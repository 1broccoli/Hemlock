if (select(2, UnitClass("player"))) ~= "ROGUE" then return end
local addOnName = ...

-- Main frame
local frame = CreateFrame("Frame", "HemlockOptions")
frame.name = addOnName
frame:Hide()

-- Add the frame to the options menu based on API availability
if Settings and Settings.RegisterAddOnCategory then
    local category = Settings.RegisterCanvasLayoutCategory(frame, addOnName)
    Settings.RegisterAddOnCategory(category)
else
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, addon)
        if addon == addOnName then
            InterfaceOptions_AddCategory(frame)
            self:UnregisterEvent("ADDON_LOADED")
        end
    end)
end

frame:SetScript("OnShow", function(frame)
    local options = {}
    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(addOnName)

    local description = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    description:SetText("Minimalistic addon to automate poison buying and creation")

    local function newCheckbox(name, label, description, onClick)
        local check = CreateFrame("CheckButton", "HemlockCheckBox" .. name, frame, "InterfaceOptionsCheckButtonTemplate")
        check:SetScript("OnClick", function(self)
            local tick = self:GetChecked()
            onClick(self, tick and true or false)
            if tick then
                PlaySound(856)
            else
                PlaySound(857)
            end
        end)
        check.label = _G[check:GetName() .. "Text"]
        check.label:SetText(label)
        check.tooltipText = label
        check.tooltipRequirement = description
        return check
    end

    smartPoisonCount = newCheckbox(
        "SmartPoisonCount",
        Hemlock:L("option_smartPoisonCount"),
        Hemlock:L("option_smartPoisonCount_desc"),
        function(self, value) Hemlock.db.profile.options.smartPoisonCount = value; Hemlock:InitFrames() end)
    smartPoisonCount:SetChecked(Hemlock.db.profile.options.smartPoisonCount)
    smartPoisonCount:SetPoint("TOPLEFT", description, "BOTTOMLEFT", -2, -16)

    chatMessages = newCheckbox(
        "ChatMessages",
        Hemlock:L("option_chatMessages"),
        Hemlock:L("option_chatMessages_desc"),
        function(self, value) Hemlock.db.profile.options.chatMessages = value end)
    chatMessages:SetChecked(Hemlock.db.profile.options.chatMessages)
    chatMessages:SetPoint("TOPLEFT", smartPoisonCount, "BOTTOMLEFT", 0, -8)

    alternativeWoundPoisonIcon = newCheckbox(
        "AlternativeWoundPoisonIcon",
        Hemlock:L("option_alternativeWoundPoisonIcon"),
        Hemlock:L("option_alternativeWoundPoisonIcon_desc"),
        function(self, value) Hemlock.db.profile.options.alternativeWoundPoisonIcon = value; Hemlock:InitFrames() end)
    alternativeWoundPoisonIcon:SetChecked(Hemlock.db.profile.options.alternativeWoundPoisonIcon)
    alternativeWoundPoisonIcon:SetPoint("TOPLEFT", chatMessages, "BOTTOMLEFT", 0, -8)

    alternativeCripplingPoisonIcon = newCheckbox(
        "AlternativeCripplingPoisonIcon",
        Hemlock:L("option_alternativeCripplingPoisonIcon"),
        Hemlock:L("option_alternativeCripplingPoisonIcon_desc"),
        function(self, value) Hemlock.db.profile.options.alternativeCripplingPoisonIcon = value; Hemlock:InitFrames() end)
    alternativeCripplingPoisonIcon:SetChecked(Hemlock.db.profile.options.alternativeCripplingPoisonIcon)
    alternativeCripplingPoisonIcon:SetPoint("TOPLEFT", alternativeWoundPoisonIcon, "BOTTOMLEFT", 0, -8)

    buyConfirmation = newCheckbox(
        "BuyConfirmation",
        Hemlock:L("option_buyConfirmation"),
        Hemlock:L("option_buyConfirmation_desc"),
        function(self, value) Hemlock.db.profile.options.buyConfirmation = value; Hemlock:InitFrames() end)
    buyConfirmation:SetChecked(Hemlock.db.profile.options.buyConfirmation)
    buyConfirmation:SetPoint("TOPLEFT", alternativeCripplingPoisonIcon, "BOTTOMLEFT", 0, -8)

    ignoreLowerRankPoisons = newCheckbox(
        "IgnoreLowerRankPoisons",
        Hemlock:L("option_ignoreLowerRankPoisons"),
        Hemlock:L("option_ignoreLowerRankPoisons_desc"),
        function(self, value) Hemlock.db.profile.options.ignoreLowerRankPoisons = value; Hemlock:InitFrames() end)
    ignoreLowerRankPoisons:SetChecked(Hemlock.db.profile.options.ignoreLowerRankPoisons)
    ignoreLowerRankPoisons:SetPoint("TOPLEFT", buyConfirmation, "BOTTOMLEFT", 0, -8)

    enableCraftingQueue = newCheckbox(
        "EnableCraftingQueue",
        Hemlock:L("option_enableCraftingQueue"),
        Hemlock:L("option_enableCraftingQueue_desc"),
        function(self, value) Hemlock.db.profile.options.enableCraftingQueue = value end)
    enableCraftingQueue:SetChecked(Hemlock.db.profile.options.enableCraftingQueue)
    enableCraftingQueue:SetPoint("TOPLEFT", ignoreLowerRankPoisons, "BOTTOMLEFT", 0, -8)

    local reset = CreateFrame("Button", "HemlockResetButton", frame, "UIPanelButtonTemplate")
    reset:SetText(Hemlock:L("option_reset_button"))
    reset:SetWidth(177)
    reset:SetHeight(24)
    reset:SetPoint("TOPLEFT", enableCraftingQueue, "BOTTOMLEFT", 17, -15)
    reset:SetScript("OnClick", function()
        Hemlock:Reset();
        PlaySound(856);
    end)
    reset.tooltipText = Hemlock:L("option_reset_tooltip_title")
    reset.newbieText = Hemlock:L("option_reset_tooltip_desc")

    frame:SetScript("OnShow", nil)
end)
