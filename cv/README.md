# Abdelrahman Wageh Mohamed — CV (Teaching Assistant)

A clean, single-page, ATS-friendly CV targeting a **Teaching Assistant** role in
Computer Science.

## Files

- `Abdelrahman_Wageh_CV_TeachingAssistant.tex` — LaTeX source.
- `Abdelrahman_Wageh_CV_TeachingAssistant.pdf` — Compiled PDF.

## Highlights

- Positioned as a **Computer Science graduate** (B.Sc. in AI & Data Science),
  **graduated June 2026** from the **Egypt-Japan University of Science and
  Technology (E-JUST)**.
- Targeted at a **Teaching Assistant** position, leading with a dedicated
  **Teaching Experience** section (Junior Teaching Assistant + Online Tutor).
- Dedicated **Graduation Project** section describing *Smartino*, an AI-powered
  educational app.
- Skills grouped to emphasize **Mathematics**, **Artificial Intelligence /
  Machine Learning**, and **Programming & Problem-Solving**.

## How to build

The CV uses only standard LaTeX packages. Compile with `pdflatex`:

```bash
pdflatex Abdelrahman_Wageh_CV_TeachingAssistant.tex
```

Required packages: `lmodern`, `microtype`, `geometry`, `enumitem`, `titlesec`,
`xcolor`, `hyperref` (all included in a standard TeX Live installation, e.g.
`texlive-latex-base`, `texlive-latex-recommended`, `texlive-latex-extra`,
`texlive-fonts-recommended`).

## Editing tips

- To adjust an entry, edit the `\role{Title}{Dates}{Organization}{Location}`
  command followed by its bullet list.
- Keep bullets concise; the layout is tuned to fit on a single page.
