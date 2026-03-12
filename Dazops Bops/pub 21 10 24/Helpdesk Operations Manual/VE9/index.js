// ---------- Markdown renderer + anchors (single slugify) ----------
const slugify = (s) => s
  .toLowerCase()
  .trim()
  .replace(/\s+#+\s*$/, "")
  .replace(/\s+/g, "-")
  .replace(/[^\w-]+/g, "")
  .replace(/-+/g, "-");

const md = window.markdownit({
  html: true,
  linkify: true,
  typographer: true
}).use(window.markdownItAnchor, {
  level: [1, 2, 3, 4, 5],
  slugify
});

// ---------- DOM refs ----------
const navEl = document.getElementById("nav");
const viewEl = document.getElementById("view");
const metaEl = document.getElementById("meta");

const searchInput = document.getElementById("search");
const resultsEl = document.getElementById("results");
const exportBtn = document.getElementById("exportPdf");

const exportManualBtn = document.getElementById("exportManualPdf");
if (exportManualBtn) {
  exportManualBtn.addEventListener("click", exportFullManualPdf);
}

// ---------- state ----------
let CURRENT_QUERY = "";
let CURRENT_POLICY = null;

// ---------- helpers ----------
function extractDocMeta(mdText) {
  const lines = mdText.split(/\r?\n/);

  const title = (lines.find((l) => l.trim()) || "Helpdesk Operations Manual").trim();

  const verLine = lines.find((l) => /^\s*VE\.\d+\s*$/i.test(l));
  const version = verLine ? verLine.trim().toUpperCase() : null;

  return { title, version };
}

// More explicit indent handling; includes h6, preserves "content inherits last heading indent"
function applyIndent(root) {
  let current = 0;

  for (const el of Array.from(root.children)) {
    const tag = el.tagName.toLowerCase();

    if (tag === "h1" || tag === "h2") {
      current = 0;
      el.removeAttribute("data-indent");
      continue;
    }

    if (tag === "h3") current = 1;
    else if (tag === "h4") current = 2;
    else if (tag === "h5" || tag === "h6") current = 3;

    if (current > 0) el.setAttribute("data-indent", String(current));
    else el.removeAttribute("data-indent");
  }
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

      // Prevent collisions by namespacing with H1 title, and ensure uniqueness if repeated
      const base = slugify(`${currentH1.title} ${title}`) || `h2-${groups.length}-${currentH1.policies.length + 1}`;
      let id = base;
      let n = 2;
      while (POLICY_INDEX?.has?.(id)) {
        id = `${base}-${n++}`;
      }

      currentPolicy = {
        id,
        title,
        h1Title: currentH1.title,
        mdText: line + "\n"
      };
      continue;
    }

    if (currentPolicy) currentPolicy.mdText += line + "\n";
  }

  pushPolicy();
  return groups.filter((g) => g.policies.length > 0);
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
  const url = new URL("manual.md", document.baseURI);
  console.log("Loading manual from:", url.href, "page:", location.href);

  const res = await fetch(url.href, { cache: "no-store" });
  if (!res.ok) throw new Error(`Failed to load ${url.href} (${res.status} ${res.statusText})`);
  return await res.text();
}

async function init() {
  try {
    const mdText = await loadManualMd();
    const { title, version } = extractDocMeta(mdText);

    const titleEl = document.getElementById("docTitle");
    const metaEl2 = document.getElementById("docMeta");

    if (titleEl) titleEl.textContent = title;
    if (metaEl2) metaEl2.textContent = `${version ? version + " | " : ""}Internal Use Only`;

    document.title = title + (version ? ` — ${version}` : "");

    // Important: parseManual now may reference POLICY_INDEX for uniqueness checks,
    // so initialize it first.
    POLICY_INDEX = new Map();

    GROUPS = parseManual(mdText);
    buildIndexFromGroups();

    buildNav();
    onHash();
  } catch (err) {
    console.error(err);
    if (metaEl) metaEl.textContent = "Error loading manual.md";
    if (viewEl) viewEl.innerHTML = `<h2>Couldn't load manual.md</h2>`;
  }
}

function buildNav() {
  if (!navEl) return;
  navEl.innerHTML = "";

  for (const g of GROUPS) {
    const h = document.createElement("div");
    h.className = "nav-h1";
    h.textContent = g.title;
    navEl.appendChild(h);

    for (const p of g.policies) {
      const a = document.createElement("a");
      a.className = "nav-h2";
      a.href = `#${p.id}`;
      a.dataset.id = p.id;
      a.textContent = p.title;

      a.addEventListener("click", (e) => {
        e.preventDefault();
        location.hash = p.id;
      });

      navEl.appendChild(a);
    }
  }
}

