# AI Agent Interface

`JCGEAgentInterface` is the JCGE entry point for AI assistants and other
Model Context Protocol (MCP) clients. It exposes a standard stdio MCP server
over JCGE services, so agents can discover the active JCGE environment, inspect
available modeling components, guide model development, solve registered models,
validate solved contexts, and render equations and outputs.

The package-level documentation is available at <https://AgentInterface.JCGE.org>.

## What the Agent Interface Provides

The interface is designed around JCGE's model-as-code approach. It helps users
work with explicit Julia models rather than replacing the economic modeling
decision.

It currently provides services for:

- discovering installed JCGE package versions and capabilities;
- listing and describing reusable `JCGEBlocks` components;
- guiding model development, formulation choice, solver choice, calibration, and
  reporting;
- updating released JCGE packages in the active Julia environment when requested;
- solving registered `RunSpec` models through `JCGERuntime`;
- validating solved model contexts;
- rendering equations, symbol tables, and output artifacts through `JCGEOutput`.

The interface does not automatically create a complete CGE model, choose the
right closure, fetch arbitrary external data, or decide the economic theory for
the user. Those choices remain part of the model source.

## Install the Julia Package

Add the package to the Julia environment used for model development:

```julia
import Pkg
Pkg.add("JCGEAgentInterface")
```

To start the MCP server from the active Julia environment:

```julia
using JCGEAgentInterface
serve(transport = :mcp_stdio)
```

For an MCP client configuration, the same command can be launched from the shell:

```sh
julia --project=/path/to/model -e 'using JCGEAgentInterface; serve(transport=:mcp_stdio)'
```

Using the model project as the active Julia environment is important when the
agent needs to solve project-specific models. The server can only solve models
that are available and registered in the running `AgentContext`.

## Use the Registered MCP Server

The release workflow publishes a versioned container image to GitHub Container
Registry and registers the server in the
[official MCP Registry](https://registry.modelcontextprotocol.io/?q=io.github.equicirco%2FJCGEAgentInterface.jl)
under:

```text
io.github.equicirco/JCGEAgentInterface.jl
```

The container image has the form:

```text
ghcr.io/equicirco/jcge-agentinterface-mcp:<release-version>
```

MCP clients that support registry discovery can use the registered server name.
The container can also be run directly as a stdio server:

```sh
docker run --rm -i ghcr.io/equicirco/jcge-agentinterface-mcp:<release-version>
```

The plain container is useful for discovery and guidance tools. Solving
project-specific models requires a Julia environment or wrapper package that
registers those models with the server.

## Main Tools

The MCP tool surface includes:

| Tool | Purpose |
|:---|:---|
| `jcge_capabilities` | Discover JCGE package capabilities and versions. |
| `jcge_list_blocks` | List reusable block helpers grouped by model component. |
| `jcge_describe_block` | Describe one block helper or block type. |
| `jcge_modeling_guide` | Guide the JCGE model-development workflow. |
| `jcge_formulation_guide` | Guide equality, inequality, MCP/complementarity, and optimization-style formulations. |
| `jcge_solver_guide` | Guide solver choice and diagnostics. |
| `jcge_calibration_guide` | Guide currently available calibration workflows. |
| `jcge_reporting_guide` | Guide generated equation and results reporting. |
| `jcge_package_status` | Report installed and loaded JCGE package versions. |
| `jcge_update_packages` | Dry-run or apply updates for released JCGE packages. |
| `jcge_list_models` | List registered models. |
| `jcge_load_model` | Load a registered model by name. |
| `jcge_solve` | Solve a loaded or named model. |
| `jcge_validate_model` | Validate the last solved context. |
| `jcge_render_model` | Render equations, blocks, or symbols. |
| `jcge_export_results` | Return tidy results from the last solve. |

See the package documentation for the complete action API and current limits:
<https://AgentInterface.JCGE.org>.
