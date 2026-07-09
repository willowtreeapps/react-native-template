---
name: create-adr
description: 'Create Architecture Decision Records (ADR) in Markdown at docs/adr using sequential filenames like 0001-slug.md. Use when users ask to document a decision, add an ADR, or standardize architecture notes.'
argument-hint: 'ADR title and short decision context'
user-invocable: true
disable-model-invocation: false
---

# Create ADR

Create a single ADR file in `docs/adr/` using a strict short template and sequential numbering.

## When to Use
- User asks to create an ADR.
- User wants to document an architecture or technical decision.
- User wants a consistent ADR filename and format.

## Output Contract
- File path: `docs/adr/<NNNN>-<slug>.md`
- Numbering: zero-padded 4 digits, strictly increasing from existing files
- Body template:

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

## Procedure
1. Gather inputs.
- Required: short ADR title.
- Required: 1-3 sentence summary containing context, decision, and rationale.

2. Ensure destination exists.
- If `docs/adr/` does not exist, create it.

3. Compute next ADR number.
- Read filenames in `docs/adr/` matching `^\d{4}-.*\.md$`.
- Parse numeric prefixes and select `max + 1`.
- If no ADR files exist, use `0001`.

4. Create slug.
- Start from title, lowercase it.
- Replace spaces/underscores with `-`.
- Remove non-alphanumeric/hyphen characters.
- Collapse duplicate hyphens and trim leading/trailing hyphens.
- If slug is empty after normalization, ask user for a clearer title.

5. Build filename.
- Format as `<NNNN>-<slug>.md`.
- If filename already exists unexpectedly, recompute using the next available number.

6. Write ADR content.
- First line must be `# <title>`.
- One blank line.
- Add exactly 1-3 sentences with context, decision, and why.

7. Validate completion.
- File exists at expected path.
- Heading matches title.
- Summary has 1-3 sentences.
- Filename follows `NNNN-slug.md` and numbering is sequential.

## Decision Points
- Missing title or summary: ask user before creating file.
- Existing malformed ADR filenames: ignore malformed files for numbering and continue from valid numeric set.
- Multiple ADRs requested: create one file per decision, incrementing number for each.

## Quality Criteria
- Concise and explicit decision statement.
- Rationale is present, not implied.
- Filename is predictable and sortable.
- No extra sections beyond the short template unless explicitly requested.

## Related Reference
- [ADR short template](./references/adr-short-template.md)
