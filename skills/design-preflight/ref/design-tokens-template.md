# Design Tokens Template

Required token categories to set via `set_variables` before designing. Adapt specific values from the chosen style guide.

## Color Tokens

### Core Surfaces

| Token | Purpose | Example (Dark) | Example (Light) |
|-------|---------|----------------|-----------------|
| `--background` | Page background | `#0A0A0A` | `#FAFAF9` |
| `--surface` | Card/panel background | `#141414` | `#FFFFFF` |
| `--surface-elevated` | Modal/popover background | `#1A1A1A` | `#FFFFFF` |
| `--border` | Default borders | `#262626` | `#E4E4E7` |
| `--border-subtle` | Subtle separators | `#1A1A1A` | `#F0F0F0` |

### Text

| Token | Purpose | Example (Dark) | Example (Light) |
|-------|---------|----------------|-----------------|
| `--text-primary` | Headings, emphasis | `#FAFAFA` | `#0A0A0A` |
| `--text-secondary` | Body text | `#A1A1AA` | `#52525B` |
| `--text-muted` | Labels, captions | `#71717A` | `#A1A1AA` |

### Brand / Accent

| Token | Purpose | Notes |
|-------|---------|-------|
| `--primary` | Primary actions, links | Dominant color — commit to one |
| `--primary-foreground` | Text on primary | Ensure WCAG AA contrast (4.5:1+) |
| `--accent` | Secondary emphasis | Sharp accent — not a tint of primary |

### Semantic

| Token | Purpose | Suggested |
|-------|---------|-----------|
| `--success` | Positive states | Green family |
| `--warning` | Caution states | Amber/orange family |
| `--error` | Error states | Red family |
| `--info` | Informational | Blue family |

## Typography Tokens

### Font Families

| Token | Purpose | Notes |
|-------|---------|-------|
| `--font-display` | Headings, hero text | Distinctive, characterful — NEVER Inter/Roboto/Arial |
| `--font-body` | Body text, UI labels | Refined, readable — pair with display font |
| `--font-mono` | Code, data, tabular | Monospace with good numeral alignment |

### Type Scale

Use a mathematical ratio from a base size. Common ratios:

| Ratio | Name | Character |
|-------|------|-----------|
| 1.200 | Minor Third | Compact, dense UIs |
| 1.250 | Major Third | Balanced, general use |
| 1.333 | Perfect Fourth | Clear hierarchy, dashboards |
| 1.500 | Perfect Fifth | Dramatic, editorial |
| 1.618 | Golden Ratio | Maximum drama, landing pages |

Example with 16px base @ 1.333 (Perfect Fourth):

| Token | Value | Use |
|-------|-------|-----|
| `--text-xs` | 10px | Fine print, badges |
| `--text-sm` | 12px | Captions, labels |
| `--text-base` | 16px | Body text |
| `--text-lg` | 21px | Subheadings |
| `--text-xl` | 28px | Section headings |
| `--text-2xl` | 38px | Page headings |
| `--text-3xl` | 50px | Hero text |

### Weight Contrast

Use extreme weight contrast for hierarchy — not 400 vs 600 (too subtle).

| Use | Weight | Notes |
|-----|--------|-------|
| Body | 400 (regular) | Standard reading weight |
| Labels/emphasis | 500-600 (medium/semibold) | Midrange for UI elements |
| Headings | 700-900 (bold/black) | Maximum contrast with body |
| Display/decorative | 100-300 (thin/light) | Large sizes only, for elegance |

## Spacing Tokens

All values must be multiples of 8px.

| Token | Value | Use |
|-------|-------|-----|
| `--space-1` | 4px | Tight internal (icon-to-text) |
| `--space-2` | 8px | Compact gaps, small padding |
| `--space-3` | 12px | Default internal padding |
| `--space-4` | 16px | Standard gap, form field spacing |
| `--space-5` | 24px | Card padding, section gaps |
| `--space-6` | 32px | Major section padding |
| `--space-8` | 48px | Section vertical spacing |
| `--space-10` | 64px | Page-level section breaks |
| `--space-12` | 80px | Hero padding, major breaks |

Note: 4px and 12px are acceptable half-grid values for tight UI.

## Shadow / Elevation Tokens

Define 3-4 distinct elevation levels. Each level should feel meaningfully different.

| Token | Use | Example |
|-------|-----|---------|
| `--shadow-sm` | Subtle lift (cards, inputs) | `0 1px 2px rgba(0,0,0,0.05)` |
| `--shadow-md` | Interactive elements (buttons, dropdowns) | `0 4px 8px rgba(0,0,0,0.1)` |
| `--shadow-lg` | Floating elements (popovers, toasts) | `0 12px 24px rgba(0,0,0,0.15)` |
| `--shadow-xl` | Overlays (modals, dialogs) | `0 24px 48px rgba(0,0,0,0.2)` |

For dark themes, shadows are less visible — use border + subtle background shifts instead for elevation cues.

## Radius Tokens

| Token | Value | Use |
|-------|-------|-----|
| `--radius-none` | 0px | Brutalist, sharp styles |
| `--radius-sm` | 4px | Subtle rounding (inputs, badges) |
| `--radius-md` | 8px | Default rounding (cards, buttons) |
| `--radius-lg` | 12-16px | Prominent rounding (panels, containers) |
| `--radius-full` | 9999px | Pills, avatars, circular elements |

Commit to a rounding strategy: either sharp (0-4px), moderate (6-8px), or soft (12-16px). Mixing arbitrarily destroys cohesion.

## set_variables Call Format

```
set_variables({
  variables: {
    "--background": "#0A0A0A",
    "--surface": "#141414",
    "--primary": "#E94560",
    "--text-primary": "#FAFAFA",
    "--text-secondary": "#A1A1AA",
    "--font-display": "Playfair Display",
    "--font-body": "Manrope",
    "--radius-md": "8"
  }
})
```

Translate the style guide values directly. Do not invent new values that deviate from the selected style guide.
