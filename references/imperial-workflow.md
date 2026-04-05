# Imperial Workflow

This file presents `instrument-of-state` in the court-process language:

`下旨 -> 太子承旨 -> 锦衣卫侦察 -> 中书省起草 -> 门下省封驳 -> 尚书省发令 -> 六部并行 -> 奏折回呈 -> 礼部宣示`

It is a user-facing mental model layered on top of the constitutional rules. It does not replace `constitutional-rules.md`; it explains the same system in a more stage-oriented way.

Read `imperial-stage-board.md` for the mandatory user-visible stage board shown in each governed response.
Read `team-blueprint-board.md` for the mandatory user-visible team blueprint table shown alongside the stage board.
Read `global-agent-routing.md` for global agent detection and routing from `~/.claude/agents/`.
Read `superpowers-integration.md` for the auxiliary process skills that strengthen the court at specific stages.

## What the plugin does

`instrument-of-state` is a governed execution plugin. It turns a raw user request into:

1. a petition,
2. a memorial,
3. a reviewed order,
4. specialist ministry work,
5. a unified report,
6. and, when needed, an institutional publication in Feishu or Lark.

The system is designed to prevent one unchecked actor from:

- deciding policy,
- approving policy,
- and executing policy

all in the same pass.

## Full process map

### Stage 1. 下旨

- Meaning: the sovereign issues the initial order
- Current executor: the user
- Current entrypoint: `shangshu-dispatch`
- Real system mapping: user request -> petition

What happens:

- the user submits a raw request
- the plugin treats it as a petition, not yet as an executable order
- session state is reset for the new petition

What the next stage waits for:

- a concrete petition from the user

What is produced:

- the initial petition

Technical note:

- `UserPromptSubmit` triggers the guard reset, clearing memorial and execution authority for the new petition

### Stage 2. 太子承旨

- Meaning: the crown-prince intake stage receives the order, classifies it, and decides whether the court machinery must be mobilized
- Current executor: `shangshu-agent`
- Current status: conceptually present, but not yet a separate agent
- Real system mapping: Shangshu prelude and intake discipline

What happens:

- determine whether the task is governed work or a lightweight direct response
- classify mode: `Standard`, `Strict`, or `Emergency`
- decide whether a docket must be opened
- detect whether the task likely needs capability discovery or ministry routing

What the next stage waits for:

- an intake decision
- the operating mode
- a decision on whether planning and reconnaissance are mandatory

What is produced:

- initial case classification
- initial operating mode
- initial route to docket opening and reconnaissance

Optimization status:

- this is a good candidate for a future dedicated `crown-prince-agent`
- right now the function is real, but it is folded into `shangshu-dispatch`

### Stage 3. 锦衣卫侦察

- Meaning: reconnaissance before policy is drafted
- Current executor: `shangshu-agent` using `planning-with-files`, `find-skills`, and `instrument-market.cmd`
- Current status: fully implemented as a capability and evidence stage, but not yet named as a separate court office
- Real system mapping: docket opening + capability ladder + repository reconnaissance

What happens:

- open the docket with `planning-with-files`
- maintain:
  - `task_plan.md`
  - `findings.md`
  - `progress.md`
- inspect repository context and evidence
- query local skills and plugins first
- use `find-skills` if a gap remains
- search approved GitHub marketplaces only after local-first discovery

What the next stage waits for:

- enough evidence to draft a real memorial
- capability findings that say what already exists and what is missing

What is produced:

- a docket
- evidence and findings
- capability shortlist

What is verified later:

- Menxia checks whether planning was skipped
- Menxia checks whether the local-first capability ladder was respected

Optimization status:

- this is an excellent candidate for a future dedicated `jinyiwei-agent`
- the plugin already behaves this way in practice, but the role name is still implicit

### Stage 4. 中书省起草

- Meaning: turn the petition into a lawful memorial
- Current executor: `zhongshu-agent`
- Skill: `zhongshu-draft`
- Real system mapping: memorial drafting authority

What happens:

- read the petition
- absorb docket evidence if present
- turn ambiguity into structure
- specify:
  - objective
  - scope
  - assumptions
  - constraints
  - risks
  - deliverables
  - recommended mode
  - ministry routing
  - capability needs

What the next stage waits for:

- a memorial with the required sections

What is produced:

- the memorial draft

What is validated:

