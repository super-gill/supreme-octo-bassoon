# Ticket Hygiene Tooling

## 7.1.1 Document Control

### 7.1.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 06/05/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 7.1.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 10/02/2026 |             |
| 1.1     | Jason Mcdill | 19/03/2026 | 01/04/2026  |
| 2.0     | Jason Mcdill | 06/05/2026 | 01/08/2026  |

### 7.1.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.1     | Stephen Richardson | 19/03/2026 |
| 1.1     | Rupert Evans       | 19/03/2026 |
| 2.0     | Stephen Richardson | 06/05/2026 |
| 2.0     | Rupert Evans       | 06/05/2026 |

### 7.1.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 06/05/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 06/05/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 06/05/2026 |

## 7.1.2 Purpose

To define the methods used by the helpdesk’s leadership to ensure all tickets receive high quality interaction, daily.

This policy is intrinsically linked to the “Ticket Status Usage Policy”; expectations for each status mentioned in this policy are given in that policy, except **Escalate** which is defined by the Escalation Policy.

## 7.1.3 Scope

This policy applies to all Team Leaders and members of the Helpdesk management team responsible for conducting daily, formal, and informal ticket hygiene checks. It covers all tooling and methods used to monitor ticket status compliance and update quality across the helpdesk.

## 7.1.4 Formal vs Informal Checks

Each check is either formal or informal:

- **Formal checks**
  - Formal checks are recorded and integrated into the disciplinary process.
- **Informal checks**
  - Informal checks are not recorded and fed back to the agent as guidance without use of the disciplinary process.
  - Results of informal checks can still be used to identify and evidence performance shortfall.

## 7.1.5 Ticket Status Checks (Formal)

**With User (HD)**

Purpose - Holds the SLA while we wait for a customer to respond

- The correct version (With User (HD)) has been used as it is required for the bread automation
  - "WithUserCorrectVersion"
- The ticket must legitimately be waiting for a reply from the user
  - "WithUserInvalidUse"
- The ticket has not been waiting for a reply for more than 24 hours
  - "WithUserNoUpdate"

**With Vendor**

Purpose - Holds the SLA while we wait for a vendor to respond

- The ticket must legitimately be waiting for a reply from a vendor
  - "WithVendorInvalidUse"
- The user must have been updated of the ticket's state (with vendor) no more than 24 hours ago
  - "WithVendorNoUpdate"
- The ticket has not been waiting for the vendor more than 24 hours
  - "WithVendorNoUpdate"

**With Testbench**

Purpose - Indicates that hardware is present on the test bench

- The ticket must legitimately be on the test bench with active work planned or being carried out
  - "WithTestBenchInvalidUse"
- The user must have received an update not more than 24 hours ago
  - "WithTestBenchNoUpdate"
- The ticket is receiving high quality technical updates / private notes frequently
  - "WithTestBenchNoUpdate"

**Scheduled**

Purpose - Holds the SLA until an appointment is reached

- The ticket must have an appointment
  - "ScheduledNoAppointment"
- The appointment must be in the future (not missed)
  - "ScheduledAppointmentInvalid"

**Field Visit Scheduled**

Purpose - Holds the SLA until a field visit is conducted

- The ticket must be assigned to an agent
  - "OtherBreachCatchAll"
- The ticket must have a child ticket assigned to a field engineer with appropriate details to conduct the site visit
  - "OtherBreachCatchAll"
- The planned site visit must be in the future
  - "OtherBreachCatchAll"

**With Internal Team**

Purpose - Indicates the ticket is waiting on an internal team

- The ticket must have a child ticket assigned to an internal team with appropriate details to conduct the task required
  - "OtherBreachCatchAll"
- The parent ticket must be assigned to the agent that raised the child ticket
  - "OtherBreachCatchAll"
- The child ticket must have updates / chases in the last 24 hours
  - "OtherBreachCatchAll"

### 7.1.5.1 How we measure compliance

Status checks are conducted twice daily:

- Once before 1000 in the morning
- Again after 1600

Every ticket is checked and its status is considered for validity against the Ticket Status Usage Policy.

If the checks are not conducted, or are delayed to the point they miss their window, it must be reported to senior management.

### 7.1.5.2 Record keeping and documentation

Outcomes are recorded as a whole number of tickets that failed an expectation, then added to the weekly statistics report.

### 7.1.5.3 How we address shortfall

- Failure to conduct the check is reported to management
- Ticket that fail to meet the required standards are recorded and
  - Reported back to the agent at the time, corrected if required
  - Addressed through the disciplinary process if repeating or serious

## 7.1.6 Telephony Usage (Formal)

### 7.1.6.1 How we measure compliance

Statistics are reviewed weekly in accordance with the Ticket Communication Policy, and cross referenced against actual call-out.

### 7.1.6.2 Record keeping and documentation

Callout statistics are recorded and reported weekly.

### 7.1.6.3 How we address shortfall

Shortfall in telephony usage is addressed in line with the Ticket Communication Policy. Intervention thresholds and the process for addressing them are defined in that policy.

## 7.1.7 Response SLA Breaches (Formal)