function setActive(id) {
  if (!navEl) return;
  const links = navEl.querySelectorAll(".nav-h2");
  links.forEach((a) => a.classList.toggle("active", a.dataset.id === id));
}

function escapeRegExp(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function highlightIn(container, query) {
  if (!container || !query) return;
  const q = query.trim();
  if (!q) return;

  const re = new RegExp(escapeRegExp(q), "gi");

  const walker = document.createTreeWalker(container, NodeFilter.SHOW_TEXT, {
    acceptNode: (node) => {
      if (!node.nodeValue || !node.nodeValue.trim()) return NodeFilter.FILTER_REJECT;
      const p = node.parentElement;
      if (!p) return NodeFilter.FILTER_REJECT;

      const tag = p.tagName;
      if (tag === "SCRIPT" || tag === "STYLE") return NodeFilter.FILTER_REJECT;
      if (p.closest("pre, code")) return NodeFilter.FILTER_REJECT;

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

      const mark = document.createElement("mark");
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
    if (metaEl) metaEl.textContent = "No H2 policies found.";
    if (viewEl) viewEl.innerHTML = "";
    return;
  }

  if (viewEl) {
    viewEl.innerHTML = md.render(policy.mdText);
    applyIndent(viewEl);
  }

  if (metaEl) metaEl.textContent = `${policy.h1Title}  ›  ${policy.title}`;
  setActive(policy.id);

  CURRENT_POLICY = policy;

  if (CURRENT_QUERY && viewEl) highlightIn(viewEl, CURRENT_QUERY);
}

function waitForImages(root) {
  const imgs = Array.from(root.querySelectorAll("img"));
  const promises = imgs.map((img) => {
    if (img.complete && img.naturalWidth > 0) return Promise.resolve();
    return new Promise((resolve) => {
      const done = () => resolve();
      img.addEventListener("load", done, { once: true });
      img.addEventListener("error", done, { once: true });
    });
  });
  return Promise.all(promises);
}

async function exportCurrentPolicyPdf() {
  if (!CURRENT_POLICY) return;

  if (!window.html2pdf) {
    alert("PDF export library failed to load (html2pdf).");
    return;
  }

  async function loadAsDataUrl(url) {
    const res = await fetch(url, { cache: "no-store" });
    if (!res.ok) throw new Error(`Failed to load ${url}: ${res.status}`);
    const blob = await res.blob();
    return await new Promise((resolve, reject) => {
      const r = new FileReader();
      r.onload = () => resolve(r.result);
      r.onerror = reject;
      r.readAsDataURL(blob);
    });
  }

  let staging;

  try {
    const body = document.createElement("div");
    body.innerHTML = md.render(CURRENT_POLICY.mdText);
    applyIndent(body);

    // Keep the H2 title so it appears at the top of the exported PDF

    const host = document.createElement("div");
    host.className = "pdf-export";
    host.appendChild(body);

    staging = document.createElement("div");
    staging.style.position = "fixed";
    staging.style.left = "-10000px";
    staging.style.top = "0";
    staging.style.width = "980px";
    staging.style.opacity = "1";
    staging.style.pointerEvents = "none";
    staging.style.background = "#fff";
    staging.style.zIndex = "-1";
    staging.appendChild(host);
    document.body.appendChild(staging);

    if (document.fonts?.ready) {
      try { await document.fonts.ready; } catch { /* ignore */ }
    }
    await waitForImages(host);

    const safeName = `${CURRENT_POLICY.title}`
      .replace(/[\\/:*?"<>|]+/g, "")
      .replace(/\s+/g, " ")
      .trim()
      .slice(0, 120) || "policy";

    const letterheadLogoDataUrl = await loadAsDataUrl("letterhead_logo.png");

    const footerLine1 = "digital-origin.co.uk | discover@digital-origin.co.uk | 0333 006 7787";
    const footerLine2 = "Digital Origin Solutions Limited, The Maltings, Pury Hill Business Park, Alderton Road, Towcester, NN12 7L";
    const footerLine3 = "Registered in England 04121501";

    const opt = {
      margin: [20, 10, 15, 10],
      filename: `${safeName}.pdf`,
      image: { type: "jpeg", quality: 0.95 },
      html2canvas: {
        scale: 2,
        useCORS: true,
        allowTaint: false,
        backgroundColor: "#ffffff",
        logging: false
      },
      jsPDF: { unit: "mm", format: "a4", orientation: "portrait" },
      pagebreak: {
        mode: ["avoid-all", "css", "legacy"],
        avoid: ["p", "li", "h1", "h2", "h3", "h4", "table", "blockquote", "pre"]
      }
    };

    const worker = window.html2pdf().set(opt).from(host).toPdf();

    await worker.get("pdf").then((pdf) => {
      const pageCount = pdf.internal.getNumberOfPages();
      const pageWidth = pdf.internal.pageSize.getWidth();
      const pageHeight = pdf.internal.pageSize.getHeight();

      for (let i = 1; i <= pageCount; i++) {
        pdf.setPage(i);

        const logoW = 40;
        const logoH = logoW / 4.04;
        const headerX = 15;
        const headerY = 8;
        pdf.addImage(letterheadLogoDataUrl, "PNG", headerX, headerY, logoW, logoH);

        pdf.setFontSize(9);
        pdf.setTextColor(80);

        const centerX = pageWidth / 2;
        pdf.text(footerLine1, centerX, pageHeight - 13, { align: "center" });
        pdf.text(footerLine2, centerX, pageHeight - 9, { align: "center" });
        pdf.text(footerLine3, centerX, pageHeight - 5, { align: "center" });

        const pageLabel = `Page ${i} of ${pageCount}`;
        const textWidth = pdf.getTextWidth(pageLabel);
        pdf.text(pageLabel, pageWidth - 10 - textWidth, pageHeight - 5);
      }
    });

    await worker.save();

  } catch (e) {
    console.error(e);
    alert(String(e));
  } finally {
    staging?.remove();
  }
}

async function exportFullManualPdf() {
  if (!window.html2pdf) {
    alert("PDF export library failed to load (html2pdf).");
    return;
  }
  if (!GROUPS?.length) {
    alert("Manual not loaded yet.");
    return;
  }
  if (!window.html2canvas) {
    alert("html2canvas not available.");
    return;
  }

  async function loadAsDataUrl(url) {
    const res = await fetch(url, { cache: "no-store" });
    if (!res.ok) throw new Error(`Failed to load ${url}: ${res.status}`);
    const blob = await res.blob();
    return await new Promise((resolve, reject) => {
      const r = new FileReader();
      r.onload = () => resolve(r.result);
      r.onerror = reject;
      r.readAsDataURL(blob);
    });
  }

  // A4 dimensions and margins (mm)
  const pageW = 210, pageH = 297;
  const mTop = 20, mLeft = 10, mBottom = 15, mRight = 10;
  const usableW = pageW - mLeft - mRight; // 190mm
  const usableH = pageH - mTop - mBottom; // 262mm
  const renderWidthPx = 980; // matches staging div width

  let staging;

  try {
    const letterheadLogoDataUrl = await loadAsDataUrl("letterhead_logo.png");
    const footerLine1 = "digital-origin.co.uk | discover@digital-origin.co.uk | 0333 006 7787";
    const footerLine2 = "Digital Origin Solutions Limited, The Maltings, Pury Hill Business Park, Alderton Road, Towcester, NN12 7L";
    const footerLine3 = "Registered in England 04121501";

    const docTitle = (document.getElementById("docTitle")?.textContent || "Helpdesk Operations Manual").trim();
    const versionMeta = (document.getElementById("docMeta")?.textContent || "").trim();

    // Bootstrap pdf instance from html2pdf (which bundles jsPDF internally)
    // so we don't need a separate window.jspdf script tag
    let pdf = null;
    let firstPage = true;

    staging = document.createElement("div");
    staging.style.cssText = "position:fixed;left:-10000px;top:0;width:980px;opacity:1;pointer-events:none;background:#fff;z-index:-1;";
    document.body.appendChild(staging);

    if (document.fonts?.ready) {
      try { await document.fonts.ready; } catch {}
    }

    // Dummy render to extract the bundled jsPDF instance from html2pdf
    const _bootstrapEl = document.createElement("div");
    _bootstrapEl.style.cssText = "width:1px;height:1px;overflow:hidden;";
    staging.appendChild(_bootstrapEl);
    await window.html2pdf()
      .set({ margin: [20,10,15,10], jsPDF: { unit: "mm", format: "a4", orientation: "portrait" }, html2canvas: { scale:1, backgroundColor:"#ffffff" } })
      .from(_bootstrapEl).toPdf()
      .get("pdf").then(p => { pdf = p; });
    staging.removeChild(_bootstrapEl);

    // Renders an element to canvas, slices it into A4-height pages, adds to master PDF
    async function addElementToPdf(el) {
      staging.appendChild(el);
      await waitForImages(el);

      const canvas = await window.html2canvas(el, {
        scale: 2,
        useCORS: true,
        allowTaint: false,
        backgroundColor: "#ffffff",
        logging: false
      });

      staging.removeChild(el);

      if (canvas.width === 0 || canvas.height === 0) return;

      // How many canvas px fit in one usable page height, given the canvas width
      const pxPerMm = canvas.width / usableW;
      const sliceHeightPx = Math.floor(usableH * pxPerMm);

      let y = 0;
      while (y < canvas.height) {
        const sliceH = Math.min(sliceHeightPx, canvas.height - y);

        const slice = document.createElement("canvas");
        slice.width = canvas.width;
        slice.height = sliceH;
        slice.getContext("2d").drawImage(
          canvas,
          0, y, canvas.width, sliceH,
          0, 0, canvas.width, sliceH
        );

        const imgData = slice.toDataURL("image/jpeg", 0.95);
        const sliceHmm = (sliceH / canvas.width) * usableW;

        if (!firstPage) pdf.addPage();
        pdf.addImage(imgData, "JPEG", mLeft, mTop, usableW, sliceHmm);
        firstPage = false;

        y += sliceH;
      }
    }

    // Cover page
    const cover = document.createElement("div");
    cover.className = "pdf-export";
    cover.innerHTML = `<h1 style="margin:0 0 8px 0;">${docTitle}</h1><p style="margin:0;">${versionMeta}</p>`;
    await addElementToPdf(cover);

    // Groups and policies
    for (const g of GROUPS) {
      const groupBlock = document.createElement("div");
      groupBlock.className = "pdf-export";
      groupBlock.innerHTML = `<h1>${g.title}</h1>`;
      await addElementToPdf(groupBlock);

      for (const p of g.policies) {
        const block = document.createElement("div");
        block.className = "pdf-export";
        block.innerHTML = md.render(p.mdText);
        applyIndent(block);
        await addElementToPdf(block);
      }
    }

    // Stamp header + footer on every page
    const pageCount = pdf.internal.getNumberOfPages();
    for (let i = 1; i <= pageCount; i++) {
      pdf.setPage(i);

      const logoW = 40;
      const logoH = logoW / 4.04;
      pdf.addImage(letterheadLogoDataUrl, "PNG", 15, 8, logoW, logoH);

      pdf.setFontSize(9);
      pdf.setTextColor(80);
      const cx = pageW / 2;
      pdf.text(footerLine1, cx, pageH - 13, { align: "center" });
      pdf.text(footerLine2, cx, pageH - 9,  { align: "center" });
      pdf.text(footerLine3, cx, pageH - 5,  { align: "center" });

      const label = `Page ${i} of ${pageCount}`;
      pdf.text(label, pageW - mRight - pdf.getTextWidth(label), pageH - 5);
    }

    const safeName = `${docTitle}${versionMeta ? " - " + versionMeta : ""}`
      .replace(/[\\/:*?"<>|]+/g, "").replace(/\s+/g, " ").trim().slice(0, 140) || "manual";

    pdf.save(`${safeName}.pdf`);

  } catch (e) {
    console.error(e);
    alert(String(e));
  } finally {
    staging?.remove();
  }
}


function onHash() {
  const id = (location.hash || "").slice(1);
  renderPolicy(id);
}

function makeSnippet(text, q, max = 140) {
  const idx = text.toLowerCase().indexOf(q.toLowerCase());
  if (idx === -1) return "";

  const start = Math.max(0, idx - Math.floor(max / 2));
  const end = Math.min(text.length, start + max);
  let snip = text.slice(start, end).replace(/\s+/g, " ").trim();

  if (start > 0) snip = "… " + snip;
  if (end < text.length) snip = snip + " …";

  return snip;
}

function runSearch(raw) {
  const q = (raw || "").trim();
  CURRENT_QUERY = q;

  if (!q) {
    resultsEl?.classList.remove("on");
    if (resultsEl) resultsEl.innerHTML = "";
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

  resultsEl?.classList.add("on");
  if (!resultsEl) return;

  resultsEl.innerHTML = "";

  const count = document.createElement("div");
  count.className = "count";
  count.textContent = matches.length ? `${matches.length} match(es)` : "No matches";
  resultsEl.appendChild(count);

  for (const m of matches.slice(0, 50)) {
    const a = document.createElement("a");
    a.className = "result";
    a.href = `#${m.id}`;
    a.addEventListener("click", (e) => {
      e.preventDefault();
      location.hash = m.id;
    });

    const strong = document.createElement("strong");
    strong.textContent = m.title;

    const small = document.createElement("small");
    small.textContent = `${m.h1Title} — ${m.snippet || "Match found"}`;

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

// ---------- events ----------
window.addEventListener("hashchange", onHash);

init();

if (exportBtn) {
  exportBtn.addEventListener("click", exportCurrentPolicyPdf);
}

if (searchInput) {
  searchInput.addEventListener("input", debounce((e) => runSearch(e.target.value), 140));
  searchInput.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      searchInput.value = "";
      runSearch("");
      searchInput.blur();
    }
  });
}