- the guard records Zhongshu as valid only when the output includes:
  - `## Objective`
  - `## Recommended Mode`
  - `## Deliverables`

Technical note:

- Menxia cannot start until Zhongshu has produced a memorial for the current petition

### Stage 5. 门下省封驳

- Meaning: independent review, remonstrance, and legal authority decision
- Current executor: `menxia-agent`
- Skill: `menxia-review`
- Real system mapping: review authority

What happens:

- review the memorial for completeness
- challenge weak assumptions
- check whether planning discipline was followed
- check whether capability acquisition is lawful and proportionate
- decide whether execution should proceed

What the stage waits for:

- a real memorial from Zhongshu

What is produced:

- one verdict only:
  - `APPROVE`
  - `CONDITIONAL`
  - `RETURN`
  - `REJECT`

What is validated:

- the guard blocks Menxia if Zhongshu has not produced a memorial
- the guard records the verdict from Menxia output
- only `APPROVE` creates `works_delivery` authority

Technical consequence:

- `CONDITIONAL`, `RETURN`, and `REJECT` do not unlock file landing

### Stage 6. 尚书省发令

- Meaning: the executive department issues the actual dispatch order
- Current executor: `shangshu-agent`
- Skill: `shangshu-dispatch`
- Real system mapping: central coordination, capability decision, and ministry routing

What happens:

- read the memorial and verdict
- stop cleanly if Menxia returned `RETURN` or `REJECT`
- satisfy or surface conditions if Menxia returned `CONDITIONAL`
- choose the minimum required ministries
- decide whether capability acquisition is still needed
- integrate external capability only if justified
- decide the close-out publication state:
  - `PUBLISH_NOW`
  - `PUBLISH_DOC_ONLY`
  - `PLAN_ONLY`
  - `SKIP_PUBLICATION`

What the next stage waits for:

- a valid review verdict
- any conditions required by Menxia

What is produced:

- the dispatch order
- the ministry routing plan
- the capability decision
- the publication decision

### Stage 7. 六部并行

Not every petition needs all six ministries. Shangshu dispatches the minimum lawful set.

#### 吏部

- Executor: `personnel-routing-agent`
- Skill: `personnel-routing`
- Function:
  - ownership
  - assignees
  - reviewer chains
  - task partitioning
  - GitHub routing
- Waits for:
  - a memorial that shows responsibility ambiguity or decomposition need
- Returns:
  - owner plan
  - reviewer plan
  - partition map

#### 户部

- Executor: `revenue-budgeting-agent`
- Skill: `revenue-budgeting`
- Function:
  - cost
  - time
  - complexity
  - dependency load
  - priority tradeoff
- Waits for:
  - broad, expensive, multi-stream, or high-blast-radius work
- Returns:
  - sizing
  - sequencing
  - scope discipline

#### 礼部

- Executor: `rites-protocol-agent`
- Skills:
  - `rites-protocol`
  - `publish-to-lark`
- Function:
  - artifact format
  - release notes
  - ADR and PR ritual
  - stakeholder communication
  - Feishu or Lark publication
- Waits for:
  - work that needs formal documentation, external handoff, or institutional publication
- Returns:
  - artifact schema
  - communication path
  - publication plan
  - or real publication result

#### 兵部

- Executor: `war-operations-agent`
- Skill: `war-operations`
- Function:
  - incident response
  - stabilization
  - rollback
  - hotfix path
  - CI/CD crisis handling
- Waits for:
  - `Emergency` mode or incident-style work
- Returns:
  - stabilization order
  - severity classification
  - post-action review requirements

#### 刑部

- Executor: `justice-compliance-agent`
- Skill: `justice-compliance`
- Function:
  - evidence requirements
  - test gates
  - reversibility
  - security and compliance boundaries
- Waits for:
  - high-risk, irreversible, production-facing, or strict-mode work
- Returns:
  - acceptance gates
  - audit and test checklist

#### 工部

- Executor: `works-delivery-agent`
- Skill: `works-delivery`
- Function:
  - actual implementation
  - code edits
  - scripts
  - automation
  - deliverable production
- Waits for:
  - Menxia `APPROVE`
  - clear dispatch order

- Returns:
  - concrete delivery result

Technical enforcement:

