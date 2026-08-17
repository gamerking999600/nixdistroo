{ pkgs, inputs, ... }:
let
  spicetifyPkgs =
    inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  pioneerVFD = pkgs.fetchFromGitHub {
    owner = "adainstarks";
    repo = "PioneerVFD";
    rev = "0ebdb2e82a012a2d1f03facb572738dd4b270b24";
    hash = "sha256-8Uy2UmZmYoyUvdP/+rJhuA2OIlEKyCH2zCmMIkEtlHI="; # fix after first rebuild
  };
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;

    # PioneerVFD theme
    theme = {
      name = "PioneerVFD";
      src = pioneerVFD + "/Themes/PioneerVFD";
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = true;
      overwriteAssets = true;
      additionalCss = "";
    };

    enabledCustomApps = with spicetifyPkgs.apps; [
      marketplace
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

      # PioneerVFD extension
      {
        src = pioneerVFD + "/Extensions";
        name = "pioneerVFD.js";
      }
    ];

    # Hamsters Dancing snippet
    enabledSnippets = [
      ''
        .player-controls .playback-progressbar { position: relative; }
        .player-controls .playback-progressbar::before {
          content: '''';
          width: 80px;
          height: 80px;
          bottom: calc(100% - 20px);
          left: 0;
          position: absolute;
          background-size: 80px 80px;
          background-image: url('https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExdXk2NW15cTJrdjF0YjZ5eTBjODE0M2l3ejg3bDlvYWh5NmVub2l0eCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/s7pdNRdwG1zxdwkazY/giphy.gif');
          pointer-events: none;
          z-index: 0;
        }
        .player-controls .playback-progressbar::after {
          content: '''';
          width: 80px;
          height: 80px;
          bottom: calc(100% - 23px);
          right: 0;
          position: absolute;
          background-size: 80px 80px;
          background-image: url('https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExamN4OWxiOXY4dHZ5Mm90NjU5ZjhwcjV1dDd3dHdveHFkaGYzbGRmaSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/VxovskkECK4egQCltk/giphy.gif');
          pointer-events: none;
          z-index: 0;
        }
      ''
    ];
  };
}
