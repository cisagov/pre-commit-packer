# pre-commit-packer #

[![GitHub Build Status](https://github.com/cisagov/pre-commit-packer/workflows/build/badge.svg)](https://github.com/cisagov/pre-commit-packer/actions)

This is a set of [pre-commit](https://pre-commit.com) hooks intended for
projects using [Packer](https://www.packer.io/).

## Available Hooks ##

| Hook name                                        | Description                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `packer_fmt`                                  | Rewrites all Packer configuration files to a canonical format.                                                          |
| `packer_validate`                             | Validates all Packer configuration files.                                                                               |

## Usage ##

```yaml
repos:
  - repo: https://github.com/cisagov/pre-commit-packer
    rev: <version> # Version from https://github.com/cisagov/pre-commit-packer/releases
    hooks:
      - id: packer_fmt
      - id: packer_validate
        args:
          - '--args=--var-file=inputs/dev.pkrvars.hcl'
```

## Notes about the `packer_fmt` hook ##

This hook scans any files in the packer configuration ending in `packer.json`,`.pkr.hcl`
and `.pkrvars.hcl` and applies packer formatting.

## Notes about the `packer_validate` hook ##

1. `packer_validate` supports custom arguments so you can pass supported
no-color or json flags.

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

1. `packer_validate` also supports custom environment variables passed to
the pre-commit runtime

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

1. `packer_validate` also supports custom arguments allowing to choose
the input pkrvars.hcl passed to the pre-commit runtime to validate your packer configuration

    1. Example:

    ```yaml
    hooks:
      - id: packer_validate
        args:
          - '--args=--var-file=inputs/dev.pkrvars.hcl'
    ```

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
