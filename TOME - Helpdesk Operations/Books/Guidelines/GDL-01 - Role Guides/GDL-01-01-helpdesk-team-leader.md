# Helpdesk Team Leader Guide

## 1.1.1 Document Control

### 1.1.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 06/05/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 1.1.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 06/05/2026 | 01/08/2026  |

### 1.1.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.0     | Stephen Richardson | 06/05/2026 |
| 1.0     | Rupert Evans       | 06/05/2026 |

### 1.1.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 06/05/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 06/05/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 06/05/2026 |

## 1.1.2 Purpose

This guide is a single-document orientation to the Helpdesk Team Leader role. It does not replace any policy. It explains, in plain terms, what a Team Leader is for, what your day looks like, what you decide on your own, what you escalate, and where to find the authoritative rule when you need it.

It is written so that a new Team Leader can read it end-to-end on day one, and an experienced Team Leader can use it as a quick reference when something happens that they have not handled before.

## 1.1.3 Scope

This guide is a **Guideline (GDL)** under the Naming Convention: recommended practice, not mandatory rules. The mandatory rules live in the Governance policies. Where this guide and a policy appear to conflict, the policy wins, and the conflict is a sign that this guide needs updating - raise it under [POL-07-02 Policy Retrospective Review (PRR)](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-02-policy-retrospective-review-prr.md).

This guide applies to all Helpdesk Team Leaders. It is also useful for:

- Helpdesk Manager, as a description of what is being delegated
- Senior agents preparing for promotion to Team Leader
- New Team Leaders during their probation
- Stakeholders outside the Helpdesk who need to understand what the role covers

## 1.1.4 How to use this guide

Three rules:

1. **Read it once, end-to-end, on day one.** Every section after this introduces something you will be expected to do or decide. Skim is not enough.
2. **Use it as a map, not a manual.** Each operational topic has a short orientation here and a cross-reference into the policy that is authoritative. When you need detail, follow the link.
3. **Treat the policy as truth, this guide as commentary.** If you find a discrepancy, the policy is correct and this guide is out of date. Raise the discrepancy through PRR so the guide is refreshed.

A policy index for the Team Leader view is in section 1.1.15.

## 1.1.5 The role

### 1.1.5.1 What a Team Leader is for

A Team Leader exists to make sure that work gets done well, by people who are supported, in a way the business can defend. That collapses into four accountabilities, each of which has policies behind it:

| Accountability | What it means | Where the rules live |
| -------------- | ------------- | -------------------- |
| **Service quality** | SLA performance, customer experience, ticket quality | [POL-02 Lifecycle & Classification](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/), [POL-03 Non-Critical Ticket Handling](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/), [POL-06 Customer Service](../../Governance/POL-06%20-%20Customer%20Service/) |
| **Team performance** | Queue health, agent capability, throughput | [POL-03-06 Queue Management](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-06-queue-management.md), [POL-07 Quality Assurance](../../Governance/POL-07%20-%20Quality%20Assurance/), [POL-08-02 Professional Advancement](../../Governance/POL-08%20-%20Resource%20Management/POL-08-02-professional-advancement.md) |
| **Compliance** | Policy adherence, evidence, governance | [POL-01-04 Document Control Policy](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md), [POL-09 Discipline](../../Governance/POL-09%20-%20Discipline/) |
| **Wellbeing** | Capacity, sustainability, culture | [POL-07-10 Agent Wellbeing and Workload Management](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-10-agent-wellbeing-and-workload-management.md), [POL-08-01 Helpdesk Rota and Breaks](../../Governance/POL-08%20-%20Resource%20Management/POL-08-01-helpdesk-rota-and-breaks.md) |

These overlap. A queue that is too deep is a service quality problem and a wellbeing problem. An agent who is silently struggling is a wellbeing problem and a team performance problem. Hold all four in view.

### 1.1.5.2 Reporting line

You report to the Helpdesk Manager. You are accountable for the agents on your team, and you are jointly accountable with the other Team Leader(s) for shared queues, the unassigned queue, the daily checks, and walk-around coverage when one of you is out.

The Helpdesk Manager can override your decisions. You cannot override theirs. Where the two of you disagree, raise it explicitly rather than working around it.

### 1.1.5.3 Span of control

You are responsible for everything that happens on your team's tickets during your shift, and for the outcomes of any ticket where the assigned agent reports to you. You are not responsible for resolving every ticket personally - your job is to make sure each agent has the support, information, and capacity they need to resolve it themselves.

