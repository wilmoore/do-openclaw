# Product Requirements Document

## 1. Product Thesis

A self-hosted OpenClaw deployment solution for DigitalOcean that enables users to run capable AI agents within a controlled sandbox. The system prioritizes ease of deployment, practical safety boundaries, and sufficient autonomy for meaningful agent work.

## 2. Core Design Principles

1. Safety through containment, not restriction
2. Fast time to first agent execution
3. Transparent system boundaries and permissions
4. Minimal configuration required for initial setup
5. Developer control remains intact at all times
6. Defaults should be safe but extensible
7. Observability is mandatory for trust

## 3. Personas

### P-001 Technical Indie Builder

* Comfortable with cloud infrastructure
* Wants quick deployment and experimentation
* Values flexibility over strict compliance

### P-002 Small Team Engineer

* Needs shared environment for agents
* Requires moderate safety guarantees
* Wants reproducible environments

### P-003 AI Experimenter

* Runs iterative tests on agents
* Needs visibility into agent behavior
* Accepts some risk for capability

## 4. Input Scenarios

* IS-001 User deploys OpenClaw instance on DigitalOcean
* IS-002 User configures sandbox permissions
* IS-003 User launches agent with task prompt
* IS-004 Agent attempts file system access
* IS-005 Agent attempts network request
* IS-006 User inspects logs and actions
* IS-007 User modifies sandbox rules

## 5. User Journeys

### J-001 Initial Deployment

User provisions OpenClaw instance via DigitalOcean and reaches running dashboard

### J-002 Agent Execution

User creates and runs an agent task within sandbox constraints

### J-003 Sandbox Configuration

User reviews and adjusts permissions for filesystem, network, and execution

### J-004 Monitoring and Control

User observes agent activity and intervenes if necessary

## 6. UX Surface Inventory

* S-001 Deployment CLI Interface
* S-002 Web Dashboard Home
* S-003 Agent Execution Panel
* S-004 Sandbox Settings Panel
* S-005 Activity Logs Viewer
* S-006 System Status Panel

## 7. Behavior and Editing Model

* Sandbox enforced at runtime using container isolation
* File system access limited to defined workspace directory
* Network access controlled via allowlist or deny-by-default mode
* Commands executed through controlled runtime wrapper
* User edits configuration via UI or config file
* Changes apply to new agent runs, not retroactively

## 8. Constraints and Anti-Features

### Constraints

* DigitalOcean is primary deployment target
* Web-first interface
* Lean infrastructure footprint
* No enterprise compliance requirements for MVP

### Anti-Features

* No multi-cloud orchestration
* No enterprise RBAC system
* No advanced policy engine
* No native desktop app

## 9. Success and Failure Criteria

### Success

* User deploys system within 15 minutes
* Agent completes meaningful task without sandbox breach
* User can observe and understand agent behavior
* System prevents unauthorized file or network access

### Failure

* Agent escapes sandbox boundaries
* Setup requires advanced infrastructure knowledge
* Logs are insufficient to debug behavior
* Sandbox overly restricts agent utility

## 10. North Star

Percentage of successful agent runs that complete tasks without requiring sandbox override or manual intervention

## 11. Epics

* E-001 [MUST] Deployment System
* E-002 [MUST] Sandbox Runtime
* E-003 [MUST] Agent Execution Engine
* E-004 [MUST] Observability and Logs
* E-005 [SHOULD] Sandbox Configuration UI
* E-006 [COULD] Preset Sandbox Profiles

## 12. User Stories with Acceptance Criteria

### E-001 Deployment System

* US-001 [MUST] As a user, I can deploy OpenClaw via a single command

  * Given a valid DigitalOcean account
  * When I run the deployment command
  * Then infrastructure is provisioned and accessible within 15 minutes

* US-002 [MUST] As a user, I can access a running dashboard

  * Given deployment is complete
  * When I open the provided URL
  * Then I see system status and navigation options

### E-002 Sandbox Runtime

* US-003 [MUST] As a user, I can run agents in isolated environments

  * Given an agent task
  * When the agent executes
  * Then it runs inside a container with restricted permissions

* US-004 [MUST] As a user, I can restrict filesystem access

  * Given sandbox rules
  * When an agent accesses files
  * Then only allowed directories are accessible

* US-005 [MUST] As a user, I can control network access

  * Given network policy is defined
  * When agent attempts external call
  * Then request is allowed or blocked per policy

### E-003 Agent Execution Engine

* US-006 [MUST] As a user, I can submit a task to an agent

  * Given the dashboard
  * When I input a task
  * Then the agent begins execution

