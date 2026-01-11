# JCGEImportMPSGE

Placeholder for a converter that lowers MPSGE.jl model objects into JCGE blocks.

Scope:
- Import MPSGE.jl model objects (not the MPSGE language as a first-class input).
- Act as a converter + conformance test harness for block-based models.

Input:
- An `MPSGEModel` object (constructed via MPSGE.jl macros).
- Optional calibration data for complex models (e.g., trade and tax blocks).

Translation:
- sectors/commodities/consumers → corresponding block entities
- each `@production` tree → production block (nest structure + elasticities + quantities)
- each `@demand` → household/institution block (final demands + endowments + transfers)
- taxes/margins (if present) → tax blocks / wedges routed to agents
- numeraire/fixed variables → RunSpec closures/fixes/normalization fields

Output:
- `RunSpec` (what to solve, closures, shocks/scenarios)
- generated block model instance (the “what” to solve)

## API (v0.1)

```julia
using MPSGE
using JCGEImportMPSGE

m = MPSGEModel()
# ... define sectors/commodities/consumers/production/demand with MPSGE.jl macros ...

spec = import_mpsge(m; name="MyMPSGE")
```

## Current coverage

- Scalar sectors, commodities, and consumers
- Fixed-coefficient (Leontief) production from `@production` netputs
- Cobb-Douglas demand from `@final_demand`
- Endowments from `@endowment`
- Commodity market clearing with MCP complementarity (MCP-only import)
- Optional data-assisted import to populate full block sets for complex models

Unsupported MPSGE features (for now):
- Nested production trees (beyond flat netputs)
- Non-Cobb-Douglas demand
- Taxes, margins, and auxiliary constraints
- Multi-region indexing

## Solving

`import_mpsge` always produces an MCP formulation (no objective). Use
PATH via `PATHSolver.Optimizer` to solve the imported model.
