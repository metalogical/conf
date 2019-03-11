{ requireFile, stdenv, p7zip, libX11, libXext, alsaLib, libjack2, freetype }:
stdenv.mkDerivation {
  name = "pianoteq-stage-6.2.2";
 
  buildInputs = [ p7zip ];
 
  src = requireFile {
    message = ''
      Please download Pianoteq and then use nix-prefetch-url
      file:///path/to/pianoteq.7z
    '';
    name = "pianoteq_stage_linux_v630.7z";
    sha256 = "2a0ff7056edd30ac27637479ec6edf779fd9e923123ff94a2f673ddc1a7d71c9";
  };
 
  unpackPhase = ''
    mkdir $out
    cd $out
    7za x $src
  '';
 
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc stdenv.cc.libc ] 
    + ":" + stdenv.lib.makeLibraryPath [ libX11 libXext alsaLib freetype libjack2 ];
 
  installPhase = ''
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $libPath \
      'Pianoteq 6 STAGE/amd64/Pianoteq 6 STAGE'
    mkdir bin/
    cp 'Pianoteq 6 STAGE/amd64/Pianoteq 6 STAGE' bin/pianoteq
  '';
 
  phases = "unpackPhase installPhase";
}
