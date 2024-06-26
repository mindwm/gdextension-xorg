{ lib
, pkgs
, stdenv
, scons
, godot-cpp
, withPlatform ? "linux"
, withTarget ? "template_release"
}:

let
  mkSconsFlagsFromAttrSet = lib.mapAttrsToList (k: v:
    if builtins.isString v
    then "${k}=${v}"
    else "${k}=${builtins.toJSON v}");
in
stdenv.mkDerivation {
  name = "godot-extension-x11";
  src = ./.;

  nativeBuildInputs = with pkgs; [ scons pkg-config makeWrapper ];
  buildInputs = with pkgs; [
    godot-cpp
  ] ++ (with xorg; [
    libX11
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libXi
    libXext
    libxcb
    xcbutilerrors
    xcbutilimage
    xcbutilrenderutil
    xcbutil
    xcbutilwm
  ]);
  enableParallelBuilding = true;
  BUILD_NAME = "nix-flake";

  sconsFlags = mkSconsFlagsFromAttrSet {
    platform = withPlatform;
    target = withTarget;
  };

  outputs = [ "out" ];

  preBuild = ''
    substituteInPlace SConstruct \
    --replace-fail 'godot-cpp/SConstruct' '${godot-cpp}/SConstruct'
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp demo/bin/*.so $out/bin/
    cp xorg.gdextension $out/
  '';

  meta = with lib; {
    homepage = "https://github.com/mindwm/mindwm-godot-client-gdextension";
    description = "A Godot extension to communicate with X11 server";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ omgbebebe ];
  };
}
