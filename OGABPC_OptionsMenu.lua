-- Mainframe
local OGABPC_Frame_Main = CreateFrame("Frame", "OGABPC_MainFrame", UIParent, "BasicFrameTemplate")
OGABPC_Frame_Main:SetPoint(OGABPC_Settings["MenuPosition"], OGABPC_Settings["MenuPosition_X"], OGABPC_Settings["MenuPosition_Y"])
OGABPC_Frame_Main:SetSize(550, 300)
OGABPC_Frame_Main:SetIgnoreParentScale(true)
OGABPC_Frame_Main:EnableMouse(true)
OGABPC_Frame_Main:SetMovable(true)
OGABPC_Frame_Main:RegisterForDrag("LeftButton")
OGABPC_Frame_Main:SetScript("OnDragStart", function(self, button)
	    self:StartMoving()
    end)
OGABPC_Frame_Main:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
	local point, _, _, point_x, point_y = OGABPC_Frame_Main:GetPoint()
	OGABPC_Settings["MenuPosition"] = point
	OGABPC_Settings["MenuPosition_X"] = point_x
	OGABPC_Settings["MenuPosition_Y"] = point_y
end)
OGABPC_Frame_Main:Hide()
tinsert(UISpecialFrames, OGABPC_Frame_Main:GetName())

function OGABPC_ToggleOptionsMenu()
    if OGABPC_Frame_Main:IsShown() == true then
	    OGABPC_Frame_Main:Hide()
	elseif OGABPC_Frame_Main:IsShown() == false then
	    OGABPC_Frame_Main:Show()
	else
	end
end



-- Menu title
local OGABPC_Frame_MenuTitle = OGABPC_Frame_Main:CreateFontString(nil, "OVERLAY", "OGABPCCustomFont")
OGABPC_Frame_MenuTitle:SetPoint("TOP", 0, -2)
OGABPC_Frame_MenuTitle:SetText("OldGromm's Action Bar Profile Changer")




-- Extra frame to hide all elements at first before the first profile has been selected.
local OGABPC_Frame_HiddenElements = CreateFrame("Frame", nil, OGABPC_MainFrame)
OGABPC_Frame_HiddenElements:SetPoint("CENTER")
OGABPC_Frame_HiddenElements:SetSize(550, 300)
OGABPC_Frame_HiddenElements:Hide()




-- Profile Name
---- Profile Name Number
local OGABPC_Frame_ProfileNumber = OGABPC_Frame_HiddenElements:CreateFontString(nil, "OVERLAY", "OGABPCCustomFont")
OGABPC_Frame_ProfileNumber:SetPoint("TOPLEFT", 170, -35)
OGABPC_Frame_ProfileNumber:SetText("Profile Number:")
OGABPC_Frame_ProfileNumber2 = OGABPC_Frame_HiddenElements:CreateFontString(nil, "OVERLAY", "OGABPCCustomFont")
OGABPC_Frame_ProfileNumber2:SetPoint("TOPLEFT", 300, -35)




---- Profile Name Editbox
local OGABPC_Frame_ProfileName_Backdrop = CreateFrame("Frame", nil, OGABPC_Frame_HiddenElements, "BackdropTemplate")
OGABPC_Frame_ProfileName_Backdrop:SetPoint("TOPLEFT", 16, -60)
OGABPC_Frame_ProfileName_Backdrop:SetSize(280, 40)
OGABPC_Frame_ProfileName_Backdrop:SetBackdrop(BACKDROP_SLIDER_8_8)

OGABPC_Frame_ProfileName_EditBox = CreateFrame("EditBox", nil, OGABPC_Frame_HiddenElements, "OGABPCInputBoxTemplate")
OGABPC_Frame_ProfileName_EditBox:SetPoint("TOPLEFT", 17, -65)
OGABPC_Frame_ProfileName_EditBox:SetSize(280, 30)
OGABPC_Frame_ProfileName_EditBox:SetFontObject("OGABPCCustomFont")
OGABPC_Frame_ProfileName_EditBox:SetAutoFocus(false)
OGABPC_Frame_ProfileName_EditBox:SetTextInsets(5, 0, 0, 0) 
OGABPC_Frame_ProfileName_EditBox:SetJustifyH("LEFT")
OGABPC_Frame_ProfileName_EditBox:SetScript("OnTextChanged", function(self)
    if OGABPC_MessageNamePause == false then
	    local profileindex = OGABPC_ProfileIndexTextstring(OGABPC_Settings["CurrentProfile"])
        local text = OGABPC_Frame_ProfileName_EditBox:GetText()
	    local count = strlenutf8(text)
	    if count > 25 then
		    OGABPC_MessageNamePause = true
	        local textnew = string.sub(text, 0, 25)
		    OGABPC_Frame_ProfileName_EditBox:SetText(textnew)
		    OGABPC_Profiles[profileindex]["Name"] = textnew
			RunNextFrame(function()
                OGABPC_MessageNamePause = false
            end)
	    else
	        OGABPC_Profiles[profileindex]["Name"] = OGABPC_Frame_ProfileName_EditBox:GetText()
		end
	end
end)




