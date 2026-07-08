# Portfolio Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the static freelance portfolio site described in `docs/superpowers/specs/2026-07-08-portfolio-site-design.md` — a home page plus four Linchpin case-study pages, styled with a Swiss/data-forward design system, plus a matching Upwork content package.

**Architecture:** Plain HTML/CSS/vanilla JS, no build step, no framework. One shared stylesheet and one shared script, included by five HTML pages that repeat an identical header/footer block. Every number shown is a real, reproducible output pulled from `supply-chain-optimization/case-studies/CASE_STUDIES.md` or `supply-chain-optimization/deliverables/portfolio/report.md` — never a fabricated client result.

**Tech Stack:** HTML5, CSS3 (custom properties, oklch colors), vanilla JS (ES2017+, no dependencies), Python's built-in `http.server` for local preview, Git.

## Global Constraints

- All file paths below are relative to `C:\Users\Gamer\Music\scm\portfolio-site\` — the repo root. It is already git-initialized with one commit (the design spec).
- No build step, no framework, no bundler, no npm dependency of any kind.
- No fabricated results or testimonials. Every stat shown must trace back to `supply-chain-optimization/case-studies/CASE_STUDIES.md` or `supply-chain-optimization/deliverables/portfolio/report.md`.
- User-specific unknowns (name, bio, years of experience, education, LinkedIn/Upwork URLs, email) are marked with visible `[PLACEHOLDER: ...]` text and/or the `.placeholder` CSS class, never silently invented.
- All internal links use relative paths (`case-studies/x.html`, `../index.html#about`), never root-absolute paths — the eventual GitHub Pages URL shape (user site vs. project subpath) isn't decided yet.
- Max two font families, system-font-first — no external font network request.
- Both light and dark mode must render correctly (`prefers-color-scheme` + manual `data-theme` override). Motion must respect `prefers-reduced-motion`.
- Responsive breakpoints to verify: 320 / 768 / 1024 / 1440.
- No automated test suite — this is a deliberate scope decision from the spec (5 static pages, no business logic). Verification is done by loading pages in the browser preview tool and checking rendered output, console errors, and network requests.
- Do NOT create a GitHub repository or run `git push` to any remote — deployment is a separate, later approval gate (spec §9), out of scope for this plan.
- Real screenshots already exist in the sibling `supply-chain-optimization` repo (confirmed dimensions): `resultado-dashboard.png` (1440×900, at `C:\Users\Gamer\Music\scm\resultado-dashboard.png`), `scm-agent-console.png` (1240×680), `dashboard-forecast.png` (1380×860), `dashboard-detail.png` (1380×860), `dashboard-portfolio.png` (1380×860) — the last four under `C:\Users\Gamer\Music\scm\supply-chain-optimization\docs\assets\`.
- Verified source numbers used throughout: EOQ example D=1000/yr, k=€50/order, h=€1.75/unit/yr → Q*≈239, C*≈€418 (`CASE_STUDIES.md` Exercise 1). Safety stock example μ=100, σ=25, α=95% → safety stock≈41, reorder point≈141 (`CASE_STUDIES.md` Exercise 2). Multi-echelon GSM example lead times [4,3,2], μ=100, σ=25, review periods [1,2,4], 95% service level → risk periods (4,0,6), holding cost≈€485 (`CASE_STUDIES.md` Exercise 6). Portfolio benchmark: 75 datasets, 34,498 SKUs, $33,474,731 aggregate inventory value, 383s runtime (`deliverables/portfolio/report.md`). Tool/test counts: "35+ agent-routable tools", "1,100+ tests", "24 SCM textbooks" (`supply-chain-optimization/README.md` / `CLAUDE.md`).
- Preview tooling: every task that produces a browsable page verifies it via the `mcp__Claude_Preview__*` tools, backed by `.claude/launch.json` (created in Task 1), which serves the site with `python -m http.server 8000`.

---

### Task 1: Project scaffold, design tokens, and preview config

**Files:**
- Create: `.gitignore`
- Create: `.claude/launch.json`
- Create: `README.md`
- Create: `assets/css/style.css`
- Test: none (static config + CSS; verified via grep, see Step 4)

**Interfaces:**
- Produces: every CSS custom property and component class consumed by all later HTML files — `--color-bg`, `--color-bg-alt`, `--color-surface`, `--color-text`, `--color-text-muted`, `--color-border`, `--color-accent`, `--color-accent-contrast`, `--color-placeholder`, `--font-sans`, `--font-mono`, `--text-xs/sm/base/lg/xl/display/stat`, `--space-1..6`, `--space-section`, `--radius-sm/md`, `--shadow-card`, `--duration-fast/normal`, `--ease-out-expo`, `--container-max`. Component classes: `.container`, `.skip-link`, `.site-header`, `.nav`, `.brand`, `.nav-toggle`, `.nav-links`, `.theme-toggle`, `.btn`/`.btn-primary`/`.btn-ghost`, `.hero`/`.hero-grid`/`.hero-kicker`/`.hero-lede`/`.hero-actions`/`.hero-image`, `.stat-grid`/`.stat`/`.stat-number`/`.stat-label`, `.section`/`.section-kicker`/`.section-title`/`.section-lede`, `.about-body`, `.tag-list`/`.tag`, `.case-study-grid`/`.case-study-card`/`.card-link`, `.placeholder`/`.placeholder-block`, `.contact-actions`, `.site-footer`/`.footer-inner`/`.footer-links`, `.back-link`, `.case-hero`/`.case-kicker`/`.case-summary`/`.case-image`, `.case-section`, `.case-result`/`.case-note`, `.reveal`/`.is-visible`.
- Produces: a `.claude/launch.json` server named `"portfolio"` on port 8000, used by `mcp__Claude_Preview__preview_start` in every later verification step.

- [ ] **Step 1: Create `.gitignore`**

```
.DS_Store
Thumbs.db
*.log
.claude/settings.local.json
```

- [ ] **Step 2: Create `.claude/launch.json`**

```json
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "portfolio",
      "runtimeExecutable": "python",
      "runtimeArgs": ["-m", "http.server", "8000"],
      "port": 8000
    }
  ]
}
```

- [ ] **Step 3: Create `README.md`**

```markdown
# Portfolio Site

A static personal portfolio for freelance inventory/supply-chain optimization
work, built to support job search on Upwork. Flagship project: **Linchpin**
(`../supply-chain-optimization`), presented as four case studies.

## Structure

- `index.html` — home page (hero, about, skills, case-study index, contact)
- `case-studies/*.html` — one page per case study, independently linkable
- `assets/css/style.css` — design tokens + all component styles
- `assets/js/main.js` — nav toggle, dark-mode toggle, scroll-reveal
- `assets/img/` — screenshots reused from the Linchpin repo
- `upwork/profile-content.md` — copy-paste content for your Upwork profile

## Before publishing

Search for `[PLACEHOLDER:` and the `.placeholder` CSS class (dashed
underline) across every HTML file and fill in:
- Your name (site title, header brand, footer, about section)
- Your bio, years of experience, background, education/certifications
- Your email, LinkedIn URL, and Upwork profile URL
- The final site URL in `upwork/profile-content.md`

## Local preview

No build step — open `index.html` directly in a browser, or serve the folder
with any static file server, e.g.:

\`\`\`bash
python -m http.server 8000
\`\`\`

Then visit `http://localhost:8000`.

## Deploying to GitHub Pages

1. Create a new **public** GitHub repository (GitHub Pages on the free tier
   requires a public repo unless you have GitHub Pro/Team).
2. Push this folder to the `main` branch of that repository.
3. In the repo's Settings → Pages, set the source to deploy from `main` /
   `/ (root)`.
4. GitHub Pages will publish the site at `https://<username>.github.io/<repo>/`
   (or `https://<username>.github.io/` if the repo is named exactly
   `<username>.github.io`).

All internal links use relative paths, so the site works correctly under
either URL shape.
```

- [ ] **Step 4: Create `assets/css/style.css`**

```css
/* Reset */
*, *::before, *::after { box-sizing: border-box; }
html, body, h1, h2, h3, h4, p, figure, blockquote, dl, dd { margin: 0; }
ul[class], ol[class] { list-style: none; padding: 0; margin: 0; }
html { scroll-behavior: smooth; }
body { min-height: 100vh; -webkit-font-smoothing: antialiased; }
img, picture { max-width: 100%; display: block; }
input, button, textarea, select { font: inherit; }
a { color: inherit; }
code { font-family: var(--font-mono); }

