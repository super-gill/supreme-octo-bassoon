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
const bookPicker = document.getElementById("bookPicker"); // Book selector dropdown
const platformVersionEl = document.getElementById("platformVersion"); // Sidebar footer version label
const themePickerEl = document.getElementById("themePicker");         // Theme picker dropdown
const backToTopBtn = document.getElementById("backToTop");           // Back to top button
const mainEl = document.querySelector("main");                       // Main scrollable pane
const tocAsideEl = document.getElementById("tocAside");              // Right pane (in-page ToC)
const tocNavEl = document.getElementById("tocNav");                  // Right pane link list
const appEl = document.querySelector(".app");                        // Root grid container


// ==========================================================================
// APPLICATION STATE
// ==========================================================================

/** Tome platform version — loaded from version.json at startup */
let PLATFORM_VERSION = "";

/** Canonical URL where the latest version.json is published */
const VERSION_CHECK_URL = "https://super-gill.github.io/tome.md/version.json";

let CURRENT_QUERY = "";       // Active search query (empty = no search)
let CURRENT_POLICY = null;    // Currently rendered policy object
let CURRENT_BOOK = null;      // Filename of the currently loaded book (set from books.json)
let BOOKS = [];               // Array of { file, title } from books.json
let TOME_CONFIG = {};         // Configuration loaded from tome.json
let EXPORT_BRANDS = [];       // Array of { id, label, config, basePath } from export-branding/
let ACTIVE_BRAND = null;      // Currently selected export brand

// ==========================================================================
// HELPERS
// ==========================================================================

/**
 * Extracts document metadata from structured lines at the top of the markdown:
 *   Document Title: [title]
 *   Document Version: [version]
 *   Document Date: [date]
 *   Document Classification: [classification]
 * Scans up to 20 lines or the first heading, whichever comes first.
 * Falls back to tome.json defaultTitle if no title line is found.
 */
function extractDocMeta(mdText) {
  const lines = mdText.split(/\r?\n/);
  const defaultTitle = TOME_CONFIG.branding?.defaultTitle || "Manual";

  let title = null;
  let version = null;
  let date = null;
  let classification = null;

  for (let i = 0; i < Math.min(lines.length, 20); i++) {
    const line = lines[i].trim();
    if (line.startsWith("#")) break;

    const titleMatch = /^Document\s+Title:\s*(.+)/i.exec(line);
    const versionMatch = /^Document\s+Version:\s*(.+)/i.exec(line);
    const dateMatch = /^Document\s+Date:\s*(.+)/i.exec(line);
    const classificationMatch = /^Document\s+Classification:\s*(.+)/i.exec(line);

    if (titleMatch) title = titleMatch[1].trim();
    if (versionMatch) version = versionMatch[1].trim();
    if (dateMatch) date = dateMatch[1].trim();
    if (classificationMatch) classification = classificationMatch[1].trim();
  }

  return {
    title: title || defaultTitle,
    version: version || null,
    date: date || null,
    classification: classification || null
  };
}

/**
 * Resolves relative image and link URLs within a rendered DOM container
 * so they are relative to the book's directory rather than the page root.
 * E.g. if CURRENT_BOOK is "Books/my-docs/guide.md", an <img src="diagram.png">
 * becomes <img src="Books/my-docs/diagram.png">. Directory-format books
 * (where CURRENT_BOOK points at a folder) resolve against the folder itself.
 */
function resolveBookPaths(container) {
  if (!CURRENT_BOOK) return;
  let bookDir;
  if (/\.md$/i.test(CURRENT_BOOK)) {
    bookDir = CURRENT_BOOK.substring(0, CURRENT_BOOK.lastIndexOf("/") + 1);
  } else {
    bookDir = CURRENT_BOOK.endsWith("/") ? CURRENT_BOOK : CURRENT_BOOK + "/";
  }
  if (!bookDir) return; // Book is in root, nothing to resolve

  const isRelative = (url) => url && !url.startsWith("http") && !url.startsWith("//")
    && !url.startsWith("data:") && !url.startsWith("#") && !url.startsWith("/")
    && !url.startsWith("tome://");

  container.querySelectorAll("img[src]").forEach((img) => {
    if (isRelative(img.getAttribute("src"))) {
      img.setAttribute("src", bookDir + img.getAttribute("src"));
    }
    img.setAttribute("loading", "lazy");
  });

  container.querySelectorAll("a[href]").forEach((a) => {
    const href = a.getAttribute("href");
    // Only resolve file links, not hash links or external URLs
    if (isRelative(href) && !href.startsWith("#")) {
      a.setAttribute("href", bookDir + href);
    }
  });
}

// ==========================================================================
// CROSS-BOOK LINKS
// Intercepts tome:// links to navigate between books with a return button.
// Syntax: <a href="tome://book-folder#policy-slug">Link text</a>
// ==========================================================================

/** Saved return point when following a cross-book link */
let CROSS_BOOK_RETURN = null;

/**
 * Scans rendered HTML for tome:// links and wires them up for cross-book
 * navigation. On click, saves the current book + policy as a return point,
 * switches to the target book, and navigates to the target policy.
 */
function processCrossBookLinks(container) {
  container.querySelectorAll('a[href^="tome://"]').forEach((a) => {
    a.style.cursor = "pointer";
    a.addEventListener("click", async (e) => {
      e.preventDefault();
      const href = a.getAttribute("href");
      const stripped = href.replace("tome://", "");
      const [bookFolder, policyHash] = stripped.split("#");

      // Find matching book by folder name
      const targetBook = BOOKS.find((b) => b.path.includes(bookFolder));
      if (!targetBook) {
        alert(`Book not found: ${bookFolder}`);
        return;
      }

      // Save return point
      const returnTitle = document.getElementById("docTitle")?.textContent || "previous book";
      CROSS_BOOK_RETURN = {
        book: CURRENT_BOOK,
        policy: CURRENT_POLICY?.id || "",
        title: returnTitle
      };

      // Switch book and navigate
      CURRENT_BOOK = targetBook.path;
      localStorage.setItem("tome-book", CURRENT_BOOK);
      if (bookPicker) bookPicker.value = CURRENT_BOOK;
      await loadBook(CURRENT_BOOK);
      if (policyHash) location.hash = policyHash;

      showReturnButton();
    });
  });
}

/** Pulse interval ID for the cross-book return button */
let crossBookPulseInterval = null;

/** Shows a floating "Back to ..." button after a cross-book navigation */
function showReturnButton() {
  // Remove existing button and interval if present
  const existing = document.getElementById("crossBookReturn");
  if (existing) existing.remove();
  if (crossBookPulseInterval) { clearInterval(crossBookPulseInterval); crossBookPulseInterval = null; }

  if (!CROSS_BOOK_RETURN) return;

  const btn = document.createElement("button");
  btn.id = "crossBookReturn";
  btn.className = "cross-book-return";

  // Return link text
  const label = document.createElement("span");
  label.innerHTML = `&#8592; Back to ${CROSS_BOOK_RETURN.title}`;
  btn.appendChild(label);

  // Dismiss button
  const dismiss = document.createElement("span");
  dismiss.className = "cross-book-dismiss";
  dismiss.innerHTML = "&times;";
  dismiss.title = "Dismiss";
  dismiss.addEventListener("click", (e) => {
    e.stopPropagation();
    CROSS_BOOK_RETURN = null;
    if (crossBookPulseInterval) { clearInterval(crossBookPulseInterval); crossBookPulseInterval = null; }
    btn.remove();
  });
  btn.appendChild(dismiss);

  // Return click
  label.style.cursor = "pointer";
  label.addEventListener("click", async () => {
    const ret = CROSS_BOOK_RETURN;
    CROSS_BOOK_RETURN = null;
    if (crossBookPulseInterval) { clearInterval(crossBookPulseInterval); crossBookPulseInterval = null; }
    btn.remove();

    CURRENT_BOOK = ret.book;
    localStorage.setItem("tome-book", CURRENT_BOOK);
    if (bookPicker) bookPicker.value = CURRENT_BOOK;
    await loadBook(CURRENT_BOOK);
    if (ret.policy) location.hash = ret.policy;
  });

  mainEl.appendChild(btn);

  // Pulse every 20 seconds to draw attention
  crossBookPulseInterval = setInterval(() => {
    btn.classList.remove("pulse");
    void btn.offsetWidth; // force reflow to restart animation
    btn.classList.add("pulse");
  }, 20000);
}

/**
 * Converts blockquotes with special prefixes into styled callouts.
 *   >! text  →  warning callout (yellow, warning icon)
 *   >? text  →  info callout (blue, info icon)
 *   >  text  →  normal blockquote (unchanged)
 */
