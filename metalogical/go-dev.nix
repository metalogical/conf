{pkgs, ...}:
{
  home.packages = with pkgs; [
    go
    go-langserver # TODO switch to bingo, then gopls
  ];
}
