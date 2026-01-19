# PayTo / Instant Direct Debit (IDD) — BA Delivery Portfolio (Jira HORIZON)

This repository showcases an end-to-end **Business Analyst (BA)** delivery simulation for a payments feature: **PayTo-style mandate (agreement) lifecycle** and **Instant Direct Debit (IDD)** initiation with outcomes.
It is structured to mirror real bank delivery: **requirements → functional specs → interface specs → user stories → testing → defect management → SQL validations**, executed in an **Agile** workflow using **Jira Cloud** (project space: **HORIZON**).

> **Note:** Jira boards are usually not publicly accessible. This repo includes **exported Jira artifacts + screenshots** so reviewers can see the backlog, sprint execution, and sample tickets without logging into Jira.

---
<img width="1220" height="910" alt="image" src="https://github.com/user-attachments/assets/03fd24f5-5df6-4ca5-a621-e25ced983bb0" />


## What I built

### Functional scope

* **Mandate (PayTo Agreement) lifecycle**

  * Create mandate
  * Authorize/activate mandate
  * Pause / Cancel mandate
  * Amend mandate (optional)
* **IDD (Instant Direct Debit) payment initiation**

  * Validate debit against mandate terms
  * Accept or reject debits with clear reasons
* **Notifications & outcomes**

  * Emit success/failure outcomes for initiated debits
* **Data validation & reconciliation**

  * SQL checks for mandatory fields, duplicates, invalid states, amount violations, and date rules
* **Testing & defect management**

  * Test plan + test cases
  * Defects captured and triaged (Jira-style)

---

## Tooling

* **Jira Cloud (Atlassian)** — Agile backlog, epics/stories, sprints, and defects (**HORIZON** project space)
* **Confluence / Notion (optional)** — documentation pages (exported here as markdown)
* **Postgres (Neon/Supabase/local)** — lightweight schema + seed data for validation
* **SQL (Structured Query Language)** — backend validation and reconciliation queries
* **Postman** — API examples and mock calls
* **OpenAPI** — API contract specification
* **diagrams.net (draw.io)** — flow diagrams, sequence diagrams, ERD
* **GitHub** — portfolio packaging + evidence

---

## Repository structure

```text
.
├── README.md
├── docs/
│   ├── BRD.md
│   ├── FSD.md
│   ├── ICD.md
│   ├── TestPlan.md
│   └── TraceabilityMatrix.csv
├── diagrams/
│   ├── 01_Context.png
│   ├── 02_ProcessFlow.png
│   ├── 03_Sequence.png
│   └── 04_DataModel.png
├── api/
│   ├── openapi.yaml
│   └── postman_collection.json
├── sql/
│   ├── 01_schema.sql
│   ├── 02_seed_data.sql
│   └── 03_validations.sql
└── evidence/
    ├── jira_timeline.png
    ├── jira_backlog.png
    ├── jira_board.png
    ├── jira_story_example.png
    ├── jira_bug_example.png
    ├── postman_mock_call.png
    ├── sql_validation_output.png
    └── jira_export.csv
```

<img width="1526" height="876" alt="image" src="https://github.com/user-attachments/assets/348d345f-426f-4509-9dee-1dc09372a467" />
<img width="1160" height="710" alt="image" src="https://github.com/user-attachments/assets/3cef5995-f21d-4f6e-b038-3281b36d7ce4" />

---


---

## Jira delivery artifacts (how this maps to real work)

### Epics (example)

* Mandate (PayTo Agreement) Lifecycle
* Payment Initiation (IDD)
* Notifications & Outcomes
* Data Validation & Reconciliation (SQL)
* Testing & Defect Management

### Story template used

* Title + description
* Acceptance criteria (Given/When/Then)
* Assumptions + edge cases
* Dependencies
* Test notes (what QA should validate)

---

## Data model (high level)

Core entities:

* **payer** — person/account owner
* **creditor** — business requesting debit
* **mandate** — PayTo Agreement (authorization rules)
* **debit_request** — a debit initiated under a mandate
* **debit_event** — outcome events (success/failure)

See: `/diagrams/04_DataModel.png` and `/sql/01_schema.sql`

<img width="597" height="1159" alt="DAta model ERD drawio" src="https://github.com/user-attachments/assets/fad4b819-e549-49ff-bdb1-1d5e764c936e" />

---

## Run locally (optional)

You can run the schema and validation queries in any Postgres environment (local Docker, Neon, Supabase, etc.).

### 1) Create schema

Run:

* `/sql/01_schema.sql`

### 2) Load seed data

Run:

* `/sql/02_seed_data.sql`

### 3) Execute validation checks

Run:

* `/sql/03_validations.sql`

Expected results:

* Queries highlight debits that violate mandate rules (e.g., amount > max_amount)
* Queries identify invalid mandate states (e.g., PAUSED/CANCELLED) used for initiation

---

## Key deliverables

* **BRD (Business Requirements Document)**: `/docs/BRD.md`
* **FSD (Functional Specification Document)**: `/docs/FSD.md`
* **ICD (Interface Control Document)**: `/docs/ICD.md`
* **Test Plan + Test Cases strategy**: `/docs/TestPlan.md`
* **Traceability Matrix** (Req → Story → Test): `/docs/TraceabilityMatrix.csv`
* **OpenAPI contract**: `/api/openapi.yaml`
* **SQL validations**: `/sql/03_validations.sql`

---

## Resume-ready summary (copy/paste)

**PayTo / Instant Direct Debit (IDD) — BA Delivery Portfolio (Jira HORIZON)** | Jira Cloud, SQL (Postgres), Postman, OpenAPI, draw.io

* Built an Agile delivery workspace in **Jira Cloud (Atlassian tool for backlog/sprints/defects)** under **HORIZON (project space name)** with epics, user stories, acceptance criteria, and sprint artifacts.
* Produced **FSD (Functional Specification Document)** and **ICD (Interface Control Document)** with request/response field mapping and validation rules for mandate + debit initiation flows.
* Created functional test plan/cases and executed **SQL (Structured Query Language)** validations to verify business rules, detect exceptions, and confirm outcomes.

---

## Next improvements (optional)

* Add idempotency handling for debit initiation (prevent duplicate processing)
* Add audit logging for mandate amendments and debit outcome transitions
* Add a small dashboard (Metabase/Looker Studio) using the same dataset
* Add a short demo video (Loom) walking through Jira → docs → validations

---

## Contact

If you’d like to discuss this project or request the Jira evidence pack structure, feel free to reach out via LinkedIn / email to elifyetistiren@gmail.com
