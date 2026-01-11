module JCGECore

export Sets, Mappings, ModelSpec, ClosureSpec, ScenarioSpec, RunSpec
export SectionSpec, RunSpecTemplate, section, template, build_spec
export allowed_sections
export AbstractBlock, calibrate!, build!, report
export validate
export validate_spec
export getparam
export EquationExpr, EIndex, EVar, EParam, EConst, EAdd, EMul, EPow, EDiv, ENeg, ESum, EProd, EEq, ERaw

"Canonical set containers (minimal placeholder)."
struct Sets
    commodities::Vector{Symbol}
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    institutions::Vector{Symbol}
end

"Canonical mapping containers (minimal placeholder)."
struct Mappings
    activity_to_output::Dict{Symbol,Symbol}
end

"Model structure: selected blocks and high-level configuration."
struct ModelSpec
    blocks::Vector{Any}          # typically Vector{<:AbstractBlock}
    sets::Sets
    mappings::Mappings
end

"Closure choices (minimal placeholder)."
struct ClosureSpec
    numeraire::Symbol
end

"Scenario changes (delta relative to baseline; minimal placeholder)."
struct ScenarioSpec
    name::Symbol
    shocks::Dict{Symbol,Any}
end

"Full run specification."
struct RunSpec
    name::String
    model::ModelSpec
    closure::ClosureSpec
    scenario::ScenarioSpec
end

"Named section grouping a set of blocks."
struct SectionSpec
    name::Symbol
    blocks::Vector{Any}
end

"Template for standardized RunSpec assembly."
struct RunSpecTemplate
    name::String
    required_sections::Vector{Symbol}
end

"Canonical section names for RunSpec assembly."
function allowed_sections()
    return [
        :production,
        :factors,
        :government,
        :savings,
        :households,
        :prices,
        :external,
        :trade,
        :markets,
        :objective,
        :init,
        :closure,
    ]
end

"Create a named section."
section(name::Symbol, blocks::Vector{Any}) = SectionSpec(name, blocks)

"Create a template describing required sections."
function template(name::String; required_sections::Vector{Symbol}=Symbol[])
    return RunSpecTemplate(name, required_sections)
end

"Assemble a RunSpec from sections and a template."
function build_spec(
    tpl::RunSpecTemplate,
    sets::Sets,
    mappings::Mappings,
    sections::Vector{SectionSpec};
    closure::ClosureSpec,
    scenario::ScenarioSpec,
    allowed_sections::Vector{Symbol}=Symbol[],
    required_nonempty::Vector{Symbol}=Symbol[],
)
    return build_spec(tpl.name, sets, mappings, sections; closure=closure, scenario=scenario,
        required_sections=tpl.required_sections,
        allowed_sections=allowed_sections,
        required_nonempty=required_nonempty)
end

"Assemble a RunSpec from sections (with optional required section checks)."
function build_spec(
    name::String,
    sets::Sets,
    mappings::Mappings,
    sections::Vector{SectionSpec};
    closure::ClosureSpec,
    scenario::ScenarioSpec,
    required_sections::Vector{Symbol}=Symbol[],
    allowed_sections::Vector{Symbol}=Symbol[],
    required_nonempty::Vector{Symbol}=Symbol[],
)
    seen = Set{Symbol}()
    for sec in sections
        sec.name in seen && error("Duplicate section: $(sec.name)")
        if !isempty(allowed_sections) && !(sec.name in allowed_sections)
            error("Unknown section: $(sec.name)")
        end
        push!(seen, sec.name)
    end
    for req in required_sections
        req in seen || error("Missing required section: $(req)")
    end
    for req in required_nonempty
        req in seen || error("Missing required section: $(req)")
        sec = only(filter(s -> s.name == req, sections))
        isempty(sec.blocks) && error("Section must be non-empty: $(req)")
    end
    blocks = Vector{Any}()
    for sec in sections
        append!(blocks, sec.blocks)
    end
    spec = RunSpec(name, ModelSpec(blocks, sets, mappings), closure, scenario)
    validate(spec)
    return spec
end

"Abstract interface for model blocks."
abstract type AbstractBlock end

"Equation expression AST (backend-agnostic)."
abstract type EquationExpr end