@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* Tokens */
:root {
  --color-bg: oklch(98% 0.005 90);
  --color-bg-alt: oklch(95% 0.006 90);
  --color-surface: oklch(100% 0 0);
  --color-text: oklch(20% 0.01 260);
  --color-text-muted: oklch(45% 0.01 260);
  --color-border: oklch(90% 0.006 90);
  --color-accent: oklch(52% 0.16 250);
  --color-accent-contrast: oklch(99% 0 0);
  --color-placeholder: oklch(58% 0.15 40);

  --font-sans: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  --font-mono: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;

  --text-xs: 0.8125rem;
  --text-sm: 0.9375rem;
  --text-base: clamp(1rem, 0.95rem + 0.3vw, 1.0625rem);
  --text-lg: clamp(1.125rem, 1.05rem + 0.4vw, 1.375rem);
  --text-xl: clamp(1.5rem, 1.3rem + 1vw, 2rem);
  --text-display: clamp(2.25rem, 1.6rem + 3vw, 4.25rem);
  --text-stat: clamp(1.875rem, 1.5rem + 1.6vw, 2.75rem);

  --space-1: 0.5rem;
  --space-2: 0.75rem;
  --space-3: 1rem;
  --space-4: 1.5rem;
  --space-5: 2.5rem;
  --space-6: 4rem;
  --space-section: clamp(4rem, 3rem + 4vw, 7rem);

  --radius-sm: 4px;
  --radius-md: 10px;
  --shadow-card: 0 1px 2px oklch(0% 0 0 / 0.04), 0 8px 24px oklch(0% 0 0 / 0.06);
  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --container-max: 1180px;
}

:root[data-theme="dark"] {
  --color-bg: oklch(18% 0.012 260);
  --color-bg-alt: oklch(22% 0.014 260);
  --color-surface: oklch(24% 0.014 260);
  --color-text: oklch(96% 0.006 90);
  --color-text-muted: oklch(72% 0.012 260);
  --color-border: oklch(32% 0.014 260);
  --color-accent: oklch(75% 0.14 250);
  --color-accent-contrast: oklch(15% 0 0);
  --color-placeholder: oklch(75% 0.14 50);
  --shadow-card: 0 1px 2px oklch(0% 0 0 / 0.3), 0 8px 24px oklch(0% 0 0 / 0.35);
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --color-bg: oklch(18% 0.012 260);
    --color-bg-alt: oklch(22% 0.014 260);
    --color-surface: oklch(24% 0.014 260);
    --color-text: oklch(96% 0.006 90);
    --color-text-muted: oklch(72% 0.012 260);
    --color-border: oklch(32% 0.014 260);
    --color-accent: oklch(75% 0.14 250);
    --color-accent-contrast: oklch(15% 0 0);
    --color-placeholder: oklch(75% 0.14 50);
    --shadow-card: 0 1px 2px oklch(0% 0 0 / 0.3), 0 8px 24px oklch(0% 0 0 / 0.35);
  }
}

/* Base */
body {
  background: var(--color-bg);
  color: var(--color-text);
  font-family: var(--font-sans);
  font-size: var(--text-base);
  line-height: 1.55;
}

.container {
  width: 100%;
  max-width: var(--container-max);
  margin-inline: auto;
  padding-inline: var(--space-4);
}

.skip-link {
  position: absolute;
  left: -999px;
  top: 0;
  background: var(--color-accent);
  color: var(--color-accent-contrast);
  padding: var(--space-2) var(--space-3);
  z-index: 100;
  text-decoration: none;
}
.skip-link:focus {
  left: var(--space-3);
  top: var(--space-3);
}

/* Header / nav */
.site-header {
  position: sticky;
  top: 0;
  z-index: 50;
  background: var(--color-bg);
  border-bottom: 1px solid var(--color-border);
}
.nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-block: var(--space-3);
  position: relative;
}
.brand {
  font-family: var(--font-mono);
  font-weight: 700;
  text-decoration: none;
  letter-spacing: -0.02em;
}
.nav-toggle {
  display: none;
  flex-direction: column;
  gap: 5px;
  background: none;
  border: none;
  cursor: pointer;
  padding: var(--space-2);
}
.nav-toggle span {
  width: 22px;
  height: 2px;
  background: var(--color-text);
  display: block;
}
.nav-links {
  display: flex;
  align-items: center;
  gap: var(--space-4);
}
.nav-links a {
  text-decoration: none;
  font-size: var(--text-sm);
  color: var(--color-text-muted);
  transition: color var(--duration-fast) var(--ease-out-expo);
}
.nav-links a:hover,
.nav-links a:focus-visible {
  color: var(--color-accent);
}
.theme-toggle {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  width: 34px;
  height: 34px;
  cursor: pointer;
  color: var(--color-text);
}

@media (max-width: 767px) {
  .nav-toggle { display: inline-flex; }
  .nav-links {
    position: absolute;
    inset-inline: 0;
    top: 100%;
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-3);
    background: var(--color-bg);
    border-bottom: 1px solid var(--color-border);
    padding: var(--space-4);
    transform: translateY(-8px);
    opacity: 0;
    pointer-events: none;
    transition: opacity var(--duration-normal) var(--ease-out-expo), transform var(--duration-normal) var(--ease-out-expo);
  }
  .nav-links.is-open {
    opacity: 1;
    transform: translateY(0);
    pointer-events: auto;
  }
}

/* Buttons */
.btn {
  display: inline-flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-2) var(--space-4);
  border-radius: var(--radius-sm);
  font-size: var(--text-sm);
  font-weight: 600;
  text-decoration: none;
  border: 1px solid transparent;
  cursor: pointer;
  transition: transform var(--duration-fast) var(--ease-out-expo), background var(--duration-fast) var(--ease-out-expo), border-color var(--duration-fast) var(--ease-out-expo), color var(--duration-fast) var(--ease-out-expo);
}
.btn-primary {
  background: var(--color-accent);
  color: var(--color-accent-contrast);
}
.btn-primary:hover { transform: translateY(-1px); }
.btn-ghost {
  background: transparent;
  border-color: var(--color-border);
  color: var(--color-text);
}
.btn-ghost:hover { border-color: var(--color-accent); color: var(--color-accent); }

/* Hero */
.hero {
  padding-block: calc(var(--space-section) * 0.7) var(--space-section);
  border-bottom: 1px solid var(--color-border);
}
.hero-grid {
  display: grid;
  gap: var(--space-6);
  align-items: center;
}
.hero-kicker {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--color-accent);
  margin-bottom: var(--space-3);
}
.hero h1 {
  font-size: var(--text-display);
  line-height: 1.05;
  letter-spacing: -0.02em;
  margin-bottom: var(--space-4);
}
.hero-lede {
  font-size: var(--text-lg);
  color: var(--color-text-muted);
  max-width: 46ch;
  margin-bottom: var(--space-5);
}
.hero-actions {
  display: flex;
  gap: var(--space-3);
  flex-wrap: wrap;
  margin-bottom: var(--space-6);
}
.hero-image {
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-card);
  overflow: hidden;
}
.hero-image img { width: 100%; height: auto; }

.stat-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--space-4);
}
.stat {
  border-top: 2px solid var(--color-accent);
  padding-top: var(--space-2);
}
.stat-number {
  font-family: var(--font-mono);
  font-size: var(--text-stat);
  font-weight: 700;
  display: block;
  line-height: 1;
}
.stat-label {
  font-size: var(--text-xs);
  color: var(--color-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

@media (min-width: 1024px) {
  .hero-grid { grid-template-columns: 1.1fr 0.9fr; }
  .stat-grid { grid-template-columns: repeat(4, 1fr); }
}

/* Generic section */
.section {
  padding-block: var(--space-section);
  border-bottom: 1px solid var(--color-border);
}
.section:last-of-type { border-bottom: none; }
.section-kicker {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--color-accent);
  margin-bottom: var(--space-2);
}
.section-title {
  font-size: var(--text-xl);
  letter-spacing: -0.01em;
  margin-bottom: var(--space-4);
  max-width: 60ch;
}
.section-lede {
  color: var(--color-text-muted);
  max-width: 65ch;
  margin-bottom: var(--space-5);
}

.about-body {
  display: grid;
  gap: var(--space-4);
  max-width: 70ch;
  font-size: var(--text-lg);
  color: var(--color-text-muted);
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-2);
}
.tag {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  padding: var(--space-1) var(--space-3);
  border: 1px solid var(--color-border);
  border-radius: 999px;
  background: var(--color-surface);
}

.case-study-grid {
  display: grid;
  gap: var(--space-4);
}
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
.case-study-card:hover { transform: translateY(-4px); }
.case-study-card img { aspect-ratio: 16 / 9; object-fit: cover; }
.case-study-card-body { padding: var(--space-4); }
.case-study-card-kicker {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--color-accent);
  text-transform: uppercase;
  letter-spacing: 0.06em;
  margin-bottom: var(--space-1);
}
.case-study-card h3 { font-size: var(--text-lg); margin-bottom: var(--space-2); }
.case-study-card p { color: var(--color-text-muted); font-size: var(--text-sm); margin-bottom: var(--space-3); }
.case-study-card .card-link { font-size: var(--text-sm); font-weight: 600; color: var(--color-accent); }

@media (min-width: 768px) {
  .case-study-grid { grid-template-columns: repeat(2, 1fr); }
}

.placeholder {
  border-bottom: 1px dashed var(--color-placeholder);
  color: var(--color-placeholder);
  cursor: help;
}
.placeholder-block {
  border: 1px dashed var(--color-placeholder);
  border-radius: var(--radius-md);
  padding: var(--space-4);
  color: var(--color-text-muted);
  font-size: var(--text-sm);
}

.contact-actions {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-3);
}

.site-footer {
  padding-block: var(--space-5);
  background: var(--color-bg-alt);
}
.footer-inner {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  gap: var(--space-3);
  font-size: var(--text-sm);
  color: var(--color-text-muted);
}
.footer-links { display: flex; gap: var(--space-4); }
.footer-links a { text-decoration: none; color: var(--color-text-muted); }
.footer-links a:hover { color: var(--color-accent); }

