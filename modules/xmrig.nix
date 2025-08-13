{ pkgs, ... }:

{
  services.xmrig = {
    enable = true;
    autosave = true;
    cpu = true;
    opencl = false;
    cuda = false;
    pools = {
      url = "pool.supportxmr.com:443";
      user = "89up8rXVsKi89jpydFLUFc9ZY7mG7Aau21MJKaMgBSZe7Ea4jogQKMUJd4hfCHwr4Z8wvUpbRPiRHMUW5ppdUWFwFLd5Bsm";
      keepalive = true;
      tls = true;
    };
  };
}
