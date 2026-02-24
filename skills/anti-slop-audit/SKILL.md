---
name: anti-slop-audit
description: "Use after generating any visual design, frontend code, or .pen file to check for generic AI defaults. Triggers on: review design, audit design, check design quality, design review, does this look good, is this generic, AI slop, design check, visual QA, before shipping design, review my frontend, check my CSS, quality check, polish, improve design. Catches common AI aesthetic convergence patterns."
---

# Anti-Slop Audit

Post-generation review that catches common AI design defaults. Run this audit after producing any visual design (Pencil .pen files) or frontend code (HTML/CSS/JS).

## How to Audit

For each category below, check the generated output against the criteria. Flag any failures and fix them before considering the design complete.

For Pencil .pen files: use `batch_get` to read node properties, `get_screenshot` for visual verification, and `search_all_unique_properties` for bulk analysis.

For frontend code: read the CSS/styles and analyze values directly.

## Audit Categories

### 1. Typography

| Check | Pass | Fail |
|-------|------|------|
| Font families | Distinctive, characterful choices | Inter, Roboto, Arial, Helvetica, system-ui, Open Sans, Lato, Montserrat, Poppins, Nunito |
| Weight contrast | 300+ difference between heading and body weights | 400 vs 600 (too subtle) |
| Size ratio | Heading is 2.5x+ body size | Heading is < 2x body size |
| Letter-spacing | Varies by context (tight headings, loose labels) | Same letter-spacing everywhere |
| Type scale | Mathematical ratio (1.25, 1.333, 1.5, 1.618) | Arbitrary sizes with no relationship |

### 2. Color

| Check | Pass | Fail |
|-------|------|------|
| Palette structure | Clear dominant (60%), supporting (30%), accent (10%) | Evenly distributed — no clear hierarchy |
| Gradient | Intentional, matches aesthetic | Purple/indigo gradient on white (the #1 AI default) |
| Accent usage | Single sharp accent, used sparingly for emphasis | Multiple competing accent colors |
| Contrast | WCAG AA (4.5:1 normal text, 3:1 large text) | Low contrast, washed out |
| CSS variables | All colors defined as variables, referenced everywhere | Hardcoded hex values scattered in component styles |

### 3. Shadows & Depth

| Check | Pass | Fail |
|-------|------|------|
| Elevation variety | 3-4 distinct shadow levels with different purposes | Same shadow on every element |
| Shadow scale | Increases meaningfully (blur, spread, offset) per level | Uniform `shadow-md` everywhere |
| Dark mode depth | Uses lighter surfaces + borders for elevation | Same shadows on dark bg (invisible) |
| Purposeful use | Shadows indicate interactivity or layering | Decorative shadows with no hierarchy meaning |

### 4. Spacing

| Check | Pass | Fail |
|-------|------|------|
| Grid adherence | All values are 8px multiples (4px for tight) | Arbitrary values (13px, 17px, 22px) |
| Whitespace | Generous — sections breathe, content isn't cramped | Tight, dense, no breathing room |
| Consistency | Same spacing for same contexts throughout | Different padding on similar cards/sections |
| Hierarchy | Section gaps > card gaps > internal gaps | Flat spacing — no spatial hierarchy |

### 5. Layout

| Check | Pass | Fail |
|-------|------|------|
| Template avoidance | At least one asymmetric or unexpected element | Three-card grid + centered hero + footer |
| Focal point | One dominant element per viewport | Everything equal weight — no hierarchy |
| Variety | Mix of layout patterns across sections | Same card grid repeated for every section |
| Grid-breaking | At least one element breaks the grid intentionally | Perfectly aligned grid throughout — feels robotic |

### 6. Motion

| Check | Pass | Fail |
|-------|------|------|
| Entrance | Orchestrated page load (staggered reveals) | No entrance animation — feels static |
| Hover states | At least primary CTAs have meaningful hover | Identical hover on every element OR no hovers |
| Scroll | Content sections animate on scroll entry | All content visible immediately with no scroll interaction |
| Restraint | Motion is purposeful and hierarchical | Every element bounces/fades independently |

### 7. Accessibility

| Check | Pass | Fail |
|-------|------|------|
| Contrast ratios | Meets WCAG AA minimums | Decorative text below 4.5:1 |
| Semantic HTML | Proper heading hierarchy (h1 > h2 > h3) | Div soup — all `<div>` and `<span>` |
| Alt text | Images have descriptive alt text | Missing or generic alt text |
| Focus states | Interactive elements have visible focus | No focus indicators |

## Scoring

Count the checks above. For each category, rate:
- **Pass**: All checks pass
- **Warning**: 1 check fails
- **Fail**: 2+ checks fail

A production-ready design should have zero **Fail** categories and at most one **Warning**.

## Common Fix Patterns

| Problem Found | Quick Fix |
|---------------|-----------|
| Banned font detected | Swap to a distinctive alternative — see `ref/fix-patterns.md` |
| Purple gradient default | Replace with intentional palette matching the aesthetic direction |
| Uniform shadows | Define 3-4 elevation levels, apply by purpose |
| Arbitrary spacing | Snap all values to 8px grid |
| No type scale | Pick a ratio (1.25-1.618), compute sizes from base |
| Three-card template | Introduce asymmetry — stagger, overlap, or vary card sizes |
| Subtle weight contrast | Push heading to 700-900, body to 400 |
| No entrance animation | Add staggered `animation-delay` on page load elements |

## References

- **`ref/fix-patterns.md`** — Detailed fix instructions with code examples for each common problem
