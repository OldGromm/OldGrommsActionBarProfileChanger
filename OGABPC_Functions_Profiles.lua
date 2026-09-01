-- Add-ons to activate or deactivate depending on the profile
function OGABPC_ChangeUserAddonsState()
    local old_number = OGABPC_Settings["CurrentProfile"]
	local old_index = OGABPC_ProfileIndexTextstring(old_number)
	local new_number = OGABPC_Profiles[old_index]["SwapTarget"]

    local profileindex = OGABPC_ProfileIndexTextstring(OGABPC_Settings["ProfileSwap_Next"])

    if next(OGABPC_Profiles[old_index]["Addons_Enabled"]) == nil then
	
	else
        for i, v in ipairs(OGABPC_Profiles[old_index]["Addons_Enabled"]) do
	        C_AddOns.EnableAddOn(v, UnitName("player"))
	    end
	end
	if next(OGABPC_Profiles[old_index]["Addons_Disabled"]) == nil then
	
	else
	    for i, v in ipairs(OGABPC_Profiles[old_index]["Addons_Disabled"]) do
	        C_AddOns.DisableAddOn(v, UnitName("player"))
	    end
	end

	OGABPC_Settings["CurrentProfile"] = new_number
end



-- Load/Save profile variables
function OGABPC_LoadVariables(input_index)
    local Slotname = OGABPC_SlotTextstring(input_index)
    local index = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
	local ActionType = OGABPC_Profiles[index]["ActionBars"][Slotname][1]
	local ActionInfo = OGABPC_Profiles[index]["ActionBars"][Slotname][2]
    return ActionType, ActionInfo
end
function OGABPC_SaveVariables(input_index, input_type, input_info)
    local Slotname = OGABPC_SlotTextstring(input_index)
    local index = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
    OGABPC_Profiles[index]["ActionBars"][Slotname] = {input_type, input_info}
	OGABPC_Profiles[index]["ActionBarHasData"] = "yes"
end




-- Profile Swapping
---- Check whether to display the option in the menu or not (requires at least two profiles with data)
function OGABPC_CheckSwapProfileDisplayStatus()
    local count = 0
    for i=1, 30 do
	    local index = OGABPC_ProfileIndexTextstring(i)
	    if OGABPC_Profiles[index]["ActionBarHasData"] == "yes" then
		    count = count + 1
		end
	end
	if count >1 then
        OGABPC_Frame_Dropdown_Title_SwapTarget:Show()
        OGABPC_Frame_Dropdown_SwapProfiles:Show()
		OGABPC_Frame_Dropdown_SwapProfiles:GenerateMenu()
	else
        OGABPC_Frame_Dropdown_Title_SwapTarget:Hide()
        OGABPC_Frame_Dropdown_SwapProfiles:Hide()
	end
end

-- Check if profile swapping is possible
function OGABPC_CheckSwapProfileCheck()
    local proceed = false
    
	local index = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
	if OGABPC_Profiles[index]["SwapTarget"] == 0 or OGABPC_Profiles[index]["SwapTarget"] == nil then
	
	else
	    proceed = true
	end
	
	return proceed
end