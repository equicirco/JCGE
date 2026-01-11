# Imports

JCGE provides two import paths: data ingestion and MPSGE model conversion.

## Data import (IO/SAM)

`JCGEImportData` defines a canonical CSV schema and helpers to build a SAM
from IO tables. It is designed for adapters that extract data from external
sources like Eurostat or GTAP.

Key outputs:
- `sam.csv`
- `sets.csv`
- optional labels, subsets, mappings, and parameters

## MPSGE import

`JCGEImportMPSGE` converts an `MPSGE.jl` model object to a JCGE RunSpec.
This is a converter and conformance bridge, not a competing authoring format.

Typical flow:

```julia
using MPSGE, JCGEImportMPSGE
m = MPSGEModel()
# build MPSGE model...
run_spec = import_mpsge(m)
```

When the source model is complementarity-based, the importer emits MCP blocks
so the model can be solved with PATHSolver.
