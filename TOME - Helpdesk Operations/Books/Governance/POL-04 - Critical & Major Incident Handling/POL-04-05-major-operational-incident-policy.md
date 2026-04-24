# Major Operational Incident Policy

## 4.5.1 Document Control

### 4.5.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 4.5.1.2 Revision History

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

### 4.5.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.8     | Stephen Richardson | 19/03/2026 |
| 1.8     | Rupert Evans       | 19/03/2026 |

### 4.5.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

## 4.5.2 Purpose

This policy sets the mandatory expectations for how major operational incidents are to be coordinated and managed across the helpdesk. It ensures a consistent and effective response, supports timely resolution, and enables appropriate communication.

## 4.5.3 Scope

This policy applies to all team members involved in the response to a major operational incident, with primary responsibility typically falling to a Helpdesk Team Leader or other senior technical staff.

## 4.5.4 When to use this policy

“Major Operational Incident” refers only to this policy and isn’t reflected directly in any ticket details. It provides managerial tooling to enable a coordinated response to the most serious and disruptive operational incidents the helpdesk may need to handle.

This policy should be used where there is a benefit to a controlled, coordinated response. For instance, if a large client suffers a major production outage. Many critical incidents can be conducted by a single agent effectively, the validity of invoking this policy can be determined during a PRR.

## 4.5.5 Supporting Documentation

- **Incident Owner’s Checklist (Major operational Incident)**
  - Provides immediate actions and containment advice
  - Reinforces fundamental expectations
- **Workload Coordinator’s Checklist**
  - Aids a Workload Coordinator in actioning key steps
- **Communicating Agent’s Checklist**
  - Aids a Communicating Agent in maintaining strong communication

## 4.5.6 Non-Technical Workload Coordinator

If no appropriate technical staff are available to coordinate the incident the role may be temporarily fulfilled by a non-technical manager or senior staff member.

A Team Leader is expected to be able to fulfil any or all roles, but adoption of multiple or all roles will degrade the quality of support provided.

The supporting documentation is not written in a way to support non-technical staff, thus:

- All team members involved are expected to make a best-effort contribution
- The full conditions of this policy are not considered to have been met, and its standards will not be used to scrutinize individual actions taken during the incident.
- The acting coordinator must follow the procedure’s steps as if they are mandatory to the best of their ability
- The acting coordinator must seek to hand over the role to an appropriate team member as soon as possible, such as:
  - Team Leaders
  - Helpdesk Manager
  - Senior third line / Escalations engineers

A PRR that includes the non-technical coordinator must be completed to determine:

- the reason the policy had to be invoked by a non-technical team member.
- Any follow up actions required to bring the incident conduct in-line with this policy

## 4.5.7 Incident Identification & Classification

- All team members must accurately classify potential major operational incidents.
- Technical resources must confirm critical priority tickets meet the criteria defined by the Priority Classification Policy before actioning them.

## 4.5.8 Roles and Responsibilities

Roles assigned by the procedure are mandatory, however only the Incident Owner is required to hand off un-associated work, other roles should be managed case by case.

Only the Workload Coordinator can determine when to end the procedure and disband the roles.

### 4.5.8.1 Workload Coordinator (typically a Helpdesk Team Leader)

Provides operational support, including task reassignment and resource allocation.

Primarily responsible for coordinating the response and assigned resource.

Additional responsibilities:

- All documentation tasks are assigned and actively being completed
- All communication tasks are assigned and actively being completed
- Handling any reassignment of un-related work, or escalations
- Arranging the PRR and managing any follow-up tasks
- Ultimately responsible for the response to the incident

### 4.5.8.2 Incident Owner (typically the agent initially assigned the incident)

Must focus solely on the remediation of the major operational incident, with no unrelated interruptions.

Primarily responsible for the conduct of response actions.

Additional responsibilities:

- Recording incident events in the incident ticket
- Communicating unrelated work that has been paused to the Workload Coordinator for reassignment as required

### 4.5.8.3 Communicating Agent (typically the Workload Coordinator or a trainee)

If resources allow, this would ideally be a third agent. Otherwise, the Workload Coordinator will adopt it.

Expectation:

- Ensure consistent frequency of communication, either once an hour or at each major event (whichever is sooner)

Primarily responsible for stakeholder communications, such as:

- Updating the customer regularly
- Internal communications with other teams

Also:

- Recording all communication events in the incident ticket

## 4.5.9 Event Recording & Ticket Updates

All events, including communications, must be recorded in the incident ticket clearly and consistently.

- Timings, both the amount of time spent and the time an event took place must be accurate
- Documenting events in the ticket is mandatory and must not be overlooked at any point

## 4.5.10 Escalation

- The Workload Coordinator must arrange relief for the Incident Owner if they are unable to continue working on the incident for any reason, without delay.
- The Workload Coordinator should take on the responsibility of Incident Owner until a relief is available.
- In this scenario, the agent leaving the Incident Owner role will take on the Communicating Agent role if it is held by the Workload Coordinator.
- Relief for the Incident Owner role must be derived from the Escalation Team or a Team Leader.

## 4.5.11 Training

Both the Incident Owner and Communicating Agent roles can be fulfilled by trainees, but preferably the Communicating Agent as this will allow a trainee to gain experience and exposure without being directly responsible for the conduct of the ticket.

Where the Incident Owner is a trainee:

- The Workload Coordinator must be a senior technician capable of taking over the incident with little to no handover while also covering the Communicating Agent role and documentation expectations until relieved
- The trainee should take over the Communicating Agent role if possible

Where the Communicating Agent is a trainee:

- The Workload Coordinator should be able to take over the Communicating Agent Role with little to no handover
- The expectations and responsibilities of the Communicating Agent role are still applied to the trainee and should have been met up until the point the role is taken over

## 4.5.12 Boundaries of Support

Helpdesk autonomy of actions is typically limited to:

- Restoring the environment to a functional state using the existing infrastructure
- Applying long term fixes that utilize only the available services and resources within the environment

The Helpdesk Manager, Team Leaders and Account Manager must coordinate to ensure the remedial actions are applied appropriately.

- Rebuilding existing services will typically be a Helpdesk responsibility
- Introducing new services or replacing existing services entirely will typically need professional services

## 4.5.13 Confirmation of Resolution

Only the Workload Coordinator can end the procedure and disband the roles.

The Incident can only be considered complete in certain circumstances:

- The customer confirms the incident is complete
- No responsibility is retained by the helpdesk, and none is likely to return (such as, when handing over a secured environment for scoping and professional services)
  - The Communicating Agent must communicate this to the customer
- Senior management instruct the Workload Coordinator to end the procedure

## 4.5.14 Root Cause Analysis

RCA should be conducted every time a major operational incident is raised with findings added to the incident ticket post closure.

### 4.5.14.1 How we measure compliance

Compliance is assessed through PRR review following each invocation of this policy. Role adherence, documentation quality, and communication frequency are reviewed.

### 4.5.14.2 Record keeping and documentation

All events are recorded in the incident ticket throughout its lifecycle. PRR outcomes, findings, and follow-up actions are documented and retained by the Helpdesk Manager.

### 4.5.14.3 How we address shortfall

Shortfall identified through PRR is addressed through process improvement and corrective training. Where the PRR identifies a human factor as a root cause, that finding is passed to the Disciplinary Process separately. The PRR itself takes no further action with respect to that individual.