struct EVar <: EquationExpr
    name::Symbol
    idxs::Union{Nothing,Vector{Any}}
end

struct EParam <: EquationExpr
    name::Symbol
    idxs::Union{Nothing,Vector{Any}}
end

struct EConst <: EquationExpr
    value::Real
end

struct ERaw <: EquationExpr
    text::String
end

struct EIndex <: EquationExpr
    name::Symbol
end

struct EAdd <: EquationExpr
    terms::Vector{EquationExpr}
end

struct EMul <: EquationExpr
    factors::Vector{EquationExpr}
end

struct EPow <: EquationExpr
    base::EquationExpr
    exponent::EquationExpr
end

struct EDiv <: EquationExpr
    numerator::EquationExpr
    denominator::EquationExpr
end

struct ENeg <: EquationExpr
    expr::EquationExpr
end

struct ESum <: EquationExpr
    index::Symbol
    domain::Vector{Symbol}
    expr::EquationExpr
end

struct EProd <: EquationExpr
    index::Symbol
    domain::Vector{Symbol}
    expr::EquationExpr
end

struct EEq <: EquationExpr
    lhs::EquationExpr
    rhs::EquationExpr
end

EVar(name::Symbol) = EVar(name, nothing)
EParam(name::Symbol) = EParam(name, nothing)

"Calibration hook (default: not implemented)."
function calibrate!(block::AbstractBlock, data, benchmark, params)
    throw(MethodError(calibrate!, (block, data, benchmark, params)))
end

"Build hook (default: not implemented)."
function build!(block::AbstractBlock, ctx, spec::RunSpec)
    throw(MethodError(build!, (block, ctx, spec)))
end

"Reporting hook (default: not implemented)."
function report(block::AbstractBlock, solution)
    throw(MethodError(report, (block, solution)))
end

"Validate that the RunSpec is structurally consistent (minimal checks)."
function validate(spec::RunSpec)
    isempty(spec.model.sets.commodities) && error("Sets.commodities is empty")
    isempty(spec.model.sets.activities) && error("Sets.activities is empty")
    isempty(spec.model.sets.factors) && error("Sets.factors is empty")
    isempty(spec.model.sets.institutions) && error("Sets.institutions is empty")
    return true
end

"Validate RunSpec structure and closure; returns a report instead of throwing."
function validate_spec(spec::RunSpec; data=nothing)
    report = _new_report()
    structural = _category!(report, :structural)
    closure = _category!(report, :closure)
    accounting = _category!(report, :accounting)

    if isempty(spec.model.blocks)
        push!(structural[:errors], "RunSpec has no blocks")
    end
    if isempty(spec.model.sets.commodities)
        push!(structural[:errors], "Sets.commodities is empty")
    end
    if isempty(spec.model.sets.activities)
        push!(structural[:errors], "Sets.activities is empty")
    end
    if isempty(spec.model.sets.factors)
        push!(structural[:errors], "Sets.factors is empty")
    end
    if isempty(spec.model.sets.institutions)
        push!(structural[:errors], "Sets.institutions is empty")
    end

    num = spec.closure.numeraire
    if !(num in spec.model.sets.commodities || num in spec.model.sets.factors)
        push!(closure[:warnings], "Numeraire $(num) not found in commodities or factors")
    end

    if data === nothing
        push!(accounting[:notes], "No data provided for SAM or flow consistency checks")
    end

    return _finalize_report(report)
end

function _new_report()
    return Dict{Symbol,Dict{Symbol,Vector{String}}}()
end

function _category!(report, name::Symbol)
    if !haskey(report, name)
        report[name] = Dict(
            :errors => String[],
            :warnings => String[],
            :notes => String[],
        )
    end
    return report[name]
end

function _finalize_report(report)
    errors = 0
    warnings = 0
    for cat in values(report)
        errors += length(cat[:errors])
        warnings += length(cat[:warnings])
    end
    return (ok=errors == 0, errors=errors, warnings=warnings, categories=report)
end

"Get parameter values from dict- or table-like containers."
function getparam(params, name::Symbol, idxs...)
    hasproperty(params, name) || error("Missing parameter: $(name)")
    data = getproperty(params, name)
    return getindex(data, idxs...)
end

end # module
