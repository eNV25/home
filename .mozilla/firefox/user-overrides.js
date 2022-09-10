
/* override: recommended */
user_pref("browser.safebrowsing.downloads.remote.enabled", false); // 0403

/* override: enable pinned tab restore */
user_pref("privacy.clearOnShutdown.history", false); // 2811

/* override recipe: RFP is not for me ***/
user_pref("privacy.resistFingerprinting", false); // 4501
user_pref("privacy.resistFingerprinting.letterboxing", false); // 4504 [pointless if not using RFP]
user_pref("webgl.disabled", false); // 4520 [mostly pointless if not using RFP]

/* optional */
user_pref("browser.download.folderList", 2); // 5016
user_pref("javascript.options.asmjs", false); // 5501

/* custom: sync UI state */
user_pref("services.sync.prefs.sync.browser.uiCustomization.state", true);

/* custom: use KDE Browser Integration */
user_pref("media.hardwaremediakeys.enabled", false);

/* custom: don't close window when closing tabs */
user_pref("browser.tabs.closeWindowWithLastTab", false);
