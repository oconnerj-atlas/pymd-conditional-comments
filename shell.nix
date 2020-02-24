let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  pname = "pymd-conditional-comments";
  buildInputs = [
    pkgs.pythonPackages.markdown
  ];
}