If you are doing a lot of agent work, ask why. The answer is usually one of: capacity gap, capability gap, or escalation that needs to leave the helpdesk. All three are things you should escalate, not absorb.

## 1.1.6 The shape of a working day

This is the operating cadence in normal conditions. Major incidents and other exceptions break the rhythm; resume it as soon as the exception is closed.

### 1.1.6.1 Start of shift

- Read overnight handover (Teams, ticket notes, any ESR or PIR notifications)
- Check the unassigned queue and dispatch what is ready (per [POL-02-03 Dispatch Policy](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/POL-02-03-dispatch-policy.md))
- Conduct the morning **Ticket Status Check** before 1000 (per [POL-07-01 §7.1.5](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md))
- Identify any ticket within range of a same-day SLA milestone and flag it to the assigned agent
- Confirm everyone scheduled is logged in; chase absences

### 1.1.6.2 Mid-shift

- Conduct **Daily Walk-Arounds** with risk-prioritised agents (per [POL-07-01 §7.1.13](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md))
- Run **Dredging** at least once during the day (per [POL-07-01 §7.1.12](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md))
- Watch the **Breadboard** scores - intervene if anyone is climbing
- Cover breaks per [POL-08-01 Helpdesk Rota and Breaks](../../Governance/POL-08%20-%20Resource%20Management/POL-08-01-helpdesk-rota-and-breaks.md)
- Clear escalations from agents in the moment - do not let them queue up

### 1.1.6.3 End of shift

- Conduct the afternoon **Ticket Status Check** after 1600
- Confirm Breadboard scores are zero before agents go home (per [POL-07-01 §7.1.9.2](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md))
- Hand over any open issues to the next shift (incoming Team Leader, on-call, or via Teams)
- Record check outcomes for the weekly stats
- Close out walk-around log entries for the day

## 1.1.7 The shape of the week and month

### 1.1.7.1 Weekly

- **Register review** - per [POL-01-04 §1.4.13](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md), monthly review of both document registers, but a weekly check that nothing pressing has slipped is good practice
- **Walk-Around coverage check** - confirm every agent has had at least one walk-around in the past seven days (per [POL-07-01 §7.1.13.4](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md))
- **Weekly stats compilation** - SLA outcomes, breach classifications, walk-around coverage, breadboard summary, telephony usage
- **Critical Care recheck** for the week (per [POL-07-01 §7.1.8](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md))
- **Quality Sampling** on Tuesdays and Thursdays where in force (per [POL-07-04](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-04-ticket-quality-sampling.md))

### 1.1.7.2 Monthly

- **One-to-one with each agent** - structured discussion of performance, sampling outcomes, development, wellbeing
- **Monthly register review** - formal pass per [POL-01-04 §1.4.13](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md), raise overdue reviews to the relevant Document Owner
- **Monthly statistics report** to the Helpdesk Manager
- **Incident review** of any Critical/Major Incident from the prior month, contribution to PRR/ESR (per [POL-07-02](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-02-policy-retrospective-review-prr.md), [POL-06-03](../../Governance/POL-06%20-%20Customer%20Service/POL-06-03-event-summary-report-esr.md))

## 1.1.8 Operational duties

### 1.1.8.1 Queue health

The unassigned queue, agent queues, and escalation queues are your operating picture. You are looking for:

- Tickets unassigned beyond their dispatch window
- Agent queues that are too deep, too old, or too high-priority for the agent's tier
- Stale tickets (no update in 24h) that aren't legitimately status-held

Authoritative rules: [POL-03-06 Queue Management](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-06-queue-management.md). Dispatch limits live in the Dispatch Limits section of [POL-02-03 Dispatch Policy](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/POL-02-03-dispatch-policy.md).

### 1.1.8.2 Twice-daily Ticket Status Checks (Formal)

These are formal checks against [POL-03-02 Ticket Status Usage Policy](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-02-ticket-status-usage-policy.md). Conduct one before 1000 and one after 1600. Failures are aggregated and reported in the weekly stats. Failure to conduct a check is itself reportable to the Helpdesk Manager. See [POL-07-01 §7.1.5](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md).

### 1.1.8.3 Daily Walk-Arounds (Informal, semi-formal)

Agent-facing queue review with each agent, conducted with them rather than on their behalf. Risk-prioritised; minimum once per agent per week regardless. See [POL-07-01 §7.1.13](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md).

