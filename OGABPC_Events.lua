-- Loading the action bar setup upon logging-in.
OGABPC_Event_Setup_PlayerLogin = CreateFrame("Frame")
OGABPC_Event_Setup_PlayerLogin:RegisterEvent("PLAYER_LOGIN")
OGABPC_Event_Setup_PlayerLogin:SetScript("OnEvent", function(_, event)
    OGABPC_CreateMinimapButton()
    ---- One-time check to startup to check what the player's setting for the minimap button are.
    if OGABPC_Settings["MinimapButton"] == "enabled" then
        OGABPC_Frame_MinimapButtonToggle:SetChecked(true)
	    OGABPC_LibDBIcon:Show("OGABPC_Minimap")
    elseif OGABPC_Settings["MinimapButton"] == "disabled" then
        OGABPC_Frame_MinimapButtonToggle:SetChecked(false)
	    OGABPC_LibDBIcon:Hide("OGABPC_Minimap")
    else
    end

    ---- Load action bar profile if th swap features was activated.
    if OGABPC_Settings["LoadOnLogin"] == "yes" then
        OGABPC_ActionBars_Load()
	    OGABPC_Settings["LoadOnLogin"] = "no"
	end
end)