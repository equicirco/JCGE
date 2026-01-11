# JCGE.jl Roadmap

## Scope
JCGE.jl is a modular, block-based framework for building and running computable general equilibrium (CGE) models in Julia.

## Monorepo structure
- `packages/`: independently testable Julia packages (Core, Calibrate, Kernel, Blocks, Circular)
- `JCGEExamples`: runnable reference models and scenarios
- `docs/`: documentation sources (optional)
- `scripts/`: developer utilities (optional)
- `data/`: tiny toy datasets only (no large or proprietary files)

## Near-term milestones
1. Establish a minimal internal data model and validation (JCGECore).
2. Implement calibration helpers for standard functional forms (JCGECalibrate).
3. Implement a JuMP runtime with variable/constraint registries and diagnostics (JCGERuntime).
4. Implement a minimal set of standard blocks (JCGEBlocks).
5. Add MCP passthrough for AI agents (JCGEAgentInterface).
6. Add MPSGE.jl model-object importer as a converter + conformance harness (JCGEImportMPSGE).
7. Add backend-agnostic output/reporting utilities (JCGEOutput).
   - Step 3: SAM/IO reporting with valuation modes `:model` (numeraire units) and `:baseline` (rescaled to base SAM using calibration prices).
   - Requires a calibration link (e.g., `StartingValues`/baseline prices) for real-value reconstruction.
8. Add data import utilities that emit canonical JCGE CSV datasets (JCGEImportData).
   - Maintain adapter skeletons (Eurostat/GTAP) with a mapping checklist:
     classifications → IO bundle → canonical CSVs.
6. Provide a tiny end-to-end example in `JCGEExamples` using a toy SAM.
7. Port an existing JuMP CGE model into `JCGEExamples` as the first real model-driven development target.

## Definition of done (v0.1)
- One toy SAM example runs end-to-end and replicates the benchmark within tolerance.
- Basic validation and diagnostics are present (Walras check, budget balance residuals).
- Each package has tests and minimal documentation.
# Project Objective (Non-negotiable)
- This is a block-based CGE tool. Every model must be expressed as a composition of reusable blocks.
- No standalone model implementations outside the block system; library/examples only wire blocks.
