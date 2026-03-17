Helpdesk Operations Manual

VE.4

2026

# Overview

## Introduction

This Helpdesk Operations Manual is a collection of self-contained
policies, procedures, and working standards that define how Digital
Origin’s Helpdesk operates day-to-day. It is designed to create
consistent service delivery, protect SLA performance, and ensure
customers receive a predictable, high-quality experience regardless of
which agent handles a ticket.

The manual is intentionally structured so that individual sections can
be read and applied independently. Where dependencies exist (for
example, where one policy references escalation handling, ticket
statuses, or communications), the relevant policy will be referenced
directly.

### Purpose

The purpose of this document is to:

- Set clear expectations for ticket ownership, quality, and customer
  communication

- Provide repeatable processes for triage, dispatch, escalation, and
  incident handling

- Reduce ambiguity by defining what “good” looks like, including minimum
  standards and prohibited practices

- Support onboarding and development by giving agents a single,
  authoritative reference for how the Helpdesk should run

### Scope

This manual applies to all Helpdesk activity performed under Digital
Origin, including:

- Incidents and service requests handled through the helpdesk ticketing
  system

- Critical incident response processes and associated roles

- Operational standards that affect the customer experience
  (communications, hygiene, QA practices, and related governance)

Where a section is marked as [Placeholder] or (NF / Not in Force), it
is either incomplete, pending approval, or not currently enforced as
policy.

### Audience and responsibilities

**This document is for internal use only.**

This manual is written for:

- Helpdesk Agents – expected to follow relevant policies as part of
  normal ticket handling

- Team Leaders / CLS – responsible for enforcing, coaching, and ensuring
  consistent application

- Escalations Engineers and supporting teams – expected to align with
  relevant processes where they interact with Helpdesk tickets

Unless a policy explicitly states otherwise, the default position is:

- The assigned agent owns the ticket outcome

- Quality standards apply equally across all queues and ticket types

- Deviations must be justified and, where required, escalated via the
  appropriate route

### How to use this document

- Treat this manual as the source of truth for Helpdesk operational
  standards.

- Use it as a reference during ticket handling (especially around
  triage, priority, escalation, and customer communications).

- If multiple policies could apply, follow the most safety-critical or
  customer-impacting requirement first (e.g., security and critical
  incident controls take precedence). Continuous improvement and
  document governance

This manual will evolve. Where a policy is unclear, unworkable, or
conflicts with real operational constraints, that is a signal that the
policy should be improved—not informally ignored. Issues should be
raised through leadership so the document can be updated, and
expectations remain defensible, consistent, and achievable.

Following written process, even if it fails, will never result in
disciplinary action.

### Use of AI in this document

AI has been used throughout this document to assist with wording,
conciseness, and formatting; however, the content itself is
human-generated and remains owned and approved internally.

## Markdown Guide (How to Edit This Manual)

### Overview

This manual is written in Markdown (plain text with formatting). The website converts the Markdown into the readable manual you see.

This guide explains the formatting used in this document and how to update it safely.

### How the website uses headings

The website treats headings like this:

