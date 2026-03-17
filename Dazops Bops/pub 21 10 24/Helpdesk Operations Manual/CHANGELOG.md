# Helpdesk Operations Manual — Version Change Notes

> Compiled 2026-03-16. Covers VE3 through VE11.

---

## VE3 → VE4

**Note:** Both VE3 and VE4 files carry the version label "VE.4" internally — VE3 appears to be an in-progress draft that was finalised into VE4.

### Changes Section
- Removed descriptive text ("All sections have either been re-written or directly converted to markdown and embedded in html") and replaced with "Not defined"

### Quality Assurance — Ticket Status Checks (Formal)
- **Heading renamed** from "Status Checks (Formal)" to "Ticket Status Checks (Formal)"
- **Added** detailed per-status check definitions with machine-readable failure codes:
  - With User (HD) — codes: `WithUserCorrectVersion`, `WithUserInvalidUse`, `WithUserNoUpdate`
  - With Vendor — codes: `WithVendorInvalidUse`, `WithVendorNoUpdate`
  - With Testbench — codes: `WithTestBenchInvalidUse`, `WithTestBenchNoUpdate`
  - Scheduled — codes: `ScheduledNoAppointment`, `ScheduleAppointmentInvalid`
  - Field Visit Scheduled — code: `OtherBreachCatchAll`
  - With Internal Team — code: `OtherBreachCatchAll`
- **New statuses added:** Field Visit Scheduled, With Internal Team
- **Statuses removed from checks:** On Hold, Awaiting Delivery
- **Record keeping rewritten:** Shifted from per-ticket agent-linked failure metadata to aggregate whole-number counting
- **How we address shortfalls expanded:** Added management escalation and disciplinary process references

### Removed
- Standalone "Recording and Documentation" subsection under Daily Ticket Checks (content reorganised into inline status check definitions)

### Appendix — New
- **Appendix — Daily Ticket Checks** added with full status check definitions and a reference table mapping statuses to check requirements and expected SLA states

### Appendix — Policy Format Template
- Heading labels now include heading-level indicators: "(H3) Purpose", "(H3) Scope", etc.
- New H4/H5 example subtitle blocks added to demonstrate deeper nesting

---

## VE4 → VE5

### Metadata
- Version updated from VE.4 to VE.5

### New Sections
- **Ticket Type Usage Policy — Overview table** added (Telephony/Incident, Telephony/Service Request)
- **Ticket Status Usage Policy — "Overview" heading** added above the existing status table
- **Ticket Closure, Reopen and Recurrence (NF)** — new H2 policy replacing and expanding the old "Confirmation of resolution" subsection. Includes: When tickets can be closed, Confirmation of resolution, Handling reopened tickets [TBD], Classifying and actioning recurrence [TBD]
- **Ticket Ownership and Handover Policy [Placeholder]** — new placeholder

### Content Changes
- **Confirmation of resolution** restructured: grace period / soft enforcement note removed; wording changed from "All tickets" to "Tickets"; entire "How we address shortfalls" intervention detail replaced with [TBD]
- **Disciplinary Process — Typical Flow:** detailed Step 1 content removed, replaced with [TBD]

### Typo / Formatting Fixes
- "hild Tickets" → "Child Tickets"
- Removed stray `>` from five H5 headings under Child Tickets
- Removed ~20 stray `</s>` characters throughout Dispatch Responsibility Policy (Abandoned)

---

## VE5 → VE6

### Metadata
- Version updated from VE.5 to VE.6

### Changes Section
- Now contains actual change notes (previously "Not defined"):
  - Removed Incident Management placeholder
  - Removed Service Request Management placeholder
  - Updated Ticket Communication Policy — added Record keeping and documentation

### Sections Removed
- **Incident Management [Placeholder]** — removed (covered by Non-Critical Ticket Handling Process)
- **Service Request Management [Placeholder]** — removed (same reason)

### Content Changes
- **Priority Classification Policy — "Initital Classification"** typo corrected to "Initial Classification"
- **Ticket Status Usage — With User (HD) SLA hold duration** changed from "Held (for 24 hours)" to "Held (for 5 hours)*" with footnote about Halo limitations
- **Ticket Communication Policy — Record keeping** filled in (was [TBD]): callout/email statistics recorded with weekly performance stats
- **Ticket Closure, Reopen and Recurrence** heading: typos "Closer" and "Recurrance" corrected to "Closure" and "Recurrence"; Purpose filled in (was [TBD])
- **Disciplinary Process — Typical Flow:** Step 1 ("Concern identified") partially drafted (was [TBD])

---

## VE6 → VE7

### Metadata
- Version updated from VE.6 to VE.7

### Structural Changes
- **"Continuous improvement and document governance"** promoted from inline text to its own H3 heading

