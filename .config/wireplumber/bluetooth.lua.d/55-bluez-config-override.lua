-- ~/.config/wireplumber/bluetooth.lua.d/55-bluez-config-override.lua
table.insert(bluez_monitor.rules, {
  matches = {
    {
      { "device.name", "matches", "bluez_card.*" },
    },
  },
  apply_properties = {
    -- default: "[ hfp_hf hsp_hs a2dp_sink ]"
    -- available: "[ hfp_hf hsp_hs a2dp_sink hfp_ag hsp_ag a2dp_source ]"
    ["bluez5.auto-connect"] = "[ hfp_hf hsp_hs a2dp_sink a2dp_source ]",
  },
})
