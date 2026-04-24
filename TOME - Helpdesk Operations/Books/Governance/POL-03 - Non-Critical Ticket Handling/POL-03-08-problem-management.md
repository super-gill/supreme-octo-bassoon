# Problem Management

## 3.8.1 Document Control

### 3.8.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 3.8.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 16/03/2026 |             |
| 1.1     | Jason Mcdill | 19/03/2026 | 01/04/2026  |
| 1.2     | Jason Mcdill | 26/03/2026 | 01/04/2026  |

### 3.8.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.1     | Stephen Richardson | 19/03/2026 |
| 1.1     | Rupert Evans       | 19/03/2026 |

### 3.8.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

> **This policy is partially complete. Sections marked [TBD] require input on proactive problem identification processes and trend analysis tooling before the policy can be considered fully operational.**

## 3.8.2 Purpose

To define how the helpdesk identifies, records, and manages underlying causes of recurring or widespread incidents using the Problem ticket type. Problem management aims to reduce incident volume and impact by addressing root causes rather than repeatedly resolving symptoms.

## 3.8.3 Scope

This policy applies to Third Line Engineers and Team Leaders, who are the only roles authorised to raise and maintain Problem tickets. It covers the creation, linking, lifecycle, and closure of Problem tickets across all customer environments.

## 3.8.4 Expectation

### 3.8.4.1 When to raise a Problem ticket

A Problem ticket should be raised when:

- Multiple incidents are identified as having the same root cause or are affecting the same system or service across one or more customers
- A PRR identifies a systemic issue that is likely to recur without intervention
- A Team Leader or Third Line Engineer identifies a pattern of related incidents through daily checks, Dredging, or escalation review

### 3.8.4.2 Problem ticket standards

As defined in the Ticket Type Usage Policy:

- Problem tickets are used to link and track multiple related tickets
- Problem tickets must not contain any actionable work - all resolution activity is conducted through child tickets
- Problem tickets must document: the identified or suspected root cause, the scope of impact (customers, systems, number of related incidents), and the current status of investigation or remediation
- All related incident tickets must be linked as children of the Problem ticket

### 3.8.4.3 Problem lifecycle

- **Open**: A Problem is raised and the root cause investigation is underway
- **On Hold**: Investigation is paused pending external input, vendor response, or scheduled change window. On Hold is permitted for Problem tickets (see Ticket Status Usage Policy)
- **Resolved**: The root cause has been identified and a fix or workaround has been implemented. The Problem is closed when the fix has been confirmed effective and no further related incidents are occurring

### 3.8.4.4 Proactive problem identification

Reactive problem identification, raising a Problem ticket once multiple incidents have already been reported, is the minimum standard. The Helpdesk also has a responsibility to identify emerging patterns before they generate significant customer impact.

Proactive problem identification is the responsibility of Team Leaders and Third Line Engineers. It is conducted through:

- **Daily queue review**, during daily hygiene and dredging activity, Team Leaders should note tickets that share system, symptom, or customer characteristics even where they have not been formally linked
- **Recurrence monitoring**, reopen and recurrence rates are tracked as part of weekly statistics; a pattern of recurrence in a particular area is a trigger for problem identification review
- **PRR findings**, where a PRR identifies a systemic weakness, the Team Leader assesses whether a Problem ticket is warranted even in the absence of multiple open incidents
- **Vendor and third-party communications**, where a vendor issues an advisory, known issue notification, or patch release that indicates a likely fault, a Problem ticket may be raised pre-emptively to capture related inbound tickets as they arrive

Where a Team Leader or Third Line Engineer identifies a potential pattern, they must not wait for confirmation of a second incident before raising it with the Helpdesk Manager. Early identification, even where it does not result in a Problem ticket, should be documented as an internal note on the most relevant active ticket.

The decision to raise a Problem ticket proactively rests with the Team Leader in consultation with the Helpdesk Manager.

### 3.8.4.5 How we measure compliance

Problem management compliance is assessed through review of Problem ticket quality, completeness of root cause documentation, and whether related incidents are correctly linked. PRR outcomes that recommend Problem tickets are tracked for follow-through.

### 3.8.4.6 Record keeping and documentation

Problem tickets and their linked incidents are retained in the ticketing system indefinitely. Root cause findings and remediation actions are documented within the Problem ticket. Where a Problem results in a process or documentation change, this is recorded in the Continual Improvement Log.

### 3.8.4.7 How we address shortfall

Failure to raise a Problem ticket where one is warranted (e.g. where a PRR recommends it, or where a clear pattern of recurring incidents exists) is raised with the responsible Team Leader. Systemic gaps in problem identification are escalated to the Helpdesk Manager for review at Management Review.