-- Save Current Action Bar Setup
local OGABPC_Frame_ActionBarSave = CreateFrame("Button", nil, OGABPC_Frame_HiddenElements, "OGABPCButtonTemplate")
    OGABPC_Frame_ActionBarSave:SetPoint("TOPLEFT", 15, -103)
    OGABPC_Frame_ActionBarSave:SetSize(60, 35)
    OGABPC_Frame_ActionBarSave:SetText("Save")
    OGABPC_Frame_ActionBarSave:SetScript("OnClick", function(self, button, down)
        OGABPC_CombatCheckWarning("Save")
    end)
    OGABPC_Frame_ActionBarSave:RegisterForClicks("AnyUp")




-- Load Current Action Bar Setup
local OGABPC_Frame_ActionBarLoad = CreateFrame("Button", nil, OGABPC_Frame_HiddenElements, "OGABPCButtonTemplate")
    OGABPC_Frame_ActionBarLoad:SetPoint("TOPLEFT", 85, -103)
    OGABPC_Frame_ActionBarLoad:SetSize(60, 35)
    OGABPC_Frame_ActionBarLoad:SetText("Load")
    OGABPC_Frame_ActionBarLoad:SetScript("OnClick", function(self, button, down)
        OGABPC_CombatCheckWarning("Load")
    end)
    OGABPC_Frame_ActionBarLoad:RegisterForClicks("AnyUp")




-- Reset Current Action Bar Setup
local OGABPC_Frame_ActionBarReset = CreateFrame("Button", nil, OGABPC_Frame_HiddenElements, "OGABPCButtonTemplate")
    OGABPC_Frame_ActionBarReset:SetPoint("TOPLEFT", 155, -103)
    OGABPC_Frame_ActionBarReset:SetSize(159, 35)
    OGABPC_Frame_ActionBarReset:SetText("Reset Action Bars")
    OGABPC_Frame_ActionBarReset:SetScript("OnClick", function(self, button, down)
        OGABPC_CombatCheckWarning("ResetActionBars")
    end)
    OGABPC_Frame_ActionBarReset:RegisterForClicks("AnyUp")




-- Reset Profile + Action Bar Setup
local OGABPC_Frame_ProfileReset = CreateFrame("Button", nil, OGABPC_Frame_HiddenElements, "OGABPCButtonTemplate")
    OGABPC_Frame_ProfileReset:SetPoint("TOPLEFT", 320, -103)
    OGABPC_Frame_ProfileReset:SetSize(125, 35)
    OGABPC_Frame_ProfileReset:SetText("Reset Profile")
    OGABPC_Frame_ProfileReset:SetScript("OnClick", function(self, button, down)
        OGABPC_CombatCheckWarning("ResetProfile")
    end)
    OGABPC_Frame_ProfileReset:RegisterForClicks("AnyUp")
    OGABPC_Frame_ProfileReset:SetScript("OnEnter", function(self, motion)
	    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
	    GameTooltip:SetText("Note: This will both clear your current action bars as well as empty the profile data.")
    end)
        OGABPC_Frame_ProfileReset:SetScript("OnLeave", function(self, motion)
	    GameTooltip:Hide()
    end)




