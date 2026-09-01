OGABPC_Profiles = OGABPC_Profiles or {}
OGABPC_Settings = OGABPC_Settings or {}
OGABPC_Minimap = OGABPC_Minimap or {}


OGABPC_LibDBIcon = LibStub("LibDBIcon-1.0")


OGABPC_MessageNamePause = false
OGABPC_AddonsInstalledTotal = C_AddOns.GetNumAddOns()


OGABPC_Icon = {}
OGABPC_Icon["Addons_Enabled"] = CreateAtlasMarkup("Capacitance-General-WorkOrderCheckmark", 16, 16)
OGABPC_Icon["Addons_Disabled"] = CreateAtlasMarkup("auctionhouse-ui-filter-redx", 16, 16)


---- Setup defaults
function OGABPC_ProfileIndexTextstring(input_number)
    local textstring = string.format("%02d", input_number)
	return textstring
end
function OGABPC_SlotTextstring(input_number)
    local textstring = string.format("%03d", input_number)
	return textstring
end

for i=1, 30 do
    local index = OGABPC_ProfileIndexTextstring(i)
    if OGABPC_Profiles[index] == nil then
        OGABPC_Profiles[index] = {}
    end
    if OGABPC_Profiles[index]["Name"] == nil then
        OGABPC_Profiles[index]["Name"] = ""
    end
    if OGABPC_Profiles[index]["Addons_Enabled"] == nil then
        OGABPC_Profiles[index]["Addons_Enabled"] = {}
    end
    if OGABPC_Profiles[index]["Addons_Disabled"] == nil then
        OGABPC_Profiles[index]["Addons_Disabled"] = {}
    end
    if OGABPC_Profiles[index]["Name"] == nil then
        OGABPC_Profiles[index]["Name"] = ""
    end
    if OGABPC_Profiles[index]["ActionBars"] == nil then
        OGABPC_Profiles[index]["ActionBars"] = {}
    end
    if OGABPC_Profiles[index]["ActionBarHasData"] == nil then
        OGABPC_Profiles[index]["ActionBarHasData"] = "no"
    end
    if OGABPC_Profiles[index]["SwapTarget"] == nil then
        OGABPC_Profiles[index]["SwapTarget"] = 0
    end
	for j=1, 180 do
	    local Slotname = OGABPC_SlotTextstring(j)
	    if OGABPC_Profiles[index]["ActionBars"][Slotname] == nil then
		    OGABPC_Profiles[index]["ActionBars"][Slotname] = {}
		end
	end
end



if OGABPC_Settings["CurrentProfile"] == nil then
    OGABPC_Settings["CurrentProfile"] = 1
end
if OGABPC_Settings["Messages"] == nil then
    OGABPC_Settings["Messages"] = "enabled"
end
if OGABPC_Settings["MinimapButton"] == nil then
    OGABPC_Settings["MinimapButton"] = "enabled"
end
if OGABPC_Settings["LoadOnLogin"] == nil then
    OGABPC_Settings["LoadOnLogin"] = "no"
end
if OGABPC_Settings["ProfileSwap_Next"] == nil then
    OGABPC_Settings["ProfileSwap_Next"] = 0
end
if OGABPC_Settings["MenuPosition"] == nil then
    OGABPC_Settings["MenuPosition"] = "CENTER"
end
if OGABPC_Settings["MenuPosition_X"] == nil then
    OGABPC_Settings["MenuPosition_X"] = 200
end
if OGABPC_Settings["MenuPosition_X"] == nil then
    OGABPC_Settings["MenuPosition_Y"] = -200
end



-- Creating various variables in advance, so they can be referenced later.
OGABPC_Frame_Dropdown_Profiles = nil
OGABPC_Frame_Dropdown_AddOnList_Enabled = nil
OGABPC_Frame_Dropdown_AddOnList_Enabled2 = nil
OGABPC_Frame_Dropdown_AddOnList_Enabled3 = nil
OGABPC_Frame_Dropdown_AddOnList_Disabled = nil
OGABPC_Frame_Dropdown_AddOnList_Disabled2 = nil
OGABPC_Frame_Dropdown_AddOnList_Disabled3 = nil
OGABPC_Frame_ProfileName_EditBox = nil
OGABPC_Frame_ProfileNumber2 = nil
OGABPC_Frame_Dropdown_Title_SwapTarget = nil
OGABPC_Frame_Dropdown_SwapProfiles = nil
OGABPC_Frame_MinimapButtonToggle = nil