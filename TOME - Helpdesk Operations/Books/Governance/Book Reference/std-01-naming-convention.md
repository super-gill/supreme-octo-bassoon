# Naming Convention

This document defines the naming convention used across the Helpdesk Operations Manual and its supporting assets. The scheme is aligned with ISO/IEC 27000-series terminology for documented information. It is designed so that every controlled artefact has a stable unique identifier, is unambiguously classified by type, and sorts predictably in any file browser or content management system.

## Document Properties

| Property | Details |
| -------- | ------- |
| Last Updated | 18/04/2026 |
| Updated By | Jason Mcdill |
| Owner | Jason Mcdill |

## Principles

The convention is built on four principles:

First, every artefact carries a **unique identifier** that does not change even if its title, location, or content does. References between documents use this identifier so that cross-references remain stable across renames or reorganisations.

Second, **the type of artefact is visible from its identifier**. A reader does not need to open a file to know whether they are looking at a policy, a procedure, a form, or a diagram - the three-letter prefix declares it up front.

Third, **hierarchy is encoded numerically**, not with nested prefixes. Section and document numbers within a book use simple dotted notation (e.g. `2.2.1`, `2.2.1.4`) that matches the document identifier, so the document ID `POL-02-02` maps directly to sections numbered `2.2.x`.

Fourth, **reserved prefixes are defined up front** to prevent collisions as the document set grows. Additional ISO-recognised types (Standard, Guideline, Work Instruction, Record) have prefixes allocated even where no documents currently exist under them.

## Type Prefixes

The ISO 27000-series defines a hierarchy of documented information types. The convention allocates a three-letter prefix to each recognised type. Currently in use are **POL**, **PRC**, **FRM**, and **DIA**. The remaining prefixes are reserved so that they can be adopted consistently when the document set expands.

| Prefix | Type | Definition | In use? |
| ------ | ---- | ---------- | ------- |
| `POL` | Policy | A governance document that defines rules, standards, and expectations - what must be done and why. Typically approved by executive sponsors and subject to formal review. | Yes - Governance book |
| `PRC` | Procedure | An authoritative sequence of steps that instructs how a specific task or activity is carried out. Subordinate to policy. | Yes - Procedures book |
| `FRM` | Form | A template used to capture information in a consistent structure. Becomes a record once completed. | Yes - supporting documents |
| `DIA` | Diagram | A visual reference (flowchart, matrix, framework, interactive diagram) embedded within or linked from policies and procedures. | Yes - supporting assets |
| `STD` | Standard | Mandatory specifics that support and expand a policy (e.g. a password complexity standard under a password policy). | Reserved |
| `GDL` | Guideline | Recommended (non-mandatory) good practice. | Reserved |
| `WIN` | Work Instruction | Step-by-step detail for a single action, narrower than a procedure. | Reserved |
| `REC` | Record | A completed form or evidence artefact retained to demonstrate compliance. | Reserved |

## Document ID Format

### Policies and Procedures

Policy and procedure documents use a three-segment identifier:

```
PREFIX-SS-DD
```

- `PREFIX` - three letters indicating type (`POL` or `PRC`)
- `SS` - two-digit section number within the book (01–99)
- `DD` - two-digit document number within that section (01–99)

Examples:

| ID | Meaning |
| -- | ------- |
| `POL-02-02` | Governance book, section 2 (Ticket Lifecycle & Classification), document 2 (Triage Policy) |
| `PRC-02-14` | Procedures book, section 2 (Halo PSA Operations), document 14 (AM Quote Process) |

### Forms and Diagrams

Forms and diagrams use a two-segment identifier because they are flat, not sectioned:

```
PREFIX-NN
```

- `PREFIX` - `FRM` or `DIA`
- `NN` - two-digit sequential number

Forms and diagrams are scoped to the book they belong to. That is, `Governance/Forms/FRM-01` and (if one existed) `Procedures/Forms/FRM-01` are independent identifiers within their own books.

## File Naming

Files include the identifier followed by a dash and a kebab-case slug derived from the document title:

```
POL-02-02-triage-policy.md
PRC-02-14-am-quote-process.md
FRM-01 - Service Transition Review (STR).docx
DIA-02 - CLS Priority Matrix.png
```

Policies and procedures use kebab-case slugs (no spaces) for portability in URLs and content systems. Forms and diagrams retain their readable titles after the ID because they are referenced primarily by title in other documents.