The walk-around is the place where you connect "what the queue says" to "what the agent is actually doing." Use it to spot capacity pressure and capability gaps before they become breaches.

### 1.1.8.4 Dredging (Informal)

Daily desk-based ticket grooming for tickets >1 day old or without an update in 24h, where there is no scheduled next action. Walk-arounds are agent-facing; dredging is desk-based. They complement, not substitute. See [POL-07-01 §7.1.12](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md).

### 1.1.8.5 Bread, Manual Bread, and Breadboard

- **Breadboard** - automated count of stale tickets per agent, visible in shared forum. Agents zero their score by end of shift. You watch the scores during the day.
- **Bread / Manual Bread** - on-demand deeper compliance check, used when a pattern is suspected, after recurring issues, or for assurance.

See [POL-07-01 §7.1.9–§7.1.11](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md).

### 1.1.8.6 Critical Care checks

Re-check Critical Care tickets to a higher standard and tighter tolerance. Failures are addressed immediately. See [POL-07-01 §7.1.8](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md).

### 1.1.8.7 SLA breach classification

Every response SLA breach is classified into one of: Miss Triage, Miss Dispatch, Slow to Respond, Ticket Conduct, External Breach, Team Leaders, False Positive. The classification determines who owns remediation. See [POL-07-01 §7.1.7](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md) and [POL-04-08 Service Level Breach Remediation](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-08-service-level-breach-remediation.md).

When a breach falls into "Team Leaders," it stays with you. Don't reclassify it to make the stats look better; classification is evidence.

## 1.1.9 People leadership

### 1.1.9.1 One-to-ones

Monthly, structured, recorded. Cover:

- Performance against Matrix expectations and recent QA sampling outcomes
- Development plan progress (where in force per [POL-09-03 Development Plan Policy](../../Governance/POL-09%20-%20Discipline/POL-09-03-development-plan-policy.md))
- Workload, wellbeing, anything raised by the agent
- Recognition of recent good work

Notes are stored in the agent's HR documentation. One-to-ones are not where you raise a brand-new disciplinary concern for the first time - if you have a concern that warrants formal handling, use the disciplinary process directly per [POL-09-01](../../Governance/POL-09%20-%20Discipline/POL-09-01-disciplinary-process.md).

### 1.1.9.2 Coaching in the moment

The walk-around and the live escalation are your highest-leverage coaching opportunities. Catch a problem at the ticket level, with the agent present, while it is small. By the time it shows up in a sampling score, the customer has already experienced it.

### 1.1.9.3 Underperformance and Development Plans

When an agent's performance is consistently below expectation, follow [POL-09-03 Development Plan Policy](../../Governance/POL-09%20-%20Discipline/POL-09-03-development-plan-policy.md). A Development Plan is not a punishment - it is a structured support tool. Use it before, not after, the disciplinary process.

Where the underperformance is conduct rather than capability, use [POL-09-01 Disciplinary Process](../../Governance/POL-09%20-%20Discipline/POL-09-01-disciplinary-process.md) directly. The two policies are complementary, not interchangeable.

### 1.1.9.4 Wellbeing and workload

Take it seriously even when it is inconvenient. The signals you should watch for: agents skipping or shortening breaks, queues that stay disproportionate without redistribution, repeated tickets that the agent privately raises as draining, withdrawal from team comms.

Raised concerns must not result in negative consequences. If an agent comes to you with a workload concern, your default action is to assess and adjust, not to push back.

See [POL-07-10 Agent Wellbeing and Workload Management](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-10-agent-wellbeing-and-workload-management.md) and [POL-08-01 Helpdesk Rota and Breaks](../../Governance/POL-08%20-%20Resource%20Management/POL-08-01-helpdesk-rota-and-breaks.md).

### 1.1.9.5 Conflict

Two agents in conflict is yours to resolve quickly. Conflict between an agent and another business unit is jointly yours and the relevant counterpart's. Conflict involving you personally goes to the Helpdesk Manager.

[POL-09-04 Helpdesk Behaviour & Language Policy](../../Governance/POL-09%20-%20Discipline/POL-09-04-helpdesk-behaviour-and-language-policy.md) sets the conduct floor. [POL-09-02 Grievance Process](../../Governance/POL-09%20-%20Discipline/POL-09-02-grievance-process.md) is available to any agent who feels the situation warrants it.

### 1.1.9.6 Onboarding new starters

