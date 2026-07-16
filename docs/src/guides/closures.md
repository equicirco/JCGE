# Closures and Accounting Checks

JCGE distinguishes conditions that define the solved equilibrium from
identities retained to verify the solution. This keeps a model's complete
equation inventory available for reporting while avoiding redundant solver
constraints.

## Declare roles in the model closure

`JCGECore` identifies an equation by its block name, tag, and indices. Every
condition is solver-enforced by default. Mark only an identity that is implied
by the selected closure as an `:accounting_check`.

```julia
using JCGECore

pool_check = ClosureCondition(:investment_pool, :investment_pool_clearing)
closure = ClosureSpec(:P_HH_COMMON;
    kind = :price_index,
    condition_roles = Dict(pool_check => :accounting_check),
)
```

The key is part of the model specification rather than a solver-specific
exception. The corresponding equation remains visible in generated equation
listings and can be checked after solution.

## Obtain keys from reusable blocks

`JCGEBlocks` provides `closure_condition` so that a model can obtain the same
key used by a block without repeating its name manually:

```julia
using JCGEBlocks

pool_check = closure_condition(pool, :investment_pool_clearing)
market_check = closure_condition(
    market, :regional_composite_market, :g1_r1, :r1)
```

The arguments after the tag are the equation indices. The runtime also exposes
`closure_conditions(ctx)` after a model is built, which is useful for
inspecting the available keys.

## Solve and check residuals

`JCGERuntime.run!` compiles `:enforce` conditions into solver constraints,
retains `:accounting_check` conditions outside the solver, and evaluates their
residuals after a successful solve:

```julia
using JCGERuntime, Ipopt

result = run!(spec; optimizer=Ipopt.Optimizer)
checks = filter(r -> r.role == :accounting_check,
    equation_residuals(result.context))
```

For advanced workflows that call `solve!` directly, call
`evaluate_residuals!(ctx)` before inspecting `equation_residuals(ctx)`.

## Report the closure

`JCGEOutput` can show the role beside every rendered equation and persists
post-solution accounting residuals alongside other results:

```julia
using JCGEOutput

equations = render_equations(result;
    format = :markdown,
    show_condition_roles = true,
)
results = collect_results(result)
checks = results.accounting_checks
```

Accounting checks are included in JSON, CSV, Arrow, Parquet, and DualSignals
exports. In tidy exports their row type is `:accounting_check`; in DualSignals
their absolute residual is recorded as slack and their dual is zero.
