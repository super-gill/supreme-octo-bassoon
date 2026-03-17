// ==========================================================================
// MARKDOWN RENDERER SETUP
// Configures markdown-it with anchor plugin for heading IDs.
// A shared slugify function is used for both anchor generation and
// internal policy ID creation to ensure consistent deep-linking.
// ==========================================================================

/**
 * Converts a heading string into a URL-safe slug.
 * Used by both markdown-it-anchor (for rendered heading IDs) and
 * the manual parser (for policy navigation IDs).
 */
const slugify = (s) => s
  .toLowerCase()
  .trim()
  .replace(/\s+#+\s*$/, "")   // Strip trailing markdown heading markers
  .replace(/\s+/g, "-")       // Spaces to hyphens
  .replace(/[^\w-]+/g, "")    // Remove non-word characters
  .replace(/-+/g, "-");       // Collapse consecutive hyphens

/** Markdown-it instance with HTML passthrough, auto-linking, and smart quotes */
const md = window.markdownit({
  html: true,
  linkify: true,
  typographer: true
}).use(window.markdownItAnchor, {
  level: [1, 2, 3, 4, 5],     // Generate anchors for H1 through H5
  slugify
});

// ==========================================================================
// DOM REFERENCES
// Cached references to key elements used throughout the app.
// ==========================================================================

const navEl = document.getElementById("nav");           // Sidebar navigation container
const viewEl = document.getElementById("view");         // Main content article
const metaEl = document.getElementById("meta");         // Breadcrumb text (H1 > H2)

const searchInput = document.getElementById("search");  // Search input field
const resultsEl = document.getElementById("results");   // Search results container
const exportBtn = document.getElementById("exportPdf"); // Single-policy PDF export button
const bookPicker = document.getElementById("bookPicker"); // Book selector dropdown
const platformVersionEl = document.getElementById("platformVersion"); // Sidebar footer version label
const themeToggleBtn = document.getElementById("themeToggle");       // Theme toggle button
const backToTopBtn = document.getElementById("backToTop");           // Back to top button
const mainEl = document.querySelector("main");                       // Main scrollable pane

// Bind the full-manual export button if it exists
const exportManualBtn = document.getElementById("exportManualPdf");
if (exportManualBtn) {
  exportManualBtn.addEventListener("click", exportFullManualPdf);
}

// ==========================================================================
// APPLICATION STATE
// ==========================================================================

/** Platform version (semantic versioning). Updated when the viewer code changes.
 *  v1.0.0 - VE.3:  Baseline single-file app (nav, search, hash routing)
 *  v1.1.0 - VE.4:  File separation (HTML/JS/CSS), dynamic metadata, indent system
 *  v1.2.0 - VE.6:  Single-policy PDF export, collision-proof IDs, meta-bar
 *  v1.3.0 - VE.7:  Full-manual PDF export, company letterhead/footer, SVG favicon
 *  v1.3.1 - VE.8:  Export rewrite (jsPDF bootstrap), H2 title retained in PDF
 *  v1.4.0 - VE.11: Multi-book selector (books.json), comprehensive code docs
 *  v1.5.0 - VE.11: Collapsible nav, back-to-top, keyboard nav, theme toggle,
 *                   in-policy ToC, copy link icon, broken hash fallback
 */
const PLATFORM_VERSION = "v1.5.0";

let CURRENT_QUERY = "";       // Active search query (empty = no search)
let CURRENT_POLICY = null;    // Currently rendered policy object
let CURRENT_BOOK = "manual.md"; // Filename of the currently loaded book
let BOOKS = [];               // Array of { file, title } from books.json

// ==========================================================================
// HELPERS
// ==========================================================================

/**
 * Extracts the document title (first non-empty line) and version string
 * (e.g. "VE.11") from the raw markdown text. Used to update the page
 * title and sidebar branding when a book is loaded.
 */
function extractDocMeta(mdText) {
  const lines = mdText.split(/\r?\n/);

  // Title is the first non-empty line of the markdown
  const title = (lines.find((l) => l.trim()) || "Helpdesk Operations Manual").trim();

  // Version is a standalone line matching "VE.XX"
  const verLine = lines.find((l) => /^\s*VE\.\d+\s*$/i.test(l));
  const version = verLine ? verLine.trim().toUpperCase() : null;

  return { title, version };
}

/**
 * Applies visual indentation to elements based on their heading hierarchy.
 * H1/H2 content sits at the left margin; H3 = indent 1, H4 = indent 2,
 * H5/H6 = indent 3. Non-heading elements inherit the indent of their
 * preceding heading, creating a nested visual structure in the rendered doc.
 */
function applyIndent(root) {
  let current = 0; // Current indent level

  for (const el of Array.from(root.children)) {
    const tag = el.tagName.toLowerCase();

    // H1 and H2 reset to no indent (top-level sections)
    if (tag === "h1" || tag === "h2") {
      current = 0;
      el.removeAttribute("data-indent");
      continue;
    }

    // Sub-headings set the indent level for themselves and following content
    if (tag === "h3") current = 1;
    else if (tag === "h4") current = 2;
    else if (tag === "h5" || tag === "h6") current = 3;

    if (current > 0) el.setAttribute("data-indent", String(current));
    else el.removeAttribute("data-indent");
  }
}

// ==========================================================================
// MANUAL PARSER
// Splits raw markdown into a structured hierarchy:
//   GROUPS[] -> each group is an H1 section
//     .policies[] -> each policy is an H2 section with its full markdown body
// ==========================================================================

/**
 * Parses the full markdown text of a manual into groups (H1 sections)
 * containing policies (H2 sections). Each policy stores its raw markdown
 * text for on-demand rendering when selected in the nav.
 *
 * Returns an array of group objects:
 *   { id, title, policies: [{ id, title, h1Title, mdText }] }
 */
function parseManual(markdown) {
  const lines = markdown.replace(/\r\n/g, "\n").split("\n");

  // Root group catches any content before the first H1
  let currentH1 = { id: "root", title: "Manual", policies: [] };
  const groups = [currentH1];

  let currentPolicy = null;

  // Flush the current policy into its parent H1 group
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
      // New H1 section: flush current policy and start a new group
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
      // New H2 policy: flush previous and start a new policy
      pushPolicy();

      const title = h2[1].trim();

      // Namespace the ID with the parent H1 title to avoid collisions
      // (e.g. two different H1s could each have an "Overview" H2)
      const base = slugify(`${currentH1.title} ${title}`) || `h2-${groups.length}-${currentH1.policies.length + 1}`;
      let id = base;
      let n = 2;
      // Ensure uniqueness if the same slug appears multiple times
      while (POLICY_INDEX?.has?.(id)) {
        id = `${base}-${n++}`;
      }

      currentPolicy = {
        id,
        title,
        h1Title: currentH1.title,
        mdText: line + "\n"     // Include the H2 line itself in the policy body
      };
      continue;
    }

    // Accumulate body lines into the current policy
    if (currentPolicy) currentPolicy.mdText += line + "\n";
  }

  pushPolicy(); // Flush the last policy
  return groups.filter((g) => g.policies.length > 0); // Drop empty groups
}

