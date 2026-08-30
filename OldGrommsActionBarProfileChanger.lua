OGABPC_Profiles = OGABPC_Profiles or {}
OGABPC_CurrentProfile = OGABPC_CurrentProfile or ""
OGABPC_Messages = OGABPC_Messages or ""
OGABPC_AddOns = {}




---- Addon List. Manually add names here. Use the folder/TOC filename of each addon.
OGABPC_AddOns["Keyboard"] = {}
OGABPC_AddOns["Gamepad"] = {}




---- Setup defaults
if OGABPC_CurrentProfile == nil or OGABPC_CurrentProfile == "" then
    OGABPC_CurrentProfile = "Keyboard"
end
if OGABPC_Messages == nil or OGABPC_Messages == "" then
    OGABPC_Messages = "enabled"
end
if OGABPC_Profiles["Keyboard"] == nil then
    OGABPC_Profiles["Keyboard"] = {}
end
if OGABPC_Profiles["Gamepad"] == nil then
    OGABPC_Profiles["Gamepad"] = {}
end
for i=1, 180 do
    local slot = ("Slot_"..tostring(i))
    if OGABPC_Profiles["Keyboard"][slot] == nil then
        OGABPC_Profiles["Keyboard"][slot] = {}
    end
    if OGABPC_Profiles["Gamepad"][slot] == nil then
        OGABPC_Profiles["Gamepad"][slot] = {}
    end
end




-- Send Add-on Messages
local function OGABPC_SendMessage(input_message)
    if OGABPC_Messages == "enabled" then
	    print("OGABPC - "..input_message)
	end
end




-- Add-ons to activate or deactivate depending on the profile
local function OGABPC_SwapAddons()
    if OGABPC_CurrentProfile == "Keyboard" then
	    for i, v in ipairs(OGABPC_AddOns["Keyboard"]) do
	        C_AddOns.DisableAddOn(v, UnitName("player"))
	    end
		for i, v in ipairs(OGABPC_AddOns["Gamepad"]) do
	        C_AddOns.EnableAddOn(v, UnitName("player"))
	    end
		OGABPC_CurrentProfile = "Gamepad"
    elseif OGABPC_CurrentProfile == "Gamepad" then
	    for i, v in ipairs(OGABPC_AddOns["Gamepad"]) do
	        C_AddOns.DisableAddOn(v, UnitName("player"))
	    end
		for i, v in ipairs(OGABPC_AddOns["Keyboard"]) do
	        C_AddOns.EnableAddOn(v, UnitName("player"))
	    end
		OGABPC_CurrentProfile = "Keyboard"
	else
	end
end




-- Save current action bar setup
local function OGABPC_ActionBars_Save()
    wipe(OGABPC_Profiles[OGABPC_CurrentProfile])
    for i=1, 180 do
	    local slot = ("Slot_"..tostring(i))
		local ActionType = nil
		local ActionInfo = nil
        if C_ActionBar.HasAction(i) == true then
            PickupAction(i)

            ActionType = select(1, GetCursorInfo())
            if ActionType == "battlepet" then
                ActionInfo = select(2, GetCursorInfo())
            elseif ActionType == "equipmentset" then
                ActionInfo = select(2, GetCursorInfo())
            elseif ActionType == "flyout" then
                ActionInfo = select(3, GetCursorInfo())
            elseif ActionType == "item" then
                ActionInfo = select(3, GetCursorInfo())
            elseif ActionType == "macro" then
                ActionInfo = select(2, GetCursorInfo())
            elseif ActionType == "mount" then
                ActionInfo = select(2, GetCursorInfo())
			elseif ActionType == "outfit" then
			    ActionInfo = select(2, GetCursorInfo())
            elseif ActionType == "petaction" then
                if select(3, GetCursorInfo()) == nil then
				    ActionInfo = select(2, GetCursorInfo())
				else
				    ActionInfo = select(3, GetCursorInfo())
				end
            elseif ActionType == "spell" then
                if select(5, GetCursorInfo()) == nil then
				    ActionInfo = select(4, GetCursorInfo())
				else
				    ActionInfo = select(5, GetCursorInfo())
				end
            else
            end

            if ActionType == nil then

            else
                PlaceAction(i)
            end
        end
		
		OGABPC_Profiles[OGABPC_CurrentProfile][slot] = {ActionType, ActionInfo}
    end
end




-- Load current action bar setup
local function OGABPC_DetectID_Mount(input_mountID)
    local TotalNumberOfMounts = C_MountJournal.GetNumMounts()
    local MountIndex = 0
	    for i=1, TotalNumberOfMounts do
			if C_MountJournal.GetDisplayedMountID(i) == input_mountID then
				MountIndex = i
				break
			end
		end
	return MountIndex
