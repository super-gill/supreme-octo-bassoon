# Customer Equipment Chain of Custody

## 5.6.1 Document Control

### 5.6.1.1 Document Properties

| Property | Details |
| -------- | ------- |
| Last Updated | 05/05/2026 |
| Updated By | Jason Mcdill |
| Owner | Jason Mcdill |

### 5.6.1.2 Revision History

| Version | Author | Date | Next Review |
| ------- | ------ | ---- | ----------- |
| 1.0 | Jason Mcdill | 05/05/2026 | 05/06/2026 |

### 5.6.1.3 Executive Sponsors

| Version | Author | Date |
| ------- | ------ | ---- |
| 1.0     | Stephen Richardson | 19/03/2026 |
| 1.0     | Rupert Evans       | 19/03/2026 |

### 5.6.1.4 Stakeholder / Distribution List

| Name | Title | Business Unit | Date |
| ---- | ----- | ------------- | ---- |
| Jason Mcdill | Helpdesk Team Leader | Customer Helpdesk | 05/05/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 05/05/2026 |
| Neels Steyn | Technical Manager | Customer Helpdesk | 05/05/2026 |

> [!INFO] This policy has an uncontrolled summary document for accessibility, see related documents: <a href="../customer-equipment-chain-of-custody-summary.pdf" download>Customer Equipment Chain of Custody — Accessibility Summary</a>

## 5.6.2 Purpose

To define the requirement for chain-of-custody recording on all customer equipment passing through Digital Origin's care, the artefacts used to maintain that record, and the responsibilities at each stage.

Customer equipment is anything owned by a customer that physically enters Digital Origin's custody, however briefly. This includes new hardware delivered to us for build, devices recovered from sites for refurbishment or decommission, equipment in transit between customer locations, and any other physical asset where Digital Origin has temporary or transitional responsibility.

Without an enforced chain of custody, equipment goes missing, condition disputes arise, accountability gaps emerge, and customer-data-bearing devices create information security risk. This policy closes that gap.

## 5.6.3 Scope

This policy applies to:

- All customer-owned equipment held by Digital Origin at any time, by any team (Helpdesk, Proactive, Builds, Field, Service Delivery, Account Management, anyone).
- All staff members who take physical custody of customer equipment, even briefly.
- Movements of customer equipment between Digital Origin staff, between Digital Origin and customer sites, and between Digital Origin and third parties (couriers, vendors, disposal contractors).

Out of scope:

- Customer equipment installed in the customer's own environment that Digital Origin only accesses remotely. This is not in our custody.
- Digital Origin-owned equipment used internally. This is covered by POL-05-05 Tooling and Asset Management Standards.

## 5.6.4 The recording model

Three artefacts work together. Each has a distinct role and a distinct lifetime.

### 5.6.4.1 The work ticket (Halo PSA)

The ticket is the live system of record while the equipment is in our custody. It holds the customer, the equipment description, the reason for custody, the customer-data-bearing assessment, and the status of the work.

The ticket is queried for "what is currently in our custody, where is it, and why". The chain-of-custody form sits underneath the ticket but is not the live state.

### 5.6.4.2 The travelling form (FRM-06)

A printed document that physically follows the equipment from receipt to final departure. It is opened at the moment of receipt, signed at every transfer of physical custody, and closed at final disposition.

The form has four sections:

- **Equipment Identification** (customer name, serial number, linked ticket reference). Captured once at form opening.
- **Initial Receipt into Digital Origin Custody** (date and time, received by, received from, condition notes). Captured once at form opening.
- **Chain of Custody Events** (transfers that follow, one row per transfer, both parties signing).
- **Form Closure** (form opened/closed dates, event count, closing signatory, Helpdesk Team Leader review signature).

The form is authoritative for the chain itself. While in flight, it lives with the equipment.

### 5.6.4.3 The aggregate register (FRM-07)

A controlled spreadsheet that records every completed FRM-06 form after it is returned, reviewed, and lodged. One row per processed form.

The register is a searchable index. Its job is to answer "where is the FRM-06 form for serial number X, customer Y, ticket Z" and to give the Helpdesk Team Leader a periodic audit base.

The register is not a live custody tracker. Equipment in custody is tracked through Halo and the physical form, not through the register.

## 5.6.5 What constitutes a chain-of-custody event

A chain-of-custody event is any transition of physical possession of customer equipment. Specifically:

- Equipment received into Digital Origin's custody from the customer, a courier, or a third party. Captured in the form's Initial Receipt section, not in the events table.
- Equipment passed from one Digital Origin staff member to another. Events table.
- Equipment moved between Digital Origin physical locations where this involves a change of custodian. Events table.
- Equipment dispatched to a courier or third party for transport. Events table.
- Equipment delivered to the customer or to a customer-nominated location. Events table; closing event.
- Equipment handed to a disposal contractor or vendor for return, repair, or decommission. Events table; closing event.

Condition observations between transfers (for example, damage discovered while a single custodian holds the equipment) are recorded at the next transfer event in the Condition column. If a condition change is significant enough to warrant its own record before the next transfer, the custodian raises a self-transfer event (From and To both being themselves) with the condition note.