- only Works Delivery may land governed file changes
- only Works Delivery may use mutating shell commands for governed execution
- if Menxia has not issued `APPROVE`, the guard blocks:
  - spawning `works-delivery-agent`
  - `Write`
  - `Edit`
  - mutating `Bash`

### Stage 8. 奏折回呈

- Meaning: the court returns one unified memorial of what happened
- Current executor: `shangshu-agent`
- Real system mapping: integrated final report

What happens:

- collect ministry outputs
- integrate them into one result
- explain capability actions
- explain publication actions
- report final action and remaining risks

What the stage waits for:

- ministry findings
- delivery result if delivery happened
- publication result if publication was routed

What is produced:

- the unified close-out report to the user

The expected shape is:

1. Memorial draft
2. Review verdict
3. Dispatch order
4. Capability actions
5. Publication actions
6. Ministry findings
7. Final action
8. Open risks

### Stage 9. 礼部宣示

- Meaning: publish the result outward when the court result must leave the chamber
- Current executor: `rites-protocol-agent` through `publish-to-lark`
- Current status: implemented
- Real system mapping: Feishu or Lark document + permission + IM chain

What happens:

- decide whether publication is:
  - `PUBLISH_NOW`
  - `PUBLISH_DOC_ONLY`
  - `PLAN_ONLY`
  - `SKIP_PUBLICATION`
- resolve recipients with `lark-contact`
- create the document with `lark-doc`
- grant permissions with `lark-drive`
- notify with `lark-im`
- place in `lark-wiki` when durable publication is needed

What the stage waits for:

- Shangshu publication decision
- clear recipients or a safe downgrade path
- lawful permissioning

What is produced:

- `doc_id`
- `doc_url`
- permission actions
- IM actions
- wiki placement when applicable

## Which parts already exist and which are still implicit

Already explicit in the plugin:

- 下旨
- 中书省
- 门下省
- 尚书省
- 六部
- 奏折回呈
- 礼部宣示
- hook-enforced authority gates

Conceptually present but still folded into Shangshu:

- 太子承旨
- 锦衣卫侦察

## Stage board and team blueprint requirement

Every governed task should begin with:

1. an Imperial Banner
2. a full Imperial Stage Board
3. a full Team Blueprint table

The stage board should list all stages and all six ministries, showing whether each is:

- `DONE`
- `ACTIVE`
- `WAITING`
- `BLOCKED`
- `SKIPPED`

The team blueprint should list all roles involved in this task with their duties, model, agent type, invocation method, and current status. When global agents from `~/.claude/agents/` are detected and matched, they appear as ministry reinforcements.

That makes both the process and the organization visible to the user instead of leaving the proceeding implicit.

## Superpowers note

The court may be strengthened by the local `superpowers` suite:

- 太子承旨: `brainstorming`
- 锦衣卫侦察: `find-skills`, `systematic-debugging`, `dispatching-parallel-agents`
- 中书省: `writing-plans`
- 尚书省: `dispatching-parallel-agents`, `subagent-driven-development`, `executing-plans`
- 刑部: `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `test-driven-development`
- 工部: `subagent-driven-development`, `executing-plans`, `systematic-debugging`, `verification-before-completion`, `using-git-worktrees`
- 礼部: `finishing-a-development-branch`

These do not replace the court. They strengthen specific offices.

## Best optimization path

If you want this court model to become even sharper, the best next upgrade is:

1. extract `太子承旨` into a dedicated intake stage that owns mode selection and escalation
2. extract `锦衣卫侦察` into a dedicated reconnaissance stage that owns repository evidence and capability search
3. expand the guard state from:
   - memorial drafted
   - Menxia verdict
   - Works Delivery approval

   into:
   - intake complete
   - reconnaissance complete
   - memorial drafted
   - review approved
   - dispatch issued
   - delivery complete
   - publication complete

4. make Shangshu wait on explicit intake and reconnaissance outputs before spawning Zhongshu
5. make Menxia check not only the memorial, but also the reconnaissance dossier

## Practical recommendation

Yes, this optimization is viable.

The best version is not to turn the plugin into historical roleplay. The best version is:

- use `太子` as the intake and escalation office
- use `锦衣卫` as the reconnaissance and evidence office
- keep `三省` as governance and authority
- keep `六部` as specialist execution
- keep `奏折` as the integrated close-out
- keep `礼部宣示` as formal publication

That gives you a stronger mental model without weakening the technical discipline already enforced by the plugin.
