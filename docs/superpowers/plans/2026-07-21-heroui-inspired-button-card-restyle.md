# HeroUI-Inspired Button/Card Restyle Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add HeroUI-inspired button press/hover feedback and a deeper card shadow to the portfolio site, per `docs/superpowers/specs/2026-07-21-heroui-inspired-button-card-restyle-design.md` — a real `:active` state on buttons (missing today), a `color-mix()`-driven hover color on the primary button, a new `.btn-secondary` variant, and a 3-layer shadow on case-study cards.

**Architecture:** Additive-only edits to the single shared stylesheet, `assets/css/style.css` — no HTML files change, since all 6 pages (`index.html` + 5 `case-studies/*.html`) already link this one file. No new files, no new dependency, no build step. Radius tokens (`--radius-sm`, `--radius-md`) are explicitly NOT touched (user decision, spec §3).

**Tech Stack:** Vanilla CSS (custom properties, `oklch()`, `color-mix()`), no build step, no test runner — same as the existing site.

## Global Constraints

- All file paths below are relative to `C:\Users\Gamer\Music\scm\portfolio-site\` — the repo root, branch `build-site`.
- Only `assets/css/style.css` is modified. No `.html` file changes are needed or in scope.
- Never redefine an existing token name or value (`--color-accent`, `--color-bg-alt`, `--color-text`, `--shadow-card`, `--radius-sm`, `--radius-md`, etc.) — every new token added by this plan is a brand-new name.
- Radius stays unchanged — do not touch `--radius-sm` or `--radius-md` anywhere in this plan.
- Dark-mode token values are duplicated in **two** places in this file today (`:root[data-theme="dark"]` at line ~62, and `@media (prefers-color-scheme: dark) { :root:not([data-theme="light"]) { ... } }` at line ~75) — this is a pre-existing, intentional duplication (see how `--shadow-card` already appears in both). Any new token whose value must differ in dark mode needs to be added to **both** places identically, or it will only apply for one of the two dark-mode trigger methods (manual toggle vs. OS preference).
- No automated test suite exists for this static site (deliberate, matches the original site plan). Verification is manual: a Python one-liner brace-balance check after each CSS edit (fast, catches typos immediately), then a full in-browser pass in the final task.
- Preview server: `mcp__Claude_Browser__preview_start({name: "portfolio"})`, which resolves `C:\Users\Gamer\Music\scm\.claude\launch.json` (the **workspace-root** config, one level above this repo — not `portfolio-site\.claude\launch.json`) and serves this repo at `http://localhost:8000` via `python -m http.server 8000 --directory portfolio-site`. If it fails to start, check that workspace-root file exists with a `"portfolio"` entry before troubleshooting further.
- Commit after every task, from the repo root (`portfolio-site`), on the current branch `build-site`. Do not push (no remote exists for this repo — see `HANDOFF.md`).
- **Line numbers below are for the file as it exists before Task 1 runs.** Task 1 inserts ~19 new lines above the `.btn` block (line 207+) and above `.case-study-card` (line 359+), so by the time Task 2/3 run, the real line numbers will have shifted down by roughly that amount. The **literal "Current" code snippet shown in each step is the authoritative anchor** — locate it by content (e.g. via your editor's search or an exact-match edit tool), not by trusting the stated line number after earlier tasks have already run.

---

### Task 1: Add new CSS tokens (light + both dark-mode blocks)

**Files:**
- Modify: `assets/css/style.css:59` (end of `:root` block)
- Modify: `assets/css/style.css:72` (end of `:root[data-theme="dark"]` block)
- Modify: `assets/css/style.css:86` (end of the `@media (prefers-color-scheme: dark)` nested block)

**Interfaces:**
- Produces: `--color-accent-hover`, `--color-accent-soft`, `--color-secondary`, `--color-secondary-hover`, `--shadow-card-2` — consumed by Task 2 (`.btn-primary`, new `.btn-secondary`) and Task 3 (`.case-study-card`).
- `--color-accent-soft`, `--color-secondary`, and `--color-secondary-hover` are derived entirely from already theme-aware variables (`--color-accent`, `--color-bg-alt`, `--color-text`), so they need **no separate dark-mode declaration** — they resolve correctly in both themes automatically once declared once in `:root`. Only `--color-accent-hover` and `--shadow-card-2` need an explicit dark-mode override (mixing toward `white` instead of `black`, and raising shadow alpha, mirroring how `--shadow-card` itself already differs between light/dark).
- `--color-accent-soft` has no consumer in Tasks 2-3 (same "available, not required to be used yet" status as `.btn-secondary` in Task 2 — it exists so a future soft-tinted element, e.g. a tag or badge, has a ready token instead of inventing one ad hoc). This is intentional, not an oversight — do not remove it for being unused, and do not invent a place to use it that isn't in this plan.

- [ ] **Step 1: Add the base tokens to `:root`**

Current end of the `:root` block (`assets/css/style.css:59-60`):

```css
  --container-max: 1180px;
}
```

Replace with:

```css
  --container-max: 1180px;

  --color-accent-hover: color-mix(in oklch, var(--color-accent) 88%, black);
  --color-accent-soft: color-mix(in oklch, var(--color-accent) 15%, transparent);
  --color-secondary: var(--color-bg-alt);
  --color-secondary-hover: color-mix(in oklch, var(--color-bg-alt) 92%, var(--color-text) 8%);
  --shadow-card-2:
    0 1px 2px oklch(0% 0 0 / 0.04),
    0 4px 10px oklch(0% 0 0 / 0.05),
    0 12px 28px oklch(0% 0 0 / 0.07);
}
```

- [ ] **Step 2: Add the dark-mode override to `:root[data-theme="dark"]`**

Current end of that block (`assets/css/style.css:72-73`):

```css
  --shadow-card: 0 1px 2px oklch(0% 0 0 / 0.3), 0 8px 24px oklch(0% 0 0 / 0.35);
}
```

Replace with:

```css
  --shadow-card: 0 1px 2px oklch(0% 0 0 / 0.3), 0 8px 24px oklch(0% 0 0 / 0.35);
  --color-accent-hover: color-mix(in oklch, var(--color-accent) 88%, white);
  --shadow-card-2:
    0 1px 2px oklch(0% 0 0 / 0.3),
    0 4px 10px oklch(0% 0 0 / 0.32),
    0 12px 28px oklch(0% 0 0 / 0.38);
}
```

- [ ] **Step 3: Add the identical override inside the `@media (prefers-color-scheme: dark)` block**

Current end of that nested block (`assets/css/style.css:86-88`):

```css
    --shadow-card: 0 1px 2px oklch(0% 0 0 / 0.3), 0 8px 24px oklch(0% 0 0 / 0.35);
  }
}
```

Replace with:

```css
    --shadow-card: 0 1px 2px oklch(0% 0 0 / 0.3), 0 8px 24px oklch(0% 0 0 / 0.35);
    --color-accent-hover: color-mix(in oklch, var(--color-accent) 88%, white);
    --shadow-card-2:
      0 1px 2px oklch(0% 0 0 / 0.3),
      0 4px 10px oklch(0% 0 0 / 0.32),
      0 12px 28px oklch(0% 0 0 / 0.38);
  }
}
```

- [ ] **Step 4: Verify the file is well-formed**

No CSS toolchain exists in this repo. Run:

```bash
python -c "s=open('assets/css/style.css').read(); assert s.count('{')==s.count('}'); print('OK', len(s), 'bytes')"
```

Expected: `OK <n> bytes`.

- [ ] **Step 5: Commit**

```bash
git add assets/css/style.css
git commit -m "feat(style): add HeroUI-inspired hover/soft/secondary/shadow tokens"
```

---

### Task 2: Add button press state, primary hover color, and `.btn-secondary`

**Files:**
- Modify: `assets/css/style.css:219` (insert `.btn:active` after the `.btn` base rule)
- Modify: `assets/css/style.css:224` (`.btn-primary:hover`)
- Modify: `assets/css/style.css:230` (insert `.btn-secondary` after `.btn-ghost:hover`)

**Interfaces:**
- Consumes: `--color-accent-hover`, `--color-secondary`, `--color-secondary-hover` from Task 1.
- Produces: `.btn-secondary` class, available for use on any page (not applied to any markup in this plan — the spec leaves it unused unless requested).

**Important ordering note:** `.btn:active` and `.btn-primary:hover` both have specificity `(0,2,0)` (one class + one pseudo-class). When a button is clicked, `:hover` and `:active` are both true simultaneously, and CSS resolves the tie by **source order** — whichever rule appears later in the file wins for any property they both set (`transform`). This plan deliberately places `.btn:active` **after** all three hover rules (`.btn-primary:hover`, `.btn-ghost:hover`, `.btn-secondary:hover`) so the press effect (`scale(0.97)`) always visibly wins over the hover lift while a button is actually being pressed. Do not reorder these rules.

- [ ] **Step 1: Add the primary hover background color**

Current (`assets/css/style.css:224`):

```css
.btn-primary:hover { transform: translateY(-1px); }
```

Replace with:

```css
.btn-primary:hover { transform: translateY(-1px); background: var(--color-accent-hover); }
```

- [ ] **Step 2: Add `.btn-secondary` after the existing `.btn-ghost:hover` rule**

Current (`assets/css/style.css:225-230`):

```css
.btn-ghost {
  background: transparent;
  border-color: var(--color-border);
  color: var(--color-text);
}
.btn-ghost:hover { border-color: var(--color-accent); color: var(--color-accent); }
```

Replace with:

```css
.btn-ghost {
  background: transparent;
  border-color: var(--color-border);
  color: var(--color-text);
}
.btn-ghost:hover { border-color: var(--color-accent); color: var(--color-accent); }
.btn-secondary {
  background: var(--color-secondary);
  color: var(--color-text);
}
.btn-secondary:hover { background: var(--color-secondary-hover); }
```

- [ ] **Step 3: Add the `:active` press state last, after `.btn-secondary:hover`**

Immediately after the `.btn-secondary:hover` rule just added (still before the `/* Hero */` comment), add:

```css
.btn:active { transform: scale(0.97); }
```

The full block from `.btn-ghost` through the new rule should now read, in this exact order:

```css
.btn-ghost {
  background: transparent;
  border-color: var(--color-border);
  color: var(--color-text);
}
.btn-ghost:hover { border-color: var(--color-accent); color: var(--color-accent); }
.btn-secondary {
  background: var(--color-secondary);
  color: var(--color-text);
}
.btn-secondary:hover { background: var(--color-secondary-hover); }
.btn:active { transform: scale(0.97); }
```

- [ ] **Step 4: Verify the file is well-formed**

```bash
python -c "s=open('assets/css/style.css').read(); assert s.count('{')==s.count('}'); print('OK', len(s), 'bytes')"
```

Expected: `OK <n> bytes`.

- [ ] **Step 5: Commit**

```bash
git add assets/css/style.css
git commit -m "feat(style): add button :active press state, primary hover color, and .btn-secondary"
```

---

### Task 3: Upgrade case-study card shadow

**Files:**
- Modify: `assets/css/style.css:367`

**Interfaces:**
- Consumes: `--shadow-card-2` from Task 1.

- [ ] **Step 1: Swap the shadow token**

Current (`assets/css/style.css:359-369`):

```css
.case-study-card {
  display: block;
  text-decoration: none;
  color: var(--color-text);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: var(--shadow-card);
  transition: transform var(--duration-normal) var(--ease-out-expo);
}
```

Replace with:

```css
.case-study-card {
  display: block;
  text-decoration: none;
  color: var(--color-text);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: var(--shadow-card-2);
  transition: transform var(--duration-normal) var(--ease-out-expo);
}
```

Note: `--shadow-card` itself is untouched and still used elsewhere (`.hero-image`, `.case-image`) — only `.case-study-card` switches to the new token, per spec §4.3.

- [ ] **Step 2: Verify the file is well-formed**

```bash
python -c "s=open('assets/css/style.css').read(); assert s.count('{')==s.count('}'); print('OK', len(s), 'bytes')"
```

Expected: `OK <n> bytes`.

- [ ] **Step 3: Commit**

```bash
git add assets/css/style.css
git commit -m "feat(style): upgrade case-study card to layered shadow"
```

---

### Task 4: Full manual verification pass (light/dark, responsive, all 6 pages)

**Files:** none (verification only)

- [ ] **Step 1: Start the preview server**

```
mcp__Claude_Browser__preview_start({name: "portfolio"})
```

Expected: a tab opens at `http://localhost:8000`, serving `index.html`.

- [ ] **Step 2: Verify button states on the home page**

Navigate to `http://localhost:8000/index.html`. Using `read_page` to find the hero's "View case studies" (`.btn-primary`) and "Get in touch" (`.btn-ghost`) buttons, then `computer`:
1. `hover` over `.btn-primary` — confirm it visibly darkens (light mode) or lightens (if dark mode is active) in addition to lifting, via `zoom` screenshot before/after.
2. `left_click` and hold (or use `computer` with a screenshot immediately after mousedown) on `.btn-primary` — confirm it visibly compresses (scale down), not just lifts. This is the one new behavior that didn't exist before this plan — confirm it's actually visible, not just present in the CSS.
3. Repeat the click check on `.btn-ghost` in the contact section — confirm it also shows the press scale (it did not have any active state before).
4. `read_console_messages` — confirm zero errors.

- [ ] **Step 3: Verify the case-study card shadow**

Still on `index.html`, scroll to the case-studies grid. `hover` over any `.case-study-card` and `zoom` on it — confirm the shadow looks visibly deeper/softer than a flat single-layer drop shadow (compare against the flatter `.hero-image` shadow just above it in the same viewport, which intentionally still uses the old `--shadow-card`).

- [ ] **Step 4: Verify dark mode**

Click the theme toggle (`#themeToggle` in the header). Re-run Steps 2-3's checks:
- `.btn-primary` hover should lighten (not darken) — this is the dark-mode-specific `color-mix(..., white)` override from Task 1; confirm it doesn't look muddy or low-contrast.
- The card shadow should still read as a visible, soft dark shadow, not disappear or look identical to `.hero-image`.

Toggle back to light mode when done.

- [ ] **Step 5: Verify on a second page**

Navigate to `http://localhost:8000/case-studies/demand-forecasting.html` (or any one case-study page). Confirm `.btn-ghost`/`.btn-primary` (if present, e.g. the "back" link area or any CTA) and general page load show no console errors and no visual regression. This confirms the single shared stylesheet change propagated correctly without needing per-page edits.

- [ ] **Step 6: Verify responsive breakpoints**

`resize_window` to 320, 768, 1024, and 1440px on `index.html`. At each width, confirm no horizontal overflow and no layout shift introduced by the new styles (the changes are shadow/color/transform only — no size or spacing properties changed, so no layout shift is expected, but confirm visually via screenshot at each width).

- [ ] **Step 7: Verify `prefers-reduced-motion` is still respected**

In Chrome DevTools (via the Rendering tab, or `resize_window`'s underlying browser controls), emulate `prefers-reduced-motion: reduce`. Reload `index.html`. Confirm buttons no longer show the `translateY`/`scale` transitions animating (they may still change instantly) and no other motion (scroll-reveal, nav) breaks. This exercises the site's existing global reduced-motion rule (`assets/css/style.css:12-20`), which this plan does not modify — confirm it still applies to the new rules since they don't add their own transitions outside what `.btn`'s existing `transition` property already covers.

- [ ] **Step 8: Fix any issues found**

If any check fails, fix the specific rule in `assets/css/style.css` (do not introduce new files or classes beyond what Tasks 1-3 defined), re-run the affected check, and commit the fix:

```bash
git add assets/css/style.css
git commit -m "fix(style): <specific issue found during verification>"
```

- [ ] **Step 9: Report back**

Summarize what was verified (button press/hover, card shadow, both themes, 4 breakpoints, reduced-motion) and confirm the branch (`build-site`) is ready for the user's own review. Do not push — this repo has no remote configured (see `HANDOFF.md`).
