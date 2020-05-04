let
  frameworks = nixpkgs.darwin.apple_sdk.frameworks;
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
  #rustNightlyChannel = (nixpkgs.rustChannelOf { date = "2019-12-01"; channel = "nightly"; }).rust;
  #rustNightlyChannel = nixpkgs.latest.rustChannels.nightly.rust.override {
  # See https://rust-lang.github.io/rustup-components-history/ for a list of nightly extensions
  rustStableChannel = (nixpkgs.rustChannelOf { channel = "stable"; }).rust.override {
    extensions = [
      "rust-src"
      "clippy-preview"
    ];
  };
in
  with nixpkgs;
  with nixpkgs.latest.rustChannels.stable;
stdenv.mkDerivation {
  name = "uoc-rust-shell";
  buildInputs = [
    cargo-bloat
    cargo-tree
    gcc
    rustStableChannel
    rustup
  ]
  ++ lib.optional stdenv.isDarwin [
    frameworks.Security
    frameworks.CoreFoundation
    frameworks.CoreServices
  ];
}
