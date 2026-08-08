# NixOS-WSL config

Slim CLI setup for WSL2 + systemd (zsh, tmux, nvim, opencode). User `max`.

## WSL quickstart (from Windows)

1. On Windows, push your config to GitHub:

   ```sh
   git add -A && git commit -m "config" && git push
   ```

2. Inside WSL, copy the config:

   ```sh
   git clone https://github.com/MaximAvetisyan/nixos-config.git ~/.config/nixos-config
   ```

3. First rebuild:

   ```sh
   sudo nixos-rebuild switch --flake ~/.config/nixos-config#wsl
   ```

Done. Open a new shell — you get `update` (rebuild), `clean`, and `cs`
(tmux session with nvim, zsh, opencode).

## Building nixos.wsl on bare metal (any Nix machine)

Build the NixOS-WSL image on a desktop or any Nix machine:

```sh
cd ~/.config/nixos-config
nix flake lock                       # generates flake.lock on first run
sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
```

The result is `./nixos.wsl`. Copy it to Windows and either double-click it
(WSL >= 2.4.4) or run:

```powershell
wsl --install --from-file nixos.wsl
```

Then set your password: `wsl -d NixOS` -> `sudo passwd max`.