end
local function OGABPC_DetectID_Flyout(input_flyoutID)
    local SpellbookSlotID = 0
    for i=1, 200 do
		local FlyoutInfo = C_SpellBook.GetSpellBookItemInfo(i, 0)
		if FlyoutInfo.iconID == input_flyoutID then
		    SpellbookSlotID = i
			break
		end
    end
	return SpellbookSlotID
end
local function OGABPC_DetectID_Flyout_Classic(input_flyoutID)
    local SpellbookSlotID = 0
    for i=1, 200 do
		local SpellTexture = GetSpellBookItemTexture(i, "spell")
		if SpellTexture == input_flyoutID then
		    SpellbookSlotID = i
			break
		end
    end
	return SpellbookSlotID
end


local function OGABPC_ActionBars_Load()
    for i=1, 180 do
	    local slot = ("Slot_"..tostring(i))
		local ActionType = OGABPC_Profiles[OGABPC_CurrentProfile][slot][1]
		local ActionInfo = OGABPC_Profiles[OGABPC_CurrentProfile][slot][2]
		if C_ActionBar.HasAction(i) == true then
		    PickupAction(i)
			ClearCursor()
		end
		
		if ActionType == nil then
		
		else
		    if ActionType == "battlepet" then
                C_PetJournal.PickupPet(ActionInfo)
			elseif ActionType == "equipmentset" then
			    local SetID = C_EquipmentSet.GetEquipmentSetID(ActionInfo)
                C_EquipmentSet.PickupEquipmentSet(SetID)
			elseif ActionType == "flyout" then	
				if select(4, GetBuildInfo()) > 120000 then
				    local SlotID = OGABPC_DetectID_Flyout(ActionInfo)
				    C_SpellBook.PickupSpellBookItem(SlotID, 0)
				else
				    local SlotID = OGABPC_DetectID_Flyout_Classic(ActionInfo)
					PickupSpellBookItem(SlotID, "spell")
				end
			elseif ActionType == "item" then
                C_Item.PickupItem(ActionInfo)
		    elseif ActionType == "macro" then
			    PickupMacro(ActionInfo)
			elseif ActionType == "mount" then
			    local DisplayID = OGABPC_DetectID_Mount(ActionInfo)
			    C_MountJournal.Pickup(DisplayID)
			elseif ActionType == "outfit" then
			    C_TransmogOutfitInfo.PickupOutfit(ActionInfo)
			elseif ActionType == "petaction" then
                PickupPetAction(ActionInfo)
		    elseif ActionType == "spell" then
			    C_Spell.PickupSpell(ActionInfo)
			
			else
			end
			PlaceAction(i)
		end
	end
end




-- Loading the action bar setup upon logging-in.
GRTK_Event_Setup_PlayerLogin = CreateFrame("Frame")
GRTK_Event_Setup_PlayerLogin:RegisterEvent("PLAYER_LOGIN")
GRTK_Event_Setup_PlayerLogin:SetScript("OnEvent", function(_, event)
    OGABPC_ActionBars_Load()
	OGABPC_SendMessage("Loaded keyboard loadout from profile: "..OGABPC_CurrentProfile)
end)




-- Keyboard shortcut command
function OGABPC_ChangeSetups()
    OGABPC_ActionBars_Save()
	OGABPC_SwapAddons()
end




SLASH_OGABPCSAVE1 = "/OGABPCSAVE"
SlashCmdList.OGABPCSAVE = function()
    OGABPC_ActionBars_Save()
	OGABPC_SendMessage("Saved current keyboard loadout to profile: "..OGABPC_CurrentProfile)
end


SLASH_OGABPCLOAD1 = "/OGABPCLOAD"
SlashCmdList.OGABPCLOAD = function()
    OGABPC_ActionBars_Load()
	OGABPC_SendMessage("Loaded keyboard loadout from profile: "..OGABPC_CurrentProfile)
end


SLASH_OGABPCSWAPPROFILE1 = "/OGABPCSWAPPROFILE"
SlashCmdList.OGABPCSWAPPROFILE = function()
    local OldProfile = OGABPC_CurrentProfile
	if OGABPC_CurrentProfile == "Keyboard" then
        OGABPC_CurrentProfile = "Gamepad"
	elseif OGABPC_CurrentProfile == "Gamepad" then
	    OGABPC_CurrentProfile = "Keyboard"
    end
	OGABPC_SendMessage("Changed current profile from "..OldProfile.." to "..OGABPC_CurrentProfile..".")
end


SLASH_OGABPCTOGGLEMESSAGES1 = "/OGABPCTOGGLEMESSAGES"
SlashCmdList.OGABPCTOGGLEMESSAGES = function()
    if OGABPC_Messages == "enabled" then
	    OGABPC_Messages = "disabled"
	    print("OGABPC - ".."Disabled Addon Messages.")
	elseif OGABPC_Messages == "disabled" then
	    OGABPC_Messages = "enabled"
	    print("OGABPC - ".."Enabled Addon Messages.")
	else
	end
end