### Sections Removed
- **Remote Access & Remote Support Policy (NF)** — entire placeholder section removed

### Content Changes — Child Tickets
- **Primary use redefined:** "assign tasks to Account Managers" → "assign quotation tasks to Service Delivery"
- **Automatic approval scope expanded:** now references "this policy, and the Escalation policy"
- **"account management" subsection** renamed to "Service Delivery (Quoting)"
- **"shipping instructions" subsection** renamed to "CLS (shipping instructions)"
- **New lines added:** Explicit automatic approval statements for quoting and shipping child tickets
- **Chase target changed:** "account manager" → "Service Delivery"
- **Bold formatting removed** from "assign tasks", "share workload", "same standards and urgency"
- **Record keeping** filled in (was [TBD]): open child tickets reported to Team Leaders daily

### Other Content Changes
- **Ticket Communication Policy — How we address shortfalls:** "Development Plan" pluralised; bullet about customer confirming email removed
- **Disciplinary Process — Typical Flow:** heading changed to "Typical Flow [TBD]"

### Typo Fixes
- "technicak" → "technical" (Triage Policy)
- "Srves" → "Serves" (Ticket Types)
- Removed stray `]` from Policy Format appendix

---

## VE7 → VE8

**Formatting-only release.**

### Changes
- Version updated from VE.7 to VE.8
- **All 41 policy metadata tables standardised:** Added explicit `| Field | Value |` header row. Previously the first data row ("Last Updated") was rendering as a column header. No content changes whatsoever.

---

## VE8 → VE9

**Major release — QMS addition and systematic policy completion.**

### Metadata
- Version updated from VE.8 to VE.9
- All "Last Updated" dates changed from 10/02/2026 to 11/03/2026

### Major Addition — Quality Management System (entire new H1 section)
ISO 9001:2015-aligned QMS layer containing ~30 new policies:
- About This Section, Quality Policy, QMS Scope
- Context of the Organisation, Interested Parties
- Risk Register (13 risks scored on likelihood/impact matrix)
- Quality Objectives (6 measurable objectives)
- Roles and Responsibilities (consolidated role definitions + authority limits table)
- Communication Plan, Customer Satisfaction, External Provider Management
- Internal Audit Programme, Management Review, Continual Improvement
- Leadership and Commitment [TBD], Planning of Changes
- Resources and Infrastructure, Competence and Awareness
- Document Control, Operational Planning and Control
- Customer Requirements [TBD], Design and Development (formal ISO 8.3 exclusion)
- Service Delivery Standards, Ticket Release and Closure Control
- Nonconforming Outputs, Monitoring/Measurement/Analysis/Evaluation
- Nonconformity and Corrective Action

### Sections Removed
- **Markdown Guide (How to Edit This Manual)** — removed from Overview
- **Changes log content** — emptied (VE8 had specific change notes)

### "(NF)" Designations Removed (policies now enforceable)
- Triage Policy, SLA Milestones, Priority Classification Policy, Ticket Status Usage Policy, Ticket Communication Policy, Ticket Closure/Reopen/Recurrence, Escalation Policy, Quality Assurance H1

### Systematic Policy Completion
Purpose and/or Scope sections added to: Triage, SLA Milestones, Priority Classification, Ticket Status Usage, Ticket Communication, Ticket Closure, Escalation, Critical Incident, Major Operational Incident, Major Security Incident, PIR, Local Administrator, Phone Etiquette, Ticket Hygiene Tooling, Projects Handover, Ticket Quality Sampling, Helpdesk Rota and Breaks, Professional Advancement, Disciplinary Process, Grievance Process, Behaviour & Language Policy, Daily Ticket Checks appendix

"How we measure compliance", "Record keeping", and "How we address shortfall" subsections filled in across nearly every existing policy (too many to list individually).

### Significant Content Additions
- **Disciplinary Process** substantially expanded:
  - New "Conduct vs Performance" subsection
  - Typical Flow expanded from 1 step to 8-step journey
  - New "Corrective Training" standalone subsection
  - New "Oversight and Authorisation" subsection
  - Warning Types expanded with detailed descriptions (Informal, Formal, Final Written, Dismissal, stacking, spent warnings)
- **Development Plan Policy** elevated from empty placeholder to fully written policy (When raised, What it contains, Conducting a DP, Outcomes)
- **Ticket Quality Sampling** renamed to "Ticket Quality Sampling (Not enforced)"

### Placeholder Structure Added
Standard template subsections (all [TBD]) added to all remaining placeholders: Documentation Standards, Ticket Ownership and Handover, Queue Management, Known Issues & Mass Communication, Password & Credential Handling, Tooling & Asset Management, Handling Complaints, New Starter & Onboarding, Training/Tooling/Systems, Knowledge Management/Base, DUO Bypass appendix, Ticket Screening appendix

