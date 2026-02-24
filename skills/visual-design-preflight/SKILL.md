---
name: visual-design-preflight
description: "Use BEFORE any Pencil MCP design work in .pen files. Triggers on: design, .pen, pen file, visual design, Pencil, batch_design, create a page, create a screen, design a dashboard, design a landing page, build a layout, mockup, wireframe, UI design, screen design, app design, website design. Ensures design constraints are established before any nodes are inserted."
globs: ["**/*.pen"]
---

# Visual Design Preflight

Establish design constraints before inserting any nodes in a .pen file. This prevents the default-convergence problem where designs come out generic and flat.

<HARD-GATE>
Do NOT call batch_design to insert design nodes until all preflight steps are complete. The only permitted Pencil MCP calls before preflight completion are: get_editor_state, get_guidelines, get_style_guide_tags, get_style_guide, get_variables, set_variables, batch_get (for reading existing components), find_empty_space_on_canvas, and open_document.
</HARD-GATE>

## Preflight Checklist

Complete these steps in order before designing:

### 1. Establish Context

Call `get_editor_state` to understand the current file and selection. If no file is open, call `open_document`.

If the file already has content, call `batch_get` with `reusable: true` to discover existing components and design system elements. Compose from existing components rather than creating from scratch.

### 2. Select a Style Guide

Call `get_style_guide_tags` to see available tags. Select tags matching the project's domain and desired aesthetic. Call `get_style_guide` with those tags.

When selecting tags, choose across multiple dimensions:

| Dimension | Example Tags |
|-----------|-------------|
| Density | minimal, clean, dense, airy |
| Mood | bold, refined, playful, professional |
| Domain | dashboard, landing-page, mobile, webapp |
| Color | dark-mode, light-mode, warm, monochrome |
| Style | editorial, geometric, organic, brutalist |

Commit to a specific aesthetic direction — not "modern and clean" but a precise combination like "editorial + dark-mode + gold-accent" or "organic + warm + light-mode + sage-green".

### 3. Load Relevant Guidelines

Call `get_guidelines` for each applicable topic:

| Topic | When |
|-------|------|
| `landing-page` | Landing pages, marketing pages, product pages |
| `table` | Data tables, list views, admin panels |
| `tailwind` | When generating Tailwind code from the design |
| `code` | When generating any frontend code from the design |

### 4. Set Design Tokens

Call `set_variables` to establish the foundational tokens before any visual work. At minimum, define tokens for colors, typography, spacing, and radius. See `ref/design-tokens-template.md` for the required token categories and suggested values.

The style guide from step 2 provides specific values — translate them directly into variables rather than inventing new ones.

### 5. Define the Design Spec

Before calling batch_design, write out (in a message to the user or internally) the concrete design spec:

```
Aesthetic direction: [specific direction, e.g. "brutalist luxury, dark mode, gold accents"]
Type scale: [base size]px @ [ratio] ratio → [computed sizes]
Spacing grid: 8px multiples → [which values will be used]
Color strategy: [dominant] + [accent] + [semantic]
Shadow levels: [how many distinct elevations, what purpose each serves]
Layout approach: [specific layout pattern, e.g. "sidebar + content" or "full-width sections"]
```

### 6. Verify Placement

Call `find_empty_space_on_canvas` to determine where the new design should go. Avoid overlapping existing work.

## Post-Insertion Verification

After every major section is added via batch_design:

1. Call `get_screenshot` and analyze the result for spacing consistency, alignment, and visual hierarchy
2. Call `snapshot_layout` to catch clipped elements, overlapping nodes, and structural problems
3. Fix issues before proceeding to the next section

## Quick Reference: Common Mistakes

| Mistake | Fix |
|---------|-----|
| Jumping straight to batch_design | Complete all 6 preflight steps first |
| Using vague aesthetic direction | Pick specific tags, not "modern and clean" |
| Skipping set_variables | Always set tokens — they enforce consistency |
| Same shadow on every element | Define 3-4 distinct elevation levels in tokens |
| Never calling get_screenshot | Verify visually after every major section |
| Ignoring existing components | Always batch_get reusable components first |

## References

- **`ref/design-tokens-template.md`** — Required token categories, suggested values, and set_variables format
