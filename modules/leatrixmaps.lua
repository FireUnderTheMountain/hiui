-- - For developers, you can now configure Leatrix Maps from your own addon or script using the following as a guide:

-- -- Ensure Leatrix Maps does not replace LeaMapsDB on next reload
-- SlashCmdList["Leatrix_Maps"]("nosave")
-- -- Clear the settings database (optional but recommended)
-- wipe(LeaMapsDB)
-- -- Configure the settings (add any settings you like here)
-- LeaMapsDB["NoMapBorder"] = "On"
-- -- Reload the UI to apply the settings
-- ReloadUI()
