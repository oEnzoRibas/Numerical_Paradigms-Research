# ULP numerical experiments — fully reproducible Jupyter notebooks

Based on the supplied materials by Lucas Martins Rocha (November 2026):
`artigo_ulp.pdf`, `relatorio_ulp.pdf`, `livro_previa.pdf`, `ulp.ipynb`, four Plotly `.html` exports, and the English LaTeX report.

## Quick start

Requirements: Python **3.10+** with NumPy, pandas, Matplotlib, Jupyter/IPython, ipykernel and nbclient.

```bash
python -m pip install -r requirements.txt
jupyter lab
```

Open `notebooks/00_ULP_and_IEEE754.ipynb` and run **Kernel → Restart Kernel and Run All Cells**. Proceed through notebooks 01 to 05. The six `.ipynb` files are **already executed with outputs saved**, so you can also read them before running anything.

To rerun all six notebooks and regenerate the images and CSV files without manually opening Jupyter:

```bash
python run_all_notebooks.py
```

The code works with a Jupyter server started from the project directory or from the `notebooks` directory. To run a notebook outside this directory, keep `src/ulp_lab.py` alongside its project folder structure.

## Notebooks

| Notebook | Topic | Regenerated PNG files |
| --- | --- | --- |
| `00_ULP_and_IEEE754.ipynb` | Binary32/binary64 ULP staircase and binades | `01_ulp_staircase.png` |
| `01_Powers_of_Two.ipynb` | 780-case classification, four rounding outcomes, continuous curves | `02_power_two_map.png`, `03_power_two_curves.png` |
| `02_Odd_Integers.ipynb` | Odd-integer staircase, table for `c=101`, odd-integer error map | `04_odd_integer_curves.png`, `05_odd_integer_heatmap.png` |
| `03_Fractions.ipynb` | Dyadic vs intended non-dyadic fractions, odd reciprocals | `06_fraction_behaviour.png`, `09_reciprocal_odd_fractions.png` |
| `04_Precision_and_Rounding.ipynb` | Comparison of precisions; measured normalized ULP error | `07_precision_comparison.png`, `08_ulp_sawtooth.png` |
| `05_Full_Validation.ipynb` | Independent checks for 1,611 increments per precision (3,222 pairs total) | Saves validation data as CSV |

All nine filenames are deliberately identical to the images under `ulp_research_rep/figs/` in the previously created English LaTeX project. If you want to refresh that report's figures, copy the PNG files from `figures/` into its `figs/` folder (overwriting the previous versions), then recompile your LaTeX document.

## Sources of results and reproducibility

The `results/` folder contains raw classification tables, thresholds, relative errors, measured sawtooth points, and one validation record per tested input/precision. In particular:

- `01_powers_of_two_780_cases.csv` reproduces the original **379/371/28/2** classification counts.
- `02_c101_by_binade.csv` independently samples each predicted binade for `c=101`.
- `05_validation_per_increment.csv` records **3,222 rows** (1,611 inputs × 2 precisions).
- `05_validation_summary.csv` groups successes, sampled points, and excluded points per family and precision.

In the full validation notebook, `SAMPLES_PER_BINADE=1500` matches the lower bound of the reported methodology's sampling rate (1,500–4,000 samples per binade). Change to `3000` to match the supplied reference validation script's normal setting.

The random input generator is seeded with **42**, and both precisions use the same generated input list to allow paired comparison. This differs slightly from the supplied book's validation code, which consumes an advancing global generator between precisions. Therefore exact *per-sample* counts near binade boundaries can differ, even when the important numerical results agree.

The sources' statement that the model matched all 1,611 cases per precision is **independently checked here for the model's stated validity domain**. The program excludes and counts points with `y<c` or where adding `c` crosses the current binade upper boundary. It does **not** claim the simple rounding rule is exact in those excluded regions; the source paper treats those separately.

A precision nuance: constants such as `0.1` and `1/3` are mathematically non-dyadic but are stored as dyadic approximations in binary floating-point. Predicted limits therefore use the **actual stored** `np.float64(c)` or `np.float32(c)`. The subtraction and power use the selected NumPy dtype and a single shared stored `y`.

## Package structure

```
ULP_Jupyter_Reproducibility/
├── README.md
├── requirements.txt
├── run_all_notebooks.py
├── notebooks/    # six executed Jupyter notebooks
├── src/          # shared helper + archived reference implementations
├── figures/      # all nine regenerated PNG figures
└── results/      # detailed CSV files
```

These figures are **new renders computed from the experiments**, not byte-for-byte copies of the original HTML exports. Matplotlib layout/colors differ from Plotly, and there may be slight numerical differences across platforms.
