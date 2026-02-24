# Fix Patterns

Detailed fix instructions for each common anti-slop audit failure.

## Fix: Banned Font Detected

### Problem
Output uses Inter, Roboto, Arial, or another banned default font.

### Diagnosis
Check all `font-family` declarations in CSS, or `fontFamily` properties in .pen nodes.

### Fix Steps

1. Identify the role of each font usage (display/heading vs body vs mono)
2. Select replacements that match the aesthetic direction:

**For headings/display:**
```css
/* Instead of Inter/Roboto at large sizes */
font-family: 'Clash Display', sans-serif;  /* editorial/bold */
font-family: 'Playfair Display', serif;     /* luxury/classic */
font-family: 'JetBrains Mono', monospace;   /* tech/terminal */
```

**For body text:**
```css
/* Instead of Inter/Roboto at body sizes */
font-family: 'Satoshi', sans-serif;         /* clean/modern */
font-family: 'Outfit', sans-serif;          /* geometric/warm */
font-family: 'General Sans', sans-serif;    /* neutral/refined */
```

3. Update all references — do not mix old and new fonts

### Google Fonts Import

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Clash+Display:wght@400;500;600;700&family=Satoshi:wght@300;400;500;700&display=swap" rel="stylesheet">
```

Note: Some fonts (Clash Display, Satoshi, Cabinet Grotesk) are on Fontshare, not Google Fonts. Use the appropriate CDN.

---

## Fix: Purple Gradient Default

### Problem
Hero section or primary CTA uses purple/indigo gradient — the #1 AI default.

### Fix Steps

1. Identify the aesthetic direction of the project
2. Replace with an intentional palette:

```css
/* REMOVE */
background: linear-gradient(to right, #6366F1, #8B5CF6);

/* REPLACE with intentional choice matching direction */

/* Warm editorial */
background: #1A1A2E;
color: #F5F5F0;

/* Earth organic */
background: linear-gradient(135deg, #2D3A2D, #1A2E1A);

/* Sunset bold */
background: linear-gradient(135deg, #F97316, #EA580C);

/* Arctic clean */
background: #0B1426;
```

3. Update all accent colors to match the new palette

---

## Fix: Uniform Shadows

### Problem
Every card, button, and container has the same `box-shadow`.

### Fix Steps

1. Define a shadow scale in CSS variables:

```css
:root {
  --shadow-xs: 0 1px 2px rgba(0,0,0,0.04);
  --shadow-sm: 0 2px 4px rgba(0,0,0,0.06);
  --shadow-md: 0 4px 12px rgba(0,0,0,0.08);
  --shadow-lg: 0 12px 32px rgba(0,0,0,0.12);
  --shadow-xl: 0 24px 48px rgba(0,0,0,0.16);
}
```

2. Assign by purpose, not by component:

| Element | Level | Reason |
|---------|-------|--------|
| Cards at rest | `--shadow-sm` | Subtle lift |
| Cards on hover | `--shadow-md` | Interactive feedback |
| Buttons | `--shadow-xs` or none | Flush with surface |
| Dropdowns | `--shadow-lg` | Floating above content |
| Modals | `--shadow-xl` | Highest layer |
| Inputs | none or `--shadow-xs` | Inset or flush |

3. Most elements should have NO shadow. Shadow implies elevation — use it sparingly.

---

## Fix: Arbitrary Spacing

### Problem
Spacing values are arbitrary (13px, 17px, 22px) with no grid system.

### Fix Steps

1. Define the spacing scale:

```css
:root {
  --space-1: 0.25rem;  /* 4px */
  --space-2: 0.5rem;   /* 8px */
  --space-3: 0.75rem;  /* 12px */
  --space-4: 1rem;     /* 16px */
  --space-5: 1.5rem;   /* 24px */
  --space-6: 2rem;     /* 32px */
  --space-8: 3rem;     /* 48px */
  --space-10: 4rem;    /* 64px */
  --space-12: 5rem;    /* 80px */
}
```

2. Snap every margin, padding, and gap to the nearest grid value
3. Use the hierarchy: tight (4-8px) for internal, medium (16-24px) for components, generous (48-80px) for sections

---

## Fix: No Type Scale

### Problem
Font sizes are arbitrary with no mathematical relationship.

### Fix Steps

1. Choose a base size and ratio:

```css
:root {
  /* Base: 16px, Ratio: 1.333 (Perfect Fourth) */
  --text-xs: 0.625rem;   /* 10px */
  --text-sm: 0.75rem;    /* 12px */
  --text-base: 1rem;     /* 16px */
  --text-lg: 1.333rem;   /* ~21px */
  --text-xl: 1.777rem;   /* ~28px */
  --text-2xl: 2.369rem;  /* ~38px */
  --text-3xl: 3.157rem;  /* ~50px */
  --text-4xl: 4.209rem;  /* ~67px */
}
```

2. Replace all arbitrary font-size values with scale tokens
3. Pair with line-height: 1.5 for body, tightening to 1.1-1.2 for large headings

---

## Fix: Three-Card Template Layout

### Problem
Layout defaults to the universal AI pattern: centered hero + three equal cards + footer.

### Fix Steps

Pick one or more of these layout-breaking techniques:

**Asymmetric hero:**
```css
.hero {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 0; /* image bleeds to edge */
}
```

**Staggered cards:**
```css
.features {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: var(--space-5);
}
.features > :nth-child(2) {
  transform: translateY(2rem);
}
```

**Alternating full-width:**
```css
.section--wide {
  grid-column: 1 / -1;
  padding: var(--space-10) var(--space-6);
}
.section--contained {
  max-width: 64rem;
  margin: 0 auto;
}
```

**Oversized element breaking grid:**
```css
.hero-heading {
  font-size: var(--text-4xl);
  margin-left: -2rem; /* bleeds past container */
  max-width: 120%; /* wider than parent */
}
```

---

## Fix: Subtle Weight Contrast

### Problem
Heading weight is 600 and body weight is 400. Difference of 200 is invisible at a glance.

### Fix Steps

1. Push headings to 700-900:

```css
h1, h2, h3 { font-weight: 800; }
```

2. Or use thin display fonts at very large sizes:

```css
.hero-heading {
  font-weight: 200;
  font-size: var(--text-4xl);
  letter-spacing: -0.03em;
}
```

3. The key is EXTREME contrast — either very bold or very thin, never medium.

---

## Fix: No Entrance Animation

### Problem
Page loads with all content visible instantly. Feels static and dead.

### Fix Steps

Add staggered entrance animation:

```css
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(1.5rem);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-in {
  animation: fadeInUp 0.6s ease-out both;
}

/* Stagger children */
.animate-in:nth-child(1) { animation-delay: 0ms; }
.animate-in:nth-child(2) { animation-delay: 100ms; }
.animate-in:nth-child(3) { animation-delay: 200ms; }
.animate-in:nth-child(4) { animation-delay: 300ms; }
```

For scroll-triggered reveals, use `IntersectionObserver`:

```js
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('animate-in');
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
```

Prioritize the hero section and first content section. Don't animate everything — that becomes noise.
