# Blocks

Blocks are reusable building blocks that emit equation ASTs and model variables.
A model is assembled by selecting and configuring blocks, then organizing them
into sections (production, households, markets, etc.). Each block has a clear
responsibility and declares which sets and parameters it requires.

## Forms

Many blocks accept a `form` parameter to choose the functional form (for
example Cobb-Douglas or CES). Use a global form for all items or provide a
per-entity mapping where supported.

Typical forms include:

- Cobb-Douglas for smooth substitution.
- CES for flexible elasticities.
- Leontief for fixed proportions.

## Typical block categories

Most models mix a small set of block categories:

- Production blocks that map inputs to outputs.
- Market clearing blocks for goods and factors.
- Income and demand blocks for institutions.
- Closure and numeraire blocks.
- Auxiliary-quantity blocks for calibrated quantities that must enter model
  equations but are not monetary SAM accounts.

Organize blocks into sections so the model structure is readable and easy to
diagnose.

## Parameterization

Blocks take parameters from calibrated data. Keep parameter names consistent
across blocks so calibration outputs can be reused. Prefer explicit mappings
over implicit defaults when building large models.

## Auxiliary quantities

`quantity_link`, `quantity_transformation`, `quantity_balance`, and
`quantity_capacity` add a small, general algebra for supplementary quantities
that must participate in equilibrium conditions. They are intentionally
domain- and unit-agnostic: mappings define relationships, while coefficients
and capacities are supplied by the model's calibration data.

Use a link to connect a quantity to an existing model variable, a
transformation for coefficient-based conversion, a signed balance for an
identity, and a capacity for an upper limit. Inputs must be defined by an
earlier block. Use these blocks only when the quantity changes the equilibrium
system; use `JCGEOutput` satellite reporting when the quantity is reported
from solved model drivers without adding an equilibrium condition.

## Extending blocks

Custom blocks can be created by following the same interface as the built-ins:
declare required sets, map parameters, and emit equation ASTs. This makes new
components fully compatible with the runtime and output tooling.

## Guidelines

- Blocks should be reusable and model-agnostic.
- Avoid hard-coded sector/factor counts; always work with sets.
- All equations are registered with block and tag metadata to enable rendering
  and reporting.
- `closure_condition(block, tag, indices...)` constructs the stable key for an
  equation when a model needs to mark it as an accounting check.

See [Closures & Checks](closures.md) for the role declaration and runtime
behaviour.

See the `JCGEBlocks` documentation at <https://Blocks.JCGE.org> for the full block
catalog and parameters.
