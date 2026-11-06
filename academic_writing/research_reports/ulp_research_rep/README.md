# ULP Research Report — English LaTeX Edition

This is the completed report based on the supplied `ulp_research_rep.rar` template and the ULP research documents. The document is written in English and retains the original template's document class and cover layout. It credits **Lucas Martins Rocha** as indicated by the provided research manuscript.

## Files

- `func_nummet_report.tex` — main LaTeX entry point
- `ic-relatorio.cls`, `relatorio.sty`, `mathconfig.sty` — original LaTeX template, minimally localized to English
- `chapters/` — abstract, introduction, theory, experimental methodology, results, discussion, conclusions, reproducibility appendix
- `refs.bib` — cited bibliography
- `figs/` — nine figures in English
- `scripts/generate_figures.py` — reproducible figure generator; also checks the 780 power-of-two samples
- `scripts/source_validation/` — English-commented adaptation of the supplied large-scale validation code (not rerun in full)

## Build

A TeX Live environment with `latexmk` and `biber` is required.

```bash
python -m pip install numpy matplotlib
python scripts/generate_figures.py
latexmk -pdf -interaction=nonstopmode -file-line-error func_nummet_report.tex
```

The class uses BibLaTeX with the `biber` backend; `latexmk` invokes it when needed.

## Research provenance and editorial boundaries

- The original paper reports **1,611** tested increments in each precision; these full validations were **not** rerun during preparation of this report.
- The 780-case power-of-two experiment **was** regenerated and matched the report: 379 preserved, 371 absorbed, 28 ties toward zero, and 2 ties upward.
- Static English figures reconstruct the experiments and observations in the supplied Plotly charts and book; the original HTML dashboards are not bundled as they retain Portuguese labels.
- The main model assumes a reused stored power, round-to-nearest ties-to-even, and (for the simple nearest-grid formula) a sum that stays in its input binade with `y >= c`.
- **Cover identity:** the original CEFET-MG logo artwork is part of the user-supplied class. No institutional affiliation or supervisor was supplied for Lucas Martins Rocha, so the title page does not claim one. Confirm intended branding before publication.
