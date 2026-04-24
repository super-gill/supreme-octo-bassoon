# Change Management (Customer-side) 

## 3.9.1 Document Control

### 3.9.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 3.9.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 16/03/2026 |             |
| 1.1     | Jason Mcdill | 19/03/2026 | 01/04/2026  |
| 1.2     | Jason Mcdill | 26/03/2026 | 01/04/2026  |

### 3.9.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.1     | Stephen Richardson | 19/03/2026 |
| 1.1     | Rupert Evans       | 19/03/2026 |

### 3.9.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

## 3.9.2 Purpose

To define how the Helpdesk handles requests from customers to make changes to their IT environment, configuration, or services. This policy ensures that change requests are correctly identified, scoped, and authorised before work begins, and that agents do not undertake change activity without appropriate approval. It exists to protect both the customer and Digital Origin from uncontrolled, undocumented, or out-of-scope work.

## 3.9.3 Scope

This policy applies to all Helpdesk agents, escalations engineers, and Team Leaders. It covers any request where the outcome is a deliberate, planned modification to a customer's environment, as distinct from incident resolution, where the aim is restoring something to its previous working state.

## 3.9.4 What is a change

A change is any action that deliberately modifies a customer's environment, configuration, or service in a way that goes beyond restoring normal operation. Examples include:

- Adding, removing, or reconfiguring user accounts beyond the scope of a reported fault
- Installing or removing software or services across a customer environment
- Modifying network configuration, firewall rules, or security settings
- Migrating data, services, or systems
- Making configuration changes to a customer's line-of-business application at their request

The distinction between a change and an incident resolution is intent. Restoring a broken thing to its previous working state is incident resolution. Modifying how something works, even at the customer's request, is a change.

Where there is ambiguity, the agent must raise it with the Team Leader before proceeding.

## 3.9.5 Expectation

### 3.9.5.1 Identifying a change request

Where a customer requests work that meets the definition of a change, the agent must:

- Not begin the work without going through the steps below
- Raise it with the Team Leader to confirm classification and authorisation requirements
- Ensure the request is documented in the ticket before any work begins

Agents must not begin change activity on the basis of a verbal request alone, regardless of the customer's seniority or urgency.

### 3.9.5.2 Authorisation

All changes require written authorisation from an appropriate contact on the customer side before work begins. The appropriate contact is a person with the authority to approve changes to their own environment, this is a named VIP in HaloPSA.

Where the customer contact requesting the change does not have that authority, the agent must confirm approval has been obtained before proceeding.

The authorisation must be recorded in the ticket. An email reply from the approving contact is sufficient. Verbal confirmation is not.

### 3.9.5.3 Scoping

Before a change is undertaken, the scope must be clearly defined in the ticket:

- What will be changed
- What will not be changed
- What the expected outcome is
- Any known risks or dependencies
- Whether a rollback is possible and what it would involve

Where a change is sufficiently complex that it cannot be clearly scoped by the agent, it must be escalated to the Team Leader or a Third Line Engineer before work begins.

### 3.9.5.4 Scheduling

Where possible, changes should be scheduled during a window agreed with the customer, outside of their peak operating hours. This is particularly important for changes that carry a risk of service disruption.

The scheduled change must be recorded in the ticket with the agreed time and the name of the authorising contact.

### 3.9.5.5 During the change

Agents must:

- Work only within the agreed scope, if the scope needs to expand, the change must be paused and re-authorised
- Document progress in the ticket as the change proceeds
- Stop and escalate if an unexpected risk or dependency is encountered that was not identified during scoping

### 3.9.5.6 After the change

Once the change is complete:

- The outcome is documented in the ticket, including any deviations from the original scope
- The customer is notified and confirmation that the change has been accepted is obtained before the ticket is closed
- Where a change has not achieved the intended outcome or has caused a secondary issue, the Team Leader is notified immediately

### 3.9.5.7 How we measure compliance

Change tickets are reviewed during ticket sampling for the presence of written authorisation, scope documentation, and customer confirmation of outcome. Team Leaders spot-check change activity during daily hygiene. The Helpdesk Manager reviews change ticket quality periodically.

### 3.9.5.8 Record keeping and documentation

All change requests are documented in the ticketing system from the point of identification. Written authorisation, scope, outcomes, and customer confirmation are retained as part of the ticket record indefinitely.

### 3.9.5.9 How we address shortfall

Agents who undertake change activity without written authorisation, outside agreed scope, or without proper documentation are addressed through corrective training and documented coaching. Where unauthorised change activity results in customer impact, it is escalated to the Helpdesk Manager and handled through the disciplinary process.