/* Case study pages */
.back-link {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  font-size: var(--text-sm);
  color: var(--color-text-muted);
  text-decoration: none;
  margin-block: var(--space-4);
}
.back-link:hover { color: var(--color-accent); }

.case-hero { padding-block: var(--space-4) var(--space-6); }
.case-kicker {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--color-accent);
  margin-bottom: var(--space-2);
}
.case-hero h1 {
  font-size: var(--text-display);
  line-height: 1.05;
  letter-spacing: -0.02em;
  margin-bottom: var(--space-3);
  max-width: 20ch;
}
.case-summary {
  font-size: var(--text-lg);
  color: var(--color-text-muted);
  max-width: 60ch;
  margin-bottom: var(--space-5);
}
.case-image {
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-card);
  overflow: hidden;
}
.case-image img { width: 100%; height: auto; }

.case-section { padding-block: var(--space-5); border-bottom: 1px solid var(--color-border); }
.case-section h2 { font-size: var(--text-xl); margin-bottom: var(--space-3); }
.case-section p { color: var(--color-text-muted); max-width: 68ch; margin-bottom: var(--space-3); }
.case-section p:last-child { margin-bottom: 0; }

.case-result {
  padding-block: var(--space-5);
  background: var(--color-bg-alt);
  border-block: 1px solid var(--color-border);
}
.case-result h2 { font-size: var(--text-xl); margin-bottom: var(--space-3); }
.case-note { font-size: var(--text-sm); color: var(--color-text-muted); font-style: italic; margin-top: var(--space-3); }

/* Motion */
.reveal {
  opacity: 0;
  transform: translateY(16px);
  transition: opacity var(--duration-normal) var(--ease-out-expo), transform var(--duration-normal) var(--ease-out-expo);
}
.reveal.is-visible {
  opacity: 1;
  transform: none;
}
@media (prefers-reduced-motion: reduce) {
  .reveal { opacity: 1; transform: none; }
}
```

- [ ] **Step 5: Verify the scaffold**

Run: `cd "C:\Users\Gamer\Music\scm\portfolio-site" && python -m json.tool .claude/launch.json`
Expected: pretty-printed JSON, no error.

Then check the CSS landed completely:
Run (Grep tool): search `style.css` for pattern `case-result` — expected 2+ matches (definition + comment). Search for pattern `prefers-reduced-motion` — expected 2 matches (top reset block + `.reveal` override).

- [ ] **Step 6: Commit**

```bash
cd "C:\Users\Gamer\Music\scm\portfolio-site"
git add .gitignore .claude/launch.json README.md assets/css/style.css
git commit -m "chore: scaffold portfolio site, design tokens, preview config"
```

---

### Task 2: Copy real screenshots into assets/img/

**Files:**
- Create: `assets/img/resultado-dashboard.png`
- Create: `assets/img/scm-agent-console.png`
- Create: `assets/img/dashboard-forecast.png`
- Create: `assets/img/dashboard-detail.png`
- Create: `assets/img/dashboard-portfolio.png`

**Interfaces:**
- Consumes: source files at `C:\Users\Gamer\Music\scm\resultado-dashboard.png` and `C:\Users\Gamer\Music\scm\supply-chain-optimization\docs\assets\{scm-agent-console,dashboard-forecast,dashboard-detail,dashboard-portfolio}.png`.
- Produces: image files at the paths above, referenced by `index.html` (Task 4) and the four case-study pages (Tasks 5–8) with exact filenames and pixel dimensions: `resultado-dashboard.png` 1440×900, `scm-agent-console.png` 1240×680, `dashboard-forecast.png`/`dashboard-detail.png`/`dashboard-portfolio.png` each 1380×860.

- [ ] **Step 1: Create the directory and copy the files**

```bash
cd "C:\Users\Gamer\Music\scm\portfolio-site"
mkdir -p assets/img
cp "C:\Users\Gamer\Music\scm\resultado-dashboard.png" assets/img/resultado-dashboard.png
cp "C:\Users\Gamer\Music\scm\supply-chain-optimization\docs\assets\scm-agent-console.png" assets/img/scm-agent-console.png
cp "C:\Users\Gamer\Music\scm\supply-chain-optimization\docs\assets\dashboard-forecast.png" assets/img/dashboard-forecast.png
cp "C:\Users\Gamer\Music\scm\supply-chain-optimization\docs\assets\dashboard-detail.png" assets/img/dashboard-detail.png
cp "C:\Users\Gamer\Music\scm\supply-chain-optimization\docs\assets\dashboard-portfolio.png" assets/img/dashboard-portfolio.png
```

- [ ] **Step 2: Verify all five files exist with nonzero size**

Run: `ls -la assets/img`
Expected: 5 files listed, each with a size in kilobytes (not 0 bytes).

- [ ] **Step 3: Commit**

```bash
git add assets/img
git commit -m "chore: add real Linchpin screenshots for hero and case studies"
```

---

### Task 3: main.js — nav toggle, theme toggle, scroll reveal

**Files:**
- Create: `assets/js/main.js`

**Interfaces:**
- Consumes (DOM element IDs it queries, which every later HTML page must provide exactly): `#navToggle` (button), `#navLinks` (nav, gets `.is-open` toggled), `#themeToggle` (button), `#year` (span, filled with current year). Also queries all elements with class `.reveal` (no ID required).
- Produces: no exported symbols — this is a self-contained IIFE. Later HTML pages just add `<script src="assets/js/main.js"></script>` (or `../assets/js/main.js` from `case-studies/`) and must include the exact IDs above for the script to have any effect.
- Full behavioral verification (does the nav actually open, does dark mode actually switch) happens in Task 4, once `index.html` exists to load this script in a real page. This task's own verification is a static sanity check only.

- [ ] **Step 1: Create `assets/js/main.js`**

```javascript
(() => {
  const yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  const navToggle = document.getElementById('navToggle');
  const navLinks = document.getElementById('navLinks');
  if (navToggle && navLinks) {
    navToggle.addEventListener('click', () => {
      const isOpen = navLinks.classList.toggle('is-open');
      navToggle.setAttribute('aria-expanded', String(isOpen));
    });
    navLinks.querySelectorAll('a').forEach((link) => {
      link.addEventListener('click', () => {
        navLinks.classList.remove('is-open');
        navToggle.setAttribute('aria-expanded', 'false');
      });
    });
  }

  const themeToggle = document.getElementById('themeToggle');
  const root = document.documentElement;
  const storedTheme = localStorage.getItem('theme');
  if (storedTheme) root.setAttribute('data-theme', storedTheme);
  if (themeToggle) {
    themeToggle.addEventListener('click', () => {
      const current = root.getAttribute('data-theme')
        || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
      const next = current === 'dark' ? 'light' : 'dark';
      root.setAttribute('data-theme', next);
      localStorage.setItem('theme', next);
    });
  }

  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const revealEls = document.querySelectorAll('.reveal');
  if (prefersReducedMotion || !('IntersectionObserver' in window)) {
    revealEls.forEach((el) => el.classList.add('is-visible'));
  } else {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.15 });
    revealEls.forEach((el) => observer.observe(el));
  }
})();
```

- [ ] **Step 2: Static sanity check**

Run (Grep tool): search `assets/js/main.js` for pattern `navToggle` — expected 3 matches. Search for pattern `IntersectionObserver` — expected 2 matches. Search for pattern `prefers-reduced-motion` — expected 1 match.

If Node.js is available, additionally run: `node --check assets/js/main.js`
Expected: no output, exit code 0. If Node isn't installed, skip this — Task 4's browser verification covers it.

- [ ] **Step 3: Commit**

```bash
git add assets/js/main.js
git commit -m "feat: add nav toggle, dark-mode toggle, and scroll-reveal script"
```

---

### Task 4: index.html — home page

**Files:**
- Create: `index.html`

**Interfaces:**
- Consumes: CSS classes and tokens from Task 1 (`assets/css/style.css`), script from Task 3 (`assets/js/main.js`), images from Task 2 (`assets/img/resultado-dashboard.png`, `dashboard-forecast.png`, `dashboard-detail.png`, `dashboard-portfolio.png`, `scm-agent-console.png`).
- Produces: section anchor IDs `#top`, `#about`, `#skills`, `#case-studies`, `#certifications`, `#contact` — Tasks 5–8's "back to home" and nav links target these via `../index.html#id`. Produces the 4 case-study card `href`s (`case-studies/demand-forecasting.html`, `case-studies/safety-stock-eoq.html`, `case-studies/multi-echelon-network.html`, `case-studies/ai-decision-agent.html`) — Tasks 5–8 must create files at exactly these paths.

