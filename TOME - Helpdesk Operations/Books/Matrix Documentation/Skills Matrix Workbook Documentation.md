# Skills Matrix Workbook — Documentation

Last updated through Phase D½ refactor. Reference document for the Skills Matrix Workbook — covers what the workbook does, how to maintain it, and what every construct in it means.

**This doc is organised in three parts. Read the parts you need.**

- **Part 1 — Orientation (sections 1–4).** What the workbook is, where things live, how the advancement engine works, what the Departments table represents. Start here if you've never seen the workbook.
- **Part 2 — How-to guides (sections 5–7).** Adding a department, removing one, and the construction rules every change must satisfy. Read before making any modification.
- **Part 3 — Technical reference (sections 8–15).** Data flow, named LAMBDAs, named ranges, function audit, formula explanations, error codes, bugs, export instructions. Look here when debugging or extending.

## Table of contents

**[Part 1 — Orientation](#part-1--orientation)**
- [1. What the workbook does](#1-what-the-workbook-does)
- [2. Sheets](#2-sheets)
- [3. The Advancement Engine](#3-the-advancement-engine)
- [4. Departments table](#4-departments-table)

**[Part 2 — How-to guides](#part-2--how-to-guides)**
- [5. Departments](#5-departments)
    - [Adding a new department](#adding-a-new-department)
    - [Removing a department](#removing-a-department)
- [6. Agents](#6-agents)
- [7. Certifications](#7-certifications)
- [8. Daily operations](#8-daily-operations)
- [9. Tuning thresholds and configuration](#9-tuning-thresholds-and-configuration)
- [10. Debugging and audit](#10-debugging-and-audit)
- [11. Construction rules](#11-construction-rules)

**[Part 3 — Technical reference](#part-3--technical-reference)**
- [12. Data flow](#12-data-flow)
- [13. Named LAMBDAs](#13-named-lambdas)
- [14. Named ranges](#14-named-ranges)
- [15. Function audit](#15-function-audit)
- [16. Complex calculations explained](#16-complex-calculations-explained)
- [17. Error codes](#17-error-codes)
- [18. Known bugs and migration notes](#18-known-bugs-and-migration-notes)
- [19. How to export this sheet to a real Markdown file](#19-how-to-export-this-sheet-to-a-real-markdown-file)

---
# Part 1 — Orientation
## 1. What the workbook does
Tracks each agent's skill level across multiple departments, and computes the role band each agent qualifies for in each dept. Three independent gates govern advancement: a points threshold (matrix score), a deviation cap (skill spread), and certifications. A fourth entry-only gate (mastery in source departments) governs gated departments like SOC and Escalations.

The output the user cares about is **Paid Role** — the agent's role in their primary department, formatted `<DI>-<Band>[M]` (e.g. `HD-T2B3M` for Helpdesk Tier 2 Band 3 with mastery suffix).

---

## 2. Sheets

User-facing tabs (no underscore prefix):

| Sheet | Purpose |
|---|---|
| **Master Sheet** | Per-agent overview: Paid Role, days since last matrix, role per dept (G:M block), competence/deviation/points by master category. |
| **Department Sheet** | Single department deep-dive. Pick a dept in A2; shows all agents in that dept with their effective role, override, competence, deviation. |
| **Career Tracker** | _Deleted_ — was a scaffold with placeholder agent names; user has marked it as a planned feature for the future. |
| **Agents** | Source of truth for agent metadata: Agent Name, Primary Department (computed), Paid Role (computed), Last Matrix Update, Primary Role Override, per-dept Qualification Role columns, per-dept membership block (YES/PRIMARY). |
| **Certification** | Log of which agents hold which certs (Agent + Cert ID + Date Achieved). Cert ID is a dropdown sourced from CertRequirements. |
| **Data Entry** | Question bank. Each row is one question with Department, Master Category, Major Category tags, plus one column per agent containing 0/1/blank. |
| **Departments** | Source of truth for department metadata. See section 5. |
| **Parameters** | Workbook-wide settings table (Mastery Suffix, Override Flag, Canonical Score, Matrix renewal period). Read by formulas via the named ranges MasterySuffix and OverrideFlag — change values here to update the whole workbook. |
| **Error Matrix** | Error code lookup. See section 12. |

Internal helper tabs (`_` prefix — visible but not for daily use):

| Sheet | Purpose |
|---|---|
| **_Roles** | RoleTarget table (role bands and thresholds), CertRequirements (cert master list), Next Free Cert ID helper. |
| **_PayscalesCalculatorNA** | Pay calculation matrix (role × dept). |
| **_AgentNameHelper** | Agent name list source. |
| **_AgentMasteryHelper** | Per-(agent, dept) cert-derived achieved tier and mastery flag. Spilled. |
| **_AgentDeptStatsHelper** | Per-(agent, dept) stats: membership, competence, deviation, qualified band. Spilled. |
| **_AgentDeptTierProgress** | Per-(agent, dept, candidate tier) gate-by-gate pass/fail. Spilled. |
| **_AgentRollupHelper** | Per-agent cross-dept rollup (Answered %, Competence %, Raw Points, Deviation across all depts the agent belongs to). One row per agent. Spilled. Source for Master Sheet N:Q. |
| **_RoleElegibilityHelper** | _Deleted_ — was orphaned (#REF!) after Phase A; final removal in Priority 1 cleanup. |
| **_InputValidationLists** | Reference lists for dropdowns (Boolean YES/NO, dept short names, role bands). |
| **_AdvancementPlan** | Rolling design plan, build phases, bug log. |
| **_MDOut** | This documentation — source of truth for workbook documentation, exported as a Markdown file. Replaces the old Documentation tab (deleted). |

---

## 3. The Advancement Engine

### 3.1 Gates

Every (agent, dept, candidate tier) is evaluated against four gates. The agent's **Qualified Band** for the dept is the highest tier where all *applicable* gates pass.

| Gate | Measures | Passes when |
|---|---|---|
| **Cert Gate** | Highest tier reachable from the agent's cert chain in the dept | `candidate tier ≤ CertCappedTier`. CertCappedTier = MIN(MasteryAchievedTier, Departments[Cap Tier]). For non-Cert-Driven depts (e.g. Builds), CertCappedTier defaults to the dept's Cap Tier. |
| **Points Gate** | Agent's competence (% of dept questions answered with `1`) | `Competence ≥ RoleTarget[Points Threshold]`. Auto-passes if dept Gate Type ≠ `Matrix`. |
| **Deviation Gate** | Std-dev of competence across the dept's Major Categories | `Deviation ≤ RoleTarget[Max Deviation]`. Auto-passes if dept Gate Type ≠ `Matrix`. |
| **Mastery Gate** | Entry requirement for gated depts: agent must have reached a minimum band in each listed source dept | `MASTERY_ENTRY_OK(agent, dept) = TRUE`. Auto-passes if dept Gate Type ≠ `Certs+Mastery`. |

### 3.2 Gate Types

Set on the Departments table per dept. Determines which gates apply.

| Gate Type | Points | Deviation | Certs | Mastery | Use for |
|---|---|---|---|---|---|
| **Matrix** | ✓ | ✓ | ✓ | — | Standard depts with skill matrix (Helpdesk, Telecoms, NOC, Field, Builds) |
| **Certs** | — | — | ✓ | — | Industry-cert-driven depts with no skill matrix |
| **Certs+Mastery** | — | — | ✓ | ✓ | Senior depts gated behind another dept's mastery (SOC needs NOC; Escalations needs multiple) |
| **None** | — | — | — | — | Core baseline only |

### 3.3 Mastery

An agent has **mastery** in a dept when their cert-derived Achieved Tier ≥ that dept's Cap Tier. Display gets an `M` suffix (`HD-T3B1M`).

Mastery is also the unit used by the **Mastery Gate**: gated depts list source depts and minimum bands in the MasteryReqs table; an agent must reach those bands in every listed source dept to enter the gated dept.

### 3.4 Roles

RoleTarget on `_Roles` defines the 9 role bands plus Core (X):

| Sequential ID | Role |
|---|---|
| 0 | X (Core) |
| 1 | T1B1 |
| 2 | T1B2 |
| 3 | T1B3 |
| 4 | T2B1 |
| 5 | T2B2 |
| 6 | T2B3 |
| 7 | T3B1 |
| 8 | T3B2 |
| 9 | T3B3 |

Each role has a **Points Threshold** (minimum competence to qualify) and a **Max Deviation** (maximum skill spread allowed). Both are user-editable on `_Roles!RoleTarget`.

---

## 4. Departments table

Sheet: `Departments`. Source of truth for everything dept-related.

| Column | Type | Description |
|---|---|---|
| Department Full Name | Input | Long form name |
| Department Short Name | Input | Used as the dept's key everywhere. Must be unique. |
| Department Initials | Input | 2-letter prefix used in role display (`HD-T1B1`) |
| Resource Cap | Input | Max headcount for this dept |
| Role Entry Point | Input | Lowest band an agent can hold (typically T1B1; T2B3 for SOC; T3B2 for Escalations) |
| Role Cap | Input | Highest band an agent can hold |
| Cap Tier | Computed | `=XLOOKUP([@[Role Cap]], RoleTarget[Role], RoleTarget[Sequential Role ID], 0)` |
| Floor Tier | Computed | `=XLOOKUP([@[Role Entry Point]], RoleTarget[Role], RoleTarget[Sequential Role ID], 0)` |
| Gated | Computed | `=[@[Floor Tier]]>1` — TRUE if Floor > T1B1 |
| Cert Driven | Input (TRUE/FALSE dropdown) | Whether progression in this dept is gated by certs |
| Pay Modifier | Input | Multiplier applied to base pay (1.0 standard; 1.2 SOC/Escalations/Projects) |
| Has Matrix Questions | Input | Whether this dept has questions in DataEntry. Required TRUE for Matrix gate type. |
| Gate Type | Input (dropdown) | Matrix / Certs / Certs+Mastery / None |
| Status | Computed | Validation flag (`OK` or warning text) |

### MasteryReqs table (below Departments)

Defines entry gates for `Certs+Mastery` depts. Each row says: "to enter `Gated Dept`, the agent must have reached `Min Source Band` in `Source Dept`". Multiple rows for the same Gated Dept = ALL must be satisfied.

| Column | Description |
|---|---|
| Gated Dept | Dropdown of dept short names |
| Source Dept | Dropdown of dept short names |
| Min Source Band | Dropdown of role bands (T1B1..T3B3) |
| Notes | Free text |

Read by the `MASTERY_ENTRY_OK` LAMBDA.

---

---

# Part 2 — How-to guides

## 5. Departments

Departments are the structural axis of the workbook. Adding or removing one touches several other tables. The two procedures below cover the full lifecycle.

### Adding a new department

Tables auto-expand. Most steps are quick, but Master Sheet G:M and _PayscalesCalculatorNA need a manual column add.

### Step 1: Add a row to the Departments table

Click the bottom row, press Tab/Enter to extend the table, or right-click -> Insert Table Row Below.

Required cells: Full Name, Short Name (must be unique), Initials (2 letters), Resource Cap, Role Entry Point, Role Cap, Pay Modifier, Has Matrix Questions, Cert Driven, Gate Type.

Auto-computed: Cap Tier, Floor Tier, Gated, Status. Don't type into these.

### Step 2: Pick the right Gate Type

- **Matrix** — standard dept with skill-matrix questions. Set Has Matrix Questions = TRUE.
- **Certs** — industry-cert-driven dept. Set Has Matrix Questions = FALSE.
- **Certs+Mastery** — senior dept gated behind another dept's mastery. Set Has Matrix Questions = FALSE. Add rows to MasteryReqs.
- **None** — Core baseline only.

### Step 3: If Certs+Mastery, add Mastery Requirements rows

One row per source dept the agent must master to enter. Gated Dept = the new dept. Source Dept = the dept they need mastery in. Min Source Band = the minimum band they must reach (use the source dept's Role Cap for full mastery). Multiple rows = ALL conditions must be satisfied.

Self-reference is rejected: don't list the new dept as its own Source Dept.

### Step 4: Add the dept's column to Agents

On Agents, columns Q-Y hold per-agent dept membership. Insert a new column at the right end of that block, name it with the new dept's Short Name, fill in YES / PRIMARY / blank for each agent.

Optional: extend the Qualification Role columns (H-N) with a new column. Copy the formula pattern from an existing column and update the literal dept name.

### Step 5: If Has Matrix Questions = TRUE, add questions to Data Entry

Set the Department column to the new dept's Short Name. The matrix engine reads questions by Department tag, not row position.

### Step 6: If the dept needs certs, add cert chain to CertRequirements

On _Roles, CertRequirements table. Each row = one cert. Set Department, From Band, To Band, Cert Status = Live, Cert Name. Use the Next Free Cert ID helper at _Roles!L15 for a unique Cert ID.

### Step 7: Verify Status reads OK

On Departments, the Status column flags two common mistakes: Certs+Mastery without MasteryReqs rows, or Matrix without Has Matrix Questions = TRUE. Fix any warnings.

### Manual: Master Sheet column

Master Sheet G9:M9 has hardcoded dept Short Names. To extend:

1. Right-click on column N -> Insert.
2. In the new column row 9, type the new dept's Short Name (case sensitive).
3. Copy any adjacent cell from row 10 and paste-fill rows 10:34. The formula reads the dept name from row 9 of the same column.

### Manual: _PayscalesCalculatorNA column

1. Find the RoleDeptMatrix table.
2. Add a new column at the right end. Header = the new dept's Short Name.
3. Copy the formula from any adjacent dept column.

### What auto-updates (no action required)

- _AgentMasteryHelper, _AgentDeptStatsHelper, _AgentDeptTierProgress all expand to include (every agent x new dept) rows.
- _InputValidationLists C and D columns (Matrix Depts and All Depts) expand.
- Master Sheet Paid Role for any agent whose Primary Department is the new dept.
- Pay calculations on _PayscalesCalculatorNA pick up the new dept's Pay Modifier.
- Department Sheet A2 dropdown and Master Sheet S4 dropdown auto-include the new dept.
- Cap Tier / Floor Tier / Gated / Status calc columns fill themselves on the new row.

---

### Removing a department

Removal is more involved than addition because data tagged with the dept (questions, certs, agent membership) needs decisions. Work through the steps in order.

### Step 0: Audit before you start

Decide what to do with each of these before deleting anything:

- **Agents whose Primary Department = the dept being removed.** Reassign their Primary to another dept.
- **DataEntry rows tagged with the dept.** Delete the rows, OR retag them, OR leave orphaned.
- **CertRequirements rows tagged with the dept.** Set Cert Status = Retired (keeps history) OR delete the rows. Existing Certification log entries pointing at deleted Cert IDs will show #INVALID.
- **MasteryReqs rows where Source Dept = the dept being removed.** Delete those rows; other gated depts can no longer require mastery in a non-existent dept.

### Step 1: Reassign affected agents

On Agents, for every agent who had PRIMARY in the column for the dept being removed: set their PRIMARY to a different dept's column. Their Paid Role and Master Sheet entries will update automatically.

### Step 2: Clean DataEntry

Filter the Department column for the dept being removed. Delete the rows or retag them. Don't leave them — they show up as orphans in Master Sheet's Master Category dropdowns.

### Step 3: Retire or delete the dept's Cert chain

On _Roles, find CertRequirements rows where Department = the dept. Set Cert Status = Retired or delete the rows. If you delete, Certification log entries for those Cert IDs will show #INVALID — review and clean.

### Step 4: Clean MasteryReqs

On Departments (the Mastery Requirements table), delete any row where Gated Dept OR Source Dept = the dept being removed.

### Step 5: Delete the structural columns (manual)

Right-click -> Delete the dept's column on each of these sheets (column headers always match the Short Name):

- Agents tab: the dept's membership column (somewhere in Q-Y) AND the matching Qualification Role column (somewhere in H-N).
- Master Sheet: the dept's column in G-M (header on row 9).
- _PayscalesCalculatorNA: the dept's column on RoleDeptMatrix.

### Step 6: Delete the row from Departments

Right-click the dept's row on the Departments table -> Delete -> Table Row.

All helper sheets (_AgentMastery, _AgentDeptStats, _AgentDeptTierProgress, _InputValidationLists) auto-shrink because they spill from this table.

### Step 7: Verify nothing is broken

- Departments Status column shows OK on every remaining row.
- Master Sheet Paid Role column does not contain ERR.003 (= no Primary Department set).
- Certification sheet's Cert Name column does not show #INVALID for any row — if it does, those Cert IDs were retired/deleted in Step 3.

---
## 6. Agents

Agents are the rows of the matrix — the people whose progression the workbook is tracking. Their identity flows through the workbook by **name**: a single agent name is a column on Data Entry, a row on the Agents tab, a row on Certification, and a key into every helper. Adding or removing an agent touches all of these places.

### Adding a new agent

Use the dedicated `_AgentNameHelper` sheet as the authoritative source for agent names. Once a name is there, the rest follows.

1. **Add the agent's name** to the next empty row of `_AgentNameHelper` column B (rows 3-27 are the active range). The Agents sheet column B reads from here directly.
2. **Add a column to `Data Entry`** for the new agent. The fastest way: right-click the column header for an existing agent column (e.g. column header `Ella Expert`), choose Insert, then rename the new column header to the new agent's name. The existing column above is duplicated structurally; clear the new column's data values.
3. **Set up the new row on `Agents`.** The agent's name spills automatically. Fill in:
   - **Start Date** (column D) and **Last 1:1** (column E) — dates.
   - **Last Matrix Update** (column F) — today's date if you've just done a matrix; otherwise leave blank and the freshness indicator will flag it.
   - **Primary Role Override** (column G) — leave blank unless the agent is on a manual role.
4. **Set department membership** in the Q:Y block of Agents. Set exactly **one** column to `PRIMARY` (their main dept), and any other columns where they're cross-skilled to `YES`. Leave the rest blank.
5. **Add cert log entries** on the Certification sheet for any certs the new agent already holds. Pick the Cert ID from the dropdown; Cert Name auto-resolves.
6. **Verify** — the new agent should appear on Master Sheet, on the relevant Department Sheet (set the dropdown to their primary dept), and their Paid Role should show a sensible band (or `<DI>-CORE` until they earn their first cert / hit the points threshold).

Watch for: an agent name that contains a digit — the `_AgentNameHelper` filter blanks out names containing 0-9. If you must use a digit, edit the filter formula or use a spelled-out variant (e.g. `Sam Two` instead of `Sam 2`).

### Removing or archiving an agent

Removal is more involved than adding because the agent has historical data scattered across DataEntry, Certification, and the Agents row. Decide first whether you want to **remove** (delete everything) or **archive** (keep history, flag the agent as inactive). The workbook doesn't have a built-in archive flag yet — if you want one, add an `Active` column to Agents with TRUE/FALSE and update the agent-list filters.

**Full removal:**

1. **Delete their column on `Data Entry`** — right-click the agent's column header → Delete. All matrix answers are gone.
2. **Delete their rows on `Certification`** — filter the Agent column for the name, delete the rows.
3. **Clear their row on `Agents`** — specifically the manual cells: Start Date, Last 1:1, Last Matrix Update, Primary Role Override, and the membership block (Q:Y). The Agent Name itself comes from `_AgentNameHelper` so blank that there too.
4. **Clear their entry on `_AgentNameHelper`** — delete the value in column B for that row.
5. **Verify** — the agent should no longer appear anywhere. Helper sheets auto-shrink because they spill from the agent name list.

**Archive (light touch):**

Add a leading marker to the agent's name on `_AgentNameHelper` (e.g. `[ARCHIVED] Adam Apprentice`). The matrix data stays intact in DataEntry. The agent will still appear in lists but tagged. Better long-term: introduce an Active flag, but that's a small build job.

### Renaming an agent

Names are the cross-table key. Renaming touches three places.

1. **Update `_AgentNameHelper` column B.** This is the single source the Agents sheet reads from.
2. **Update the column header on `Data Entry`** to the new name. The header is what the formulas match on.
3. **Update the Agent column on `Certification`** — if any cert log entries reference the old name, change them. The Certification sheet stores names by value (not lookup), so old entries don't auto-update.

Helper sheets all key off the live name from `_AgentNameHelper`, so they update automatically. The agent's Paid Role and qualified bands recompute on next sync.

### Changing an agent's primary department

1. On the Agents sheet, find the agent's row and locate the membership block (columns Q:Y).
2. Find the column with `PRIMARY` and change it to either `YES` (if they remain a member of that dept) or blank (if they're leaving it entirely).
3. Set `PRIMARY` in the column for their new primary dept.

Validation: exactly one column must be `PRIMARY` per row. If you accidentally have two, the Primary Department column shows `ERR.002`. If you have zero, it shows `ERR.003`. The Agents sheet's Paid Role column then surfaces the same error.

### Changing department membership

Use the membership block on Agents (columns Q:Y) and the values `PRIMARY`, `YES`, or blank.

- **Add an agent to a dept** as cross-skilled: set the relevant column to `YES`.
- **Remove an agent from a dept**: clear the cell.
- **Promote a YES to PRIMARY**: see *Changing primary department* above — you must demote the existing PRIMARY first.

Setting `YES` on a gated dept (SOC, Escalations) doesn't bypass the entry mastery gate. The agent will appear in that dept's list but their Qualified Band will be blank until they meet the mastery requirements.

Membership changes are picked up immediately by the engine. There's no need to recalculate or refresh anything.

























## 7. Certifications

Certifications drive cert-gated bands and contribute to mastery. Every cert lives twice in the workbook: once as a definition (`CertRequirements` table on `_Roles`) and once per holder (`Certification` sheet, the `AgentCerts` table). Both have to stay in sync.

### Adding a new certification to the catalog

Certs are defined on `_Roles` in the `CertRequirements` table (rows 17 onwards).

1. **Find the next free Cert ID** at `_Roles!L15` (it auto-suggests, e.g. `CERT072`). Note the value.
2. **Add a row** to the bottom of CertRequirements. Fill in:
   - **Department** — the dept this cert belongs to (Helpdesk, NOC, etc.). Use the dept's Short Name.
   - **From Band** and **To Band** — the band the agent must already be at, and the band this cert advances them to. e.g. `T1B3` → `T2B1` for a tier transition cert.
   - **Cert Status** — `Live` (active) or `Retired` (kept for history but no longer counted toward progression).
   - **Cert Name** — the human-readable name (e.g. `CompTIA N+`, `MD-102`).
   - **Cert ID** — paste the value from L15. The ID Status column will turn `OK` if the format is right and the ID is unique.
   - **Interview** — `Yes` if a live interview / sign-off is part of awarding the cert.
   - **Notes** — free text, e.g. `Tier 2→3 transition`, `SOC entry band`.
3. **Verify ID Status reads OK.** If it shows `⚠️ Duplicate`, the ID was already in use — use a different one (regenerate by re-reading L15). If `⚠️ Wrong format`, the ID must start with `CERT` followed by digits.
4. The cert is now selectable on the Certification sheet's Cert ID dropdown.

If the new cert defines a band the agent reaches as the dept's Role Cap (e.g. To Band = T3B1 in Helpdesk), holding this cert contributes to mastery. The engine treats mastery as 'all Live certs up to and including the dept cap held'.

### Awarding a certification to an agent

Use the `Certification` sheet (table `AgentCerts`).

1. Add a new row at the bottom of the table.
2. **Agent** — type or pick the agent's name. Must match `Agents[Agent Name]` exactly.
3. **Cert ID** — use the dropdown. The list comes from `CertRequirements[Cert ID]`.
4. **Cert Name** — auto-fills from CertRequirements. If it shows `#INVALID`, the Cert ID doesn't match a known cert (typo or the cert was deleted from the catalog).
5. **Date Achieved** — the date the agent completed the cert.
6. **Notes** — optional.

Once committed, the agent's qualification role recomputes immediately. If this cert advanced them to a new band and they now meet all the gates, their Paid Role updates. If it pushed them to the dept's Role Cap, they pick up the mastery suffix (e.g. `T3B1M`).

### Retiring a certification

When a cert is being phased out (e.g. CompTIA replaced its old name with a new one) but you don't want to lose the history of who held it:

1. On `CertRequirements` (`_Roles`), find the cert and change **Cert Status** from `Live` to `Retired`.
2. Existing agent holdings on the Certification sheet stay as-is. The Cert Name still resolves correctly.
3. **The engine stops counting it toward progression.** An agent who only holds Retired certs in a band-pair is treated as if they hold no certs in that pair.
4. Optionally, add a replacement cert (with `Live` status) to CertRequirements alongside it, and award the new cert to anyone who previously held the retired one.

Don't delete a Retired cert outright unless you also clean up every Certification entry referencing it — those would otherwise show `#INVALID`.

### Renaming or fixing a certification

**Renaming a Cert Name** is safe — the engine matches by Cert ID, not by name. Edit the Cert Name on CertRequirements and every Certification log entry's display name updates automatically.

**Changing a Cert ID** is risky — every Certification log entry references the ID by value. If you change the ID:

1. On `Certification`, filter for the old Cert ID. Update each row's Cert ID to the new one.
2. Then change the Cert ID on `CertRequirements`.

Watch for `#INVALID` showing up in the Cert Name column afterwards — those are entries you missed. Also check `_Roles!J17` (ID Status) on CertRequirements turns `OK` after the change.

**Changing a cert's From Band / To Band** affects the cert chain math. The mastery and qualification calculations re-evaluate immediately. If you change a cert's transition band, agents who held that cert may suddenly be at a different qualification tier.

**Changing the Department of an existing cert** is the most disruptive change — it moves the cert to a different chain. Agents holding it now contribute their cert to the new dept, which can shift their qualification across multiple departments at once. Only do this if you genuinely meant to reclassify the cert.















## 8. Daily operations

Day-to-day use of the workbook — what you'll do regularly without changing any structural setup. These are the workflows for someone running matrix updates, reviewing agents, or having a 1:1.

### Running a matrix update for an agent

A matrix update is the act of going through the question bank and recording the agent's current competency for each question. The result feeds Points and Deviation, which in turn drive the agent's Qualified Band.

1. Open the **Data Entry** sheet.
2. Find the column with the agent's name. The header at row 6 is the lookup key — it must match `Agents[Agent Name]` exactly.
3. Walk down the column row-by-row, entering a score for each question:
   - **`1`** = the agent demonstrates competency for this skill
   - **`0`** = the agent does not demonstrate competency
   - **blank** = not yet assessed (the answered % calculation excludes blanks)
4. The questions are tagged by Department, Master Category, and Major Category. Skip questions whose Department isn't relevant to this agent.
5. When done, go to the **Agents** sheet and update **Last Matrix Update** (column F) for this agent to today's date.

Tips:

- The `Unanswered` row at top of Data Entry shows how many questions still have a blank for each agent. Aim for 0 in their dept's questions.
- Don't enter values other than 0, 1, or blank — the math assumes binary scoring. Text or fractional values cause `ERR.014`.
- If the agent is a member of multiple departments, score every question in every dept they're in (YES or PRIMARY). Cross-dept stats roll up across all their depts.

### Reading the Master Sheet

Master Sheet is the at-a-glance view: one row per agent, one column block per dept.

Columns to read:

- **A** Agent Name — spilled list of real agents.
- **B** Helpdesk — the agent's Primary Department (computed).
- **C** Last Matrix Update — date of their last full matrix run.
- **D** Days Since Matrix Update — if this exceeds the **Matrix renewal period** in Parameters (default 90), their data is stale and should be re-run.
- **E** Paid Role — the agent's effective role today (e.g. `HD-T2B3M`). This is the headline number.
- **F** Primary Role Override — if set, displayed with a flag character (default `⚑`) to indicate manual override.
- **G:M** Per-dept role view — each cell shows the agent's effective role in that dept (or blank if not a member).
- **N** Cross-Department Answered % — portion of in-scope questions the agent has answered.
- **O** Cross-Department Deviation — standard deviation of competence across major categories. Lower = more even skill spread.
- **P** Cross-Department Competence — portion of in-scope questions the agent scored 1.
- **Q** Cross-Department Raw Points — sum of 1s across the agent's depts.

The right-hand block from Q4 onwards is a Master Category breakdown for a chosen dept. Pick the dept in `S4` (and use the dropdown at `Q4` if it appears) and the matrix shows per-agent scores within each Master Category.

### Using the Department Sheet for a 1:1

Department Sheet is the deep-dive for one dept. Pick a dept in `A2` and the agent list, qualifications, and scores filter to just that dept's members.

For a 1:1 with an agent:

1. Set `A2` to the agent's primary dept.
2. Find their row. Read in this order:
   - **D** Effective Dept Matrix Role — their current role in this dept.
   - **F** Dept Qualification Role — the highest band their certs unlock (the cert ceiling).
   - **G** Difference to next Role — whole points to the next role threshold. `MAX` = at top, `N/A` = not Matrix-gated.
   - **H** Total Complete — % of dept questions they've answered (data freshness).
   - **I** Deviation — skill spread within the dept.
   - **J** Total Competence — % of questions scored 1.
   - **K** Total Points — raw whole points.
3. Use **G** as the headline development target ("you need X more competence points to advance") and **F** as the cert development target ("you need cert Y to unlock the next band").

If columns D and F disagree (e.g. D says `HD-T1B3` but F says `T2B1`), the cert ceiling is higher than the matrix gate — the agent has the certs but not the points or deviation. Their development is matrix work, not certs.

If F is higher than D's band part, the opposite is true — certs are the bottleneck.

### Setting a manual role override

Sometimes you need to override the engine — a tactical promotion, a temporary cover role, or a known-but-not-yet-certified situation.

1. On the **Agents** sheet, find the agent's row.
2. In **Primary Role Override** (column G), type the band string (e.g. `T2B3` or `T3B1M`).
3. The agent's Paid Role on the Agents sheet, the Master Sheet, and the Department Sheet all immediately switch to `<DI>-<override> <flag>` (default flag = `⚑`), bypassing all gate checks.

If the override string isn't a valid role band, the cell shows `ERR.007`. Valid bands are listed in `RoleTarget[Role]` on `_Roles`.

To remove the override, delete the value in column G. The engine returns to gate-based qualification.

The override flag character is a single Parameter (`Parameters!D6`), so changing it on the Parameters sheet updates the visual indicator everywhere.



## 9. Tuning thresholds and configuration

These are the dials that change how the engine behaves without changing its structure. Pulling any of them propagates immediately across the workbook.

### Adjusting role thresholds

The points and deviation thresholds for each role band live on `_Roles` in the `RoleTarget` table.

1. Open `_Roles`. The table starts at row 2 with one row per band (T1B1 through T3B3, plus X for Core).
2. To change the points required for a band: edit **Points Threshold** for that row. Value is a ratio (0.30 = 30% of dept questions answered correctly).
3. To change the deviation cap: edit **Max Deviation** for that row. Value is a standard deviation across major-category competence ratios. Lower numbers = stricter (skill must be more even across categories to pass).

Recalculation is automatic. Master Sheet, Department Sheet, and the helper engine all update instantly.

Practical guidance:

- **Raising a Points Threshold** demotes anyone whose competence used to clear it but no longer does. Use the Department Sheet G ("Difference to next Role") column afterwards to see who's now blocked.
- **Lowering a Max Deviation** demotes agents with uneven skill spreads. They need to broaden their competence within the dept before they re-qualify.
- The thresholds are global per band, not per dept. If you want a dept-specific threshold, that's a structural change — it would mean adding per-dept threshold columns to either RoleTarget or Departments and updating the engine LAMBDAs.

### Adjusting pay modifiers

Pay modifiers scale a role's base rate by department. They live on the `Departments` table in column L (`Pay Modifier`).

1. Open the `Departments` sheet.
2. Find the dept's row, edit the `Pay Modifier` cell. Default for most depts is `1` (no adjustment). SOC and Escalations carry `1.2`.
3. The pay matrix on `_PayscalesCalculatorNA` (table `RoleDeptMatrix`) recomputes immediately.

Watch for: Pay Modifier of `0` will zero out that dept's column on the pay matrix. Use a small positive number (e.g. `0.01`) if you want to flag a dept as effectively unpaid but not break the matrix display.

The base rates and the 2026 modifier (annual cost-of-living adjustment) live on `_PayscalesCalculatorNA` in the `RoleRates` table. Change the base rate for a band to push every dept's pay for that band up or down. Change the 2026 modifier to apply a workbook-wide annual uplift.

### Adjusting Parameters (suffix, flag, renewal period)

Workbook-wide settings are on the `Parameters` sheet.

| Parameter | Cell | Effect of changing |
|---|---|---|
| Canonical Score | D3 | Reference total used in some normalizations. Rarely changed. |
| Matrix renewal period | D4 | Days before a matrix is considered stale. Master Sheet's "Days Since Matrix Update" warns when an agent exceeds this. |
| Mastery Suffix | D5 | The character appended to a band when an agent is at dept cap (default `M`, e.g. `T3B1M`). Used by every role display formula via the `MasterySuffix` named range. |
| Override Flag | D6 | The character appended after a manually overridden role (default `⚑`). Used by `OVERRIDE_CHECK`. |

Edit any of these once and every consumer picks up the new value. The rule (rule 7 — user can extend) is that anything globally tunable lives here.

If you find a hardcoded literal somewhere that should be tunable, that's an opportunity for a new Parameters row — add the row, give it a name and a Description, then add a workbook-level named range pointing at its Parameter cell, and replace the literal in the consuming formulas with the named range.

### Adjusting mastery requirements

Mastery entry gates for `Certs+Mastery` depts (SOC, Escalations) live on the `Departments` sheet in the `MasteryReqs` table (rows 13 onwards).

Each row says: "to enter Gated Dept, the agent must have reached at least Min Source Band in Source Dept."

1. Open `Departments`, scroll to the Mastery Requirements table.
2. To add a requirement, append a row. Pick **Gated Dept** (the dept being entered), **Source Dept** (the dept whose mastery is required), and **Min Source Band** from the dropdowns. Add a Note for context.
3. To remove a requirement, delete the row.
4. To change a requirement, edit the existing row's Min Source Band.

Multiple rows for the same Gated Dept = ALL must be satisfied (AND logic). For example, Escalations currently has five rows — the agent must have reached the listed band in **every** source dept to be qualified for Escalations.

**Self-reference is invalid** — don't list a dept as both Gated Dept and Source Dept on the same row, even though the dropdown allows it. The engine doesn't currently validate this; treat it as an authoring error.

After any change, the Status column on the Departments table re-evaluates. A Certs+Mastery dept with no MasteryReqs rows triggers a `⚠️ No Mastery Reqs rows` warning. The MASTERY_ENTRY_OK LAMBDA reads the table directly so changes take effect immediately.

Practical guidance:

- **Tightening** an entry gate (raising Min Source Band) ejects anyone in the gated dept who no longer qualifies. They drop to `<DI>-CORE` until they meet the higher bar.
- **Adding** a new source dept requirement is similar — anyone who hadn't earned the new prerequisite drops out.
- **Removing** a requirement opens the gated dept to more agents. Anyone whose certs already qualify them now sees their Qualified Band populate.











## 10. Debugging and audit

What to do when something looks wrong, and the routine checks that catch problems before they bite. Construction rule 6 is "user can troubleshoot" — these are the troubleshooting paths that rule guarantees.

### Reading the Departments Status column

Every dept row on `Departments` has a `Status` column (column O) that flags configuration problems.

| Status | Meaning | Fix |
|---|---|---|
| `OK` | The row is consistent. | Nothing to do. |
| `⚠️ No Mastery Reqs rows` | Gate Type is `Certs+Mastery` but no rows in MasteryReqs name this dept as Gated Dept. | Add at least one row to MasteryReqs (Section 9 — Adjusting mastery requirements). Otherwise nobody can ever enter the dept. |
| `⚠️ Matrix dept needs Has Matrix Questions = TRUE` | Gate Type is `Matrix` but the Has Matrix Questions flag is off. | Either set Has Matrix Questions to TRUE (and add the relevant rows to Data Entry), or change the Gate Type to `Certs` / `Certs+Mastery` / `None`. |

Treat any non-OK Status as a blocking issue — the engine won't return useful Qualified Bands for that dept until it's resolved.

### Investigating why an agent's role looks wrong

When the Paid Role on Master Sheet doesn't match what you expect, work down this checklist. Each step rules out a category of cause.

1. **Is the agent in the right primary department?** Master Sheet column B (or Agents column P) shows it. If `ERR.002` or `ERR.003`, fix membership first — see Section 6 (Changing primary department).
2. **Is there a manual override?** Master Sheet column F. If set, it overrides everything else and the role displays with the override flag character. Clear column G on Agents to remove.
3. **Look at their cert column for that dept** on Agents (H:O). If blank, the agent has no cert chain in this dept — they'll show CORE in non-cert-driven depts and blank in cert-driven ones.
4. **If the cert column shows a band but Master Sheet shows CORE**, the agent's competence is below the Points Threshold for their cert-derived band. Open Department Sheet (set A2 to that dept) and look at columns G, H, J, K — G tells you exactly how many points away they are.
5. **If a gated dept (SOC, Escalations) shows CORE despite the agent having certs**, check the MasteryReqs entry gate. The agent must satisfy ALL rows for that gated dept. The MASTERY_ENTRY_OK LAMBDA is what's failing — you can sanity-test it directly: in any blank cell type `=MASTERY_ENTRY_OK("Agent Name", "GatedDept")` and it returns TRUE/FALSE.
6. **If everything looks right but the role is still wrong**, the helper sheets may have stale values. Force a recalc by editing any input cell (e.g. add and delete a space in a DataEntry cell). The spilled helpers should re-evaluate immediately.

Trace flow:

```
Master Sheet[Paid Role]
  → Agents[Paid Role]
    → StatsQualifiedBand
      → _AgentDeptStatsHelper[Qualified Band] (col O)
        → MAXIFS over _AgentDeptTierProgress where All Gates Pass = TRUE
          → inspect Cert / Points / Deviation / Mastery gate columns for that (agent, dept, tier) row
```

If you click into the Master Sheet cell, you can follow these references through Excel's Trace Precedents tool to see exactly where any cell value originates.

### Diagnosing #INVALID on the Certification log

The `Cert Name` column on Certification looks up the Cert ID in CertRequirements. If the lookup fails, the cell shows `#INVALID`.

Causes:

1. **The Cert ID was typed wrong** — most common when the dropdown wasn't used. Pick a valid ID from the dropdown to fix.
2. **The cert was deleted from CertRequirements** — the catalog row was removed but agent log entries still reference it. Either re-add the cert with the same ID, or delete the orphan log entries.
3. **The Cert ID was renamed on CertRequirements** — see Section 7 (Renaming or fixing a certification). The fix is to update each Certification log entry to the new ID.

Periodic check: filter Certification's Cert Name column for `#INVALID`. The filtered view is the cleanup list.

### Annual review and audit checklist

Run through this once a year (or whenever the workbook gets passed between maintainers) to keep it healthy.

**Data freshness:**

- On Master Sheet, scan column D (Days Since Matrix Update). Anyone past the renewal period (Parameters!D4, default 90 days) needs a fresh matrix run.
- Spot-check a few agents' Last 1:1 (Agents column E) to make sure they're current.

**Configuration health:**

- Departments Status column — every row should read OK.
- _Roles!J17 (CertRequirements ID Status) — every row should read OK. Duplicates and wrong-format IDs surface here.
- Master Sheet Paid Role column — no `ERR.001` to `ERR.022` errors. Each error code's meaning is in Section 12.

**Orphans and gaps:**

- Filter Certification's Cert Name column for `#INVALID`. Clean any orphan entries.
- Spot-check that every agent on _AgentNameHelper has a column on Data Entry. If not, score for that agent will read 0 across the board.
- Check Data Entry for rows where Department isn't in `Departments[Department Short Name]`. Those rows are orphaned (their scores don't roll up to any dept).

**Calibration:**

- Pick a representative agent in each dept. Walk through Department Sheet for them and confirm the role looks right (matches your manager's gut sense). If the engine consistently disagrees with reality, the thresholds may be miscalibrated — see Section 9 (Adjusting role thresholds).
- If any new certs have been published in the industry, add them to CertRequirements with their band-pair before agents start earning them.

**Annual uplift:**

- Update the year modifier on `_PayscalesCalculatorNA!RoleRates` (the column currently labelled `2026 Modifier`). Rename the column header to the new year and adjust the value. The pay matrix recomputes.

**Document any changes** in Section 18 of this doc (Known bugs and migration notes) so the next maintainer has the context.
---

## 11. Construction rules


These are the binding design constraints the workbook is held to. Every change should satisfy all of them.

1. **Human-readable formulas.** A formula must be one a competent spreadsheet user could write themselves. No clever AI tricks.
2. **LAMBDAs encouraged when they reduce repetition.** If a non-trivial formula appears 3+ times, factor it into a named LAMBDA. Each LAMBDA must have (a) a comment in Name Manager describing inputs/output, and (b) a cross-reference in this Documentation. INDEX/MATCH/MATCH and LET inside a LAMBDA are fine — the wrapper IS the documentation.
3. **No deep embed cascades.** Max 3 levels of function nesting in any single cell. Beyond that, split into helper columns or LAMBDAs.
4. **Helper columns over inline LET.** If you'd reach for LET to name 4+ intermediate values, those values belong in their own visible columns or a helper sheet.
5. **Documentation alongside every new construct.** Every new sheet, table, column, and LAMBDA gets a one-liner explaining its purpose.
6. **User can troubleshoot.** When something looks wrong, the user must be able to trace from the symptom (e.g. wrong qualified role) back to the input (e.g. cert missing, points below threshold) by clicking through cells.
7. **User can extend.** Adding a new dept, role, cert, or threshold is done by editing tables — not by writing formulas. Dropdowns and validation guide them.
8. **Maintainable means visible.** Any helper sheet that does real work must be visible (not hidden). Prefix with underscore (_) to convention-mark as internal, but stay accessible.
9. **Table placement.** If a table has no user-editable parts, it goes on a helper sheet (_-prefixed). User-editable agent metadata goes on Agents. User-editable dept metadata goes on Departments. Use as few tables as possible.
10. **No positional or literal agent/dept refs in helpers.** Source-of-truth = Agents[Agent Name] + Departments[Department Short Name]. Role names (T1B1, etc.) and Gate Type strings (Matrix, Certs, etc.) are OK as literals.
11. **LAMBDA threshold.** A formula becomes a named LAMBDA when (a) it's used in 3+ cells with the same shape, OR (b) it's used on 2+ different sheets, OR (c) it's a named domain concept worth testing in isolation. Otherwise stay inline. Don't LAMBDA-ify single-use formulas — the indirection costs more than it saves.

### Standards

These derive from the rules above and tell you HOW to satisfy them in practice.

**Naming**

- Sheets: PascalCase user-facing (`Master Sheet`, `Department Sheet`), `_PrefixedHelper` for internal/computed.
- Tables: PascalCase singular concept (`AgentStats`, `RoleTarget`, `MasteryReqs`).
- Named ranges: PascalCase, prefix matches the source (`StatsKey`, `TPAllGatesPass`, `RollupAnswered`).
- LAMBDAs: SCREAMING_SNAKE_CASE, verb_subject form (`MASTERY_ENTRY_OK`, `AGENT_DEPT_QUAL_ROLE`, `OVERRIDE_CHECK`). Reads like a sentence at the use site.
- Parameters in LAMBDAs: lowerCamelCase, descriptive (`agent`, `dept`, `override`), never `x` or `a1`.

**Documentation requirements per construct**

| Construct | Where it's documented |
|---|---|
| New sheet | Section 2 (sheet inventory) of this doc |
| New table | Either as a sheet description (Section 2) or in a dedicated section if structurally important |
| New computed column | A header note on the column itself, plus a Function Audit / Complex Formula entry if non-trivial |
| New LAMBDA | (1) Name Manager comment with inputs and return value, (2) Function Audit row, (3) Section 13 entry with example use |
| New named range | Section 14 row, including the underlying expression and use-case |
| New error code | Error Matrix sheet AND Section 17 of this doc |
| New bug discovered | Section 18 of this doc, with status (Open / Fixed / Mitigated) and root cause |

**Formula patterns**

- **Lookups across (agent, dept) pairs**: build a key as `agent & "|" & dept`, look up in `StatsKey` or `MasteryKey` spill-named ranges. Never positional row indexing.
- **Spilled helpers**: anchor the row dimension with `FILTER(Agents[Agent Name], Agents[Agent Name]<>"")` and the column dimension with `Departments[Department Short Name]`. Build the Cartesian via `SEQUENCE` + `INT/MOD`. Other columns then `BYROW` over the anchors.
- **Suffix/flag chars**: read from Parameters via `MasterySuffix` and `OverrideFlag` named ranges. Never hardcode the literal characters.
- **Dept membership in formulas**: read by name via `INDEX(INDEX(Agents,0,MATCH(d,Agents[#Headers],0)),MATCH(a,Agents[Agent Name],0))`. Never positional like `Agents!P3`.
- **Error trapping**: wrap any external XLOOKUP in `IFERROR(..., "" )` or a sensible default. Bare XLOOKUPs that can return #N/A are forbidden in user-facing cells.

**Validation requirements**

- Any user-editable cell with a finite valid set gets a Data Validation dropdown.
- Dropdown sources: `=DeptShortNames`, `=RoleBands`, `=CertIDs`, `=TRUE,FALSE`, etc. Always use a named range or table column — never hardcoded comma-separated literals (except for true enums of <=4 values like Gate Type).
- Status / health columns belong on the table they describe (e.g. Departments[Status]) and use `IFS` to flag specific misconfigs by name.

**Layout conventions**

- Tables on user-facing sheets start at row 2 (header) with title text in row 1 if needed.
- Helper sheets put the spill anchor at A2/B2/C2 etc with bold headers in row 1. Audit/test cells go far right (e.g. AJ:AL) so they don't clutter the data.
- Agent rows on user-facing sheets are spilled from `_AgentNameHelper` or `Agents[Agent Name]`, never typed in.

### When to use what — quick reference

| Situation | Choice |
|---|---|
| Formula appears in 1 cell, won't be reused | Inline LET. Stay readable, max 3 nesting levels. |
| Formula appears in 3+ cells with same shape | Named LAMBDA. Document per Rule 11. |
| Need 4+ named intermediate values | Helper columns on a `_`-prefixed sheet. |
| Need to derive a value from another sheet's table | XLOOKUP via named range. Never positional. |
| Need a list that grows (agents, depts, roles) | Spill from `Agents[Agent Name]` / `Departments[Department Short Name]` / `RoleTarget[Role]`. |
| Need a fixed enum (e.g. Gate Type) | Hardcoded dropdown source string. Document the values in this doc. |
| Need a system-wide tunable (e.g. a suffix character, a date threshold) | Add to Parameters table, expose via a named range. |
| Need a per-dept / per-role tunable | Add a column to Departments / RoleTarget. |
| Need a workspace for testing a LAMBDA | Bottom-right of `_AgentDeptStatsHelper` or any `_`-prefixed sheet. Label clearly so it's not mistaken for live data. |

### Anti-patterns to avoid

- An expression no one without explanation could understand (e.g. the original `_AgentNameHelper` SEARCH+ROW trick).
- A LAMBDA that's only used in one cell. Inline it instead.
- A LAMBDA that wraps another LAMBDA that wraps another LAMBDA. The reader can't tell what's actually happening.
- A magic literal that's actually a parameter (e.g. `<>"Builds"` to mean "is cert-driven"). Promote to a real column / Parameters entry.
- A range reference that breaks when a column is inserted (e.g. `Q3:Y3` when Y is the rightmost dept). Use `Departments[Department Short Name]` to derive the count instead.
- A computed value typed in as a literal because "it's faster". The next data change will silently invalidate it.
- Test/audit cells mixed in with live data. Always isolate to a far-right block on a helper sheet.
- A bug fix without a Section 18 entry. Bugs that aren't logged get re-discovered.

---

---

# Part 3 — Technical reference

## 12. Data flow

```
USER-EDITABLE                    COMPUTED HELPERS                   DISPLAY
─────────────                    ────────────────                   ───────
Departments[…]              ──┐
RoleTarget[Points Threshold]──┤
RoleTarget[Max Deviation]   ──┼──►  _AgentMasteryHelper       ──┐
CertRequirements            ──┤     (cert-derived band)         │
MasteryReqs                 ──┤                                 ├──►  _AgentDeptStatsHelper
DataEntry                   ──┤     _AgentDeptTierProgress  ──┐ │     (Qualified Band)
AgentCerts                  ──┤     (per-tier gate pass/fail) │ │           │
Agents membership block     ──┘                                ◄─┘           ▼
                                                                       Master Sheet
                                                                       Department Sheet
                                                                       Agents.Paid Role
```

---

## 13. Named LAMBDAs

All LAMBDAs are defined in the workbook's Name Manager. Each has a comment describing inputs and output.

### MASTERY_ENTRY_OK(agent, dept)

Returns TRUE if the agent meets all entry mastery requirements for a gated dept. Returns TRUE for non-gated depts.

```
=LAMBDA(agent, dept,
  LET(
    reqs,       IFERROR(FILTER(MasteryReqs[Source Dept],     MasteryReqs[Gated Dept]=dept), ""),
    minBands,   IFERROR(FILTER(MasteryReqs[Min Source Band], MasteryReqs[Gated Dept]=dept), ""),
    minTiers,   IFERROR(XLOOKUP(minBands, RoleTarget[Role], RoleTarget[Sequential Role ID]), 0),
    sourceKeys, agent & "|" & reqs,
    achieved,   IFERROR(XLOOKUP(sourceKeys, _AgentMastery[Key], _AgentMastery[Achieved Tier]), 0),
    IF(@reqs="", TRUE, AND(achieved >= minTiers))
  )
)
```

Used by _AgentDeptTierProgress[Mastery Gate].

### ACHIEVED_TIER(agent, dept)

Computes the highest tier an agent has achieved in a dept based on their cert chain. Walks unique From-To band-pairs in tier order, only advancing if all certs in a pair are held.

Used by _AgentMastery[Achieved Tier].

### DEPT_INITIALS(dept)

```
=LAMBDA(dept, IFERROR(XLOOKUP(dept, Departments[Department Short Name], Departments[Department Initials]), ""))
```

Returns the 2-letter dept code (e.g. Helpdesk -> HD). Used in role display formulas.

### OVERRIDE_CHECK(override)

```
=LAMBDA(override,
  IF(override="", "",
    IF(ISERROR(MATCH(override, RoleTarget[Role], 0)), "ERR.007", override & " ⚑")
  )
)
```

Validates a manual role override. Returns blank for blank input, ERR.007 for an invalid role string, or `<role> ⚑` for a valid one. Used by Department Sheet D9:D33 and Agents[Paid Role].

---

## 14. Named ranges

All defined in the workbook's Name Manager. The `#` operator means the spilled range from this anchor cell.

### Mastery helper (_AgentMasteryHelper spills)

| Name | Formula |
|---|---|
| MasteryKey | =_AgentMasteryHelper!$A$2# |
| MasteryAgent | =_AgentMasteryHelper!$B$2# |
| MasteryDept | =_AgentMasteryHelper!$C$2# |
| MasteryAchievedTier | =_AgentMasteryHelper!$D$2# |
| MasteryAchievedBand | =_AgentMasteryHelper!$E$2# |
| MasteryHasMastery | =_AgentMasteryHelper!$F$2# |
| MasteryIsMember | =_AgentMasteryHelper!$G$2# |

### Stats helper (_AgentDeptStatsHelper spills)

| Name | Formula |
|---|---|
| StatsAgent | =_AgentDeptStatsHelper!$A$2# |
| StatsDept | =_AgentDeptStatsHelper!$B$2# |
| StatsMembership | =_AgentDeptStatsHelper!$C$2# |
| StatsCert | =_AgentDeptStatsHelper!$D$2# |
| StatsCertTier | =_AgentDeptStatsHelper!$E$2# |
| StatsCertCappedTier | =_AgentDeptStatsHelper!$F$2# |
| StatsCertCappedRole | =_AgentDeptStatsHelper!$G$2# |
| StatsDeptQuestions | =_AgentDeptStatsHelper!$H$2# |
| StatsRawPoints | =_AgentDeptStatsHelper!$I$2# |
| StatsCompetence | =_AgentDeptStatsHelper!$J$2# |
| StatsDeviation | =_AgentDeptStatsHelper!$K$2# |
| StatsKey | =_AgentDeptStatsHelper!$L$2# |
| StatsAchievedBand | =_AgentDeptStatsHelper!$M$2# |
| StatsHasMastery | =_AgentDeptStatsHelper!$N$2# |
| StatsQualifiedBand | =_AgentDeptStatsHelper!$O$2# |

### Tier progress helper (_AgentDeptTierProgress spills)

| Name | Formula |
|---|---|
| TPKey | =_AgentDeptTierProgress!$A$2# |
| TPAgent | =_AgentDeptTierProgress!$B$2# |
| TPDept | =_AgentDeptTierProgress!$C$2# |
| TPTierID | =_AgentDeptTierProgress!$D$2# |
| TPTierName | =_AgentDeptTierProgress!$E$2# |
| TPGateType | =_AgentDeptTierProgress!$F$2# |
| TPCertGate | =_AgentDeptTierProgress!$L$2# |
| TPPointsGate | =_AgentDeptTierProgress!$M$2# |
| TPDeviationGate | =_AgentDeptTierProgress!$N$2# |
| TPMasteryGate | =_AgentDeptTierProgress!$O$2# |
| TPAllGatesPass | =_AgentDeptTierProgress!$P$2# |

### Misc named ranges

| Name | Formula | Use |
|---|---|---|
| DeptShortNames | =Departments[Department Short Name] | Dropdown source for dept pickers |
| RoleBands | =RoleTarget[Role] | Dropdown source for band pickers |
| CertIDs | =CertRequirements[Cert ID] | Dropdown source for Certification!B (Cert ID) |
| MasterySuffix | =XLOOKUP("Mastery Suffix",Parameters[Name],Parameters[Parameter],"M") | Suffix appended to a band when an agent has mastered the dept (e.g. T3B1M). Read by Master Sheet G:M, Department Sheet D, Agents C and H:O. Edit Parameters[D5] to change everywhere. |
| OverrideFlag | =XLOOKUP("Override Flag",Parameters[Name],Parameters[Parameter],"⚑") | Character appended after a manually-overridden role (e.g. T2B1 ⚑). Read by OVERRIDE_CHECK LAMBDA. Edit Parameters[D6] to change. |
| RollupAgent | =_AgentRollupHelper!$A$2# | Spilled list of real agent names. |
| RollupAnswered | =_AgentRollupHelper!$B$2# | Per-agent cross-dept Answered %. Source for Master Sheet N. |
| RollupCompetence | =_AgentRollupHelper!$C$2# | Per-agent cross-dept Competence %. Source for Master Sheet P. |
| RollupRawPoints | =_AgentRollupHelper!$D$2# | Per-agent cross-dept Raw Points. Source for Master Sheet Q. |
| RollupDeviation | =_AgentRollupHelper!$E$2# | Per-agent cross-dept Deviation (STDEV across major-category answer ratios). Source for Master Sheet O. |

---

## 15. Function audit

Functions used across the workbook with their first occurrence and a one-line description.

| Function | Type | First Occurrence | Description |
|---|---|---|---|
| AND | Logical | Master Sheet!D10 | Returns TRUE only if all arguments are TRUE. |
| AVERAGE | Statistical | Master Sheet!Q6 | Arithmetic mean of the numeric values in a range. |
| BYROW | Dynamic Array | Master Sheet!A10 | Applies a LAMBDA to each row of an array, returning a column vector of results. |
| CEILING | Math | Department Sheet!G9 | Rounds a number up to the nearest multiple of a given increment. Used to convert a fractional points-needed into a whole number that, when added, clears the threshold. |
| COLUMN | Lookup/Reference | Master Sheet!A1 | Returns the column number of a reference. |
| COUNTA | Statistical | Data Entry!E4 | Counts non-empty cells in a range. |
| COUNTIF | Statistical | Master Sheet!E34 | Counts cells in a range that meet a single criterion. |
| COUNTIFS | Statistical | Master Sheet!Q8 | Counts cells across one or more ranges that meet multiple criteria. |
| FILTER | Dynamic Array | Master Sheet!Q5 | Returns rows/columns of an array that satisfy a boolean condition. |
| HSTACK | Dynamic Array | _AgentDeptStatsHelper!C2 | Concatenates arrays horizontally. Used to pair Agent and Dept columns for BYROW lookups. |
| IF | Logical | Master Sheet!Q6 | Returns one value if a condition is TRUE, another if FALSE. |
| IFS | Logical | Departments!O3 | Tests multiple conditions in order; returns the value matching the first TRUE. |
| IFERROR | Logical | Master Sheet!Q6 | Returns a fallback value if the wrapped expression evaluates to an error. |
| INDEX | Lookup/Reference | Master Sheet!L10 | Returns a value at a given row/column position in a range. |
| ISBLANK | Information | _AgentDeptStatsHelper!Z12 | Returns TRUE if the referenced cell is empty. |
| ISERROR | Information | Master Sheet!E34 | Returns TRUE if the value is any error type. |
| ISNUMBER | Information | Master Sheet!A10 | Returns TRUE if the value is a number. |
| LAMBDA | Logical/Custom | Master Sheet!A10 | Defines a reusable inline function with named parameters. |
| LEFT | Text | Master Sheet!A10 | Returns the leftmost N characters of a text string. |
| LET | Logical | Master Sheet!A10 | Assigns names to intermediate calculations within a formula. |
| MATCH | Lookup/Reference | Master Sheet!A10 | Returns the relative position of an item in a range. |
| MAX | Statistical | Master Sheet!E34 | Returns the largest numeric value in a set. |
| MAXIFS | Statistical | _AgentDeptStatsHelper!O2 | Maximum among cells specified by one or more criteria. |
| MIN | Statistical | Master Sheet!E34 | Returns the smallest numeric value in a set. |
| MINIFS | Statistical | Department Sheet!G9 | Minimum among cells specified by one or more criteria. |
| MOD | Math | _AgentDeptStatsHelper!B2 | Remainder after division. Used in Cartesian-product spill anchors. |
| OR | Logical | Master Sheet!Q10 | Returns TRUE if any argument is TRUE. |
| REDUCE | Logical | _AgentMasteryHelper!D2 | Walks an array applying an accumulator LAMBDA. Used in cert-chain advancement. |
| ROW | Lookup/Reference | Agents!C27 | Returns the row number of a reference. |
| ROWS | Lookup/Reference | _AgentDeptStatsHelper!A2 | Returns the row count of an array or range. |
| SEARCH | Text | Agents!C27 | Returns the position of a substring within text (case-insensitive). |
| SEQUENCE | Dynamic Array | _AgentDeptStatsHelper!A2 | Generates a sequence of numbers as an array. Used in Cartesian-product spills. |
| STDEV | Statistical | Master Sheet!M10 | Estimates standard deviation based on a sample. |
| SUBSTITUTE | Text | Agents!H3 | Replaces matching text within a string. Used by AGENT_DEPT_QUAL_ROLE to strip " Qualification Role" from the column header to derive the dept name. |
| SUM | Math | Master Sheet!Q7 | Adds all numbers in a range. |
| SUMPRODUCT | Math | Master Sheet!L10 | Multiplies corresponding components of arrays and returns the sum of the products. |
| TEXT | Text | _Roles!L15 | Formats a number as text using a format code. |
| TODAY | Date/Time | Master Sheet!D10 | Returns the current date. |
| TRANSPOSE | Lookup/Reference | Master Sheet!Q5 | Converts a vertical range to horizontal (or vice versa). |
| UNIQUE | Dynamic Array | Master Sheet!Q5 | Returns the distinct values from a range or array. |
| VALUE | Text | _AgentMasteryHelper!D2 | Converts a text representation of a number to a number. |
| XLOOKUP | Lookup/Reference | Master Sheet!B10 | Modern lookup function. |
| ACHIEVED_TIER | Custom (LAMBDA) | _AgentMastery!D2 | See section 6. |
| DEPT_INITIALS | Custom (LAMBDA) | Master Sheet!G10 | See section 6. |
| MASTERY_ENTRY_OK | Custom (LAMBDA) | _AgentDeptTierProgress!O2 | See section 6. |
| OVERRIDE_CHECK | Custom (LAMBDA) | Department Sheet!D9 | See section 6. |
| AGENT_DEPTS | Custom (LAMBDA) | _AgentRollupHelper | See section 6. |
| AGENT_ANSWERED_PCT | Custom (LAMBDA) | _AgentRollupHelper!B2 | See section 6. |
| AGENT_COMPETENCE_PCT | Custom (LAMBDA) | _AgentRollupHelper!C2 | See section 6. |
| AGENT_RAW_POINTS | Custom (LAMBDA) | _AgentRollupHelper!D2 | See section 6. |
| AGENT_DEVIATION | Custom (LAMBDA) | _AgentRollupHelper!E2 | See section 6. |
| AGENT_DEPT_QUAL_ROLE | Custom (LAMBDA) | Agents!H3 | See section 6. Returns the cert-derived qualification role for an agent in a given dept (used by Agents H:O Qualification Role columns). |

---

## 16. Complex calculations explained

### Master Sheet G10:M34 — per-(agent, dept) role display

Looks up qualified band, membership, and mastery flag from AgentStats. Returns blank for non-members; `<DI>-CORE` for members below threshold; `<DI>-<Band>` for qualified; `<DI>-<Band>M` for mastered.

```
=LET(
  agent,   $A10,
  dept,    G$9,
  key,     agent & "|" & dept,
  band,    IFERROR(XLOOKUP(key, StatsKey, StatsQualifiedBand), ""),
  member,  IFERROR(XLOOKUP(key, StatsKey, StatsMembership),    ""),
  mastery, IFERROR(XLOOKUP(key, StatsKey, StatsHasMastery),    FALSE),
  IF(member="", "",
    DEPT_INITIALS(dept) & "-" &
    IF(band="", "CORE", band & IF(mastery, "M", "")))
)
```

### Department Sheet D9:D33 / Agents[Paid Role] — same with override path

Adds an override branch: if a manual role is set in column E (Department Sheet) or `Primary Role Override` (Agents), validate it via OVERRIDE_CHECK and return that with the manual-override flag. Otherwise same logic as Master Sheet.

```
=LET(
  agent,    A9,
  dept,     $A$2,
  override, E9,
  key,      agent & "|" & dept,
  band,     IFERROR(XLOOKUP(key, StatsKey, StatsQualifiedBand), ""),
  member,   IFERROR(XLOOKUP(key, StatsKey, StatsMembership),    ""),
  mastery,  IFERROR(XLOOKUP(key, StatsKey, StatsHasMastery),    FALSE),
  IF(agent="", "",
    IF(override<>"",
      DEPT_INITIALS(dept) & "-" & OVERRIDE_CHECK(override),
      IF(member="", "",
        DEPT_INITIALS(dept) & "-" & IF(band="", "CORE", band & IF(mastery, "M", ""))))))
```

### Department Sheet G9:G33 — Difference to next Role (whole points)

Returns the number of WHOLE POINTS the agent needs to add to their current dept points to reach the threshold for their next role band, capped at the dept's Role Cap Tier. Returns `MAX` once they've passed the cap, `N/A` if the dept doesn't use a Matrix gate (Certs / Certs+Mastery / None), and blank if the dept has no cap (Core).

Inputs:
- `J9` = agent's Total Competence (ratio 0..1) for this sheet's dept
- `K9` = agent's Total Points (whole number)
- `$A$2` = the dept this Department Sheet is set to

Steps:
1. Look up the dept's `Gate Type` and `Cap Tier` from Departments. Bail with `N/A` or blank if not Matrix-gated or no cap.
2. Count the dept's questions in DataEntry — used to convert ratio thresholds into point totals.
3. Find the smallest `Points Threshold` in RoleTarget that is strictly greater than the agent's current competence AND whose tier ID is at or below the dept's cap. That's the next role they could climb to.
4. Convert: `nextThreshold × deptQuestions − currentPoints`. CEILING ensures the returned whole number, when added to current points, *clears* the threshold (avoids off-by-one).
5. If `MINIFS` returns 0, the agent is already past every threshold under the dept cap — return `MAX`.

```
=IF(A9="","",
  LET(
    comp,     J9,
    points,   K9,
    dept,     $A$2,
    gateType, IFERROR(XLOOKUP(dept,Departments[Department Short Name],Departments[Gate Type]),""),
    capTier,  IFERROR(XLOOKUP(dept,Departments[Department Short Name],Departments[Cap Tier]),0),
    deptQ,    COUNTIF(DataEntry[Department],dept),
    IF(gateType<>"Matrix","N/A",
      IF(capTier=0,"",
        LET(
          nextThr, MINIFS(RoleTarget[Points Threshold],
                          RoleTarget[Points Threshold],">"&comp,
                          RoleTarget[Sequential Role ID],"<="&capTier),
          IF(nextThr=0,"MAX",
             CEILING(nextThr*deptQ-points,1)))))))
```

### _AgentDeptStatsHelper — Membership lookup (col C)

Looks up each (agent, dept) cell from the Agents membership block by name (not position). Returns YES, PRIMARY, or blank.

```
=BYROW(HSTACK(A2#, B2#),
  LAMBDA(r,
    LET(
      a, INDEX(r, 1),
      d, INDEX(r, 2),
      v, IFERROR(INDEX(INDEX(Agents, 0, MATCH(d, Agents[#Headers], 0)),
                       MATCH(a, Agents[Agent Name], 0)), ""),
      IF(OR(v="", v=0), "", v))))
```

### _AgentDeptStatsHelper — CertCappedTier (col F)

Caps an agent's cert-derived tier at the dept's role cap. For non-Cert-Driven depts, returns the dept's cap directly (no cert restriction).

```
=BYROW(HSTACK(A2#, B2#),
  LAMBDA(r,
    LET(
      a, INDEX(r, 1),
      d, INDEX(r, 2),
      key, a & "|" & d,
      certDriven, IFERROR(XLOOKUP(d, Departments[Department Short Name], Departments[Cert Driven], TRUE), TRUE),
      IF(NOT(certDriven),
        IFERROR(XLOOKUP(d, Departments[Department Short Name], Departments[Cap Tier]), 0),
        IFERROR(XLOOKUP(key, MasteryKey, MasteryAchievedTier, 0), 0)))))
```

### _AgentDeptStatsHelper — Qualified Band (col O)

The 3-gate decision. MAXIFS finds the highest tier ID where this (agent, dept) row passes all gates in TierProgress; XLOOKUP converts tier ID back to band name.

```
=BYROW(L2#,
  LAMBDA(k,
    LET(
      maxTier, MAXIFS(TPTierID, TPKey, k, TPAllGatesPass, TRUE),
      IF(maxTier=0, "",
        IFERROR(XLOOKUP(maxTier, RoleTarget[Sequential Role ID], RoleTarget[Role]), "")))))
```

### _AgentDeptTierProgress — Per-tier gate columns

Four short formulas, each one logical statement. All Gates Pass is the AND of the four.

```
Cert Gate:      =D2#<=G2#       (Tier ID <= CertCappedTier)
Points Gate:    =BYROW(HSTACK(F2#,H2#,J2#), LAMBDA(r,
                  LET(gt,INDEX(r,1), c,INDEX(r,2), pt,INDEX(r,3),
                      IF(gt="Matrix", c>=pt, TRUE))))
Deviation Gate: =BYROW(HSTACK(F2#,I2#,K2#), LAMBDA(r,
                  LET(gt,INDEX(r,1), d,INDEX(r,2), md,INDEX(r,3),
                      IF(gt="Matrix", d<=md, TRUE))))
Mastery Gate:   =BYROW(HSTACK(F2#,B2#,C2#), LAMBDA(r,
                  LET(gt,INDEX(r,1), a,INDEX(r,2), d,INDEX(r,3),
                      IF(gt="Certs+Mastery", MASTERY_ENTRY_OK(a,d), TRUE))))
All Gates Pass: =(L2#)*(M2#)*(N2#)*(O2#)=1
```

### Master Sheet single-department deviation (Department Sheet I9)

Standard deviation of the agent's competence across all major categories within the active department.

```
=IFERROR(
  LET(
    majors,   UNIQUE(FILTER(DataEntry[Major Category], DataEntry[Department]=$A$2)),
    agentCol, INDEX(DataEntry, 0, MATCH(A9, DataEntry[#Headers], 0)),
    ratios,   BYROW(majors, LAMBDA(m,
                SUMPRODUCT((DataEntry[Department]=$A$2)*(DataEntry[Major Category]=m)*agentCol)
                / SUMPRODUCT((DataEntry[Department]=$A$2)*(DataEntry[Major Category]=m)))),
    STDEV(ratios)),
  "")
```

### Real Agents in Department (Department Sheet A9)

Spilled list of agents in the active department, filtering placeholder names.

```
=LET(
  names,    _AgentNameHelper!B3:B27,
  deptCol,  INDEX(Agents, 0, MATCH($A$2, Agents[#Headers], 0)),
  isReal,   (LEFT(names,6)<>"Column") * (names<>""),
  isInDept, ISNUMBER(MATCH(names, IF((deptCol="YES")+(deptCol="PRIMARY"), Agents[Agent Name]), 0)),
  FILTER(names, isReal*isInDept, ""))
```

---

## 17. Error codes

| Code | Meaning |
|---|---|
| ERR.001 | The date read failed to make a number when checking how many days since the last Matrix update. Check Last Matrix Update has a valid date and the row has a valid name. |
| ERR.002 | Multiple departments are marked PRIMARY for this agent. Each agent must have exactly one PRIMARY in the membership block. |
| ERR.003 | Agent has no PRIMARY department set. Exactly one column in the membership block must contain PRIMARY. |
| ERR.004 | The department name in A2 is not recognized. Check for typos and ensure the dept exists in Departments[Department Short Name]. |
| ERR.005 | The agent name in column A doesn't match any column header in DataEntry. Either add the agent column to DataEntry or correct the name in Agents. |
| ERR.006 | The agent's Qualification Role isn't a valid role name. Check the Qualification Role column on Agents — it must match a value in RoleTarget[Role]. |
| ERR.007 | The Given Role override isn't a recognized role. Check the Role Override column — must match RoleTarget[Role]. |
| ERR.008 | Agent is marked YES (or PRIMARY) for a department but no matching question column exists for them in DataEntry. |
| ERR.009 | A DataEntry row has an unrecognized Department value. Must match Departments[Department Short Name]. |
| ERR.010 | Last Matrix Update date is in the future. |
| ERR.011 | Last Matrix Update is missing for this agent. |
| ERR.012 | The RoleTarget column for this department has no role entries. |
| ERR.013 | A DataEntry row is missing required category data — Master Category and Major Category must both be populated. |
| ERR.014 | The agent's score column in DataEntry contains text or values other than 0/1 where a numeric score is expected. |
| ERR.022 | Failed to generate the average competence, likely division by 0. Check the scores are visible and the total is not 0. |

---

## 18. Known bugs and migration notes

Open bugs at time of writing. Tracked on the _AdvancementPlan sheet.

### BUG-001 — Department Sheet G9:G33 ERR.004

All cells in the Difference to Next Role column returned ERR.004 because the formula did MATCH(deptName, RoleTarget[#Headers]) but RoleTarget headers are Role/Sequential Role ID/Points Threshold/Max Deviation — no dept names. **Fixed:** rewritten to compute the gap in WHOLE POINTS — finds the next role tier above the agent's current competence (within the dept's Cap Tier), then returns CEILING(nextThreshold × deptQuestions − currentPoints). Returns 'MAX' if past dept cap, 'N/A' for non-Matrix depts, blank for depts with no cap. **Status: Fixed.**

### BUG-002 — _RoleElegibilityHelper #REF! cascade

The whole _RoleElegibilityHelper sheet returned #REF! because its formulas referenced _Roles!$G$2:$M$12 which was deleted in earlier cleanup. **Fixed:** all consumers had already been migrated to read Departments[Cap Tier] directly; the sheet was deleted in Priority 1 cleanup. **Status: Fixed/Deleted.**

### BUG-003 — CertTier with M suffix

When the Agents cert column displayed a band with mastery suffix (e.g. T2B1M), the AgentStats CertTier formula returned 0 because XLOOKUP didn't match the M-suffixed text against RoleTarget[Role]. **Fixed** by updating CertTier to strip the trailing M before lookup. Resolved during Phase D½. **Status: Fixed.**

### BUG-004 — TierProgress hardcoded layout

The original TierProgress table had 1,440 rows hardcoded (25 agents x 8 depts x 9 tiers). Adding/removing agents or depts required regenerating the table manually. **Fixed** in Phase D½ refactor: rows now spilled from FILTER(Agents[Agent Name]) x Departments[Department Short Name] x FILTER(RoleTarget[Sequential Role ID]>0). Adding agents or depts auto-expands the table. **Status: Fixed.**

### BUG-005 — Agents H:N hardcoded dept names

The Qualification Role columns (H to N) on Agents have the dept name hardcoded as a literal in each formula's LET (dept,"Helpdesk",...). Adding a new dept means manually adding a column with the literal updated. Low priority — these columns are display-only, not used by the engine. **Status: Open.**

### BUG-006 — Cert Driven magic literal

Departments[Cert Driven] formula was =[@[Department Short Name]]<>"Builds" — a hardcoded exception for Builds. **Fixed** by converting Cert Driven to a user-editable column with a TRUE/FALSE dropdown. Each dept now sets its own Cert Driven flag. **Status: Fixed.**

---

## 19. How to export this sheet to a real Markdown file

1. Select column A on _MDOut (click the column header).
2. Copy.
3. Open a plain-text editor (VS Code, Notepad, Sublime).
4. Paste. Each cell becomes one line. The result is valid Markdown.
5. Save as `skills-matrix-docs.md`.

Some lines start with a leading apostrophe artifact from Excel's text-mode escaping. If you see one in front of a `=` or `#`, delete it.

---

_End of documentation._