-- Update Menu
local function OGABPC_UpdateMenu(input_number)
    OGABPC_Settings["CurrentProfile"] = input_number

    OGABPC_Frame_ProfileNumber2:SetText(tostring(input_number))

    local index = OGABPC_ProfileIndexTextstring(input_number)
    OGABPC_Frame_ProfileName_EditBox:SetText(OGABPC_Profiles[index]["Name"])

	OGABPC_Frame_Dropdown_Profiles:GenerateMenu()
	OGABPC_Frame_Dropdown_AddOnList_Enabled:GenerateMenu()
	OGABPC_Frame_Dropdown_AddOnList_Disabled:GenerateMenu()

    OGABPC_CheckSwapProfileDisplayStatus()

	if OGABPC_AddonsInstalledTotal >30 then
        OGABPC_Frame_Dropdown_AddOnList_Enabled2:GenerateMenu()
        OGABPC_Frame_Dropdown_AddOnList_Disabled2:GenerateMenu()
        OGABPC_Frame_Dropdown_AddOnList_Enabled2:Show()
        OGABPC_Frame_Dropdown_AddOnList_Disabled2:Show()
	else
        OGABPC_Frame_Dropdown_AddOnList_Enabled2:Hide()
        OGABPC_Frame_Dropdown_AddOnList_Disabled2:Hide()
	end

	if OGABPC_AddonsInstalledTotal >60 then
        OGABPC_Frame_Dropdown_AddOnList_Enabled3:GenerateMenu()
        OGABPC_Frame_Dropdown_AddOnList_Disabled3:GenerateMenu()
        OGABPC_Frame_Dropdown_AddOnList_Enabled3:Show()
        OGABPC_Frame_Dropdown_AddOnList_Disabled3:Show()
	else
        OGABPC_Frame_Dropdown_AddOnList_Enabled3:Hide()
        OGABPC_Frame_Dropdown_AddOnList_Disabled3:Hide()
	end
end




-- Profiles List
OGABPC_Frame_Dropdown_Profiles = CreateFrame("DropdownButton", nil, OGABPC_MainFrame, "OGABPCDropdownProfiles")
OGABPC_Frame_Dropdown_Profiles:SetDefaultText("Select Profile")
OGABPC_Frame_Dropdown_Profiles:SetPoint("TOPLEFT", 15, -30)
OGABPC_Frame_Dropdown_Profiles:SetupMenu(function(dropdown, rootDescription)
    for i=1, 30 do
	    local index = OGABPC_ProfileIndexTextstring(i)
	    rootDescription:CreateButton(OGABPC_Profiles[index]["Name"], function()
		    OGABPC_Frame_HiddenElements:Show()
		    OGABPC_UpdateMenu(i)
		end)
	end
end)




-- Addon Enabled/Disabled List
---- create addon name with icon
local function OGABPC_GetAddonNameTextstring(input_name, input_type)
    local textstring = ""
	if OGABPC_CheckAddonsList(input_name, input_type) == true then
	    textstring = (OGABPC_Icon[input_type].." "..input_name)
	else
	    textstring = input_name
	end
    return textstring
end

---- titles
local OGABPC_Frame_Dropdown_Title_Enabled = OGABPC_Frame_HiddenElements:CreateFontString(nil, "OVERLAY", "OGABPCCustomFont")
OGABPC_Frame_Dropdown_Title_Enabled:SetPoint("TOPLEFT", 15, -160)
OGABPC_Frame_Dropdown_Title_Enabled:SetText("Enable Addons:")
local OGABPC_Frame_Dropdown_Title_Disabled = OGABPC_Frame_HiddenElements:CreateFontString(nil, "OVERLAY", "OGABPCCustomFont")
OGABPC_Frame_Dropdown_Title_Disabled:SetPoint("TOPLEFT", 185, -160)
OGABPC_Frame_Dropdown_Title_Disabled:SetText("Disable Addons:")

---- dropdown menu (enabled)
OGABPC_Frame_Dropdown_AddOnList_Enabled = CreateFrame("DropdownButton", nil, OGABPC_Frame_HiddenElements, "OGABPCDropdownAddonList")
OGABPC_Frame_Dropdown_AddOnList_Enabled:SetDefaultText("Entries 1 - 30")
OGABPC_Frame_Dropdown_AddOnList_Enabled:SetPoint("TOPLEFT", 15, -190)
OGABPC_Frame_Dropdown_AddOnList_Enabled:SetupMenu(function(dropdown, rootDescription)
    for i=1, 30 do
	    if i > OGABPC_AddonsInstalledTotal then
		
		else
		    local addonname = C_AddOns.GetAddOnName(i)
		    local dropdowntext = OGABPC_GetAddonNameTextstring(addonname, "Addons_Enabled")
	        rootDescription:CreateButton(dropdowntext, function()
		        OGABPC_UpdateAddonsList(addonname, "Addons_Enabled")
		    end)
		end
	end
end)
OGABPC_Frame_Dropdown_AddOnList_Enabled2 = CreateFrame("DropdownButton", nil, OGABPC_Frame_HiddenElements, "OGABPCDropdownAddonList")
OGABPC_Frame_Dropdown_AddOnList_Enabled2:SetDefaultText("Entries 31 - 60")
OGABPC_Frame_Dropdown_AddOnList_Enabled2:SetPoint("TOPLEFT", 15, -220)
OGABPC_Frame_Dropdown_AddOnList_Enabled2:SetupMenu(function(dropdown, rootDescription)
    for i=31, 60 do
	    if i > OGABPC_AddonsInstalledTotal then
		
		else
		    local addonname = C_AddOns.GetAddOnName(i)
		    local dropdowntext = OGABPC_GetAddonNameTextstring(addonname, "Addons_Enabled")
	        rootDescription:CreateButton(dropdowntext, function()
		        OGABPC_UpdateAddonsList(addonname, "Addons_Enabled")
		    end)
		end
	end
end)
OGABPC_Frame_Dropdown_AddOnList_Enabled3 = CreateFrame("DropdownButton", nil, OGABPC_Frame_HiddenElements, "OGABPCDropdownAddonList")
OGABPC_Frame_Dropdown_AddOnList_Enabled3:SetDefaultText("Entries 61 - 90")
OGABPC_Frame_Dropdown_AddOnList_Enabled3:SetPoint("TOPLEFT", 15, -250)
OGABPC_Frame_Dropdown_AddOnList_Enabled3:SetupMenu(function(dropdown, rootDescription)
    for i=61, 90 do
	    if i > OGABPC_AddonsInstalledTotal then
		
		else
		    local addonname = C_AddOns.GetAddOnName(i)
		    local dropdowntext = OGABPC_GetAddonNameTextstring(addonname, "Addons_Enabled")
	        rootDescription:CreateButton(dropdowntext, function()
		        OGABPC_UpdateAddonsList(addonname, "Addons_Enabled")
		    end)
		end
	end
end)