- [ ] **Step 1: Create `index.html`**

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>[Your Name] — Inventory & Supply Chain Optimization Specialist</title>
<meta name="description" content="Freelance inventory and supply chain optimization specialist. Demand forecasting, safety stock, EOQ, and multi-echelon network design, backed by an AI decision-support agent built from the ground up.">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect width='100' height='100' rx='20' fill='%232f5fb0'/%3E%3Ctext x='50' y='68' font-family='monospace' font-size='60' fill='white' text-anchor='middle'%3EL%3C/text%3E%3C/svg%3E">
<link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <div class="container nav">
    <a class="brand placeholder" href="index.html" title="Replace with your name">[Your Name]</a>
    <button class="nav-toggle" id="navToggle" type="button" aria-expanded="false" aria-controls="navLinks" aria-label="Toggle navigation">
      <span></span><span></span><span></span>
    </button>
    <nav class="nav-links" id="navLinks">
      <a href="#about">About</a>
      <a href="#case-studies">Case Studies</a>
      <a href="#skills">Skills</a>
      <a href="#contact">Contact</a>
      <button class="theme-toggle" id="themeToggle" type="button" aria-label="Toggle dark mode">&#9680;</button>
    </nav>
  </div>
</header>

<main id="main">
  <section class="hero" id="top">
    <div class="container hero-grid">
      <div>
        <p class="hero-kicker">Inventory &amp; Supply Chain Optimization</p>
        <h1>I turn demand data into inventory decisions you can defend.</h1>
        <p class="hero-lede">Freelance specialist in demand forecasting, safety stock, EOQ, and multi-echelon network design &mdash; grounded in the field's established models, and backed by <strong>Linchpin</strong>, an AI agent I built to run those models end to end.</p>
        <div class="hero-actions">
          <a class="btn btn-primary" href="#case-studies">View case studies</a>
          <a class="btn btn-ghost" href="#contact">Get in touch</a>
        </div>
        <div class="stat-grid">
          <div class="stat"><span class="stat-number">35+</span><span class="stat-label">Agent-routable tools</span></div>
          <div class="stat"><span class="stat-number">1,100+</span><span class="stat-label">Automated tests</span></div>
          <div class="stat"><span class="stat-number">24</span><span class="stat-label">SCM textbooks grounding every model</span></div>
          <div class="stat"><span class="stat-number">75 / 383s</span><span class="stat-label">Public datasets processed end to end</span></div>
        </div>
      </div>
      <div class="hero-image reveal">
        <img src="assets/img/resultado-dashboard.png" width="1440" height="900" alt="Linchpin inventory dashboard showing portfolio-level demand, budget, and reorder metrics" loading="eager" fetchpriority="high">
      </div>
    </div>
  </section>

  <section class="section about" id="about">
    <div class="container">
      <p class="section-kicker">About</p>
      <h2 class="section-title reveal">Hands-on with the models, not just the spreadsheets.</h2>
      <div class="about-body reveal">
        <p><span class="placeholder" title="Replace with your name">[Your Name]</span> is an inventory and supply chain optimization specialist with <span class="placeholder" title="Replace with years of experience">[X years]</span> of experience in <span class="placeholder" title="Replace with your background, e.g. retail/CPG/manufacturing planning">[your background]</span>.</p>
        <p>Rather than eyeballing reorder points in a spreadsheet, I build and run the actual models &mdash; EOQ, safety stock, multi-echelon guaranteed-service optimization, demand classification &mdash; grounded in the field's established textbooks (Vandeput, Silver-Pyke-Peterson, and others). That rigor is packaged into <strong>Linchpin</strong>, an AI agent I built that classifies a plain-language brief, runs the right model, validates the result, and delivers a finished Excel/report &mdash; see the case studies below.</p>
        <p><span class="placeholder" title="Replace with education/certifications">[Education / certifications]</span>.</p>
      </div>
    </div>
  </section>

  <section class="section skills" id="skills">
    <div class="container">
      <p class="section-kicker">Skills</p>
      <h2 class="section-title reveal">What I work with</h2>
      <ul class="tag-list reveal">
        <li class="tag">Demand Forecasting</li>
        <li class="tag">Safety Stock &amp; Reorder Points</li>
        <li class="tag">EOQ &amp; Order Policies</li>
        <li class="tag">Multi-Echelon Network Design</li>
        <li class="tag">DDMRP</li>
        <li class="tag">ABC-XYZ Segmentation</li>
        <li class="tag">S&amp;OP</li>
        <li class="tag">Python</li>
        <li class="tag">Pandas / Data Analysis</li>
        <li class="tag">Excel &amp; Power BI</li>
        <li class="tag">Process Automation</li>
      </ul>
    </div>
  </section>

  <section class="section case-studies" id="case-studies">
    <div class="container">
      <p class="section-kicker">Case Studies</p>
      <h2 class="section-title reveal">Four ways the models pay off</h2>
      <p class="section-lede reveal">Every number below is a real, reproducible output &mdash; a worked textbook example or a run against public benchmark data &mdash; not a client testimonial.</p>
      <div class="case-study-grid">
        <a class="case-study-card reveal" href="case-studies/demand-forecasting.html">
          <img src="assets/img/dashboard-forecast.png" width="1380" height="860" alt="Forecast dashboard showing demand curves against policy levels" loading="lazy">
          <div class="case-study-card-body">
            <p class="case-study-card-kicker">Forecasting</p>
            <h3>Demand Forecasting &amp; Segmentation at Scale</h3>
            <p>Classifying and forecasting 34,498 SKUs across 75 public retail datasets, end to end.</p>
            <span class="card-link">Read the case study &rarr;</span>
          </div>
        </a>
        <a class="case-study-card reveal" href="case-studies/safety-stock-eoq.html">
          <img src="assets/img/dashboard-detail.png" width="1380" height="860" alt="Detail dashboard showing SKU-level inventory policy parameters" loading="lazy">
          <div class="case-study-card-body">
            <p class="case-study-card-kicker">Safety Stock &amp; EOQ</p>
            <h3>Right-Sizing Safety Stock, Reorder Points &amp; Order Quantities</h3>
            <p>Textbook-grounded EOQ and safety-stock models, worked end to end from raw demand statistics.</p>
            <span class="card-link">Read the case study &rarr;</span>
          </div>
        </a>
        <a class="case-study-card reveal" href="case-studies/multi-echelon-network.html">
          <img src="assets/img/dashboard-portfolio.png" width="1380" height="860" alt="Portfolio dashboard showing inventory investment across a network of SKUs" loading="lazy">
          <div class="case-study-card-body">
            <p class="case-study-card-kicker">Network Design</p>
            <h3>Multi-Echelon Network Optimization</h3>
            <p>Guaranteed-service modeling across a 3-stage supply chain to place safety stock where it's cheapest.</p>
            <span class="card-link">Read the case study &rarr;</span>
          </div>
        </a>
        <a class="case-study-card reveal" href="case-studies/ai-decision-agent.html">
          <img src="assets/img/scm-agent-console.png" width="1240" height="680" alt="Linchpin agent console routing a brief to a supply chain capability" loading="lazy">
          <div class="case-study-card-body">
            <p class="case-study-card-kicker">AI Agent</p>
            <h3>Building an AI Agent for Supply-Chain Decisions</h3>
            <p>Why I didn't stop at spreadsheets: a QA-gated agent that runs 35+ SCM models end to end.</p>
            <span class="card-link">Read the case study &rarr;</span>
          </div>
        </a>
      </div>
    </div>
  </section>

  <section class="section certifications" id="certifications">
    <div class="container">
      <p class="section-kicker">Certifications</p>
      <h2 class="section-title reveal">Credentials</h2>
      <!-- Remove this block once you have real certifications to list, or fill it in. -->
      <div class="placeholder-block reveal">
        <span class="placeholder" title="Replace with a real certification, or delete this section">[Certification name &mdash; issuer, year]</span>
      </div>
    </div>
  </section>

  <section class="section contact" id="contact">
    <div class="container">
      <p class="section-kicker">Contact</p>
      <h2 class="section-title reveal">Have a demand or inventory problem?</h2>
      <p class="section-lede reveal">I'm available for freelance inventory and supply chain optimization work. Reach out and I'll walk you through how I'd approach it.</p>
      <div class="contact-actions reveal">
        <a class="btn btn-primary" href="mailto:you@example.com">Email me</a>
        <a class="btn btn-ghost placeholder" href="https://www.linkedin.com/in/your-profile" title="Replace with your LinkedIn URL" target="_blank" rel="noopener">LinkedIn</a>
        <a class="btn btn-ghost placeholder" href="https://www.upwork.com/freelancers/your-profile" title="Replace with your Upwork URL" target="_blank" rel="noopener">Upwork</a>
      </div>
    </div>
  </section>
</main>

<footer class="site-footer">
  <div class="container footer-inner">
    <p>&copy; <span id="year"></span> <span class="placeholder" title="Replace with your name">[Your Name]</span>. Built with Linchpin.</p>
    <div class="footer-links">
      <a href="https://github.com/esstipi-debug/linchpin" target="_blank" rel="noopener">GitHub</a>
      <a class="placeholder" href="https://www.linkedin.com/in/your-profile" title="Replace with your LinkedIn URL" target="_blank" rel="noopener">LinkedIn</a>
      <a class="placeholder" href="https://www.upwork.com/freelancers/your-profile" title="Replace with your Upwork URL" target="_blank" rel="noopener">Upwork</a>
    </div>
  </div>
</footer>

