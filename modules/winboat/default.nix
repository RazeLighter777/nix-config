{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.winboat;
  
  # Create the winboat package
  winboatPkg = pkgs.stdenv.mkDerivation rec {
    pname = "winboat";
    version = "1.2.4"; # You may need to update this version
    
    src = pkgs.fetchurl {
      url = "https://github.com/TibixDev/winboat/releases/download/v${version}/winboat-${version}-x64.tar.gz";
      sha256 = "0wnbdnm1w59xyhw55bqac0jak16nvcs91qixnxyrnq2b46gpvmg0"; # You may need to update this hash
    };
    
    nativeBuildInputs = with pkgs; [
      makeWrapper
      freerdp3
      usbutils
      libusb1
    ];
    
    buildInputs = with pkgs; [ 
      electron 
      gcc 
      glibc 
      stdenv.cc.cc.lib 
    ];

    # Create required data files
    usb_ids = builtins.toFile "usb.ids" ''
      # Placeholder USB IDs file
      # This would normally contain USB device information
    '';

    # Create a placeholder icon (you might want to download the actual icon)
    iconFile = pkgs.writeText "winboat-icon.png" ''
      # Placeholder for icon file
      # You should replace this with the actual icon file
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/winboat
      (cd . && tar cf - .) | (cd $out/share/winboat && tar xf -)
      
      cat > $out/bin/winboat <<EOF
#!/bin/sh
export LD_LIBRARY_PATH=${pkgs.gcc}/lib:${pkgs.glibc}/lib:${pkgs.electron}/lib:${pkgs.stdenv.cc.cc.lib}/lib:\$LD_LIBRARY_PATH
exec ${pkgs.electron}/bin/electron $out/share/winboat/resources/app.asar "\$@"
EOF
      chmod +x $out/bin/winboat
       
      mkdir -p $out/share/icons/hicolor/256x256/apps
      mkdir -p $out/share/winboat
       
      # Use a simple text file as placeholder icon
      echo "WinBoat Icon" > $out/share/icons/hicolor/256x256/apps/winboat.png
      echo "WinBoat Icon" > $out/share/winboat/icon.png
       
      # desktop entry
      mkdir -p $out/share/applications
      cat > $out/share/applications/winboat.desktop <<EOF
[Desktop Entry]
Name=WinBoat
Comment=Run Windows apps on Linux with seamless integration
Exec=$out/bin/winboat %U
Type=Application
Terminal=false
Icon=winboat
Categories=Utility;System;
StartupNotify=true
EOF

      mkdir -p $out/share/winboat/data
      mkdir -p $out/share/winboat/resources/data

      echo "# USB IDs placeholder" > $out/share/winboat/data/usb.ids
      echo "# USB IDs placeholder" > $out/share/winboat/resources/data/usb.ids

      mkdir -p $out/lib/guest_server

      # Handle guest_server directory if it exists
      if [ -d guest_server ]; then
        cp -a guest_server/. $out/share/winboat/resources/guest_server/
        cp -a guest_server/. $out/share/winboat/guest_server/
        cp -a guest_server/. $out/lib/guest_server/
      elif [ -d resources/guest_server ]; then
        cp -a resources/guest_server/. $out/share/winboat/resources/guest_server/
        cp -a resources/guest_server/. $out/share/winboat/guest_server/
        cp -a resources/guest_server/. $out/lib/guest_server/
      else
        # Create empty guest_server directories if source doesn't exist
        mkdir -p $out/share/winboat/resources/guest_server
        mkdir -p $out/share/winboat/guest_server
        mkdir -p $out/lib/guest_server
      fi
    '';

    meta = with pkgs.lib; {
      description = "WinBoat - Run Windows apps on Linux with seamless integration";
      homepage = "https://github.com/TibixDev/winboat";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
      maintainers = [ ];
    };
  };
in
{
  options.my.winboat.enable = lib.mkEnableOption "Enable WinBoat - Run Windows apps on Linux";
  
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ winboatPkg ];
    
    # Enable required services/features that WinBoat might need
    virtualisation.libvirtd.enable = lib.mkDefault true;
    
    # Add the user to necessary groups for virtualization
    users.users.${config.my.user.name} = {
      extraGroups = [ "libvirtd" ];
    };
  };
}