---- dropdown menu (disabled)
OGABPC_Frame_Dropdown_AddOnList_Disabled = CreateFrame("DropdownButton", nil, OGABPC_Frame_HiddenElements, "OGABPCDropdownAddonList")
OGABPC_Frame_Dropdown_AddOnList_Disabled:SetDefaultText("Entries 1 - 30")
OGABPC_Frame_Dropdown_AddOnList_Disabled:SetPoint("TOPLEFT", 180, -190)
OGABPC_Frame_Dropdown_AddOnList_Disabled:SetupMenu(function(dropdown, rootDescription)
    for i=1, 30 do
	    if i > OGABPC_AddonsInstalledTotal then
		
		else
		    local addonname = C_AddOns.GetAddOnName(i)
		    local dropdowntext = OGABPC_GetAddonNameTextstring(addonname, "Addons_Disabled")
	        rootDescription:CreateButton(dropdowntext, function()
		        OGABPC_UpdateAddonsList(addonname, "Addons_Disabled")
		    end)
		end
	end
end)
OGABPC_Frame_Dropdown_AddOnList_Disabled2 = CreateFrame("DropdownButton", nil, OGABPC_Frame_HiddenElements, "OGABPCDropdownAddonList")
OGABPC_Frame_Dropdown_AddOnList_Disabled2:SetDefaultText("Entries 31 - 60")
OGABPC_Frame_Dropdown_AddOnList_Disabled2:SetPoint("TOPLEFT", 180, -220)
OGABPC_Frame_Dropdown_AddOnList_Disabled2:SetupMenu(function(dropdown, rootDescription)
    for i=31, 60 do
	    if i > OGABPC_AddonsInstalledTotal then
		
		else
		    local addonname = C_AddOns.GetAddOnName(i)
		    local dropdowntext = OGABPC_GetAddonNameTextstring(addonname, "Addons_Disabled")
	        rootDescription:CreateButton(dropdowntext, function()
		        OGABPC_UpdateAddonsList(addonname, "Addons_Disabled")
		    end)
		end
	end
end)
OGABPC_Frame_Dropdown_AddOnList_Disabled3 = CreateFrame("DropdownButton", nil, OGABPC_Frame_HiddenElements, "OGABPCDropdownAddonList")
OGABPC_Frame_Dropdown_AddOnList_Disabled3:SetDefaultText("Entries 61 - 90")
OGABPC_Frame_Dropdown_AddOnList_Disabled3:SetPoint("TOPLEFT", 180, -250)
OGABPC_Frame_Dropdown_AddOnList_Disabled3:SetupMenu(function(dropdown, rootDescription)
    for i=61, 90 do
	    if i > OGABPC_AddonsInstalledTotal then
		
		else
		    local addonname = C_AddOns.GetAddOnName(i)
		    local dropdowntext = OGABPC_GetAddonNameTextstring(addonname, "Addons_Disabled")
	        rootDescription:CreateButton(dropdowntext, function()
		        OGABPC_UpdateAddonsList(addonname, "Addons_Disabled")
		    end)
		end
	end
end)