Status changes that do not involve physical possession (a build flagged as complete, a device flagged as ready for handover) are not chain-of-custody events. They sit on the ticket.

## 5.6.6 When a chain of custody starts

A chain of custody starts the moment customer equipment enters Digital Origin's custody. Specifically:

- When a courier delivers customer equipment to a Digital Origin location.
- When a Digital Origin staff member takes physical possession of customer equipment from a customer site, customer-nominated person, or third party.
- When Digital Origin acquires customer equipment from a vendor on the customer's behalf and takes possession.

The receiving staff member prints a fresh FRM-06, completes the Equipment Identification and Initial Receipt sections, and attaches it to or accompanies it with the equipment. From that point, the form is live and is updated at every subsequent transfer.

The receiving staff member also ensures the relevant Halo ticket is flagged as having equipment in Digital Origin custody. Where no ticket exists yet, one is created.

A piece of customer equipment in Digital Origin's custody without an open FRM-06 form is a process failure. It is treated as such and remediated immediately when discovered.

## 5.6.7 Required information at each event

### 5.6.7.1 Initial receipt

Captured in the Initial Receipt section of the form:

- Date and time of receipt.
- The Digital Origin staff member receiving (name).
- The party handing over (name and organisation: customer representative, courier, third party).
- Condition of the equipment at receipt.

The receiver records their name. A counter-signature from the handing-over party is captured when practical (for example, a customer-site collection where the customer representative is present). Where the handing-over party is not available to counter-sign (for example, a courier dropping a parcel and leaving), this is acceptable for general equipment but is escalated for customer-data-bearing devices per 5.6.8.

### 5.6.7.2 Chain-of-custody events

Captured one row per transfer in the events table:

- Date and time.
- From (name and organisation).
- To (name and organisation).
- Reason or activity (the "why" of the transfer).
- Condition at the point of transfer.
- Signatures of both the handing-over and receiving parties.

For dispatch events to a courier where the customer-side receiving signature is captured later through whatever mechanism the courier provides, the form is annotated with the dispatch and the receiving signature is captured later or evidenced by the courier's proof-of-delivery, attached to the ticket.

### 5.6.7.3 Form closure

Captured in the Form Closure section by the closing custodian:

- Date the form was opened.
- Date the form was closed.
- Number of events recorded. The closer counts events and writes the number.
- Name of the closing staff member.

The closing custodian then returns the completed form to the Helpdesk Team Leader for review. The Helpdesk Team Leader review signature, date of review, and lodgement against the register are completed during processing (see 5.6.10).

## 5.6.8 Customer-data-bearing devices

Devices that hold customer data, particularly devices recovered for refurbishment or decommission, require additional handling on top of the standard chain-of-custody requirements:

- Custody transfer is counter-signed by both parties at every transition without exception. A "courier delivered and left" event is acceptable for general equipment but not for customer-data-bearing devices, which require a controlled handover with a counter-signed recipient.
- The device is not stored in vehicles or unsecured locations except for the briefest necessary period in transit.
- Data on the device is not accessed except as authorised by the work in progress.
- Loss, theft, or unrecorded transition of a customer-data-bearing device invokes POL-05-03 Information Security and Data Handling immediately.

The customer-data-bearing assessment is held on the Halo ticket. The receiving staff member confirms the assessment is set on the ticket at form opening.

## 5.6.9 Roles and responsibilities

### 5.6.9.1 The receiving staff member

The person who first takes Digital Origin custody of the equipment is responsible for:

- Printing a fresh FRM-06 form.
- Completing the Equipment Identification section.
- Completing the Initial Receipt section.
- Confirming the relevant Halo ticket reflects equipment-in-custody status (creating one if necessary), and that the customer-data-bearing assessment is set on the ticket.

### 5.6.9.2 Each subsequent custodian

Every staff member who takes custody after the initial receipt is responsible for:

- Confirming the form is up to date when they receive the equipment.
- Recording the transfer event in the events table when they take and hand over custody.
- Signing the form at receipt and at handover.

### 5.6.9.3 The closing staff member

The person who hands the equipment back to the customer or to a final destination is responsible for:

- Recording the closing transfer in the events table.
- Capturing the receiving signature where available.
- Completing the Form Closure section (open date, close date, event count, closer name).
- Returning the completed form to the Helpdesk Team Leader.
- Updating the Halo ticket to reflect that the equipment has left Digital Origin custody.

### 5.6.9.4 The Helpdesk Team Leader

The Helpdesk Team Leader is responsible for processing each returned form:

- Reviewing the form for completeness (signatures, condition entries, event-count cross-check).
- Signing the Helpdesk Team Leader review section of the form.
- Scanning the completed form and attaching the scan to the relevant Halo ticket. Where no ticket exists, the scan is filed in the controlled records location.
- Adding a row to the FRM-07 register recording the form's existence, identifiers, and filing location.
- Periodic audit (see 5.6.11).
- Resolving incomplete or disputed records.
- Investigating loss or theft events under POL-05-03.

