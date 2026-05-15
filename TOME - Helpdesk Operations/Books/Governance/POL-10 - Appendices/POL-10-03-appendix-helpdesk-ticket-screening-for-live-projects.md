# Appendix – Helpdesk Ticket Screening for Live Projects (Draft)

## 10.3.1 Document Control

### 10.3.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 10.3.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 10/02/2026 |             |
| 1.1     | Jason Mcdill | 19/03/2026 | 01/04/2026  |
| 2.0     | Jason Mcdill | 13/05/2026 | 13/10/2026  |

### 10.3.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 2.0     | Stephen Richardson | 13/05/2026 |
| 2.0     | Rupert Evans       | 13/05/2026 |

### 10.3.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

Draft

The process:

1. Customer with an active project raises a ticket
2. Ticket is added to “Projects Screening” queue through automation
3. TL & CLS monitor the queue and notify Projects Manager
4. Projects Manager assigns relevant agent to screen the ticket
5. Once screened, ticket is dispatched normally through the Helpdesk

Project screening enforces quality control on project adjascent issues that may be caused, but are uncontrolled, by a project. the purpose is to protect service quality from both the helpdesk and indirectly projects.

### 10.3.1 Purpose

To enforce quality control on project adjacent issues that may be caused by, but are not directly controlled by, an active project. Screening protects service quality across the Helpdesk and, indirectly, the Projects function, by ensuring tickets raised against a live project are correctly identified, triaged, and routed before they enter normal Helpdesk flow.

This prevents project related work being incorrectly absorbed by the Helpdesk, prevents Helpdesk SLA being damaged by project related complexity, and ensures the customer receives the right response from the right team.

### 10.3.2 Scope

Applies to all tickets raised by customers who have an active project at the time the ticket is logged. Covers:

- The automation rule responsible for routing tickets into the **Projects Screening** queue.
- The monitoring responsibilities of the Helpdesk Team Leader and Customer Lifecycle Specialist.
- The assignment and screening responsibilities of the Projects Manager and nominated screening agent.
- The onward dispatch of the ticket into the Helpdesk once screening is complete.

Applies during standard business hours. Out of hours tickets are screened on the next working day unless flagged as a P1.

### 10.3.3 Expectation

Every ticket raised by a customer with an active project is screened by Projects before it is worked by the Helpdesk. Screening follows a defined flow:

1. Ticket is raised by a customer with an active project and routed to the Projects Screening queue by automation.
2. The Team Leader and CLS monitor the queue and notify the Projects Manager of new arrivals.
3. The Projects Manager assigns a nominated agent to screen the ticket.
4. The agent screens the ticket, records the outcome and reasoning, and identifies the correct onward route.
5. The ticket is dispatched into the Helpdesk for normal handling, or retained by Projects where it is identified as project caused.

Screening is timely, decisive, and produces a clear onward route for the ticket, with sufficient context for the receiving team to take immediate ownership.

#### 10.3.3.1 How we measure compliance

- Percentage of tickets from customers with active projects that are correctly captured into the Projects Screening queue by automation, targeting 100%.
- Average and maximum dwell time in the Projects Screening queue before agent assignment, measured against an agreed internal target.
- Average and maximum time from agent assignment to completed screening.
- Percentage of screened tickets dispatched to the correct team first time, measured via reassignment and rework rates.
- Volume of tickets identified during screening as project caused versus business as usual, reported back to Projects for trend analysis.

#### 10.3.3.2 Record keeping and documentation

- Each screened ticket carries a screening note from the assigned agent recording the outcome, the reasoning, and the onward route.
- The Projects Screening queue is fully auditable through the ticketing system, with assignment history, dwell time, and screening outcome retained for review.
- Disputes or reversals of screening decisions are logged against the ticket and surfaced in the weekly Helpdesk and Projects sync.
- Aggregate screening data is retained for a minimum of 12 months to support trend analysis and continuous improvement.

#### 10.3.3.3 How we address shortfall

- Where tickets are missed by automation, the routing rule is reviewed and corrected, and a one off sweep is performed to recover any tickets in flight.
- Where queue dwell time or screening turnaround targets are breached, the Team Leader or CLS notifies the Projects Manager and the cause is recorded against the ticket.
- Where screening accuracy falls below the agreed standard, the assigned agent receives coaching from the Projects Manager, with recurring issues addressed through the skills matrix and development plan.
- Persistent or systemic shortfall is escalated jointly to the Head of Technical Support and the Projects Manager for resolution, with corrective actions tracked through to closure.
