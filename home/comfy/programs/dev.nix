let
home = import <home-manager-config>;
in
{ pkgs, ... }: {
  home.packages = with pkgs; [
    deno
    nodejs_20
    yarn

    tmux
    lazygit

    glow

    neovide

    rnix-lsp

    lua-language-server

    jq
    tldr

    git-cliff
  ];
}