---

## VE9 → VE10

### Metadata
- Version updated from VE.9 to VE.10
- Document Control reference updated from "currently VE.9" to "currently VE.10"
- Changes section populated with formal changelog table (entries for VE.9 and VE.10)

### Sections Removed
- **Dispatch Responsibility Policy (Abandoned)** — entire section removed (~54 lines)
- **Password & Credential Handling [Placeholder]** — removed
- **Tooling & Asset Management Handling [Placeholder]** — removed
- **Post Incident Review (PIR) [Placeholder]** (appendices) — removed (consolidated into new standalone policy)
- **Inline PIR sections** within Escalation Policy and Major Incident handling — removed and replaced with cross-references

### Major Addition — Post Incident Review (PIR) Standalone Policy
Promoted from scattered inline content to a top-level `# Post Incident Review (PIR)` section:
- New "Core Principles" section with blameless review commitment
- New "When a PIR is Required" section with 6 explicit trigger conditions
- Expanded attendees, document review, and timing sections
- New "Relationship to Continual Improvement" section linking to improvement log
- Expanded compliance and record keeping (retained indefinitely as QMS documentation)

### Content Changes
- **Ticket Communication Policy — email contact:** Added two sub-bullets for when email should be used (customer preference, non-interactive tasks)

### Typo Corrections (15 fixes)
- "but the CLS team" → "by the CLS team"
- "tickets details and infomration" → "ticket's details and information"
- "consistent service deliver" → "consistent service delivery"
- "disruption or interuption" → "disruption or interruption"
- "standarad operational tasks or administative" → "standard operational tasks or administrative"
- "excpetional telephy" → "exceptional telephony"
- "track multipe related tickets" → "track multiple related tickets"
- "To doucment a widespread issue" → "To document a widespread issue"
- "To act as a perant" → "To act as a parent"
- "approval, excep" → "approval, except"
- "Classifying and actioning recurrance" → "Classifying and actioning recurrence"
- "Field Visit Schduled" → "Field Visit Scheduled" (×2)
- "hypercare owner by" → "hypercare owned by"
- "they service is functional" → "the service is functional"

---

## VE10 → VE11

### Metadata
- Version updated from VE.10 to VE.11
- Changelog table updated with VE.11 entry (16/03/2026)

### New Placeholder Policies Added (10)
- Scheduled Ticket Review
- Service Level Breach Remediation
- Handling Complaints and Difficult Customers
- New Starter & Onboarding
- Agent Wellbeing and Workload Management
- Service Level Breach Remediation (under Quality Assurance)
- Ticket Ownership and Handover Policy
- Queue Management
- Customer Escalation
- Known Issues & Mass Communication

### Policies Drafted with [AI GEN] Tag (11)
All drafted by AI from existing manual content, marked with `[AI GEN]` in H2 titles:

**Fully complete:**
- Scheduled Ticket Review — twice-daily status checks, Breadboard monitoring, Dredging, Critical Care reviews, Manual Bread checks

**Partially complete (with TBD sections noted):**
- Service Level Breach Remediation — immediate response, breach classification, root cause/corrective action, customer communication. TBD: Repeated Breach Escalation, Service Credits
- Handling Complaints and Difficult Customers — recognising complaints, agent/TL response protocols. TBD: Account Management Involvement thresholds, Formal Complaint Logging
- New Starter & Onboarding — prerequisites, supervised handling period, minimum knowledge requirements. TBD: Onboarding Schedule, Shadowing, Probation Review
- Agent Wellbeing and Workload Management — workload awareness, break compliance, workload distribution, raising concerns, screen breaks. TBD: Workload Caps, Welfare Escalation

---

## Version Summary

| Version | Date | Character |
|---------|------|-----------|
| VE3 → VE4 | Pre-2026 | Ticket status check formalisation, failure codes, new appendix |
| VE4 → VE5 | ~Feb 2026 | Ticket closure policy created, confirmation of resolution restructured, typo fixes |
| VE5 → VE6 | ~Feb 2026 | Placeholder cleanup, typo corrections, Ticket Communication record keeping filled |
| VE6 → VE7 | ~Mar 2026 | Account Managers → Service Delivery, child ticket auto-approval, Remote Access removed |
| VE7 → VE8 | ~Mar 2026 | Formatting only — metadata table headers standardised |
| VE8 → VE9 | 11/03/2026 | **Major release** — ISO 9001 QMS added, systematic policy completion, NF designations removed, Disciplinary/Development Plan expanded |
| VE9 → VE10 | 13/03/2026 | PIR consolidated into standalone policy, abandoned/redundant sections removed, 15 typo fixes |
| VE10 → VE11 | 16/03/2026 | 10 new placeholder policies, 11 AI-drafted policies added |