// ==========================================================================
// INDEXES
// Flat lookup structures built after parsing for fast policy access.
// ==========================================================================

let GROUPS = [];              // Parsed H1 groups with nested policies
let POLICY_INDEX = new Map(); // Map<policyId, policyObject> for O(1) lookup
let ALL_POLICIES = [];        // Flat array of all policies for search

/**
 * Rebuilds the flat index and lookup map from the current GROUPS array.
 * Called after parsing a new book.
 */
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

// ==========================================================================
// BOOK LOADING
// Fetches markdown files and the books.json manifest.
// ==========================================================================

/**
 * Fetches a markdown file relative to the current page URL.
 * Uses cache-busting to ensure the latest version is always loaded.
 */
async function loadManualMd(filename) {
  const file = filename || CURRENT_BOOK;
  const url = new URL(file, document.baseURI);
  console.log("Loading book from:", url.href, "page:", location.href);

  const res = await fetch(url.href, { cache: "no-store" });
  if (!res.ok) throw new Error(`Failed to load ${url.href} (${res.status} ${res.statusText})`);
  return await res.text();
}

/**
 * Loads the books.json manifest and populates the book picker dropdown.
 * If books.json is missing or fails, falls back to a single manual.md entry.
 * Attaches a change listener so selecting a different book triggers a reload.
 */
