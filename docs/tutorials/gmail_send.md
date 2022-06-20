# SEND BULK EMAILS WITH GMAIL #

* Read the [Introduction](https://github.com/rizki96/workflow_cmd/blob/master/docs/manuals/intrduction.md) for the details on **workflow_cmd**
* Or directly follow the **workflow_cmd** installation steps in [Getting Started](https://github.com/rizki96/workflow_cmd/blob/master/docs/manuals/getting_started.md) manual.
* Follow the tutorial for getting an App Password with gmail account (https://evermap.com/Tutorial_AMM_UseAppPasswords.asp). Stop until step number 6.
* Setup a directory to be your workspace and download below files into your workspace 
  - https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow3.json
  - https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow3/contacts.csv
  - https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow3/message.html.tmpl
  - https://raw.githubusercontent.com/rizki96/workflow_cmd/master/examples/workflow3/message.tmpl
* Create password.json with below content 
  ```console
    {
    "gmail": "xxxxxxxxxx"
    }
  ```
  replace xxxxxxxxxx with your Gmail App password
* Edit workflow3.json and replace any directories inside json file with your current directory, for example change below section
  ```console
    {
        "define_password": {
          "call": "file.read",
          "args": {
            "input_path": "examples/password.json",
            "read_as": "json"
          },
          "result": "password_storage"
        }
      },
      {
        "define_var": {
            "call": "file.read",
            "args": {
                "input_path": "examples/workflow3/contacts.csv",
                "read_as": "csv"
            },
            "result": "array_var"
        }
    },
  ```
  into
  ```console
    {
        "define_password": {
          "call": "file.read",
          "args": {
            "input_path": "password.json",
            "read_as": "json"
          },
          "result": "password_storage"
        }
      },
      {
        "define_var": {
            "call": "file.read",
            "args": {
                "input_path": "contacts.csv",
                "read_as": "csv"
            },
            "result": "array_var"
        }
    },
  ```
  Please change also the template location from
  ```console
    {
        "write_message": {
            "call": "template.render",
            "args": {
                "template_path": "examples/workflow3/message.tmpl",
                "output_path": "${\"output/workflow3/message\" + string(i) + \".out\"}"
            },
            "result": "rendered_content",
            "next": "write_html"
        }
    },
    {
        "write_html": {
            "call": "template.render",
            "args": {
                "template_path": "examples/workflow3/message.html.tmpl",
                "output_path": "${\"output/workflow3/message\" + string(i) + \".html\"}"
            },
            "result": "rendered_html",
            "next": "send_email"
        }
    },
  ```
  into
  ```console
    {
        "write_message": {
            "call": "template.render",
            "args": {
                "template_path": "message.tmpl",
                "output_path": "${\"output/message\" + string(i) + \".out\"}"
            },
            "result": "rendered_content",
            "next": "write_html"
        }
    },
    {
        "write_html": {
            "call": "template.render",
            "args": {
                "template_path": "message.html.tmpl",
                "output_path": "${\"output/message\" + string(i) + \".html\"}"
            },
            "result": "rendered_html",
            "next": "send_email"
        }
    },
  ```