- H1 (a single # at the start of the line) = Section group in the left navigation (acts like a category/folder)
- H2 (two ## at the start of the line) = Policy page (clicking it shows only that policy)
- H3+ (three ### or more) = Subheadings inside a policy

Important: If you want something to appear as its own selectable page in the site, it must be an H2.

Example structure (copy/paste as a template):

    # Ticket Lifecycle & Classification
    ## Triage Policy (NF)
    ### Purpose
    ### Scope
    ### Expectation
    #### How we measure compliance
    #### Record keeping and documentation
    #### How we address shortfall

### Headings

Use headings to create structure:

    # Section name (H1)
    ## Policy name (H2)
    ### Sub-section (H3)
    #### Detail heading (H4)

Guidelines:

- Use one space after the # symbols.
- Keep headings short and consistent.
- Leave a blank line after headings for readability.

### Paragraphs and line breaks

Write normal text as paragraphs. Separate paragraphs with a blank line:

    This is paragraph one.
    
    This is paragraph two.

To force a line break inside a paragraph, end the line with two spaces:

    Line one.  
    Line two.

### Bold, italics, and inline code style

Use bold and italics:

- Bold: surround text with two asterisks on each side
- Italics: surround text with one asterisk on each side

Examples:

- Internal use only (bold)
- Not in Force (italics)

Note: This manual avoids inline code formatting because inline code uses backticks, and backticks break the website’s embedded Markdown block.

### Bullet lists

Use hyphens for bullets:

    - First item
    - Second item
      - Nested item
      - Nested item
    - Third item

Nested bullets should be indented by two spaces or more.

### Numbered lists

    1. Step one
    2. Step two
    3. Step three

Nested lists work the same way (indent the nested list).

### Links

    [Text to show](https://example.com)

### Notes / callouts

Use a greater-than symbol for notes:

    > This is a note.
    > It can span multiple lines.

### Code blocks

This manual uses indented code blocks (4 leading spaces) instead of fenced code blocks.

Example:

    Get-Process
    ipconfig /all

### Tables (recommended approach)

Use Markdown tables (avoid HTML tables):

    | Field        | Value        |
    |--------------|--------------|
    | Last Updated | 10/02/2026   |
    | Updated By   | Jason Mcdill |
    | Owner        | Jason Mcdill |

### Images

Use Markdown image syntax:

    ![Description of image](media/image1.png)

### Dividers

Use three hyphens on a line:

    ---

### Escaping special characters

If a line begins with # but you do not want it to become a heading, prefix it with a backslash.

### Editing checklist (quick)

- New major area? Use H1 (one # at the start of the line)
- New policy page? Use H2 (two ## at the start of the line)
- New subsections inside a policy? Use H3/H4
- Prefer Markdown tables over HTML tables
- Keep blank lines between blocks (headings, lists, tables) for readability

## Changes

<br>
All sections have either been re-written or directly converted to markdown and embedded in html

# Ticket Lifecycle & Classification

## Lifecycle Flowchart 

<img src="lifecycle_flowchart.png" style="width:6.92745in;height:9.15952in"
alt="Ticket lifecycle image" />

## Triage Policy (NF)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Types of Triage

#### Procedural Triage

Procedural triage is carried out but the CLS team using a Triage
workflow initiated with a “Triage” button in the ticket. While this is
primarily to aid the CLS in adding required initial information to a
ticket, it is a mandatory step in a ticket’s lifecycle.

Procedural triage is the only method carried out by the CLS team;
however, it must be carried out on all tickets that have not been
triaged as it triggers automations that are required to complete
processing of the ticket. Helpdesk engineers have additional
expectations when conducting initial triage.

#### Conventional Triage

In addition to procedural triage, a ticket will undergo further triage
at dispatch and/or once assigned, where required, allowing a technician
to confirm or update ticket details as required.

### Expectation

**All tickets processed by the CLS team or Helpdesk must, at a minimum**

have been procedurally triaged to ensure:

- Correct contact details are present

- Sufficient information exists to classify the ticket type and the
  request

**Helpdesk engineers correct any mistakes and add additional technicak information** 

- Correct any mistakes in the tickets details and infomration

- Provide further context, or clarification of the information already provided

#### How we measure compliance

Compliance and quality are assessed through:

- Daily checks (reviewing completeness and quality of ticket information

- Spot checks / ticket sampling (targeting reviews of randomly selected
  or high-risk tickets)

#### How we address shortfall

Shortfall is addressed through re/corrective training, and handled
entirely by the disciplinary process.

## Dispatch Policy

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

**This policy does not reflect changes to queue management and dispatch limitations (15 tickets per queue) for a brief overview of this practice see Appendix - Dispatch Limitations (Temporary)**

### Purpose

This policy defines the process for selecting and dispatching helpdesk
tickets in a consistent and effective manner.

### Scope

This policy applies to any party involved in the dispatch of helpdesk
tickets

### Responsibility Statement

Responsibility for dispatch falls on both the CLS and TL teams.

### Dispatch order of priority

The order that tickets are dispatched in is determined by the ticket’s
priority, then by the tickets remaining response SLA:

Critical Incidents (notification required, agent acknowledgement
required)

- High Priority Incidents (notification required)

- High Priority Service Requests (notification required)

- Moderate Incidents (by SLA remaining)

- High & Medium Service Requests (by SLA remaining)

- Low priority incidents and Service Requests (by SLA remaining)

Critical and High priority tickets always take precedence over all other
dispatches to ensure resources are directed where they are most needed.

This priority ensures that we are using available resource effectively,
addressing the right issues at the right time.

Dispatch of Critical and High priority incidents must be accompanied by
a notification, only critical priority incidents require the agent to
respond in acknowledgement.

### After-Dispatch CLS Interaction

CLS continue to take calls and pass them through to the appropriate
agents, on occasion the agent may be able to accept a call from CLS but
unable to progress the requisite ticket. If that is the case:

Provide CLS with reasonably accurate time estimate for when you will
respond to the ticket

Plan to meet this time expectation

CLS will not take and pass on any message, especially ticket updates or
technical information, on your behalf. If you have missed a time
expectation you have made on a previous call with CLS, you must take the
clients call and explain.

### Dispatch resource availability

The TL and CLS teams should communicate absence from the helpdesk
continuously to ensure that adequate cover for dispatch is maintained.

### Use of the skills matrix

The skills matrix incorporates a simplified view that shows the base
competence which the CLS team can use to quickly determine appropriate
dispatch on a “best chance of success” basis.

## Dispatch Responsibility Policy (Abandoned)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

This policy establishes clear responsibilities for the dispatch of
Incident and Service Request tickets between the CLS team and Team
Leaders. The goal is to ensure that all tickets are handled swiftly and
effectively.</s>

### Scope

This policy applies to the dispatch process of Incident and Service
Request tickets within the helpdesk. It defines the responsibilities
shared between the CLS and Team Leaders to maintain efficient ticket
management, particularly when dealing with tickets assigned a low to
medium priority allowing them to implement and support professional
progression through on-the-job training.</s>

### Policy Details</s>

Responsibility for low to medium ticket dispatch:</s>

The responsibility for the dispatch of Incident and Service Request
tickets of a low to medium priority is primarily held by the Team
Leaders.</s>

Responsibility for high to critical ticket dispatch:</s>

Both CLS and Team Leaders are accountable for the swift handling of
tickets marked with elevated priority. Tickets with high or critical
priority must be escalated and processed as quickly as possible to
ensure minimal disruption to operations. There is effectively no change
to the existing process.</s>

Team Leader availability:</s>

Team Leaders must communicate their availability to the CLS team on
an ongoing basis to ensure this process is resistant to sudden or
unplanned changes. If a Team Leader is unavailable due to absence or
being busy with other tasks, they are required to promptly inform
CLS.</s>

Use of skills matrix:</s>

The skills matrix will incorporate a simplified view that shows base
competence the CLS team can use to quickly determine appropriate
dispatch on a ‘best chance of success’ basis when performing dispatch on
behalf of the Team Leaders or dispatching high and critical priority
tickets.</s>

Absence or unavailability of Team Leaders:</s>

In situations where one or both Team Leaders are unavailable or
preoccupied with other tasks:</s>

The unavailable Team Leader(s) must notify the CLS team as soon as
possible.</s>

During these periods, the CLS team will assume full responsibility
for dispatching all Incident and Service Request tickets until the Team
Leader(s) are available to resume their duties.</s>

## SLA Milestones (NF)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

To define the target response and resolution times for tickets based on
their assigned priority and type. These targets ensure consistent
service deliver and provide clear expectations for both helpdesk staff
and customers.

### Service Level Agreements

Each ticket is subject to a service level agreement (SLA) that outlines
the maximum allowable time to respond to and resolve the issue. These
SLA milestones vary depending on whether the ticket is an incident or a
service request (SR) and are determined by the priority level assigned
during triage.

| Priority | Description | Response Target (Incident) | Response Target (SR) | Resolution Target (Incident) | Resolution Target (SR) |
| -------: | ----------- | -------------------------: | -------------------: | ---------------------------: | ---------------------: |
|        1 | Critical    |                      00:30 |                  N/A |                        02:00 |                    N/A |
|        2 | High        |                      01:00 |                04:00 |                        04:00 |                  08:00 |
|        3 | Moderate    |                      04:00 |                04:00 |                        08:00 |                 3 days |
|        4 | Low         |                      08:00 |                08:00 |                       3 days |                 5 days |

- Time expectations given are the maximum allowed, not the target.
  Tickets should be addressed as quickly as possible.

- Critical priority tickets are expected to be addressed immediately,
  regardless of their SLA.

- Security incidents are always given Critical priority until they are
  confirmed to be safe.

### Response Target

Response target is window in which a ticket must receive a response, to
meet the requirements of the response target the response must both
include the ticket user and progress the ticket in a meaningful way,
unless impossible.

### Resolution Target

The resolution target is the window in which the issue must be resolved,
to meet this requirement the client must confirm the issue is resolved
and the ticket must be “Resolved” or “Completed”

#### How we measure compliance

We measure compliance directly through stats recorded weekly and
monthly, per agent and whole desk.

#### Record keeping and documentation

Records of SLA performance are taken weekly and monthly at both whole
team and per agent levels, and kept indefinitely.

#### How we address shortfall

Shortfall is handled directly through the disciplinary process.

## Priority Classification Policy (NF)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

To ensure tickets are given accurate priority at the earliest stage and
updated appropriately throughout their lifecycle. This maintains SLA
integrity and ensures that high-impact issues receive the appropriate
urgency and response.

### Initital Classification

- Priority should be set:

  - At ticket creation if raised by the helpdesk

  - During triage if raised by the end user

- After dispatch, the receiving agent must confirm or adjust the
  priority before conducting any work

- It is the receiving agent’s responsibility to ensure accurate
  classification based on the tickets impact and urgency

- Initial classification uses a more aggressive matrix;
  re-classification – especially de-escalation – is often necessary as
  the situation becomes clearer

- Tickets marked as critical will trigger workflows based on the nature
  of the incident

#### How we measure compliance

- Spot-checks of newly created and triaged tickets for priority set
  correctly at first touch

- Dispatch audits: confirmation/adjustment completed before first
  technical action

- Sampling of “Critical” tickets to confirm workflow triggers were
  followed

- SLA review: mismatch patterns between priority and breach outcomes,
  escalations, or complaint volume

### Priority Re-Classification

- A ticket must retain the highest priority it was confirmed to be at
  any point

- If a lower-priority or otherwise related issue is discovered during
  the resolution of higher-priority ticket it should be raised as a
  child of the higher priority ticket

#### How we measure compliance

- Review of reclassification events and justification notes

- Checks that previously confirmed highest priority remains
  recorded/retained

- Sampling of high-priority tickets to confirm related lower-priority
  work is separated into child tickets where appropriate

#### Record keeping and documentation

Priority classification is checked daily, through our daily ticket
checks, through our weekly stats and through spot checks on high
priority or high-risk tickets.

#### How we address shortfall

Shortfall is handled informally through corrective training and
guidance, repeat failures are handled through the disciplinary process.

### Priority Classification Expectations

#### Priority 1 (Critical)

Priority 1 (P1) incidents represent critical issues that have a severe
and immediate impact on business operations, such as company-wide
outages, security breaches, or failures affecting multiple systems or
users. When a P1 is raised, it takes absolute precedence over all other
workloads. Agents must immediately stop work on any other tickets and
prioritise resolution of the P1.

#### Priority 2 (High)

Priority 2 (P2) incidents indicate a significant issue that causes
serious disruption, but on a more limited scale than a P1. For example,
a complete service outage affecting a single user or a critical function
within one department would be considered P2. These incidents require
prompt attention and timely resolution, but do not override P1
workloads.

The primary distinction between P1 and P2 is the scope and scale of
impact

#### Priority 3 (Moderate)

Priority 3 (P3) is the default level for most standard incidents. These
include issues that are disruptive but not urgent, such as software
bugs, intermittent performance problems, or single-user issues that have
viable workarounds.  
P3 incidents are handled in the order they are received, unless
escalated due to change in impact or urgency.

#### Priority 4 (low)

Priority 4 (P4) incidents are low-impact or long-term issues that do not
significantly affect user productivity or business operations. Examples
include feature requests, cosmetic UI issues, or planned work that is
not time-sensitive.  
These incidents are typically scheduled for resolution after higher
priority work has been completed.

#### How we measure compliance

[TBD]

#### Record keeping and documentation

Priority classification is checked daily, through our daily ticket
checks, through our weekly stats and through spot checks on high
priority or high-risk tickets.

#### How we address shortfall

Shortfall is handled informally through corrective training and
guidance, repeat failures are handled through the disciplinary process.

### CLS Priority Matrix

<img src="cls_priority_matrix.png" style="width:5.68351in;height:4.21348in"
alt="CLS Priority Matrix" />

### Helpdesk Priority Matrix

<img src="hd_priority_matrix.png" style="width:5.67555in;height:4.23091in"
alt="HD Priority Matrix" />

## Documentation Standards [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

# Non-Critical Ticket Handling

## Incident Management [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Service Request Management [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Ticket Type Usage Policy

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

To define and standardize the usage of ticket types across the helpdesk.

### Incidents & Telephony Incidents

Incidents represent a service disruption or interruption that is
unplanned and unintended.

- These are the most common tickets raised by end users.

- All security-related issues must be logged as incidents.

- Examples include:

  - Printer won’t print

  - Server down

  - Phishing email reported

### Service Requests & Telephony Service Requests

Service requests and user requests that do not represent a disruption or
interuption that is unplanned or unintended

- These requests involve standarad operational tasks or administative
  changes.

- Examples include:

  - Name or password changes

  - New user or PCE setup

  - Printer installation

### Telephony Task

Used for project-related or excpetional telephy incidents

- Not included in normal SLAs or standard reporting

- Typically long-term or out-of-scope tasks

- May involve monitoring, scheduling, or bespoke setups

### Problem

Used to link and track multipe related tickets

- Not used for direct actions or updates

- Srves two main purposes:

  - To doucment a widespread issue across clients or systems

  - To act as a perant to many tickets tied to a single root cause

- Must not contain any actionable work

- Should be raised and maintained by only Third Line engineers or Team
  Leaders

- Child tickets are created for all actual work related to the problem

### Service Delivery Support

[TBD]

### Projects Support

[TBD]

### hild Tickets

Child tickets are used to either **assign tasks** or **share workload**.
Each use case has specific requirements and expectations. In all
situations, a child ticket must be handled with the **same standards and
urgency** as any other helpdesk ticket, and all policies that would
apply to any other ticket, also apply to children except during
escalation (see the escalation policy).

#### Expectations

Child tickets must be treated as customer-impacting tickets raised on
behalf of a customer. The agent who raises the child ticket retains
ownership and accountability for it for its entire lifecycle.

The primary use of child tickets is to assign tasks to Account Managers,
however they may also be used to assign tasks to other teams or
individuals. Use of child tickets to share workload requires leadership
intervention and/or approval, except where automatic approval is defined
within the Escalations Policy.

#####> Assigning a task with a child ticket

Any helpdesk ticket created specifically for task assignment—regardless
of the receiving team or individual—must meet the expectations below.

A helpdesk agent may create a child ticket **without** leadership
approval only to:

- Assign a workload to an account manager

- Assign shipping instructions to CLS

#####> When creating a child ticket for account management

- The customer is always the agent that raised it and the company is
  Digital Origin

- The actual customer name must be present in the summary

- If a quote is required, have sought, and provide, the contact details
  of the VIP approver

- Clearly define the task needing achieved

- Accompany the assignment of the child with a secondary communication,
  preferably in teams or email

- The ticket must contain all the necessary context for it to be
  conducted independently

- The agent that creates the child ticket is responsible for ensuring it
  is conducted but:

  - Chase the account manager for updates daily

  - Apply a 3 strike rule to child tickets, but instead of closing it:
    escalate with a Team Leader

#####> When creating a child ticket for shipping instructions

- The customer is always the agent that raised it and the company is
  Digital Origin

- The actual customer name must be present in the summary

- Provide the from and to address, in full, and clearly identified, even
  if one of them is Digital Origin

- Accompany the assignment of the child with a secondary communication,
  preferably in teams or email

- The ticket must contain all the necessary context for it to be
  conducted independently

- Confirm with CLS that the ticket is received, and comply with any
  discovery requests they make. It is the agent creating the ticket who
  is responsible for providing the information, not CLS.

#####> When not to use a child ticket

- To avoid ownership or responsibility  
  If the intent is to “hand off” an issue and stop tracking it, a child
  ticket is the wrong tool. The creating agent remains accountable.

- When a normal escalation is required  
  If the issue needs specialist technical intervention, leadership
  oversight, or a formal escalation route, follow the Escalations Policy
  rather than creating a child ticket as a workaround.

- When the receiving party needs discovery  
  If the recipient would need to ask multiple questions, request
  additional information, or investigate from scratch, the child ticket
  is not ready. Add the missing context first (or keep the work on the
  parent ticket until it is).

- To “split” a ticket purely for convenience  
  Don’t create child tickets just to make the queue look smaller, reduce
  the appearance of workload, or move work between people without a
  clear task boundary and outcome.

- To duplicate work already being performed  
  If another team/member is already engaged through an existing ticket,
  email thread, or agreed process, don’t create a new child ticket
  unless it adds clear value and avoids confusion.

- When it would create SLA ambiguity  
  If splitting the work makes it unclear who is responsible for which
  SLA commitments, keep it on the parent ticket or raise with a Team
  Leader.

### How we measure compliance

- Ticket sampling to confirm correct type selection (especially
  security-related tickets logged as incidents)

- Trend analysis of mis-typed tickets and reclassification frequency
  during triage

- QA checks during dredging/spot checks where ticket type impacts
  SLA/workflow

### Record keeping and documentation

[TBD]

### How we address shortfall

[TBD]

## Ticket Status Usage Policy (NF)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Expectation

All tickets must always have a valid status, and any SLA holds must be
used correctly and only where appropriate.

Use of SLA holds explicitly:

SLA timers may only be paused when progression depends on an external
party (e.g., the user or a vendor)

In the case of no contact with a user, a reasonable effort must be made
and documented, to contact them before holding the SLA timer.

The ticket must still be updated daily unless it is scheduled.

SLA hold must not be used where progression of the ticket requires an
internal team

| Status                | Usage                                                                     | Expected SLA Status |
| --------------------- | --------------------------------------------------------------------------| ------------------- |
| New                   | A new ticket that has not been updated yet.                               | Running             |
| In Progress           | The ticket is actively being worked on.                                   | Running             |
| With User (HD)        | Awaiting a response or action from the user; work is paused.              | Held (for 24 hours) |
| With Vendor           | Awaiting a response or action from a vendor; work is paused.              | Held                |
| With Testbench        | Hardware has been delivered and is on the testbench                       | Running             |
| Escalate              | The issue has been escalated for additional support or visibility.        | Running             |
| Updated               | The ticket has received an update from someone other than the agent.      | Running             |
| Scheduled             | The ticket has a future appointment or planned action (not missed).       | Held                |
| Field Visit Scheduled | A field engineer has been scheduled, and a site visit is booked           | Held                |
| With Internal Team    | The ticket requires action from a team or authority with Digital Origin   | Running             |

**Valid Status Required**: Every ticket must always maintain a valid and
appropriate status.

**On-Hold Justification**: If an incident is placed on hold, the reason
for this must be clearly documented within the ticket. This will usually
be clear by the tickets conduct but the agent is still responsible to
make sure.

**SLA Hold Restriction**: Holding SLA status is strictly prohibited in
any situation where the ticket requires action or intervention from any
team within Digital Origin.

**Scheduled**:

- Have a valid appointment:

- Set in the future

- Set by the owner of the ticket

**On Hold**:

- Should only be used by / for:

- Problems

- TL – on demand

**With User**:

- The correct status has been used (“With User (HD)” as opposed to “With
  User”)

- The ticket is waiting for a user to interact

- The user is being chased or updated daily

- The ticket does not meet the requirements of the “three strike rule”

- Applies to:

  - Incident & Telephony Incident

  - Service Request & Telephony Service Request

**With Vendor**:

- The ticket is actively waiting on a vendor

- The vendor is being chased daily

- The user (if present) is being updated promptly of changes, or daily,
  whichever is soonest.

**Awaiting Delivery**:

- Ensure the ticket is assigned to a helpdesk agent

- Ensure we are waiting for a delivery

- Ensure the delivery agent is being chased if late, ie:

- The user taking a long time to ship

- The courier taking a long time en-route

- DO not passing the machine to the agent on arrival

**With Test bench**:

- Ensure the machine is on the test bench

- Ensure the ticket is receiving updates daily and progress is being
  made

#### How we measure compliance

[TBD]

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

[TBD]

### Scheduling Appointments and use of Scheduled status

#### Expectation

Appointments may be set to manage your workload or to coordinate
sessions with busy users. **Any time commitments made to a customer must
be honoured, without exception.**

- [NOT ENFORCED] All appointments must include the user**, even if
  only to notify them of activity taking place on their ticket.

- **Appointments must be completed independently of the ticket.** Ensure
  calendar entries are managed properly so that past appointments do not
  show as missed due to ticket closure or status changes.

Missing an appointment with a customer causes significant disruption and
leads to an immediate negative customer experience. **Failure to meet
agreed appointments may result in disciplinary action.**

#### How we measure compliance

Scheduled tickets are checked every morning for a valid appointment,
appointments that include a customer are captured through reporting and
tracked on the day the appointment is due.

We also check the quality of scheduled appointments through ticket
sampling.

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

[TBD]

## Ticket Communication Policy (NF)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Expectation

Customer contact should primarily be by phone.

- Use of the Call User button

  - Used to record a made call, regardless of if the recipient picked up
    or not

  - On missed calls, where the agent has selected “no” to “User
    answered”

    - The call is still recorded

    - The customer is sent a missed call notification

    - No further email is required from the agent

  - Email User button

    - Facilities emailing the ticket primary contact from the ticket
      itself

- Contact via email tick-box

  - Used to remove a ticket from the call user statistics

    - All ticket content is ignored, including call user button
      activations

  - Should be used:

#### How we measure compliance

Compliance with this policy is measured by comparing the use of the call
user button directly to the use of the email user button to make a
ratio. We then cross-reference actual call out and talk time to confirm
the agent’s recorded stats agree.

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

Triggers for intervention are:

- Any consistent ratio below 1:1

- Any weekly recorded ratio falling below 0.5

- Large deviation between recorded call user button activation and
  actual callout

Intervention process:

- A meeting will be held with the agent to investigate the reason(s) for
  the reduced callout volume where we will review tickets and discuss
  ticket actions.

  - If necessary, corrective measures will be applied, which may include
    a Development Plan

    - If the customer confirms email as the preferred contact method

  - For Vetoquinol tickets where primary contact is in person or over
    teams

- Each use is scrutinized for compliance with this policy

Each agent should be able to reach a ratio of 1:1 for use of the call
user and email user actions, first line agents focussing on service
requests will have a naturally lower ratio than second line agents
focussing on Incidents.

### Updates and Customer Communications

#### Expectation

- **Update Frequency**: Tickets must not go more than 24 hours without
  an update unless they are scheduled, or a site visit is booked.

- **Update Quality**: Tickets must receive high quality interactions
  that are clearly attempts to progress the ticket

- **Customer Communication**: Customers must be appropriately informed
  of their ticket’s progress and kept up to date throughout the
  lifecycle of the ticket.

#### How we measure compliance

Lifecycle management is an ongoing process with several automated
methods of reporting and alerting. We measure compliance with this
policy primarily through daily lifecycle checks like “Bread”.

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

[TBD]

### Confirmation of resolution (NF, soft enforced)

This policy is being integrated into the disciplinary process but will
not result in disciplinary action until the end of its grace period on
3rd of October 2025

#### Expectation

All tickets processed by the helpdesk must have confirmation that the
resolution has worked before the ticket is closed.

- Preferred method: Directly from the ticket user.

- Alternatively: Through testing the solution and providing results in
  the ticket.

#### How we measure compliance

Confirmation of resolution is added to ticket sampling, failure to
confirm resolution is a common reason for apparent re-occurrence which
is already being monitored and can be fed back.

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

Triggers for intervention:

- Any recurrence that results directly or indirectly from a lack of
  resolution confirmation

Intervention process:

- A meeting will be held with the agent to review the ticket and
  identify the reason(s) confirmation was not obtained.

- If necessary, corrective measures will be applied, which may include a
  Development Plan and/or disciplinary action as appropriate.

## Queue Management [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Escalation Policy (NF)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

This policy provides governance around the handling, coordination, and expectations of non-critical incident and service request escalations. The intent is to ensure consistent, effective, and timely escalation of incidents that exceed the capabilities of the current handler but do not meet the criteria for critical or security incident handling.

### Scope

This policy applies to all helpdesk personnel, including Level 1, Level 2, Level 3, Escalation Engineers, and Team Leaders involved in the resolution of non-critical incidents and service requests.

- “Escalation Team” or “Escalations” used in the context of agents, consists of:

  - Team Leaders

  - Third Line Engineers

  - Senior Second Line Engineers undergoing escalations exposure training

### Escalation Triggers

- Escalations can generally be initiated for any reason but should follow these triggers:

  - Technician skillset exceeded

  - Resolution SLA about to be breached AND escalation may prevent the SLA breach

  - Priority elevation to “high” or “critical”

  - Escalation is requested by a Team Leader or management

  - The ticket requires Account Management intervention such as scoping or sales

    - The ticket itself is not escalated, a child ticket must be raised

  - The agent is unable to progress the incident following best effort for any other reason

    - This is meant as a deliberate catch-all, consider if the escalation was reasonable or breached this policy on a case-by-case basis

    - If this is the trigger used, a PIR is required

  - The customer has requested escalation (see Customer Escalation)

#### How we measure compliance

[TBD]

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

[TBD]

### Service Request Escalation

While rare, Service Requests may need to be escalated for various reasons like management, lack of access or permissions assigned to the agent, difficulty or specialist knowledge requirements.

Service request escalation is handled in the same way as incidents, but the reason for escalation must be identified clearly.

#### How we measure compliance

[TBD]

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

[TBD]

### Customer Escalation

This is a placeholder policy for customer escalation.

Currently, the Team Leaders handle customer escalation on a case by case basis. Agents should inform the Helpdesk leadership team at the earliest opportunity when a customer is requesting escalation through them.

Where resources allow, and depending on the customers expectations, it may be appropriate for a Team Leader to take over communication with the customer.

#### How we measure compliance

[TBD]

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

[TBD]

### Escalation Procedure

#### General expectations

- The ticket owner retains responsibility for the ticket even after escalation has taken place.

- Escalation should not be used to “hand off” ownership.

- The reason for escalation must be clear and documented within the ticket.

- Escalation must be raised as early as possible once a blocker is identified.

#### Escalation event recording

Escalation events must be recorded in the ticket, including:

- Time of escalation

- Who it was escalated to

- Reason for escalation

- Any actions already taken, and the current status

- Any immediate next steps or expected outcomes

#### Escalation communication

The ticket owner must:

- Notify the escalation recipient in an appropriate channel (ticket + Teams where required)

- Provide sufficient context for the escalated party to act without unnecessary discovery

- Maintain customer communication throughout the escalation lifecycle unless ownership of comms has been explicitly taken over

#### Reassignment and coverage

If the escalated party is unavailable or the escalation cannot be handled promptly:

- The Team Leader must arrange alternative coverage without delay

- Escalation must not stall due to uncertainty about resource availability

#### Closing escalation

Escalation concludes when:

- The escalated requirement has been met, and the ticket owner can proceed

- The escalated party has taken over and confirmed responsibility for further progress (where appropriate)

- The ticket is closed under normal resolution conditions

#### How we measure compliance

[TBD]

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

[TBD]

### Post Incident Review

Post Incident Reviews are not meant as disciplinary, but a way to ensure the supporting documentation of the process are effective and enforceable. Any disciplinary actions, including assessment, must be entirely separate. If a PIR concludes that an agent’s actions were the root cause, that is effectively the end of the PIR.

A post incident review is not required every time this policy is triggered, but it should be done following any failure to meet the policy requirements, when the procedure led to a failure of this policy or when stated as required.

- A debrief must take place within 1 – 3 business days of the resolution

- If the agent is found to be the root cause, and all parties agree, the PIR automatically concludes

- This policy and the procedure must be reviewed if it has caused, or was in any way responsible for any failure

- All findings and actionable items must be documented, and improvements tracked

#### How we measure compliance

[TBD]

#### Record keeping and documentation

[TBD]

#### How we address shortfalls

[TBD]

## Remote Access & Remote Support Policy (NF)

[Content not present in the provided extraction. If you paste the Remote Access section text (or re-export), I’ll convert it cleanly into markdown and keep the same metadata/table style as the other policies.]

# Critical Incident Handling

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Overview

Critical incidents are high-priority issues that have a significant impact on service availability, business operations, or security posture. Effective handling of these incidents requires clear categorization and a consistent response approach. This section outlines how critical incidents are classified and the expectations for response coordination.

## Categorization

Critical incidents are categorized based on their type, whether coordination is required, and whether the incident involves a security concern. This ensures appropriate escalation paths and response procedures are followed.

| Type                       | Coordination Required? | Security Required? | Example                                  |
| -------------------------- | ---------------------: | -----------------: | ---------------------------------------- |
| Critical Incident          |                     No |                 No | Internet outage                          |
| Security Incident          |                     No |                Yes | Malware alert or unopened phishing spam  |
| Major Operational Incident |                    Yes |                 No | DC Failure, mail system failure          |
| Major Security Incident    |                    Yes |                Yes | Ransomware, successful phishing campaign |

Each category follows a distinct escalation and communication path. Major incidents (operational or security) invoke the Major Incident Process, which includes cross-functional coordination, real-time updates, and post-incident review. It is crucial that we identify the appropriate course of action for critical priority cases, and selection of the response.

## Critical Incident Policy

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

This policy sets the mandatory expectations for how critical incident are to be conducted across the helpdesk.

### Scope

This policy applies to all team members involved in the processing or conduct of a critical priority incident, and all tickets with a priority of “Critical” or “P1” within the helpdesk.

### Definition of a Critical Incident

A Critical incident is any incident that:

- Has a high urgency and a significant impact on the affected customer
- Requires immediate action to restore service or secure the estate

### Types of Critical Incident

There are 4 main types of incidents that would be assigned “Critical” priority within the helpdesk, each have their own expectations and governance covered in this section, but this policy applies across the board.

#### Critical Incident

Any incident assigned critical priority regardless of its procedural escalation to either Major Incident type. Critical Incidents that do not escalate typically include things like internet and server outages at smaller clients where a single agent can handle all aspects of the case.

#### Security Incident

All security incidents are given critical priority, but it is only necessary to procedurally escalate to a Major Security Incident if an intrusion is confirmed. Typically, these will be spoofing emails that have been identified but not actioned.

#### Major Operational Incident

Any Critical Incident that would benefit from a coordinated response incorporating more resource from the helpdesk and cross communication with internal teams like Account Management.

#### Major Security Incident

Any Security Incident with a confirmed intrusion of any kind.

## Major Operational Incident Policy

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

This policy sets the mandatory expectations for how major operational incident are to be coordinated and managed across the helpdesk. It ensures a consistent and effective response, supports timely resolution, and enables appropriate communication.

### Scope

This policy applies to all team members involved in the response to a major operational incident, with primary responsibility typically falling to a Helpdesk Team Leader or other senior technical staff.

### When to use this policy

“Major Operational Incident” refers only to this policy and isn’t reflected directly in any ticket details. It provides managerial tooling to enable a coordinated response to the most serious and disruptive operational incidents the helpdesk may need to handle.

This policy should be used where there is a benefit to a controlled, coordinated response. For instance, if a large client suffers a major production outage. Many critical incidents can be conducted by a single agent effectively, the validity of invoking this policy can be determined during a PIR.

### Supporting Documentation

- **Incident Owner’s Checklist (Major operational Incident)**
  - Provides immediate actions and containment advice
  - Reinforces fundamental expectations
- **Workload Coordinator’s Checklist**
  - Aids a Workload Coordinator in actioning key steps
- **Communicating Agent’s Checklist**
  - Aids a Communicating Agent in maintaining strong communication

### Non-Technical Workload Coordinator

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

A PIR that includes the non-technical coordinator must be completed to determine:

- the reason the policy had to be invoked by a non-technical team member.
- Any follow up actions required to bring the incident conduct in-line with this policy

### Incident Identification & Classification

- All team members must accurately classify potential major operational incidents.
- Technical resources must confirm major operational priority tickets meet the major operational priority criteria defined by the “Priority Classification Policy” before actioning them.

### Roles and Responsibilities

Roles assigned by the procedure are mandatory, however only the Incident Owner is required to hand off un-associated work, other roles should be managed case by case.

Only the Workload Coordinator can determine when to end the procedure and disband the roles.

#### Workload Coordinator (typically a Helpdesk Team Leader)

Provides operational support, including task reassignment and resource allocation.

Primarily responsible for coordinating the response and assigned resource.

Additional responsibilities:

- All documentation tasks are assigned and actively being completed
- All communication tasks are assigned and actively being completed
- Handling any reassignment of un-related work, or escalations
- Arranging the PIR and managing any follow-up tasks
- Ultimately responsible for the response to the incident

#### Incident Owner (typically the agent initially assigned the incident)

Must focus solely on the remediation of the major operational incident, with no unrelated interruptions.

Primarily responsible for the conduct of response actions.

Additional responsibilities:

- Recording incident events in the incident ticket
- Communicating unrelated work that has been paused to the Workload Coordinator for reassignment as required

#### Communicating Agent (typically the Workload Coordinator or a trainee)

If resources allow, this would ideally be a third agent. Otherwise, the Workload Coordinator will adopt it.

Expectation:

- Ensure consistent frequency of communication, either once an hour or at each major event (whichever is shortest)

Primarily responsible for stakeholder communications, such as:

- Updating the customer regularly
- Internal communications with other teams

Also:

- Recording all communication events in the incident ticket

### Event Recording & Ticket Updates

All events, including communications, must be recorded in the incident ticket clearly and consistently.

- Timings, both the amount of time spent and the time an event took place must be accurate
- Documenting events in the ticket is mandatory and must not be overlooked at any point

### Escalation

- The Workload Coordinator must arrange relief for the Incident Owner if they are unable to continue working on the incident for any reason, without delay.
- The Workload Coordinator should take on the responsibility of Incident Owner until a relief is available.
- In this scenario, the agent leaving the Incident Owner role will take on the Communicating Agent role if it is held by the Workload Coordinator.
- Relief for the Incident Owner role must be derived from the Escalation Team or a Team Leader.

### Training

Both the Incident Owner and Communicating Agent roles can be fulfilled by trainees, but preferably the Communicating Agent as this will allow a trainee to gain experience and exposure without being directly responsible the conduct of the ticket.

Where the Incident Owner is a trainee:

- The Workload Coordinator must be a senior technician capable of taking over the incident with little to no handover while also covering the Communicating Agent role and documentation expectations until relieved
- The trainee should take over the Communicating Agent role if possible

Where the Communicating Agent is a trainee:

- The Workload Coordinator should be able to take over the Communicating Agent Role with little to no handover
- The expectations and responsibilities of the Communicating Agent role are still applied to the trainee and should have been met up until the point the role is taken over

### Boundaries of Support

Helpdesk autonomy of actions is typically limited to:

- Restoring the environment to a functional state using the existing infrastructure
- Applying long term fixes that utilize only the available services and resources within the environment

The Helpdesk Manager, Team Leaders and Account Manager must coordinate to ensure the remedial actions are applied appropriately.

- Rebuilding existing services will typically be a Helpdesk responsibility
- Introducing new services or replacing existing services entirely will typically need professional services

### Confirmation of Resolution

Only the Workload Coordinator can end the procedure and disband the roles.

The Incident can only be considered complete in certain circumstances:

- The customer confirms the incident is complete
- No responsibility is retained by the helpdesk, and none is likely to return (such as, when handing over a secured environment for scoping and professional services)
  - The Communicating Agent must communicate this to the customer
- Senior management instruct the Workload Coordinator to end the procedure

### Root Cause Analysis

RCA should be conducted every time a major operational incident is raised with findings added to the incident ticket post closure.

## Major Security Incident Policy

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

> *This policies’ automatic trigger is not in force – see “When to use this policy (Not in force)”.*

### Purpose

This policy sets the mandatory expectations for how major security incidents are to be coordinated and managed across the organization. It ensures a consistent and effective response, supports timely containment, and enables appropriate communication during major security incidents.

### Scope

This policy applies to all team members involved in the response to a major security incident, with primary responsibility typically falling to a Helpdesk Team Leader or other senior technical staff.

### When to use this policy (Not in force)

“Major Security Incident” refers only to this policy and isn’t reflected directly in any ticket details. It provides managerial tooling to enable a coordinated response to a confirmed intrusion event.

A “Major Security Incident” happens when any part of a customer’s estate has been exposed to an attacker for any reason. Immediate invocation of this policy is mandatory at the point which a breach is confirmed to have taken place.

### Supporting Documentation

- **Incident Owner’s Checklist (Major Security Incident)**
  - Provides immediate actions and containment advice
  - Reinforces fundamental expectations
- **Workload Coordinator’s Checklist (Major Security Incident)**
  - Aids a Workload Coordinator in actioning key steps
- **Communicating Agent’s Checklist (Major Security Incident)**
  - Aids a Communicating Agent in maintaining strong communication

### Non-Technical Workload Coordinator

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

A PIR that includes the non-technical coordinator must be completed to determine:

- the reason the policy had to be invoked by a non-technical team member.
- Any follow up actions required to bring the incident conduct in-line with this policy

### Incident Identification & Classification

All potential security incidents, regardless of confirmed status, are an emergency and must be given critical priority in line with the “Priority Classification Policy”.

Security incidents must be assessed for potential impact to determine the level of response required immediately.

### Roles and Responsibilities

Roles assigned by this policy are mandatory, however only the Incident Owner is required to hand off un-associated work, other roles should be managed case by case.

All roles retain their responsibility even if the incident ownership has been transferred to an external body such as a cyber security specialist, until closure conditions are met.

Only the Workload Coordinator can determine when to end the procedure and disband the roles.

#### Workload Coordinator (typically a Helpdesk Team Leader)

Provides operational support, including task reassignment and resource allocation.

Primarily responsible for coordinating the response and assigned resource.

Additional responsibilities:

- All documentation tasks are assigned and actively being completed
- All communication tasks are assigned and actively being completed
- Handling any reassignment of un-related work, or escalations
- Arranging the PIR and managing any follow-up tasks
- Ultimately responsible for the response to the incident

### Coordination with third parties

Coordination with third parties must be handled professionally by a technically competent team member, even if that means re-assigning this responsibility to a more senior technician.

### Training

Both the Incident Owner and Communicating Agent roles can be fulfilled by trainees, but preferably the Communicating Agent as this will allow a trainee to gain experience and exposure without being directly responsible the conduct of the ticket.

Where the Incident Owner is a trainee:

- The Workload Coordinator must be a senior technician capable of taking over the incident with little to no handover while also covering the Communicating Agent role and documentation expectations until relieved
- The trainee should take over the Communicating Agent role if possible

Where the Communicating Agent is a trainee:

- The Workload Coordinator should be able to take over the Communicating Agent Role with little to no handover
- The expectations and responsibilities of the Communicating Agent role are still applied to the trainee and should have been met up until the point the role is taken over

### Boundaries of Support & Authority to Restore Services

#### Support boundaries

Helpdesk involvement is limited to containment and securing infrastructure.

No restoration, rebuilding, or long-term remediation is to be performed without explicit approval from the Account Manager and the Helpdesk Manager.

#### Authority

After a major security incident, it is unlikely that Digital Origin or even the customer is authorized to determine at what point affected services can be restored, if at all, or what the configuration of those services should be.

Communication with the authoritative bodies is essential and should be handled through coordination between the Team Leaders, Helpdesk Manager and Account Manager.

The Communicating Agent should only be used for this if they are a Team Leader.

While our main objective is to get the customers environment functional as quickly as possible, that is not necessarily the main concern of external factors such as cyber specialists or legal counsel.

The work being requested by an external authority should be continuously assessed for compatibility with support and the support boundary by the Team Leaders and Helpdesk Manager.

### Confirmation of Resolution

Only the Workload Coordinator can end the procedure and disband the roles.

The Incident can only be considered complete in certain circumstances:

- The customer confirms the incident is complete
- No responsibility is retained by the helpdesk, and none is likely to return (such as, when handing over a secured environment for scoping and professional services)
  - The Communicating Agent must communicate this to the customer
- Senior management instruct the Workload Coordinator to end the procedure

## Post Incident Review (PIR)

Post-incident reviews exist to learn and improve rather than punish. PIR activities must never include disciplinary assessment or recommendations. Any disciplinary action, if required, will be handled separately.

If a PIR determines that an agent’s actions were a root cause or significantly contributing factor, the PIR records that fact and stops there with respect to that agent, proceeding only on system/process improvements.

A debrief should occur within 1 to 3 business days of the resolution.

Attendees:

- Incident Owner
- Communicating Agent
- Workload Coordinator
- Team Leader (if not already involved)
- Helpdesk Manager

Discussion points:

- Timeline summary
- What went well and what didn’t
- Opportunities to improve:
  - Tooling
  - Detection
  - Communication
  - Escalation
- Identify training or process gaps
- Follow-up actions must be assigned and tracked appropriately

The meeting should not exceed 15 minutes.

### Document and Procedure Review

Update:

- Affected documentation or guidelines docs based on findings
- Any customer facing documentation where relevant

This procedure should be reviewed each time it is triggered.

## Known Issues & Mass Communication Policy [Placeholder]

[Placeholder]

# IT Operations

## Use of the Local Administrator group on customer machines

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Scope

Applies to customer computers running Windows and Mac OSX.

### General Guidelines

- Use of the Local Administrators group is in line with current CE standards and designed around them
- Users can have access to a local administrator account but cannot log in to it
- They must have a valid reason for having one
- Accounts should be retired when no longer required
- Issuance of a local administrator account must be approved by the user's manager in writing

### Configuration of Local Administrator Accounts

- Accounts must not be identifiable from their username, i.e. “localadmin”, “JamesAdmin” etc
- Must have a unique, long and complex password
- Should be protected by MFA where possible
- The account should be prevented from logging in to windows where possible

## Password & Credential Handling [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Tooling & Asset Management Handling [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Password & Credential Handling Policy [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Tooling & Asset Management Standards [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

# Customer Service

## Phone Etiquette Guide

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

Establishes a clear standard of quality for phone communications and provides actionable guidance on meeting these expectations.

All personnel are required to prioritize contacting customers by phone as the primary method of communication. Email follow-ups should only be used when necessary.

### Scope

This process applies comprehensively to all telephone interactions, whether inbound or outbound, conducted in the capacity of a help desk team member.

### Policy Details

#### Answer promptly and clearly

- Aim to answer within a couple of rings

#### Greet warmly with a standardized opening

“Digital Origin, [Name] Speaking, how can I help?”

#### Smile while speaking

Smiling helps provoke a positive tone of voice.

#### Maintain a moderate speaking pace

- Speak clearly and with a steady pace to ensure you are understandable
- Avoid speaking quickly, which can feel rushed

#### Acknowledge the caller

Actively listen to the caller and acknowledge their concerns.

#### Stay polite and professional

- Use polite language such as “please”, “thank you” and “you’re welcome”
- Avoid technical jargon unless the caller is familiar with technical terms

#### Handle challenges positively

Maintain a positive can-do attitude even if the caller becomes difficult or the issue can’t be immediately resolved.

#### End the call on a positive note

- Confirm the issue has been addressed
- Ask if there are any other items they need help with
- Thank the caller for their call

#### Reflect and improve

After each call take a moment to reflect on your tone and interaction, consider areas for improvement to ensure a consistent quality.

## Handling Complaints and Difficult Customers [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

# Quality Assurance (NF)

## Ticket Hygiene Tooling

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

To define the methods used by the helpdesk’s leadership to ensure all tickets receive high quality interaction, daily.

This policy is intrinsically linked to the “Ticket Status Usage Policy”; expectations for each status mentioned in this policy are given in that policy, except **Escalate** which is defined by the Escalation Policy.

### Formal vs Informal Checks

Each check is either formal or informal:

- **Formal checks**
  - Formal checks are recorded and integrated into the disciplinary process.
- **Informal checks**
  - Informal checks are not recorded and fed back to the agent as guidance without use of the disciplinary process.
  - Results of informal checks can still be used to identify and evidence performance shortfall.

### Status Checks (Formal)

#### How we measure compliance

Status checks are conducted twice daily:

- Once before 1000 in the morning
- Again after 1600

Every ticket is checked and its status is considered for validity against the Ticket Status Usage Policy.

If the checks are not conducted, or are delayed to the point they miss their window, it must be reported to senior management.

#### Record keeping and documentation

Failures are recorded in the ticket with metadata that links the ticket to the agent who caused the failure (rather than the agent that closed the ticket) then reported through weekly stats.

#### How we address shortfalls

Failures are recorded and reported back to the agent. Recorded failures form part of the helpdesk’s and agent’s performance statistics.

### Telephony Usage (Formal)

#### How we measure compliance

Statistics are reviewed weekly in accordance with the customer communication policy, and cross referenced against actual call-out.

#### Record keeping and documentation

Callout statistics are recorded and reported weekly.

#### How we address shortfalls

[TBD]

### Response SLA Breaches (Formal)

SLA response breaches are checked daily and classified, then investigated if required.

#### Breach Classifications

- **Miss Triage**
  - Occurs when ticket details are incorrect and cause a breach (e.g., breached because of incorrect priority)
- **Miss Dispatch**
  - Occurs when dispatch failed to assign a ticket to an agent with sufficient time to respond (typically less than 30 minutes, or within 30 minutes of an agents shift end)
- **Slow to respond**
  - Occurs when triage and dispatch provided sufficiently accurate information and time to respond, but the agent failed to respond within the response SLA window
- **Ticket conduct**
  - Occurs when the agent fails to respond to the ticket with a valid update, or defers work inappropriately, or the customer did not receive a notification in the response window (the ticket will typically show procedurally met response SLA)
- **External breach**
  - Occurs when sales or SD breach a ticket before it reaches the helpdesk
- **Team Leaders**
  - Tickets that are breached by a Team Leader, for any reason
- **False Positive**
  - A ticket that breached procedurally in Halo, but in reality didn’t breach the SLA from the customers perspective

#### How we measure compliance

Team Leaders check all tickets open in the helpdesk, twice daily, for compliance with the Ticket Status Usage Policy.

#### Record keeping and documentation

Failures are recorded and reported back to the agent. Recorded failures form part of the helpdesk’s performance statistics.

#### How we address shortfalls

[TBD]

### Critical Care Checks (Formal)

#### How we measure compliance

Team Leaders re-check Critical Care tickets independently for all expectations listed in this toolset but to a higher level of detail and tighter tolerance.

#### Record keeping and documentation

Failures are recorded and reported back to the agent. Recorded failures form part of the helpdesk’s performance statistics.

#### How we address shortfalls

[TBD]

### Breadboard (Informal)

Breadboard is a pseudo-automated queue hygiene tool used to monitor ticket update compliance.

#### How it works

- Each agent has a visible score shown in a shared forum.
- The score represents the number of tickets assigned to that agent that have not been updated within the last 24 hours.

Exceptions apply, for example:

- Tickets with a documented scheduled next action (booked call, change window, agreed follow-up date)
- Tickets awaiting customer response within an agreed timeframe (and this is clearly recorded)
- Tickets blocked by a third party, where this has been communicated and recorded with a recent update

#### Agent expectation

Agents are required to clear their score to zero before the end of every shift.

This is done by reviewing each contributing ticket and applying valid, high-quality updates that:

- Show progress or actions taken
- Record next steps, owner, and timeframe
- Provide appropriate customer communication (where relevant)

See [Update quality] for the update standard.

#### Quality control

The Breadboard supports visibility and consistency, but it does not confirm update quality.

It must be supported by Manual Bread spot checks by Team Leaders to confirm:

- Updates are meaningful (not placeholders)
- Tickets are progressing appropriately
- Handling remains compliant with the Ticket Handling policy

### Stale Ticket Reminders

Reminders are posted in Teams and checked informally against the Bread Board. Failure occurs when an agent completes their shift with a score greater than zero remaining; the ticket is assessed for the breach reason and fed back to the agent.

### Bread (Informal)

Manual Bread is an informal check and has largely been replaced by daily checks and dredging, but it remains available as an on-demand, deeper compliance check where additional assurance is required.

Manual Bread checks are conducted by Team Leaders to confirm that tickets meet the full set of update and handling expectations defined in the Ticket Status Usage Policy (NF). This includes verifying that tickets show consistent evidence of progress, clear ownership, and appropriate customer communication.

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
- **Policy compliance**: any mandatory fields, templates, or categorisation rules required by the Ticket Handling policy

Outcome: Manual Bread provides stronger assurance than a routine daily sweep, identifies training/coaching needs, and helps ensure consistent ticket quality across the team—especially when performance or compliance needs to be demonstrated.

### Dredging (Informal)

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

### Recording and Documentation

Outcomes are recorded as a whole number of tickets that failed an expectation, then added to the weekly statistics report.

Where a ticket fails to meet our expectations, and it is recorded, the reasons are as follows:

#### Status Checks

#####> Scheduled

- No appointment (there is no appointment set)
- Appointment invalid (the appointment is wrong, or in the past)

#####> On Hold

- Invalid use (use case breaches the status expectations)

#####> With User

- No update (the ticket has not received an update in 24 hours)
- Incorrect version (“With User” vs “With User (HD)”)
- Invalid use (the ticket is not waiting for a response from the user)

#####> With Vendor

- No update (the ticket has not received an update in 24 hours)

#####> Awaiting Delivery

- No update (the ticket has not received an update in 24 hours)
- Invalid use (the ticket does not have an outstanding delivery associated with it)

#####> With Test Bench

- No update (the ticket has not received an update in 24 hours)
- Invalid use (the ticket is not physically present in our office or on the test bench)

## Projects to Helpdesk Handover

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### When a handover interview is required

Triggers for a handover interview are:

- Any change to a client’s core infrastructure:
  - Servers’ hardware (e.g. cloud migration to Azure)
  - File storage and sharing (e.g. cloud migration to SharePoint)
  - Backup and recovery systems (e.g. migration to Cove or introduction of local solutions)
  - Business critical or line of business systems (including printing) (e.g. migration of LOB apps to a new service, change to print management)
  - Networking hardware refresh (e.g. replacing a large amount of a networks hardware infrastructure or reconfiguring / tidying a network cabinet)
- Any change to a security feature that directly affects, or is directly interacted with by users (e.g. introduction of MFA)
- Any change to the core daily functions or nature of work carried out by users (e.g. change of workstation hardware or introduction of cloud work environments)
- Any project that contains changes to more than one core business system (e.g. a project that combine multiple migrations or changes across different, unrelated systems)

### What is covered by the interview

#### Service Readiness

- Why does the service exist and or what purpose did the project serve?
- Is there a defined endpoint that includes supportability?
- What is the hypercare period and who retains responsibility during it?

#### Documentation & Knowledge

- Service overview – high level description of what the project is and does
- Runbooks & SOPs – support orientated documentation to aid in new or complex project support
- Escalation path – who does the helpdesk turn to when they have exhausted provided documentation and available expertise
- Knowledge transfer – should the helpdesk undergo specific training to aid in supporting the project

#### Service Supportability

- Is the service monitored and do alerts go to the right place
- Do helpdesk agents have the right access to diagnose and resolve common issues
- Tooling integration – Has the project been integrated in to existing monitoring systems
- Known issues – are any known issues and workarounds documented

#### Risk & Continuity

- Risk register review – did the project flag any known risks that may affect operations
- Backup & recovery – is there a restore process and has it been tested
- Business continuity – is there a fallback if the service fails or is the service covered under current BCDR

#### Testing & Acceptance

- Client confirmation – has the client signed off the service as functional
- Operational testing – has the service undergone any testing
- Capacity & Performance – is the service adequately resourced to meet its real-world demand

### Handover

The helpdesk accepts a handover when:

- The above conditions are met
- Continuation procedures are in place to support the service beyond normal helpdesk operations
- The service has been proven stable following a short period of hypercare owner by the project team
- The client confirms they service is functional in regard to the initial expectations

## Scheduled Ticket Review [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Ticket Quality Sampling

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

To ensure consistent, high-quality support through accurate ticket updates and clear communications. The process also provides constructive feedback to support agent development.

### Ticket Selection

On Tuesdays and Thursdays, 3 tickets from each present agent will be selected at random for QA review.

Tickets are collected from a filtered report that runs the day following.

Example:

- 50 tickets were created yesterday.
- 29 of these meet the QA criteria (filtered list).
- agents were in, all 8 closed more than 3 tickets, 24 tickets are selected for QA.

### Data Usage

The collected data is used to highlight quality control issues in tickets that affect customer satisfaction. We also feedback the results month to month in the monthly one to one.

QA data is collected and stored indefinitely.

### Recording

The scoring matrix should be attached to the ticket it applies to; a copy of the completed matrix should be saved to the agents HR documentation for future reference.

## New Starter & Onboarding [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Training [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Tooling and Systems [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Post Incident Review (PIR) [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

PIRs, where called upon, are handled by individual process with no global expecations yet.

## Knowledge Management [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Knowledge Base Management [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

# Resource

## Helpdesk Rota and Breaks

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

**THIS POLICY DOES NOT REFLECT THE 10-6 ROTA**

### Purpose

To ensure adequate helpdesk coverage at all times through effective management of available staffing.

### Lunch Windows

Each shift has an assigned lunch window to maintain acceptable helpdesk coverage throughout the day.

| Shift                     | Lunch       |
| ------------------------- | ----------- |
| 0800 – 1600 / 1630        | 1200 - 1300 |
| 0900 – 1700 / 1730        | 1300 - 1400 |
| 1000 – 1800 & 0930 – 1730 | 1400 - 1500 |

Lunch break windows are mandatory, whether working in the office or remotely. Agents are expected to plan their lunch breaks into their daily schedule.

If an adjustment to the standard lunch window is needed, this must be requested in advance. Approval will always be granted if it does not significantly impact helpdesk coverage.

### Break Locations

Taking breaks at your desk is not permitted, you must leave your desk if you are not working. For instance, you may eat your lunch at your desk, but you will also be expected to answer phones and deal with tickets.

### Comfort Breaks

Comfort breaks and smoking / vaping breaks, can be taken at any time as long as their use is reasonable, time away from your desk is minimal and customer satisfaction is not impacted.

### Vaping and Smoking

Vaping and smoking breaks must be taken in accordance with the company handbook, in addition to this only 2 personnel are permitted to use vaping & smoking facilities at the same time and not during the lunch windows (unless used while on lunch).

## Professional Advancement

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

To define clear, consistent expectations for progression within the Helpdesk role framework, ensuring advancement is earned through demonstrated performance, policy compliance, and required qualifications.

### Helpdesk Role Framework

The Helpdesk is structured into 3 levels (Level 1, 2, 3), each with 3 sub-tiers: C → B → A.

Core rule: At every stage, advancement is gated by:

- Job performance and policy compliance
- Matrix score
- Matrix deviation
- Prerequisite exams (where required)
- Technical interviews (where required)

Advancement is not automatic; progression is granted when evidence supports readiness for the next tier.

<img src="role_framework.png" alt="Helpdesk Professional Advancement role framework" style="width: 100%; height: auto; display: block;"/>

### Advancement requirements by tier

#### Level 1 progression

Advancement from Level 1 – C → Level 1 – B → Level 1 – A is based on job performance, Matrix score & Matrix deviation including but not limited to:

- Ticket closures and throughput
- Time to close
- SLA performance
- Quality of ticket handling and lifecycle management
- Telephony usage as the primary customer contact method
- General compliance with Helpdesk policies and expectations

#### Level 1 → Level 2 entry

Advancement from Level 1 – A → Level 2 – C requires:

- CompTIA A+ (For new hires)
- CompTIA Network+ (N+)

Technical interview

#### Level 2 progression

All previous requirements (for new hires, and direct entry into Level 2 – see Direct Entry)

- Level 2 – C → Level 2 – B requires: Microsoft MD-102
- Level 2 – B → Level 2 – A requires: Microsoft AZ-104
- Level 2 – A → Level 3 – C requires: Microsoft MS-102 + Technical interview

#### Level 3 progression

All previous requirements (for new hires, and direct entry into Level 3 – see Direct Entry)

- Level 3 – C → Level 3 – B requires: CompTIA Security+ (S+) + BLT1 (Blue Team Level 1)
- Level 3 – B → Level 3 – A requires: Microsoft AZ-305

### Direct Entry

#### Definition & Scope

Direct Entry refers to engineers hired into Level 2 or Level 3 without prior advancement through the Helpdesk progression framework. Direct Entry applies to any entry into the helpdesk, external or internal after January 2026. It is in addition to "For new hires” requirements (where used).

#### Expectation

Regardless of job title or wage, all new hires start at Matrix Level 1 – C and must meet the expectations of each level and sub-level through performance and compliance, exactly as if they had progressed internally.

Where an engineer’s wage exceeds Matrix Level 1 – C, meeting the expectations and prerequisites up to their appointed level forms part of their probation requirements.

#### Direct Entry requirements

Direct Entry hires must evidence (or achieve, within the agreed probation plan) all prior requirements up to their appointed tier, including:

- Job performance and policy compliance (including telephony as primary customer contact where applicable)
- Matrix score and Matrix deviation at the expected standard
- All prerequisite exams for prior tiers
- All required technical interviews for prior tiers (unless explicitly satisfied by an equivalent internal technical assessment during hiring)

### Performance and Compliance Gate

#### Expectation

To be eligible for advancement at any stage, the engineer must:

- Meet or exceed the expected Matrix score for their current tier
- Maintain acceptable Matrix deviation (consistent with role expectations)
- Demonstrate consistent compliance with Helpdesk policies (e.g., customer contact, lifecycle updates, SLA holds, scheduling commitments)
- Maintain professional conduct and reliability

#### How we measure compliance and readiness

Readiness for progression is evaluated using:

- Matrix score (overall performance against expectations)
- Matrix deviation (variance from expected behaviours/outputs)
- Operational performance indicators (examples):
  - SLA outcomes and avoidable breaches
  - Ticket volume and quality of closures
  - Time-to-close relative to ticket type
  - Rework/reopen/recurrence indicators
  - Evidence of customer contact via telephony where required
  - Policy compliance checks and ticket sampling outcomes
  - Certification evidence (where required)
  - Technical interview outcome (where required)

### Exams and Technical Interviews

#### Exams

Where exams are listed as prerequisites, the certification must be achieved before advancement can be approved.

Once an exam is achieved, it must be valid and within its own support lifecycle at the time it Is presented as a pre-requisite for advancement, but there-after does not have to be maintained.

#### Technical Interviews & Boards

Where a technical interview is required, the engineer must demonstrate capability aligned to the next tier’s responsibilities. Technical interviews are intended to be challenging and a test of ability, no preparation material or content is shared with the subject prior to the interview as the intention is to confirm readiness.

A technical interview can only be conducted once all other conditions are met.

If the interviewee fails to meet the required standard it can be re-taken after a period of 30 days once, then any subsequent re-takes after a period of 90 days without limitation.

# Discipline

## Disciplinary Process

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Summary

This process is defined by the advice given in the “Disciplinary procedures and action against you at work” document on gov.uk.

<https://www.gov.uk/disciplinary-procedures-and-action-at-work>

The Helpdesk’s disciplinary process aims to address and correct shortcomings through training and mentorship, and only escalate to formal proceedings as a last resort or where less formal approaches would be insufficient or inappropriate.

### Practical Overview

Disciplinary action is not the default response to underperformance or isolated mistakes. The normal route is:

Support > coaching > monitoring improvement

Escalating to formal disciplinary steps only when:

- The shortfall is serious, repeated, deliberate, or high-risk, or
- Informal correction has been attempted and has not resulted in sustained improvement, or
- The nature of the issue means informal handling would be inappropriate (e.g. gross misconduct, major negligence, or serious breach of trust)

### Typical Flow

1. **Concern identified**
   - Triggered by QA checks, SLA failures, repeated ticket-handling shortfalls, customer complaints, colleague concerns or observed behaviours
   - The Team Leader records a short “what happened” note and gathers initial evidence (examples, dates, tickets, messages)

### Formal Steps

#### Informal Resolution

Attempt to resolve issues informally through feedback or a quiet word where appropriate.

#### Investigation

- Investigate promptly to establish facts
- Separate personnel should conduct the investigation and hearing where possible
- Investigatory meetings should not result in disciplinary action

#### Notification

If there’s a case to answer, notify the employee in writing with:

- Allegations
- Evidence
- Time and place of hearing
- Right to be accompanied

#### Disciplinary Meeting

- Held without unreasonable delay
- Allow employee to:
  - Present their case
  - Ask questions
  - Call witnesses
  - Be accompanied

#### Decision and Action

Decide based on evidence:

- No action
- Informal warning – low severity recorded warning
- Formal warning – high severity recorded warning
- Final written warning – escalated severity recorded warning
- Dismissal

Notify the employee in writing, include:

- Reasons
- Sanctions
- Duration of warnings
- Consequences of further misconduct

#### Appeal

- Employee has the right to appeal
- Appeal heard impartially and ideally by someone uninvolved
- Decision communicated in writing

### Warning Types and Durations

All disciplinary action is recorded, including all warnings. Warnings are issued based on severity, with informal warnings being the least severe.

- All recorded warnings are kept for at least 6 months
- Final written warnings are kept for 12 months

## Grievance Process

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Submitting a grievance

Grievances may be submitted to any member of the leadership team; however, non-helpdesk managers may not be aware of specific helpdesk procedures regarding grievance. This policy relates to how the helpdesk department, specifically, handles grievance.

You should submit a grievance, preferably in writing, to a manager who is not directly involved in your grievance.

### Steps

1. **Informal Resolution**
   - Try to resolve the issue informally
2. **Raise a formal grievance**
   - Employee submits grievance in writing to a manager not involved
3. **Grievance meeting**
   - Hold without unreasonable delay
   - Employee can explain the grievance and suggest resolution
   - May adjourn for further investigation
4. **Right to be Accompanied**
   - Same rules as disciplinary: must allow a suitable companion
5. **Decision and Action**
   - Decide on any action to resolve the grievance
   - Communicate decision in writing
   - Inform employee of right to appeal
6. **Appeal**
   - Employee may appeal in writing
   - Appeal heard impartially and promptly
   - Result communicated in writing

## Development Plan Policy [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Helpdesk Behaviour & Language Policy (Draft)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

To keep language and behaviour respectful, professional and customer-safe at all times in the office.

### Policy Details

#### Core rules

- Treat all colleagues with respect, at all times
- Critique work, not people
- No bullying, intimidation, humiliation or “pile-ons”
- Take sensitive subjects (performance, conflict, personal) off the floor

#### Language standards

- Swearing is not allowed in the helpdesk, at any time
- No insults, name calling or comments about intelligence / competence
- No discriminatory, sexual or demeaning language
- Threatening or aggressive language
- Gossip about colleagues or customers

#### Volume

- Keep voices at a shared-office level
- If disagreements escalate, take it off the floor.

#### Reporting and enforcement

- Raise concerns through TL, do not retaliate.
- Breaches will generally be managed as coaching > documented coaching > formal action
- Serious breaches may provoke formal action in the first instance

# Appendices

## Appendix – DUO Use of Bypass [Placeholder]

[Placeholder]

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Appendix – AI Usage Policy (Draft)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### Purpose

The purpose of this policy is to provide clear guidance on the use of Artificial Intelligence (AI) tools, such as ChatGPT, within the Helpdesk. AI can be a valuable tool to support productivity and improve communication, but its use must not compromise the accuracy, security, or professionalism of the service we provide to customers.

### Scope

This policy applies to all Helpdesk agents, Team Leaders, and Escalations Engineers. It covers all support activities where AI tools may be used, including ticket handling, customer communication, and the creation of internal documentation. The scope includes both publicly available platforms and company-approved AI solutions.

### Data Protection and Security

Protecting customer and company data is critical. For this reason, AI tools must not be used to process or store personally identifiable information, confidential system details, or any other sensitive information.

Only AI platforms approved by management may be used for Helpdesk work, and public AI tools must never be directly connected to company systems unless specifically authorised.

## Appendix – Helpdesk Ticket Screening for Live Projects (Draft)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

Draft

The process:

1. Customer with an active project raises a ticket
2. Ticket is added to “Projects Screening” queue through automation
3. TL & CLS monitor the queue and notify Projects Manager
4. Projects Manager assigns relevant agent to screen the ticket
5. Once screened, ticket is dispatched normally through the Helpdesk

## Appendix – Policy Format / New Format (Draft)

| Last Updated | 10/02/2026   |
| ------------ | ------------ |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

## Policy New Format Title

### Purpose  

High level overview of the whole policy

### Scope  

Who and what the policy applies to

### Expectation  

Description of a sub-policy or expectation

#### How we measure compliance  

Methods used, linked process or policies

#### How we address shortfall  

How this policy integrates with discipline]

## Appendix - Dispatch Limitations (Temporary)

### Purpose

This appendix outlines the temporary dispatch limitations currently in place for the Helpdesk team. These limitations are designed to manage workload and ensure a high level of service quality.

The rationale of this policy is not temporary, only its current implementation. Limits will remain and continue to be enforced going forward but the expectations will evolve as we gather more data on their impact.

### CLS Limitations

- Maximum of 15 tickets per queue for initial dispatch
- No assignment of tickets, unless P1 or P2, in the last 30 minutes of an agents shift, except when:
  - They have been directly communicated with
  - The ticket is P1, P2
  - The ticket is under Critical Care the the agent, themself, confirms they have capacity
- If no valid queue is available for dispatch, the ticket will be held in unassigned
- P1 and P2 tickets will continue to be prioritized for immediate dispatch regardles of queue size and state

### Team Leader Expectations

- Monitor ticket queues and ensure:
  - Compliance with dispatch limitations
  - Agents are able to manage their workloads
  - Monitor secondary workload sources (such as re-opened tickets, child ticket assignment, etc)
- Communicate any issues or concerns regarding ticket volume or agent workload
- Support agents in managing their ticket assignments effectively

Critical Operational Incident & Critical Security Incident "Incident Owner" workload management

- The workload of this agent must be cleared, and as such the limitations do not apply when re-distributing their queue
- Any conflict with any part of the helpdesk's "Critical Incident Handling Process" overrules this policy

### Critical Care Tickets

Tickets that are classified as "Critical Care" will be handled in the same way as any normal ticket through dispatch, with the same limitations and expectations

### Rationale

- Reduce the risk of overwhelming an agents queue with an amount of work they are unable to achieve inside each tickets SLA
- Maintain enough agent bandwidth to allow P1 and P2 tickets through immediately
- Allow workloads we are under-resourced to achieve to expire in a public forum (unassigned)

### How we measure compliance

- Ticket queues are constantly monitored already, breaches can be addressed informally and fedback immediately
- Performance of this policy is tested by reporting on the average time a ticket spends without dispatch
- "Slow dispatch" is excused or ignored in lieu of the expectations of this policy, where it applies

### How we address shortfall

- If compliance shortfalls are identified, the Helpdesk management team will work with affected agents to reduce their workload
- Feedback, training and additional resources can be provided where dispatch is unable to meet demand
- This process is incompatible with the helpdesk disciplinary process as it requires cooperation from an external team and queue owners are not directly responsible for controlling their own workload volume