# Banned Defaults & Alternatives

## Banned Font Families

These fonts are the statistical average of AI training data. Using them signals "generated, not designed."

### Sans-Serif (Banned → Alternatives)

| Banned | Why | Alternatives by Character |
|--------|-----|--------------------------|
| Inter | #1 AI default, ubiquitous | **Satoshi** (geometric), **General Sans** (neutral+), **Switzer** (clean) |
| Roboto | Google default, everywhere | **Plus Jakarta Sans** (friendly), **Outfit** (geometric), **Figtree** (warm) |
| Open Sans | Safe corporate fallback | **Source Sans 3** (refined), **Nunito Sans** (softer), **Karla** (quirky) |
| Lato | Overexposed | **Sora** (modern geometric), **Albert Sans** (Swiss), **Urbanist** (contemporary) |
| Montserrat | Was distinctive, now generic | **Clash Display** (editorial), **Cabinet Grotesk** (bold), **Epilogue** (sharp) |
| Poppins | Rounded generic | **DM Sans** (geometric), **Lexend** (legibility), **Quicksand** (organic) |
| Space Grotesk | AI favorite convergence | **JetBrains Mono** (tech), **Azeret Mono** (display), **Commit Mono** (clean) |
| Nunito | Rounded, forgettable | **Wotfard** (characterful), **Red Hat Display** (distinctive), **Rethink Sans** (fresh) |

### Serif (Alternatives for Editorial/Luxury)

| Character | Fonts |
|-----------|-------|
| Classic editorial | **Playfair Display**, **Cormorant**, **Libre Baskerville** |
| Modern serif | **DM Serif Display**, **Fraunces**, **Newsreader** |
| Sharp/angular | **Bodoni Moda**, **Noto Serif Display**, **Young Serif** |
| Warm/friendly | **Lora**, **Merriweather**, **Cardo** |
| Display/impact | **Abril Fatface**, **Yeseva One**, **Rozha One** |

### Monospace (for tech/data aesthetics)

| Character | Fonts |
|-----------|-------|
| Modern | **JetBrains Mono**, **Fira Code**, **Cascadia Code** |
| Classic | **IBM Plex Mono**, **Source Code Pro** |
| Distinctive | **Commit Mono**, **Monaspace**, **Berkeley Mono** |

## Banned Color Patterns

### The Purple Gradient Problem

The #1 AI design default: purple/indigo gradient (`bg-indigo-500` → `bg-purple-600`) on white. This is a direct artifact of Tailwind CSS training data dominance.

**Banned combinations:**
- `#6366F1` → `#8B5CF6` (indigo to purple gradient)
- `#7C3AED` → `#A855F7` (violet gradient)
- Any purple gradient as hero background on white
- Blue-purple gradient as primary CTA color

### Instead: Intentional Palettes

| Direction | Dominant | Accent | Background |
|-----------|----------|--------|------------|
| Warm editorial | `#1A1A2E` (deep navy) | `#E94560` (coral) | `#F5F5F0` (warm paper) |
| Earth organic | `#2D3A2D` (forest) | `#D89575` (terracotta) | `#F5F4F1` (cream) |
| Night luxury | `#0F0F0F` (near-black) | `#C9A962` (champagne gold) | `#0F0F0F` (same) |
| Arctic clean | `#0B1426` (midnight) | `#38BDF8` (sky blue) | `#F8FAFC` (snow) |
| Sunset bold | `#1C1917` (stone black) | `#F97316` (orange) | `#FFF7ED` (peach) |
| Sage calm | `#1A2E1A` (dark sage) | `#3D8A5A` (forest green) | `#F0F5F0` (mint) |
| Industrial | `#18181B` (zinc) | `#EF4444` (red) | `#FAFAFA` (white) |
| Candy pop | `#FDF2F8` (pink mist) | `#EC4899` (hot pink) | `#FFFFFF` (white) |

### Banned Shadow Pattern

**Uniform shadow**: Same `box-shadow: 0 4px 6px rgba(0,0,0,0.1)` on every card, button, and container.

**Instead**: Define 4 levels with distinct character:

```css
--shadow-xs: 0 1px 2px rgba(0,0,0,0.04);          /* inputs, badges */
--shadow-sm: 0 2px 4px rgba(0,0,0,0.06);           /* cards at rest */
--shadow-md: 0 4px 12px rgba(0,0,0,0.08);          /* buttons, hover states */
--shadow-lg: 0 12px 32px rgba(0,0,0,0.12);         /* dropdowns, popovers */
--shadow-xl: 0 24px 48px rgba(0,0,0,0.16);         /* modals, overlays */
```

### Banned Layout Patterns

| Pattern | Why Banned | Alternative |
|---------|-----------|-------------|
| Three equal cards in a row | The universal AI layout | Stagger sizes (1 large + 2 small), overlap, or vary heights |
| Centered hero + subtitle + CTA button | Every AI landing page | Asymmetric hero (text left, visual right bleeding edge) |
| Equal-height feature grid | Feels generated | Masonry, staggered, or alternating full-width + grid |
| Perfectly symmetrical everything | No tension, no interest | Introduce one deliberate asymmetry per section |
