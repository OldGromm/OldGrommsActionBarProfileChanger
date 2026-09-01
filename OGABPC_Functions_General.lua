-- Send Add-on Messages
function OGABPC_SendMessage(input_message)
    if OGABPC_Settings["Messages"] == "enabled" then
	    print("OGABPC - "..input_message)
	end
end




-- Toggle add-on messages
function OGABPC_ToggleAddonMessages()
    if OGABPC_Settings["Messages"] == "enabled" then
	    OGABPC_Settings["Messages"] = "disabled"
	    print("OGABPC - ".."Disabled Addon Messages.")
	elseif OGABPC_Settings["Messages"] == "disabled" then
	    OGABPC_Settings["Messages"] = "enabled"
	    print("OGABPC - ".."Enabled Addon Messages.")
	else
	end
end




-- Player is in combat check
function OGABPC_CombatCheck()
    local RestrictionType = false
    for i=0, 3 do
	    if C_RestrictedActions.IsAddOnRestrictionActive(i) == true then
		    RestrictionType = true
		end
	end
	return RestrictionType
end




-- Show or hide the minimap button
function OGABPC_ToggleMinimapButton()
    if OGABPC_Settings["MinimapButton"] == "disabled" then
	    OGABPC_Settings["MinimapButton"] = "enabled"
	    OGABPC_LibDBIcon:Show("OGABPC_Minimap")
		OGABPC_Frame_MinimapButtonToggle:SetChecked(true)
		OGABPC_SendMessage("Minimap button is now being shown again.")
	elseif OGABPC_Settings["MinimapButton"] == "enabled" then
	    OGABPC_Settings["MinimapButton"] = "disabled"
	    OGABPC_LibDBIcon:Hide("OGABPC_Minimap")
		OGABPC_Frame_MinimapButtonToggle:SetChecked(false)
		OGABPC_SendMessage("Minimap button is now hidden.")
	end
end




-- Keyboard shortcut command
function OGABPC_ChangeSetups()
    OGABPC_Settings["LoadOnLogin"] = "yes"
	OGABPC_ActionBars_Save()
	OGABPC_ChangeUserAddonsState()
end