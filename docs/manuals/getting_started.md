# GETTING STARTED #

* Currently workflow_cmd supports for 3 platform, which is windows, macosx and linux.
* You can install workflow_cmd by execute the installation binary or compile it from source. For windows and macosx there are a binary distributions for each platform. If you want to install it on linux, you have to compile it from the source.
* Install using binary installation :
  - Windows 10 (manually download the workflow_cmd binary):
    - create directory for your working space, ex: C:\workflow
    - download https://github.com/rizki96/workflow_cmd/releases/latest/download/workflow_cmd.zip and copy the file to C:\workflow
    - unzip workflow_cmd.zip on C:\workflow
    - open command prompt window, try to execute the workflow_cmd file in command prompt 
      ```console
        > cd C:\workflow
        > workflow_cmd
      ```

  - Windows 10 (chocolatey):
    - install chocolatey (https://chocolatey.org/)
    - open command prompt and execute below command:
      ```console
        > choco install workflow_cmd
        > workflow_cmd
      ```
    - create your working space, ex: C:\workflow

  - MacOSX (brew M1 Rosetta)
    - install brew (https://brew.sh/)
    - open comamnd shell, and execute below command :
      ```console
        > brew update
        > brew install rizki96/wffw/workflow_cmd
        > workflow_cmd
      ```

* Install from the source :
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
        > ./workflow_cmd
      ```
