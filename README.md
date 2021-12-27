# WorkflowCmd

[Workflow DSL](https://github.com/rizki96/workflow_dsl) running as a binary command line, with features : 
- [x] single binary executable
- [x] domain specific language based on Google Cloud Workflows
- [ ] template rendering
- [ ] database command and query

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
    - > /usr/local/Cellar/workflow_cmd/0.1.0/bin/workflow_cmd

## Domain Specific Language

Examples : 
- https://github.com/rizki96/workflow_dsl/tree/master/examples

## Template Rendering

- TODO