Follow [POL-07-05 New Starter & Onboarding](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-05-new-starter-and-onboarding.md). Your role:

- Confirm their accounts, accesses, and tooling are in place before day one
- Pair them with a buddy from the team
- Personally walk them through this guide, the daily cadence, and the Ticket Status Usage Policy
- Schedule check-ins at week 1, week 2, week 4, and at the end of probation
- Apply the Direct Entry expectations where applicable per [POL-08-02 §8.2.6](../../Governance/POL-08%20-%20Resource%20Management/POL-08-02-professional-advancement.md)

### 1.1.9.7 Professional advancement

Advancement is gated by Matrix score, Matrix deviation, exams, and (where required) technical interviews. You contribute the performance evidence; you do not unilaterally promote. Decisions are made jointly with the Helpdesk Manager and recorded in HR documentation.

See [POL-08-02 Professional Advancement](../../Governance/POL-08%20-%20Resource%20Management/POL-08-02-professional-advancement.md). The Role Framework diagram is at [DIA-04](../../Governance/Diagrams/DIA-04%20-%20Role%20Framework.png).

## 1.1.10 Incident handling

### 1.1.10.1 Critical Incidents

A Critical Incident is a customer-impacting issue with significant business consequence (availability, security, financial). Your immediate role:

- Confirm the categorisation per [POL-04-02 Categorization](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-02-categorization.md)
- Invoke the response under [POL-04-03 Critical Incident Policy](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-03-critical-incident-policy.md)
- Free the assigned agent from non-critical work and allocate support
- Ensure customer communications and stakeholder updates are happening - assign someone to comms explicitly if needed

You are not the swarm leader by default - the swarm process has its own role allocation. See 1.1.10.4.

### 1.1.10.2 Major Operational Incidents

Major Operational Incidents are large-scale operational events affecting Digital Origin's service delivery (e.g. RMM tooling outage, mass ticket surge). The handling differs from a per-customer Critical Incident; see [POL-04-05 Major Operational Incident Policy](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-05-major-operational-incident-policy.md).

### 1.1.10.3 Major Security Incidents

Anything with a credible security impact (suspected breach, credential compromise, data exposure). The threshold for invoking the major security incident process is deliberately low - if you are unsure, invoke and stand down later. See [POL-04-06 Major Security Incident Policy](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-06-major-security-incident-policy.md).

Don't try to handle a security incident inside a normal ticket comment thread. The major security incident process has the right routing.

### 1.1.10.4 Major Incident Escalation (Swarm)

When the incident requires multiple skill sets simultaneously, the Swarm process is invoked per [POL-04-04 Major Incident Escalation Policy (Swarm Team)](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-04-major-incident-escalation-policy-swarm-team.md). The Swarm Leader runs the swarm using [FRM-04 Swarm Leader Checklist](../../Governance/Forms/frm-04-swarm-leaderchecklist.docx). Visual: [DIA-05 Swarm Flow](../../Governance/Diagrams/dia-05-swarm-flow.html).

You may be the Swarm Leader for an incident, or you may be coordinating cover for another Team Leader who is. Be explicit about who holds the role.

### 1.1.10.5 Known Issues and mass communication

Where a single root cause is generating multiple inbound tickets, declare it a Known Issue and switch the helpdesk to the mass communication mode defined in [POL-04-07 Known Issues & Mass Communication Policy](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-07-known-issues-and-mass-communication-policy.md).

Mass communication needs explicit approval. The decision to send is not a unilateral Team Leader call - follow the approval chain in the policy.

### 1.1.10.6 Service Level Breach Remediation

Once an SLA breach has occurred, the remediation path is defined by the breach classification (see 1.1.8.7). Follow [POL-04-08 Service Level Breach Remediation](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-08-service-level-breach-remediation.md). Customer-facing remediation may require Service Delivery or the Account Manager - involve them early.

## 1.1.11 Customer-facing leadership

### 1.1.11.1 Escalations from agents

When an agent escalates to you, your job is to remove the blocker, not absorb the ticket. Ask:

- Is this a capacity gap (someone else can take it)?
- Is this a capability gap (the agent needs help, not replacement)?
- Is this beyond the helpdesk (third party, vendor, internal team)?

Escalations involving customer-facing risk (complaint, threat to leave, threat to escalate to leadership) come to you immediately. See [POL-03-07 Escalation Policy](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-07-escalation-policy.md).

### 1.1.11.2 Complaints

