# Projects to Helpdesk Handover

## 7.3.1 Document Control

### 7.3.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 7.3.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 10/02/2026 |             |
| 1.1     | Jason Mcdill | 19/03/2026 | 01/04/2026  |
| 1.2     | Jason Mcdill | 26/03/2026 | 01/04/2026  |

### 7.3.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.2     | Stephen Richardson | 26/03/2026 |
| 1.2     | Rupert Evans       | 26/03/2026 |

### 7.3.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

## 7.3.2 Purpose

To define the conditions under which the Projects team may hand over completed work to the Helpdesk for ongoing support, and to ensure the Helpdesk has the knowledge, access, and documentation required to support the delivered service from day one.

## 7.3.3 Scope

This policy applies to all projects delivered by Digital Origin that result in changes to a customer's supported environment meeting the trigger criteria defined in this policy. It applies to both the Projects team as the delivering party and the Helpdesk as the receiving party.

## 7.3.4 When a handover interview is required

A Service Transition Review (STR) interview must be completed before the Helpdesk assumes ongoing support responsibility. The interview must take place prior to go-live, or at the point of handover where go-live has already occurred, and must be signed off before the Helpdesk accepts the service.

Triggers for a handover interview are:

- Onboard of a new client
  - New client onboards will typically be accepted as-is provided the Helpdesk is reasonably capable of providing support
  - New client onboards will not automatically have a hypercare period, unless it is deemed necessary during the STR interview
- Any change to a client's core infrastructure:
  - Servers / hardware (e.g. cloud migration to Azure)
  - File storage and sharing (e.g. cloud migration to SharePoint)
  - Backup and recovery systems (e.g. migration to Cove or introduction of local solutions)
  - Business critical or line of business systems (including printing) (e.g. migration of LOB apps to a new service, change to print management)
  - Networking hardware refresh (e.g. replacing a significant portion of a network's hardware infrastructure or reconfiguring a network cabinet)
- Any change to a security feature that directly affects, or is directly interacted with by, users (e.g. introduction of MFA)
- Any change to the core daily functions or nature of work carried out by users (e.g. change of workstation hardware or introduction of cloud work environments)
- Any project that contains changes to more than one core business system (e.g. a project combining multiple migrations or changes across different, unrelated systems)

## 7.3.5 What is covered by the interview

### 7.3.5.1 Service Readiness

- Why does the service exist and/or what purpose did the project serve?
- Is there a defined endpoint that includes supportability?
- What is the hypercare period and who retains responsibility during it?

### 7.3.5.2 Documentation & Knowledge

- Service overview – high level description of what the project is and does
- Runbooks & SOPs – support orientated documentation to aid in new or complex project support
- Escalation path – who does the helpdesk turn to when they have exhausted provided documentation and available expertise
- Knowledge transfer – should the helpdesk undergo specific training to aid in supporting the project

### 7.3.5.3 Service Supportability

- Is the service monitored and do alerts go to the right place
- Do helpdesk agents have the right access to diagnose and resolve common issues
- Tooling integration – has the project been integrated into existing monitoring systems
- Known issues – are any known issues and workarounds documented

### 7.3.5.4 Risk & Continuity

- Risk register review – did the project flag any known risks that may affect operations
- Backup & recovery – is there a restore process and has it been tested
- Business continuity – is there a fallback if the service fails or is the service covered under current BCDR

### 7.3.5.5 Testing & Acceptance

- Client confirmation – has the client signed off the service as functional
- Operational testing – has the service undergone any testing
- Capacity & Performance – is the service adequately resourced to meet its real-world demand

## 7.3.6 Handover

The helpdesk accepts a handover when:

- The above conditions are met
- Continuation procedures are in place to support the service beyond normal helpdesk operations
- The service has been proven stable following the hypercare period, the duration of which is agreed during the STR interview and owned by the project team
- The client confirms the service is functional in regard to the initial expectations

### 7.3.6.1 How we measure compliance

Handover compliance is reviewed by the Team Leader following each applicable project completion. The Team Leader confirms whether a handover interview was conducted and whether all acceptance conditions were met before ongoing support was assumed.

### 7.3.6.2 Record keeping and documentation

Handover interview outcomes and acceptance decisions are documented in the Service Transition Review (STR) document (see appendix) and stored in the relevant customer record. Where a handover is declined, the reason is recorded and shared with the Projects Manager.

All supporting documentation can be found in Nexus.

### 7.3.6.3 How we address shortfall

Where a handover is accepted without the required conditions being met, this is escalated to the Helpdesk Manager and Projects Manager for resolution. Misrepresentation or significant misalignment with the actual state of the client's estate is reported to the Helpdesk Manager.
