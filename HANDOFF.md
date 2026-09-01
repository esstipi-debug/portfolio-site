# HANDOFF — Portfolio site + Linchpin benchmark/audit work

> Session-to-session context for a fresh Claude Code session with no prior
> conversation history. Read this before doing anything else. If something
> here is stale, fix it in the same commit that changed the underlying fact.

## TL;DR — where things stand

A freelance portfolio site for Inventory/SCM specialist work (Upwork-focused)
is **built, reviewed, and locally verified** — 6 pages, real numbers only,
nothing fabricated. Two supporting PRs are open on the Linchpin repo with
**green CI**, not yet merged. A HeroUI-inspired button/card visual restyle
(`docs/superpowers/specs/2026-07-21-heroui-inspired-button-card-restyle-design.md`)
also landed since the previous version of this handoff — additive vanilla-CSS
only, no React/build step adopted (see that spec for why).

**`build-site` merged to `master` (fast-forward) and deleted; `master` pushed
to a new public GitHub repo, https://github.com/esstipi-debug/portfolio-site**
— the site is no longer local-only. **Not deployed to GitHub Pages yet** (that
remains a separate, explicitly-gated step). **Placeholder content is still
live and now publicly visible on GitHub** — `Marcos Stipicich`, `marcos.stipicic@gmail.com`,
LinkedIn/Upwork URLs, etc. across all 6 pages (search `class=""` /
`[PLACEHOLDER:`) — fill these in before pointing anyone at the repo or
enabling Pages.

**The very next planned step (not yet started): Phase 2 — translate the site
into es/pt/zh/ja.** A design was proposed to the user (language-folder
architecture, precomputed language-switcher links, hreflang tags,
glossary-first translation) but **not yet approved** when this handoff was
written — confirm/re-propose it before writing any translated pages.

## What exists right now

### 1. Portfolio site (this repo, `C:\Users\Gamer\Music\scm\portfolio-site`)

- Now on `master` (`build-site` was merged in fast-forward and deleted).
  Remote: `origin` → https://github.com/esstipi-debug/portfolio-site (public).
  Pushed. **Not deployed to GitHub Pages yet** — separate, explicitly-gated step.
- 6 HTML pages, all cross-verified in-browser (zero console errors, zero
  failed requests, no overflow at 320/768/1024/1440px), Swiss/data-forward
  design system, light+dark mode, `prefers-reduced-motion` respected:
  - `index.html` — hero, about, skills, 5-card case-study index, contact
  - `case-studies/demand-forecasting.html`
  - `case-studies/safety-stock-eoq.html`
  - `case-studies/multi-echelon-network.html`
  - `case-studies/ai-decision-agent.html`
  - `case-studies/audit-evidence.html` — **marked "In Development"**, the
    only case study that isn't a fully live capability (see PR #122 below)
- `assets/css/style.css`, `assets/js/main.js`, `assets/img/*.png` (6 real
  screenshots from the Linchpin repo, no stock imagery/mockups)
- `upwork/profile-content.md` — copy-paste Upwork profile content, **English
  only, deliberately not translated** (Upwork profiles are single-language)
- Every page still has live `[PLACEHOLDER: ...]` / `.placeholder`-marked
  content (name, bio, years of experience, email, LinkedIn/Upwork URLs,
  certifications) — **the user has not filled these in yet.** Search for
  `class=""` across all HTML files before publishing.
