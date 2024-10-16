{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
  };

  xdg.mimeApps =
    let
      x = "firefox.desktop";
    in
    {
      defaultApplications =
        let
          f = [ x ];
        in
        {
          "x-scheme-handler/http" = f;
          "x-scheme-handler/https" = f;
          "x-scheme-handler/chrome" = f;
          "text/html" = f;
          "application/x-extension-htm" = f;
          "application/x-extension-html" = f;
          "application/x-extension-shtml" = f;
          "application/xhtml+xml" = f;
          "application/x-extension-xhtml" = f;
          "application/x-extension-xht" = f;
        };
      associations.added =
        let
          f = x;
        in
        {
          "x-scheme-handler/http" = f;
          "x-scheme-handler/https" = f;
          "x-scheme-handler/chrome" = f;
          "text/html" = f;
          "application/x-extension-htm" = f;
          "application/x-extension-html" = f;
          "application/x-extension-shtml" = f;
          "application/xhtml+xml" = f;
          "application/x-extension-xhtml" = f;
          "application/x-extension-xht" = f;
        };
    };

  programs.firefox = {
    enable = true;
    profiles.default = {
      search = {
        force = true;
        default = "Google";
        privateDefault = "Google";
        order = [ "Google" ];
      };
      bookmarks = { };
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        darkreader
      ];
      bookmarks = { };
      settings = {
        "browser.startup.homepage" = "about:home";

        # Disable irritating first-run stuff
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = false;

        "browser.download.useDownloadDir" = true;

        # Disable crappy home activity stream page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        "browser.newtabpage.blocked" = lib.genAttrs [
          # Youtube
          "26UbzFJ7qT9/4DhodHKA1Q=="
          # Facebook
          "4gPpjkxgZzXPVtuEoAL9Ig=="
          # Wikipedia
          "eV8/WsSLxHadrTL1gAxhug=="
          # Reddit
          "gLv0ja2RYVgxKdp0I5qwvA=="
          # Amazon
          "K00ILysCaEq8+bEqV/3nuw=="
          # Twitter
          "T9nJot5PurhJSy8n038xGA=="
        ] (_: 1);

        # Disable some telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # Disable fx accounts
        "identity.fxaccounts.enabled" = false;
        # Disable "save password" prompt
        "signon.rememberSignons" = true;
        # Harden
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        # Layout
        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 20;
          newElementCount = 5;
          dirtyAreaCache = [
            "nav-bar"
            "PersonalToolbar"
            "toolbar-menubar"
            "TabsToolbar"
            "widget-overflow-fixed-list"
          ];
          placements = {
            PersonalToolbar = [ ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "downloads-button"
              "ublock0_raymondhill_net-browser-action"
              "_testpilot-containers-browser-action"
              "reset-pbm-toolbar-button"
              "unified-extensions-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
            unified-extensions-area = [ ];
            widget-overflow-fixed-list = [ ];
          };
          seen = [
            "developer-button"
            "ublock0_raymondhill_net-browser-action"
            "_testpilot-containers-browser-action"
          ];
        };
      };
    };
  };
}
