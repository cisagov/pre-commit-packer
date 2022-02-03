# pre-commit-packer #

[![GitHub Build Status](https://github.com/cisagov/pre-commit-packer/workflows/build/badge.svg)](https://github.com/cisagov/pre-commit-packer/actions)

This is a set of [pre-commit](https://pre-commit.com) hooks intended for
projects using [Packer](https://www.packer.io/).

## Available Hooks ##

| Hook name         | Description                                                                           |
| ----------------- |---------------------------------------------------------------------------------------|
| `packer_validate` | Validate all Packer templates.                                                        |
| `packer_fmt`      | Check that Packer HCL templates are properly formatted, formatting files when needed. |

## Usage ##

```yaml
repos:
  - repo: https://github.com/cisagov/pre-commit-packer
    rev: v0.0.2
    hooks:
      - id: packer_validate
        args:
          - manual_file_entry
      - id: packer_fmt
```

## Notes about the `packer_validate` hook ##

This hook matches any paths ending in `packer.json` and `.pkr.hcl` by default.
File paths can be added for checking manually as additional arguments.

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
