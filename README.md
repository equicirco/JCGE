# JCGE.jl

JCGE.jl is a modular, block-based framework for building and running computable general equilibrium (CGE) models in Julia.

## Repository layout
- `packages/`: independently testable Julia packages
  - `JCGECore`: canonical data model and interfaces (no JuMP)
  - `JCGECalibrate`: calibration utilities for standard functional forms (no JuMP)
  - `JCGEKernel`: JuMP-facing kernel (model building, closure, diagnostics)
  - `JCGEBlocks`: standard CGE blocks built on the interfaces
  - `JCGECircular`: circular-economy extension blocks
- `examples/`: runnable reference models and scenarios
- `docs/`: documentation sources (optional)
- `scripts/`: developer utilities (optional)
- `data/`: tiny toy datasets only (no large/proprietary files)

## Status
Pre-release. APIs are unstable until a tagged v0.1.