## Folder Naming

Section folders use the book prefix, two-digit section number, and a readable section name:

```
POL-02 - Ticket Lifecycle & Classification/
PRC-05 - N-Able TakeControl Operations/
```

Assets are grouped into type-named folders under each book:

```
Governance/Diagrams/
Procedures/Diagrams/
```

Downloadable assets - forms (`.docx`), interactive diagrams (`.html`), and any other file type that the static-site generator does not treat as an auto-imported asset - live under a top-level `public/` directory, mirroring the book namespace:

```
public/Governance/Forms/
public/Governance/Diagrams/    (HTML diagrams only)
public/Procedures/Forms/       (reserved)
public/Procedures/Diagrams/    (reserved)
```

Image diagrams (`.png`, `.jpg`, `.svg`, etc.) stay in the per-book `Diagrams/` folder because VitePress auto-copies them when they are referenced relatively from a markdown file. Downloadable file types are not auto-copied by VitePress, so they must sit in `public/` to be served at build time.

## Section Numbering Within Documents

Each document's headings are numbered hierarchically using the document ID as the prefix. The numbering starts at H2 - the H1 is the document title and is left unnumbered.

For a document with ID `POL-02-02`, headings are numbered:

```
# Triage Policy                    (unnumbered - document title)
## 2.2.1 Document Control
### 2.2.1.1 Document Properties
### 2.2.1.2 Revision History
## 2.2.2 Purpose
## 2.2.3 Scope
## 2.2.4 Types of Triage
### 2.2.4.1 Procedural Triage
### 2.2.4.2 Conventional Triage
```

The pattern is `{section}.{doc}.{h2}.{h3}.{h4}…`. Counters reset when a parent heading advances: so `2.2.4.1` and `2.2.4.2` both sit under `## 2.2.4 Types of Triage`, and the next `## 2.2.5 …` resets the H3 counter back to 1.

Procedure files follow the same rule. A procedure with ID `PRC-02-14` would have headings numbered `2.14.1`, `2.14.2`, etc.

## Cross-References

References between documents use the relative path to the target file, not the bespoke `tome://` scheme from the previous platform. From a procedure file referencing a governance policy, the link looks like this:

```
href="../../Governance/POL-03 - Non-Critical Ticket Handling/POL-03-02-ticket-status-usage-policy.md"
```

Asset references follow two rules depending on asset type.

**Image diagrams** (`.png`, `.jpg`, `.svg`, etc.) are referenced with a relative path up to the book root:

```
src="../Diagrams/DIA-02 - CLS Priority Matrix.png"
```

**Downloadable assets** (`.docx` forms, `.html` diagrams, and similar) are referenced with a relative path up to the book root, the same way image diagrams are. File names use the kebab-case slug (no spaces, no parentheses) so no URL encoding is needed. The display text should still use the readable title of the asset. Form links should include a `download` attribute so the browser treats them as downloads rather than attempting to preview:

```
<a href="../Forms/frm-001-service-transition-review-str.docx" download>Service Transition Review (STR)</a>
<a href="../Diagrams/dia-05-swarm-flow.html" target="_blank">Swarm Flow</a>
```

The display text in the link should describe the target in human terms (including any section path). The underlying path handles the routing.

## Version Control

Each document carries its own version history in a Document Control section. The document's version is independent of the ID - the ID stays stable across versions, and the version increments as the document is revised.

For the Procedures book, Document Control is maintained at the section level rather than per-procedure (because procedures within a section are authored and reviewed as a set). Individual procedures carry a lightweight Last Update table that records the most recent change.

## Adding New Documents

When authoring a new document:

1. **Choose the right prefix.** Is it a policy (POL), procedure (PRC), form (FRM), or diagram (DIA)? If the type is something else, consult the reserved prefixes above and add documentation for it.
2. **Allocate the next sequential number** within the appropriate section. Check the relevant document register first to avoid collisions.
3. **Name the file and folder** using the conventions described above.
4. **Number headings** starting at H2 using the document's ID as the prefix.
5. **Add a Document Control block** covering properties, revision history, executive sponsors, and stakeholders. For procedures, use the lightweight Last Update table instead.
6. **Update the document register** for the relevant book.
7. **If the document is retired**, mark it as such in the register rather than deleting it - the identifier should remain retired, not reused.

## Related Documents

- [Governance Document Register](Governance/document-register.md)
- [Procedures Document Register](Procedures/document-register.md)