{
  description = "A flake that packages an AppImage from GitHub";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        appName = "claude-desktop";
        appVersion = "0.13.11";
        
        appimage = pkgs.appimageTools.wrapType2 {
          pname = appName;
          name = appName;
          version = appVersion;
          
          src = pkgs.fetchurl {
            url = "https://github.com/aaddrick/claude-desktop-debian/releases/download/v1.1.5%2Bclaude0.13.11/claude-desktop-0.13.11-amd64.AppImage";
            hash = "sha256-kKntzVy95NXeph9ZQM1WvAPuNWGjutz1HNDW3UMDrtg=";
          };
          
          extraPkgs = pkgs: [
          ];
          
          extraInstallCommands = ''
            mkdir -p $out/share/applications
            cat > $out/share/applications/${appName}.desktop << EOF
            [Desktop Entry]
            Name=Claude Desktop
            Exec=${appName}
            Icon=${appName}
            Type=Application
            Categories=Office;TextEditor;
            Comment=A desktop client for Claude.ai
            EOF
          '';
        };
        
      in
      {
        packages = {
          default = appimage;
          ${appName} = appimage;
        };
        
        apps = {
          default = flake-utils.lib.mkApp {
            drv = appimage;
          };
          ${appName} = flake-utils.lib.mkApp {
            drv = appimage;
          };
        };
      });
}
