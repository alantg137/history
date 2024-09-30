This is a demo of how to use [Nix](https://nixos.org/) to start
writing documents in LaTeX.

1. Install Nix or NixOS.
2. Clone this repository.
3. Run "nix-shell" to install a basic LaTeX environment (it will take a while to download/build everything).

Now, you can type `make` to build everything or something like

```
make output/hello.pdf
```

to build a specific document.
