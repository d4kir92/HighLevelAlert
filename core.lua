local AddOnName, HighLevelAlert = ...

function HighLevelAlert:MSG(msg)
	print("[|cffff6060" .. AddOnName .. "|r] " .. msg)
end

local hla = CreateFrame("Frame", nil, UIParent)
hla:SetSize(800, 50)
hla:SetPoint("CENTER", 0, 200)
hla:Hide()
hla:SetMovable(true)
hla:EnableMouse(true)

hla:SetScript("OnMouseDown", function(self, button)
	HLATAB.hlaFixed = HLATAB.hlaFixed or false

	if button == "LeftButton" and not self.isMoving then
		if not HLATAB.hlaFixed then
			self:StartMoving()
			self.isMoving = true
		else
			HighLevelAlert:MSG("Warning is fixed. (not movable) (rightclick it to unlock)")
		end
	elseif button == "RightButton" then
		HLATAB.hlaFixed = not HLATAB.hlaFixed
		hla:SetMovable(not HLATAB.hlaFixed)

		if HLATAB.hlaFixed then
			HighLevelAlert:MSG("Warning is now fixed. (not movable)")
		else
			HighLevelAlert:MSG("Warning is now not fixed. (movable)")
		end
	end
end)

hla:SetScript("OnMouseUp", function(self, button)
	HLATAB.hlaFixed = HLATAB.hlaFixed or false

	if button == "LeftButton" and self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = false
		local point, _, relPoint, x, y = self:GetPoint()

		HLATAB.hlaPosition = {point, "UIParent", relPoint, x, y}
	end
end)

hla.text = hla:CreateFontString(nil, "ARTWORK")
hla.text:SetAllPoints(true)
hla.text:SetFont("Fonts\\FRIZQT__.TTF", 30)
hla.text:SetText("")
hla:RegisterEvent("ADDON_LOADED")

hla:SetScript("OnEvent", function(self, event, addonName)
	HLATAB = HLATAB or {}

	if event == "ADDON_LOADED" and addonName == AddOnName then
		hla:ClearAllPoints()

		if HLATAB.hlaPosition then
			local p1, p2, p3, p4, p5 = unpack(HLATAB.hlaPosition)
			hla:SetPoint(p1, p2, p3, p4, p5)
		else
			hla:SetPoint("CENTER", UIParent, "CENTER")
		end

		for i = 1, 60 do
			SetCVar("nameplateMaxDistance", i)
		end

		self:UnregisterEvent("ADDON_LOADED")
	end
end)

local NPPvp = {}
local NPSkullElite = {}
local NPSkull = {}
local NPRedElite = {}
local NPRed = {}

local function UpdateText()
	local NPPvpCount = #NPPvp
	local NPSkullEliteCount = #NPSkullElite
	local NPSkullCount = #NPSkull
	local NPRedEliteCount = #NPRedElite
	local NPRedCount = #NPRed

	if NPPvpCount > 0 then
		hla.text:SetText("|cffff0000[Warning]|r: " .. NPPvpCount .. " PVP-Player nearby!")
		hla:Show()
	elseif NPSkullEliteCount > 0 then
		hla.text:SetText("|cffff0000[Warning]|r: " .. NPSkullEliteCount .. " Skull Elites nearby!")
		hla:Show()
	elseif NPSkullCount > 0 then
		hla.text:SetText("|cffff0000[Warning]|r: " .. NPSkullCount .. " Skulls nearby!")
		hla:Show()
	elseif NPRedEliteCount > 0 then
		hla.text:SetText("|cffeda55f[Caution]|r: " .. NPRedEliteCount .. " Red Elites nearby!")
		hla:Show()
	elseif NPRedCount > 0 then
		hla.text:SetText("|cffeda55f[Caution]|r: " .. NPRedCount .. " Reds nearby!")
		hla:Show()
	else
		hla.text:SetText("")
		hla:Hide()
	end
end

local FUA = CreateFrame("Frame")
FUA:RegisterEvent("NAME_PLATE_UNIT_ADDED")

FUA:SetScript("OnEvent", function(self, event, unit)
	local level = UnitLevel(unit)
	local classification = UnitClassification(unit)
	local isElite = classification == "worldboss" or classification == "rareelite" or classification == "elite"
	local isEnemy = UnitIsEnemy("player", unit)
	local isPlayer = UnitIsPlayer(unit)

	if level and isEnemy then
		local playerLevel = UnitLevel("player")
		local isSkull = level == -1 or level >= playerLevel + 10
		local isRed = level >= playerLevel + 3

		if isPlayer then
			PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE or SOUNDKIT.RAID_WARNING)
			table.insert(NPPvp, unit)
		elseif isSkull and isElite then
			PlaySound(SOUNDKIT.RAID_WARNING)
			table.insert(NPSkullElite, unit)
		elseif isSkull then
			PlaySound(SOUNDKIT.READY_CHECK or SOUNDKIT.RAID_WARNING)
			table.insert(NPSkull, unit)
		elseif isRed and isElite then
			PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_2 or SOUNDKIT.RAID_WARNING)
			table.insert(NPRedElite, unit)
		elseif isRed then
			PlaySound(SOUNDKIT.GS_LOGIN or SOUNDKIT.RAID_WARNING)
			table.insert(NPRed, unit)
		end

		UpdateText()
	end
end)

local FUR = CreateFrame("Frame")
FUR:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

FUR:SetScript("OnEvent", function(self, event, unit)
	local removed = false

	for i, u in ipairs(NPPvp) do
		if u == unit then
			table.remove(NPPvp, i)
			removed = true
			break
		end
	end

	if not removed then
		for i, u in ipairs(NPSkullElite) do
			if u == unit then
				table.remove(NPSkullElite, i)
				removed = true
				break
			end
		end
	end

	if not removed then
		for i, u in ipairs(NPSkull) do
			if u == unit then
				table.remove(NPSkull, i)
				removed = true
				break
			end
		end
	end

	if not removed then
		for i, u in ipairs(NPRedElite) do
			if u == unit then
				table.remove(NPRedElite, i)
				removed = true
				break
			end
		end
	end

	if not removed then
		for i, u in ipairs(NPRed) do
			if u == unit then
				table.remove(NPRed, i)
				break
			end
		end
	end

	UpdateText()
end)