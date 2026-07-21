# HeroUI-Inspired Button/Card Restyle — Design Spec

> Date: 2026-07-21
> Status: approved for implementation
> Author: collaborative brainstorming (user + agent)

## 1. Problem and goal

The user asked to "connect or use" `github.com/heroui-inc/heroui.git` to improve the
portfolio site's UI. HeroUI is a React + Tailwind component library — this site is a
zero-build-step static HTML/CSS/JS site (`assets/css/style.css` shared by all 6 pages),
so literal adoption (npm, a bundler, React, rewriting every page as a component) was
evaluated and rejected: it would contradict the site's deliberate no-build-tooling
design, and would delay the already-queued Phase 2 (multilingual translation, see
`HANDOFF.md`). Full detail of the three options considered is in the brainstorming
transcript; the user picked the middle path.

**Direction chosen:** borrow HeroUI's *visual/interaction language* — inspected via a
shallow clone of the repo (`packages/styles`, the plain-CSS design-token package
underlying their React components) — and hand-port the relevant parts into the
existing vanilla CSS design system. No new dependency, no build step introduced.

## 2. What HeroUI contributed (reference only, not a dependency)

From `packages/styles/themes/default/variables.css` and
`packages/styles/components/{button,card}.css`:
- OKLCH color tokens with `color-mix()`-calculated hover/pressed/soft variants,
  instead of hand-picked hover colors.
- A real `:active`/pressed state on buttons (`scale(0.97)`), separate from `:hover`.
- A layered (multi-shadow) elevation system for surfaces/cards, distinct from a
  single drop-shadow.
- A secondary/tertiary button tier between primary and ghost.

The site already uses OKLCH tokens, so this is a refinement of an existing pattern,
not a new one.

## 3. What stays the same

- **Radius stays Swiss** — the user explicitly chose to keep `--radius-sm`/`--radius-md`
  unchanged (4px/10px, near-rectangular). HeroUI's pill/`rounded-3xl` look was
  considered and rejected as too large an identity shift away from the
  Swiss/data-forward direction already approved in
  `docs/superpowers/specs/2026-07-08-portfolio-site-design.md`.
- The single teal-toned `--color-accent` brand color, typography, layout (hero,
  about, skills, case-study grid), and the existing `translateY` hover lifts on
  `.btn-primary` and `.case-study-card` are unchanged — this is additive polish, not
  a redesign.
- No framework, no build step, no new dependency. `assets/css/style.css` remains the
  single stylesheet for all 6 pages.

## 4. What changes

### 4.1 New tokens (additive, both `:root` and `:root[data-theme="dark"]`)

```css
--color-accent-hover: color-mix(in oklch, var(--color-accent) 88%, black);
--color-accent-soft: color-mix(in oklch, var(--color-accent) 15%, transparent);
--color-secondary: var(--color-bg-alt);
--color-secondary-hover: color-mix(in oklch, var(--color-bg-alt) 92%, var(--color-text) 8%);
--shadow-card-2: 0 1px 2px oklch(0% 0 0 / .04), 0 4px 10px oklch(0% 0 0 / .05), 0 12px 28px oklch(0% 0 0 / .07);
```

Dark-mode variants mix toward `white` instead of `black` for the hover shade, mirroring
how `--shadow-card`'s dark variant already raises its alpha rather than reusing the
light formula verbatim.

### 4.2 Buttons (`.btn`, `.btn-primary`, `.btn-ghost`, new `.btn-secondary`)

- `.btn` gains a real pressed state: `&:active { transform: scale(0.97); }` — today
  there is no press feedback at all, only a hover lift. This is the one genuine gap
  HeroUI's button.css surfaced.
- `.btn-primary:hover` additionally sets `background: var(--color-accent-hover)` (on
  top of the existing `translateY(-1px)`) — today hover is motion-only, no color
  change.
- New `.btn-secondary`: `background: var(--color-secondary); color: var(--color-text);`
  with `:hover { background: var(--color-secondary-hover); }` — an intermediate
  button tier between `.btn-primary` and `.btn-ghost`, available for future use
  (e.g. a second-priority CTA); not required to be applied anywhere in this pass
  unless the user wants it used immediately (see Task list in the implementation
  plan).
- `.btn-ghost` is unchanged except it also inherits the new base `:active` scale
  from `.btn`.

### 4.3 Cards (`.case-study-card`)

- Swap `--shadow-card` (single layer) for the new `--shadow-card-2` (three layers) on
  `.case-study-card` only. The existing `:hover { transform: translateY(-4px) }` is
  unchanged — only the shadow gets more depth.
- `--shadow-card` itself is left untouched (still used elsewhere, e.g. `.stat`, if
  applicable) to avoid an unreviewed visual change outside the card component.

## 5. Out of scope

- No React, no HeroUI package as an actual dependency, no build step.
- No radius changes (explicit user decision, §3).
- No new color hue — `--color-accent` itself is untouched, only hover/soft
  derivatives are added.
- No changes to typography, layout, spacing scale, or the mobile nav/dark-mode
  toggle JS.
- Filling in placeholder content and Phase 2 (i18n) remain separate, already-queued
  work — this pass is scoped purely to the button/card visual refinement.

## 6. Verification plan

No frontend test suite exists for this static site (consistent with the original
build). Verification is manual, via the local preview server, across all 6 pages
(they share one stylesheet, so one visual pass covers all of them):

1. `.btn-primary` and `.btn-ghost` on `index.html` (hero, contact) and any case-study
   page show the new `:active` press (scale down) on mousedown, in addition to the
   existing hover lift.
2. `.btn-primary:hover` shows a visible color shift (`--color-accent-hover`), not just
   movement.
3. `.case-study-card:hover` shows a visibly deeper/softer shadow than before.
4. Both light and dark mode (toggle via the existing theme switch) look correct —
   no washed-out or overly harsh hover colors in either mode.
5. `prefers-reduced-motion: reduce` still suppresses the transform-based hover/press
   animations (already handled globally in `style.css`; confirm the new rules don't
   bypass it).
6. No console errors, no layout shift, at 320/768/1024/1440px.

## 7. Risks / trade-offs

- **`color-mix()` browser support**: requires a reasonably modern browser (same
  requirement the site already has via its existing OKLCH tokens) — no new
  compatibility risk introduced.
- **`.btn-secondary` may go unused**: it's added as an available tool, not wired into
  any page in this pass, per the "no new gamification/UI *content*" style scoping —
  only apply it somewhere if the user asks for a specific spot in the implementation
  plan review.
