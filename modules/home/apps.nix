{ pkgs, config, inputs, ... }:
{

  home.packages = with pkgs; [
    # Communication
   # teamspeak6-client
   # teamspeak3
    
    # GUI
    wlogout
    rofi
    kitty
    foot
    tor-browser
    hyprpaper
    fastfetch
    waybar
    mako
    cava
    
    # Development
    android-tools
   # rustup
    godot
    git
    arduino-ide
    pipx
    rustc
  cargo
  rustfmt
  clippy
  rust-analyzer
  python3
  chromedriver
    
    
    # Utilities
    qpwgraph
    bluejay
    slurp
    grim
    wl-clipboard
    nixfmt
    file-roller
    nemo-fileroller
    qalculate-gtk
    copyq
    pavucontrol
    kdiskmark
    zoxide
    ffmpeg
    wget
    playerctl
    renderdoc
    libnotify
    sox
    gopeed
    fsearch
    chromium
    bun
    kdePackages.k3b
    cdrkit
    dvdplusrwtools
    libburn
    grimblast
    swappy
    wl-clipboard
    slurp
    nodejs
    glib
    android-tools
    jdk
    glib.dev
    libvirt
    pkgs.qemu
    
  #  yt-dlp
   # jq
    #curl
    
    

    
    # Media
    vlc
    linux-wallpaperengine
    inputs.yt-x.packages."${system}".default
    pkgs.stremio-linux-shell

   
    
    # Gaming
    osu-lazer-bin
    lutris
    gamescope
    retroarch
    libretro.citra
   
    
    # Creation
    blender
    

  ];
home.sessionPath = [
  "${config.home.homeDirectory}/.bun/bin"
];



}
