# Blocks

Blocks are reusable building blocks that emit equation ASTs and model variables.
A model is assembled by selecting and configuring blocks, then organizing them
into sections (production, households, markets, etc.).

## Forms

Many blocks accept a `form` parameter to choose the functional form (for
example Cobb-Douglas or CES). Use a global form for all items or provide a
per-entity mapping where supported.

## Guidelines

- Blocks should be reusable and model-agnostic.
- Avoid hard-coded sector/factor counts; always work with sets.
- All equations are registered with block and tag metadata to enable rendering
  and reporting.

See the `JCGEBlocks` documentation for the full block catalog and parameters.
