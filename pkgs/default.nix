{ pkgs, ... }: {
  gruvbox-plus = pkgs.callPackage ./gruvbox-plus { };
  sddm-sugar-dark = pkgs.callPackage ./sddm-sugar-dark { };
}
