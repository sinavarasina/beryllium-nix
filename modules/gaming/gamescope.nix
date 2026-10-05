{
  programs.gamescope = {
    enable = true;
    # Installs /run/wrappers/bin/gamescope, which can raise its own priority.
    capSysNice = true;
  };
}
