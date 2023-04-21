-- enUS English
local _, HighLevelAlert = ...
LHLA = LHLA or {}

function HighLevelAlert:LangenUS()
	LHLA["LID_NPSCVAR"] = "\"%s\" (Nameplates) is turned off, please enable it."
	LHLA["LID_WARNING"] = "Warning"
	LHLA["LID_CAUTION"] = "Caution"
	LHLA["LID_PVPNEARBY"] = "%d PVP-Player nearby!"
	LHLA["LID_SKULLELITESNEARBY"] = "%d {rt8}-Elites Nearby!"
	LHLA["LID_SKULLSNEARBY"] = "%d {rt8} Nearby!"
	LHLA["LID_REDELITESNEARBY"] = "%d Red-Elites Nearby!"
	LHLA["LID_REDSNEARBY"] = "%d Reds Nearby!"
	LHLA["LID_HELPTEXTLOCKED"] = "Warning-Text is fixed, rightclick to unlock it."
	LHLA["LID_LOCKEDTEXT"] = "Warning-Text is now locked."
	LHLA["LID_UNLOCKEDTEXT"] = "Warning-Text is now unlocked."
end