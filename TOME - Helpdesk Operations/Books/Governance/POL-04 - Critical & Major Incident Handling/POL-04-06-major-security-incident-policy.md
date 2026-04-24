# Major Security Incident Policy

## 4.6.1 Document Control

### 4.6.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 4.6.1.2 Revision History

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

### 4.6.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.8     | Stephen Richardson | 19/03/2026 |
| 1.8     | Rupert Evans       | 19/03/2026 |

### 4.6.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

> *This policy’s automatic trigger is not in force – see “When to use this policy (Not in force)”.*

## 4.6.2 Purpose

This policy sets the mandatory expectations for how major security incidents are to be coordinated and managed across the organization. It ensures a consistent and effective response, supports timely containment, and enables appropriate communication during major security incidents.

## 4.6.3 Scope

This policy applies to all team members involved in the response to a major security incident, with primary responsibility typically falling to a Helpdesk Team Leader or other senior technical staff.

## 4.6.4 When to use this policy (Not in force)

“Major Security Incident” refers only to this policy and isn’t reflected directly in any ticket details. It provides managerial tooling to enable a coordinated response to a confirmed intrusion event.

A “Major Security Incident” happens when any part of a customer’s estate has been exposed to an attacker for any reason. Immediate invocation of this policy is mandatory at the point which a breach is confirmed to have taken place.

## 4.6.5 Supporting Documentation

- **Incident Owner’s Checklist (Major Security Incident)**
  - Provides immediate actions and containment advice
  - Reinforces fundamental expectations
- **Workload Coordinator’s Checklist (Major Security Incident)**
  - Aids a Workload Coordinator in actioning key steps
- **Communicating Agent’s Checklist (Major Security Incident)**
  - Aids a Communicating Agent in maintaining strong communication

## 4.6.6 Non-Technical Workload Coordinator

If no appropriate technical staff are available to coordinate the incident the role may be temporarily fulfilled by a non-technical manager or senior staff member.

A Team Leader is expected to be able to fulfil any or all roles, but adoption of multiple or all roles will degrade the quality of support provided.

The supporting documentation is not written in a way to support non-technical staff, thus:

- All team members involved are expected to make a best-effort contribution
- The full conditions of this policy are not considered to have been met, and its standards will not be used to scrutinize individual actions taken during the incident.
- The acting coordinator must follow all provided documentation as if it is mandatory and / or to the best of their ability
- The acting coordinator must seek to hand over the role to an appropriate team member as soon as possible, such as:
  - Team Leaders
  - Helpdesk Manager
  - Senior third line / Escalations engineers

A PRR that includes the non-technical coordinator must be completed to determine:

- the reason the policy had to be invoked by a non-technical team member.
- Any follow up actions required to bring the incident conduct in-line with this policy

## 4.6.7 Incident Identification & Classification

All potential security incidents, regardless of confirmed status, are an emergency and must be given critical priority in line with the “Priority Classification Policy”.

Security incidents must be assessed for potential impact to determine the level of response required immediately.

## 4.6.8 Roles and Responsibilities

Roles assigned by this policy are mandatory, however only the Incident Owner is required to hand off un-associated work, other roles should be managed case by case.

All roles retain their responsibility even if the incident ownership has been transferred to an external body such as a cyber security specialist, until closure conditions are met.

Only the Workload Coordinator can determine when to end the procedure and disband the roles.

### 4.6.8.1 Workload Coordinator (typically a Helpdesk Team Leader)

Provides operational support, including task reassignment and resource allocation.

Primarily responsible for coordinating the response and assigned resource.

Additional responsibilities:

- All documentation tasks are assigned and actively being completed
- All communication tasks are assigned and actively being completed
- Handling any reassignment of un-related work, or escalations
- Arranging the PRR and managing any follow-up tasks
- Ultimately responsible for the response to the incident

## 4.6.9 Coordination with third parties

Coordination with third parties must be handled professionally by a technically competent team member, even if that means re-assigning this responsibility to a more senior technician.

## 4.6.10 Training

Both the Incident Owner and Communicating Agent roles can be fulfilled by trainees, but preferably the Communicating Agent as this will allow a trainee to gain experience and exposure without being directly responsible for the conduct of the ticket.

Where the Incident Owner is a trainee:

- The Workload Coordinator must be a senior technician capable of taking over the incident with little to no handover while also covering the Communicating Agent role and documentation expectations until relieved
- The trainee should take over the Communicating Agent role if possible

Where the Communicating Agent is a trainee:

- The Workload Coordinator should be able to take over the Communicating Agent Role with little to no handover
- The expectations and responsibilities of the Communicating Agent role are still applied to the trainee and should have been met up until the point the role is taken over

## 4.6.11 Boundaries of Support & Authority to Restore Services

### 4.6.11.1 Support boundaries

Helpdesk involvement is limited to containment and securing infrastructure.

No restoration, rebuilding, or long-term remediation is to be performed without explicit approval from the Account Manager and the Helpdesk Manager.

### 4.6.11.2 Authority

After a major security incident, it is unlikely that Digital Origin or even the customer is authorized to determine at what point affected services can be restored, if at all, or what the configuration of those services should be.

Communication with the authoritative bodies is essential and should be handled through coordination between the Team Leaders, Helpdesk Manager and Account Manager.

The Communicating Agent should only be used for this if they are a Team Leader.

While our main objective is to get the customer's environment functional as quickly as possible, that is not necessarily the main concern of external factors such as cyber specialists or legal counsel.

The work being requested by an external authority should be continuously assessed for compatibility with support and the support boundary by the Team Leaders and Helpdesk Manager.

## 4.6.12 Confirmation of Resolution

Only the Workload Coordinator can end the procedure and disband the roles.

The Incident can only be considered complete in certain circumstances:

- The customer confirms the incident is complete
- No responsibility is retained by the helpdesk, and none is likely to return (such as, when handing over a secured environment for scoping and professional services)
  - The Communicating Agent must communicate this to the customer
- Senior management instruct the Workload Coordinator to end the procedure

### 4.6.12.1 How we measure compliance

Compliance is assessed through PRR review following each invocation of this policy. Role adherence, documentation quality, and communication frequency are reviewed.

### 4.6.12.2 Record keeping and documentation

All events are recorded in the incident ticket throughout its lifecycle. PRR outcomes, findings, and follow-up actions are documented and retained by the Helpdesk Manager.

### 4.6.12.3 How we address shortfall

Shortfall identified through PRR is addressed through process improvement and corrective training. Where the PRR identifies a human factor as a root cause, that finding is passed to the Disciplinary Process separately. The PRR itself takes no further action with respect to that individual.
