---
name: creating-skills
description: Guides the creation of new AntiGravity skills by enforcing structure standards, metadata requirements, and writing principles for logical and concise instructions.
---

# AntiGravity Skills Creator

This skill provides the mandatory standards and best practices for developing new skills within the AntiGravity ecosystem. Follow these instructions to ensure your skills are effective, consistent, and easily discoverable.

## When to use this skill
- When creating a new Agentic Skill for any project.
- When refactoring existing skills to meet professional standards.
- When documenting specialized workflows or domain knowledge.

## Directory Structure
Every skill should live in its own directory within `.agent/skills/`:
```text
<skill-name>/
  ├── SKILL.md (Mandatory: Core instructions and metadata)
  ├── scripts/ (Optional: Helper scripts and utilities)
  ├── examples/ (Optional: Reference implementations)
  └── resources/ (Optional: Additional files or templates)
```

## Metadata Standards
The `SKILL.md` file MUST start with a YAML frontmatter:
1. **name**: MUST be in gerund form (e.g., `writing-code`, `optimizing-performance`, `managing-tasks`).
2. **description**: MUST be written in the third person. Use specific keywords and phrases that clearly define the skill's trigger conditions.

## Writing Principles
1. **Conciseness**: Only include logic unique to the skill. Do not repeat instructions that the base model already knows (e.g., "how to write a loop").
2. **Progressive Disclosure**: Keep the main `SKILL.md` file under 500 lines. Offload large datasets, long checklists, or complex diagrams to secondary files in `resources/`.
3. **Degrees of Freedom**:
    - Use **Bullet Points** for heuristics (high freedom/creative tasks).
    - Use **Numbered Lists** for rigid workflows (low freedom/procedural tasks).
    - Use **Code Blocks** for templates and fixed structures.

## Workflow Guidelines
Skills should follow a **Plan-Validate-Execute** loop:
1. **Planning**: Use checklists to ensure requirements are understood.
2. **Validation**: Include steps for checking prerequisites and verifying inputs (e.g., using `--help` flags).
3. **Execution**: Provide clear, logical steps for the core task.
4. **Error Handling**: Explicitly guide the agent on what to do when a step fails.
