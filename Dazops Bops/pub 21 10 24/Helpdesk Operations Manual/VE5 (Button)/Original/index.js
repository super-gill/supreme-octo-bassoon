const md = window.markdownit({
    html: true,
    linkify: true,
    typographer: true
}).use(window.markdownItAnchor, {
    level: [1, 2, 3, 4, 5],
    slugify: (s) => s
        .toLowerCase()
        .trim()
        .replace(/\s+#+\s*$/, '')
        .replace(/[\s]+/g, '-')
        .replace(/[^\w\-]+/g, '')
        .replace(/\-+/g, '-')
});

const navEl = document.getElementById('nav');
const viewEl = document.getElementById('view');
const metaEl = document.getElementById('meta');

const searchInput = document.getElementById('search');
const resultsEl = document.getElementById('results');
const exportBtn = document.getElementById('exportPdf');

let CURRENT_QUERY = '';
let CURRENT_POLICY = null;

function extractDocMeta(mdText) {
    const lines = mdText.split(/\r?\n/);

    // Title = first non-empty line
    const title = (lines.find(l => l.trim()) || 'Helpdesk Operations Manual').trim();

    // Version = first line like "VE.4"
    const verLine = lines.find(l => /^\s*VE\.\d+\s*$/i.test(l));
    const version = verLine ? verLine.trim().toUpperCase() : null;

    return { title, version };
}

function applyIndent(root) {
    let indent = 0;

    const children = Array.from(root.children);

    for (const el of children) {
        const tag = el.tagName.toLowerCase();

        // Reset at major headings
        if (tag === 'h1' || tag === 'h2') {
            indent = 0;
            el.removeAttribute('data-indent');
            continue;
        }

        // Set indent based on heading depth
        if (tag === 'h3') indent = 1;
        else if (tag === 'h4') indent = 2;
        else if (tag === 'h5') indent = 3;

        // Apply indent to *everything* until the next reset/change
        if (indent > 0) el.setAttribute('data-indent', String(indent));
        else el.removeAttribute('data-indent');
    }
}
function slugify(text) {
    return text
        .toLowerCase()
        .trim()
        .replace(/\s+#+\s*$/, '')
        .replace(/[\s]+/g, '-')
        .replace(/[^\w\-]+/g, '')
        .replace(/\-+/g, '-');
}

function parseManual(markdown) {
    const lines = markdown.replace(/\r\n/g, "\n").split("\n");

    let currentH1 = { id: "root", title: "Manual", policies: [] };
    const groups = [currentH1];

    let currentPolicy = null;

    const pushPolicy = () => {
        if (currentPolicy && currentPolicy.mdText.trim()) {
            currentH1.policies.push(currentPolicy);
        }
        currentPolicy = null;
    };

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];

        const h1 = /^#\s+(.+?)\s*$/.exec(line);
        const h2 = /^##\s+(.+?)\s*$/.exec(line);

        if (h1) {
            pushPolicy();

            const title = h1[1].trim();
            currentH1 = {
                id: slugify(title) || `h1-${groups.length}`,
                title,
                policies: []
            };
            groups.push(currentH1);
            continue;
        }

        if (h2) {
            pushPolicy();

            const title = h2[1].trim();
            const id = slugify(title) || `h2-${currentH1.policies.length + 1}`;

            currentPolicy = {
                id,
                title,
                h1Title: currentH1.title,
                mdText: line + "\n"
            };
            continue;
        }

        if (currentPolicy) {
            currentPolicy.mdText += line + "\n";
        }
    }

    pushPolicy();

    return groups.filter(g => g.policies.length > 0);
}

let GROUPS = [];
let POLICY_INDEX = new Map();
let ALL_POLICIES = [];

function buildIndexFromGroups() {
    POLICY_INDEX = new Map();
    ALL_POLICIES = [];

    for (const g of GROUPS) {
        for (const p of g.policies) {
            POLICY_INDEX.set(p.id, p);
            ALL_POLICIES.push(p);
        }
    }
}

async function loadManualMd() {
    const url = new URL('manual.md', document.baseURI);
    console.log('Loading manual from:', url.href, 'page:', location.href);

    const res = await fetch(url.href, { cache: 'no-store' });
    if (!res.ok) throw new Error(`Failed to load ${url.href} (${res.status} ${res.statusText})`);

    return await res.text();
}


