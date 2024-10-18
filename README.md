# pre-commit-packer #

[![GitHub Build Status](https://github.com/cisagov/pre-commit-packer/workflows/build/badge.svg)](https://github.com/cisagov/pre-commit-packer/actions)

This is a set of [pre-commit](https://pre-commit.com) hooks intended for
projects using [Packer](https://www.packer.io/).

## Available Hooks ##

> [!NOTE]
> You can pass arguments to these hooks through the normal use of the `args` block
> in your pre-commit configuration. These arguments should align with whatever options
> you wish to pass to the underlying `packer` command. However, any arguments that
> take values must be in the form `-argument=value` rather than `-argument value`
> to ensure proper processing.

### `packer_fmt` ###

This hook ensures that any `.pkr.hcl` or `.pkrvars.hcl` files are properly formatted
using the `packer fmt` command. The hook will update files by default, but that
behavior can be overridden by changing the arguments passed to the hook.

### `packer_validate` ###

This hook checks that a Packer configuration is valid by running `packer validate`
against any directory that houses `.pkr.hcl` files.

> [!NOTE]
> The hook will change to each directory and run `packer init` before running
> `packer validate`.

## Usage ##

```yaml
repos:
  - repo: https://github.com/cisagov/pre-commit-packer
    rev: v0.2.0
    hooks:
      - id: packer_fmt
      - id: packer_validate
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
