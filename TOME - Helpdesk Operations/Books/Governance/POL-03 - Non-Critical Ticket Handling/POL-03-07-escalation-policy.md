# Escalation Policy

## 3.7.1 Document Control

### 3.7.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 30/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 3.7.1.2 Revision History

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
| 1.8     | Jason Mcdill | 11/03/2026 |             |
| 1.9     | Jason Mcdill | 19/03/2026 |             |
| 2.0     | Jason Mcdill | 30/03/2026 | 01/07/2026  |

### 3.7.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.9     | Stephen Richardson | 19/03/2026 |
| 1.9     | Rupert Evans       | 19/03/2026 |
| 2.0     | [TBD]              |            |

### 3.7.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

## 3.7.2 Purpose

This policy provides governance around the handling, coordination, and expectations of incident and service request escalations. The intent is to ensure consistent, effective, and timely escalation of incidents that exceed the capabilities of the current handler.

This policy also governs the Major Incident Escalation process, which applies when Helpdesk-level escalation cannot be resolved without cross-functional coordination through a swarm team.

This policy does not apply to Critical Incident or Critical Security Incident declarations, which are governed by the Critical Incident Handling Policy.

## 3.7.3 Scope

This policy applies to all helpdesk personnel, including Level 1, Level 2, Level 3, Escalation Engineers, and Team Leaders involved in the resolution of incidents and service requests.

- "Escalation Team" or "Escalations" used in the context of agents, consists of:
  - Team Leaders
  - Third Line Engineers
  - Senior Second Line Engineers undergoing escalations exposure training

## 3.7.4 Escalation Triggers

Escalations can generally be initiated for any reason but should follow these triggers:

- Technician skillset exceeded
- Resolution SLA about to be breached AND escalation may prevent the SLA breach
- Priority elevation to "high" or "critical"
- Escalation is requested by a Team Leader or management
- The ticket requires Account Management intervention such as scoping or sales
  - The ticket itself is not escalated; a child ticket must be raised
- The agent is unable to progress the incident following best effort for any other reason
  - This is meant as a deliberate catch-all; consider if the escalation was reasonable or breached this policy on a case-by-case basis
  - If this is the trigger used, a PRR is required
- The customer has requested escalation (see Customer Escalation)

### 3.7.4.1 How we measure compliance

Escalation triggers are reviewed through ticket sampling and PRR outcomes. Agents are expected to document the trigger reason clearly in the ticket at the point of escalation.

### 3.7.4.2 Record keeping and documentation

Escalation events and their trigger reasons are recorded in the ticket at the time of escalation and reviewed as part of QA sampling and PRR processes.

### 3.7.4.3 How we address shortfall

Failure to escalate when appropriate, or escalation without a documented trigger, is addressed through corrective training and feedback. Repeat failures are handled through the disciplinary process.

## 3.7.5 Types of Escalation

### 3.7.5.1 Incident Escalation

Incident technical escalation is the most common form of escalation. It applies when the assigned agent cannot progress or resolve an incident and requires specialist support from the Escalation Team.

#### 3.7.5.1.1 How we measure compliance

Incident escalation compliance is assessed through ticket sampling and PRR outcomes. Reviewers confirm that the escalation trigger was documented and that escalation was raised at the appropriate point.

#### 3.7.5.1.2 Record keeping and documentation

Escalation events are recorded in the ticket at the time of escalation and captured through QA sampling outcomes.

#### 3.7.5.1.3 How we address shortfall

Shortfall is addressed through informal feedback and corrective training in the first instance. Repeated or serious failures are handled through the disciplinary process.

### 3.7.5.2 Service Request Escalation

While rare, service requests may need to be escalated for reasons including management approval requirements, insufficient access or permissions assigned to the agent, or specialist knowledge requirements.

Service request escalation is handled in the same way as incident escalation, but the reason for escalation must be clearly identified.

#### 3.7.5.2.1 How we measure compliance

Service request escalation compliance is assessed through ticket sampling. The reason for escalation and any subsequent handling are reviewed for appropriateness.

#### 3.7.5.2.2 Record keeping and documentation

Escalation events for service requests are recorded in the ticket and captured through QA sampling outcomes.

#### 3.7.5.2.3 How we address shortfall

Shortfall is addressed through informal feedback and corrective training in the first instance. Repeated or serious failures are handled through the disciplinary process.

### 3.7.5.3 Customer Escalation

A customer escalation occurs when a customer explicitly requests that their issue be escalated beyond the current handler, or expresses dissatisfaction with the progress or handling of their ticket to the extent that leadership intervention is appropriate.

#### 3.7.5.3.1 When customer escalation applies

- The customer explicitly requests to speak to a manager or senior person
- The customer expresses significant dissatisfaction with the handling, progress, or outcome of their ticket
- The agent identifies that the customer's expectations cannot be met within normal handling and leadership input is needed
- The customer contacts Digital Origin through a channel outside the normal ticket flow (e.g. direct email to management, complaint via account manager) about an active ticket

#### 3.7.5.3.2 Agent responsibilities

- Inform the Helpdesk leadership team (Team Leader or Helpdesk Manager) at the earliest opportunity when a customer is requesting escalation
- Do not attempt to dissuade the customer from escalating or promise outcomes that require leadership authority
- Continue to manage the ticket and maintain communication with the customer unless a Team Leader explicitly takes over communication ownership
- Record the escalation request and the customer's stated concern in the ticket

