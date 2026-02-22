{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.xdg-apps.enable {
    xdg.menus.enable = true;
    home-manager.users.${config.my.user.name} = {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          # Images
          "image/jpeg" = "swayim.desktop";
          "image/png" = "swayim.desktop";
          "image/gif" = "swayim.desktop";
          "image/bmp" = "swayim.desktop";
          "image/webp" = "swayim.desktop";
          "image/svg+xml" = "swayim.desktop";

          # Text files
          "text/plain" = "vim";
          "application/x-shellscript" = "vim";
          "text/markdown" = "vim";
          "text/x-csrc" = "vim";
          "text/x-c++src" = "vim";
          "text/x-python" = "vim";

          # PDFs
          "application/pdf" = "okular.desktop";

          # Documents (LibreOffice)
          "application/vnd.oasis.opendocument.text" = "writer.desktop";
          "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
          "application/vnd.oasis.opendocument.presentation" = "impress.desktop";
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";
          "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "impress.desktop";
          "application/msword" = "writer.desktop";
          "application/vnd.ms-excel" = "calc.desktop";
          "application/vnd.ms-powerpoint" = "impress.desktop";
          "application/rtf" = "writer.desktop";

          # E-books (Calibre)
          "application/epub+zip" = "calibre-ebook-viewer.desktop";
          "application/x-mobipocket-ebook" = "calibre-ebook-viewer.desktop";

          # Email
          "x-scheme-handler/mailto" = "thunderbird.desktop";
          "message/rfc822" = "thunderbird.desktop";

          # Web
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/ftp" = "firefox.desktop";

          # Video
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "video/webm" = "mpv.desktop";
          "video/mpeg" = "mpv.desktop";
          "video/x-msvideo" = "mpv.desktop";

          # Audio
          "audio/mpeg" = "mpv.desktop";
          "audio/mp4" = "mpv.desktop";
          "audio/x-flac" = "mpv.desktop";
          "audio/ogg" = "mpv.desktop";
          "audio/x-wav" = "mpv.desktop";

          # Archives
          "application/zip" = "ark.desktop";
          "application/x-tar" = "ark.desktop";
          "application/x-gzip" = "ark.desktop";
          "application/x-bzip2" = "ark.desktop";
          "application/x-7z-compressed" = "ark.desktop";
          "application/x-rar" = "ark.desktop";

          # Terminal
          "x-scheme-handler/terminal" = "kitty.desktop";
        };

      };
    };
  };
}
