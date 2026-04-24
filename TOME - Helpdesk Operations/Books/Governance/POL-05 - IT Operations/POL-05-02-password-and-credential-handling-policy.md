# Password & Credential Handling Policy

## 5.2.1 Document Control

### 5.2.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 5.2.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 10/02/2026 |             |
| 1.1     | Jason Mcdill | 19/03/2026 | 01/04/2026  |
| 1.2     | Jason Mcdill | 26/03/2026 | 01/04/2026  |

### 5.2.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.1     | Stephen Richardson | 19/03/2026 |
| 1.1     | Rupert Evans       | 19/03/2026 |

### 5.2.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

## 5.2.2 Purpose

To define how Helpdesk agents handle passwords and credentials encountered during support activity. Credentials are high-value targets and their mishandling, even unintentionally, can result in security incidents, data breaches, and loss of customer trust. This policy establishes the minimum standard for receiving, using, and disposing of credentials, and makes clear what agents must never do.

## 5.2.3 Scope

This policy applies to all Helpdesk agents, CLS staff, and escalations engineers. It covers any password, credential, API key, token, PIN, or other authentication material encountered or received during the course of support activity, whether belonging to a customer, a customer's user, a vendor system, or an internal Digital Origin system.

## 5.2.4 Expectation

### 5.2.4.1 General principles

- Credentials exist to authenticate a specific person or system. Agents handle them only to the minimum extent necessary to complete the task at hand.
- Where access to a customer system can be obtained without receiving the customer's personal credentials, for example, through an admin account, a break-glass account, or a remote access tool, that method must be used in preference.
- Agents must never encourage a customer to share a personal password unless there is no alternative and the Team Leader has confirmed it is appropriate.

### 5.2.4.2 Receiving credentials

Where a customer provides a password or credential during a support interaction:

- It is used solely for the immediate task and discarded once complete
- It is never written into a ticket update, internal note, email, or any other record, the ticket should note that credentials were provided, not what they were
- It is never shared with another agent, team, or third party beyond what is needed to complete the task
- Where a credential has been shared verbally or in writing, the agent should advise the customer to change it once the task is complete

### 5.2.4.3 Prohibited actions

Agents must never:

- Store a customer or user password in any system, document, or personal record
- Send a password or credential via email, Teams message, ticket update, or any unencrypted channel
- Reuse a credential provided for one task in a different context without the customer's explicit instruction
- Share credentials received from a customer with another party without the customer's knowledge and consent
- Log in to a customer user's personal account using their credentials for any purpose beyond the specific task the customer has requested support for

### 5.2.4.4 Admin and service credentials

Where agents have access to admin, service, or shared accounts for customer environments:

- These credentials are managed and stored in N-Able PassPortal only
- Credentials must not be stored in personal notes, spreadsheets, browser password managers, or any system outside PassPortal
- Where a credential must be shared with another agent or team for a handover, this is done through the approved tooling, not by direct message or ticket note
- Admin credentials should be rotated in line with the customer's security requirements or Digital Origin's standard practice where no customer requirement exists

### 5.2.4.5 Password resets

Where an agent performs a password reset for a customer user:

- The temporary credential is communicated directly to the user through an appropriate channel agreed with the customer
- It is not left in a ticket note visible to other agents unless it has already been changed
- The agent confirms with the user that they have received and changed the temporary credential before closing the ticket

### 5.2.4.6 Suspicious or unexpected credential requests

Where a customer, user, or third party makes an unusual request involving credentials, for example, asking an agent to retrieve, forward, or confirm a stored password, the agent must stop, not fulfil the request, and notify their Team Leader immediately. Legitimate support requests do not typically require credential retrieval.

### 5.2.4.7 How we measure compliance

Compliance is assessed through ticket sampling, with specific attention to whether credentials appear in ticket notes, emails, or updates. Spot checks are conducted by Team Leaders. Agents are expected to raise concerns about credential handling as they arise rather than waiting for formal review.

### 5.2.4.8 Record keeping and documentation

Tickets where credentials were received or used must note that fact without recording the credential itself. Records of credential-related activity are retained as part of the ticket record. Where a credential management tool is used, access logs are retained in line with that tool's audit capability.

### 5.2.4.9 How we address shortfall

Credential handling failures, including recording passwords in tickets, sending credentials via unencrypted channels, or storing credentials outside approved tooling, are treated as serious regardless of intent. Initial failures are addressed through corrective training and documented coaching. Where the failure creates or could create a security risk, it is escalated to the Helpdesk Manager immediately and handled through the disciplinary process. Where a failure may constitute a data breach, the Information Security and Data Handling Policy applies alongside this one.