-- Other Settings
local OGABPC_Frame_Dropdown_Title_Disabled = OGABPC_MainFrame:CreateFontString(nil, "OVERLAY", "OGABPCCustomFont")
OGABPC_Frame_Dropdown_Title_Disabled:SetPoint("TOPRIGHT", -22, -35)
OGABPC_Frame_Dropdown_Title_Disabled:SetText("Other Settings:")




-- Enable/disable messages toggle
---- Checkbox frame
local OGABPC_Frame_ShowMessagesCheckbox = CreateFrame("CheckButton", nil, OGABPC_MainFrame, "SettingsCheckboxTemplate")
OGABPC_Frame_ShowMessagesCheckbox:SetPoint("TOPRIGHT", -20, -55)
OGABPC_Frame_ShowMessagesCheckbox:SetSize(30, 30)
OGABPC_Frame_ShowMessagesCheckbox:RegisterForClicks("AnyDown")
OGABPC_Frame_ShowMessagesCheckbox:SetScript("OnClick", function (self, button, down)
    OGABPC_ToggleAddonMessages()
end)
OGABPC_Frame_ShowMessagesCheckbox:SetScript("OnEnter", function(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
	GameTooltip:SetText("Enable/disable add-on messages in chat.")
end)
OGABPC_Frame_ShowMessagesCheckbox:SetScript("OnLeave", function(self, motion)
	GameTooltip:Hide()
end)

---- One-time check to startup to check what the player's setting for messages are.
if OGABPC_Settings["Messages"] == "enabled" then
    OGABPC_Frame_ShowMessagesCheckbox:SetChecked(true)
elseif OGABPC_Settings["Messages"] == "disabled" then
    OGABPC_Frame_ShowMessagesCheckbox:SetChecked(false)
else
end




-- Hide/show minimap button
---- Checkbox frame
OGABPC_Frame_MinimapButtonToggle = CreateFrame("CheckButton", nil, OGABPC_MainFrame, "SettingsCheckboxTemplate")
OGABPC_Frame_MinimapButtonToggle:SetPoint("TOPRIGHT", -60, -55)
OGABPC_Frame_MinimapButtonToggle:SetSize(30, 30)
OGABPC_Frame_MinimapButtonToggle:RegisterForClicks("AnyDown")
OGABPC_Frame_MinimapButtonToggle:SetScript("OnClick", function (self, button, down)
    OGABPC_ToggleMinimapButton()
end)
OGABPC_Frame_MinimapButtonToggle:SetScript("OnEnter", function(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
	GameTooltip:SetText("Show/hide the minimap button.")
end)
OGABPC_Frame_MinimapButtonToggle:SetScript("OnLeave", function(self, motion)
	GameTooltip:Hide()
end)




-- Swap Profiles Dropdowns
---- title
OGABPC_Frame_Dropdown_Title_SwapTarget = OGABPC_Frame_HiddenElements:CreateFontString(nil, "OVERLAY", "OGABPCCustomFont")
OGABPC_Frame_Dropdown_Title_SwapTarget:SetPoint("TOPRIGHT", -30, -160)
OGABPC_Frame_Dropdown_Title_SwapTarget:SetText("Swap Profile:")

OGABPC_Frame_Dropdown_SwapProfiles = CreateFrame("DropdownButton", nil, OGABPC_Frame_HiddenElements, "OGABPCDropdownAddonList")
OGABPC_Frame_Dropdown_SwapProfiles:SetDefaultText("Swap Target")
OGABPC_Frame_Dropdown_SwapProfiles:SetPoint("TOPRIGHT", -30, -190)
OGABPC_Frame_Dropdown_SwapProfiles:SetupMenu(function(dropdown, rootDescription)
    for i=1, 30 do
	    local new_number = i
		local new_index = OGABPC_ProfileIndexTextstring(i)
		local new_name = OGABPC_Profiles[new_index]["Name"]
		local hasdata = OGABPC_Profiles[new_index]["ActionBarHasData"]
		local old_number = OGABPC_Settings["CurrentProfile"]
	    local old_index = OGABPC_ProfileIndexTextstring(old_number)
		local old_name = OGABPC_Profiles[old_index]["Name"]
		if hasdata == "yes" and i ~= old_number then
	        rootDescription:CreateButton(new_name, function()
		        OGABPC_Profiles[old_index]["SwapTarget"] = new_number
                OGABPC_Profiles[new_index]["SwapTarget"] = old_number
				OGABPC_SendMessage("The current profile ("..old_name..") will swap with the following profile: ("..new_name..").")
		    end)
		end
	end
end)