SLA response breaches are checked daily and classified, then investigated if required.

### 7.1.7.1 Breach Classifications

- **Miss Triage**
  - Occurs when ticket details are incorrect and cause a breach (e.g., breached because of incorrect priority)
- **Miss Dispatch**
  - Occurs when dispatch failed to assign a ticket to an agent with sufficient time to respond (typically less than 30 minutes, or within 30 minutes of an agent's shift end)
- **Slow to respond**
  - Occurs when triage and dispatch provided sufficiently accurate information and time to respond, but the agent failed to respond within the response SLA window
- **Ticket conduct**
  - Occurs when the agent fails to respond to the ticket with a valid update, or defers work inappropriately, or the customer did not receive a notification in the response window (the ticket will typically show procedurally met response SLA)
- **External breach**
  - Occurs when sales or SD breach a ticket before it reaches the helpdesk
- **Team Leaders**
  - Tickets that are breached by a Team Leader, for any reason
- **False Positive**
  - A ticket that breached procedurally in Halo, but in reality didn’t breach the SLA from the customer's perspective

### 7.1.7.2 How we measure compliance

Team Leaders check all tickets open in the helpdesk, twice daily, for compliance with the Ticket Status Usage Policy.

### 7.1.7.3 Record keeping and documentation

Failures are recorded and reported back to the agent. Recorded failures form part of the helpdesk’s performance statistics.

### 7.1.7.4 How we address shortfall

SLA breach classifications are reviewed with the relevant agent. Where the breach is attributable to agent conduct (Slow to Respond or Ticket Conduct), it is addressed through corrective training, and where necessary, the disciplinary process. Systemic breach patterns are escalated to management for process review.

## 7.1.8 Critical Care Checks (Formal)

### 7.1.8.1 How we measure compliance

Team Leaders re-check Critical Care tickets independently for all expectations listed in this toolset but to a higher level of detail and tighter tolerance.

### 7.1.8.2 Record keeping and documentation

Failures are recorded and reported back to the agent. Recorded failures form part of the helpdesk’s performance statistics.

### 7.1.8.3 How we address shortfall

Critical Care failures are addressed with the agent immediately and recorded. Given the elevated customer impact of Critical Care tickets, persistent failures are treated with greater urgency through the disciplinary process.

## 7.1.9 Breadboard (Informal)

Breadboard is a pseudo-automated queue hygiene tool used to monitor ticket update compliance.

### 7.1.9.1 How it works

- Each agent has a visible score shown in a shared forum.
- The score represents the number of tickets assigned to that agent that have not been updated within the last 24 hours.

Exceptions apply, for example:

- Tickets with a documented scheduled next action (booked call, change window, agreed follow-up date)
- Tickets awaiting customer response within an agreed timeframe (and this is clearly recorded)
- Tickets blocked by a third party, where this has been communicated and recorded with a recent update

### 7.1.9.2 Agent expectation

Agents are required to clear their score to zero before the end of every shift.

This is done by reviewing each contributing ticket and applying valid, high-quality updates that:

- Show progress or actions taken
- Record next steps, owner, and timeframe
- Provide appropriate customer communication (where relevant)

See the Documentation Standards policy for the update standard.

### 7.1.9.3 Quality control

The Breadboard supports visibility and consistency, but it does not confirm update quality.

It must be supported by Manual Bread spot checks by Team Leaders to confirm:

- Updates are meaningful (not placeholders)
- Tickets are progressing appropriately
- Handling remains compliant with the Ticket Status Usage Policy

## 7.1.10 Stale Ticket Reminders

Reminders are posted in Teams and checked informally against the Breadboard. Failure occurs when an agent completes their shift with a score greater than zero remaining; the ticket is assessed for the breach reason and fed back to the agent.

## 7.1.11 Bread (Informal)

Manual Bread is an informal check and has largely been replaced by daily checks and dredging, but it remains available as an on-demand, deeper compliance check where additional assurance is required.

Manual Bread checks are conducted by Team Leaders to confirm that tickets meet the full set of update and handling expectations defined in the Ticket Status Usage Policy . This includes verifying that tickets show consistent evidence of progress, clear ownership, and appropriate customer communication.

Manual Bread may be initiated:

- After recurring issues are identified (e.g., repeat stale tickets, weak updates)
- When SLA risk increases, or a backlog spike occurs
- As part of targeted coaching, quality improvement, or spot checks
- Following complaints, escalations, or service reviews
- To validate compliance for audit or management assurance purposes

During a Manual Bread check, Team Leaders will typically review:

- **Update quality**: meaningful updates, not placeholders; clear internal notes vs customer updates
- **Progression evidence**: actions taken, troubleshooting steps, and outcomes recorded
- **Next steps**: explicit next action, owner, and timeframe; scheduled activity captured where applicable
- **Communication standards**: user expectations managed, timelines explained, and tone appropriate
- **Escalation and routing**: correct prioritisation, correct queue/assignment, and timely escalation where blocked
- **Policy compliance**: any mandatory fields, templates, or categorisation rules required by the Ticket Status Usage Policy

Outcome: Manual Bread provides stronger assurance than a routine daily sweep, identifies training/coaching needs, and helps ensure consistent ticket quality across the team -especially when performance or compliance needs to be demonstrated.

## 7.1.12 Dredging (Informal)

Dredging is an informal daily ticket-grooming activity where we review the Helpdesk queue to ensure older tickets remain active, well-communicated, and progressing.

Dredging applies to tickets that:

- Are older than 1 day, and/or
- Have not received an update in the last 24 hours, and do not have a scheduled next action recorded (e.g., awaiting a booked call, change window, third-party appointment, or agreed customer response date).

During dredging, each ticket is checked for:

- A clear, meaningful update (no “nothing” updates)
- Evidence of progress (actions taken, next steps, ownership)
- A defined next action and timeframe (what happens next, and when)
- Appropriate prioritisation/escalation if the ticket is blocked or SLA risk is increasing

Where gaps are identified, the assigned engineer is expected to:

- Add a quality update to the ticket (internal + customer-facing where appropriate)
- Record the next step and expected timeline
- Escalate blockers (third parties, access issues, approvals) where necessary

Team Leaders support dredging by:

- Removing blockers and assisting with escalation/decision-making
- Reassigning tickets if needed to restore momentum
- Ensuring customer communication is appropriate and consistent
- Highlighting systemic issues (repeat blockers, capacity constraints, recurring request types)

Outcome: tickets do not stagnate, customers receive regular high-quality communication, and potential SLA risk is identified early and managed proactively.

## 7.1.13 Daily Walk-Arounds (Informal)

Daily Walk-Arounds are an agent-facing queue review conducted by the Team Leader during the shift. They sit alongside Bread and Dredging as a daily leadership check, but differ in that they are conducted **with the agent**, in person or via call/screen-share, rather than as a desk review.

Walk-Arounds are semi-formal: outcomes are not directly used in the disciplinary process, but per the Formal vs Informal distinction in 7.1.4, results may be used to identify and evidence performance shortfall over time.

The intent is twofold:

- Confirm that every assigned ticket is progressing, has a clear next action, and is being communicated in line with the Documentation Standards and the Ticket Status Usage Policy
- Surface blockers, capacity pressure, and coaching needs in a low-friction setting before they manifest as SLA risk or quality shortfall

### 7.1.13.1 How it works

- Walk-Arounds are conducted at the Team Leader's discretion during the working day, but **at minimum once per shift** on a working day
- Coverage is **risk-prioritised**: agents with rising queue depth, growing Breadboard scores, recent SLA risk, or recent quality concerns are seen first
- Every agent receives a Walk-Around at least once per week regardless of risk profile
- During each Walk-Around the Team Leader and the agent review:
  - The agent's full open queue
  - All status-held tickets (With User, With Vendor, With Testbench, Scheduled, Field Visit Scheduled, With Internal Team) against the expectations in 7.1.5
  - Any tickets contributing to the agent's Breadboard score
  - All P1/P2 tickets and any others within close range of an SLA milestone
- Where issues are identified, the agent is expected to address them in real time, or to record a clear next action and timeframe before the Walk-Around concludes
- The Team Leader uses the Walk-Around to remove blockers, support escalation, and surface coaching opportunities

### 7.1.13.2 Coverage when the Team Leader is unavailable

If the assigned Team Leader is unavailable (off, on leave, or engaged with a Major Incident), the other Team Leader on shift covers Walk-Arounds for both teams. Where neither Team Leader is available, the Helpdesk Manager is notified and decides whether to delegate or to defer.

### 7.1.13.3 Relationship to other checks

Walk-Arounds complement, but do not replace:

- The twice-daily formal Ticket Status Checks (7.1.5)
- Dredging (7.1.12), which is desk-based ticket grooming
- Manual Bread (7.1.11), which is on-demand and typically targeted

Walk-Arounds are also distinct from one-to-ones: wellbeing, development, and structured performance discussions belong in scheduled one-to-ones per the Agent Wellbeing and Workload Management policy.

### 7.1.13.4 How we measure compliance

The Team Leader maintains a lightweight log of which agents were seen on which day. Weekly, the Helpdesk Team Leader confirms that every agent has had at least one Walk-Around in the preceding seven calendar days, and that risk-prioritised agents have been seen with appropriate frequency. Walk-Around coverage is reported in the weekly statistics.

### 7.1.13.5 Record keeping and documentation

Walk-Arounds are an Informal check; their content is not formally recorded. Specific issues identified during a Walk-Around that require ticket-level follow-up are recorded against the relevant ticket as a private note. Patterns of repeated shortfall identified across multiple Walk-Arounds are fed into the agent's monthly one-to-one and, where required, the development plan or disciplinary process.

### 7.1.13.6 How we address shortfall

Where a Walk-Around identifies an isolated issue (a stale ticket, a missing next action), it is corrected at the time. Where Walk-Arounds repeatedly surface the same issue with the same agent, the matter is escalated to the agent's monthly one-to-one and, if required, to the development plan or disciplinary process. Failure by a Team Leader to conduct Walk-Arounds with the required frequency is addressed by the Helpdesk Manager during weekly review.
