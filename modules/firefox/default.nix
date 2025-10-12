{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.firefox.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.users.${config.my.user.name}.programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
        cfg = {
          pipewireSupport = true;
          ffmpegSupport = true;
          smartcardSupport = true;
        };
      };
      policies = {
        "3rdparty" = {
          Extensions = {
            "uBlock0@raymondhill.net" = {
              permissions = [ "internal:privateBrowsingAllowed" ];
              origins = [ ];
            };
            "tridactyl.vim@cmcaine.co.uk" = {
              permissions = [ "internal:privateBrowsingAllowed" ];
              origins = [ ];
            };

          };
        };

        AllowFileSelctionDialogs = true;
        AppAutoUpdate = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;

        BlockAboutAddons = false;
        BlockAboutConfig = false;
        BlockAboutProfiles = false;
        BlockAboutSupport = false;

        Cookies = {
          Behavior = "reject-tracker";
        };

        DefaultDownloadDirectory = "~/Downloads";
        DisableAppUpdate = true;
        DisableBookmarksToolbar = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DisplayMenuBar = false;
        DontCheckDefaultBrowser = true;

        EnableTrackingProtection = {
          Value = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
          SuspectedFingerprinting = true;
        };

        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
        };

        HardwareAcceleration = true;

        PasswordManagerEnabled = false;

        # Permissions = { };
        # PopupBlocking

        SearchBar = "unified";
        SearchSuggestEnabled = false;
        SecurityDevices = {
          "OpenSC PKCS#11 Module" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
        };
        ShowHomeButton = false;
        SkipTermsOfUse = true;
        SupportMenu = false;

        TranslateEnabled = true;
      };
      profiles.default = {
        id = 0;
        extensions.force = true;
        extensions.settings = {
          "uBlock0@raymondhill.net".settings = {
            force = true;
            selectedFilterLists = [
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "easylist"
              "easyprivacy"
              "urlhaus-1"
              "fanboy-cookiemonster"
              "ublock-cookies-easylist"
              "adguard-cookies"
              "ublock-cookies-adguard"
              "fanboy-social"
              "adguard-social"
            ];
          };
        };
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
          cookies-txt
          don-t-fuck-with-paste
          greasemonkey
          bitwarden
          libredirect
          localcdn
          privacy-pass
          protondb-for-steam
          return-youtube-dislikes
          rust-search-extension
          search-by-image
          sponsorblock
          steam-database
          ublock-origin
          unpaywall
          vimium-c
          old-reddit-redirect
        ];
        settings = {
          "extensions.autoDisableScopes" = 0;
          "browser.search.defaultenginename" = "Google";
          "browser.search.selectedEngine" = "Google";
          "browser.urlbar.placeholderName" = "Google";
          "browser.search.region" = "US";
          "browser.uidensity" = 1;
          "browser.search.openintab" = true;
          "xpinstall.signatures.required" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "network.allow-experiments" = false;
          "extensions.pocket.enabled" = false;
          "places.history.enabled" = false;
          "browser.sessionstore.resume_from_crash" = false;
          "browser.sessionstore.max_tabs_undo" = 0;
          "dom.security.https_only_mode" = true; # force https
          "browser.download.panel.shown" = true; # show download panel
          "identity.fxaccounts.enabled" = false; # disable firefox accounts
          "signon.rememberSignons" = false; # disable saving passwords
          "app.shield.optoutstudies.enabled" = false; # disable shield studies
          "app.update.auto" = false; # disable auto update
          "browser.bookmarks.restore_default_bookmarks" = false; # don't restore default bookmarks
          "browser.quitShortcut.disabled" = true; # disable ctrl+q
          "browser.shell.checkDefaultBrowser" = false; # don't check if default browser

          # download handling
          "browser.download.dir" = "/home/meain/down"; # default download dir
          "browser.startup.page" = 3; # restore previous session

          # ui changes
          "browser.aboutConfig.showWarning" = false; # disable warning about about:config
          "browser.compactmode.show" = true; # enable compact mode
          "general.autoScroll" = true; # enable autoscroll
          "browser.tabs.firefox-view" = false; # enable firefox view
          "browser.toolbars.bookmarks.visibility" = "never"; # hide bookmarks toolbar
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true; # disable picture in picture button
          "startup.homepage_welcome_url" = ""; # disable welcome page
          "browser.newtabpage.enabled" = false; # disable new tab page
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # enable userChrome.css
          "full-screen-api.ignore-widgets" = true; # fullscreen within window

          # privacy
          "browser.contentblocking.category" = "custom"; # set tracking protection to custom
          "browser.discovery.enabled" = false; # disable discovery
          "browser.search.suggest.enabled" = false; # disable search suggestions
          "browser.protections_panel.infoMessage.seen" = true; # disable tracking protection info
          "dom.private-attribution.submission.enabled" = false; # stop doing dumb stuff mozilla

          # clearing
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.clearOnShutdown.cache" = true;
          # let me close and open tabs without confirmation
          "browser.tabs.closeWindowWithLastTab" = false; # don't close window when last tab is closed
          "browser.tabs.loadBookmarksInTabs" = true; # open bookmarks in new tab
          "browser.tabs.loadDivertedInBackground" = false; # open new tab in background
          "browser.tabs.loadInBackground" = true; # open new tab in background
          "browser.tabs.warnOnClose" = false; # don't warn when closing multiple tabs
          "browser.tabs.warnOnCloseOtherTabs" = false; # don't warn when closing multiple tabs
          "browser.tabs.warnOnOpen" = false; # don't warn when opening multiple tabs
          "browser.tabs.warnOnQuit" = false; # don't warn when closing multiple tabs

          # other
          "devtools.cache.disabled" = true; # disable caching in devtools
          "devtools.toolbox.host" = "right"; # move devtools to right
          # "browser.ssb.enabled" = true; # enable site specific browser
          "media.autoplay.default" = 0; # enable autoplay on open
          "media.ffmpeg.vaapi.enabled" = true; # enable hardware acceleration
          "media.rdd-vpx.enabled" = true; # enable hardware acceleration

          # override fonts (Set tracking protection to custom without "Suspected fingerprinters")
          "font.minimum-size.x-western" = 13;
          "font.size.fixed.x-western" = 15;
          "font.size.monospace.x-western" = 15;
          "font.size.variable.x-western" = 15;
          "browser.display.use_document_fonts" = 0;

          # do not open a tab in a new window
          # ascentpayroll.net open link in a new without without any
          # chrome and I can't even use my password manager
          # https://support.mozilla.org/eu/questions/1151067?&mobile=1
          "browser.link.open_newwindow.restriction" = 0;
        };
      };
    };
  };
}
