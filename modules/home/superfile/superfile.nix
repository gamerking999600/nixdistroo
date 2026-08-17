{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  superfile = inputs.superfile.packages.${system}.default;
in
{
  home.packages = [
    (superfile.overrideAttrs (oldAttrs: {
      doCheck = false;
      nativeBuildInputs =
        (builtins.filter
          (p: (p.pname or p.name or "") != "go")
          (oldAttrs.nativeBuildInputs or []))
        ++ [ pkgs.go_1_26 ];
    }))
  ];
  xdg.configFile."superfile/config.toml".source = ./config.toml;
}
