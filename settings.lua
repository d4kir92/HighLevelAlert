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
    HighLevelAlert:SetVersion(AddonName, 136219, "0.4.48")
    hla_settings = HighLevelAlert:CreateFrame(
        {
            ["name"] = "HighLevelAlert",
            ["pTab"] = {"CENTER"},
            ["sw"] = 520,
            ["sh"] = 520,
            ["title"] = format("HighLevelAlert |T136219:16:16:0:0|t v|cff3FC7EB%s", "0.4.48")
        }
    )

    hla_settings.SF = CreateFrame("ScrollFrame", "hla_settings_SF", hla_settings, "UIPanelScrollFrameTemplate")
    hla_settings.SF:SetPoint("TOPLEFT", hla_settings, 8, -26)
    hla_settings.SF:SetPoint("BOTTOMRIGHT", hla_settings, -32, 8)
    hla_settings.SC = CreateFrame("Frame", "hla_settings_SC", hla_settings.SF)
    hla_settings.SC:SetSize(hla_settings.SF:GetSize())
    hla_settings.SC:SetPoint("TOPLEFT", hla_settings.SF, "TOPLEFT", 0, 0)
    hla_settings.SF:SetScrollChild(hla_settings.SC)
    local y = 0
    HighLevelAlert:SetAppendY(y)
    HighLevelAlert:SetAppendParent(hla_settings.SC)
    HighLevelAlert:SetAppendTab(HLATAB)
    HighLevelAlert:AppendCategory("GENERAL")
    HighLevelAlert:AppendCheckbox(
        "MMBTN",
        HighLevelAlert:GetWoWBuild() ~= "RETAIL",
        function(sel, checked)
            if checked then
                HighLevelAlert:ShowMMBtn("HighLevelAlert")
            else
                HighLevelAlert:HideMMBtn("HighLevelAlert")
            end
        end
    )

    HighLevelAlert:AppendCategory("TEXT")
    HighLevelAlert:AppendCheckbox(
        "SHOWTEXT",
        true,
        function(sel, checked)
            HighLevelAlert:SetShowText(checked)
        end
    )

    HighLevelAlert:AppendSlider(
        "TEXTSCALE",
        1,
        0.4,
        2,
        0.1,
        1,
        function(sel, val)
            if val then
                TMTAB["TEXTSCALE"] = val
                ThreatMeter:SetTextScale(val)
            end
        end
    )

    HighLevelAlert:AppendCheckbox(
        "SHOWWARNINGFORPLAYERS",
        true,
        function(sel, checked)
            HighLevelAlert:SetShowText(checked)
        end
    )

    HighLevelAlert:AddSlash("hla", HighLevelAlert.ToggleSettings)
    HighLevelAlert:AddSlash("highlevelalert", HighLevelAlert.ToggleSettings)
    HighLevelAlert:CreateMinimapButton(
        {
            ["name"] = "HighLevelAlert",
            ["icon"] = 136219,
            ["dbtab"] = HLATAB,
            ["vTT"] = {{"HighLevelAlert |T136219:16:16:0:0|t", "v|cff3FC7EB0.4.48"}, {"Leftclick", "Toggle Settings"}, {"Rightclick", "Unlock/lock Text"}, {"Shift + Rightclick", "Hide Minimap Icon"}},
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

    if HighLevelAlert:GV(HLATAB, "MMBTN", HighLevelAlert:GetWoWBuild() ~= "RETAIL") then
        HighLevelAlert:ShowMMBtn("HighLevelAlert")
    else
        HighLevelAlert:HideMMBtn("HighLevelAlert")
    end
end
