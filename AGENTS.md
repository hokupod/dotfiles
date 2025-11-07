# Repository Guidelines

## Project Structure & Module Organization
`flake.nix` is the entry point for Home Manager; it exposes the `mac` configuration assembled from `home/common.nix` and `home/darwin.nix`. Config files intended for `$HOME` live under mirrored directories (`dot_config/`, `dot_vim/`, `dot_claude/`, `dot_gemini/`); keep paths aligned with the hidden targets they represent (for example, `dot_config/nvim` ➜ `~/.config/nvim`). Legacy Vim assets sit in `dot_vim/`, while Neovim-specific Lua and tooling are in `dot_config/nvim`. The bootstrap script `setup.sh` creates the symlinks for non-flake setups; update it when new dot directories appear.

## Build, Test, and Development Commands
- `home-manager switch --flake .#mac` rebuilds and activates the full Home Manager profile for the mac host.
- `nix run .#homeConfigurations.mac.activationPackage` builds the activation package without switching, useful for CI smoke checks.
- `nix flake check` ensures the flake definitions evaluate cleanly before you push.
- `./setup.sh` links vim/neovim dotfiles directly when Home Manager is unavailable.

## Coding Style & Naming Conventions
Prefer two-space indentation in Nix modules and keep attribute sets alphabetized when practical to avoid churn. Shell scripts should remain POSIX-friendly (`bash` shebang is standard here) and use `set -euo pipefail` when adding new logic. For Vimscript and Lua configs, follow existing naming (e.g., `*.lua` files in `lua/` and `ftplugin/` directories) and keep AI-related settings under `aibou`, `gemini`, or `claude` namespaces. Keep mirrored directory names prefixed with `dot_` to signal their destination.

## Testing Guidelines
Run `nix flake check` after modifying any Nix module. When touching editor configuration, launch `nvim` with `NVIM_APPNAME=dot_config/nvim` to confirm startup health. For shell helpers or scripts, add lightweight `bash -n script.sh` syntax checks and, where feasible, capture example runs in comments or docs.

## Commit & Pull Request Guidelines
Follow the conventional format visible in the log (`feat(scope): short summary`). Use present tense, limit summaries to ~72 characters, and expand on motivation in the body if needed. Pull requests should: describe the change set, note validation steps (`nix flake check`, manual editor tests, etc.), and link any related issues or external references. Include screenshots only when UI-facing behavior is affected (e.g., terminal UI themes or prompt tweaks).

## Agent-Specific Instructions
Keep AI assistant configurations (`dot_claude/`, `dot_gemini/`) in sync with Neovim bindings defined under `dot_config/nvim/lua`. When introducing new agents, document keybindings in the appropriate README or module comments and ensure secrets stay out of the repo—prefer environment variables or Home Manager options.
