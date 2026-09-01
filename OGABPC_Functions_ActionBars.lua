-- Save current action bar setup
---- Specific pet action function
function OGABPC_CheckPetCommands()
    local NumberOfPetSpells = select(1, C_SpellBook.HasPetSpells())
	if NumberOfPetSpells == nil then
		    OGABPC_SendMessage("Unable to save pet icons. Be sure to summon your pet first so the ".."\"".."Pet".."\"".." section of your spellbook becomes available.")
	else
        for i=1, NumberOfPetSpells do
            if select(4, GetBuildInfo()) > 120000 then
        	    local NewItemInfo = C_SpellBook.GetSpellBookItemInfo(i, 1)
        		local ActionID = NewItemInfo.actionID
        		local IconTexture = C_ActionBar.GetActionTexture(i)
        		local ActionSlots = C_ActionBar.FindPetActionButtons(ActionID)
        		if ActionSlots == nil then
        		else
        		    if type(ActionSlots) == "number" then 
                        OGABPC_SaveVariables(ActionSlots, "petcommand", i)
        			elseif type(ActionSlots) == "table" then
        			    for _, v in ipairs(ActionSlots) do
        			        OGABPC_SaveVariables(v, "petcommand", i)
        				end
        			end
        		end
        	else
        	    local ItemInfo = select(2, GetSpellBookItemInfo(i, "pet"))
        	    local spellID = bit.band(0xFFFFFF, ItemInfo)
        		local Name = GetSpellBookItemName(i, "pet")
        	end
        end
	end
end

---- main save function
function OGABPC_ActionBars_Save()
    local CheckPetCommandsOnActionBars = false
	for i=1, 180 do
		local ActionType = nil
		local ActionInfo = nil

        if C_ActionBar.HasAction(i) == true then
		    ActionType = select(1, GetActionInfo(i))
			if ActionType == "companion" then
				if select(3, GetActionInfo(i)) == "MOUNT" then
				    ActionType = "mount"
				    ActionInfo = select(2, GetActionInfo(i))
				end
            elseif ActionType == "equipmentset" then
                ActionInfo = select(2, GetActionInfo(i))
            elseif ActionType == "flyout" then
                local FlyoutID = select(2, GetActionInfo(i))
				ActionInfo = select(2, GetFlyoutSlotInfo(FlyoutID, 1))
            elseif ActionType == "item" then
			    PickupAction(i)
                ActionInfo = select(3, GetCursorInfo())
				PlaceAction(i)
            elseif ActionType == "macro" then
                local MacroID = select(2, GetActionInfo(i))
				ActionInfo = C_Macro.GetMacroName(MacroID)
			elseif ActionType == "outfit" then
			    ActionInfo = select(2, GetActionInfo(i))
            elseif ActionType == "petaction" then
                CheckPetCommandsOnActionBars = true
            elseif ActionType == "spell" then
                local ActionInfoExtra = select(3, GetActionInfo(i))
				if ActionInfoExtra == "assistedcombat" then
				    ActionInfo = 1229376
				elseif ActionInfoExtra == "pet" then
                    CheckPetCommandsOnActionBars = true
				else
				    ActionInfo = select(2, GetActionInfo(i))
				end
			elseif ActionType == "summonmount" then
			    ActionType = "mount"
                local MountID = select(2, GetActionInfo(i))
				if MountID == 268435455 then
				    ActionInfo = MountID
				else
				    ActionInfo = select(2, C_MountJournal.GetMountInfoByID(MountID))
				end
			elseif ActionType == "summonpet" then
			    ActionType = "pet"
                ActionInfo = select(2, GetActionInfo(i))
            else
            end
		end

		OGABPC_SaveVariables(i, ActionType, ActionInfo)
	end
	
	if CheckPetCommandsOnActionBars == true then
	    OGABPC_CheckPetCommands()
	end

	OGABPC_CheckSwapProfileDisplayStatus()

	local index = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
	OGABPC_SendMessage("Saved current keyboard loadout to the ".."\""..OGABPC_Profiles[index]["Name"].."\"".." profile: ")
end



-- Load current action bar setup


