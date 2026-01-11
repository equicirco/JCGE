# Output & Reporting

`JCGEOutput` provides backend-agnostic rendering and results containers.

## Equation rendering

```julia
using JCGEOutput
text = render_equations(result; format=:markdown)
```

Rendered equations are derived from the equation AST, not solver objects.

## Results containers

Results are stored in a canonical `Results` object with primals/duals and
metadata. Export helpers include JSON, CSV, Arrow/Parquet, and a tidy
long-table form for analysis.

## SAM-style reporting

`sam_from_solution` can map model flows back to a SAM-like table. This is
optional and may be incomplete if the model does not track all flows.
