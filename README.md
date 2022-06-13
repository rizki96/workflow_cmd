# WorkflowCmd

> **workflow_cmd** is a tool to execute your workflow scripts. 
> The workflow is meant to be a glue to combine many services and APIs. 
> But unlike any other workflows that being executed on the cloud servers or services, **workflow_cmd** can be executed on your own computers or servers.

*workflow_cmd* utilising [Workflow DSL](https://github.com/rizki96/workflow_dsl) and running as a binary command line, with features : 
- [x] single binary executable
- [x] domain specific language based on Google Cloud Workflows
- [x] template rendering
- [x] docker support
- [ ] command prompt

## Download Binary Executable

- Windows 10 :
    - > mkdir C:\worfklow
    - > cd C:\workflow
    - download https://github.com/rizki96/workflow_cmd/releases/latest/download/workflow_cmd.zip and copy the file to C:\workflow
    - > unzip workflow_cmd.zip
    - > workflow_cmd
- MacOSX (M1 Rosetta) :
    - > brew update
    - > brew install rizki96/wffw/workflow_cmd
    - > workflow_cmd

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
- > MIX_ENV=prod mix release.nix
- > ./_build/prod/rel/bakeware/workflow_cmd

## Domain Specific Language

Based on [`Google Cloud Workflows`](https://cloud.google.com/workflows/docs/reference/syntax).
Examples :
- https://github.com/rizki96/workflow_dsl/tree/master/examples

## Template Rendering

Using [Liquid](https://shopify.github.io/liquid/) template.
Example :
- https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow1.json
- [Sending Email Blast https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow3.json](https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow3.json)

## Docker Support

Requirement: Install [Docker Desktop](https://www.docker.com/products/docker-desktop) in your Laptop / PC.
Example :
- [Docker Hello World https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow2.json](https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow2.json)
- [Sending Whatsapp Blast https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow4.json](https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow4.json)
