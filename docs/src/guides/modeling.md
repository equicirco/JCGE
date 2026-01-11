# Modeling

This guide outlines a typical modeling workflow in JCGE.

## 1. Start from data

Use `JCGECalibrate` to load a SAM and produce calibrated parameters and
starting values. The canonical input format is described in the Calibration
and Imports guides.

## 2. Build a RunSpec

A RunSpec is the structural description of a model: sets, mappings, sections,
blocks, and closures.

```julia
using JCGECore
using JCGEBlocks

sets = Sets(goods, activities, factors, institutions)
mappings = Mappings(Dict(a => a for a in activities))

prod = production(:prod, activities, factors, goods; form=:cd, params=prod_params)
market = composite_market_clearing(:market, goods, activities)
numeraire = numeraire(:numeraire, :factor, :LAB, 1.0)

sections = [
    section(:production, [prod]),
    section(:markets, [market]),
    section(:closure, [numeraire]),
]

spec = build_spec("MyModel", sets, mappings, sections)
```

## 3. Validate

```julia
using JCGERuntime
report = validate_model(spec)
report.ok || error("Model validation failed")
```

## 4. Solve

```julia
using JCGERuntime, Ipopt
result = run!(spec; optimizer=Ipopt.Optimizer)
```

## 5. Inspect and export

Use `JCGEOutput` to render equations or export results.
