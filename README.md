# Collection of git hooks for Packer to be used with [pre-commit framework](http://pre-commit.com/)

## How to install

### 1. Install dependencies

* [`pre-commit`](https://pre-commit.com/#install)
* [`coreutils`](https://formulae.brew.sh/formula/coreutils) required for `packer_validate` hook on macOS (due to use of `realpath`).

##### MacOS

```bash
brew install pre-commit pre-commit coreutils
```

### 2. Install the pre-commit hook globally

```bash
DIR=~/.git-template
git config --global init.templateDir ${DIR}
pre-commit init-templatedir -t pre-commit ${DIR}
```

### 3. Add configs and hooks

Step into the repository you want to have the pre-commit hooks installed and run:

```bash
git init
cat <<EOF > .pre-commit-config.yaml
repos:
- repo: https://github.com/schniber/pre-commit-packer
  rev: <VERSION> # Get the latest from: https://github.com/schniber/pre-commit-packer/releases
  hooks:
      - id: packer_fmt
      - id: packer_validate
        args:
          - '--args=--var-file=inputs/dev.pkrvars.hcl'
EOF
```

### 4. Run

After pre-commit hook has been installed you can run it manually on all files in the repository

```bash
pre-commit run -a
```

## Available Hooks

There are several [pre-commit](https://pre-commit.com/) hooks to keep Packer configurations (both `*.pkr.hcl` and `*.pkrvars.hcl`) and Packer json configurations (`packer*.json`) in a good shape:

| Hook name                                        | Description                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `packer_fmt`                                  | Rewrites all Packer configuration files to a canonical format.                                                          |
| `packer_validate`                             | Validates all Packer configuration files.                                                                               |

Check the [source file](https://github.com/schniber/pre-commit-packer/blob/master/.pre-commit-hooks.yaml) to know arguments used for each hook.

## Notes about packer_fmt hooks

1. `packer_fmt` automatically scans for *.pkr.hcl files and locates the subfolder containing the *.pkrvars.hcl files before applying the Packer Formatting.

    1. Example:
    ```yaml
    hooks:
      - id: packer_fmt
    ```

## Notes about packer_validate hooks

1. `packer_validate` supports custom arguments so you can pass supported no-color or json flags.

    1. Example:
    ```yaml
    hooks:
      - id: packer_validate
        args: ['--args=-json']
    ```

    In order to pass multiple args, try the following:
    ```yaml
     - id: packer_validate
       args:
          - '--args=-json'
          - '--args=-no-color'
    ```
1. `packer_validate` also supports custom environment variables passed to the pre-commit runtime

    1. Example:
    ```yaml
    hooks:
      - id: packer_validate
        args: ['--envs=AWS_DEFAULT_REGION="us-west-2"']
    ```

    In order to pass multiple args, try the following:
    ```yaml
     - id: packer_validate
       args:
          - '--envs=AWS_DEFAULT_REGION="us-west-2"'
          - '--envs=AWS_ACCESS_KEY_ID="anaccesskey"'
          - '--envs=AWS_SECRET_ACCESS_KEY="asecretkey"'
    ```

1. `packer_validate` also supports custom arguments allowing to choose the input pkrvars.hcl passed to the pre-commit runtime to validate your packer configuration

    1. Example:
    ```yaml
    hooks:
      - id: packer_validate
        args:
          - '--args=--var-file=inputs/dev.pkrvars.hcl'
    ```

Enjoy the clean & valid packer code!