---- main load function
function OGABPC_ActionBars_Load()
    local indexcheck = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
    if OGABPC_Profiles[indexcheck]["ActionBarHasData"] == "no" then
	    local indexempty = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
	    OGABPC_SendMessage("The profile ".."\""..OGABPC_Profiles[indexempty]["Name"].."\"".." is empty.")
	else
	    local OGABPC_SendMissingPetSpellbookMessageBefore = false
    	for i=1, 180 do
    		local ActionType, ActionInfo = OGABPC_LoadVariables(i)
    		if C_ActionBar.HasAction(i) == true then
    		    PickupAction(i)
    			ClearCursor()
    		end
    		
    		if ActionType == nil then
    		
    		else
    			if ActionType == "equipmentset" then
    			    local SetID = C_EquipmentSet.GetEquipmentSetID(ActionInfo)
                    C_EquipmentSet.PickupEquipmentSet(SetID)
    			elseif ActionType == "flyout" then
    			    local SpellbookSlot = C_SpellBook.FindFlyoutSlotBySpellID(ActionInfo)
    				if select(4, GetBuildInfo()) > 120000 then
    				    C_SpellBook.PickupSpellBookItem(SpellbookSlot, 0)
    					if GetCursorInfo() == nil then
    					    C_SpellBook.PickupSpellBookItem(SpellbookSlot, 1)
    					end
    				else
    					PickupSpellBookItem(SpellbookSlot, "spell")
    					if GetCursorInfo() == nil then
    					    PickupSpellBookItem(SpellbookSlot, "pet")
    					end
    				end
    			elseif ActionType == "item" then
                    C_Item.PickupItem(ActionInfo)
    		    elseif ActionType == "macro" then
    			    PickupMacro(ActionInfo)
    			elseif ActionType == "mount" then
    			    if ActionInfo == 268435455 then
    				    C_MountJournal.Pickup(0)
    				else
    				    C_Spell.PickupSpell(ActionInfo)
    				end
				elseif ActionType == "mount" then
				    C_Spell.PickupSpell(ActionInfo)
    			elseif ActionType == "outfit" then
    			    C_TransmogOutfitInfo.PickupOutfit(ActionInfo)
				elseif ActionType == "pet" then
                    C_PetJournal.PickupPet(ActionInfo)
    			elseif ActionType == "petaction" then
    			    local SpellID = 0
    			    if select(4, GetBuildInfo()) > 120000 then
                        local NewActionInfo = C_SpellBook.GetSpellBookItemInfo(ActionInfo, 1)
    				    SpellID = NewActionInfo.spellID
    				else
    				    local NewActionInfo = select(2, GetSpellBookItemInfo(ActionInfo, "pet"))
    					SpellID = bit.band(0xFFFFFF, NewActionInfo)
    				end
    				PickupPetSpell(SpellID)
				elseif ActionType == "petcommand" then
				    if select(4, GetBuildInfo()) > 120000 then
					    C_SpellBook.PickupSpellBookItem(ActionInfo, 1)
					else
    				    local NewActionInfo = select(2, GetSpellBookItemInfo(ActionInfo, "pet"))
    					local SpellID = bit.band(0xFFFFFF, NewActionInfo)
						PickupSpellBookItem(SpellID)
					end
					NumberOfPetSpells = select(1, C_SpellBook.HasPetSpells())
                    if NumberOfPetSpells == nil then
					    if OGABPC_SendMissingPetSpellbookMessageBefore == false then
						    OGABPC_SendMissingPetSpellbookMessageBefore = true
                            OGABPC_SendMessage("Unable to load pet icons. Be sure to summon your pet first so the ".."\"".."Pet".."\"".." section of your spellbook becomes available.")
                        end
					end
    		    elseif ActionType == "spell" then
    			    C_Spell.PickupSpell(ActionInfo)
    			else
    			end
    			PlaceAction(i)
    		end
    	end
    	local index = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
    	if OGABPC_Settings["LoadOnLogin"] == "yes" then
		    OGABPC_SendMessage("Profile swapping successful. Current profile is: "..OGABPC_Profiles[index]["Name"])
		else
		    OGABPC_SendMessage("Loaded keyboard loadout from the ".."\""..OGABPC_Profiles[index]["Name"].."\"".." profile.")
		end
	end
end




-- Reset current action bar setup
function OGABPC_ActionBars_Reset(input_number, input_mode)
    for i=1, 180 do
        if C_ActionBar.HasAction(i) == true then
            PickupAction(i)
            ClearCursor()
        end
    end
	if input_mode == "all" then
	    local index = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
	    wipe(OGABPC_Profiles[index]["ActionBars"])
	    OGABPC_Profiles[index]["ActionBarHasData"] = "no"
		OGABPC_CheckSwapProfileDisplayStatus()
		OGABPC_SendMessage("The profile ".."\""..OGABPC_Profiles[index]["Name"].."\"".." has been reset.")
	else
	    OGABPC_SendMessage("All action bars have been cleared.")
	end
end