- Design spec: `docs/superpowers/specs/2026-07-08-portfolio-site-design.md`
- Implementation plan: `docs/superpowers/plans/2026-07-08-portfolio-site.md`
- Built via `superpowers:subagent-driven-development` (10 tasks, each
  individually reviewed, one fix loop on Task 4). Ledger (historical, task
  IDs won't mean anything new):
  `.superpowers/sdd/progress.md`

### 2. Linchpin PR #123 — comparison benchmarks (NOT merged, CI green)

`https://github.com/esstipi-debug/linchpin/pull/123`, branch
`feat/benchmark-old-vs-linchpin`, worktree at
`C:\Users\Gamer\Music\scm\.wt-benchmarks`. **Draft, CI green on
3.11/3.12/3.13 + GitGuardian**, not marked ready, not merged — needs an
explicit decision (mark ready + merge, or leave as-is) from the user.

Adds to the Linchpin engine:
- `src/safety_stock.py::achieved_service_level()` (new, TDD'd)
- `src/benchmarks.py::compare_forecast_methods()` (new module, TDD'd)
- `scripts/benchmark_forecast_m5.py` (new — real M5-competition backtest,
  not runnable in CI since the M5 data is gitignored)
- 4 new exercises (7–10) in `case-studies/CASE_STUDIES.md`

**Why this matters for the portfolio:** the 4 English case studies' "How
this compares" sections cite real numbers from this PR, and link to
`github.com/esstipi-debug/linchpin/blob/main/case-studies/CASE_STUDIES.md`
— which **will not show Exercises 7–10 until PR #123 merges to `main`**.
Low urgency (the portfolio isn't deployed yet either), but merge #123 before
the site goes live, or those links look broken/incomplete to a visitor.

Design spec: `supply-chain-optimization/.wt-benchmarks/docs/superpowers/specs/2026-07-08-comparison-benchmarks-design.md`
Plan: `.../docs/superpowers/plans/2026-07-08-comparison-benchmarks-plan.md`

### 3. Linchpin PR #122 — audit-evidence vertical (owned by a different/concurrent session)

`https://github.com/esstipi-debug/linchpin/pull/122`, branch
`claude/linchpin-audit-evidence-gj1mhc`, worktree at
`C:\Users\Gamer\Music\scm\.wt-audit-evidence`. **This PR belongs to a
separate, concurrent Claude Code session** (per this repo's own documented
"genuinely concurrent sessions" gotcha) — this session only contributed one
file to it, at the user's explicit request:
`documentation/paquetes/evidencia-auditoria-inventario.md` (a proposed
commercial-package one-pager, honestly marked "en desarrollo, no es un
paquete ejecutable todavía" since the job/tool wiring for `audit_evidence`
isn't done — only the pure engine + 30 tests have landed). CI is green.
**Do not assume ownership of this PR or merge it** — that's the other
session's call.

## Real numbers reference (already verified, cite these verbatim — don't re-derive)

| Case study | Real number | Source |
|---|---|---|
| Demand Forecasting | ~19% lower MAE and demand-weighted WAPE vs. naive persistence; -3.2% on unweighted per-SKU-average WAPE specifically (explained artifact, not hidden) | PR #123, Exercise 10, `scripts/benchmark_forecast_m5.py --sample-size 100 --seed 42` |
| Safety Stock | Naive "20% of demand" rule achieves ~78.8% service level vs. 95% target | PR #123, Exercise 7 |
| EOQ | Round-lot Q=500 costs ~29% more than EOQ-optimal Q*=239 | PR #123, Exercise 8 |
| Multi-Echelon | No-pooling costs €520 vs. GSM-optimal €485 (~6.7% reduction) | PR #123, Exercise 9 (also pinned by `test_gsm_case4_all_downstream_cost`, pre-existing) |
| AI Agent | 35+ tools, 1,100+ tests (site copy; live repo count has since drifted to 36 — "35+" is a safe lower bound, not stale) | `supply-chain-optimization/README.md` / `CLAUDE.md` |
| Audit Evidence | 30 tests; MUS zero-error reliability factor 3.00 at 5% risk; attribute sample sizes 29/59 at 95%/10%-5% TDR — all match published AICPA reference values | PR #122, `src/audit_evidence.py` + `tests/test_audit_evidence.py` |

## Phase 2 — multilingual translation (proposed, not yet executed)

Design proposed to the user, not yet confirmed as of this handoff:

- **Architecture:** English stays at the repo root (already built, don't
  move it). Add sibling folders `es/`, `pt/`, `zh/`, `ja/`, each a full
  translated copy of all 6 pages (`index.html` + 5 `case-studies/*.html`) =
  **24 new pages**.
- **Language switcher:** compact `EN · ES · PT · ZH · JA` control in the
  header nav on every page (30 pages total), each link precomputed to the
  *same page* in that language. Relative-path depth varies by page type —
  compute these centrally, don't trust per-page generation to get the `../`
  math right across 30 files.
- **SEO:** `hreflang` alternate tags in every page's `<head>`, plus
  `x-default` → English.
- **Consistency:** lock a glossary per language for shared strings (nav
  items, section headings like "Problem"/"Method"/"Result", button labels)
  *before* translating any page content, so parallel translation doesn't
  produce inconsistent wording for the same UI string across pages.
- **Scope:** the website only. `upwork/profile-content.md` stays
  English-only (user-confirmed).
- **Quality caveat already given to the user:** translations will be done
  directly, but a native-speaker review pass before publishing to real
  clients was flagged as worth doing, especially for zh/ja.
- Given the scale (24 new pages, highly parallelizable, 2 non-Latin
  scripts), this is a good candidate for the Workflow tool rather than
  task-by-task subagent-driven-development (translation isn't really a TDD
  problem) — glossary-first, then parallel per-page translation, then a
  structural + consistency QA pass.

**Before starting:** re-confirm this design with the user (it may have
changed since this handoff was written), and re-derive the exact language-
switcher href table for all 30 pages before generating any translated file.

## Operational gotchas (read before running anything)

- **Preview tool / `.claude/launch.json`:** the `mcp__Claude_Preview__*`
  tools resolve `.claude/launch.json` relative to the **workspace root**
  (`C:\Users\Gamer\Music\scm`), one level *above* this repo — not relative
  to `portfolio-site` itself. A working config already exists there (not
  part of this repo, not committed): serves `portfolio-site` via
  `python -m http.server 8000 --directory portfolio-site`. `preview_start({name: "portfolio"})` should just work; if it doesn't, recreate that
  workspace-root file.
- **Linchpin work has no venv per worktree.** Both `.wt-benchmarks` and
  `.wt-audit-evidence` (and any future worktree) share the **main
  checkout's** venv: use
  `"C:\Users\Gamer\Music\scm\supply-chain-optimization\.venv\Scripts\python.exe"`
  and `"...\.venv\Scripts\ruff.exe"` explicitly, with `PYTHONPATH` pointed
  at the worktree root (not the main checkout), so tests exercise the code
  actually being changed.
- **Real M5 competition data already exists locally**, gitignored, at
  `supply-chain-optimization/data/kaggle/m5/m5/datasets/` (
  `sales_train_evaluation.csv` + `calendar.csv`, 1946 columns = 5 id columns
  + `d_1`..`d_1941`, genuine 28-day held-out actuals at `d_1914`-`d_1941`).
  No Kaggle credentials are available in this environment — don't try to
  re-fetch; copy from that path into any new worktree that needs it instead.
- **This machine runs genuinely concurrent Claude Code sessions** on the
  Linchpin repo (confirmed twice this session: PR #122 belongs to another
  session; the main checkout had pre-existing untracked files from other
  work that were left untouched). Always `git fetch` + check for drift on
  `origin/main` immediately before pushing or opening/updating a PR, not
  just at the start of a task.
- **ASCII-only in any new Python `print()`/console output** on this Windows
  machine (cp1252 breaks on em dashes) — Markdown files written as UTF-8
  are fine. This portfolio site's HTML/CSS/JS is UTF-8 throughout and that's
  fine too (browsers, not a Windows console, render it).
- **Never push straight to `main`** on the Linchpin repo — feature branch →
  draft PR → CI green → explicit user go-ahead → mark ready → squash-merge.
  The portfolio-site repo has no remote yet, so this doesn't apply there
  until one exists.
- Both `.wt-benchmarks` and `.wt-audit-evidence` are real git worktrees
  (`git worktree list` from the main checkout shows both) — don't delete
  them casually; they're live checkouts of open PR branches.

## Explicit gates — do not do these without asking first

- Creating a GitHub repo for `portfolio-site` and pushing it (site has no
  remote at all right now).
- Deploying to GitHub Pages.
- Merging PR #123 (CI is green, but merging is still the user's call) or
  running `gh pr ready`/`gh pr merge` on it.
- Touching or merging PR #122 (not this session's PR to manage).
- Filling in any placeholder content with invented values — those are the
  user's real name/bio/contact info, never guess them.
