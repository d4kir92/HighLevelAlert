local AddonName, HighLevelAlert = ...
local hla_settings = nil
function HighLevelAlert:ToggleSettings()
    if hla_settings then
        if hla_settings:IsShown() then
            hla_settings:Hide()
        else
            hla_settings:Show()
        end
    end
end

function HighLevelAlert:InitSettings()
    HLATAB = HLATAB or {}
    D4:SetVersion(AddonName, 136219, "0.4.25")
    hla_settings = D4:CreateFrame(
        {
            ["name"] = "HighLevelAlert",
            ["pTab"] = {"CENTER"},
            ["sw"] = 520,
            ["sh"] = 520,
            ["title"] = format("HighLevelAlert |T136219:16:16:0:0|t v|cff3FC7EB%s", "0.4.25")
        }
    )

    local y = -30
    if HLATAB["MMBTN"] == nil then
        HLATAB["MMBTN"] = true
    end

    D4:AddCategory(
        {
            ["name"] = "LID_GENERAL",
            ["parent"] = hla_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
        }
    )

    y = y - 15
    D4:CreateCheckbox(
        {
            ["name"] = "LID_SHOWMINIMAPBUTTON",
            ["parent"] = hla_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
            ["value"] = HLATAB["MMBTN"],
            ["funcV"] = function(sel, checked)
                HLATAB["MMBTN"] = checked
                if HLATAB["MMBTN"] then
                    D4:ShowMMBtn("HighLevelAlert")
                else
                    D4:HideMMBtn("HighLevelAlert")
                end
            end
        }
    )

    y = y - 45
    D4:AddCategory(
        {
            ["name"] = "LID_TEXT",
            ["parent"] = hla_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
        }
    )

    y = y - 15
    if HLATAB["SHOWTEXT"] == nil then
        HLATAB["SHOWTEXT"] = true
    end

    D4:CreateCheckbox(
        {
            ["name"] = "LID_SHOWTEXT",
            ["parent"] = hla_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
            ["value"] = HLATAB["SHOWTEXT"],
            ["funcV"] = function(sel, checked)
                HLATAB["SHOWTEXT"] = checked
                HighLevelAlert:SetShowText(checked)
            end
        }
    )

    y = y - 45
    HLATAB["TEXTSCALE"] = HLATAB["TEXTSCALE"] or 1
    D4:CreateSlider(
        {
            ["name"] = "LID_TEXTSCALE",
            ["parent"] = hla_settings,
            ["sw"] = 400,
            ["pTab"] = {"TOPLEFT", 15, y},
            ["vmin"] = 0.4,
            ["vmax"] = 2.0,
            ["value"] = HLATAB["TEXTSCALE"],
            ["steps"] = 0.1,
            ["funcV"] = function(sel, val)
                if val then
                    HLATAB["TEXTSCALE"] = val
                    HighLevelAlert:SetTextScale(val)
                end
            end,
        }
    )

    y = y - 45
    if HLATAB["SHOWWARNINGFORPLAYERS"] == nil then
        HLATAB["SHOWWARNINGFORPLAYERS"] = true
    end

    D4:CreateCheckbox(
        {
            ["name"] = "LID_SHOWWARNINGFORPLAYERS",
            ["parent"] = hla_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
            ["value"] = HLATAB["SHOWWARNINGFORPLAYERS"],
            ["funcV"] = function(sel, checked)
                HLATAB["SHOWWARNINGFORPLAYERS"] = checked
            end
        }
    )

    D4:CreateMinimapButton(
        {
            ["name"] = "HighLevelAlert",
            ["icon"] = 136219,
            ["dbtab"] = HLATAB,
            ["vTT"] = {"HighLevelAlert", "Leftclick - Toggle Settings", "Rightclick - Unlock/lock Text", "Shift + Rightclick - Hide Minimap Icon"},
            ["funcL"] = function()
                HighLevelAlert:ToggleSettings()
            end,
            ["funcR"] = function()
                HighLevelAlert:ToggleFrame()
            end,
            ["funcSR"] = function()
                D4:SV(HLATAB, "MMBTN", false)
                D4:MSG("HighLevelAlert", 136219, "Minimap Button is now hidden.")
                D4:HideMMBtn("HighLevelAlert")
            end,
        }
    )

    D4:AddSlash("hla", HighLevelAlert.ToggleSettings)
    D4:AddSlash("highlevelalert", HighLevelAlert.ToggleSettings)
    if D4:GV(HLATAB, "MMBTN", true) then
        D4:ShowMMBtn("HighLevelAlert")
    else
        D4:HideMMBtn("HighLevelAlert")
    end
end