async function init() {
    try {
        const mdText = await loadManualMd();
        const { title, version } = extractDocMeta(mdText);

        const titleEl = document.getElementById('docTitle');
        const metaEl2 = document.getElementById('docMeta');

        if (titleEl) titleEl.textContent = title;
        if (metaEl2) metaEl2.textContent = `${version ? version + ' | ' : ''}Internal Use Only`;

        document.title = title + (version ? ` — ${version}` : '');

        GROUPS = parseManual(mdText);
        buildIndexFromGroups();

        buildNav();
        onHash();
    } catch (err) {
        console.error(err);
        metaEl.textContent = 'Error loading manual.md';
        viewEl.innerHTML = `
      <h2>Couldn’t load manual.md</h2>
    `;
    }
}


function buildNav() {
    navEl.innerHTML = '';

    for (const g of GROUPS) {
        const h = document.createElement('div');
        h.className = 'nav-h1';
        h.textContent = g.title;
        navEl.appendChild(h);

        for (const p of g.policies) {
            const a = document.createElement('a');
            a.className = 'nav-h2';
            a.href = `#${p.id}`;
            a.dataset.id = p.id;
            a.textContent = p.title;

            a.addEventListener('click', (e) => {
                e.preventDefault();
                location.hash = p.id;
            });

            navEl.appendChild(a);
        }
    }
}

function setActive(id) {
    const links = navEl.querySelectorAll('.nav-h2');
    links.forEach(a => a.classList.toggle('active', a.dataset.id === id));
}

function escapeRegExp(s) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function highlightIn(container, query) {
    if (!query) return;

    const q = query.trim();
    if (!q) return;

    const re = new RegExp(escapeRegExp(q), 'gi');

    const walker = document.createTreeWalker(container, NodeFilter.SHOW_TEXT, {
        acceptNode: (node) => {
            if (!node.nodeValue || !node.nodeValue.trim()) return NodeFilter.FILTER_REJECT;
            const p = node.parentElement;
            if (!p) return NodeFilter.FILTER_REJECT;

            const tag = p.tagName;
            if (tag === 'SCRIPT' || tag === 'STYLE') return NodeFilter.FILTER_REJECT;
            if (p.closest('pre, code')) return NodeFilter.FILTER_REJECT;

            return NodeFilter.FILTER_ACCEPT;
        }
    });

    const nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);

    for (const textNode of nodes) {
        const text = textNode.nodeValue;
        if (!re.test(text)) continue;

        re.lastIndex = 0;

        const frag = document.createDocumentFragment();
        let last = 0;
        let m;

        while ((m = re.exec(text)) !== null) {
            const start = m.index;
            const end = start + m[0].length;

            if (start > last) frag.appendChild(document.createTextNode(text.slice(last, start)));

            const mark = document.createElement('mark');
            mark.textContent = text.slice(start, end);
            frag.appendChild(mark);

            last = end;
        }

        if (last < text.length) frag.appendChild(document.createTextNode(text.slice(last)));

        textNode.parentNode.replaceChild(frag, textNode);
    }
}

function renderPolicy(id) {
    const fallback = GROUPS?.[0]?.policies?.[0];
    const policy = POLICY_INDEX.get(id) || fallback;

    if (!policy) {
        metaEl.textContent = 'No H2 policies found.';
        viewEl.innerHTML = '';
        return;
    }

    viewEl.innerHTML = md.render(policy.mdText);
    applyIndent(viewEl);
    metaEl.textContent = `${policy.h1Title}  ›  ${policy.title}`;
    setActive(policy.id);

    CURRENT_POLICY = policy;

    if (CURRENT_QUERY) highlightIn(viewEl, CURRENT_QUERY);
}

function stripMarks(root) {
    root.querySelectorAll('mark').forEach(m => {
        const t = document.createTextNode(m.textContent || '');
        m.replaceWith(t);
    });
}

function waitForImages(root) {
    const imgs = Array.from(root.querySelectorAll('img'));
    const promises = imgs.map(img => {
        if (img.complete && img.naturalWidth > 0) return Promise.resolve();
        return new Promise(resolve => {
            const done = () => resolve();
            img.addEventListener('load', done, { once: true });
            img.addEventListener('error', done, { once: true });
        });
    });
    return Promise.all(promises);
}

