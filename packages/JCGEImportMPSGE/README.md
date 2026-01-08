# JCGEImportMPSGE

Placeholder for a converter that lowers MPSGE.jl model objects into JCGE blocks.

Scope:
- Import MPSGE.jl model objects (not the MPSGE language as a first-class input).
- Act as a converter + conformance test harness for block-based models.

Input:
- An `MPSGEModel` object (constructed via MPSGE.jl macros).

Translation:
- sectors/commodities/consumers → corresponding block entities
- each `@production` tree → production block (nest structure + elasticities + quantities)
- each `@demand` → household/institution block (final demands + endowments + transfers)
- taxes/margins (if present) → tax blocks / wedges routed to agents
- numeraire/fixed variables → RunSpec closures/fixes/normalization fields

Output:
- `RunSpec` (what to solve, closures, shocks/scenarios)
- generated block model instance (the “what” to solve)

Status: stub package (no API yet).