<script src="assets/js/main.js"></script>
</body>
</html>
```

- [ ] **Step 2: Start the preview server**

Call `mcp__Claude_Preview__preview_start` with `name: "portfolio"`. Capture the returned `serverId` for the following steps.

- [ ] **Step 3: Verify rendered content**

Call `mcp__Claude_Preview__preview_snapshot` with the `serverId`. Expected: accessibility tree includes the heading "I turn demand data into inventory decisions you can defend.", nav links "About"/"Case Studies"/"Skills"/"Contact", stat text "35+" and "1,100+", and 4 case-study card links with hrefs ending in `demand-forecasting.html`, `safety-stock-eoq.html`, `multi-echelon-network.html`, `ai-decision-agent.html`.

- [ ] **Step 4: Verify no console errors and no failed requests**

Call `mcp__Claude_Preview__preview_console_logs` with `level: "error"`. Expected: empty.
Call `mcp__Claude_Preview__preview_network` with `filter: "failed"`. Expected: empty (all 5 images and the CSS/JS load successfully).

- [ ] **Step 5: Verify the nav toggle and theme toggle work**

Call `mcp__Claude_Preview__preview_resize` with `preset: "mobile"`.
Call `mcp__Claude_Preview__preview_click` with `selector: "#navToggle"`.
Call `mcp__Claude_Preview__preview_eval` with `expression: "document.getElementById('navLinks').classList.contains('is-open')"`. Expected: `true`.
Call `mcp__Claude_Preview__preview_click` with `selector: "#themeToggle"`.
Call `mcp__Claude_Preview__preview_eval` with `expression: "document.documentElement.getAttribute('data-theme')"`. Expected: `"dark"` or `"light"` (a defined value, not `null`).
Call `mcp__Claude_Preview__preview_resize` with `preset: "desktop"` to restore the viewport before the next task.

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "feat: add home page (hero, about, skills, case-study index, contact)"
```

---

### Task 5: case-studies/demand-forecasting.html

**Files:**
- Create: `case-studies/demand-forecasting.html`

**Interfaces:**
- Consumes: CSS from Task 1, script from Task 3, image `assets/img/dashboard-forecast.png` from Task 2, and the exact header/footer/nav markup pattern established in Task 4 (same element IDs `#navToggle`/`#navLinks`/`#themeToggle`/`#year`), adapted to the one-level-deeper path (`../assets/...`, `../index.html#...`).
- Produces: nothing consumed by later tasks except the final verification pass in Task 10.

- [ ] **Step 1: Create `case-studies/demand-forecasting.html`**

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Demand Forecasting &amp; Segmentation at Scale — [Your Name]</title>
<meta name="description" content="Case study: classifying and forecasting 34,498 SKUs across 75 public retail datasets end to end with Linchpin.">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect width='100' height='100' rx='20' fill='%232f5fb0'/%3E%3Ctext x='50' y='68' font-family='monospace' font-size='60' fill='white' text-anchor='middle'%3EL%3C/text%3E%3C/svg%3E">
<link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <div class="container nav">
    <a class="brand placeholder" href="../index.html" title="Replace with your name">[Your Name]</a>
    <button class="nav-toggle" id="navToggle" type="button" aria-expanded="false" aria-controls="navLinks" aria-label="Toggle navigation">
      <span></span><span></span><span></span>
    </button>
    <nav class="nav-links" id="navLinks">
      <a href="../index.html#about">About</a>
      <a href="../index.html#case-studies">Case Studies</a>
      <a href="../index.html#skills">Skills</a>
      <a href="../index.html#contact">Contact</a>
      <button class="theme-toggle" id="themeToggle" type="button" aria-label="Toggle dark mode">&#9680;</button>
    </nav>
  </div>
</header>

<main id="main">
  <div class="container">
    <a class="back-link" href="../index.html#case-studies">&larr; All case studies</a>
  </div>

  <header class="case-hero">
    <div class="container">
      <p class="case-kicker">Case Study &mdash; Forecasting</p>
      <h1>Demand Forecasting &amp; Segmentation at Scale</h1>
      <p class="case-summary">Classifying and forecasting 34,498 SKUs across 75 public retail datasets, end to end, with no manual per-SKU tuning.</p>
      <div class="case-image reveal">
        <img src="../assets/img/dashboard-forecast.png" width="1380" height="860" alt="Forecast dashboard showing demand curves against policy levels" loading="eager">
      </div>
    </div>
  </header>

  <section class="case-section">
    <div class="container">
      <h2>Problem</h2>
      <p>Most retail and CPG SKUs don't have smooth, predictable demand. A large share of them are intermittent &mdash; long stretches of zero demand punctuated by occasional orders &mdash; which breaks naive forecasting methods like simple moving averages or plain exponential smoothing. Forecast the wrong way and every downstream decision (safety stock, reorder points, purchasing) inherits the error.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>Method</h2>
      <p>Before forecasting a single SKU, classify it. Linchpin's engine runs ABC-XYZ segmentation to separate steady, high-volume SKUs from volatile or intermittent ones, then routes intermittent SKUs to Croston's method instead of a generic smoothing model &mdash; the demand-classification approach laid out in Vandeput (2020), Ch. 9.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>What I built</h2>
      <p>I ran Linchpin's full <code>classify &rarr; forecast &rarr; inventory-policy</code> pipeline end to end against 75 public retail datasets &mdash; the M5 Forecasting competition (split by store and department), the UCI Online Retail dataset, and the Kaggle Superstore dataset &mdash; through the same agent pipeline used for every other capability, with no manual per-SKU tuning.</p>
    </div>
  </section>

  <section class="case-result">
    <div class="container">
      <h2>Result</h2>
      <div class="stat-grid">
        <div class="stat"><span class="stat-number">75</span><span class="stat-label">Public datasets processed</span></div>
        <div class="stat"><span class="stat-number">34,498</span><span class="stat-label">SKUs classified &amp; forecast</span></div>
        <div class="stat"><span class="stat-number">$33.47M</span><span class="stat-label">Aggregate inventory value computed</span></div>
        <div class="stat"><span class="stat-number">383s</span><span class="stat-label">Total end-to-end runtime</span></div>
      </div>
      <p class="case-note">Run against public benchmark datasets (M5 / UCI Online Retail / Superstore) via Linchpin's own portfolio benchmark script &mdash; not client data. The full dataset-by-dataset breakdown is reproducible from the Linchpin repository.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>Tools</h2>
      <ul class="tag-list">
        <li class="tag">Python</li>
        <li class="tag">Pandas</li>
        <li class="tag">ABC-XYZ Segmentation</li>
        <li class="tag">Croston's Method</li>
        <li class="tag">Linchpin Forecasting Engine</li>
      </ul>
    </div>
  </section>

  <div class="container">
    <a class="btn btn-primary" href="../index.html#contact">Discuss a project like this &rarr;</a>
  </div>
</main>

<footer class="site-footer">
  <div class="container footer-inner">
    <p>&copy; <span id="year"></span> <span class="placeholder" title="Replace with your name">[Your Name]</span>. Built with Linchpin.</p>
    <div class="footer-links">
      <a href="https://github.com/esstipi-debug/linchpin" target="_blank" rel="noopener">GitHub</a>
      <a class="placeholder" href="https://www.linkedin.com/in/your-profile" title="Replace with your LinkedIn URL" target="_blank" rel="noopener">LinkedIn</a>
      <a class="placeholder" href="https://www.upwork.com/freelancers/your-profile" title="Replace with your Upwork URL" target="_blank" rel="noopener">Upwork</a>
    </div>
  </div>
</footer>

