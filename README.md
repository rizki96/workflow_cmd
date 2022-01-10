# WorkflowCmd

[Workflow DSL](https://github.com/rizki96/workflow_dsl) running as a binary command line, with features : 
- [x] single binary executable
- [x] domain specific language based on Google Cloud Workflows
- [x] template rendering
- [x] docker support
- [ ] command prompt

## Build From Source
Windows8 / Windows10:
- install chocolatey
- > choco install -y elixir git zstandard make mingw
- > git clone https://github.com/rizki96/workflow_cmd.git
- > cd workflow_cmd
- > set MAKE=make
- > set CC=gcc
- > mix deps.get
- > mix release.win
- Copy the binary to C:\ directory:
- > mkdir c:\workflow
- > copy _build/prod/rel/bakeware/workflow_cmd C:\workflow
- > C:\workflow\workflow_cmd

MacOSX:
- install brew
- > brew install elixir git zstd
- > git clone https://github.com/rizki96/workflow_cmd.git
- > cd workflow_cmd
- > mix deps.get
- > MIX_ENV=prod mix release.mac
- > ./_build/prod/rel/bakeware/workflow_cmd

## Download Binary Executable

- [Windows10](https://github.com/rizki96/workflow_cmd/releases/download/v0.1.0/workflow_cmd-win10.zip)
- MacOSX (M1 Rosetta) :
    - > brew install rizki96/wffw/workflow_cmd
    - > workflow_cmd

## Domain Specific Language

Based on [`Google Cloud Workflows`](https://cloud.google.com/workflows/docs/reference/syntax).
Examples :
- https://github.com/rizki96/workflow_dsl/tree/master/examples

## Template Rendering

Using [Liquid](https://shopify.github.io/liquid/) template.
Example :
- https://github.com/rizki96/workflow_cmd/blob/master/examples/workflow1.json

## Docker Support

Requirement: Install Docker Desktop in your Laptop / PC.
Example :
- [Docker Hello World https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow2.json](https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow2.json)