Handle per [POL-06-02 Handling Complaints and Difficult Customers](../../Governance/POL-06%20-%20Customer%20Service/POL-06-02-handling-complaints-and-difficult-customers.md). A complaint is not a failure to be hidden - it is information about a gap in service delivery. Document accurately, involve Account Management where the policy directs, and feed systemic issues into PRR.

### 1.1.11.3 Stakeholder updates during incidents

You may be the on-shift face of the helpdesk to a customer or stakeholder during a Critical Incident. Use the templates in [POL-06-04 Communication Templates and Standards](../../Governance/POL-06%20-%20Customer%20Service/POL-06-04-communication-templates-and-standards.md) and the cadence defined in the relevant incident policy. Under-promise, over-update.

### 1.1.11.4 Event Summary Reports (ESR)

Following a Critical Incident, an ESR is prepared per [POL-06-03 Event Summary Report (ESR)](../../Governance/POL-06%20-%20Customer%20Service/POL-06-03-event-summary-report-esr.md) using [FRM-03 Event Summary Report](../../Governance/Forms/frm-03-event-summary-report-esr.docx). You may be the author or a contributor; the assignment is per the incident policy.

ESRs are customer-facing and human-factor sensitive. Do not name individuals. Focus on process and contributing conditions.

## 1.1.12 Decision authority and escalation

A rough map of who decides what. Where an item appears in multiple rows, the higher authority wins.

| You decide alone | You escalate to the Helpdesk Manager | Needs Executive Sponsor |
| --- | --- | --- |
| Ticket reassignment within your team | Cross-team or out-of-band reassignment that affects another Team Leader | Structural changes to the policy set (per [POL-01-04 §1.4.10](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md)) |
| Walk-around schedule and coverage between Team Leaders on shift | Cover when both Team Leaders are unavailable | Major changes to a Published policy (per [POL-01-04 §1.4.7](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md)) |
| Day-to-day rota adjustments within published rules | Rota changes outside published rules; staffing pressure that may affect SLA | New policy retirement (per [POL-01-04 §1.4.9](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md)) |
| Coaching, in-the-moment correction | Initiating a Development Plan or Disciplinary process | - |
| Walk-Around outcomes and informal feedback | Persistent shortfall after coaching | - |
| Routine breach classification | Disputes over breach classification, especially Team Leader breaches | - |
| Invoking Swarm or Major Incident processes | Invoking the swarm where neither Team Leader is available | - |
| Approving an agent to clear their Breadboard with a documented exception | Mass-communication approval for Known Issues | - |
| Allocating tickets to your team | Cross-customer policy decisions, vendor escalations beyond agreed authority | - |

When in doubt, escalate. The cost of an unnecessary escalation is small. The cost of a missed escalation is paid by the customer or the agent.

### 1.1.12.1 When to involve HR

HR involvement is required when:

- A formal disciplinary stage is reached per [POL-09-01](../../Governance/POL-09%20-%20Discipline/POL-09-01-disciplinary-process.md)
- A grievance is raised per [POL-09-02](../../Governance/POL-09%20-%20Discipline/POL-09-02-grievance-process.md)
- A wellbeing concern crosses into formal welfare territory (extended absence, reasonable adjustments, occupational health)
- Any conflict involves a protected characteristic or potential discrimination

You initiate the involvement; the Helpdesk Manager and HR run the process. Your role from that point is to provide accurate, dated evidence and to continue managing the agent's day-to-day fairly.

## 1.1.13 Documentation responsibilities

### 1.1.13.1 Document Control

You are a Document Owner for any document where your name is in the Owner field. Owners are accountable per [POL-01-04 Document Control Policy](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md). The headline obligations:

- Keep your documents on-cadence (Next Review dates do not slip silently)
- Bump the version on any change, with a Revision History entry
- For Major changes, get re-approval from Executive Sponsors before publishing
- Notify stakeholders on Major changes

### 1.1.13.2 Document registers

Both registers (Governance and any future book) are themselves controlled documents. They are **regenerated on change, not edited piecemeal**. You are responsible for triggering regeneration when:

- A document is added, retired, or re-versioned
- A document's Owner or Next Review date changes
- A new section is added or retired
- A form or diagram changes

See [POL-01-04 §1.4.11](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md).

### 1.1.13.3 The Naming Convention

The Naming Convention ([std-01](../../Governance/Book%20Reference/std-01-naming-convention.md)) governs identifiers, file naming, folder structure, heading numbering, and cross-references. When you create or change a document, follow it. When in doubt, look at how an existing document does it.