<script src="../assets/js/main.js"></script>
</body>
</html>
```

- [ ] **Step 2: Verify in the browser**

Call `mcp__Claude_Preview__preview_start` with `name: "portfolio"` (reuses the running server).
Call `mcp__Claude_Preview__preview_eval` with `expression: "location.href = 'http://localhost:8000/case-studies/demand-forecasting.html'"`.
Call `mcp__Claude_Preview__preview_snapshot`. Expected: heading "Demand Forecasting & Segmentation at Scale", stat text "75", "34,498", "$33.47M", "383s", and a "&larr; All case studies" back link.
Call `mcp__Claude_Preview__preview_console_logs` with `level: "error"`. Expected: empty.
Call `mcp__Claude_Preview__preview_network` with `filter: "failed"`. Expected: empty.

- [ ] **Step 3: Commit**

```bash
git add case-studies/demand-forecasting.html
git commit -m "feat: add demand forecasting case study page"
```

---

### Task 6: case-studies/safety-stock-eoq.html

**Files:**
- Create: `case-studies/safety-stock-eoq.html`

**Interfaces:**
- Consumes: CSS from Task 1, script from Task 3, image `assets/img/dashboard-detail.png` from Task 2, same header/footer/nav pattern as Task 5.
- Produces: nothing consumed by later tasks except Task 10's verification.

- [ ] **Step 1: Create `case-studies/safety-stock-eoq.html`**

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Right-Sizing Safety Stock, Reorder Points &amp; EOQ — [Your Name]</title>
<meta name="description" content="Case study: worked EOQ and safety-stock models, end to end, grounded in Vandeput (2020).">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect width='100' height='100' rx='20' fill='%232f5fb0'/%3E%3Ctext x='50' y='68' font-family='monospace' font-size='60' fill='white' text-anchor='middle'%3EL%3C/text%3E%3C/svg%3E">
<link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <div class="container nav">
    <a class="brand placeholder" href="../index.html" title="Replace with your name">[Your Name]</a>
    <button class="nav-toggle" id="navToggle" type="button" aria-expanded="false" aria-controls="navLinks" aria-label="Toggle navigation">
      <span></span><span></span><span></span>
    </button>
    <nav class="nav-links" id="navLinks">
      <a href="../index.html#about">About</a>
      <a href="../index.html#case-studies">Case Studies</a>
      <a href="../index.html#skills">Skills</a>
      <a href="../index.html#contact">Contact</a>
      <button class="theme-toggle" id="themeToggle" type="button" aria-label="Toggle dark mode">&#9680;</button>
    </nav>
  </div>
</header>

<main id="main">
  <div class="container">
    <a class="back-link" href="../index.html#case-studies">&larr; All case studies</a>
  </div>

  <header class="case-hero">
    <div class="container">
      <p class="case-kicker">Case Study &mdash; Safety Stock &amp; EOQ</p>
      <h1>Right-Sizing Safety Stock, Reorder Points &amp; Order Quantities</h1>
      <p class="case-summary">The two most common &mdash; and most often misapplied &mdash; inventory formulas, worked end to end from raw demand statistics to a defensible policy.</p>
      <div class="case-image reveal">
        <img src="../assets/img/dashboard-detail.png" width="1380" height="860" alt="Detail dashboard showing SKU-level inventory policy parameters" loading="eager">
      </div>
    </div>
  </header>

  <section class="case-section">
    <div class="container">
      <h2>Problem</h2>
      <p>Two questions come up on almost every inventory engagement: how much should I order at once, and how much buffer should I hold against demand variability? Get the order quantity wrong and you pay too much in ordering or holding costs; get the safety stock wrong and you either stock out or tie up working capital that didn't need to be there.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>Method</h2>
      <p>The Economic Order Quantity (EOQ) model balances ordering cost against holding cost to find the order size that minimizes total annual cost (Vandeput 2020, &sect;2.2.4). Safety stock is sized from the standard deviation of demand and a target cycle service level, converted to a buffer via the service-level z-factor (Vandeput 2020, Table 4.1) &mdash; not a flat percentage of average demand, which is the most common mistake I see.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>What I built</h2>
      <p>I ran both formulas end to end through Linchpin's <code>eoq</code> and <code>safety_stock</code> modules on a representative demand profile, then combined them into a reorder point: expected demand during lead time plus the safety-stock buffer.</p>
    </div>
  </section>

  <section class="case-result">
    <div class="container">
      <h2>Result</h2>
      <div class="stat-grid">
        <div class="stat"><span class="stat-number">239</span><span class="stat-label">EOQ order quantity (units), D=1,000/yr, k=&euro;50/order, h=&euro;1.75/unit/yr</span></div>
        <div class="stat"><span class="stat-number">&euro;418</span><span class="stat-label">Minimum total annual cost at that order quantity</span></div>
        <div class="stat"><span class="stat-number">41</span><span class="stat-label">Safety stock (units), &mu;=100, &sigma;=25, 95% service level</span></div>
        <div class="stat"><span class="stat-number">141</span><span class="stat-label">Resulting reorder point (units)</span></div>
      </div>
      <p class="case-note">Worked examples reproduced from Linchpin's engine (<code>src/eoq.py</code>, <code>src/safety_stock.py</code>) &mdash; every number here is reproducible with a two-line Python snippet in the repository's case-studies file.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>Tools</h2>
      <ul class="tag-list">
        <li class="tag">Python</li>
        <li class="tag">EOQ Modeling</li>
        <li class="tag">Safety Stock / Service Level Analysis</li>
        <li class="tag">(s,Q) / (R,S) Policy Design</li>
      </ul>
    </div>
  </section>

  <div class="container">
    <a class="btn btn-primary" href="../index.html#contact">Discuss a project like this &rarr;</a>
  </div>
</main>

<footer class="site-footer">
  <div class="container footer-inner">
    <p>&copy; <span id="year"></span> <span class="placeholder" title="Replace with your name">[Your Name]</span>. Built with Linchpin.</p>
    <div class="footer-links">
      <a href="https://github.com/esstipi-debug/linchpin" target="_blank" rel="noopener">GitHub</a>
      <a class="placeholder" href="https://www.linkedin.com/in/your-profile" title="Replace with your LinkedIn URL" target="_blank" rel="noopener">LinkedIn</a>
      <a class="placeholder" href="https://www.upwork.com/freelancers/your-profile" title="Replace with your Upwork URL" target="_blank" rel="noopener">Upwork</a>
    </div>
  </div>
</footer>

<script src="../assets/js/main.js"></script>
</body>
</html>
```

- [ ] **Step 2: Verify in the browser**

Call `mcp__Claude_Preview__preview_start` with `name: "portfolio"`.
Call `mcp__Claude_Preview__preview_eval` with `expression: "location.href = 'http://localhost:8000/case-studies/safety-stock-eoq.html'"`.
Call `mcp__Claude_Preview__preview_snapshot`. Expected: heading "Right-Sizing Safety Stock, Reorder Points & Order Quantities", stat text "239", "€418", "41", "141".
Call `mcp__Claude_Preview__preview_console_logs` with `level: "error"`. Expected: empty.
Call `mcp__Claude_Preview__preview_network` with `filter: "failed"`. Expected: empty.

- [ ] **Step 3: Commit**

```bash
git add case-studies/safety-stock-eoq.html
git commit -m "feat: add safety stock and EOQ case study page"
```

---

### Task 7: case-studies/multi-echelon-network.html

**Files:**
- Create: `case-studies/multi-echelon-network.html`

**Interfaces:**
- Consumes: CSS from Task 1, script from Task 3, image `assets/img/dashboard-portfolio.png` from Task 2, same header/footer/nav pattern as Task 5.
- Produces: nothing consumed by later tasks except Task 10's verification.

- [ ] **Step 1: Create `case-studies/multi-echelon-network.html`**

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Multi-Echelon Network Optimization — [Your Name]</title>
<meta name="description" content="Case study: Guaranteed-Service Model optimization across a 3-stage supply chain.">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect width='100' height='100' rx='20' fill='%232f5fb0'/%3E%3Ctext x='50' y='68' font-family='monospace' font-size='60' fill='white' text-anchor='middle'%3EL%3C/text%3E%3C/svg%3E">
<link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <div class="container nav">
    <a class="brand placeholder" href="../index.html" title="Replace with your name">[Your Name]</a>
    <button class="nav-toggle" id="navToggle" type="button" aria-expanded="false" aria-controls="navLinks" aria-label="Toggle navigation">
      <span></span><span></span><span></span>
    </button>
    <nav class="nav-links" id="navLinks">
      <a href="../index.html#about">About</a>
      <a href="../index.html#case-studies">Case Studies</a>
      <a href="../index.html#skills">Skills</a>
      <a href="../index.html#contact">Contact</a>
      <button class="theme-toggle" id="themeToggle" type="button" aria-label="Toggle dark mode">&#9680;</button>
    </nav>
  </div>
</header>

<main id="main">
  <div class="container">
    <a class="back-link" href="../index.html#case-studies">&larr; All case studies</a>
  </div>

  <header class="case-hero">
    <div class="container">
      <p class="case-kicker">Case Study &mdash; Network Design</p>
      <h1>Multi-Echelon Network Optimization</h1>
      <p class="case-summary">Where in a multi-stage supply chain should safety stock actually live? The Guaranteed-Service Model answers that with numbers, not intuition.</p>
      <div class="case-image reveal">
        <img src="../assets/img/dashboard-portfolio.png" width="1380" height="860" alt="Portfolio dashboard showing inventory investment across a network of SKUs" loading="eager">
      </div>
    </div>
  </header>

  <section class="case-section">
    <div class="container">
      <h2>Problem</h2>
      <p>Positioning safety stock node by node in a multi-stage supply chain (supplier &rarr; distribution center &rarr; store) is a common but wasteful default. Holding a buffer at every stage double- and triple-covers the same variability. The real question is where in the chain to hold it.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>Method</h2>
      <p>The Guaranteed-Service Model (GSM) &mdash; Vandeput (2020) Ch. 10, building on Graves &amp; Willems &mdash; computes each stage's optimal "net replenishment time" (its risk period) to minimize total holding cost across the chain while still meeting a target end-to-end service level.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>What I built</h2>
      <p>I ran Linchpin's <code>multi_echelon</code> module on a 3-stage serial chain with stage lead times of 4, 3, and 2 days, demand of &mu;=100 / &sigma;=25 per period, review periods of 1, 2, and 4 days at each stage, and a 95% target service level.</p>
    </div>
  </section>

  <section class="case-result">
    <div class="container">
      <h2>Result</h2>
      <div class="stat-grid">
        <div class="stat"><span class="stat-number">(4, 0, 6)</span><span class="stat-label">Optimal risk periods across the 3 stages</span></div>
        <div class="stat"><span class="stat-number">&euro;485</span><span class="stat-label">Total holding cost at that configuration</span></div>
        <div class="stat"><span class="stat-number">95%</span><span class="stat-label">End-to-end target service level held</span></div>
        <div class="stat"><span class="stat-number">3</span><span class="stat-label">Supply-chain stages optimized jointly</span></div>
      </div>
      <p class="case-note">Worked example reproduced from Linchpin's engine (<code>src/multi_echelon.py</code>) &mdash; reproducible via Exercise 6 in the repository's case-studies file.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>Tools</h2>
      <ul class="tag-list">
        <li class="tag">Python</li>
        <li class="tag">Guaranteed-Service Model (GSM)</li>
        <li class="tag">Multi-Echelon Inventory Optimization</li>
        <li class="tag">Network Design</li>
      </ul>
    </div>
  </section>

  <div class="container">
    <a class="btn btn-primary" href="../index.html#contact">Discuss a project like this &rarr;</a>
  </div>
