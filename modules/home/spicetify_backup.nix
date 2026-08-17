{ pkgs, inputs, ... }:
let
  spicetifyPkgs =
    inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];
  programs.spicetify = {
    enable = true;

    
      enabledCustomApps = with spicetifyPkgs.apps; [
    marketplace  
    Visualizer
  ];
  
    enabledExtensions = with spicetifyPkgs.extensions; [
      keyboardShortcut
      shuffle
      seekSong
      hidePodcasts
      adblock
      volumePercentage
      queueTime
      autoSkipVideo
      playNext
     
    ];
    programs.spicetify.themes = {
    name = ""
	};
  };
}
