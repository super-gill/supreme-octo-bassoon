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
    if (viewEl) viewEl.innerHTML = `<h2>Couldn’t load manual.md</h2>`;
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

  // ---- helper: load image as dataURL (so jsPDF can embed it) ----
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

    const firstH2 = body.querySelector("h2");
    if (firstH2) firstH2.remove();

    const host = document.createElement("div");
    host.className = "pdf-export";

    // IMPORTANT: do NOT include an in-content header, because it only affects page 1.
    // Rely entirely on stamped letterhead header/footer so every page is consistent.
    host.appendChild(body);

    staging = document.createElement("div");
    staging.style.position = "fixed";
    staging.style.left = "-10000px";   // off-screen
    staging.style.top = "0";
    staging.style.width = "980px";     // give it a real width (matches your app max)
    staging.style.opacity = "1";       // IMPORTANT: do not make it fully transparent
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

    // ---- Letterhead assets (from your DOTX) ----
    const letterheadLogoDataUrl = await loadAsDataUrl("letterhead_logo.png");

    // Footer text
    const footerLine1 = "digital-origin.co.uk | discover@digital-origin.co.uk | 0333 006 7787";
    const footerLine2 = "Digital Origin Solutions Limited, The Maltings, Pury Hill Business Park, Alderton Road, Towcester, NN12 7L";
    const footerLine3 = "Registered in England 04121501";

    // ---- Give the PDF content room for the repeating header/footer ----
    // [top, left, bottom, right] in mm
    // Top margin must cover the stamped logo area; bottom margin must cover footer area.
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

    // Build PDF, then stamp every page using jsPDF
    const worker = window.html2pdf().set(opt).from(host).toPdf();

    await worker.get("pdf").then((pdf) => {
      const pageCount = pdf.internal.getNumberOfPages();
      const pageWidth = pdf.internal.pageSize.getWidth();
      const pageHeight = pdf.internal.pageSize.getHeight();

      for (let i = 1; i <= pageCount; i++) {
        pdf.setPage(i);

        // --- Header (logo) ---
        const logoW = 40;           // mm
        const logoH = logoW / 4.04; // keep aspect ratio
        const headerX = 15;
        const headerY = 8;
        pdf.addImage(letterheadLogoDataUrl, "PNG", headerX, headerY, logoW, logoH);

        // --- Footer ---
        pdf.setFontSize(9);
        pdf.setTextColor(80);

        const centerX = pageWidth / 2;
        pdf.text(footerLine1, centerX, pageHeight - 13, { align: "center" });
        pdf.text(footerLine2, centerX, pageHeight - 9, { align: "center" });
        pdf.text(footerLine3, centerX, pageHeight - 5, { align: "center" });

        // optional: page numbers (right aligned)
        const pageLabel = `Page ${i} of ${pageCount}`;
        const textWidth = pdf.getTextWidth(pageLabel);
        pdf.text(pageLabel, pageWidth - 10 - textWidth, pageHeight - 5);
      }
    });

    await worker.save();

  } catch (e) {
    console.error(e);
    alert("PDF export failed. Check DevTools Console for details.");
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
    alert("html2canvas not available (required for full export).");
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

  // Your margins: [top, left, bottom, right] in mm
  const margin = [20, 10, 15, 10];
  const [mTop, mLeft, mBottom, mRight] = margin;

  // Letterhead assets
  const letterheadLogoDataUrl = await loadAsDataUrl("letterhead_logo.png");
  const footerLine1 = "digital-origin.co.uk | discover@digital-origin.co.uk | 0333 006 7787";
  const footerLine2 = "Digital Origin Solutions Limited, The Maltings, Pury Hill Business Park, Alderton Road, Towcester, NN12 7L";
  const footerLine3 = "Registered in England 04121501";

  // Create a jsPDF instance directly
  const pdf = new window.jspdf.jsPDF({ unit: "mm", format: "a4", orientation: "portrait" });
  const pageWidth = pdf.internal.pageSize.getWidth();
  const pageHeight = pdf.internal.pageSize.getHeight();

  const usableW = pageWidth - mLeft - mRight;
  const usableH = pageHeight - mTop - mBottom;

  // Offscreen staging (VISIBLE, but offscreen)
  const staging = document.createElement("div");
  staging.style.position = "fixed";
  staging.style.left = "-10000px";
  staging.style.top = "0";
  staging.style.width = "980px";
  staging.style.opacity = "1";
  staging.style.pointerEvents = "none";
  staging.style.background = "#fff";
  staging.style.zIndex = "-1";
  document.body.appendChild(staging);

  // Helper: add a canvas to the PDF, slicing across pages if it's taller than usableH
  function addCanvasWithPaging(canvas) {
    // Scale to fit width
    const imgWmm = usableW;
    const imgHmm = (canvas.height * imgWmm) / canvas.width;

    if (imgHmm <= usableH) {
      const imgData = canvas.toDataURL("image/jpeg", 0.95);
      pdf.addImage(imgData, "JPEG", mLeft, mTop, imgWmm, imgHmm);
      return;
    }

    // Need to slice canvas into page-sized chunks
    const pxPerMm = canvas.width / imgWmm;           // pixels per mm at this scale
    const sliceHPx = Math.floor(usableH * pxPerMm);  // pixels that fit one page height

    let y = 0;
    while (y < canvas.height) {
      const slice = document.createElement("canvas");
      slice.width = canvas.width;
      slice.height = Math.min(sliceHPx, canvas.height - y);

      const ctx = slice.getContext("2d");
      ctx.drawImage(
        canvas,
        0, y, canvas.width, slice.height,  // src
        0, 0, slice.width, slice.height    // dst
      );

      const sliceData = slice.toDataURL("image/jpeg", 0.95);
      const sliceHmm = (slice.height * imgWmm) / slice.width;

      pdf.addImage(sliceData, "JPEG", mLeft, mTop, imgWmm, sliceHmm);
      y += slice.height;

      if (y < canvas.height) pdf.addPage();
    }
  }

  // Build the PDF content policy-by-policy
  let firstContent = true;

  try {
    // Make a simple title page block (optional; remove if you don't want it)
    const docTitle = (document.getElementById("docTitle")?.textContent || "Helpdesk Operations Manual").trim();
    const versionMeta = (document.getElementById("docMeta")?.textContent || "").trim();

    const cover = document.createElement("div");
    cover.className = "pdf-export";
    cover.innerHTML = `
      <h1 style="margin:0 0 8px 0;">${docTitle}</h1>
      <p style="margin:0 0 16px 0;">${versionMeta}</p>
      <p style="margin:0;">Full manual export</p>
    `;
    staging.appendChild(cover);

    const coverCanvas = await window.html2canvas(cover, {
      scale: 2,
      useCORS: true,
      allowTaint: false,
      backgroundColor: "#ffffff"
    });

    addCanvasWithPaging(coverCanvas);
    staging.removeChild(cover);
    pdf.addPage();
    firstContent = false;

    for (const g of GROUPS) {
      // Group heading page block (optional but helps readability)
      const groupBlock = document.createElement("div");
      groupBlock.className = "pdf-export";
      groupBlock.innerHTML = `<h1>${g.title}</h1>`;
      staging.appendChild(groupBlock);

      const groupCanvas = await window.html2canvas(groupBlock, {
        scale: 2,
        useCORS: true,
        allowTaint: false,
        backgroundColor: "#ffffff"
      });

      addCanvasWithPaging(groupCanvas);
      staging.removeChild(groupBlock);
      pdf.addPage();

      for (const p of g.policies) {
        const block = document.createElement("div");
        block.className = "pdf-export";

        // Render the policy markdown
        block.innerHTML = md.render(p.mdText);
        applyIndent(block);

        staging.appendChild(block);
        await waitForImages(block);

        const canvas = await window.html2canvas(block, {
          scale: 2,
          useCORS: true,
          allowTaint: false,
          backgroundColor: "#ffffff"
        });

        addCanvasWithPaging(canvas);
        staging.removeChild(block);

        // Add a page break between policies (but not after the last one)
        pdf.addPage();
      }
    }

    // If we added an extra blank page at the end, remove it
    const totalPagesBeforeStamp = pdf.internal.getNumberOfPages();
    // If last page is empty, it's hard to detect perfectly; simplest: keep it if you don't mind.
    // If you DO mind, comment out the pdf.addPage() after each policy and add it conditionally.

    // Stamp header/footer on every page
    const pageCount = pdf.internal.getNumberOfPages();
    for (let i = 1; i <= pageCount; i++) {
      pdf.setPage(i);

      // Header logo
      const logoW = 40;
      const logoH = logoW / 4.04;
      pdf.addImage(letterheadLogoDataUrl, "PNG", 15, 8, logoW, logoH);

      // Footer (centered)
      pdf.setFontSize(9);
      pdf.setTextColor(80);
      const centerX = pageWidth / 2;
      pdf.text(footerLine1, centerX, pageHeight - 13, { align: "center" });
      pdf.text(footerLine2, centerX, pageHeight - 9,  { align: "center" });
      pdf.text(footerLine3, centerX, pageHeight - 5,  { align: "center" });
    }

    // Filename
    const safeName = `${docTitle}${versionMeta ? " - " + versionMeta : ""}`
      .replace(/[\\/:*?"<>|]+/g, "")
      .replace(/\s+/g, " ")
      .trim()
      .slice(0, 140) || "manual";

    pdf.save(`${safeName}.pdf`);

  } catch (e) {
    console.error(e);
    alert("Full manual export failed. Check DevTools Console for details.");
  } finally {
    staging.remove();
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

// Null-guard (suggestion #5)
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