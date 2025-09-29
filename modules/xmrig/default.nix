{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.my.xmrig.enable {
    services.xmrig = {
      enable = true; # enable when module is enabled
      package = pkgs.xmrig-mo;
      settings = {
        autosave = true;
        randomx = { "1gb-pages" = true; };
        http = {
          enabled = true;
          port = 1984;
          host = "127.0.0.1";
          access_token = null;
          restricted = true;
        };
        cpu.enabled = true;
        opencl = false;
        cuda = false;
        pools = [{
          url = "pool.supportxmr.com:9000";
          user = "89up8rXVsKi89jpydFLUFc9ZY7mG7Aau21MJKaMgBSZe7Ea4jogQKMUJd4hfCHwr4Z8wvUpbRPiRHMUW5ppdUWFwFLd5Bsm";
          keepalive = true;
          tls = true;
        }];
      };
    };
  };
}
