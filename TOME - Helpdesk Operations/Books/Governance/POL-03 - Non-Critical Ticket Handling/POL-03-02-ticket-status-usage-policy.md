# Ticket Status Usage Policy

## 3.2.1 Document Control

### 3.2.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 3.2.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 10/02/2026 |             |
| 1.1     | Jason Mcdill | 13/02/2026 |             |
| 1.2     | Jason Mcdill | 11/03/2026 |             |
| 1.3     | Jason Mcdill | 19/03/2026 | 01/04/2026  |

### 3.2.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.3     | Stephen Richardson | 19/03/2026 |
| 1.3     | Rupert Evans       | 19/03/2026 |

### 3.2.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

## 3.2.2 Purpose

To ensure all tickets maintain an accurate and valid status at all times, and that SLA holds are used correctly and only where the conditions of this policy are met. Accurate status usage is essential to SLA integrity, queue visibility, and effective ticket management.

## 3.2.3 Scope

This policy applies to all Helpdesk agents, CLS staff, and Team Leaders. It covers all ticket statuses available in the helpdesk system and defines the conditions under which each may be applied or held.

## 3.2.4 Expectation

All tickets must always have a valid status, and any SLA holds must be used correctly and only where appropriate.

Use of SLA holds explicitly:

SLA timers may only be paused when progression depends on an external party (e.g., the user or a vendor)

In the case of no contact with a user, a reasonable effort must be made and documented, to contact them before holding the SLA timer.

The ticket must still be updated daily unless it is scheduled.

SLA hold must not be used where progression of the ticket requires an internal team

## 3.2.5 Overview

| Status                | Usage                                                        | Expected SLA Status |
| --------------------- | ------------------------------------------------------------ | ------------------- |
| New                   | A new ticket that has not been updated yet.                  | Running             |
| In Progress           | The ticket is actively being worked on.                      | Running             |
| With User (HD)        | Awaiting a response or action from the user; work is paused. | Held (for 5 hours)* |
| With Vendor           | Awaiting a response or action from a vendor; work is paused. | Held                |
| With Testbench        | Hardware has been delivered and is on the testbench          | Running             |
| Escalate              | The issue has been escalated for additional support or visibility. | Running             |
| Updated               | The ticket has received an update from someone other than the agent. | Running             |
| Scheduled             | The ticket has a future appointment or planned action (not missed). | Held                |
| Field Visit Scheduled | A field engineer has been scheduled, and a site visit is booked | Held                |
| With Internal Team    | The ticket requires action from a team or authority with Digital Origin | Running             |

*Limitations in Halo currently prevent us using a real 24 hour clock

**Valid Status Required**: Every ticket must always maintain a valid and appropriate status.

**On-Hold Justification**: If an incident is placed on hold, the reason for this must be clearly documented within the ticket. This will usually be clear by the tickets conduct but the agent is still responsible to make sure.

**SLA Hold Restriction**: Holding SLA status is strictly prohibited in any situation where the ticket requires action or intervention from any team within Digital Origin.

**Scheduled**:

- Have a valid appointment:
- Set in the future
- Set by the owner of the ticket

**On Hold**:

- Should only be used by / for:
- Problems
- TL – on demand

**With User**:

- The correct status has been used (“With User (HD)” as opposed to “With User”)
- The ticket is waiting for a user to interact
- The user is being chased or updated daily
- The ticket does not meet the requirements of the “three strike rule”
- Applies to:
  - Incident & Telephony Incident
  - Service Request & Telephony Service Request

**With Vendor**:

- The ticket is actively waiting on a vendor
- The vendor is being chased daily
- The user (if present) is being updated promptly of changes, or daily, whichever is soonest.

**With Testbench**:

- Ensure the machine is on the test bench
- Ensure the ticket is receiving updates daily and progress is being made

### 3.2.5.1 How we measure compliance

Ticket statuses are checked twice daily by Team Leaders as part of the formal ticket hygiene process (see Ticket Hygiene Tooling). Non-compliant statuses are flagged and corrected in real time where possible.

### 3.2.5.2 Record keeping and documentation

[TBD]

### 3.2.5.3 How we address shortfall

[TBD]

## 3.2.6 Scheduling Appointments and use of Scheduled status

### 3.2.6.1 Expectation

Appointments may be set to manage your workload or to coordinate sessions with busy users. **Any time commitments made to a customer must be honoured, without exception.**

- [NOT ENFORCED] All appointments must include the user**, even if only to notify them of activity taking place on their ticket.
- **Appointments must be completed independently of the ticket.** Ensure calendar entries are managed properly so that past appointments do not show as missed due to ticket closure or status changes.

Missing an appointment with a customer causes significant disruption and leads to an immediate negative customer experience. **Failure to meet agreed appointments may result in disciplinary action.**

### 3.2.6.2 How we measure compliance

Scheduled tickets are checked every morning for a valid appointment, appointments that include a customer are captured through reporting and tracked on the day the appointment is due.

We also check the quality of scheduled appointments through ticket sampling.

### 3.2.6.3 Record keeping and documentation

Appointment compliance is captured through daily scheduled ticket checks and spot checks. Missed appointments are flagged, recorded per agent, and reported in weekly statistics.

### 3.2.6.4 How we address shortfall

Missed or invalid appointments are addressed with the agent at the time of identification. Repeated failures to honour agreed appointments may result in disciplinary action as stated in this policy.