### 1.1.13.4 The book Change Log

Major changes to the document set are logged in the book's Changes document (Governance: [POL-01-02](../../Governance/POL-01%20-%20Overview/POL-01-02-changes.md)). Each entry summarises what changed and why. The log is append-only.

## 1.1.14 Continuous improvement

The helpdesk is meant to evolve. Three mechanisms feed that evolution back into policy:

### 1.1.14.1 Policy Retrospective Review (PRR)

PRR is the formal process for reviewing a policy after a triggering event - typically an incident, a recurring issue, or a deviation that flagged a policy gap. See [POL-07-02 Policy Retrospective Review (PRR)](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-02-policy-retrospective-review-prr.md) and [FRM-02](../../Governance/Forms/frm-02-policy-restrospective-review-prr.docx).

PRR is **blameless** and process-focused. Do not name individuals in the output.

### 1.1.14.2 Event Summary Report (ESR)

ESR is the customer-facing summary of a major event. It is also a vehicle for surfacing systemic issues to the wider business. See [POL-06-03 Event Summary Report (ESR)](../../Governance/POL-06%20-%20Customer%20Service/POL-06-03-event-summary-report-esr.md).

### 1.1.14.3 Deviation handling

When you find that a published policy is unworkable or in conflict with operational reality, that is a signal the policy needs updating - not a justification for informal deviation. Raise it through PRR. See [POL-01-04 §1.4.12](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md).

Adherence to a written process, even where it does not produce the desired outcome in a specific instance, is never grounds for disciplinary action. Be explicit about this with your team. It changes the way they raise issues.

## 1.1.15 Policy index (Team Leader view)

Quick reference of what every Governance policy means for you as a Team Leader. Where a policy is largely agent-facing, the column captures your oversight role; where it is leader-facing, it captures your operating responsibility.

### 1.1.15.1 Overview

| Policy | Your responsibility |
| --- | --- |
| [POL-01-01 Introduction](../../Governance/POL-01%20-%20Overview/POL-01-01-introduction.md) | Orient new starters; reinforce that the manual is the source of truth |
| [POL-01-02 Changes](../../Governance/POL-01%20-%20Overview/POL-01-02-changes.md) | Append entries when you make Major changes; never edit prior entries |
| [POL-01-03 Related Documents](../../Governance/POL-01%20-%20Overview/POL-01-03-related-documents.md) | Update when a new form, diagram, or supporting doc is added or retired |
| [POL-01-04 Document Control Policy](../../Governance/POL-01%20-%20Overview/POL-01-04-document-control-policy.md) | The constitution of the document set - know it cold |

### 1.1.15.2 Ticket Lifecycle & Classification

| Policy | Your responsibility |
| --- | --- |
| [POL-02-01 Lifecycle Flowchart](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/POL-02-01-lifecycle-flowchart.md) | Reference for new starters; spot-check tickets that drift outside the flow |
| [POL-02-02 Triage Policy](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/POL-02-02-triage-policy.md) | Verify triage quality during checks; reclassify Miss-Triage breaches |
| [POL-02-03 Dispatch Policy](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/POL-02-03-dispatch-policy.md) | Enforce Dispatch Limits; intervene when limits would be breached |
| [POL-02-04 SLA Milestones](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/POL-02-04-sla-milestones.md) | Daily SLA risk monitoring; flag at-risk tickets to assigned agents |
| [POL-02-05 Priority Classification](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/POL-02-05-priority-classification-policy.md) | Verify priority correctness; reclassify where wrong (with audit trail) |
| [POL-02-06 Documentation Standards](../../Governance/POL-02%20-%20Ticket%20Lifecycle%20&%20Classification/POL-02-06-documentation-standards.md) | The standard you check against during walk-arounds and Bread |

### 1.1.15.3 Non-Critical Ticket Handling

