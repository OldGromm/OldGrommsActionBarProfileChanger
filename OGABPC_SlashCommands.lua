SLASH_OGABPCMINIMAP1 = "/OGABPCMINIMAP"
SlashCmdList.OGABPCMINIMAP = function()
    OGABPC_ToggleMinimapButton()
end




SLASH_OGABPCMENU1 = "/OGABPCMENU"
SlashCmdList.OGABPCMENU = function()
    OGABPC_ToggleOptionsMenu()
end




SLASH_OGABPCTOGGLEMESSAGES1 = "/OGABPCTOGGLEMESSAGES"
SlashCmdList.OGABPCTOGGLEMESSAGES = function()
    OGABPC_ToggleAddonMessages()
end




SLASH_OGABPCSAVE1 = "/OGABPCSAVE"
SlashCmdList.OGABPCSAVE = function()
    OGABPC_CombatCheckWarning("Save")
end




SLASH_OGABPCLOAD1 = "/OGABPCLOAD"
SlashCmdList.OGABPCLOAD = function()
    OGABPC_CombatCheckWarning("Load")
end




SLASH_OGABPCRESETBARS1 = "/OGABPCRESETBARS"
SlashCmdList.OGABPCRESETBARS = function()
    OGABPC_CombatCheckWarning("ResetActionBars")
end




SLASH_OGABPCRESETPROFILE1 = "/OGABPCRESETPROFILE"
SlashCmdList.OGABPCRESETPROFILE = function()
    OGABPC_CombatCheckWarning("ResetProfile")
end




SLASH_OGABPCSWAP1 = "/OGABPCSWAP"
SlashCmdList.OGABPCSWAP = function()
    OGABPC_SwapProfilesMessage()
end