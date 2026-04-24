# Major Incident Escalation Policy (Swarm Team)

## 4.4.1 Document Control

### 4.4.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 29/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 4.4.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 29/03/2026 | 01/07/2026  |

### 4.4.1.3 Executive Sponsors

| Version | Author | Date |
| ------- | ------ | ---- |
| 1.0     | [TBD]  |      |

### 4.4.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 29/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk |            |
| Neels Steyn   | Technical Manager    | Customer Helpdesk |            |

## 4.4.2 Purpose

This policy defines the process for handling escalated incidents that exceed the capability of the assigned Helpdesk agent and require coordinated resolution through a Major Incident Swarm Team. It establishes the conditions under which a swarm is formed, the roles involved, the decision framework applied during the escalation lifecycle, and the conditions under which an escalation is concluded.

This policy governs major incidents only. It does not replace the Critical Incident Handling policy, which applies to incidents meeting the threshold for a Critical Operational or Critical Security declaration.

## 4.4.3 Scope

This policy applies to all Helpdesk personnel involved in handling escalated incidents: Helpdesk agents, Team Leaders, the Helpdesk Manager, Escalation Engineers, and representatives from Projects, DevOps, and any other branch teams drawn into a swarm.

## 4.4.4 Relationship to the Escalation Policy

This policy operates downstream of the Escalation Policy, which governs the conditions under which a ticket is escalated. This policy governs what happens once an escalation has been raised and the swarm process is activated. Where both apply, this policy takes precedence for major incident handling.

## 4.4.5 Escalation Entry and Priority Assessment

When a ticket is formally escalated, the following two assessments must be completed before a swarm is activated.

**P1 Incident check** - If the ticket is, or may be, a P1 incident, the Major Incident Policy must be invoked before proceeding. Both policies run in parallel: the Major Incident Policy governs incident declaration and stakeholder communication; this policy governs the technical resolution pathway.

**Helpdesk resolution assessment** - The assigned agent and Team Leader confirm whether the Helpdesk can resolve the incident without external support. If it can, the ticket proceeds to customer outcome confirmation. If it cannot, a swarm is formed.

[FLOWCHART - Escalation Entry and Priority Assessment]

**Governance**

Both assessments are recorded in the ticket before a swarm is formed, confirmed through ticket sampling. Failure to complete either assessment, or to invoke the Major Incident Policy where required, is addressed through corrective training; repeat failures through the disciplinary process.

## 4.4.6 Major Incident Swarm Team

The swarm is a temporary cross-functional group assembled to resolve a single escalated incident. It has no standing membership and is disbanded once the escalation is concluded.

**Composition**

Composition is determined by the nature of the incident, drawing from:

- Leadership (HDTL / HDM) - coordinates the swarm and retains overall accountability
- HD Branch (Escalations) - escalation engineering resource
- Projects Branch - engaged where the incident has a delivery dimension
- DevOps Branch - engaged where the incident involves infrastructure, systems, or automation

Leadership must confirm involvement before the swarm is considered active.

**Responsibilities**

- Leadership coordinates the swarm, maintains customer communication, and escalates further where required
- Each branch representative applies their specialist capability within the swarm session
- The original ticket owner retains ownership throughout and is responsible for ensuring all swarm activity is documented

**Governance**

Swarm formation is confirmed through ticket sampling and PRR outcomes, verifying that Leadership was notified, composition was appropriate, and the swarm was not formed unnecessarily. Formation is recorded in the ticket, including activation time, branches involved, and representative names. Where a deputy acts for Leadership, this is noted. Forming a swarm without Leadership involvement or failing to document composition is addressed through corrective training. Unnecessary formation or bypassing of the entry assessment is raised through the PRR process.

## 4.4.7 Swarm Communication

A Teams group chat is created at activation and maintained until completion of the incident and PRR (where applicable). All active swarm members are added to the channel each time it is activated. Details of in-person communications are summarised and posted to the channel.

## 4.4.8 Swarm Resolution Pathway

The resolution pathway is defined in the **Major Incident Escalation Flowchart** below. Stages must be followed in order and each stage outcome recorded in the ticket as it is completed.



>  [!INFO] <a href="../Diagrams/dia-05-swarm-flow.html" target="_blank">**Major Incident Escalation Flowchart**</a>

>  [!INFO] <a href="../Forms/frm-04-swarm-leaderchecklist.docx" download>**Swarm Leader Checklist**</a>



**Governance**

Pathway adherence is assessed through ticket sampling and PRR outcomes. Failure to follow stages in order, or recording a constrained outcome without required sign-off, is addressed through corrective training. Misuse of "Technical resource exhausted" is handled through the disciplinary and PRR processes.

## 4.4.9 Customer Outcome Confirmation

Before the escalation is concluded, the customer must accept the outcome. This applies to all resolution pathways except Business / Relationship Management and Technical resource exhausted, which conclude independently.

If the customer accepts the outcome, the escalation is concluded and the ticket re-enters the standard lifecycle for closure.

If the customer rejects the outcome, the case is referred to Leadership, who determines whether any further technical or commercial pathway exists. Where further action is possible, the ticket re-enters the swarm process at the appropriate stage. Where none exists, the escalation is concluded with the outcome documented.

> **Info:** Customer rejection does not automatically reactivate the full swarm. Leadership determines the appropriate response, which may be a targeted technical review, a commercial discussion, or confirmation that the original outcome stands.

**Governance**

Confirmation is assessed through ticket sampling. Acceptance or rejection is recorded in the ticket, including a summary of the customer's position where rejection occurs and the outcome of any subsequent Leadership assessment. Failure to seek confirmation before concluding is addressed through corrective training; repeated failures through the disciplinary process.

## 4.4.10 Business and Relationship Management

Where all technical and commercial pathways have been exhausted and no alternative solution exists, the escalation is referred to Business / Relationship Management for resolution at an account management level.

The swarm is disbanded at the point of referral. The ticket owner remains responsible for ensuring the ticket reflects the referral clearly. Business / Relationship Management concludes by feeding the agreed outcome back into the ticket lifecycle.

**Governance**

Referrals are reviewed through ticket sampling and PRR outcomes, confirming the swarm pathway was fully exhausted before referral. The ticket records the reason for referral, the point of disbandment, and the agreed outcome once reached. Premature referral is addressed through corrective training and a PRR; repeated failures through the disciplinary process.

## 4.4.11 Escalation Concluded

The escalation is concluded when one of the following conditions is met:

- The customer has accepted the outcome and the ticket has returned to the standard lifecycle
- Business / Relationship Management has reached an agreed outcome
- The outcome is "Technical resource exhausted" and Leadership has confirmed no further action is possible

The ticket must be updated to reflect the final outcome and re-enter the lifecycle for closure in accordance with the Ticket Closure Policy. Leadership must confirm disbandment and notify all participants.

**Governance**

Conclusion is assessed through ticket sampling. The ticket records the conclusion condition met, the time of conclusion, disbandment confirmation, and any PRR reference. Failure to formally conclude or return the ticket to the lifecycle is addressed through corrective training; repeated failures through the disciplinary process.

## 4.4.12 Post Incident Review

A PRR is required following every activation of this policy, and should include:

- The leadership member that activated the swarm
- The key swarm members
- The helpdesk engineer that retained ownership of the incident

Its purpose is to determine if activation was appropriate, and if future activation can be avoided through training.