| Policy | Your responsibility |
| --- | --- |
| [POL-03-01 Ticket Type Usage](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-01-ticket-type-usage-policy.md) | Spot-check during sampling; correct in-flight |
| [POL-03-02 Ticket Status Usage](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-02-ticket-status-usage-policy.md) | The reference for twice-daily Ticket Status Checks |
| [POL-03-03 Ticket Communication](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-03-ticket-communication-policy.md) | Telephony usage and customer comms standards - check during Bread |
| [POL-03-04 Ticket Closure, Reopen and Recurrence](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-04-ticket-closure-reopen-and-recurrence.md) | Recurrence is a signal - investigate before re-closing |
| [POL-03-05 Ticket Ownership and Handover](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-05-ticket-ownership-and-handover-policy.md) | Minimise handovers; when unavoidable, ensure quality |
| [POL-03-06 Queue Management](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-06-queue-management.md) | Your daily operating doctrine |
| [POL-03-07 Escalation Policy](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-07-escalation-policy.md) | First responder for agent escalations |
| [POL-03-08 Problem Management](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-08-problem-management.md) | Identify problems through queue review and recurrence; raise to PM |
| [POL-03-09 Change Management (Customer-side)](../../Governance/POL-03%20-%20Non-Critical%20Ticket%20Handling/POL-03-09-change-management-customer-side.md) | Confirm written authorisation before sanctioning customer-side changes |

### 1.1.15.4 Critical & Major Incident Handling

| Policy | Your responsibility |
| --- | --- |
| [POL-04-01 Overview](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-01-overview.md) | Orientation - how the incident set fits together |
| [POL-04-02 Categorization](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-02-categorization.md) | Confirm category at the point of declaration |
| [POL-04-03 Critical Incident Policy](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-03-critical-incident-policy.md) | Invoke; coordinate; ensure comms |
| [POL-04-04 Major Incident Escalation (Swarm)](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-04-major-incident-escalation-policy-swarm-team.md) | Be the Swarm Leader, or coordinate the cover |
| [POL-04-05 Major Operational Incident](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-05-major-operational-incident-policy.md) | Recognise and invoke - distinct from per-customer incidents |
| [POL-04-06 Major Security Incident](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-06-major-security-incident-policy.md) | Low threshold to invoke - if unsure, invoke |
| [POL-04-07 Known Issues & Mass Communication](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-07-known-issues-and-mass-communication-policy.md) | Declare; route inbound tickets; secure approval before mass comms |
| [POL-04-08 Service Level Breach Remediation](../../Governance/POL-04%20-%20Critical%20&%20Major%20Incident%20Handling/POL-04-08-service-level-breach-remediation.md) | Classify breaches accurately; remediate by classification |

### 1.1.15.5 IT Operations

| Policy | Your responsibility |
| --- | --- |
| [POL-05-01 Local Administrator Use](../../Governance/POL-05%20-%20IT%20Operations/POL-05-01-use-of-the-local-administrator-group-on-customer-machines.md) | Verify justified use during sampling |
| [POL-05-02 Password & Credential Handling](../../Governance/POL-05%20-%20IT%20Operations/POL-05-02-password-and-credential-handling-policy.md) | Reinforce in walk-arounds; treat breaches as security incidents |
| [POL-05-03 Information Security and Data Handling](../../Governance/POL-05%20-%20IT%20Operations/POL-05-03-information-security-and-data-handling-policy.md) | Recognise and route data-handling incidents per security incident policy |
| [POL-05-04 Vendor and Third-Party Access](../../Governance/POL-05%20-%20IT%20Operations/POL-05-04-vendor-and-third-party-access-policy.md) | Approve vendor access requests within published authority |
| [POL-05-05 Tooling & Asset Management Standards](../../Governance/POL-05%20-%20IT%20Operations/POL-05-05-tooling-and-asset-management-standards.md) | Ensure tooling is recorded; raise gaps |

### 1.1.15.6 Customer Service

| Policy | Your responsibility |
| --- | --- |
| [POL-06-01 Phone Etiquette Guide](../../Governance/POL-06%20-%20Customer%20Service/POL-06-01-phone-etiquette-guide.md) | Coach in walk-arounds; reinforce telephony as primary contact |
| [POL-06-02 Handling Complaints and Difficult Customers](../../Governance/POL-06%20-%20Customer%20Service/POL-06-02-handling-complaints-and-difficult-customers.md) | First responder; involve AM where the policy directs |
| [POL-06-03 Event Summary Report (ESR)](../../Governance/POL-06%20-%20Customer%20Service/POL-06-03-event-summary-report-esr.md) | Author or contributor following major events |
| [POL-06-04 Communication Templates and Standards](../../Governance/POL-06%20-%20Customer%20Service/POL-06-04-communication-templates-and-standards.md) | The reference for all customer-facing comms during incidents |

### 1.1.15.7 Quality Assurance