async function loadBooks() {
  try {
    const url = new URL("books.json", document.baseURI);
    const res = await fetch(url.href, { cache: "no-store" });
    if (!res.ok) throw new Error(`Failed to load books.json (${res.status})`);
    BOOKS = await res.json();
  } catch (e) {
    console.warn("Could not load books.json, defaulting to manual.md:", e);
    BOOKS = [{ file: "manual.md", title: "Helpdesk Operations Manual" }];
  }

  // Populate the dropdown with available books
  if (bookPicker) {
    bookPicker.innerHTML = "";
    for (const book of BOOKS) {
      const opt = document.createElement("option");
      opt.value = book.file;
      opt.textContent = book.title;
      bookPicker.appendChild(opt);
    }
    bookPicker.value = CURRENT_BOOK;

    // Switch books when the user selects a different option
    bookPicker.addEventListener("change", async () => {
      CURRENT_BOOK = bookPicker.value;
      location.hash = "";        // Clear any existing policy hash
      await loadBook(CURRENT_BOOK);
    });
  }
}

/**
 * Loads and renders a specific book file. Parses the markdown, updates
 * the page title and sidebar branding, rebuilds navigation, and renders
 * the policy indicated by the current URL hash (or the first policy).
 */
async function loadBook(filename) {
  try {
    const mdText = await loadManualMd(filename);
    const { title, version } = extractDocMeta(mdText);

    // Update sidebar branding with book title and version
    const titleEl = document.getElementById("docTitle");
    const metaEl2 = document.getElementById("docMeta");

    if (titleEl) titleEl.textContent = title;
    if (metaEl2) metaEl2.textContent = `${version ? version + " | " : ""}Internal Use Only`;

    // Update browser tab title
    document.title = title + (version ? ` — ${version}` : "");

    // Parse the markdown and rebuild all indexes and navigation
    POLICY_INDEX = new Map();
    GROUPS = parseManual(mdText);
    buildIndexFromGroups();
    buildNav();
    onHash(); // Render the policy from the current URL hash
  } catch (err) {
    console.error(err);
    if (metaEl) metaEl.textContent = `Error loading ${filename}`;
    if (viewEl) viewEl.innerHTML = `<h2>Couldn't load ${filename}</h2>`;
  }
}

/**
 * Application entry point. Loads the book manifest, then loads and
 * renders the default book.
 */
async function init() {
  // Display the platform version in the sidebar footer
  if (platformVersionEl) platformVersionEl.textContent = `Platform ${PLATFORM_VERSION}`;

  await loadBooks();
  await loadBook(CURRENT_BOOK);
}

// ==========================================================================
// SIDEBAR NAVIGATION
// Builds the H1/H2 nav tree and manages the active state highlight.
// ==========================================================================

/**
 * Builds the sidebar navigation from the parsed GROUPS structure.
 * Creates collapsible H1 section headers with child H2 policy links
 * wrapped in a toggle-able container. Clicking an H1 expands/collapses
 * its group; clicking an H2 navigates to that policy.
 */
function buildNav() {
  if (!navEl) return;
  navEl.innerHTML = "";

  for (const g of GROUPS) {
    // H1 section header (clickable to toggle)
    const h = document.createElement("div");
    h.className = "nav-h1";
    h.textContent = g.title;
    navEl.appendChild(h);

    // Container for H2 links within this group
    const group = document.createElement("div");
    group.className = "nav-group";
    navEl.appendChild(group);

    // H2 policy links within this section
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

      group.appendChild(a);
    }

    // Collapse/expand toggle on H1 click
    h.addEventListener("click", () => {
      const isCollapsed = h.classList.toggle("collapsed");
      if (isCollapsed) {
        group.style.maxHeight = "0";
        group.classList.add("collapsed");
      } else {
        group.classList.remove("collapsed");
        group.style.maxHeight = group.scrollHeight + "px";
      }
    });

    // Start expanded: set max-height to natural height after layout
    requestAnimationFrame(() => {
      group.style.maxHeight = group.scrollHeight + "px";
    });
  }
}

/**
 * Toggles the "active" class on the nav link matching the given policy ID.
 * Also expands the parent nav group if it is currently collapsed.
 */
function setActive(id) {
  if (!navEl) return;
  const links = navEl.querySelectorAll(".nav-h2");
  links.forEach((a) => {
    const isActive = a.dataset.id === id;
    a.classList.toggle("active", isActive);

    // Expand collapsed parent group when navigating to a policy
    if (isActive) {
      const group = a.closest(".nav-group");
      if (group && group.classList.contains("collapsed")) {
        group.classList.remove("collapsed");
        group.style.maxHeight = group.scrollHeight + "px";
        const h1 = group.previousElementSibling;
        if (h1) h1.classList.remove("collapsed");
      }
    }
  });
}

