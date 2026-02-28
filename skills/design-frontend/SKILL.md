---
name: design-frontend
description: "Use when building web components, pages, or applications with HTML, CSS, JavaScript, React, Vue, Svelte, or any frontend framework. Triggers on: build a page, create a component, design a UI, landing page, dashboard, settings panel, login page, signup form, pricing page, hero section, card component, navigation, sidebar, modal, frontend, web design, HTML, CSS, styled, Tailwind, web app, website. Ensures distinctive, production-grade output that avoids generic AI aesthetics."
---

# Frontend Design Enhanced

Create distinctive, production-grade frontend interfaces. This skill replaces vague aesthetic guidance with specific, actionable constraints that produce better first-pass output.

## Before Writing Code

Commit to a concrete design spec. Not vibes — specific values.

### 1. Choose an Aesthetic Direction

Pick a specific direction, not "modern and clean." If the first direction that comes to mind feels obvious, deliberately explore alternatives.

See `ref/aesthetic-directions.md` for 20+ directions with concrete characteristics.

### 2. Define Specific Values

Before writing any markup or styles, define these explicitly:

```
Fonts: [display font] + [body font] (NEVER first-instinct defaults)
Palette: [dominant hex] + [accent hex] + [background hex] + [text hex]
Type scale: [base]px @ [ratio] → [computed heading sizes]
Spacing: 8px grid → [which multiples will be used]
Shadows: [# of elevation levels] with [distinct purposes]
```

## Typography

Typography is the single biggest differentiator between professional and amateur design.

### Banned Defaults

Never reach for these as a first choice: Inter, Roboto, Arial, Helvetica, system-ui, Open Sans, Lato, Montserrat, Poppins, Space Grotesk, Nunito.

If a font feels like the "safe choice," it is the wrong choice. Instead, explore distinctive alternatives. See `ref/banned-defaults.md` for specific alternatives organized by character.

### Hierarchy Through Extremes

Subtle differences destroy hierarchy. Use extremes:

| Property | Weak (avoid) | Strong (use) |
|----------|-------------|-------------|
| Weight contrast | 400 vs 600 | 300 vs 800 |
| Size ratio (heading:body) | 1.5x | 3x+ |
| Letter-spacing | Same everywhere | Tight headings (-0.02em), loose labels (0.08em) |
| Case | Title Case only | MIX: uppercase labels, sentence-case body, lowercase nav |

### Font Pairing Strategy

Pair a **distinctive display font** with a **refined body font**. Contrast in character, not conflict:

- Serif display + sans-serif body (classic editorial)
- Geometric display + humanist body (modern warmth)
- Mono display + proportional body (technical edge)
- Slab display + grotesque body (industrial strength)

## Color

### Commit to a Dominant Color

A single dominant color with one sharp accent beats a timid, evenly-distributed palette. Define the hierarchy:

1. **Dominant**: 60% — backgrounds, surfaces
2. **Supporting**: 30% — text, secondary elements
3. **Accent**: 10% — CTAs, active states, key highlights

### Banned Patterns

- Purple/indigo gradient on white (the #1 AI default — Tailwind training data artifact)
- Equal-weight pastels with no dominant
- Gray-on-gray with blue links (corporate default)
- Rainbow gradients (AI tries to be "creative" but lands on chaos)

**Instead**: Lead with one bold choice. Warm earth tones + terracotta accent. Deep navy + gold. Near-black + single neon highlight. Cream paper + ink black.

### Use CSS Variables

Define the full palette in `:root` or CSS variables. Reference variables everywhere — never hardcode hex values in component styles.

## Spacing

### 8px Grid

All margins, padding, gaps, and sizes: multiples of 8 (4px acceptable for tight internal spacing).

| Context | Values |
|---------|--------|
| Icon-to-text gap | 4-8px |
| Form field spacing | 16px |
| Card internal padding | 24px |
| Section gaps | 32-48px |
| Major page sections | 64-80px |

### Whitespace Signals Quality

Generous whitespace signals confidence. Cramped layouts signal amateur work. When in doubt, add more space, not less.

## Shadows & Depth

### Never Uniform Shadows

Same `shadow-md` on every element makes the page flat. Define distinct elevation levels:

| Level | Purpose | Character |
|-------|---------|-----------|
| 0 | Flush (most elements) | No shadow — flat on surface |
| 1 | Subtle lift (cards, inputs) | Barely visible, tight blur |
| 2 | Interactive (buttons, dropdowns) | Medium, noticeable on hover |
| 3 | Floating (popovers, toasts) | Prominent, wide blur |
| 4 | Overlay (modals) | Dramatic, dark scrim |

### Dark Theme Depth

Shadows disappear on dark backgrounds. Use **lighter surface colors** and **subtle borders** to create elevation instead.

## Layout

### Break the Template

Three-card grid + centered hero is the AI default. Instead:

- Asymmetric splits (60/40, 70/30)
- Overlapping elements (image bleeding into next section)
- Full-bleed sections alternating with contained sections
- Grid-breaking hero elements (oversized heading crossing column boundaries)
- Diagonal or angled section dividers
- Staggered card layouts instead of uniform grids

### One Focal Point Per Viewport

Every screenful of content should have exactly one element that dominates attention. If everything is emphasized, nothing is.

## Motion

### Orchestrate, Don't Scatter

One well-timed page load with staggered reveals (using `animation-delay`) creates more impact than identical hover effects on every element.

| Priority | Technique |
|----------|-----------|
| Highest | Staggered entrance on page load |
| High | Scroll-triggered section reveals |
| Medium | Hover states that surprise (scale, color shift, shadow lift) |
| Low | Micro-interactions (toggle, checkbox, loading) |

Prioritize CSS-only solutions. Use Motion library (framer-motion) for React when available.

## Implementation Checklist

Before considering the design complete:

- [ ] No banned fonts used (check `ref/banned-defaults.md`)
- [ ] Color palette has a clear dominant, not evenly distributed
- [ ] Type scale uses mathematical ratio, not arbitrary sizes
- [ ] Weight contrast is 300+ between heading and body
- [ ] Spacing uses 8px grid exclusively
- [ ] Shadow levels are distinct (not same shadow everywhere)
- [ ] Layout has at least one asymmetric or grid-breaking element
- [ ] CSS variables defined for all colors, fonts, spacing
- [ ] At least one orchestrated animation (entrance or scroll)

## References

- **`ref/banned-defaults.md`** — Banned fonts/colors/patterns with specific alternatives
- **`ref/aesthetic-directions.md`** — 20+ aesthetic directions with concrete characteristics