## 5.6.10 The register: practical operation

### 5.6.10.1 Entry timing

A register row is created once per form, at the point the Helpdesk Team Leader processes it. There are no in-flight register entries. The register is a closure-only archive.

### 5.6.10.2 Register fields

Each row carries:

- Form ID (Digital Origin reference, format COC-YYYY-NNNN, assigned at processing).
- Date processed.
- Customer (from the form).
- Serial number (from the form).
- Linked ticket reference (from the form; "no ticket" recorded explicitly where none exists).
- Form opened (from the form).
- Form closed (from the form).
- Events recorded (from the form's closure section).
- Closed by (from the form).
- Filed at (Halo attachment reference, or filing path where no ticket exists).
- Status (Processed, Disputed, Loss recorded).
- Review notes (any observations from the HDTL review: missing signatures, condition gaps, event-count mismatches, etc.).

### 5.6.10.3 Register implementation

The register is implemented as the FRM-07 controlled spreadsheet. Migration to a configured asset register within Halo PSA may follow under POL-05-05; this policy will be updated when that happens.

## 5.6.11 Audit

The register and a sample of forms are audited periodically. Suggested cadence: monthly during the first 3 months of operation, then quarterly.

The audit covers:

- **Form completeness**: a sample of register rows is pulled and the corresponding scanned forms inspected. Reviewers check for missing events, missing signatures, condition gaps, and event-count mismatches between the closure section and the events table.
- **Register completeness**: a sample of recent processed forms is checked back against the register to confirm a row exists and the filing location is correct.
- **Stale or unreturned forms**: the Helpdesk Team Leader queries Halo for tickets flagged as equipment-in-custody for an unusual length of time, and confirms either that the equipment is genuinely still in custody (with a current form in flight) or that a form has been returned and processed.
- **Lost or unaccounted items**: investigation and write-off where appropriate, recorded in the register with status "Loss recorded".

Audit outcomes are reviewed at the annual review of this policy.

## 5.6.12 Loss, theft, and unrecorded transitions

Where customer equipment is found to be missing, stolen, or to have transitioned without being recorded:

- The Helpdesk Team Leader is notified at the earliest safe opportunity, no later than end of the working day.
- A written record is made within 24 hours and attached to the Halo ticket.
- The customer is informed where appropriate, with timing and content agreed with Account Management.
- POL-05-03 Information Security and Data Handling is invoked where customer data may be involved.
- A register row is created with status "Loss recorded" and a reference to the written record.

Loss or theft attributable to negligence is handled through the disciplinary process. Loss or theft attributable to circumstance is treated as an operational event and reviewed for systemic improvements.

## 5.6.13 Relationship with other policies

This policy interacts with:

- **POL-05-05 Tooling and Asset Management Standards** holds the overall asset register and lifecycle. POL-05-06 (this policy) is the custody-tracking layer that applies specifically to customer equipment.
- **POL-05-03 Information Security and Data Handling** applies whenever customer-data-bearing devices are in custody.
- **POL-12-03 Build Standards and Quality Control** requires this policy's form to be active for any device passing through Builds.
- **POL-13-04 Asset Chain of Custody (Field)** is the Field-specific operational expression of this policy. Field engineers follow both: this policy for the principles, POL-13-04 for the field operating detail.
- **POL-12-05 Customer Handover Protocol** governs the closing event for builds.

## 5.6.14 How we measure compliance

Compliance is assessed through:

- Audit outcomes (5.6.11).
- Loss and theft rates.
- Form completeness on processed records, including event-count cross-checks.
- Register completeness against returned forms.
- Pattern of unrecorded transitions discovered after the fact.
- Time-to-process: the lag between a form being returned and a register row being created.

## 5.6.15 Record keeping and documentation

Scanned forms attached to Halo tickets follow the ticket retention rules. Scanned forms filed outside Halo (where no ticket exists) are retained for the period defined by Digital Origin's broader records policy, and not less than 3 years from the closing event.

Register entries are retained indefinitely.

[Open: confirm retention period for filed scanned forms against Digital Origin's broader records policy.]

## 5.6.16 How we address shortfall

Failure to maintain a chain-of-custody form for equipment in custody is addressed through corrective feedback in the first instance, with the seriousness of the response calibrated to the risk created. Customer-data-bearing-device shortfalls are escalated more aggressively, given the information security implications. Persistent failures are handled through the disciplinary process. Patterns that reflect process gaps rather than individual choices are addressed through process review.

## 5.6.17 Open items at v0.3

- Migration from spreadsheet to Halo asset module (5.6.10.3).
- Retention period for filed scanned forms (5.6.15).
- Audit cadence after the initial 3-month period (5.6.11): suggested quarterly but to be confirmed against actual experience.
- Stale-form detection in Halo (5.6.11): how the HDTL flags tickets where equipment-in-custody status has persisted unusually long. Likely a saved Halo report.
- Convention for paper versus digital form (5.6.4.2): print-and-paper is the working assumption, but digital-with-signatures may suit some scenarios. Confirm.