async function exportCurrentPolicyPdf() {
    try {
        if (!CURRENT_POLICY) return;
        if (!window.html2pdf) {
            alert('PDF export library failed to load (html2pdf).');
            return;
        }

        // OPTION 1 EXPORT MODE:
        // Render the *raw markdown section* for the selected H2 into a clean, PDF-only container.
        // This decouples PDF styling from the website styling.
        const body = document.createElement('div');
        body.innerHTML = md.render(CURRENT_POLICY.mdText);
        applyIndent(body);

        // Remove the first H2 inside the policy (we add a clean header ourselves)
        const firstH2 = body.querySelector('h2');
        if (firstH2) firstH2.remove();

        // Build export wrapper
        const host = document.createElement('div');
        host.className = 'pdf-export';

        const header = document.createElement('div');
        header.className = 'pdf-header';

        const docTitle = (document.getElementById('docTitle')?.textContent || 'Helpdesk Operations Manual').trim();
        const versionMeta = (document.getElementById('docMeta')?.textContent || '').trim();

        const h = document.createElement('div');
        h.className = 'pdf-title';
        h.textContent = docTitle;

        const sub = document.createElement('p');
        sub.className = 'pdf-subtitle';
        sub.textContent = `${CURRENT_POLICY.h1Title} — ${CURRENT_POLICY.title}${versionMeta ? ` • ${versionMeta}` : ''}`;

        header.appendChild(h);
        header.appendChild(sub);
        host.appendChild(header);
        host.appendChild(body);

        // Keep it in-viewport but invisible to avoid zero-layout captures
        const staging = document.createElement('div');
        staging.style.position = 'fixed';
        staging.style.inset = '0';
        staging.style.opacity = '0';
        staging.style.pointerEvents = 'none';
        staging.style.overflow = 'auto';
        staging.style.zIndex = '-1';
        staging.appendChild(host);
        document.body.appendChild(staging);

        // Wait for fonts/images to be ready
        if (document.fonts?.ready) {
            try { await document.fonts.ready; } catch { /* ignore */ }
        }
        await waitForImages(host);

        const safeName = `${CURRENT_POLICY.title}`
            .replace(/[\\/:*?"<>|]+/g, '')
            .replace(/\s+/g, ' ')
            .trim()
            .slice(0, 120) || 'policy';

        const opt = {
            margin: [10, 10, 12, 10],
            filename: `${safeName}.pdf`,
            image: { type: 'jpeg', quality: 0.95 },
            html2canvas: {
                scale: 2,
                useCORS: true,
                allowTaint: true,
                backgroundColor: '#ffffff',
                logging: false,
            },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
            pagebreak: { mode: ['css', 'legacy'] }
        };

        await window.html2pdf().set(opt).from(host).save();
        staging.remove();
    } catch (e) {
        console.error(e);
        alert('PDF export failed. Check DevTools Console for details.');
    }
}

function onHash() {
    const id = (location.hash || '').slice(1);
    renderPolicy(id);
}

function makeSnippet(text, q, max = 140) {
    const idx = text.toLowerCase().indexOf(q.toLowerCase());
    if (idx === -1) return '';

    const start = Math.max(0, idx - Math.floor(max / 2));
    const end = Math.min(text.length, start + max);
    let snip = text.slice(start, end).replace(/\s+/g, ' ').trim();

    if (start > 0) snip = '… ' + snip;
    if (end < text.length) snip = snip + ' …';

    return snip;
}

function runSearch(raw) {
    const q = (raw || '').trim();
    CURRENT_QUERY = q;

    if (!q) {
        resultsEl.classList.remove('on');
        resultsEl.innerHTML = '';
        onHash();
        return;
    }

    const qLower = q.toLowerCase();
    const matches = [];

    for (const p of ALL_POLICIES) {
        const hay = (p.title + "\n" + p.h1Title + "\n" + p.mdText).toLowerCase();
        if (hay.includes(qLower)) {
            matches.push({
                id: p.id,
                title: p.title,
                h1Title: p.h1Title,
                snippet: makeSnippet(p.mdText, q)
            });
        }
    }

    resultsEl.classList.add('on');
    resultsEl.innerHTML = '';

    const count = document.createElement('div');
    count.className = 'count';
    count.textContent = matches.length ? `${matches.length} match(es)` : 'No matches';
    resultsEl.appendChild(count);

    for (const m of matches.slice(0, 50)) {
        const a = document.createElement('a');
        a.className = 'result';
        a.href = `#${m.id}`;
        a.addEventListener('click', (e) => {
            e.preventDefault();
            location.hash = m.id;
        });

        const strong = document.createElement('strong');
        strong.textContent = m.title;

        const small = document.createElement('small');
        small.textContent = `${m.h1Title} — ${m.snippet || 'Match found'}`;

        a.appendChild(strong);
        a.appendChild(small);
        resultsEl.appendChild(a);
    }

    onHash();
}

function debounce(fn, ms) {
    let t;
    return (...args) => {
        clearTimeout(t);
        t = setTimeout(() => fn(...args), ms);
    };
}

window.addEventListener('hashchange', onHash);

// Load markdown + build nav + render
init();

if (exportBtn) {
    exportBtn.addEventListener('click', exportCurrentPolicyPdf);
}

searchInput.addEventListener('input', debounce((e) => runSearch(e.target.value), 140));
searchInput.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        searchInput.value = '';
        runSearch('');
        searchInput.blur();
    }
});