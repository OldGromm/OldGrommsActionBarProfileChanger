-- Create minimap button
function OGABPC_CreateMinimapButton()
    local OGABPC_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("OGABPC_Minimap", {  
    	type = "data source",
    	icon = 133015,
    	OnClick = function(clickedframe, button)
            if button == "LeftButton" then
                OGABPC_ToggleOptionsMenu()
            elseif button == "MiddleButton" then
			    OGABPC_SwapProfilesMessage()
			elseif button == "RightButton" then
			    OGABPC_ToggleOptionsMenu()
            else
            end
        end,
        OnTooltipShow = function(tip)
		tip:AddLine("OldGromm's Action Bar Profile Changer", 1, 1, 1)
		tip:AddLine("Use the left or right mouse button to open the settings menu.")
        tip:AddLine("Use the middle mouse button to swap profiles.")
		tip:Show()
        end 
    })

    OGABPC_LibDBIcon:Register("OGABPC_Minimap", OGABPC_LDB, OGABPC_Minimap)
end