#### 3.7.5.3.3 Team Leader responsibilities

- Assess the situation promptly and determine the appropriate response
- Where resources allow and the customer's expectations warrant it, take over communication with the customer directly
- Where a Team Leader takes over communication, this must be noted clearly in the ticket so that all parties understand who owns customer contact
- Ensure the underlying ticket continues to progress - customer escalation does not pause technical resolution
- Where the escalation indicates a broader service issue (e.g. repeated failures for the same customer, systemic handling problems), raise this for review at the weekly statistics meeting or Management Review as appropriate

#### 3.7.5.3.4 Relationship to Handling Complaints and Difficult Customers

Where a customer escalation involves a formal complaint or abusive behaviour, refer to the Handling Complaints and Difficult Customers policy.

#### 3.7.5.3.5 How we measure compliance

Customer escalation handling is reviewed informally by Team Leaders on a case-by-case basis. Notable outcomes may be reviewed in the monthly one-to-one. Patterns of repeated customer escalation for the same customer or agent are tracked through weekly statistics.

#### 3.7.5.3.6 Record keeping and documentation

Customer escalation events are recorded in the ticket, including the customer's stated concern and the leadership response. Where a Team Leader takes over communication, this is noted in the ticket and tracked to resolution.

#### 3.7.5.3.7 How we address shortfall

Failure to notify leadership of a customer escalation request at the earliest opportunity is addressed through informal feedback. Repeat failures are handled through the disciplinary process. Where customer escalations reveal systemic handling issues, these are raised through the continual improvement process.

### 3.7.5.4 Major Incident Escalation

Major Incident Escalation applies when a ticket has been formally escalated and the Helpdesk cannot resolve the incident independently. At this point the ticket is handed off to the Major Incident Swarm process, which is governed entirely by the Major Incident Escalation Policy.

Before handing off, the assigned agent and Team Leader must confirm two things:

- **P1 check** - if the ticket is or may be a P1, the Major Incident Policy must be invoked before proceeding
- **Helpdesk resolution assessment** - confirm that the Helpdesk genuinely cannot resolve the incident without external support; if it can, the ticket does not enter the swarm pipeline

Once both are confirmed, the ticket is handed to the swarm team and all further handling is governed by the Major Incident Escalation Policy. The original ticket owner retains ownership of the ticket and remains responsible for keeping it updated throughout.

#### 3.7.5.4.1 How we measure compliance

The P1 check and Helpdesk resolution assessment are recorded in the ticket at the point of handoff. Ticket sampling confirms both steps are completed and documented before the swarm is activated.

#### 3.7.5.4.2 Record keeping and documentation

The outcome of both pre-handoff assessments, including whether the Major Incident Policy was invoked and when, is recorded in the ticket at the point of handoff.

#### 3.7.5.4.3 How we address shortfall

Failure to complete either assessment before handing off to the swarm, or failure to invoke the Major Incident Policy where required, is addressed through corrective training and feedback. Repeat failures are handled through the disciplinary process.

## 3.7.6 Escalation Process

### 3.7.6.1 General expectations

- The ticket owner retains responsibility for the ticket even after escalation has taken place.
- Escalation should not be used to "hand off" ownership.
- The reason for escalation must be clear and documented within the ticket.
- Escalation must be raised as early as possible once a blocker is identified.

### 3.7.6.2 Escalation event recording

Escalation events must be recorded in the ticket, including:

- Time of escalation
- Who it was escalated to
- Reason for escalation
- Any actions already taken and the current status
- Any immediate next steps or expected outcomes

### 3.7.6.3 Escalation communication

The ticket owner must:

- Notify the escalation recipient in an appropriate channel (ticket + Teams where required)
- Provide sufficient context for the escalated party to act without unnecessary discovery
- Maintain customer communication throughout the escalation lifecycle unless ownership of comms has been explicitly taken over

### 3.7.6.4 Reassignment and coverage

If the escalated party is unavailable or the escalation cannot be handled promptly:

- The Team Leader must arrange alternative coverage without delay
- Escalation must not stall due to uncertainty about resource availability

### 3.7.6.5 Closing escalation

Escalation concludes when:

- The escalated requirement has been met and the ticket owner can proceed
- The escalated party has taken over and confirmed responsibility for further progress (where appropriate)
- The ticket is closed under normal resolution conditions

### 3.7.6.6 How we measure compliance

Escalation procedure adherence is assessed through ticket sampling and PRR outcomes. Reviewers confirm that escalation events are recorded correctly, communication expectations were met, and ownership was not inappropriately transferred.

### 3.7.6.7 Record keeping and documentation

Escalation procedure compliance is recorded through ticket sampling outcomes and PRR findings. Records are retained as part of weekly statistics and incident documentation.

### 3.7.6.8 How we address shortfall

Shortfall is addressed through informal feedback and corrective training in the first instance. Repeated or serious failures are handled through the disciplinary process.

## 3.7.7 Post Incident Review

A PRR is required where the escalation trigger used was the catch-all (agent unable to progress for any other reason), or where Leadership determines a PRR is warranted for any other reason. PRR triggers arising from the Major Incident Swarm process are governed by the Major Incident Escalation Policy.

Where a PRR is required, it is conducted in accordance with the Post Incident Review (PRR) Policy, which is the single authoritative reference for PRR process, expectations, and governance.
