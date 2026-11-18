# kpozin/tap

Homebrew formulae for [Sprawl Guard](https://github.com/kpozin/sprawl-guard), which checks that
source files stay short and directories stay small.

## Install

```sh
brew install kpozin/tap/sprawl-guard
```

The formula installs the prebuilt binary from the Sprawl Guard release for macOS or Linux, on Arm
or Intel. On Arm Linux, it needs glibc 2.39 or later, as in Ubuntu 24.04.

## Updates

Publishing a Sprawl Guard release opens a pull request here that moves the formula to the new
version. To move it yourself, run `bin/bump-sprawl-guard vVERSION` with an authenticated `gh`,
replacing `VERSION` with the release's version. Report problems with the formula in the
[Sprawl Guard issue tracker](https://github.com/kpozin/sprawl-guard/issues).
