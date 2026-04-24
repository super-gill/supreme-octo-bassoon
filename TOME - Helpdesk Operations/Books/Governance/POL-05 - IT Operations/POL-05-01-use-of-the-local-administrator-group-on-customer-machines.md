# Use of the Local Administrator group on customer machines

## 5.1.1 Document Control

### 5.1.1.1 Document Properties

| Property     | Details      |
| ------------ | ------------ |
| Last Updated | 19/03/2026   |
| Updated By   | Jason Mcdill |
| Owner        | Jason Mcdill |

### 5.1.1.2 Revision History

| Version | Author       | Date       | Next Review |
| ------- | ------------ | ---------- | ----------- |
| 1.0     | Jason Mcdill | 11/04/2025 |             |
| 1.1     | Jason Mcdill | 15/06/2025 |             |
| 1.2     | Jason Mcdill | 22/07/2025 |             |
| 1.3     | Jason Mcdill | 04/09/2025 |             |
| 1.4     | Jason Mcdill | 17/10/2025 |             |
| 1.5     | Jason Mcdill | 28/11/2025 |             |
| 1.6     | Jason Mcdill | 09/01/2026 |             |
| 1.7     | Jason Mcdill | 10/02/2026 |             |
| 1.8     | Jason Mcdill | 19/03/2026 | 01/04/2026  |

### 5.1.1.3 Executive Sponsors

| Version | Author             | Date       |
| ------- | ------------------ | ---------- |
| 1.8     | Stephen Richardson | 19/03/2026 |
| 1.8     | Rupert Evans       | 19/03/2026 |

### 5.1.1.4 Stakeholder / Distribution List

| Name          | Title                | Business Unit     | Date       |
| ------------- | -------------------- | ----------------- | ---------- |
| Jason Mcdill  | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Scott Jenkins | Helpdesk Team Leader | Customer Helpdesk | 19/03/2026 |
| Neels Steyn   | Technical Manager    | Customer Helpdesk | 19/03/2026 |

## 5.1.2 Purpose

To define the conditions under which local administrator accounts may be issued on customer machines, and to establish the configuration standards that must be followed to minimise security risk in line with current Cyber Essentials standards.

## 5.1.3 Scope

Applies to customer computers running Windows and Mac OSX.

## 5.1.4 General Guidelines

- Use of the Local Administrators group is in line with current CE standards and designed around them
- Users can have access to a local administrator account but cannot log in to it
- They must have a valid reason for having one
- Accounts should be retired when no longer required
- Issuance of a local administrator account must be approved by the user's manager in writing

## 5.1.5 Configuration of Local Administrator Accounts

- Accounts must not be identifiable from their username, i.e. “localadmin”, “JamesAdmin” etc
- Must have a unique, long and complex password
- Should be protected by MFA where possible
- The account should be prevented from logging in to windows where possible

### 5.1.5.1 How we measure compliance

Compliance is assessed through periodic review of customer machine configurations and through spot checks during ticket handling. Non-compliant configurations identified during support activity are flagged for remediation.

### 5.1.5.2 Record keeping and documentation

Issuance of local administrator accounts is recorded in the relevant ticket and in customer documentation. Written manager approval is retained as part of the ticket record.

### 5.1.5.3 How we address shortfall

Non-compliant configurations are remediated at the earliest opportunity. Accounts issued without written approval or outside the configuration standards are subject to corrective training and, where serious, the disciplinary process.