// ==========================================================================
// SEARCH HIGHLIGHTING
// Wraps matching text in <mark> elements within the rendered document.
// ==========================================================================

/** Escapes special regex characters in a string for safe use in new RegExp() */
function escapeRegExp(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

/**
 * Walks all text nodes within a container and wraps substrings matching
 * the query in <mark> elements. Skips script, style, pre, and code blocks.
 */
function highlightIn(container, query) {
  if (!container || !query) return;
  const q = query.trim();
  if (!q) return;

  const re = new RegExp(escapeRegExp(q), "gi");

  // Collect all eligible text nodes using a TreeWalker
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

  // Replace matching substrings with <mark> wrapped fragments
  for (const textNode of nodes) {
    const text = textNode.nodeValue;
    if (!re.test(text)) continue;

    re.lastIndex = 0; // Reset regex state after .test()

    const frag = document.createDocumentFragment();
    let last = 0;
    let m;

    while ((m = re.exec(text)) !== null) {
      const start = m.index;
      const end = start + m[0].length;

      // Text before the match
      if (start > last) frag.appendChild(document.createTextNode(text.slice(last, start)));

      // The matched text wrapped in <mark>
      const mark = document.createElement("mark");
      mark.textContent = text.slice(start, end);
      frag.appendChild(mark);

      last = end;
    }

    // Remaining text after the last match
    if (last < text.length) frag.appendChild(document.createTextNode(text.slice(last)));

    textNode.parentNode.replaceChild(frag, textNode);
  }
}

// ==========================================================================
// POLICY RENDERING
// Renders a single policy's markdown into the main content area.
// ==========================================================================

/**
 * Renders the policy matching the given ID into the view area.
 * Shows a fallback notice if the hash doesn't match any policy.
 * Injects an in-policy ToC from H3/H4/H5 headings and a copy-link
 * icon on the H2 heading. Updates breadcrumb, nav, and search highlights.
 */
function renderPolicy(id) {
  const policy = POLICY_INDEX.get(id);

  // --- Broken hash fallback ---
  if (id && !policy && ALL_POLICIES.length > 0) {
    if (metaEl) metaEl.textContent = "";
    if (viewEl) {
      viewEl.innerHTML = `
        <div class="hash-fallback">
          <div class="hash-fallback-title">Section not found</div>
          <div class="hash-fallback-detail">
            No policy matches <code>${id.replace(/</g, "&lt;")}</code>. It may have been moved or renamed.
          </div>
          <button class="hash-fallback-action" onclick="location.hash='${ALL_POLICIES[0].id}'">
            Go to first policy
          </button>
        </div>`;
    }
    CURRENT_POLICY = null;
    return;
  }

  // Fall back to first policy if no ID provided
  const target = policy || GROUPS?.[0]?.policies?.[0];

  if (!target) {
    if (metaEl) metaEl.textContent = "No H2 policies found.";
    if (viewEl) viewEl.innerHTML = "";
    return;
  }

  // Render markdown to HTML and apply indent formatting
  if (viewEl) {
    viewEl.innerHTML = md.render(target.mdText);
    applyIndent(viewEl);

    // --- Copy/share link icon on the H2 heading ---
    const h2El = viewEl.querySelector("h2");
    if (h2El) {
      const linkIcon = document.createElement("span");
      linkIcon.className = "heading-link";
      linkIcon.textContent = "\uD83D\uDD17"; // link emoji
      linkIcon.title = "Copy link to this policy";
      linkIcon.tabIndex = 0;
      linkIcon.addEventListener("click", (e) => {
        e.stopPropagation();
        const url = `${location.origin}${location.pathname}#${target.id}`;
        navigator.clipboard.writeText(url).then(() => {
          linkIcon.classList.add("copied");
          setTimeout(() => linkIcon.classList.remove("copied"), 1500);
        });
      });
      h2El.appendChild(linkIcon);
    }

    // --- In-policy table of contents (H3/H4/H5) ---
    const subHeadings = viewEl.querySelectorAll("h3, h4, h5");
    if (subHeadings.length >= 3) {
      const toc = document.createElement("nav");
      toc.className = "policy-toc";

      const tocTitle = document.createElement("div");
      tocTitle.className = "policy-toc-title";
      tocTitle.textContent = "In this policy";
      toc.appendChild(tocTitle);

      for (const heading of subHeadings) {
        const level = heading.tagName[1]; // "3", "4", or "5"
        const anchor = heading.id || slugify(heading.textContent);
        if (!heading.id) heading.id = anchor;

        const link = document.createElement("a");
        link.href = `#`;
        link.textContent = heading.textContent;
        link.dataset.level = level;
        link.addEventListener("click", (e) => {
          e.preventDefault();
          heading.scrollIntoView({ behavior: "smooth", block: "start" });
        });
        toc.appendChild(link);
      }

      // Insert after the H2 heading
      const firstH2 = viewEl.querySelector("h2");
      if (firstH2 && firstH2.nextSibling) {
        viewEl.insertBefore(toc, firstH2.nextSibling);
      } else {
        viewEl.prepend(toc);
      }
    }
  }

  // Update breadcrumb: "H1 Section > H2 Policy"
  if (metaEl) metaEl.textContent = `${target.h1Title}  ›  ${target.title}`;
  setActive(target.id);

  CURRENT_POLICY = target;

  // Re-apply search highlighting if a search is active
  if (CURRENT_QUERY && viewEl) highlightIn(viewEl, CURRENT_QUERY);

  // Scroll main content to top when switching policies
  if (mainEl) mainEl.scrollTop = 0;
}

// ==========================================================================
// PDF EXPORT: SHARED UTILITIES
// ==========================================================================

/**
 * Returns a promise that resolves when all <img> elements within a
 * container have finished loading (or errored). Used to ensure images
 * are rendered before capturing to canvas for PDF export.
 */
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

// ==========================================================================
// PDF EXPORT: SINGLE POLICY
// Exports the currently viewed policy as a branded A4 PDF with
// letterhead logo, page numbers, and company footer.
// ==========================================================================

async function exportCurrentPolicyPdf() {
  if (!CURRENT_POLICY) return;

  if (!window.html2pdf) {
    alert("PDF export library failed to load (html2pdf).");
    return;
  }

  /**
   * Fetches a file and converts it to a base64 data URL.
   * Used to embed the letterhead logo into the PDF.
   */
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

  let staging; // Off-screen container for rendering

  try {
    // Render the policy markdown to a detached DOM element
    const body = document.createElement("div");
    body.innerHTML = md.render(CURRENT_POLICY.mdText);
    applyIndent(body);

    // Wrap in pdf-export class for print-friendly styling
    const host = document.createElement("div");
    host.className = "pdf-export";
    host.appendChild(body);

    // Create an off-screen staging area to render the content invisibly
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

    // Wait for fonts and images to load before capturing
    if (document.fonts?.ready) {
      try { await document.fonts.ready; } catch { /* ignore */ }
    }
    await waitForImages(host);

    // Generate a safe filename from the policy title
    const safeName = `${CURRENT_POLICY.title}`
      .replace(/[\\/:*?"<>|]+/g, "")
      .replace(/\s+/g, " ")
      .trim()
      .slice(0, 120) || "policy";

    // Load the company letterhead logo as a data URL for embedding
    const letterheadLogoDataUrl = await loadAsDataUrl("letterhead_logo.png");

    // Company footer text
    const footerLine1 = "digital-origin.co.uk | discover@digital-origin.co.uk | 0333 006 7787";
    const footerLine2 = "Digital Origin Solutions Limited, The Maltings, Pury Hill Business Park, Alderton Road, Towcester, NN12 7L";
    const footerLine3 = "Registered in England 04121501";

    // html2pdf configuration
    const opt = {
      margin: [20, 10, 15, 10],    // [top, right, bottom, left] in mm
      filename: `${safeName}.pdf`,
      image: { type: "jpeg", quality: 0.95 },
      html2canvas: {
        scale: 2,                   // 2x resolution for sharp text
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

    // Generate the PDF, then stamp headers and footers on each page
    const worker = window.html2pdf().set(opt).from(host).toPdf();

    await worker.get("pdf").then((pdf) => {
      const pageCount = pdf.internal.getNumberOfPages();
      const pageWidth = pdf.internal.pageSize.getWidth();
      const pageHeight = pdf.internal.pageSize.getHeight();

      for (let i = 1; i <= pageCount; i++) {
        pdf.setPage(i);

        // Header: company logo top-left
        const logoW = 40;
        const logoH = logoW / 4.04; // Maintain aspect ratio
        const headerX = 15;
        const headerY = 8;
        pdf.addImage(letterheadLogoDataUrl, "PNG", headerX, headerY, logoW, logoH);

        // Footer: company details centred, page number bottom-right
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
    staging?.remove(); // Clean up the off-screen staging element
  }
}

// ==========================================================================
// PDF EXPORT: FULL MANUAL
// Exports every policy across all H1 groups as a single branded PDF.
// Uses a canvas-slicing approach: each policy is rendered to canvas,
// sliced into A4-height strips, and stitched into one jsPDF document.
// ==========================================================================

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

  /**
   * Fetches a file and converts it to a base64 data URL.
   * Used to embed the letterhead logo into the PDF.
   */
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
  const usableW = pageW - mLeft - mRight;   // 190mm printable width
  const usableH = pageH - mTop - mBottom;   // 262mm printable height
  const renderWidthPx = 980;                // Matches staging div width for consistent scaling

  let staging; // Off-screen container for rendering

  try {
    // Load branding assets
    const letterheadLogoDataUrl = await loadAsDataUrl("letterhead_logo.png");
    const footerLine1 = "digital-origin.co.uk | discover@digital-origin.co.uk | 0333 006 7787";
    const footerLine2 = "Digital Origin Solutions Limited, The Maltings, Pury Hill Business Park, Alderton Road, Towcester, NN12 7L";
    const footerLine3 = "Registered in England 04121501";

    const docTitle = (document.getElementById("docTitle")?.textContent || "Helpdesk Operations Manual").trim();
    const versionMeta = (document.getElementById("docMeta")?.textContent || "").trim();

    // Bootstrap a jsPDF instance from html2pdf's bundled copy
    // (avoids needing a separate jsPDF script tag)
    let pdf = null;
    let firstPage = true;

    // Create the off-screen staging container
    staging = document.createElement("div");
    staging.style.cssText = "position:fixed;left:-10000px;top:0;width:980px;opacity:1;pointer-events:none;background:#fff;z-index:-1;";
    document.body.appendChild(staging);

    // Wait for web fonts to be ready
    if (document.fonts?.ready) {
      try { await document.fonts.ready; } catch {}
    }

    // Dummy render to extract the jsPDF instance from html2pdf's internals
    const _bootstrapEl = document.createElement("div");
    _bootstrapEl.style.cssText = "width:1px;height:1px;overflow:hidden;";
    staging.appendChild(_bootstrapEl);
    await window.html2pdf()
      .set({ margin: [20,10,15,10], jsPDF: { unit: "mm", format: "a4", orientation: "portrait" }, html2canvas: { scale:1, backgroundColor:"#ffffff" } })
      .from(_bootstrapEl).toPdf()
      .get("pdf").then(p => { pdf = p; });
    staging.removeChild(_bootstrapEl);

    /**
     * Renders a DOM element to a canvas, slices the canvas into
     * A4-page-height strips, and appends each strip as a new page
     * in the master PDF document.
     */
    async function addElementToPdf(el) {
      staging.appendChild(el);
      await waitForImages(el);

      // Capture the element as a high-resolution canvas
      const canvas = await window.html2canvas(el, {
        scale: 2,
        useCORS: true,
        allowTaint: false,
        backgroundColor: "#ffffff",
        logging: false
      });

      staging.removeChild(el);

      if (canvas.width === 0 || canvas.height === 0) return;

      // Calculate how many canvas pixels fit in one printable page height
      const pxPerMm = canvas.width / usableW;
      const sliceHeightPx = Math.floor(usableH * pxPerMm);

      // Slice the canvas into page-height strips and add each to the PDF
      let y = 0;
      while (y < canvas.height) {
        const sliceH = Math.min(sliceHeightPx, canvas.height - y);

        // Extract the strip from the full canvas
        const slice = document.createElement("canvas");
        slice.width = canvas.width;
        slice.height = sliceH;
        slice.getContext("2d").drawImage(
          canvas,
          0, y, canvas.width, sliceH,  // Source rectangle
          0, 0, canvas.width, sliceH    // Destination rectangle
        );

        // Convert the strip to JPEG and add as a new PDF page
        const imgData = slice.toDataURL("image/jpeg", 0.95);
        const sliceHmm = (sliceH / canvas.width) * usableW; // Convert pixel height to mm

        if (!firstPage) pdf.addPage();
        pdf.addImage(imgData, "JPEG", mLeft, mTop, usableW, sliceHmm);
        firstPage = false;

        y += sliceH;
      }
    }

    // --- COVER PAGE ---
    const cover = document.createElement("div");
    cover.className = "pdf-export";
    cover.innerHTML = `<h1 style="margin:0 0 8px 0;">${docTitle}</h1><p style="margin:0;">${versionMeta}</p>`;
    await addElementToPdf(cover);

    // --- CONTENT PAGES: iterate through all groups and policies ---
    for (const g of GROUPS) {
      // H1 section title page
      const groupBlock = document.createElement("div");
      groupBlock.className = "pdf-export";
      groupBlock.innerHTML = `<h1>${g.title}</h1>`;
      await addElementToPdf(groupBlock);

      // Each H2 policy within the group
      for (const p of g.policies) {
        const block = document.createElement("div");
        block.className = "pdf-export";
        block.innerHTML = md.render(p.mdText);
        applyIndent(block);
        await addElementToPdf(block);
      }
    }

    // --- STAMP HEADERS AND FOOTERS ON EVERY PAGE ---
    const pageCount = pdf.internal.getNumberOfPages();
    for (let i = 1; i <= pageCount; i++) {
      pdf.setPage(i);

      // Header: company logo top-left
      const logoW = 40;
      const logoH = logoW / 4.04;
      pdf.addImage(letterheadLogoDataUrl, "PNG", 15, 8, logoW, logoH);

      // Footer: company details centred, page number bottom-right
      pdf.setFontSize(9);
      pdf.setTextColor(80);
      const cx = pageW / 2;
      pdf.text(footerLine1, cx, pageH - 13, { align: "center" });
      pdf.text(footerLine2, cx, pageH - 9,  { align: "center" });
      pdf.text(footerLine3, cx, pageH - 5,  { align: "center" });

      const label = `Page ${i} of ${pageCount}`;
      pdf.text(label, pageW - mRight - pdf.getTextWidth(label), pageH - 5);
    }

    // Generate a safe filename and trigger download
    const safeName = `${docTitle}${versionMeta ? " - " + versionMeta : ""}`
      .replace(/[\\/:*?"<>|]+/g, "").replace(/\s+/g, " ").trim().slice(0, 140) || "manual";

    pdf.save(`${safeName}.pdf`);

  } catch (e) {
    console.error(e);
    alert(String(e));
  } finally {
    staging?.remove(); // Clean up the off-screen staging element
  }
}

// ==========================================================================
// HASH-BASED ROUTING
// The URL hash (#policy-id) determines which policy is displayed.
// Changing the hash triggers a re-render of the corresponding policy.
// ==========================================================================

/** Reads the current URL hash and renders the matching policy */
function onHash() {
  const id = (location.hash || "").slice(1);
  renderPolicy(id);
}

// ==========================================================================
// SEARCH
// Full-text search across all policy titles and markdown content.
// Results are displayed in the sidebar; matching text is highlighted
// in the rendered document.
// ==========================================================================

/**
 * Extracts a short snippet around the first occurrence of the query
 * within the given text. Used for search result previews.
 */
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

/**
 * Performs a case-insensitive substring search across all policies.
 * Updates the results panel in the sidebar and re-renders the current
 * policy with search terms highlighted.
 */
function runSearch(raw) {
  const q = (raw || "").trim();
  CURRENT_QUERY = q;

  // If search is cleared, hide results and re-render without highlights
  if (!q) {
    resultsEl?.classList.remove("on");
    if (resultsEl) resultsEl.innerHTML = "";
    onHash();
    return;
  }

  const qLower = q.toLowerCase();
  const matches = [];

  // Search across title, parent H1 title, and full markdown body
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

  // Show the results panel
  resultsEl?.classList.add("on");
  if (!resultsEl) return;

  resultsEl.innerHTML = "";

  // Match count
  const count = document.createElement("div");
  count.className = "count";
  count.textContent = matches.length ? `${matches.length} match(es)` : "No matches";
  resultsEl.appendChild(count);

  // Render up to 50 result items
  for (const m of matches.slice(0, 50)) {
    const a = document.createElement("a");
    a.className = "result";
    a.href = `#${m.id}`;
    a.addEventListener("click", (e) => {
      e.preventDefault();
      location.hash = m.id;     // Navigate to the matching policy
    });

    const strong = document.createElement("strong");
    strong.textContent = m.title;

    const small = document.createElement("small");
    small.textContent = `${m.h1Title} — ${m.snippet || "Match found"}`;

    a.appendChild(strong);
    a.appendChild(small);
    resultsEl.appendChild(a);
  }

  // Re-render current policy to apply highlights
  onHash();
}

/**
 * Creates a debounced version of a function that delays execution
 * until after the specified milliseconds have elapsed since the last call.
 * Used to avoid running search on every keystroke.
 */
function debounce(fn, ms) {
  let t;
  return (...args) => {
    clearTimeout(t);
    t = setTimeout(() => fn(...args), ms);
  };
}

// ==========================================================================
// EVENT BINDINGS & INITIALISATION
// ==========================================================================

// Re-render when the URL hash changes (browser back/forward or nav click)
window.addEventListener("hashchange", onHash);

// Boot the application
init();

// Bind single-policy PDF export button
if (exportBtn) {
  exportBtn.addEventListener("click", exportCurrentPolicyPdf);
}

// Bind search input with debounced handler (140ms delay) and Escape to clear
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

// ==========================================================================
// BACK TO TOP BUTTON
// Shows when main content is scrolled down; scrolls to top on click.
// ==========================================================================

if (mainEl && backToTopBtn) {
  mainEl.addEventListener("scroll", () => {
    backToTopBtn.classList.toggle("visible", mainEl.scrollTop > 300);
  });

  backToTopBtn.addEventListener("click", () => {
    mainEl.scrollTo({ top: 0, behavior: "smooth" });
  });
}

// ==========================================================================
// KEYBOARD NAVIGATION
// /  — focus search
// n  — next policy
// p  — previous policy
// Only active when no input/textarea is focused.
// ==========================================================================

window.addEventListener("keydown", (e) => {
  const active = document.activeElement;
  const inInput = active && (active.tagName === "INPUT" || active.tagName === "TEXTAREA" || active.isContentEditable);

  // "/" focuses search from anywhere (unless already in an input)
  if (e.key === "/" && !inInput) {
    e.preventDefault();
    if (searchInput) searchInput.focus();
    return;
  }

  // Skip navigation shortcuts if the user is typing
  if (inInput) return;

  if (e.key === "n" || e.key === "p") {
    e.preventDefault();
    const idx = CURRENT_POLICY ? ALL_POLICIES.indexOf(CURRENT_POLICY) : -1;
    let next;

    if (e.key === "n") {
      next = ALL_POLICIES[idx + 1] || ALL_POLICIES[0];
    } else {
      next = ALL_POLICIES[idx - 1] || ALL_POLICIES[ALL_POLICIES.length - 1];
    }

    if (next) location.hash = next.id;
  }
});

// ==========================================================================
// THEME TOGGLE
// Cycles: system (default) → light → dark → system.
// Persists choice in localStorage. System = remove data-theme attribute.
// ==========================================================================

/** Theme icon map */
const THEME_ICONS = { system: "\u25D0", light: "\u2600", dark: "\u263E" };

/**
 * Applies the given theme setting to the document.
 * "system" removes the data-theme attribute, letting prefers-color-scheme rule.
 */
function applyTheme(setting) {
  if (setting === "system") {
    document.documentElement.removeAttribute("data-theme");
  } else {
    document.documentElement.setAttribute("data-theme", setting);
  }
  if (themeToggleBtn) themeToggleBtn.textContent = THEME_ICONS[setting] || THEME_ICONS.system;
  if (themeToggleBtn) themeToggleBtn.title = `Theme: ${setting}`;
}

// Initialise theme from localStorage (default: system)
const savedTheme = localStorage.getItem("theme") || "system";
applyTheme(savedTheme);

if (themeToggleBtn) {
  themeToggleBtn.addEventListener("click", () => {
    const current = localStorage.getItem("theme") || "system";
    const order = ["system", "light", "dark"];
    const next = order[(order.indexOf(current) + 1) % order.length];
    localStorage.setItem("theme", next);
    applyTheme(next);
  });
}