* US-007 [MUST] As a user, I can stop an agent mid-execution

  * Given an active agent
  * When I click stop
  * Then execution halts within 5 seconds

### E-004 Observability and Logs

* US-008 [MUST] As a user, I can view agent actions

  * Given an agent run
  * When I open logs
  * Then I see step-by-step actions

* US-009 [MUST] As a user, I can see blocked actions

  * Given sandbox enforcement
  * When an action is denied
  * Then it is logged with reason

### E-005 Sandbox Configuration UI

* US-010 [SHOULD] As a user, I can edit sandbox rules in UI

  * Given settings panel
  * When I modify rules
  * Then new runs follow updated rules

### E-006 Preset Sandbox Profiles

* US-011 [COULD] As a user, I can choose predefined sandbox levels

  * Given profile options
  * When I select one
  * Then rules are applied automatically

## 13. Traceability Map

| Story  | Epic  | Journey | Screen | Priority |
| ------ | ----- | ------- | ------ | -------- |
| US-001 | E-001 | J-001   | S-001  | MUST     |
| US-002 | E-001 | J-001   | S-002  | MUST     |
| US-003 | E-002 | J-002   | S-003  | MUST     |
| US-004 | E-002 | J-003   | S-004  | MUST     |
| US-005 | E-002 | J-003   | S-004  | MUST     |
| US-006 | E-003 | J-002   | S-003  | MUST     |
| US-007 | E-003 | J-004   | S-003  | MUST     |
| US-008 | E-004 | J-004   | S-005  | MUST     |
| US-009 | E-004 | J-004   | S-005  | MUST     |
| US-010 | E-005 | J-003   | S-004  | SHOULD   |
| US-011 | E-006 | J-003   | S-004  | COULD    |

## 14. Lo-fi UI Mockups (ASCII)

### S-001 Deployment CLI Interface

Purpose: Deploy system
Actions: Run command
States: idle, running, success, error

```
> openclaw deploy

[ Running... ]
Provisioning resources...

[ Success ]
URL: http://xxx
```

### S-002 Web Dashboard Home

Purpose: Overview
Actions: Navigate

```
+----------------------+
| OpenClaw Dashboard   |
+----------------------+
| Status: Running      |
| Agents Active: 1     |
|                      |
| [Run Agent]          |
| [Settings]           |
| [Logs]               |
+----------------------+
```

### S-003 Agent Execution Panel

Purpose: Run agents
Actions: Start, Stop

```
+----------------------+
| Agent Execution      |
+----------------------+
| Task: [__________]   |
|                      |
| [Run] [Stop]         |
|                      |
| Status: Running      |
+----------------------+
```

### S-004 Sandbox Settings Panel

Purpose: Configure rules
Actions: Edit

```
+--------------------------+
| Sandbox Settings         |
+--------------------------+
| FS Access: /workspace    |
| Network: Restricted      |
|                          |
| [Edit Rules]             |
| [Save]                   |
+--------------------------+
```

### S-005 Activity Logs Viewer

Purpose: Observability
Actions: Inspect

```
+--------------------------+
| Logs                     |
+--------------------------+
| Step 1: Read file        |
| Step 2: HTTP blocked     |
| Step 3: Write output     |
+--------------------------+
```

### S-006 System Status Panel

Purpose: Health view
Actions: Refresh

```
+--------------------------+
| System Status            |
+--------------------------+
| CPU: Normal              |
| Memory: Normal           |
| Containers: Running      |
+--------------------------+
```

## 15. Decision Log

### D-001 Sandbox Isolation Method

Options: Container, VM, Process isolation
Winner: Container
Confidence: 0.82

### D-002 Network Policy Default

Options: Allow all, Deny all, Allowlist
Winner: Allowlist
Confidence: 0.78

### D-003 Deployment Method

Options: CLI, UI, Terraform
Winner: CLI
Confidence: 0.80

### D-004 Observability Depth

Options: Minimal, Standard, Full trace
Winner: Standard
Confidence: 0.76

### D-005 Sandbox Config Method

Options: UI, Config file, Both
Winner: Both
Confidence: 0.81

### D-006 Preset Profiles Inclusion

Options: Yes, No
Winner: Yes
Confidence: 0.65 (Review Suggested)

## 16. Assumptions

* Users have basic familiarity with DigitalOcean
* OpenClaw core engine exists and is functional
* Container runtime available on deployment target
* Logs do not require external aggregation for MVP
* Security is best-effort within practical limits, not formally verified
* Single-node deployment is sufficient for MVP

---

> **This PRD is complete.**
> Copy this Markdown into Word, Google Docs, Notion, or directly into a coding model.