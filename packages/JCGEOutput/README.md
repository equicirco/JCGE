# JCGEOutput

Backend-agnostic output and reporting utilities for JCGE.

## 1) Equation and block rendering (model introspection)

Render the generated system (or each block) to:
- Markdown with MathJax/LaTeX fragments
- LaTeX document snippets
- plain text (debug)

Recommended API surface:

```
render_equations(model; format=:markdown, level=:block|:equation, show_defs=true)
render_block(model, block_id; format=:markdown)
```

Include symbol tables: variables, parameters, indices/sets, domain restrictions.

Key design point: render from a stable internal equation AST (not solver-specific
objects), so it works regardless of backend.

## 2) Results container + persistence

Canonical results object (backend-agnostic):
- primals (levels), duals (multipliers), reduced costs, complement status where relevant
- metadata: scenario id, calibration hash, solver info, timestamps, units/currency,
  numeraire, closure flags

Exports:
- `to_json`, `to_jld2`, `to_arrow`/`to_parquet` (tabular), `to_csv` (basic)
- “tidy” long-table form: `(symbol, index_tuple, value, kind=:level|:dual|:param|...)`

Integration: `DualSignals.jl` adapters should live here to reuse its
saving/analysis utilities.

## 3) SAM/IO-style reporting (including “dump solution back to a SAM”)

```
sam_from_solution(base_sam, solution; method=:levels|:pct_change, closure=...,
                  valuation=..., include_taxes=true)
```

Outputs:
- SAM table (matrix) for the counterfactual
- decomposition table (differences, % differences)

Boundary conditions:
- Only populate entries that are model-backed.
- Optionally compute residuals and report imbalance diagnostics.
- Optional RAS balancing only if explicitly decided; many projects prefer to keep
  balancing in calibration tooling.

Status: stub package (no API yet).
