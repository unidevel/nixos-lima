# Run NixOS on a Lima VM

Heavily inspired from [patryk4815/ctftools](https://github.com/patryk4815/ctftools/tree/master/lima-vm)

## Generating the image

On a linux machine or ubuntu lima vm for example:

```bash
# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon
# enable kvm feature
echo "system-features = nixos-test benchmark big-parallel kvm" >> /etc/nix/nix.conf
reboot

# build image
nix --extra-experimental-features nix-command --extra-experimental-features flakes build .
cp $(readlink result)/nixos.qcow2 /tmp/lima/nixos-aarch64.qcow2
```

On your mac:

- Move `nixos-aarch64.qcow2` under `imgs`

## Running NixOS

```bash
limactl start --name=default nixos.yaml

lima
# switch to this repo directory
nixos-rebuild switch --flake .#nixos --use-remote-sudo
```
