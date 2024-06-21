local AddonName, HighLevelAlert = ...
HighLevelAlert:SetAddonOutput("HighLevelAlert", 136219)
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
    HighLevelAlert:SetVersion(AddonName, 136219, "0.4.34")
    hla_settings = HighLevelAlert:CreateFrame(
        {
            ["name"] = "HighLevelAlert",
            ["pTab"] = {"CENTER"},
            ["sw"] = 520,
            ["sh"] = 520,
            ["title"] = format("HighLevelAlert |T136219:16:16:0:0|t v|cff3FC7EB%s", "0.4.34")
        }
    )

    local y = -30
    if HLATAB["MMBTN"] == nil then
        HLATAB["MMBTN"] = true
    end

    HighLevelAlert:AddCategory(
        {
            ["name"] = "LID_GENERAL",
            ["parent"] = hla_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
        }
    )

    y = y - 15
    HighLevelAlert:CreateCheckbox(
        {
            ["name"] = "LID_SHOWMINIMAPBUTTON",
            ["parent"] = hla_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
            ["value"] = HLATAB["MMBTN"],
            ["funcV"] = function(sel, checked)
                HLATAB["MMBTN"] = checked
                if HLATAB["MMBTN"] then
                    HighLevelAlert:ShowMMBtn("HighLevelAlert")
                else
                    HighLevelAlert:HideMMBtn("HighLevelAlert")
                end
            end
        }
    )

    y = y - 45
    HighLevelAlert:AddCategory(
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

    HighLevelAlert:CreateCheckbox(
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
    HighLevelAlert:CreateSlider(
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

    HighLevelAlert:CreateCheckbox(
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

    HighLevelAlert:CreateMinimapButton(
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
                HighLevelAlert:SV(HLATAB, "MMBTN", false)
                HighLevelAlert:MSG("Minimap Button is now hidden.")
                HighLevelAlert:HideMMBtn("HighLevelAlert")
            end,
        }
    )

    HighLevelAlert:AddSlash("hla", HighLevelAlert.ToggleSettings)
    HighLevelAlert:AddSlash("highlevelalert", HighLevelAlert.ToggleSettings)
    if HighLevelAlert:GV(HLATAB, "MMBTN", true) then
        HighLevelAlert:ShowMMBtn("HighLevelAlert")
    else
        HighLevelAlert:HideMMBtn("HighLevelAlert")
    end
end
