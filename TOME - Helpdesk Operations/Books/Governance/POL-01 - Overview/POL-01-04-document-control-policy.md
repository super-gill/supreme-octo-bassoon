# Document Control Policy

## 1.4.1 Document Control

### 1.4.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 18/04/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 1.4.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 18/04/2026 | 01/10/2026  |

### 1.4.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
|         |                    |            |

### 1.4.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 18/04/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 18/04/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 18/04/2026 |

## 1.4.2 Purpose

To ensure that every controlled document within the Helpdesk Operations Manual is created, approved, maintained, and retired in a consistent and auditable way. This policy establishes the lifecycle, roles, and evidence requirements for documented information, and is the governance mechanism that protects the integrity of every other policy, procedure, form, and diagram in the manual.

This policy operates alongside the [Naming Convention](../../Naming%20Convention.md), which defines the identifier structure and file layout used across the manual. This policy defines *how* documents move through their lifecycle; the Naming Convention defines *what* they are called and *where* they sit.

## 1.4.3 Scope

This policy applies to all controlled documents within the Helpdesk Operations Manual, including:

- Policies (`POL-`)
- Procedures (`PRC-`)
- Forms (`FRM-`)
- Diagrams (`DIA-`)
- The Governance and Procedures document registers
- The Naming Convention document itself

It applies to every stage of a document's life: proposal, drafting, review, approval, publication, revision, and retirement. It also covers structural changes such as the addition or removal of entire sections within a book.

Uncontrolled working notes, draft content held outside the manual, and informal knowledge articles are out of scope. Those should be promoted into a controlled document under this policy if they become authoritative.

## 1.4.4 Document Lifecycle

Every controlled document exists in exactly one of the following lifecycle states at any time. The state is tracked in the relevant document register.

| State        | Meaning                                                      |
| ------------ | ------------------------------------------------------------ |
| Placeholder  | Reserved identifier with no authored content yet. Not for reference in decision-making. |
| Draft        | Under active authoring or revision. Content is indicative and must not be treated as in force. |
| Published    | Approved and in force. Expected to be followed as written.   |
| Not Enforced | Published but explicitly not being enforced operationally. Recorded as such in the register. |
| Retired      | Previously published, now withdrawn. The file and identifier are preserved; the register marks the retirement date and (where relevant) any replacing document. |

Transitions between states are owned by the Document Owner, with approval from Executive Sponsors required for transitions into and out of the Published state. All transitions are recorded in the document's Revision History and in the document register.

## 1.4.5 Roles and Authority

### 1.4.5.1 Document Owner

Every controlled document has exactly one Owner recorded in its Document Properties table. The Owner is accountable for the accuracy, review schedule, and lifecycle of the document. The Owner may delegate authoring or review tasks but retains accountability.

### 1.4.5.2 Author

The Author is the individual making a specific change to a document. Each entry in the Revision History records the Author of that version. The Author may be the Owner or a delegate.

### 1.4.5.3 Executive Sponsors

Executive Sponsors are named in each document's Document Control block and approve the document before it transitions to Published. Sponsor sign-off is recorded with the version and date it applied to. A Published document without at least one recorded Executive Sponsor signature for its current version is not considered in force.

### 1.4.5.4 Stakeholders

Stakeholders are named individuals who must be aware of the document and any changes to it. They do not have approval authority but must be notified when the document moves to or from Published state.

## 1.4.6 Creating a New Document

The following steps apply when creating a new policy, procedure, form, or diagram.

1. **Confirm the need.** Check the relevant document register to ensure the proposed content is not already covered. If it overlaps materially with an existing document, revise the existing document rather than creating a new one.
2. **Allocate an identifier.** Consult the target section in the register and allocate the next sequential number. Identifiers are not reused; once allocated, the identifier belongs to that document permanently, even after retirement.
3. **Name the file and folder** per the Naming Convention.
4. **Author the document in Draft state.** Populate the Document Control block with Owner, initial Revision History entry (version 1.0, Draft), and Stakeholder list. Leave Executive Sponsors empty until approval.
5. **Number the headings** from H2 downward using the document's identifier as the prefix, per the Naming Convention.
6. **Review with stakeholders.** Circulate the Draft to the stakeholders listed. Incorporate feedback as minor revisions (1.0 → 1.1 within Draft) until the content is stable.
7. **Seek Executive Sponsor approval.** Once stable, submit to Executive Sponsors. Record each sponsor's approval in the Executive Sponsors table.
8. **Transition to Published.** Update the Document Properties, add a Revision History entry marking the published version, and update the relevant document register.
9. **Notify stakeholders** of the new Published document.

## 1.4.7 Updating a Published Document

Changes to a Published document are classified as either Minor or Major.

**Minor change** - correction of typos, reformatting, clarification of existing content, or updates that do not alter the meaning or enforceability of the document. Requires:

- New Revision History entry
- Patch-level version bump (e.g. 1.2 → 1.3)
- No Executive Sponsor re-approval needed unless explicitly requested by a sponsor
- Notification to stakeholders is optional for purely cosmetic changes

**Major change** - addition, removal, or alteration of requirements, scope, roles, or expectations; any change that a reader acting on the previous version might reasonably have handled differently. Requires:

- New Revision History entry
- Minor version bump for substantial additions (e.g. 1.2 → 2.0), or patch bump for targeted changes that nonetheless change meaning (e.g. 1.2 → 1.3)
- Re-approval by current Executive Sponsors
- Notification to stakeholders before or at the point of publication
- Change Log entry in the book's Changes document summarising what changed and why

