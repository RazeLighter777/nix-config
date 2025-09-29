{ config, lib, pkgs, ... }:
let 
  cfg = config.my.dodCerts;
  
  # Download and extract DoD certificates
  dodCerts = pkgs.stdenv.mkDerivation {
    pname = "dod-cac-certificates";
    version = "2025";
    
    src = pkgs.fetchurl {
      url = "https://militarycac.com/maccerts/AllCerts.zip";
      sha256 = "sha256-sHuQeJwvOdt3yiajCpKoUXCO5hXyI1I18JhnhBut+sw=";
    };
    
    nativeBuildInputs = [ pkgs.unzip pkgs.openssl ];
    
    unpackPhase = ''
      runHook preUnpack
      unzip $src
      runHook postUnpack
    '';
    
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/ca-certificates/dod
      
      # Convert .cer files (DER format) to PEM format
      for cerfile in *.cer; do
        if [ -f "$cerfile" ]; then
          # Get a clean name for the certificate
          basename_no_ext=$(basename "$cerfile" .cer)
          clean_name=$(echo "$basename_no_ext" | tr ' ' '_' | tr -cd '[:alnum:]_-')
          
          # Convert DER to PEM format
          openssl x509 -inform DER -in "$cerfile" -outform PEM -out "$out/share/ca-certificates/dod/''${clean_name}.crt" 2>/dev/null || \
          openssl x509 -inform PEM -in "$cerfile" -outform PEM -out "$out/share/ca-certificates/dod/''${clean_name}.crt" 2>/dev/null || \
          echo "Warning: Could not process $cerfile"
        fi
      done
      
      # Ensure we have the root certificates with consistent names
      if [ -f "$out/share/ca-certificates/dod/DoDRoot3.crt" ]; then
        cp "$out/share/ca-certificates/dod/DoDRoot3.crt" "$out/share/ca-certificates/dod/DoD_Root_CA_3.crt"
      fi
      if [ -f "$out/share/ca-certificates/dod/DoDRoot4.crt" ]; then
        cp "$out/share/ca-certificates/dod/DoDRoot4.crt" "$out/share/ca-certificates/dod/DoD_Root_CA_4.crt"
      fi
      if [ -f "$out/share/ca-certificates/dod/DoDRoot5.crt" ]; then
        cp "$out/share/ca-certificates/dod/DoDRoot5.crt" "$out/share/ca-certificates/dod/DoD_Root_CA_5.crt"
      fi
      if [ -f "$out/share/ca-certificates/dod/DoDRoot6.crt" ]; then
        cp "$out/share/ca-certificates/dod/DoDRoot6.crt" "$out/share/ca-certificates/dod/DoD_Root_CA_6.crt"
      fi
      
      runHook postInstall
    '';
    
    meta = with lib; {
      description = "Department of Defense Common Access Card certificates";
      homepage = "https://militarycac.com/";
      license = licenses.publicDomain;
      platforms = platforms.all;
    };
  };
in {
  options.my.dodCerts.enable = lib.mkEnableOption "Enable DoD CAC certificate trust";
  
  config = lib.mkIf cfg.enable {
    # Add DoD certificates to system trust store
    # We'll include all the major root certificates from the package
    security.pki.certificateFiles = [
      "${dodCerts}/share/ca-certificates/dod"
    ];
    
    # Make certificates available for applications
    environment.systemPackages = [ dodCerts ];
    
    # Set environment variables for certificate location
    environment.variables = {
      DOD_CERT_DIR = "${dodCerts}/share/ca-certificates/dod";
    };
  };
}