</main>

<footer class="site-footer">
  <div class="container footer-inner">
    <p>&copy; <span id="year"></span> <span class="placeholder" title="Replace with your name">[Your Name]</span>. Built with Linchpin.</p>
    <div class="footer-links">
      <a href="https://github.com/esstipi-debug/linchpin" target="_blank" rel="noopener">GitHub</a>
      <a class="placeholder" href="https://www.linkedin.com/in/your-profile" title="Replace with your LinkedIn URL" target="_blank" rel="noopener">LinkedIn</a>
      <a class="placeholder" href="https://www.upwork.com/freelancers/your-profile" title="Replace with your Upwork URL" target="_blank" rel="noopener">Upwork</a>
    </div>
  </div>
</footer>

<script src="../assets/js/main.js"></script>
</body>
</html>
```

- [ ] **Step 2: Verify in the browser**

Call `mcp__Claude_Preview__preview_start` with `name: "portfolio"`.
Call `mcp__Claude_Preview__preview_eval` with `expression: "location.href = 'http://localhost:8000/case-studies/multi-echelon-network.html'"`.
Call `mcp__Claude_Preview__preview_snapshot`. Expected: heading "Multi-Echelon Network Optimization", stat text "(4, 0, 6)", "€485", "95%", "3".
Call `mcp__Claude_Preview__preview_console_logs` with `level: "error"`. Expected: empty.
Call `mcp__Claude_Preview__preview_network` with `filter: "failed"`. Expected: empty.

- [ ] **Step 3: Commit**

```bash
git add case-studies/multi-echelon-network.html
git commit -m "feat: add multi-echelon network optimization case study page"
```

---

### Task 8: case-studies/ai-decision-agent.html

**Files:**
- Create: `case-studies/ai-decision-agent.html`

**Interfaces:**
- Consumes: CSS from Task 1, script from Task 3, image `assets/img/scm-agent-console.png` from Task 2, same header/footer/nav pattern as Task 5 (note: this page's primary CTA links directly to the GitHub repo instead of `../index.html#contact`, since "view the code" is the natural next action here).
- Produces: nothing consumed by later tasks except Task 10's verification.

- [ ] **Step 1: Create `case-studies/ai-decision-agent.html`**

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Building an AI Agent for Supply-Chain Decisions — [Your Name]</title>
<meta name="description" content="Case study: Linchpin, a QA-gated AI agent that runs 35+ supply-chain models end to end.">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect width='100' height='100' rx='20' fill='%232f5fb0'/%3E%3Ctext x='50' y='68' font-family='monospace' font-size='60' fill='white' text-anchor='middle'%3EL%3C/text%3E%3C/svg%3E">
<link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <div class="container nav">
    <a class="brand placeholder" href="../index.html" title="Replace with your name">[Your Name]</a>
    <button class="nav-toggle" id="navToggle" type="button" aria-expanded="false" aria-controls="navLinks" aria-label="Toggle navigation">
      <span></span><span></span><span></span>
    </button>
    <nav class="nav-links" id="navLinks">
      <a href="../index.html#about">About</a>
      <a href="../index.html#case-studies">Case Studies</a>
      <a href="../index.html#skills">Skills</a>
      <a href="../index.html#contact">Contact</a>
      <button class="theme-toggle" id="themeToggle" type="button" aria-label="Toggle dark mode">&#9680;</button>
    </nav>
  </div>
</header>

<main id="main">
  <div class="container">
    <a class="back-link" href="../index.html#case-studies">&larr; All case studies</a>
  </div>

  <header class="case-hero">
    <div class="container">
      <p class="case-kicker">Case Study &mdash; AI Agent</p>
      <h1>Building an AI Agent for Supply-Chain Decisions</h1>
      <p class="case-summary">Why I didn't stop at spreadsheets: a QA-gated agent that classifies a brief, runs the right model, and never leaves you with a dead end.</p>
      <div class="case-image reveal">
        <img src="../assets/img/scm-agent-console.png" width="1240" height="680" alt="Linchpin agent console routing a brief to a supply chain capability" loading="eager">
      </div>
    </div>
  </header>

  <section class="case-section">
    <div class="container">
      <h2>Problem</h2>
      <p>Most inventory analysis lives in one-off spreadsheets: fragile, unauditable, and slow to rerun the moment the data changes. Every new question means rebuilding the same formulas from scratch, and nothing stops a bad input from producing a confident-looking wrong answer.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>Method</h2>
      <p>I built an orchestrator agent around the exact same pipeline for every capability: a plain-language brief is classified to intent, routed to one of 35+ registered tools, run, validated against a QA gate, and delivered as a finished Excel workbook, report, and chart. If QA fails, nothing ships &mdash; that check lives in one place, not scattered across each tool.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>What I built</h2>
      <p>Two safety guarantees sit on top of the pipeline. <strong>Never-unprotected:</strong> every consequential result is either executed outright, or hands back ranked options, a prepared handoff (a pre-filled PO or count sheet), or an escalation with an SLA &mdash; never a dead end. <strong>Safe-staging writeback:</strong> any change to a client's live system of record (e.g. an Odoo ERP or an Excel workbook) is first staged as a dry-run changeset, classified by risk tier, gated behind a time-boxed approval, and applied idempotently with a working rollback.</p>
    </div>
  </section>

  <section class="case-result">
    <div class="container">
      <h2>Result</h2>
      <div class="stat-grid">
        <div class="stat"><span class="stat-number">35+</span><span class="stat-label">Agent-routable supply-chain tools, one pipeline</span></div>
        <div class="stat"><span class="stat-number">1,100+</span><span class="stat-label">Automated tests (engine vs. textbook numbers + agent + HTTP guards)</span></div>
        <div class="stat"><span class="stat-number">24</span><span class="stat-label">SCM textbooks/papers grounding every model via a knowledge graph</span></div>
        <div class="stat"><span class="stat-number">75 / 383s</span><span class="stat-label">Public datasets processed end to end, one benchmark run</span></div>
      </div>
      <p class="case-note">Linchpin is open source &mdash; browse the orchestrator, the full tool registry, and the test suite on GitHub.</p>
    </div>
  </section>

  <section class="case-section">
    <div class="container">
      <h2>Tools</h2>
      <ul class="tag-list">
        <li class="tag">Python</li>
        <li class="tag">FastAPI</li>
        <li class="tag">Knowledge-Graph Retrieval</li>
        <li class="tag">QA-Gated Pipeline Design</li>
        <li class="tag">LLM-Assisted Routing (optional)</li>
      </ul>
    </div>
  </section>

  <div class="container">
    <a class="btn btn-primary" href="https://github.com/esstipi-debug/linchpin" target="_blank" rel="noopener">View the repository &rarr;</a>
  </div>
</main>

<footer class="site-footer">
  <div class="container footer-inner">
    <p>&copy; <span id="year"></span> <span class="placeholder" title="Replace with your name">[Your Name]</span>. Built with Linchpin.</p>
    <div class="footer-links">
      <a href="https://github.com/esstipi-debug/linchpin" target="_blank" rel="noopener">GitHub</a>
      <a class="placeholder" href="https://www.linkedin.com/in/your-profile" title="Replace with your LinkedIn URL" target="_blank" rel="noopener">LinkedIn</a>
      <a class="placeholder" href="https://www.upwork.com/freelancers/your-profile" title="Replace with your Upwork URL" target="_blank" rel="noopener">Upwork</a>
    </div>
  </div>
</footer>

<script src="../assets/js/main.js"></script>
</body>
</html>
```

- [ ] **Step 2: Verify in the browser**

Call `mcp__Claude_Preview__preview_start` with `name: "portfolio"`.
Call `mcp__Claude_Preview__preview_eval` with `expression: "location.href = 'http://localhost:8000/case-studies/ai-decision-agent.html'"`.
Call `mcp__Claude_Preview__preview_snapshot`. Expected: heading "Building an AI Agent for Supply-Chain Decisions", stat text "35+", "1,100+", "24", "75 / 383s", and a "View the repository" link pointing to `https://github.com/esstipi-debug/linchpin`.
Call `mcp__Claude_Preview__preview_console_logs` with `level: "error"`. Expected: empty.
Call `mcp__Claude_Preview__preview_network` with `filter: "failed"`. Expected: empty.

- [ ] **Step 3: Commit**

```bash
git add case-studies/ai-decision-agent.html
git commit -m "feat: add AI decision agent case study page"
```

---

### Task 9: upwork/profile-content.md

**Files:**
- Create: `upwork/profile-content.md`

**Interfaces:**
- Consumes: the four case-study filenames from Tasks 5–8 (`demand-forecasting.html`, `safety-stock-eoq.html`, `multi-echelon-network.html`, `ai-decision-agent.html`) to build the portfolio-item link placeholders.
- Produces: a standalone content file, not rendered by the website, not consumed by any other task.

