# Ticket Type Usage Policy

## 3.1.1 Document Control

### 3.1.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 3.1.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 07/05/2025 |             |
| 1.1     | Jason Mcdill | 15/06/2025 |             |
| 1.2     | Jason Mcdill | 22/07/2025 |             |
| 1.3     | Jason Mcdill | 04/09/2025 |             |
| 1.4     | Jason Mcdill | 17/10/2025 |             |
| 1.5     | Jason Mcdill | 28/11/2025 |             |
| 1.6     | Jason Mcdill | 09/01/2026 |             |
| 1.7     | Jason Mcdill | 10/02/2026 |             |
| 1.8     | Jason Mcdill | 19/03/2026 | 01/04/2026  |

### 3.1.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.8     | Stephen Richardson | 19/03/2026 |
| 1.8     | Rupert Evans       | 19/03/2026 |

### 3.1.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

## 3.1.2 Purpose

To define and standardize the usage of ticket types across the helpdesk.

## 3.1.3 Scope

This policy applies to all Helpdesk agents, CLS staff, and Team Leaders involved in creating or handling tickets. It covers all ticket types available within the helpdesk system and applies across all queues.

## 3.1.4 Overview

## 3.1.5 Incidents & Telephony Incidents

Incidents represent a service disruption or interruption that is unplanned and unintended.

- These are the most common tickets raised by end users.
- All security-related issues must be logged as incidents.
- Examples include:
  - Printer won’t print
  - Server down
  - Phishing email reported

## 3.1.6 Service Requests & Telephony Service Requests

Service requests are user requests that do not represent a disruption or interruption that is unplanned or unintended

- These requests involve standard operational tasks or administrative changes.
- Examples include:
  - Name or password changes
  - New user or PCE setup
  - Printer installation

## 3.1.7 Telephony Task

Used for project-related or exceptional telephony incidents

- Not included in normal SLAs or standard reporting
- Typically long-term or out-of-scope tasks
- May involve monitoring, scheduling, or bespoke setups

## 3.1.8 Problem

Used to link and track multiple related tickets

- Not used for direct actions or updates
- Serves two main purposes:
  - To document a widespread issue across clients or systems
  - To act as a parent to many tickets tied to a single root cause
- Must not contain any actionable work
- Should be raised and maintained by only Third Line engineers or Team Leaders
- Child tickets are created for all actual work related to the problem

## 3.1.9 Service Delivery Support

Used by Service Delivery to raise internal support tickets and build escalations.

- Always high priority
- Functionally identical to an Incident
- Currently can be used by the Projects team for workload sharing

## 3.1.10 Projects Support

Proposed type for Projects team workload sharing (not yet implemented)

## 3.1.11 Child Tickets

Child tickets are used to either assign tasks or share workload. Each use case has specific requirements and expectations. In all situations, a child ticket must be handled with the same standards and urgency as any other helpdesk ticket, and all policies that would apply to any other ticket, also apply to children except during escalation (see the escalation policy).

### 3.1.11.1 Expectations

Child tickets must be treated as customer-impacting tickets raised on behalf of a customer. The agent who raises the child ticket retains ownership and accountability for it for its entire lifecycle.

The primary use of child tickets is to assign quotation tasks to Service Delivery, however they may also be used to assign tasks to other teams or individuals. Use of child tickets to share workload requires leadership intervention and/or approval, except where automatic approval is defined within this policy, and the Escalation policy.

#### 3.1.11.1.1 Assigning a task with a child ticket

Any helpdesk ticket created specifically for task assignment -regardless of the receiving team or individual -must meet the expectations below.

A helpdesk agent may create a child ticket **without** leadership approval only to:

- Assign a workload to an account manager
- Assign shipping instructions to CLS

#### 3.1.11.1.2 When creating a child ticket for Service Delivery (Quoting)

- The agent is automatically approved to raise child tickets for quoting
- The customer is always the agent that raised it and the company is Digital Origin
- The actual customer name must be present in the summary
- If a quote is required, seek and provide the contact details of the VIP approver
- Clearly define the task needing achieved
- Accompany the assignment of the child with a secondary communication, preferably in teams or email
- The ticket must contain all the necessary context for it to be conducted independently
- The agent that creates the child ticket is responsible for ensuring it is conducted but:
  - Chase Service Delivery for updates daily
  - Apply a 3 strike rule to child tickets, but instead of closing it: escalate with a Team Leader

#### 3.1.11.1.3 When creating a child ticket for CLS (shipping instructions)

- The agent is automatically approved to raise child tickets for shipping instructions
- The customer is always the agent that raised it and the company is Digital Origin
- The actual customer name must be present in the summary
- Provide the from and to address, in full, and clearly identified, even if one of them is Digital Origin
- Accompany the assignment of the child with a secondary communication, preferably in teams or email
- The ticket must contain all the necessary context for it to be conducted independently
- Confirm with CLS that the ticket is received, and comply with any discovery requests they make. It is the agent creating the ticket who is responsible for providing the information, not CLS.

#### 3.1.11.1.3 When creating a child ticket for CLS (field visit)

- The agent is automatically approved to raise child tickets for shipping instructions
- The customer is always the agent that raised it and the company is Digital Origin
- The actual customer name must be present in the summary
- Provide the from and to address, in full, and clearly identified, even if one of them is Digital Origin
- Provide all of the instructions and context required to conduct the site visit
- Provide the customer agreed date and time, preferably with a window is possible
- Accompany the assignment of the child with a secondary communication, preferably in teams or email
- The ticket must contain all the necessary context for it to be conducted independently
- Confirm with CLS that the ticket is received, and comply with any discovery requests they make. It is the agent creating the ticket who is responsible for providing the information, not CLS.
- If the visit is rejected because the date(s) are unavailable:
  - Initially raise with a Team Leader
  - Re-approach the customer and agree a new date based on the field agents availability (usually this will be part of the rejection)

#### 3.1.11.1.4 When not to use a child ticket

- To avoid ownership or responsibility If the intent is to “hand off” an issue and stop tracking it, a child ticket is the wrong tool. The creating agent remains accountable.
- When a normal escalation is required If the issue needs specialist technical intervention, leadership oversight, or a formal escalation route, follow the Escalation Policy rather than creating a child ticket as a workaround.
- When the receiving party needs discovery If the recipient would need to ask multiple questions, request additional information, or investigate from scratch, the child ticket is not ready. Add the missing context first (or keep the work on the parent ticket until it is).
- To “split” a ticket purely for convenience Don’t create child tickets just to make the queue look smaller, reduce the appearance of workload, or move work between people without a clear task boundary and outcome.
- To duplicate work already being performed If another team/member is already engaged through an existing ticket, email thread, or agreed process, don’t create a new child ticket unless it adds clear value and avoids confusion.
- When it would create SLA ambiguity If splitting the work makes it unclear who is responsible for which SLA commitments, keep it on the parent ticket or raise with a Team Leader.

## 3.1.12 How we measure compliance

- Ticket sampling to confirm correct type selection (especially security-related tickets logged as incidents)
- Trend analysis of mis-typed tickets and reclassification frequency during triage
- QA checks during dredging/spot checks where ticket type impacts SLA/workflow

## 3.1.13 Record keeping and documentation

Open child tickets are recorded and reported to Team Leaders daily to be checked individually, failures are reported through stats.

## 3.1.14 How we address shortfall

Misclassification of ticket type is addressed through corrective feedback and training at the time it is identified. Where misclassification affects SLA or workflow, it is recorded and tracked. Persistent misclassification is handled through the disciplinary process.
