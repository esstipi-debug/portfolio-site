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

```bash
python -m http.server 8000
```

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
