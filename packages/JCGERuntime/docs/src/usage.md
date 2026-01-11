# Usage

`JCGERuntime` compiles RunSpecs and executes solver runs.

## Solve a model

```julia
using JCGERuntime, Ipopt
result = run!(spec; optimizer=Ipopt.Optimizer)
```

## Validation

```julia
report = validate_model(spec)
```

## Compilation hooks

Use `compile!` and `build_model!` for advanced workflows that need direct access
to the JuMP model or solver options.

