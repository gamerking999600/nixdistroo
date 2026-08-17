{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  powerManagement.cpuFreqGovernor = "performance"; 
  
users.users.hashim.extraGroups = [ "wheel" "cdrom" "dialout" "networkmanager" "libvirtd" "adbusers" "docker"];



  
  services.udev.extraRules = ''
    # ESP32 CP210x
    SUBSYSTEM=="usb", ATTR{idVendor}=="10c4", ATTR{idProduct}=="ea60", MODE="0666", GROUP="dialout"
    # CH340 / CH341
    SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="7523", MODE="0666", GROUP="dialout"
    # General USB serial
    KERNEL=="ttyUSB*", MODE="0666", GROUP="dialout"
  '';

services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # === Steam + WiVRn for Meta Quest 3S ===
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
      '';
    };
  };
  # Setuid wrappers for K3b burning (required on   # Setuid wrappers for K3b / burning
  security.wrappers = {
    wodim = {
      source = "${pkgs.cdrkit}/bin/wodim";
      setuid = true;
      owner = "root";
      group = "cdrom";
    };
    cdrecord = {
      source = "${pkgs.cdrkit}/bin/cdrecord";
      setuid = true;
      owner = "root";
      group = "cdrom";
    };
  };
  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;

    # Uncomment the next line ONLY if you have an NVIDIA GPU (for better AV1 encoding)
     package = pkgs.wivrn.override { cudaSupport = true; };
  };

  # Required for Quest 3S wireless discovery
  services.avahi.enable = true;
  
  virtualisation.docker.enable = true;
  
  
    # Portals + Polkit for graphical sudo/pkexec apps on Hyprland
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];
fileSystems."/mnt/old-ubuntu" = {
  device = "/dev/disk/by-uuid/4a7f3276-da3e-43e9-94f0-d86eccb90468";
  fsType = "ext4";
  options = [ "rw" "nofail" "users" "exec" ];
};

fileSystems."/home/hashim/.ollama" = {
    device = "/mnt/old-ubuntu/home/hashim/.ollama";
    fsType = "none";
    options = [ "bind" "nofail" ];
  };
  

 services.ollama = {
  enable = false;
  package = pkgs.ollama-cuda;   # Use CUDA version for your RTX 4060
  host = "0.0.0.0";
  };
  
}
