# Calibration

`JCGECalibrate` converts SAM and IO data into calibrated parameters and starting
values. The calibration process is model-agnostic but assumes a canonical input
schema.

## Inputs

- `sam.csv`: square SAM matrix with labeled rows/columns
- `sets.csv`: canonical lists of goods, activities, factors, and institutions
- Optional: `subsets.csv`, `labels.csv`, `mappings.csv`, `params.csv`

## Typical workflow

```julia
using JCGECalibrate
sam = load_sam_table("path/to/sam.csv"; goods=..., factors=...)
start = compute_starting_values(sam)
params = compute_calibration_params(sam, start)
```

Calibration is deterministic and should produce a consistent benchmark that
satisfies model accounting identities.