| Policy | Your responsibility |
| --- | --- |
| [POL-07-01 Ticket Hygiene Tooling](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-01-ticket-hygiene-tooling.md) | Your daily/weekly toolset - know every section |
| [POL-07-02 Policy Retrospective Review (PRR)](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-02-policy-retrospective-review-prr.md) | Trigger; participate; treat as blameless |
| [POL-07-03 Projects to Helpdesk Handover](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-03-projects-to-helpdesk-handover.md) | Run the STR; refuse incomplete handovers |
| [POL-07-04 Ticket Quality Sampling](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-04-ticket-quality-sampling.md) | Conduct on Tue/Thu where in force; feed back in monthly one-to-one |
| [POL-07-05 New Starter & Onboarding](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-05-new-starter-and-onboarding.md) | Run for every new starter on your team |
| [POL-07-06 Training](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-06-training.md) | Identify training needs; sponsor enrolment |
| [POL-07-07 Tooling and Systems](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-07-tooling-and-systems.md) | Confirm agent tooling is current and licensed |
| [POL-07-08 Knowledge Management](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-08-knowledge-management.md) | Reinforce KB use during walk-arounds |
| [POL-07-09 Knowledge Base Management](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-09-knowledge-base-management.md) | Encourage KB contribution; sample for accuracy |
| [POL-07-10 Agent Wellbeing and Workload Management](../../Governance/POL-07%20-%20Quality%20Assurance/POL-07-10-agent-wellbeing-and-workload-management.md) | Watch the signals; act on raised concerns |

### 1.1.15.8 Resource Management

| Policy | Your responsibility |
| --- | --- |
| [POL-08-01 Helpdesk Rota and Breaks](../../Governance/POL-08%20-%20Resource%20Management/POL-08-01-helpdesk-rota-and-breaks.md) | Cover breaks; enforce break compliance |
| [POL-08-02 Professional Advancement](../../Governance/POL-08%20-%20Resource%20Management/POL-08-02-professional-advancement.md) | Provide evidence; do not unilaterally advance |
| [POL-08-03 Remote and Hybrid Working](../../Governance/POL-08%20-%20Resource%20Management/POL-08-03-remote-and-hybrid-working-policy.md) | Apply published rules consistently |
| [POL-08-04 Out-of-Hours and On-Call](../../Governance/POL-08%20-%20Resource%20Management/POL-08-04-out-of-hours-and-on-call-policy.md) | Run the rota; respect the deferral rules |

### 1.1.15.9 Discipline

| Policy | Your responsibility |
| --- | --- |
| [POL-09-01 Disciplinary Process](../../Governance/POL-09%20-%20Discipline/POL-09-01-disciplinary-process.md) | Initiate; provide accurate evidence; never used punitively for honest deviation |
| [POL-09-02 Grievance Process](../../Governance/POL-09%20-%20Discipline/POL-09-02-grievance-process.md) | Receive grievances neutrally; route to Helpdesk Manager / HR |
| [POL-09-03 Development Plan Policy](../../Governance/POL-09%20-%20Discipline/POL-09-03-development-plan-policy.md) | Author DPs for capability gaps; review on cadence |
| [POL-09-04 Helpdesk Behaviour & Language Policy](../../Governance/POL-09%20-%20Discipline/POL-09-04-helpdesk-behaviour-and-language-policy.md) | The conduct floor; coach where breached |

### 1.1.15.10 Appendices

| Policy | Your responsibility |
| --- | --- |
| [POL-10-01 DUO Use of Bypass](../../Governance/POL-10%20-%20Appendices/POL-10-01-appendix-duo-use-of-bypass.md) | Approve only per the appendix; record use |
| [POL-10-02 AI Usage Policy](../../Governance/POL-10%20-%20Appendices/POL-10-02-appendix-ai-usage-policy.md) | Reinforce in walk-arounds; sample for compliance |
| [POL-10-03 Helpdesk Ticket Screening for Live Projects](../../Governance/POL-10%20-%20Appendices/POL-10-03-appendix-helpdesk-ticket-screening-for-live-projects.md) | Screen and route; refuse where the appendix directs |
| [POL-10-04 Quoting](../../Governance/POL-10%20-%20Appendices/POL-10-04-appendix-quoting.md) | Approve child quoting tickets per appendix authority |

## 1.1.16 Closing

The shortest version of this guide is: **make sure work gets done well, by people who are supported, in a way the business can defend.** Everything in this guide is a tool for one of those three things. If you find yourself doing something that does not advance any of them, stop and ask why.
