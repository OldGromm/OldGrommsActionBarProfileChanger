-- Update User Addon Enabled/Disabled Lists
---- Add or remove addon from a list
function OGABPC_UpdateAddonsList(input_name, input_type)
    local index = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
	local profilename = OGABPC_Profiles[index]["Name"]

	local listtype = ""
	if input_type == "Addons_Enabled" then
	    listtype = "Enabled"
	elseif input_type == "Addons_Disabled" then
	    listtype = "Disabled"
	else
	end
	
	if next(OGABPC_Profiles[index][input_type]) == nil then
        tinsert(OGABPC_Profiles[index][input_type], input_name)
        OGABPC_SendMessage("Added ".."\""..input_name.."\"".." to the "..listtype.." list of the ".."\""..profilename.."\"".." profile.")
	else
	    local alreadyexists = false
		local position = 0
		for i, v in ipairs(OGABPC_Profiles[index][input_type]) do
	        if v == input_name then
			    alreadyexists = true
				position = i
			end
		end
			
		if alreadyexists == true then
		    tremove(OGABPC_Profiles[index][input_type], position)
			OGABPC_SendMessage("Removed ".."\""..input_name.."\"".." from the "..listtype.." list of the ".."\""..profilename.."\"".." profile.")
		else
		    tinsert(OGABPC_Profiles[index][input_type], input_name)
			OGABPC_SendMessage("Added ".."\""..input_name.."\"".." to the "..listtype.." list of the ".."\""..profilename.."\"".." profile.")
		end
	end
end

---- Check if add-on already is on a list
function OGABPC_CheckAddonsList(input_name, input_type)
    local index = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
	local proceed = false
	for i, v in ipairs(OGABPC_Profiles[index][input_type]) do
	    if v == input_name then
		    proceed = true
		end
	end
    return proceed
end



-- In-Combat warning message
function OGABPC_CombatCheckWarning(input_type)
    local textstring = ""
    if input_type == "Load" then
	    textstring = "load profile"
	elseif input_type == "Save" then
	    textstring = "save profile"
	elseif input_type == "ResetActionBars" then
	    textstring = "reset action bars"
	elseif input_type == "ResetProfile" then
	    textstring = "reset profile"
	end

	if OGABPC_CombatCheck() == true then
		PlaySoundFile(567415, "Master")
		OGABPC_SendMessage("Unable to "..textstring.."- You are in combat.")
	else
		if input_type == "Load" then
            OGABPC_ActionBars_Load()
	    elseif input_type == "Save" then
            OGABPC_ActionBars_Save()
	    elseif input_type == "ResetActionBars" then
            OGABPC_ActionBars_Reset(input_number)
	    elseif input_type == "ResetProfile" then
            OGABPC_ActionBars_Reset(input_number, "all")
	    end
	end
end



-- Profile Swapping Check Message
function OGABPC_SwapProfilesMessage()
    if OGABPC_CheckSwapProfileCheck() == false then
		PlaySoundFile(567415, "Master")
		OGABPC_SendMessage("Unable to swap profiles - no second profile has been selected.")
	else
        OGABPC_Settings["LoadOnLogin"] = "yes"
	    OGABPC_ActionBars_Save()
	    OGABPC_ChangeUserAddonsState()
		C_UI.Reload()
	end
end