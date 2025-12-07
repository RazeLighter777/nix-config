{ config, lib, ... }:
{
  config = lib.mkIf config.my.bash.enable {
    home-manager.users.${config.my.user.name} = {
      programs.bash = {
        enable = true;
        shellAliases = {
          ll = "ls -l";
          la = "ls -la";
          k = "kubectl";
          gr = "gitroot";
        };
        bashrcExtra = ''
          # fzf
          eval "$(fzf --bash)"
          # Git prompt
          export GIT_PS1_SHOWDIRTYSTATE=1
          export GIT_PS1_SHOWSTASHSTATE=1
          export GIT_PS1_SHOWUNTRACKEDFILES=1
          export GIT_PS1_SHOWUPSTREAM="auto verbose"
          export GIT_PS1_SHOWCOLORHINTS=1
          . ~/.local/bin/git-prompt.sh # Load Git prompt
          git_repo_path() {
            local top rel repo

            top=$(git rev-parse --show-toplevel 2>/dev/null) || return 0
            repo=$(basename "$top")
            rel=$(realpath --relative-to="$top" "$PWD" 2>/dev/null)

            if [[ "$rel" = "." ]]; then
                printf "%s" "$repo"
            else
                printf "%s/%s" "$repo" "$rel"
            fi
          }
          prompt_path() {
            local top repo rel

            # Are we in a git repo?
            top=$(git rev-parse --show-toplevel 2>/dev/null)
            if [[ $? -eq 0 ]]; then
                repo=$(basename "$top")
                rel=$(realpath --relative-to="$top" "$PWD")

                # At repo root → just repo name
                if [[ "$rel" = "." ]]; then
                    printf "%s" "$repo"
                else
                    printf "%s/%s" "$repo" "$rel"
                fi
                return
            fi

            # Not in git repo → print ~/path or full path
            if [[ "$PWD" == "$HOME"* ]]; then
                printf "~%s" "''${PWD#$HOME}"
            else
                printf "%s" "$PWD"
            fi
          }
          gitroot() {
            local root
            root=$(git rev-parse --show-toplevel 2>/dev/null) || {
                echo "Not in a git repository." >&2
                return 1
            }
            cd "$root"
          }
          PS1='\[\e[1m\][\u@\h \[\e[2m\]$(prompt_path)$(__git_ps1 " (%s)")\[\e[1m\]]\$\[\e[0m\] '
        '';
      };
      home.file.".local/bin/git-prompt.sh".source = ./git-prompt.sh;
    };
  };
}