function processCallouts(container) {
  container.querySelectorAll("blockquote").forEach((bq) => {
    const firstP = bq.querySelector("p");
    if (!firstP) return;

    const text = firstP.innerHTML;
    const tags = {
      "[!WARNING]":  "callout-warning",
      "[!INFO]":     "callout-info",
      "[!TIP]":      "callout-tip",
      "[!DANGER]":   "callout-danger",
      "[!NOTE]":     "callout-note"
    };

    for (const [tag, cls] of Object.entries(tags)) {
      if (text.startsWith(tag)) {
        bq.classList.add("callout", cls);
        firstP.innerHTML = text.slice(tag.length).replace(/^\s*/, "");
        break;
      }
    }
  });
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
  const allLines = markdown.replace(/\r\n/g, "\n").split("\n");

  // Strip metadata lines from the top (Document Title:, Document Version:, Document Date:, Document Classification:)
  const metaPattern = /^Document\s+(Title|Version|Date|Classification):\s*/i;
  let firstContentLine = 0;
  for (let i = 0; i < Math.min(allLines.length, 20); i++) {
    const trimmed = allLines[i].trim();
    if (trimmed.startsWith("#")) break;
    if (metaPattern.test(trimmed) || trimmed === "") {
      firstContentLine = i + 1;
      continue;
    }
    break;
  }
  const lines = allLines.slice(firstContentLine);

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

  // Track fenced code blocks so `# something` or `## something` used inside
  // a code example is NOT mistaken for a real heading (e.g. an authoring guide
  // that demonstrates markdown heading syntax inside a ``` block).
  let inFence = false;
  let fenceMarker = "";

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    const fenceMatch = /^\s*(```|~~~)/.exec(line);
    if (fenceMatch) {
      const token = fenceMatch[1];
      if (!inFence) { inFence = true; fenceMarker = token; }
      else if (fenceMarker === token) { inFence = false; fenceMarker = ""; }
      if (currentPolicy) currentPolicy.mdText += line + "\n";
      continue;
    }
    if (inFence) {
      if (currentPolicy) currentPolicy.mdText += line + "\n";
      continue;
    }

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
// Fetches markdown files and the Books/books.json manifest.
// ==========================================================================

/**
 * Loads the tome.json configuration file. Falls back to sensible defaults
 * if the file is missing so the platform still works without it.
 */
async function loadConfig() {
  try {
    const url = new URL("tome.json", document.baseURI);
    const res = await fetch(url.href, { cache: "default" });
    if (!res.ok) throw new Error(`${res.status}`);
    TOME_CONFIG = await res.json();
  } catch (e) {
    console.warn("Could not load tome.json, using defaults:", e);
    TOME_CONFIG = {};
  }
}

/**
 * Fetches the markdown for a book. A book is either:
 *   - a single monolithic .md file (path ends in .md), or
 *   - a directory whose sections/pages are declared either inline in
 *     Books/books.json or in a book.json inside the directory itself.
 * Directory books are compiled into an equivalent synthetic markdown string
 * in memory so parser, nav, search, and export all work unchanged.
 */
async function loadManualMd(filename) {
  const file = filename || CURRENT_BOOK;
  console.log("Loading book from:", file);

  if (isDirectoryBook(file)) {
    // If the books.json entry carries an inline manifest, use it directly;
    // otherwise fall back to fetching book.json from the directory.
    const entry = BOOKS.find((b) => b.path === file) || null;
    const inline = entry && Array.isArray(entry.sections) ? entry : null;
    return await loadManualFromDirectory(file, inline);
  }

  const url = new URL(file, document.baseURI);
  const res = await fetch(url.href, { cache: "default" });
  if (!res.ok) throw new Error(`Failed to load ${url.href} (${res.status} ${res.statusText})`);
  return await res.text();
}

// ==========================================================================
// DIRECTORY-FORMAT BOOK SUPPORT
// Lets a book live as a folder of markdown files instead of one monolithic
// file. Because static hosting (e.g. GitHub Pages) cannot list directories,
// each directory book carries a lightweight book.json manifest that names
// its sections (sub-folders) and pages (files in order).
//
// The manifest is compiled into a synthetic monolithic markdown string that
// feeds the existing parseManual() pipeline, so every downstream feature
// (search, PDF export, full-manual export, cross-book links) works
// identically to a monolithic book with no changes required.
// ==========================================================================

/** True if the books.json `file` entry points at a directory (anything not ending in .md). */
function isDirectoryBook(filePath) {
  return !/\.md$/i.test((filePath || "").replace(/\/$/, ""));
}

/**
 * Compiles a directory book into a synthetic monolithic markdown string.
 * The manifest can be supplied inline (from Books/books.json) or — for
 * books authored as portable self-contained folders — fetched from a
 * book.json file inside the directory.
 *
 * Manifest schema (all fields optional unless noted):
 *   {
 *     "title":          "Book title" (defaults to the folder name),
 *     "version":        "1.0",
 *     "date":           "2026-04-21",
 *     "classification": "Internal Use Only",
 *     "sections": [
 *       {
 *         "title":  "Section title" (required; shown as H1 in nav),
 *         "folder": "subfolder"     (optional; defaults to title; use "" for the book root),
 *         "pages":  [
 *           "filename.md"                              // shorthand (title taken from file's first H1)
 *           { "file": "filename.md", "title": "..." }  // explicit title override
 *         ]
 *       }
 *     ]
 *   }
 */
async function loadManualFromDirectory(dirPath, inlineManifest) {
  const base = dirPath.replace(/\/$/, "");

  let manifest;
  if (inlineManifest && Array.isArray(inlineManifest.sections)) {
    // Inline manifest from Books/books.json — no extra fetch required.
    manifest = inlineManifest;
  } else {
    // Fallback: fetch a book.json bundled inside the directory.
    const manifestUrl = new URL(`${base}/book.json`, document.baseURI);
    const mRes = await fetch(manifestUrl.href, { cache: "default" });
    if (!mRes.ok) {
      throw new Error(`No inline manifest in Books/books.json and ${manifestUrl.href} is missing (${mRes.status} ${mRes.statusText}). Declare the book's sections/pages inline or add a book.json inside the directory.`);
    }
    manifest = await mRes.json();
  }

  const bookTitle = manifest.title || base.split("/").filter(Boolean).pop() || "Manual";

  // --- Pass 1: fetch every page and determine its title, so we can build a
  //     lookup from "section-folder/filename" to the #slug the parser will
  //     produce. This is what lets intra-book <a href="other-page.md"> links
  //     be rewritten to viewer anchors instead of raw file fetches.
  const sections = [];
  const linkSlugMap = new Map();

  for (const section of manifest.sections || []) {
    const sectionTitle = section.title || section.folder || "";
    const sectionFolder = section.folder !== undefined ? section.folder : sectionTitle;
    const pages = [];

    for (const pageRaw of section.pages || []) {
      const pageFile = typeof pageRaw === "string" ? pageRaw : pageRaw?.file;
      const explicitTitle = (pageRaw && typeof pageRaw === "object") ? pageRaw.title : null;
      if (!pageFile) continue;

      const relPath = sectionFolder ? `${sectionFolder}/${pageFile}` : pageFile;
      const pageUrl = new URL(`${base}/${relPath}`, document.baseURI);

      let mdText = "";
      try {
        const pRes = await fetch(pageUrl.href, { cache: "default" });
        if (pRes.ok) mdText = await pRes.text();
        else console.warn(`Directory-book page missing: ${pageUrl.href} (${pRes.status})`);
      } catch (e) {
        console.warn(`Failed to fetch ${pageUrl.href}:`, e);
      }

      // Resolve page title: manifest override > file's first H1 > humanised filename
      let pageTitle = explicitTitle || null;
      if (!pageTitle) {
        const h1 = /^#\s+(.+?)\s*$/m.exec(mdText);
        if (h1) pageTitle = h1[1].trim();
      }
      if (!pageTitle) pageTitle = pageFile.replace(/\.md$/i, "").replace(/[-_]+/g, " ").trim();

      // Pre-compute the slug parseManual() will assign so links can target it.
      // Mirror the parser's collision-suffixing (-2, -3, …) by tracking already-used slugs.
      const baseSlug = slugify(`${sectionTitle} ${pageTitle}`) || `h2-${sections.length + 1}-${pages.length + 1}`;
      let finalSlug = baseSlug;
      let n = 2;
      const used = new Set(linkSlugMap.values());
      while (used.has(finalSlug)) finalSlug = `${baseSlug}-${n++}`;
      linkSlugMap.set(relPath, finalSlug);

      pages.push({ file: pageFile, title: pageTitle, mdText, sectionFolder });
    }

    sections.push({ title: sectionTitle, folder: sectionFolder, pages });
  }

  // --- Pass 2: assemble the synthetic monolithic markdown.
  const meta = [];
  meta.push(`Document Title: ${bookTitle}`);
  if (manifest.version) meta.push(`Document Version: ${manifest.version}`);
  if (manifest.date) meta.push(`Document Date: ${manifest.date}`);
  if (manifest.classification) meta.push(`Document Classification: ${manifest.classification}`);

  let out = meta.join("\n") + "\n\n";
  for (const section of sections) {
    out += `# ${section.title}\n\n`;
    for (const page of section.pages) {
      out += compileDirectoryPage(page, linkSlugMap) + "\n\n";
    }
  }
  return out;
}

/**
 * Transforms one page file into a chunk suitable for concatenation into
 * the synthetic manual:
 *   - Replaces the file's first H1 with a new H2 carrying the page title
 *     (so the existing parser sees it as a page boundary).
 *   - Demotes remaining headings by one level (H2→H3, H3→H4, …, H6 clamped),
 *     floored at H3 so no nested heading accidentally introduces a new page
 *     or section boundary.
 *   - Prefixes relative image/link paths with the section folder and
 *     percent-encodes spaces so they resolve correctly after
 *     resolveBookPaths() applies the book-root prefix.
 *   - Rewrites links that target another .md file in the same book to the
 *     viewer's #slug anchor for that page.
 */
