# Portfolio Site — Design Spec

> Date: 2026-07-08
> Status: approved for implementation
> Author: collaborative brainstorming (user + agent)

## 1. Problem and goal

The user wants a freelance portfolio to support job search on Upwork, targeting
Inventory / Supply Chain Management specialist roles. The flagship (and only)
project is **Linchpin** — an agentic supply-chain engine the user built
(`C:\Users\Gamer\Music\scm\supply-chain-optimization`, 35+ agent-routable
tools — Linchpin is under active development in parallel sessions, so pull the
exact current count from `README.md`/`CLAUDE.md` at build time rather than
hardcoding it — QA-gated deliverables, 1100+ tests, grounded in 24 SCM
textbooks/papers).

Rather than one monolithic case study, Linchpin is broken into several
bite-sized case studies so the portfolio demonstrates range (forecasting,
safety stock/EOQ, network design) plus the differentiator (built an AI agent
that automates the work, not just spreadsheets).

Two deliverables come out of this spec:
1. A standalone static **website**, deployed on GitHub Pages.
2. A **content package** for the user's Upwork profile (title, bio, skills,
   portfolio item blurbs) — plain text/Markdown, not part of the website.

## 2. Scope v1

**In scope:**
- One home page (`index.html`): hero, about, skills, case-study index, contact.
- Four case-study pages, each independently linkable.
- A shared CSS design system (Swiss / data-forward direction).
- Minimal vanilla JS (mobile nav toggle, smooth scroll, scroll-reveal that
  respects `prefers-reduced-motion`). No framework, no build step.
- `upwork/profile-content.md` — copy-paste content for the Upwork profile.
- Local build, verified in-browser. Git repo initialized and committed locally.

