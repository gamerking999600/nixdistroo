{ pkgs, ... }:

pkgs.appimageTools.wrapType2 {
  pname = "mourn";
  version = "1.0.23";

  src = /home/hashim/Downloads/mourn_1.0.23_amd64.AppImage;
  # or, better for reproducibility, use fetchurl if you have a stable download URL:
  # src = pkgs.fetchurl {
  #   url = "https://.../mourn_1.0.23_amd64.AppImage";
  #   sha256 = "276212d2890e01101239376bf3b3b749d79748feb65eb7b6897586899f980a3a";
  # };

  extraPkgs = pkgs: with pkgs; [
    # start empty, add libs here if it fails to launch
  ];
}