function compileDirectoryPage(page, linkSlugMap) {
  const { title, mdText, sectionFolder } = page;
  const lines = (mdText || "").replace(/\r\n/g, "\n").split("\n");

  // Drop everything up to and including the first H1. Body after it becomes
  // the page body; the manifest title replaces the original H1.
  let firstH1 = -1;
  for (let i = 0; i < lines.length; i++) {
    if (/^#\s+/.test(lines[i])) { firstH1 = i; break; }
  }
  const body = firstH1 >= 0 ? lines.slice(firstH1 + 1) : lines.slice();

  const out = [`## ${title}`, ""];
  let inFence = false;
  let fenceMarker = "";

  for (const raw of body) {
    const fenceMatch = /^\s*(```|~~~)/.exec(raw);
    if (fenceMatch) {
      const token = fenceMatch[1];
      if (!inFence) { inFence = true; fenceMarker = token; }
      else if (fenceMarker === token) { inFence = false; fenceMarker = ""; }
      out.push(raw);
      continue;
    }
    if (inFence) { out.push(raw); continue; }

    let line = raw;
    const hm = /^(#{1,6})(\s+.+)$/.exec(line);
    if (hm) {
      const newLevel = Math.min(6, Math.max(3, hm[1].length + 1));
      line = "#".repeat(newLevel) + hm[2];
    }
    line = rewriteDirectoryPageRefs(line, sectionFolder, linkSlugMap);
    out.push(line);
  }

  return out.join("\n");
}

/**
 * Rewrites image/link targets in one line of a directory-book page.
 *   - Absolute, hash, mailto, data, and tome:// URLs are left alone.
 *   - Links whose target resolves to another .md file in the same book
 *     are replaced with the #slug anchor for that page.
 *   - Everything else is joined to the section folder (so resolveBookPaths
 *     can prefix the book root), with spaces percent-encoded.
 */
function rewriteDirectoryPageRefs(line, sectionFolder, linkSlugMap) {
  const isAbsoluteOrSpecial = (url) =>
    /^(https?:|\/\/|\/|#|data:|tome:|mailto:)/i.test(url);

  // Resolve a relative URL into a "sectionFolder/filename" key, applying
  // any ../ segments against the source page's section folder. Returns null
  // if the URL is not an .md file or escapes above the book root.
  const resolveIntraBook = (url) => {
    const hashIdx = url.indexOf("#");
    const pathPart = hashIdx >= 0 ? url.slice(0, hashIdx) : url;
    if (!/\.md$/i.test(pathPart)) return null;

    const folderParts = sectionFolder ? sectionFolder.split("/").filter(Boolean) : [];
    const pathParts = pathPart.split("/").filter((p) => p !== "" && p !== ".");
    const stack = [...folderParts];
    for (const p of pathParts) {
      if (p === "..") {
        if (stack.length === 0) return null;
        stack.pop();
      } else {
        stack.push(p);
      }
    }
    return stack.join("/");
  };

  const rewrite = (url) => {
    if (!url) return url;
    if (isAbsoluteOrSpecial(url)) return url;

    const resolved = resolveIntraBook(url);
    if (resolved && linkSlugMap.has(resolved)) {
      return `#${linkSlugMap.get(resolved)}`;
    }

    const joined = sectionFolder ? `${sectionFolder}/${url}` : url;
    return joined.replace(/ /g, "%20");
  };

  // Markdown images: ![alt](url "optional title")
  line = line.replace(
    /!\[([^\]]*)\]\(([^)\s]+)((?:\s+"[^"]*")?)\)/g,
    (_, alt, url, title) => `![${alt}](${rewrite(url)}${title || ""})`
  );

  // Markdown links: [text](url "optional title") — exclude the image form
  line = line.replace(
    /(^|[^!])\[([^\]]*)\]\(([^)\s]+)((?:\s+"[^"]*")?)\)/g,
    (_, before, text, url, title) => `${before}[${text}](${rewrite(url)}${title || ""})`
  );

  // HTML <img src="…"> and <a href="…"> (both ASCII quote styles)
  line = line.replace(
    /(<img\s[^>]*\bsrc\s*=\s*)(["'])([^"']+)\2/gi,
    (_, pre, q, url) => `${pre}${q}${rewrite(url)}${q}`
  );
  line = line.replace(
    /(<a\s[^>]*\bhref\s*=\s*)(["'])([^"']+)\2/gi,
    (_, pre, q, url) => `${pre}${q}${rewrite(url)}${q}`
  );

  return line;
}

/**
 * Loads the books.json manifest and populates the book picker dropdown.
 * If Books/books.json is missing or empty, BOOKS is set to an empty array.
 * Attaches a change listener so selecting a different book triggers a reload.
 */
// ==========================================================================
// EXPORT BRAND LOADING
// Loads the brands.json manifest and each brand's brand.json configuration.
// ==========================================================================

/**
 * Loads the export branding manifest and each brand's config.
 * Falls back to tome.json PDF settings if no brands are found.
 */
async function loadBrands() {
  try {
    const manifestUrl = new URL("export-branding/brands.json", document.baseURI);
    const res = await fetch(manifestUrl.href, { cache: "default" });
    if (!res.ok) throw new Error(`${res.status}`);
    const brandIds = await res.json();

    const brands = [];
    for (const id of brandIds) {
      try {
        const brandUrl = new URL(`export-branding/${id}/brand.json`, document.baseURI);
        const bRes = await fetch(brandUrl.href, { cache: "default" });
        if (!bRes.ok) continue;
        const config = await bRes.json();
        brands.push({
          id,
          label: config.label || id,
          config,
          basePath: `export-branding/${id}/`
        });
      } catch (e) {
        console.warn(`Could not load brand "${id}":`, e);
      }
    }

    if (brands.length > 0) {
      EXPORT_BRANDS = brands;
      ACTIVE_BRAND = brands[0];
    }
  } catch (e) {
    console.warn("Could not load export-branding/brands.json, using tome.json PDF settings:", e);
    EXPORT_BRANDS = [];
    ACTIVE_BRAND = null;
  }
}

/**
 * Returns the resolved PDF settings for the active brand.
 * Falls back to tome.json settings if no brand is active.
 */
function getExportSettings() {
  if (!ACTIVE_BRAND) {
    // Fallback to tome.json settings
    const pdfConf = TOME_CONFIG.pdf || {};
    return {
      pageSize: "a4",
      orientation: "portrait",
      margins: { top: 20, right: 10, bottom: 15, left: 10 },
      header: {
        logo: pdfConf.logo || "letterhead_logo.png",
        logoWidth: 40,
        logoAspect: 4.04,
        x: 15,
        y: 8
      },
      footer: {
        lines: pdfConf.footer || ["", "", ""],
        fontSize: 9,
        color: 80
      },
      coverPage: true,
      coverTitle: null,
      _basePath: ""
    };
  }

  const c = ACTIVE_BRAND.config;
  return {
    pageSize: c.pageSize || "a4",
    orientation: c.orientation || "portrait",
    margins: c.margins || { top: 20, right: 10, bottom: 15, left: 10 },
    header: c.header || { logo: "media/letterhead_logo.png", logoWidth: 40, logoAspect: 4.04, x: 15, y: 8 },
    footer: c.footer || { lines: ["", "", ""], fontSize: 9, color: 80 },
    coverPage: c.coverPage !== false,
    coverTitle: c.coverTitle || null,
    _basePath: ACTIVE_BRAND.basePath
  };
}

/**
 * Resolves a media path within a brand's directory.
 */
function resolveBrandPath(relativePath, basePath) {
  if (!relativePath) return relativePath;
  if (relativePath.startsWith("http") || relativePath.startsWith("data:")) return relativePath;
  return basePath + relativePath;
}

async function loadBooks() {
  try {
    const url = new URL("Books/books.json", document.baseURI);
    const res = await fetch(url.href, { cache: "default" });
    if (!res.ok) throw new Error(`Failed to load Books/books.json (${res.status})`);
    BOOKS = await res.json();
  } catch (e) {
    console.warn("Could not load Books/books.json:", e);
    BOOKS = [];
  }

  // Normalize each entry to have a canonical `path` property.
  // Supported shapes: { file: "Books/foo.md" }  |  { file: "Books/foo" }  |  { directory: "Books/foo" }
  // The rest of the entry (title, sections, version, ...) is preserved.
  BOOKS = (Array.isArray(BOOKS) ? BOOKS : [])
    .map((b) => ({ ...b, path: b.path || b.file || b.directory || "" }))
    .filter((b) => b.path);

  // Restore last-viewed book, or default to the first book
  if (!CURRENT_BOOK && BOOKS.length > 0) {
    const saved = localStorage.getItem("tome-book");
    CURRENT_BOOK = (saved && BOOKS.some((b) => b.path === saved)) ? saved : BOOKS[0].path;
  }

  // Populate the dropdown with available books
  if (bookPicker) {
    bookPicker.innerHTML = "";
    for (const book of BOOKS) {
      const opt = document.createElement("option");
      opt.value = book.path;
      opt.textContent = book.title;
      bookPicker.appendChild(opt);
    }
    bookPicker.value = CURRENT_BOOK;

    // Switch books when the user selects a different option
    bookPicker.addEventListener("change", async () => {
      CURRENT_BOOK = bookPicker.value;
      localStorage.setItem("tome-book", CURRENT_BOOK);
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
    const { title, version, date, classification: docClassification } = extractDocMeta(mdText);
    const classification = docClassification || TOME_CONFIG.branding?.classification || "";

    // Update sidebar branding with book title, version, and date
    const titleEl = document.getElementById("docTitle");
    const metaEl2 = document.getElementById("docMeta");

    if (titleEl) titleEl.textContent = title;
    if (metaEl2) {
      const parts = [version, date, classification].filter(Boolean);
      metaEl2.textContent = parts.join(" | ");
    }

    // Update browser tab title
    document.title = title + (version ? ` \u2014 ${version}` : "");

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
 * Displays a welcome/getting-started message when no books are configured.
 */
function showWelcome() {
  const titleEl = document.getElementById("docTitle");
  if (titleEl) titleEl.textContent = "Welcome to Tome";
  if (metaEl) metaEl.textContent = "";
  if (navEl) navEl.innerHTML = "";
  if (bookPicker) bookPicker.style.display = "none";
  // Collapse the right ToC pane — there's no page content to build one from.
  if (typeof resetRightToc === "function") resetRightToc();
  if (viewEl) {
    viewEl.innerHTML = `
      <div style="max-width:600px;margin:40px auto;line-height:1.7">
        <h2 style="margin-bottom:8px">No books found</h2>
        <p>Tome is running, but there are no books configured yet.</p>
        <h3 style="margin-top:24px">Getting started</h3>
        <ol>
          <li>Add a markdown file (e.g. <code>Books/my-docs/guide.md</code>), or a folder of files for a directory book</li>
          <li>Register it in <code>Books/books.json</code>:</li>
        </ol>
<pre>[
  { "file": "Books/my-docs/guide.md", "title": "My Guide" }
]</pre>
        <ol start="3">
          <li>Refresh this page</li>
        </ol>
        <p>See the <strong>Managing Books</strong> and <strong>Directory-Format Books</strong> sections in the Guide tab for the full schema.</p>
      </div>`;
  }
}

/**
 * Application entry point. Loads the book manifest, then loads and
 * renders the default book.
 */
async function init() {
  const splashEl = document.getElementById("tomeSplash");
  const splashStart = Date.now();

  // Load platform version from version.json (single source of truth)
  try {
    const vRes = await fetch(new URL("version.json", document.baseURI).href, { cache: "default" });
    if (vRes.ok) {
      const vData = await vRes.json();
      PLATFORM_VERSION = vData.version || "";
    }
  } catch (e) {
    console.warn("Could not load version.json:", e);
  }
  if (platformVersionEl) platformVersionEl.textContent = `Tome ${PLATFORM_VERSION}`;
  populateAbout();

  // Load configuration and book manifest while the splash is visible
  await loadConfig();

  // Apply config: favicon and branding
  const faviconPath = TOME_CONFIG.branding?.favicon;
  if (faviconPath) {
    const faviconEl = document.getElementById("favicon");
    if (faviconEl) faviconEl.href = faviconPath;
  }
  applyBranding();

  await loadBooks();
  await loadBrands();
  buildBrandPicker();

  // Wait for the remainder of the minimum splash duration
  const splashMs = TOME_CONFIG.splash?.minDurationMs ?? 2000;
  const elapsed = Date.now() - splashStart;
  if (elapsed < splashMs) {
    await new Promise(r => setTimeout(r, splashMs - elapsed));
  }

  // Fade out the splash overlay, then remove it from the DOM
  if (splashEl) {
    splashEl.classList.add("dismissed");
    splashEl.addEventListener("transitionend", () => splashEl.remove(), { once: true });
  }

  // Render the first page, or show a welcome screen if no books are configured
  if (CURRENT_BOOK) {
    await loadBook(CURRENT_BOOK);
  } else {
    showWelcome();
  }

  // Check for platform updates (non-blocking)
  checkForUpdate();
}

// ==========================================================================
// VERSION CHECK
// Fetches the latest version.json from the canonical published URL and
// shows a notification banner if this instance is running an older version.
// ==========================================================================

/**
 * Compares two semver strings (e.g. "v2.1.0" vs "v2.2.0").
 * Returns true if remote is newer than local.
 */
function isNewerVersion(local, remote) {
  const parse = (v) => v.replace(/^v/, "").split(".").map(Number);
  const l = parse(local);
  const r = parse(remote);
  for (let i = 0; i < 3; i++) {
    if ((r[i] || 0) > (l[i] || 0)) return true;
    if ((r[i] || 0) < (l[i] || 0)) return false;
  }
  return false;
}

/**
 * Fetches the latest version from the canonical URL and displays
 * a dismissible banner if this instance is outdated.
 */
async function checkForUpdate() {
  try {
    const res = await fetch(VERSION_CHECK_URL, { cache: "default" });
    if (!res.ok) return;
    const data = await res.json();
    const latest = data.version;

    if (!latest || !isNewerVersion(PLATFORM_VERSION, latest)) return;

    // Build and inject the update banner
    const banner = document.createElement("div");
    banner.className = "update-banner";
    banner.innerHTML = `
      <span>A newer version of Tome is available: <strong>${latest}</strong> (you are running ${PLATFORM_VERSION})</span>
      <button class="update-banner-dismiss" title="Dismiss">&times;</button>
    `;
    banner.querySelector(".update-banner-dismiss").addEventListener("click", () => {
      banner.remove();
    });
    document.body.appendChild(banner);
  } catch {
    // Silently ignore — update check is non-critical
  }
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
      updateNavToggleLabel();
    });

    // Start collapsed by default
    h.classList.add("collapsed");
    group.classList.add("collapsed");
    group.style.maxHeight = "0";
  }
}

/** Updates the Expand/Collapse all button label based on current nav state */
function updateNavToggleLabel() {
  const btn = document.getElementById("navToggleAll");
  if (!btn || !navEl) return;
  const allCollapsed = navEl.querySelectorAll(".nav-group:not(.collapsed)").length === 0;
  btn.textContent = allCollapsed ? "Expand all" : "Collapse all";
  btn.title = allCollapsed ? "Expand all sections" : "Collapse all sections";
}

// Expand / Collapse all nav sections
document.getElementById("navToggleAll")?.addEventListener("click", () => {
  if (!navEl) return;
  const groups = navEl.querySelectorAll(".nav-group");
  const headers = navEl.querySelectorAll(".nav-h1");
  const anyExpanded = navEl.querySelectorAll(".nav-group:not(.collapsed)").length > 0;

  groups.forEach((g, i) => {
    if (anyExpanded) {
      g.classList.add("collapsed");
      g.style.maxHeight = "0";
      headers[i]?.classList.add("collapsed");
    } else {
      g.classList.remove("collapsed");
      g.style.maxHeight = g.scrollHeight + "px";
      headers[i]?.classList.remove("collapsed");
    }
  });
  updateNavToggleLabel();
});

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

  // Clear the right-pane ToC up-front so stale entries from the previous
  // page don't linger if we take an early-return path below.
  resetRightToc();

  // --- Broken hash fallback ---
  if (id && !policy && ALL_POLICIES.length > 0) {
    if (metaEl) metaEl.textContent = "";
    if (viewEl) {
      viewEl.innerHTML = `
        <div class="hash-fallback">
          <div class="tome-wordmark">Tome</div>
          <div class="hash-fallback-title">Section not found</div>
          <div class="hash-fallback-detail">
            No page matches <code>${id.replace(/</g, "&lt;")}</code>. It may have been moved or renamed.
          </div>
          <button class="hash-fallback-action" onclick="location.hash='${ALL_POLICIES[0].id}'">
            Go to first page
          </button>
        </div>`;
    }
    CURRENT_POLICY = null;
    return;
  }

  // Fall back to first policy if no ID provided
  const target = policy || GROUPS?.[0]?.policies?.[0];

  if (!target) {
    if (metaEl) metaEl.textContent = "No H2 pages found.";
    if (viewEl) viewEl.innerHTML = "";
    return;
  }

  // Render markdown to HTML and apply indent formatting
  if (viewEl) {
    viewEl.innerHTML = md.render(target.mdText);
    resolveBookPaths(viewEl);
    processCallouts(viewEl);
    processCrossBookLinks(viewEl);
    applyIndent(viewEl);

    // --- Copy/share link icon on the H2 heading ---
    const h2El = viewEl.querySelector("h2");
    if (h2El) {
      const linkIcon = document.createElement("span");
      linkIcon.className = "heading-link";
      linkIcon.textContent = "\uD83D\uDD17"; // link emoji
      linkIcon.title = "Copy link to this page";
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

    // --- In-page table of contents (H3/H4/H5) rendered into the right sidebar ---
    buildRightToc(viewEl);
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
// RIGHT-PANE IN-PAGE TABLE OF CONTENTS + SCROLL SPY
// Populates the right sidebar with an ordered list of the current page's
// H3/H4/H5 headings, and highlights the one the reader is currently viewing
// as they scroll through the main pane.
// ==========================================================================

/** Minimum number of sub-headings on a page before we show the right pane. */
const TOC_MIN_HEADINGS = 3;

/** Cache of { link, heading } pairs for the current page's ToC. */
let TOC_ITEMS = [];
/** rAF handle used to throttle scroll-spy updates. */
let tocScrollRaf = null;

/**
 * Clears the right-pane ToC and collapses the column. Called on every
 * navigation so pages with no ToC (welcome, broken hash, short pages)
 * never inherit the previous page's entries.
 */
function resetRightToc() {
  if (tocNavEl) tocNavEl.innerHTML = "";
  TOC_ITEMS = [];
  appEl?.classList.add("toc-empty");
}

/**
 * Rebuilds the right-pane ToC from the headings currently rendered in
 * viewEl. Hides the pane (by collapsing the grid column) when there are
 * fewer than TOC_MIN_HEADINGS sub-headings, so short pages get the full
 * content width.
 */
function buildRightToc(root) {
  if (!tocNavEl) return;

  tocNavEl.innerHTML = "";
  TOC_ITEMS = [];

  const subHeadings = Array.from(root.querySelectorAll("h3, h4, h5"));

  if (subHeadings.length < TOC_MIN_HEADINGS) {
    appEl?.classList.add("toc-empty");
    return;
  }
  appEl?.classList.remove("toc-empty");

  for (const heading of subHeadings) {
    const level = heading.tagName[1]; // "3" | "4" | "5"
    // Ensure the heading has an id so the link can target it
    const anchor = heading.id || slugify(heading.textContent);
    if (!heading.id) heading.id = anchor;

    const link = document.createElement("a");
    link.href = `#${anchor}`;
    link.textContent = heading.textContent;
    link.dataset.level = level;
    link.dataset.targetId = anchor;
    link.addEventListener("click", (e) => {
      e.preventDefault();
      heading.scrollIntoView({ behavior: "smooth", block: "start" });
    });

    tocNavEl.appendChild(link);
    TOC_ITEMS.push({ link, heading });
  }

  // Paint the initial active state without waiting for a scroll event.
  updateTocActive();
}

/**
 * Scroll-spy: marks the nav item matching the heading nearest the top of
 * the main scroll pane as active. The "top" is offset slightly so a heading
 * is considered current once it has scrolled past the sticky width bar.
 */
function updateTocActive() {
  if (!tocNavEl || !mainEl || TOC_ITEMS.length === 0) return;

  const mainTop = mainEl.getBoundingClientRect().top;
  // Offset in px from the top of the main pane at which a heading flips to
  // "active". Kept slightly below the sticky width toggle so the highlight
  // updates when a heading scrolls under it, not just when it disappears.
  const activationOffset = 120;

  let activeId = TOC_ITEMS[0].heading.id;
  for (const { heading } of TOC_ITEMS) {
    const offsetFromMainTop = heading.getBoundingClientRect().top - mainTop;
    if (offsetFromMainTop <= activationOffset) activeId = heading.id;
    else break;
  }

  for (const { link } of TOC_ITEMS) {
    link.classList.toggle("active", link.dataset.targetId === activeId);
  }
}

/** rAF-throttled scroll handler wired to the main pane. */
function onMainScrollForToc() {
  if (tocScrollRaf) return;
  tocScrollRaf = requestAnimationFrame(() => {
    tocScrollRaf = null;
    updateTocActive();
  });
}

if (mainEl) mainEl.addEventListener("scroll", onMainScrollForToc, { passive: true });
window.addEventListener("resize", onMainScrollForToc, { passive: true });

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
// EXPORT PROGRESS OVERLAY
// Shows/hides a branded overlay with status text during PDF generation.
// ==========================================================================

const exportProgressEl = document.getElementById("exportProgress");
const exportProgressTextEl = document.getElementById("exportProgressText");

function showExportProgress(text) {
  if (exportProgressTextEl) exportProgressTextEl.textContent = text || "Exporting\u2026";
  if (exportProgressEl) exportProgressEl.hidden = false;
}

function updateExportProgress(text) {
  if (exportProgressTextEl) exportProgressTextEl.textContent = text;
}

function hideExportProgress() {
  if (exportProgressEl) exportProgressEl.hidden = true;
}

// ==========================================================================
// PDF EXPORT: SINGLE PAGE
// Exports the currently viewed page as a branded A4 PDF with
// letterhead logo, page numbers, and footer.
// ==========================================================================

async function exportCurrentPolicyPdf() {
  if (!CURRENT_POLICY) return;

  if (!window.html2pdf) {
    alert("PDF export library failed to load (html2pdf).");
    return;
  }

  showExportProgress(`Exporting "${CURRENT_POLICY.title}" to PDF\u2026`);

  const brand = getExportSettings();

  /**
   * Fetches a file and converts it to a base64 data URL.
   * Used to embed the letterhead logo into the PDF.
   */
  async function loadAsDataUrl(url) {
    const res = await fetch(url, { cache: "default" });
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
    resolveBookPaths(body);
    processCallouts(body);
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
    host.querySelectorAll('img[loading="lazy"]').forEach(img => img.removeAttribute("loading"));
    await waitForImages(host);

    // Generate a safe filename from the policy title
    const safeName = `${CURRENT_POLICY.title}`
      .replace(/[\\/:*?"<>|]+/g, "")
      .replace(/\s+/g, " ")
      .trim()
      .slice(0, 120) || "policy";

    // Load the letterhead logo from brand config as a data URL (if set)
    let letterheadLogoDataUrl = null;
    if (brand.header.logo) {
      const logoPath = resolveBrandPath(brand.header.logo, brand._basePath);
      letterheadLogoDataUrl = await loadAsDataUrl(logoPath);
    }

    // Footer text from brand config
    const footerLines = brand.footer.lines || [];
    const footerLine1 = footerLines[0] || "";
    const footerLine2 = footerLines[1] || "";
    const footerLine3 = footerLines[2] || "";
    const hasFooter = footerLines.some(l => l);

    const m = brand.margins;

    // html2pdf configuration
    const opt = {
      margin: [m.top, m.right, m.bottom, m.left],
      filename: `${safeName}.pdf`,
      image: { type: "jpeg", quality: 0.95 },
      html2canvas: {
        scale: 2,                   // 2x resolution for sharp text
        useCORS: true,
        allowTaint: false,
        backgroundColor: "#ffffff",
        logging: false
      },
      jsPDF: { unit: "mm", format: brand.pageSize, orientation: brand.orientation },
      pagebreak: {
        mode: ["css"]
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

        // Header: company logo (if brand has one)
        if (letterheadLogoDataUrl) {
          const logoW = brand.header.logoWidth || 40;
          const logoH = logoW / (brand.header.logoAspect || 4.04);
          const headerX = brand.header.x || 15;
          const headerY = brand.header.y || 8;
          pdf.addImage(letterheadLogoDataUrl, "PNG", headerX, headerY, logoW, logoH);
        }

        // Footer: company details centred, page number bottom-right
        pdf.setFontSize(brand.footer.fontSize || 9);
        pdf.setTextColor(brand.footer.color || 80);

        if (hasFooter) {
          const centerX = pageWidth / 2;
          pdf.text(footerLine1, centerX, pageHeight - 13, { align: "center" });
          pdf.text(footerLine2, centerX, pageHeight - 9, { align: "center" });
          pdf.text(footerLine3, centerX, pageHeight - 5, { align: "center" });
        }

        const pageLabel = `Page ${i} of ${pageCount}`;
        const textWidth = pdf.getTextWidth(pageLabel);
        pdf.text(pageLabel, pageWidth - m.right - textWidth, pageHeight - 5);
      }
    });

    await worker.save();

  } catch (e) {
    console.error(e);
    alert(String(e));
  } finally {
    staging?.remove();
    hideExportProgress();
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

  const totalPages = ALL_POLICIES.length;
  let pagesProcessed = 0;
  showExportProgress(`Exporting full manual\u2026 0 / ${totalPages} pages`);

  const brand = getExportSettings();

  /**
   * Fetches a file and converts it to a base64 data URL.
   * Used to embed the letterhead logo into the PDF.
   */
  async function loadAsDataUrl(url) {
    const res = await fetch(url, { cache: "default" });
    if (!res.ok) throw new Error(`Failed to load ${url}: ${res.status}`);
    const blob = await res.blob();
    return await new Promise((resolve, reject) => {
      const r = new FileReader();
      r.onload = () => resolve(r.result);
      r.onerror = reject;
      r.readAsDataURL(blob);
    });
  }

  // Page dimensions from brand settings
  const pageSizes = { a4: [210, 297], letter: [215.9, 279.4], legal: [215.9, 355.6] };
  const [defaultW, defaultH] = pageSizes[brand.pageSize] || pageSizes.a4;
  const pageW = brand.orientation === "landscape" ? defaultH : defaultW;
  const pageH = brand.orientation === "landscape" ? defaultW : defaultH;
  const m = brand.margins;
  const mTop = m.top, mLeft = m.left, mBottom = m.bottom, mRight = m.right;
  const usableW = pageW - mLeft - mRight;
  const usableH = pageH - mTop - mBottom;

  let staging; // Off-screen container for rendering

  try {
    // Load branding assets from brand config (if set)
    let letterheadLogoDataUrl = null;
    if (brand.header.logo) {
      const logoPath = resolveBrandPath(brand.header.logo, brand._basePath);
      letterheadLogoDataUrl = await loadAsDataUrl(logoPath);
    }
    const footerLines = brand.footer.lines || [];
    const footerLine1 = footerLines[0] || "";
    const footerLine2 = footerLines[1] || "";
    const footerLine3 = footerLines[2] || "";
    const hasFooter = footerLines.some(l => l);

    const defaultTitle = TOME_CONFIG.branding?.defaultTitle || "Manual";
    const docTitle = (document.getElementById("docTitle")?.textContent || defaultTitle).trim();
    const versionMeta = (document.getElementById("docMeta")?.textContent || "").trim();

    // Bootstrap a jsPDF instance from html2pdf's bundled copy
    let pdf = null;
    let firstPage = true;

    // Create the off-screen staging container
    staging = document.createElement("div");
    staging.style.cssText = "position:fixed;left:-10000px;top:0;width:980px;opacity:1;pointer-events:none;background:#fff;z-index:-1;";
    document.body.appendChild(staging);

    // Wait for web fonts to be ready
    if (document.fonts?.ready) {
      try { await document.fonts.ready; } catch { }
    }

    // Dummy render to extract the jsPDF instance from html2pdf's internals
    const _bootstrapEl = document.createElement("div");
    _bootstrapEl.style.cssText = "width:1px;height:1px;overflow:hidden;";
    staging.appendChild(_bootstrapEl);
    await window.html2pdf()
      .set({ margin: [mTop, mRight, mBottom, mLeft], jsPDF: { unit: "mm", format: brand.pageSize, orientation: brand.orientation }, html2canvas: { scale: 1, backgroundColor: "#ffffff" } })
      .from(_bootstrapEl).toPdf()
      .get("pdf").then(p => { pdf = p; });
    staging.removeChild(_bootstrapEl);

    /**
     * Renders a DOM element to a canvas, slices the canvas into
     * page-height strips, and appends each strip as a new page
     * in the master PDF document.
     *
     * @param {HTMLElement} el - The element to render.
     * @param {Function} [measureFn] - Optional callback invoked after the
     *   element is in the DOM but before canvas capture. Receives
     *   (el, elRect, scale) and can return arbitrary measurement data.
     * @returns {{ measured, slices: {yStart,yEnd,pageNum}[], pxPerMm }}
     */
    async function addElementToPdf(el, measureFn) {
      staging.appendChild(el);
      // Force eager loading — lazy images in an off-screen container
      // are deferred by the browser and never fire their load event.
      el.querySelectorAll('img[loading="lazy"]').forEach(img => img.removeAttribute("loading"));
      await waitForImages(el);

      // Measure heading positions before capturing to canvas.
      // - "keep zones" prevent slice boundaries from landing between a
      //   heading and its first content sibling (H2–H5).
      // - "force breaks" ensure H2s that follow body content (not H1)
      //   always start on a new page.
      const elRect = el.getBoundingClientRect();
      const scale = 2; // must match html2canvas scale
      const keepZones = [];
      const forceBreaks = []; // Y positions where a new page must start
      el.querySelectorAll("h2, h3, h4, h5").forEach(h => {
        const hRect = h.getBoundingClientRect();
        const top = (hRect.top - elRect.top) * scale;
        // Extend the zone to include the first content sibling
        let bottom = (hRect.bottom - elRect.top) * scale;
        const sib = h.nextElementSibling;
        if (sib) {
          const sibRect = sib.getBoundingClientRect();
          bottom = (sibRect.bottom - elRect.top) * scale;
        }
        keepZones.push({ top, bottom });

        // H2s force a page break unless they directly follow an H1
        if (h.tagName === "H2") {
          const prev = h.previousElementSibling;
          if (prev && prev.tagName !== "H1" && top > 0) {
            forceBreaks.push(top);
          }
        }
      });

      // Allow caller to measure DOM positions before canvas capture
      const measured = measureFn ? measureFn(el, elRect, scale) : null;

      const canvas = await window.html2canvas(el, {
        scale,
        useCORS: true,
        allowTaint: false,
        backgroundColor: "#ffffff",
        logging: false
      });

      staging.removeChild(el);

      if (canvas.width === 0 || canvas.height === 0) {
        return { measured, slices: [], pxPerMm: 0 };
      }

      const pxPerMm = canvas.width / usableW;
      const sliceHeightPx = Math.floor(usableH * pxPerMm);

      // Minimum slice height to prevent blank pages (10mm worth of pixels)
      const minSlicePx = Math.floor(10 * pxPerMm);

      const slices = [];
      let y = 0;
      while (y < canvas.height) {
        let sliceH = Math.min(sliceHeightPx, canvas.height - y);

        // Check for forced H2 breaks within this slice.
        // Find the FIRST force break that falls inside the slice,
        // but only if it would leave a meaningful amount of content.
        let forcedCut = false;
        for (const bp of forceBreaks) {
          if (bp > y + minSlicePx && bp < y + sliceH) {
            sliceH = Math.floor(bp - y);
            forcedCut = true;
            break;
          }
        }

        // If no forced cut, check keep zones — if the slice boundary
        // lands inside a keep zone, pull it back to before the heading,
        // but only if the resulting slice is tall enough.
        if (!forcedCut && y + sliceH < canvas.height) {
          for (const zone of keepZones) {
            if (y + sliceH > zone.top && y + sliceH < zone.bottom) {
              const adjusted = Math.floor(zone.top - y);
              if (adjusted >= minSlicePx) {
                sliceH = adjusted;
              }
              break;
            }
          }
        }

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
        const pageNum = pdf.internal.getNumberOfPages();
        pdf.addImage(imgData, "JPEG", mLeft, mTop, usableW, sliceHmm);
        firstPage = false;

        slices.push({ yStart: y, yEnd: y + sliceH, pageNum });
        y += sliceH;
      }

      return { measured, slices, pxPerMm };
    }

    /**
     * Maps a canvas-pixel Y position to the PDF page and Y offset (mm)
     * it falls on, using the slice boundaries from addElementToPdf.
     */
    function resolveCanvasY(slices, canvasY, pxPerMm) {
      for (const s of slices) {
        if (canvasY >= s.yStart && canvasY < s.yEnd) {
          return { page: s.pageNum, yMm: mTop + ((canvasY - s.yStart) / pxPerMm) };
        }
      }
      const last = slices[slices.length - 1];
      return last
        ? { page: last.pageNum, yMm: mTop + ((canvasY - last.yStart) / pxPerMm) }
        : null;
    }

    // --- COVER PAGE ---
    if (brand.coverPage) {
      const coverTitle = brand.coverTitle || docTitle;
      const cover = document.createElement("div");
      cover.className = "pdf-export";
      cover.innerHTML = `<h1 style="margin:0 0 8px 0;">${coverTitle}</h1><p style="margin:0;">${versionMeta}</p>`;
      await addElementToPdf(cover);
    }

    // --- CONTENTS PAGE (if enabled) ---
    const includeToc = document.getElementById("mdContentsPage")?.checked;
    let tocEntryPositions = [];  // { canvasY, groupIdx }
    let tocSlices = [];
    let tocPxPerMm = 0;
    const groupStartPages = [];  // page number where each group begins
    const backLinkPositions = []; // { page, yMm } for each group's "Back to Contents"

    if (includeToc) {
      const tocEl = document.createElement("div");
      tocEl.className = "pdf-export";
      let tocHtml = "<h1>Contents</h1>";
      GROUPS.forEach((g, gi) => {
        tocHtml += `<p data-toc-group="${gi}" style="margin:0 0 2px 0;font-weight:700;">${g.title}</p>`;
        tocHtml += "<ul style=\"margin:0 0 8px 0;padding-left:20px;\">";
        for (const p of g.policies) {
          tocHtml += `<li style="margin:0 0 1px 0;">${p.title}</li>`;
        }
        tocHtml += "</ul>";
      });
      tocEl.innerHTML = tocHtml;

      const tocResult = await addElementToPdf(tocEl, (el, elRect, scale) => {
        const entries = [];
        el.querySelectorAll("[data-toc-group]").forEach(node => {
          const r = node.getBoundingClientRect();
          // Measure the full group entry: from the H1 title to the end of its UL
          const ul = node.nextElementSibling;
          const bottom = ul ? ul.getBoundingClientRect().bottom : r.bottom;
          entries.push({
            groupIdx: parseInt(node.dataset.tocGroup, 10),
            top: (r.top - elRect.top) * scale,
            bottom: (bottom - elRect.top) * scale
          });
        });
        return entries;
      });

      tocSlices = tocResult.slices;
      tocPxPerMm = tocResult.pxPerMm;
      tocEntryPositions = tocResult.measured || [];
    }

    // --- CONTENT PAGES: render each group as a single block ---
    // The entire group (H1 + all policies) is rendered as one continuous
    // element. The keep-zone slicer handles page breaks, ensuring headings
    // are never separated from their following content.
    for (let gi = 0; gi < GROUPS.length; gi++) {
      const g = GROUPS[gi];
      pagesProcessed += g.policies.length;
      updateExportProgress(`Exporting full manual\u2026 ${pagesProcessed} / ${totalPages} pages`);

      const block = document.createElement("div");
      block.className = "pdf-export";

      let html = `<h1>${g.title}</h1>`;
      for (const p of g.policies) {
        html += md.render(p.mdText);
      }
      if (includeToc) {
        html += '<div data-back-to-contents style="margin:24px 0 0 0;padding:8px 0;border-top:1px solid #ddd;font-size:13px;"><span style="color:#0645ad;text-decoration:underline;cursor:pointer;">&#8592; Back to Contents</span></div>';
      }
      block.innerHTML = html;

      resolveBookPaths(block);
      processCallouts(block);
      applyIndent(block);

      const groupResult = await addElementToPdf(block, (el, elRect, scale) => {
        const backEl = el.querySelector("[data-back-to-contents]");
        return backEl
          ? { backY: (backEl.getBoundingClientRect().top - elRect.top) * scale,
              backH: (backEl.getBoundingClientRect().height) * scale }
          : null;
      });

      // Record first page of this group
      if (groupResult.slices.length) {
        groupStartPages[gi] = groupResult.slices[0].pageNum;
      }

      // Resolve "Back to Contents" link position
      if (includeToc && groupResult.measured && groupResult.slices.length) {
        const resolved = resolveCanvasY(groupResult.slices, groupResult.measured.backY, groupResult.pxPerMm);
        if (resolved) {
          const linkH = groupResult.measured.backH / groupResult.pxPerMm;
          backLinkPositions.push({ page: resolved.page, yMm: resolved.yMm, hMm: linkH });
        }
      }
    }

    // --- STAMP INTERNAL LINKS ---
    // TOC entries link to their group's first page;
    // "Back to Contents" links point back to the first TOC page.
    if (includeToc) {
      const tocFirstPage = tocSlices.length ? tocSlices[0].pageNum : 1;

      // TOC → group links
      for (const entry of tocEntryPositions) {
        const targetPage = groupStartPages[entry.groupIdx];
        if (!targetPage) continue;
        const top = resolveCanvasY(tocSlices, entry.top, tocPxPerMm);
        const bottom = resolveCanvasY(tocSlices, entry.bottom, tocPxPerMm);
        if (!top) continue;
        // Link may span a single page; use top's page
        const linkH = (bottom ? bottom.yMm - top.yMm : 10);
        pdf.setPage(top.page);
        pdf.link(mLeft, top.yMm, usableW, Math.max(linkH, 5), { pageNumber: targetPage });
      }

      // "Back to Contents" → TOC page links
      for (const bl of backLinkPositions) {
        pdf.setPage(bl.page);
        pdf.link(mLeft, bl.yMm, usableW, Math.max(bl.hMm || 5, 5), { pageNumber: tocFirstPage });
      }
    }

    // --- STAMP HEADERS AND FOOTERS ON EVERY PAGE ---
    const pageCount = pdf.internal.getNumberOfPages();
    for (let i = 1; i <= pageCount; i++) {
      pdf.setPage(i);

      // Header: company logo (if brand has one)
      if (letterheadLogoDataUrl) {
        const logoW = brand.header.logoWidth || 40;
        const logoH = logoW / (brand.header.logoAspect || 4.04);
        pdf.addImage(letterheadLogoDataUrl, "PNG", brand.header.x || 15, brand.header.y || 8, logoW, logoH);
      }

      pdf.setFontSize(brand.footer.fontSize || 9);
      pdf.setTextColor(brand.footer.color || 80);

      if (hasFooter) {
        const cx = pageW / 2;
        pdf.text(footerLine1, cx, pageH - 13, { align: "center" });
        pdf.text(footerLine2, cx, pageH - 9, { align: "center" });
        pdf.text(footerLine3, cx, pageH - 5, { align: "center" });
      }

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
    staging?.remove();
    hideExportProgress();
  }
}

// ==========================================================================
// MARKDOWN EXPORT
// Downloads raw markdown for the current policy or the full manual.
// ==========================================================================

/**
 * Triggers a file download from an in-memory string.
 */
function downloadText(filename, text) {
  const blob = new Blob([text], { type: "text/markdown;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(url);
}

/**
 * Exports the currently viewed policy as a standalone .md file.
 */
function exportCurrentPolicyMd() {
  if (!CURRENT_POLICY) {
    alert("No page is currently selected.");
    return;
  }
  const safeName = CURRENT_POLICY.title
    .replace(/[\\/:*?"<>|]+/g, "").replace(/\s+/g, " ").trim().slice(0, 140) || "policy";
  downloadText(`${safeName}.md`, CURRENT_POLICY.mdText.trim());
}

/**
 * Exports the entire loaded manual as a single .md file by fetching
 * the raw source file (same file the parser loaded).
 */
async function exportFullManualMd() {
  if (!CURRENT_BOOK) {
    alert("No manual is currently loaded.");
    return;
  }
  try {
    const mdText = await loadManualMd(CURRENT_BOOK);
    const docTitle = (document.getElementById("docTitle")?.textContent || "manual").trim();
    const safeName = docTitle
      .replace(/[\\/:*?"<>|]+/g, "").replace(/\s+/g, " ").trim().slice(0, 140) || "manual";

    const includeContents = document.getElementById("mdContentsPage")?.checked;
    if (includeContents && GROUPS?.length) {
      downloadText(`${safeName}.md`, injectMdContentsPage(mdText, GROUPS));
    } else {
      downloadText(`${safeName}.md`, mdText);
    }
  } catch (e) {
    console.error(e);
    alert(`Failed to export: ${e.message}`);
  }
}

/**
 * Injects a Contents H1 into the raw markdown and adds "Back to Contents"
 * links before every H2 heading. The contents page is inserted after the
 * document metadata block but before the first H1.
 */
function injectMdContentsPage(mdText, groups) {
  const lines = mdText.replace(/\r\n/g, "\n").split("\n");

  // Build the TOC block
  let toc = "# Contents\n\n";
  for (const g of groups) {
    const h1Anchor = slugify(g.title);
    toc += `- [${g.title}](#${h1Anchor})\n`;
    for (const p of g.policies) {
      const h2Anchor = slugify(p.title);
      toc += `  - [${p.title}](#${h2Anchor})\n`;
    }
  }

  // Find insertion point: after metadata, before first H1
  const metaPattern = /^Document\s+(Title|Version|Date|Classification):\s*/i;
  let insertAt = 0;
  for (let i = 0; i < Math.min(lines.length, 20); i++) {
    const trimmed = lines[i].trim();
    if (trimmed.startsWith("#")) break;
    if (metaPattern.test(trimmed) || trimmed === "") {
      insertAt = i + 1;
      continue;
    }
    break;
  }

  // Insert TOC after metadata
  lines.splice(insertAt, 0, "", toc, "---", "");

  // Add "Back to Contents" link before every H2
  const result = [];
  for (let i = 0; i < lines.length; i++) {
    if (/^##\s+/.test(lines[i])) {
      result.push("[Back to Contents](#contents)", "");
    }
    result.push(lines[i]);
  }

  return result.join("\n");
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
// MOBILE NAV DRAWER
// Hamburger button toggles the sidebar as a slide-out drawer on small screens.
// ==========================================================================

const navHamburger = document.getElementById("navHamburger");
const navBackdrop = document.getElementById("navBackdrop");
const asideEl = document.querySelector("aside");

function openDrawer() {
  if (!asideEl) return;
  navBackdrop.hidden = false;
  asideEl.classList.add("drawer-open");
}

function closeDrawer() {
  if (!asideEl) return;
  asideEl.classList.remove("drawer-open");
  asideEl.addEventListener("transitionend", () => {
    navBackdrop.hidden = true;
  }, { once: true });
}

if (navHamburger) navHamburger.addEventListener("click", () => {
  // Desktop: toggle sidebar collapse; Mobile: open drawer
  if (appEl?.classList.contains("sidebar-collapsed")) {
    appEl.classList.remove("sidebar-collapsed");
    localStorage.setItem("tome-sidebar", "open");
  } else {
    openDrawer();
  }
});
if (navBackdrop) navBackdrop.addEventListener("click", closeDrawer);

// Close drawer when a nav link is tapped (mobile navigation)
if (navEl) {
  navEl.addEventListener("click", (e) => {
    if (e.target.closest(".nav-h2") && asideEl?.classList.contains("drawer-open")) {
      closeDrawer();
    }
  });
}

// ==========================================================================
// SIDEBAR COLLAPSE (DESKTOP)
// Collapses sidebar to give full width to the reading pane.
// Persists state to localStorage.
// ==========================================================================

const sidebarCollapseBtn = document.getElementById("sidebarCollapse");

if (sidebarCollapseBtn && appEl) {
  sidebarCollapseBtn.addEventListener("click", () => {
    appEl.classList.add("sidebar-collapsed");
    localStorage.setItem("tome-sidebar", "collapsed");
  });

  // Restore saved state
  if (localStorage.getItem("tome-sidebar") === "collapsed") {
    appEl.classList.add("sidebar-collapsed");
  }
}

// ==========================================================================
// RIGHT-PANE (IN-PAGE ToC) COLLAPSE (DESKTOP)
// Mirror of the left sidebar collapse: internal chevron to hide, fixed
// top-right hamburger to reopen. State persists across pages & sessions.
// ==========================================================================

const tocCollapseBtn = document.getElementById("tocCollapse");
const tocHamburger = document.getElementById("tocHamburger");

if (tocCollapseBtn && appEl) {
  tocCollapseBtn.addEventListener("click", () => {
    appEl.classList.add("toc-collapsed");
    localStorage.setItem("tome-toc", "collapsed");
  });
}

if (tocHamburger && appEl) {
  tocHamburger.addEventListener("click", () => {
    appEl.classList.remove("toc-collapsed");
    localStorage.setItem("tome-toc", "open");
    // Refresh the scroll-spy highlight now that the pane is visible again.
    if (typeof updateTocActive === "function") updateTocActive();
  });
}

// Restore saved state on load
if (appEl && localStorage.getItem("tome-toc") === "collapsed") {
  appEl.classList.add("toc-collapsed");
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
// THEME PICKER
// Dropdown selector for colour themes. "system" defers to prefers-color-scheme;
// all others set data-theme on <html>. Choice persisted in localStorage.
// ==========================================================================

/** Available themes — value maps to data-theme, tone indicates light/dark for CSS */
const THEMES = [
  { value: "system", tone: null, label: "\u25D0  System" },
  { value: "dark", tone: "dark", label: "\u263E  Dark" },
  { value: "light", tone: "light", label: "\u2600  Light" },
  { value: "midnight", tone: "dark", label: "\u2726  Midnight" },
  { value: "ember", tone: "dark", label: "\u2622  Ember" },
  { value: "forest", tone: "dark", label: "\u2618  Forest" },
  { value: "sand", tone: "light", label: "\u2600  Sand" },
  { value: "terminal", tone: "dark", label: "\u25B6  Terminal" },
];

/**
 * Applies the given theme setting to the document.
 * Sets data-theme for colour tokens and data-tone (light/dark) for
 * broad light-vs-dark overrides. "system" removes both attributes,
 * letting prefers-color-scheme rule.
 */
function applyTheme(setting) {
  const theme = THEMES.find(t => t.value === setting);
  const root = document.documentElement;

  if (setting === "system" || !theme) {
    root.removeAttribute("data-theme");
    root.removeAttribute("data-tone");
  } else {
    root.setAttribute("data-theme", setting);
    if (theme.tone) {
      root.setAttribute("data-tone", theme.tone);
    } else {
      root.removeAttribute("data-tone");
    }
  }
  if (themePickerEl) themePickerEl.value = setting;
}

// Populate the theme picker dropdown
if (themePickerEl) {
  for (const t of THEMES) {
    const opt = document.createElement("option");
    opt.value = t.value;
    opt.textContent = t.label;
    themePickerEl.appendChild(opt);
  }

  themePickerEl.addEventListener("change", () => {
    localStorage.setItem("theme", themePickerEl.value);
    applyTheme(themePickerEl.value);
  });
}

// Initialise theme from localStorage (default: system)
const savedTheme = localStorage.getItem("theme") || "system";
applyTheme(savedTheme);

// ==========================================================================
// SETTINGS PANEL
// Slide-out panel with tabs for Settings, Guide, and About.
// ==========================================================================

const settingsBtn = document.getElementById("settingsBtn");
const settingsPanel = document.getElementById("settingsPanel");
const settingsBackdrop = document.getElementById("settingsBackdrop");
const settingsClose = document.getElementById("settingsClose");

function openSettings() {
  if (!settingsPanel) return;
  settingsPanel.hidden = false;
  settingsBackdrop.hidden = false;
  // Trigger reflow so the CSS transition plays
  void settingsPanel.offsetWidth;
  settingsPanel.classList.add("open");
}

function closeSettings() {
  if (!settingsPanel) return;
  settingsPanel.classList.remove("open");
  settingsPanel.addEventListener("transitionend", () => {
    settingsPanel.hidden = true;
    settingsBackdrop.hidden = true;
  }, { once: true });
}

if (settingsBtn) settingsBtn.addEventListener("click", openSettings);
if (settingsClose) settingsClose.addEventListener("click", closeSettings);
if (settingsBackdrop) settingsBackdrop.addEventListener("click", closeSettings);

// Close settings on Escape
window.addEventListener("keydown", (e) => {
  if (e.key === "Escape" && settingsPanel && settingsPanel.classList.contains("open")) {
    closeSettings();
  }
});

// Tab switching
document.querySelectorAll(".settings-tab").forEach((tab) => {
  tab.addEventListener("click", () => {
    // Deactivate all tabs and hide all content
    document.querySelectorAll(".settings-tab").forEach(t => t.classList.remove("active"));
    document.querySelectorAll(".settings-content").forEach(c => c.hidden = true);

    // Activate clicked tab and show its content
    tab.classList.add("active");
    const target = document.getElementById(`tab-${tab.dataset.tab}`);
    if (target) target.hidden = false;
  });
});

/**
 * Builds the brand picker dropdown in the export section of settings.
 * Always visible so the user can see which branding will be applied.
 */
function buildBrandPicker() {
  const container = document.getElementById("brandPickerGroup");
  const picker = document.getElementById("brandPicker");
  if (!container || !picker) return;

  container.hidden = false;
  picker.innerHTML = "";

  if (EXPORT_BRANDS.length === 0) {
    // No brands loaded — show a disabled fallback option
    const opt = document.createElement("option");
    opt.textContent = "No branding";
    opt.disabled = true;
    opt.selected = true;
    picker.appendChild(opt);
    picker.disabled = true;
  } else {
    picker.disabled = false;
    for (const b of EXPORT_BRANDS) {
      const opt = document.createElement("option");
      opt.value = b.id;
      opt.textContent = b.label;
      picker.appendChild(opt);
    }

    if (ACTIVE_BRAND) picker.value = ACTIVE_BRAND.id;

    picker.addEventListener("change", () => {
      ACTIVE_BRAND = EXPORT_BRANDS.find(b => b.id === picker.value) || EXPORT_BRANDS[0];
    });
  }
}

// Export buttons within settings panel
document.querySelectorAll(".settings-action[data-export]").forEach((btn) => {
  btn.addEventListener("click", async () => {
    closeSettings();
    // Small delay to let the panel close before potentially heavy export work
    await new Promise(r => setTimeout(r, 300));

    switch (btn.dataset.export) {
      case "policy-pdf": await exportCurrentPolicyPdf(); break;
      case "policy-md": exportCurrentPolicyMd(); break;
      case "manual-pdf": await exportFullManualPdf(); break;
      case "manual-md": await exportFullManualMd(); break;
    }
  });
});

// Populate About tab with library versions
function populateAbout() {
  const set = (id, val) => {
    const el = document.getElementById(id);
    if (el) el.textContent = val;
  };
  set("aboutPlatformVersion", PLATFORM_VERSION);
  set("aboutMarkdownIt", window.markdownit ? "14.1.0" : "not loaded");
  set("aboutMarkdownItAnchor", window.markdownItAnchor ? "9.1.0" : "not loaded");
  set("aboutHtml2pdf", window.html2pdf ? "0.10.1" : "not loaded");
  set("aboutHtml2canvas", window.html2canvas ? "1.4.1" : "not loaded");

  // Retry once for deferred scripts that may not have loaded yet
  if (!window.html2pdf || !window.html2canvas) {
    setTimeout(() => {
      set("aboutHtml2pdf", window.html2pdf ? "0.10.1" : "not loaded");
      set("aboutHtml2canvas", window.html2canvas ? "1.4.1" : "not loaded");
    }, 2000);
  }
}

// Apply platform branding from tome.json
function applyBranding() {
  const b = TOME_CONFIG.branding || {};

  // Sidebar top wordmark
  const wordmarkEl = document.querySelector(".tome-wordmark.tome-nav");
  if (wordmarkEl && b.sidebarTitle) wordmarkEl.textContent = b.sidebarTitle;

  // Settings > About title
  const aboutTitle = document.querySelector("#tab-about .tome-wordmark");
  if (aboutTitle && b.defaultTitle) aboutTitle.textContent = b.defaultTitle;
}

// Guide accordion toggles
document.querySelectorAll(".guide-toggle").forEach((btn) => {
  btn.addEventListener("click", () => {
    const body = btn.nextElementSibling;
    const isOpen = !body.hidden;
    body.hidden = isOpen;
    btn.classList.toggle("open", !isOpen);
  });
});

// Changelog toggle within the About tab
const changelogBtn = document.getElementById("changelogBtn");
const changelogView = document.getElementById("changelogView");
const changelogBack = document.getElementById("changelogBack");
const aboutMain = document.querySelector(".settings-about");

if (changelogBtn && changelogView && aboutMain) {
  changelogBtn.addEventListener("click", () => {
    aboutMain.hidden = true;
    changelogView.hidden = false;
  });
}

if (changelogBack && changelogView && aboutMain) {
  changelogBack.addEventListener("click", () => {
    changelogView.hidden = true;
    aboutMain.hidden = false;
  });
}

// ==========================================================================
// WIDTH TOGGLE
// Three-preset content width switcher (narrow / medium / wide).
// Persists choice to localStorage.
// ==========================================================================

(function () {
  const btns = document.querySelectorAll(".width-btn");
  const saved = localStorage.getItem("tome-width") || "medium";

  function apply(mode) {
    mainEl.dataset.width = mode;
    btns.forEach((b) => b.classList.toggle("active", b.dataset.width === mode));
    localStorage.setItem("tome-width", mode);
  }

  btns.forEach((b) => b.addEventListener("click", () => apply(b.dataset.width)));
  apply(saved);
})();