- [ ] **Step 1: Create `upwork/profile-content.md`**

```markdown
# Upwork Profile Content

Copy-paste source for your Upwork profile. Replace every `[PLACEHOLDER: ...]`
before publishing.

## Profile title (one line)

Inventory & Supply Chain Optimization Specialist | Demand Forecasting, Safety Stock, EOQ, Multi-Echelon

## Overview / bio

[PLACEHOLDER: 1-2 sentence opener about your background — role, years of experience, industries]

I work on the inventory and demand-planning problems that decide whether a business is stocked out or drowning in working capital:

- **Demand forecasting** for volatile and intermittent-demand SKUs (Croston's method, ABC-XYZ segmentation)
- **Safety stock & reorder points** sized to a target service level, not guesswork
- **EOQ & order policies** — (s,Q) and (R,S) — balancing ordering cost against holding cost
- **Multi-echelon network design** — placing safety stock where it's cheapest across a supply chain, using the Guaranteed-Service Model

Every model I use is grounded in the field's established literature (Vandeput, Silver-Pyke-Peterson, and others) — I don't eyeball it. To prove it, I built **Linchpin**, an open-source AI agent that runs 35+ of these models end to end, QA-gated, from a plain-language brief. You can see it work in my portfolio.

[PLACEHOLDER: education, certifications, or a closing line about availability/rates]

## Skills (tags)

Inventory Optimization, Demand Forecasting, Safety Stock, EOQ, Reorder Point Optimization, Multi-Echelon Inventory Optimization, DDMRP, ABC-XYZ Analysis, S&OP, Python, Pandas, Excel, Power BI, Supply Chain Analytics, Process Automation

## Portfolio items (4)

### 1. Demand Forecasting & Segmentation at Scale
Classified and forecast 34,498 SKUs across 75 public retail datasets (M5 competition, UCI Online Retail, Superstore) end to end, using demand-driven segmentation and Croston's method for intermittent demand.
Link: [PLACEHOLDER: your-site-url]/case-studies/demand-forecasting.html

### 2. Right-Sizing Safety Stock, Reorder Points & Order Quantities
Worked EOQ and safety-stock models end to end from raw demand statistics to a reorder policy at a target service level, grounded in Vandeput (2020).
Link: [PLACEHOLDER: your-site-url]/case-studies/safety-stock-eoq.html

### 3. Multi-Echelon Network Optimization
Applied the Guaranteed-Service Model to a 3-stage supply chain to find where in the network to hold safety stock at minimum cost while meeting a 95% service level.
Link: [PLACEHOLDER: your-site-url]/case-studies/multi-echelon-network.html

### 4. Building an AI Agent for Supply-Chain Decisions
Built Linchpin, an open-source orchestrator agent that classifies a plain-language brief, runs the right model from a registry of 35+, validates it, and delivers a finished Excel/report — QA-gated, with a safe-staging writeback guarantee for any live system it touches.
Link: [PLACEHOLDER: your-site-url]/case-studies/ai-decision-agent.html
```

- [ ] **Step 2: Verify the placeholder markers and links are correct**

Run (Grep tool): search `upwork/profile-content.md` for pattern `\[PLACEHOLDER:` — expected 6 matches (opener, closing line, 4 link URLs).
Run (Grep tool): search `upwork/profile-content.md` for pattern `case-studies/` — expected 4 matches, one per case-study filename, and each must match a file created in Tasks 5–8 exactly: `demand-forecasting.html`, `safety-stock-eoq.html`, `multi-echelon-network.html`, `ai-decision-agent.html`.

- [ ] **Step 3: Commit**

```bash
git add upwork/profile-content.md
git commit -m "docs: add Upwork profile content package"
```

---

### Task 10: Full cross-page QA pass

**Files:**
- Modify: any file above, only if this pass finds a real defect (none expected if Tasks 1–9 were followed exactly).

**Interfaces:**
- Consumes: every artifact produced by Tasks 1–9.
- Produces: a final verification record. No new interfaces for further tasks — this is the last task in the plan.

- [ ] **Step 1: Start the preview server**

Call `mcp__Claude_Preview__preview_start` with `name: "portfolio"`. Capture the `serverId`.

- [ ] **Step 2: Check every page at every breakpoint for overflow**

For each of the 5 URLs — `http://localhost:8000/index.html`, `.../case-studies/demand-forecasting.html`, `.../case-studies/safety-stock-eoq.html`, `.../case-studies/multi-echelon-network.html`, `.../case-studies/ai-decision-agent.html` — and each of the 4 widths — 320, 768, 1024, 1440 (height 900 for all):
1. Call `mcp__Claude_Preview__preview_eval` with `expression: "location.href = '<url>'"`.
2. Call `mcp__Claude_Preview__preview_resize` with `width: <w>, height: 900`.
3. Call `mcp__Claude_Preview__preview_eval` with `expression: "document.documentElement.scrollWidth > document.documentElement.clientWidth"`. Expected: `false` at every combination (no horizontal overflow).

That's 20 checks total (5 pages × 4 widths). If any check returns `true`, take a `mcp__Claude_Preview__preview_screenshot` to identify the overflowing element, fix the CSS rule in `assets/css/style.css`, and re-run that specific check.

- [ ] **Step 3: Verify dark mode on every page**

For each of the 5 URLs:
1. Navigate to it via `preview_eval` (`location.href = '<url>'`).
2. Call `mcp__Claude_Preview__preview_click` with `selector: "#themeToggle"`.
3. Call `mcp__Claude_Preview__preview_eval` with `expression: "getComputedStyle(document.body).backgroundColor"`. Expected: a dark color (not the light-mode background) after the click.
4. Call `mcp__Claude_Preview__preview_click` with `selector: "#themeToggle"` again to toggle back to light, confirming the toggle is reversible.

- [ ] **Step 4: Verify all internal links resolve**

For each of the 5 URLs, navigate to it, then call `mcp__Claude_Preview__preview_network` with `filter: "failed"`. Expected: empty for every page (zero 404s, zero failed requests — this also confirms the inline SVG favicons mean no stray `/favicon.ico` request appears).

Additionally, from `index.html`, call `mcp__Claude_Preview__preview_click` on each of the 4 case-study card links (`selector: "a[href='case-studies/demand-forecasting.html']"`, etc.) and confirm via `preview_snapshot` that the resulting page's `<h1>` matches the expected case-study title. Then use the "&larr; All case studies" back-link on each case-study page and confirm it lands back on `index.html` with the `#case-studies` section in view.

- [ ] **Step 5: Confirm the reduced-motion guard is present in shipped code**

Run (Grep tool): search `assets/css/style.css` for pattern `prefers-reduced-motion` — expected 2 matches. Search `assets/js/main.js` for pattern `prefers-reduced-motion` — expected 1 match. (Live emulation of `prefers-reduced-motion` isn't available through the preview tooling, so this is a static confirmation that the guard shipped in both the CSS and JS, matching the spec's requirement.)

- [ ] **Step 6: Final commit**

If Step 2 found and fixed any overflow issues, commit them now:

```bash
git add assets/css/style.css
git commit -m "fix: resolve responsive overflow found in final QA pass"
```

If no fixes were needed, run a final sanity check instead:

```bash
git log --oneline
git status
```

Expected: a clean working tree (`nothing to commit, working tree clean`) and a commit history showing all 9 prior commits plus the initial spec commit.

---

## Self-Review

**Spec coverage:** §2 (scope) → Tasks 1–9 build exactly the in-scope file list, nothing from the out-of-scope list (no GitHub push, no contact-form backend, no real bio content, no new Linchpin engine work). §3 (case studies, honesty constraint) → all four stat blocks in Tasks 5–8 trace to `CASE_STUDIES.md` or `deliverables/portfolio/report.md`, cited in each `case-note`. §4 (architecture) → Task 1's file structure matches exactly. §5 (visual design) → Task 1's CSS implements the Swiss/data-forward tokens, max-two-font-family rule, light/dark mode, and reduced-motion guard. §6 (Upwork content) → Task 9. §7 (contact & links) → `mailto:` + placeholder LinkedIn/Upwork + real GitHub link, present in every page's footer and the home page's contact section. §8 (testing) → Task 10 covers breakpoints, both themes, all internal links, and the reduced-motion guard, with the "no automated test suite" decision honored throughout (Grep/preview-tool checks instead of pytest). §9 (deployment) → explicitly excluded from every task; the plan never runs `git push` or touches GitHub repo creation.

**Placeholder scan:** No "TBD"/"TODO" in any task step. The `[PLACEHOLDER: ...]` markers inside the HTML/Markdown content are intentional per spec §2/§6, not omissions in the plan itself.

**Type/interface consistency:** Element IDs `navToggle`/`navLinks`/`themeToggle`/`year` are identical across Task 3 (consumer) and Tasks 4–8 (producers) — checked by re-reading each task's markup after drafting. The 4 case-study filenames referenced in Task 4's cards and Task 9's links match the exact filenames created in Tasks 5–8. Image filenames and dimensions referenced in Tasks 4–8 match exactly what Task 2 copies.

---

**Plan complete and saved to `docs/superpowers/plans/2026-07-08-portfolio-site.md`.** Two execution options:

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration.

**2. Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints.

Which approach?