Where there is doubt about whether a change is Minor or Major, it is treated as Major.

## 1.4.8 Review Cadence

Every Published document carries a Next Review date in its Revision History. The default review cadence is:

| Document Type | Default Cadence | Notes |
| ------------- | --------------- | ----- |
| Policy (POL)  | Every 6 months  | Shortened to 3 months for a policy in its first year, or following a significant operational incident affecting the policy's subject. |
| Procedure (PRC) | Rolling, reviewed whenever the underlying tool or workflow changes | Individual procedures carry a Last Update date; section Document Control carries the formal review date. |
| Form (FRM)    | Reviewed with the governing policy | A form is reviewed whenever its governing policy is reviewed. |
| Diagram (DIA) | Reviewed with the governing document | A diagram is reviewed whenever the document that embeds it is reviewed. |

A review does not necessarily result in a change. Where a review concludes that no change is needed, this is recorded by updating the Last Updated property and incrementing the patch version (e.g. 1.2 → 1.3) with a Revision History entry of "Reviewed; no changes required."

Overdue reviews (Next Review date in the past) are raised to the Document Owner by the Helpdesk Team Leader as part of monthly register review.

## 1.4.9 Retiring a Document

A document is retired when it is superseded, no longer applicable, or permanently withdrawn. Retirement is handled as follows.

1. The Document Owner proposes retirement, with the reason and (if applicable) the replacing document's identifier.
2. Executive Sponsors approve the retirement. Their approval is recorded in the Revision History with a state transition entry (e.g. "Retired; replaced by POL-XX-YY").
3. The document's file is preserved in place. The content is not deleted. A clear "RETIRED" notice is added at the top of the document, with the retirement date and any replacing identifier.
4. The document register is updated to mark the document as Retired, with the retirement date and replacement reference.
5. Any cross-references from other documents pointing to the retired document are updated to point to the replacement, or removed where no replacement exists.

**Identifiers are never reused.** A retired `POL-03-09` identifier remains retired; a future document on similar subject matter receives the next available identifier in that section.

## 1.4.10 Adding or Removing Sections

Adding a new section to a book (e.g. a new `POL-11`) or retiring an existing section is a structural change and follows the same lifecycle rules as an individual document, applied at section scope.

1. The proposal is raised to the Helpdesk Team Leader with rationale for the new or removed section and the expected document set beneath it.
2. Executive Sponsors approve the structural change before any files are moved or created.
3. Section numbers are allocated from the next available integer. **Section numbers are never reused**, for the same reason document identifiers are not reused - existing references must remain unambiguous.
4. The Naming Convention document is updated to reflect the new or retired section.
5. The document register is regenerated to reflect the new structure.
6. A Change Log entry is recorded in the book's Changes document.

Reordering of existing sections (i.e. renumbering a Published section) is not permitted. If the conceptual order needs to change, this is handled in presentation (e.g. table of contents, navigation) rather than by renumbering identifiers.

## 1.4.11 Register Maintenance

The Governance and Procedures document registers are themselves controlled documents. They are regenerated whenever any of the following occurs:

- A document is added, retired, or re-versioned
- A document's Owner or Next Review date changes
- A new section is added or an existing section retired
- A form or diagram is added, retired, or reallocated between governing policies

Registers are regenerated in full (not edited by hand) to ensure they remain consistent with the underlying documents. The Helpdesk Team Leader is responsible for the registers.

## 1.4.12 Deviation Handling

Where a published policy is found to be unworkable, unclear, or in conflict with real operational constraints, this is treated as a signal that the policy requires revision rather than a justification for informal deviation.

Agents raise the issue through their Team Leader. The Document Owner assesses the issue and, where change is warranted, initiates an update per the Major or Minor change process described above. Adherence to a written process, even where that process does not produce the desired outcome in a specific instance, is never grounds for disciplinary action.

Where an urgent operational need makes compliance with a published policy impossible in the short term, the deviation is logged in the ticket (for incident-related deviations) or raised to the Helpdesk Manager (for process-wide deviations), and the document is revised as priority.

## 1.4.13 How we measure compliance

Compliance is assessed through:

- **Register review** - monthly review by the Helpdesk Team Leader of both document registers, identifying overdue reviews, placeholders that have remained unchanged for extended periods, and inconsistencies between register state and underlying document state.
- **Sample audits** - quarterly sampling of a small number of Published documents to verify that Revision History, Executive Sponsor approval, and cross-references are consistent and current.
- **Cross-reference integrity checks** - periodic link validation across the manual, confirming that every relative reference resolves to an existing file.
- **Change evidence** - every Major change has a corresponding Executive Sponsor approval entry and a Change Log entry; absence of either is a compliance failure.

## 1.4.14 Record keeping and documentation

The Revision History of each document, together with the Change Log in each book's Changes document, forms the permanent record of all changes to documented information. These records are preserved indefinitely and are not edited retrospectively except to correct factual errors in prior entries (which are themselves recorded as a corrective entry, not a rewrite).

The document registers are regenerated on change and do not themselves preserve historical state; historical state lives in the underlying documents' Revision Histories.

## 1.4.15 How we address shortfall

Shortfall in document control - overdue reviews, unapproved Published documents, broken cross-references, missed Change Log entries - is raised to the Document Owner by the Helpdesk Team Leader during register review. Persistent or material shortfall is escalated to the Helpdesk Manager.

Document control shortfall is treated as a governance issue rather than individual performance failure in the first instance, since gaps typically reflect process weaknesses. Where an individual Owner repeatedly fails to maintain the documents they own despite coaching, the matter is handled under the Disciplinary Process.