**Out of scope for v1:**
- Pushing to a new GitHub repo / enabling GitHub Pages (separate step, requires
  explicit user confirmation before any `git push` or repo creation on GitHub,
  since that's a public/shared action).
- Domain purchase or custom DNS.
- Real bio content, headshot photo, or certifications (none exist yet) — these
  are clearly marked placeholders the user fills in afterward.
- A working contact form / backend (static site → `mailto:` link only).
- Any new Linchpin engine work. This project only *presents* Linchpin; it does
  not modify `supply-chain-optimization`.

## 3. Case studies — content plan and honesty constraint

No fabricated client results or testimonials. Each case study shows **real,
verifiable output** — either a worked example already in
`supply-chain-optimization/case-studies/CASE_STUDIES.md`, or a result run
against a public benchmark dataset already present in
`supply-chain-optimization/deliverables/` (M5, Superstore). Framed explicitly
as "demonstrated capability on public/benchmark data," not a client
engagement — this is more credible for cold outreach than an unverifiable
number, and avoids misrepresenting freelance experience the user doesn't have
yet.

| # | Case study | Source material | Real number to feature |
|---|---|---|---|
| 1 | Demand Forecasting for Volatile & Intermittent Demand | `src/forecasting.py`, M5 benchmark in `deliverables/` | Forecast output on M5 sample SKUs (pull actual figure at build time) |
| 2 | Safety Stock, Reorder Points & EOQ | `CASE_STUDIES.md` Exercises 1–2 | Q*≈239, C*≈418 (EOQ); Ss≈41, inventory≈141 units at 95% service level |
| 3 | Multi-Echelon Network Optimization | `CASE_STUDIES.md` Exercise 6 | risk periods (4,0,6), holding cost ≈485 |
| 4 | Building an AI Agent for Supply-Chain Decisions | `README.md` / `CLAUDE.md` | 35+ agent-routable tools (exact count from README at build time), QA-gated pipeline, 1100+ tests, never-unprotected guarantee, safe-staging writeback |

Each case study page follows the same structure: **Problem → Method (cites the
underlying model/textbook, e.g. Vandeput 2020) → What was built → Verifiable
result → Tools used**.

Real screenshots already exist and will be reused (not recreated) as visual
proof (item 8 of the original outline):
`supply-chain-optimization/docs/assets/scm-agent-console.png`,
`dashboard-forecast.png`, `dashboard-budget.png`, `dashboard-detail.png`,
`dashboard-portfolio.png`, and `scm/resultado-dashboard.png`. Copies will be
placed under `portfolio-site/assets/img/` (not referenced cross-repo, since
the two are separate git projects).

## 4. Architecture / file structure

```
portfolio-site/
├── index.html
├── case-studies/
│   ├── demand-forecasting.html
│   ├── safety-stock-eoq.html
│   ├── multi-echelon-network.html
│   └── ai-decision-agent.html
├── assets/
│   ├── css/style.css
│   ├── js/main.js
│   └── img/               (copies of real Linchpin screenshots, see §3)
├── upwork/
│   └── profile-content.md
└── README.md               (how to edit content, how to deploy to GH Pages)
```

Plain HTML per page (no templating engine) — content is duplicated in the
shared header/footer markup across 5 pages. Acceptable at this scale (5
pages); if the site grows meaningfully beyond this, a static-site generator
becomes worth the added tooling, but YAGNI for v1.

No client-side framework, no bundler. `<link>`/`<script>` tags reference
`assets/` directly. GitHub Pages serves the repo root as-is once enabled — no
build/deploy pipeline needed.

## 5. Visual design system — Swiss / data-forward

- **Palette:** neutral near-white/near-black base (light + dark mode via
  `prefers-color-scheme` and a manual toggle), one restrained accent color for
  links/highlights/chart accents. Exact token values (defined as CSS custom
  properties in `:root`) chosen during implementation, following the existing
  `--color-*` token pattern from the user's web coding-style conventions.
- **Typography:** max two font families — a grotesk/sans for headings, a
  clean system-first sans for body text, to keep load fast (no external font
  request required; a single self-hosted variable font is acceptable if it
  clearly improves the headline feel).
- **Layout:** 12-column grid, generous whitespace, thin Swiss-style rule
  dividers between sections. Numbers/metrics (the EOQ, safety-stock, tool
  counts) rendered as large display-type figures, not buried in paragraph
  text — data treated as a first-class design element per the case-study
  honesty constraint in §3.
- **Motion:** minimal — fade/slide-in on scroll for case-study cards only,
  compositor-friendly properties (`transform`/`opacity`), disabled under
  `prefers-reduced-motion`.
- **Responsive breakpoints:** 320 / 768 / 1024 / 1440, per standard testing
  convention.

## 6. Upwork content package

`upwork/profile-content.md`, plain Markdown, containing:
- Profile title (one line, keyword-rich — e.g. "Inventory & Supply Chain
  Optimization Specialist | Demand Forecasting, Safety Stock, EOQ").
- Overview/bio — structured paragraph(s) around the four case studies, with
  `[PLACEHOLDER: ...]` markers wherever real biographical detail (name, years
  of experience, education) is needed. The user fills these in before
  publishing.
- Skills tag list, pulled from Linchpin's real capability list (inventory
  optimization, demand forecasting, safety stock, EOQ, DDMRP, multi-echelon,
  ABC-XYZ, Python).
- Four portfolio item blurbs (title + short description + link placeholder to
  the matching case-study page), matching Upwork's portfolio-item format.

This file is not rendered as part of the website — it's a copy-paste source
the user pastes into Upwork's UI by hand.

## 7. Contact & links

No backend. Home page contact section is a `mailto:` link plus placeholder
slots for LinkedIn and Upwork profile URLs (`[PLACEHOLDER: linkedin url]`,
etc.), and a live link to the Linchpin GitHub repo
(`https://github.com/esstipi-debug/linchpin`, confirmed from the README
badge). No certifications section content is included since none exist yet —
a single clearly marked placeholder block is left in `index.html` for the
user to either fill in or delete.

## 8. Testing / verification

Since this is a static site with no backend logic, verification is manual and
visual, per the project's web-testing convention:
- Open each of the 5 pages in the dev preview at 320/768/1024/1440 widths,
  check for overflow and broken layout.
- Verify both light and dark mode render correctly.
- Verify all internal links (home → case studies, case studies → home) and
  the `mailto:` link resolve.
- Verify reduced-motion preference disables scroll animation.
- No automated test suite is warranted for 5 static HTML pages with no logic
  beyond a nav toggle — this is a deliberate scope decision, not an omission.

## 9. Deployment (separate approval gate)

Deployment to GitHub Pages is a follow-up step requiring the user's explicit
go-ahead before any repo is created or pushed publicly:
1. Create a new GitHub repository (public, since GitHub Pages on the free tier
   requires a public repo unless the user has GitHub Pro/Team).
2. Push `portfolio-site` to `main`.
3. Enable GitHub Pages (Settings → Pages → deploy from `main` / root).
4. Confirm the resulting `*.github.io` URL loads correctly.

This spec covers steps 1–8 above (build + local verification) only; step 9 is
executed in a later session once the user reviews the finished site locally.
