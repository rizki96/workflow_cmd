# WorkflowCmd

> **workflow_cmd** is a tool to execute your workflow scripts. 
> The workflow is meant to be a glue to combine many services and APIs. 
> But unlike any other workflows that being executed on the cloud servers or services, **workflow_cmd** can be executed on your own computers or servers.

**workflow_cmd** is utilizing [Workflow DSL](https://github.com/rizki96/workflow_dsl) and running as a binary command line, with features : 
- [x] single binary executable
- [x] domain specific language based on Google Cloud Workflows
- [x] template rendering
- [x] docker support
- [ ] command prompt

## Download Binary Executable

  - Windows 10 (manually download the workflow_cmd binary) :
    - create directory for your working space, ex: C:\workflow
    - download https://github.com/rizki96/workflow_cmd/releases/latest/download/workflow_cmd.zip and copy the file to C:\workflow
    - unzip workflow_cmd.zip on C:\workflow
    - open command prompt window, try to execute the workflow_cmd file in command prompt
      ```console
        > cd C:\workflow
        > workflow_cmd
      ```

  - MacOSX (M1 Rosetta) :
    - install brew (https://brew.sh/)
    - open comamnd shell, and execute below command :
      ```console
        > brew update
        > brew install rizki96/wffw/workflow_cmd
        > workflow_cmd
      ```

## Build From Source

  - Linux (generic)
    - install erlang and elixir (https://elixir-lang.org/install.html)
    - open command shell, create your working directory on your home directory
      ```console
        > mkdir workflow
        > cd workflow
        > git clone https://github.com/rizki96/workflow_cmd.git
        > cd workflow_cmd
        > mix deps.get
        > MIX_ENV=prod mix release.nix
        > tar -xzvf workflow_cmd.tar.gz
        > mv workflow_cmd ..
        > cd ..
        > ./workflow_cmd
      ```

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
