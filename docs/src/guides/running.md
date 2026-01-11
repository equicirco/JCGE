# Running Models

The `JCGEExamples` package provides reference models ported from the literature.
Each model exposes a `model`, `baseline`, and `solve` entry point.

```julia
using JCGEExamples

result = JCGEExamples.StandardCGE.solve()
```

## Solvers

- NLP models: Ipopt (`Ipopt.Optimizer`)
- MCP models: PATHSolver (`PATHSolver.Optimizer`)

PATHSolver requires a license for larger problems. You can provide the license
via environment variable:

```bash
export PATH_LICENSE_STRING="<LICENSE STRING>"
```

If the problem is small enough, PATHSolver can run without a license.
