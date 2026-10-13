local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local SoundService     = game:GetService("SoundService")
local GuiService       = game:GetService("GuiService")
local HttpService      = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local BRAND = "HIros"


local DEFAULT_SOUNDS = {
    Hover     = { Id = "rbxassetid://119354387183704", Volume = 0.25 },
    Click     = { Id = "rbxassetid://6042053626",      Volume = 0.5 },
    ToggleOn  = { Id = "rbxassetid://140207837688369", Volume = 0.5 },
    ToggleOff = { Id = "rbxassetid://139009780109934", Volume = 0.5 },
    Open      = { Id = "rbxassetid://78897892629188",  Volume = 0.5 },
    Close     = { Id = "rbxassetid://78299875784295",  Volume = 0.5 },
    Notify    = { Id = "rbxassetid://117653664939966", Volume = 0.6 },
}

local DEFAULT_SHOUTOUT_WEBHOOK = "https://discord.com/api/webhooks/1555905991558697020/iMzh1L_sREI1sdOyjlMykgZBbs9Be3jMQlWjL-wWnptSguJsLdfxDsvyqSYjuzDLSyLa"
local VERSION = "6.3"

local Library = {}
Library.__index = Library

local THEMES = {
    Blue   = { Name = "Синяя",   Accent = Color3.fromRGB(88, 101, 242), AccentLight = Color3.fromRGB(160, 170, 255) },
    Red    = { Name = "Красная", Accent = Color3.fromRGB(235, 70, 85),  AccentLight = Color3.fromRGB(255, 150, 160) },
    Yellow = { Name = "Жёлтая",  Accent = Color3.fromRGB(235, 180, 45), AccentLight = Color3.fromRGB(255, 220, 130) },
    Green  = { Name = "Зелёная", Accent = Color3.fromRGB(40, 200, 120), AccentLight = Color3.fromRGB(150, 245, 190) },
    Purple = { Name = "Фиолет",  Accent = Color3.fromRGB(138, 43, 226), AccentLight = Color3.fromRGB(200, 150, 255) },

    -- Одноцветные
    Cyan    = { Name = "Бирюзовая", Accent = Color3.fromRGB(0, 200, 220),   AccentLight = Color3.fromRGB(140, 240, 250) },
    Pink    = { Name = "Розовая",   Accent = Color3.fromRGB(240, 90, 170),  AccentLight = Color3.fromRGB(255, 170, 215) },
    Orange  = { Name = "Оранжевая", Accent = Color3.fromRGB(255, 140, 40),  AccentLight = Color3.fromRGB(255, 200, 130) },
    Mint    = { Name = "Мятная",    Accent = Color3.fromRGB(60, 220, 180),  AccentLight = Color3.fromRGB(160, 250, 225) },
    Crimson = { Name = "Бордовая",  Accent = Color3.fromRGB(200, 30, 60),   AccentLight = Color3.fromRGB(240, 120, 140) },
    Lime    = { Name = "Лайм",      Accent = Color3.fromRGB(150, 220, 40),  AccentLight = Color3.fromRGB(210, 250, 130) },
    Mono    = { Name = "Серебро",   Accent = Color3.fromRGB(190, 190, 205), AccentLight = Color3.fromRGB(240, 240, 248) },

    -- Двухцветные (Accent2 — второй цвет градиента рамки, заголовка, фона и частиц)
    Sunset   = { Name = "Закат",   Accent = Color3.fromRGB(255, 110, 80),  AccentLight = Color3.fromRGB(255, 180, 140), Accent2 = Color3.fromRGB(200, 60, 160) },
    Ocean    = { Name = "Океан",   Accent = Color3.fromRGB(30, 120, 230),  AccentLight = Color3.fromRGB(120, 190, 255), Accent2 = Color3.fromRGB(0, 210, 200) },
    Aurora   = { Name = "Аврора",  Accent = Color3.fromRGB(60, 220, 160),  AccentLight = Color3.fromRGB(160, 255, 220), Accent2 = Color3.fromRGB(130, 90, 255) },
    Neon     = { Name = "Неон",    Accent = Color3.fromRGB(255, 40, 200),  AccentLight = Color3.fromRGB(255, 140, 230), Accent2 = Color3.fromRGB(40, 220, 255) },
    Sakura   = { Name = "Сакура",  Accent = Color3.fromRGB(245, 150, 190), AccentLight = Color3.fromRGB(255, 210, 230), Accent2 = Color3.fromRGB(190, 130, 255) },
    Gold     = { Name = "Золото",  Accent = Color3.fromRGB(230, 180, 60),  AccentLight = Color3.fromRGB(255, 225, 140), Accent2 = Color3.fromRGB(255, 120, 40) },
    Ice      = { Name = "Лёд",     Accent = Color3.fromRGB(140, 200, 255), AccentLight = Color3.fromRGB(210, 235, 255), Accent2 = Color3.fromRGB(190, 170, 255) },
    Lava     = { Name = "Лава",    Accent = Color3.fromRGB(255, 70, 30),   AccentLight = Color3.fromRGB(255, 160, 110), Accent2 = Color3.fromRGB(255, 190, 0) },
    Midnight = { Name = "Полночь", Accent = Color3.fromRGB(110, 100, 230), AccentLight = Color3.fromRGB(180, 170, 255), Accent2 = Color3.fromRGB(50, 90, 200) },
}

-- Порядок тем для меню выбора (Library:GetThemes())
local THEME_ORDER = {
    "Blue", "Red", "Yellow", "Green", "Purple",
    "Cyan", "Pink", "Orange", "Mint", "Crimson", "Lime", "Mono",
    "Sunset", "Ocean", "Aurora", "Neon", "Sakura", "Gold", "Ice", "Lava", "Midnight",
}


local PALETTES = {
    dark = {
        BG_DARK = Color3.fromRGB(18, 18, 22),       BG_PANEL = Color3.fromRGB(26, 26, 31),
        BG_ITEM = Color3.fromRGB(34, 34, 40),       BG_HOVER = Color3.fromRGB(44, 44, 52),
        TEXT_COLOR = Color3.fromRGB(235, 235, 240), SUBTEXT = Color3.fromRGB(150, 150, 160),
        INPUT = Color3.fromRGB(28, 28, 34),         TRACK = Color3.fromRGB(50, 50, 60),
        TRACK_OFF = Color3.fromRGB(60, 60, 70),     CTRL_FOCUS = Color3.fromRGB(54, 54, 64),
        AVATAR_BG = Color3.fromRGB(40, 40, 46),
        TITLE = Color3.fromRGB(255, 255, 255),      LINE = Color3.fromRGB(255, 255, 255),
    },
    light = {
        BG_DARK = Color3.fromRGB(238, 240, 246),    BG_PANEL = Color3.fromRGB(250, 250, 253),
        BG_ITEM = Color3.fromRGB(226, 229, 238),    BG_HOVER = Color3.fromRGB(212, 216, 228),
        TEXT_COLOR = Color3.fromRGB(28, 30, 40),    SUBTEXT = Color3.fromRGB(98, 102, 120),
        INPUT = Color3.fromRGB(242, 243, 248),      TRACK = Color3.fromRGB(198, 202, 215),
        TRACK_OFF = Color3.fromRGB(186, 190, 204),  CTRL_FOCUS = Color3.fromRGB(204, 208, 222),
        AVATAR_BG = Color3.fromRGB(218, 221, 232),
        TITLE = Color3.fromRGB(30, 32, 44),         LINE = Color3.fromRGB(0, 0, 0),
    },
}
-- какие цвета перекрашиваются у уже созданных элементов при смене палитры
local MAPPED_KEYS = { "BG_DARK", "BG_PANEL", "BG_ITEM", "BG_HOVER", "TEXT_COLOR", "SUBTEXT",
    "INPUT", "TRACK", "TRACK_OFF", "CTRL_FOCUS", "AVATAR_BG" }

local BG_DARK, BG_PANEL, BG_ITEM, BG_HOVER, TEXT_COLOR, SUBTEXT
local INPUT, TRACK, TRACK_OFF, CTRL, CTRL_FOCUS, AVATAR_BG, TITLE, LINE
local currentPalette = "dark"

local function loadPalette(name)
    local p = PALETTES[name]
    BG_DARK, BG_PANEL, BG_ITEM, BG_HOVER = p.BG_DARK, p.BG_PANEL, p.BG_ITEM, p.BG_HOVER
    TEXT_COLOR, SUBTEXT = p.TEXT_COLOR, p.SUBTEXT
    INPUT, TRACK, TRACK_OFF, CTRL, CTRL_FOCUS = p.INPUT, p.TRACK, p.TRACK_OFF, p.BG_HOVER, p.CTRL_FOCUS
    AVATAR_BG, TITLE, LINE = p.AVATAR_BG, p.TITLE, p.LINE
    currentPalette = name
end
loadPalette("dark")

-- Все созданные окна (для перекраски при смене палитры)
local WINDOWS = setmetatable({}, { __mode = "k" })

local function switchPalette(name)
    if name == currentPalette or not PALETTES[name] then return end
    local old, new = PALETTES[currentPalette], PALETTES[name]
    loadPalette(name)

    local pairsList = {}
    for _, key in ipairs(MAPPED_KEYS) do
        table.insert(pairsList, { old[key], new[key] })
    end
    local function remap(c)
        for _, p in ipairs(pairsList) do
            if c == p[1] then return p[2] end
        end
        return nil
    end

    for w in pairs(WINDOWS) do
        if not w._destroyed then
            for _, root in ipairs({ w.ScreenGui, w.OverlayGui }) do
                if root then
                    for _, inst in ipairs(root:GetDescendants()) do
                        if inst:IsA("GuiObject") then
                            local bg = inst.BackgroundColor3
                            if inst.ClassName == "Frame" and bg == old.LINE
                                and inst.BackgroundTransparency > 0.8 and inst.BackgroundTransparency < 1 then
                                inst.BackgroundColor3 = new.LINE -- тонкие линии-разделители
                            else
                                local n = remap(bg)
                                if n then inst.BackgroundColor3 = n end
                            end
                            if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                                local tn = remap(inst.TextColor3)
                                if tn then inst.TextColor3 = tn end
                                if inst:IsA("TextBox") then
                                    local pn = remap(inst.PlaceholderColor3)
                                    if pn then inst.PlaceholderColor3 = pn end
                                end
                            end
                        end
                    end
                end
            end
            w:_onPaletteChanged()
        end
    end
end

-- ============================================================
-- ЯЗЫКИ (встроенные тексты библиотеки: ru / en)
-- ============================================================
local STRINGS = {
    ru = {
        search = "🔍 Поиск...", search_list = "Поиск в списке...", no_results = "🔎 Ничего не найдено",
        confirm = "Подтверждение", yes = "Да", no = "Отмена", sure = "Ты уверен?",
        notify = "Уведомление", loading = "Загрузка...", players = "Игроки", refresh = "🔄 Обновить",
        cfg_title = "Профили настроек", cfg_name = "Имя профиля", cfg_name_ph = "например: farm",
        cfg_list = "Сохранённые профили", cfg_save = "💾 Сохранить", cfg_load = "📂 Загрузить", cfg_delete = "🗑️ Удалить",
        cfg_need_name = "Укажи имя профиля.", cfg_profile = "Профиль",
        cfg_saved = "Сохранено", cfg_saved_msg = "Профиль «%s» сохранён.",
        cfg_loaded = "Загружено", cfg_loaded_msg = "Профиль «%s» применён.",
        cfg_no_default = "Нельзя удалить default.",
        cfg_del_title = "Удалить профиль?", cfg_del_body = "Профиль «%s» будет удалён без возможности отмены.",
        cfg_deleted = "Удалено", cfg_del_fail = "Не удалось", cfg_deleted_msg = "Профиль «%s» удалён.",
        cfg_del_hint = "Проверь, поддерживает ли твой экзекьютор delfile.",
        mode_toggle = "Переключ.", mode_hold = "Удержание", mode_always = "Всегда",
        kb_title = "Клавиши",
        set_title = "Настройки", set_ui = "Интерфейс", set_theme = "Тема", set_accent = "Свой акцент",
        set_light = "Светлая тема", set_scale = "Масштаб окна", set_particles = "Частицы",
        set_rainbow = "Радужное свечение", set_clicks = "Эффект кликов", set_click_style = "Стиль кликов",
        set_sound = "Звуки", set_volume = "Громкость", set_hotkey = "Клавиша меню",
        set_lang = "Язык интерфейса", set_lang_note = "Язык меню полностью применится после перезапуска скрипта.",
        set_overlay = "Оверлеи и телефон", set_quick = "Кнопки быстрого доступа",
        set_wm = "Водяной знак (FPS / пинг)", set_kb = "Список клавиш на экране",
        set_handle = "Полоска-ручка под окном", set_reset_pos = "Сбросить позицию окна", set_reset_size = "Сбросить размер окна",
    },
    en = {
        search = "🔍 Search...", search_list = "Search list...", no_results = "🔎 Nothing found",
        confirm = "Confirm", yes = "Yes", no = "Cancel", sure = "Are you sure?",
        notify = "Notification", loading = "Loading...", players = "Players", refresh = "🔄 Refresh",
        cfg_title = "Config profiles", cfg_name = "Profile name", cfg_name_ph = "e.g. farm",
        cfg_list = "Saved profiles", cfg_save = "💾 Save", cfg_load = "📂 Load", cfg_delete = "🗑️ Delete",
        cfg_need_name = "Enter a profile name.", cfg_profile = "Profile",
        cfg_saved = "Saved", cfg_saved_msg = "Profile “%s” saved.",
        cfg_loaded = "Loaded", cfg_loaded_msg = "Profile “%s” applied.",
        cfg_no_default = "The default profile can't be deleted.",
        cfg_del_title = "Delete profile?", cfg_del_body = "Profile “%s” will be deleted permanently.",
        cfg_deleted = "Deleted", cfg_del_fail = "Failed", cfg_deleted_msg = "Profile “%s” deleted.",
        cfg_del_hint = "Check that your executor supports delfile.",
        mode_toggle = "Toggle", mode_hold = "Hold", mode_always = "Always",
        kb_title = "Keybinds",
        set_title = "Settings", set_ui = "Interface", set_theme = "Theme", set_accent = "Custom accent",
        set_light = "Light theme", set_scale = "Window scale", set_particles = "Particles",
        set_rainbow = "Rainbow glow", set_clicks = "Click effect", set_click_style = "Click style",
        set_sound = "Sounds", set_volume = "Volume", set_hotkey = "Menu key",
        set_lang = "Interface language", set_lang_note = "The menu language fully applies after the script is restarted.",
        set_overlay = "Overlays & mobile", set_quick = "Quick buttons",
        set_wm = "Watermark (FPS / ping)", set_kb = "On-screen keybind list",
        set_handle = "Drag handle under the window", set_reset_pos = "Reset window position", set_reset_size = "Reset window size",
    },
}

-- Телефон/планшет без клавиатуры
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
Library.IsMobile = IS_MOBILE

-- Размеры окна (можно менять уголком в правом нижнем углу)
local MIN_W, MIN_H, MAX_W, MAX_H = 520, 320, 900, 700

local function colorToHex(c)
    return string.format("#%02X%02X%02X",
        math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

-- Пока тянем ползунок/выбор цвета — страница не должна прокручиваться (важно на телефоне)
local function lockScroll(inst, locked)
    local sf = inst:FindFirstAncestorOfClass("ScrollingFrame")
    if sf then sf.ScrollingEnabled = not locked end
end

local DEFAULT_HOTKEY = Enum.KeyCode.RightShift
local CONFIG_FILE_PREFIX = "MenuLibrary_config"

-- ============================================================
-- LIBRARY API
-- ============================================================
function Library:RegisterTheme(name, themeTable)
    if type(name) ~= "string" or type(themeTable) ~= "table" then return end
    local isNew = THEMES[name] == nil
    THEMES[name] = {
        Name = themeTable.Name or name,
        Accent = themeTable.Accent or Color3.fromRGB(88, 101, 242),
        AccentLight = themeTable.AccentLight or (themeTable.Accent or Color3.fromRGB(88, 101, 242)):Lerp(Color3.new(1,1,1), 0.4),
        Accent2 = themeTable.Accent2, -- необязательно: второй цвет для двухцветного градиента
    }
    if isNew then table.insert(THEME_ORDER, name) end
end

-- Список ключей всех тем по порядку: HIros:GetThemes() -> { "Blue", "Red", ... }
function Library:GetThemes()
    local list = {}
    for _, key in ipairs(THEME_ORDER) do
        if THEMES[key] then table.insert(list, key) end
    end
    return list
end

-- Русское название темы по ключу: HIros:GetThemeName("Sunset") -> "Закат"
function Library:GetThemeName(key)
    return THEMES[key] and THEMES[key].Name or tostring(key)
end

function Library:GetInfo()
    return { Version = VERSION, Brand = BRAND, Author = "kjdgfisdgfhisd" }
end

function Library:SetAPI()
    if getgenv then
        getgenv().HIros = Library
        getgenv().HIrosVersion = VERSION
    end
    _G.HIros = Library
    _G.HIrosVersion = VERSION
end

-- Текущая тема ЭТОГО окна (у каждого окна своя)
function Library:_theme()
    return self._themeOverride or THEMES[self._themeKey] or THEMES.Blue
end

-- Запоминает подключение, чтобы отключить его в Destroy()
function Library:_track(conn)
    self._connections = self._connections or {}
    self._connections[conn] = true
    return conn
end

function Library:_untrack(conn)
    if conn and self._connections then self._connections[conn] = nil end
end

-- ============================================================
-- JSON (через HttpService: JSONEncode/JSONDecode работают и без HttpEnabled)
-- ============================================================
local function toJsonValue(v)
    local t = typeof(v)
    if t == "string" or t == "boolean" then return v end
    if t == "number" then
        if v ~= v or v == math.huge or v == -math.huge then return nil end
        return v
    end
    if t == "Color3" then
        return { __c3 = { v.R, v.G, v.B } }
    end
    if t == "EnumItem" then return v.Name end
    if t == "table" then
        local count, maxIndex = 0, 0
        for k in pairs(v) do
            count = count + 1
            if type(k) == "number" and k > maxIndex then maxIndex = k end
        end
        local out = {}
        if count == #v then
            -- обычный массив
            for i, val in ipairs(v) do out[i] = toJsonValue(val) end
        else
            for k, val in pairs(v) do
                local enc = toJsonValue(val)
                if enc ~= nil then out[tostring(k)] = enc end
            end
        end
        return out
    end
    return nil
end

local function fromJsonValue(v)
    if type(v) ~= "table" then return v end
    if type(v.__c3) == "table" and #v.__c3 == 3 then
        local r, g, b = tonumber(v.__c3[1]), tonumber(v.__c3[2]), tonumber(v.__c3[3])
        if r and g and b then return Color3.new(r, g, b) end
    end
    local out = {}
    for k, val in pairs(v) do out[k] = fromJsonValue(val) end
    return out
end

local function jsonEncode(tbl)
    return HttpService:JSONEncode(toJsonValue(tbl))
end

local function jsonDecode(str)
    local ok, data = pcall(function() return HttpService:JSONDecode(str) end)
    if not ok or type(data) ~= "table" then return {} end
    return fromJsonValue(data)
end

-- ============================================================
-- UTILS
-- ============================================================
-- Позиция указателя в координатах наших ScreenGui (у них IgnoreGuiInset = true,
-- т.е. отсчёт от самого верха экрана). input.Position у мыши/тача считается от
-- нижнего края верхней панели Roblox, поэтому без поправки всё "уезжает" вверх.
local function pointerPos(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local inset = GuiService:GetGuiInset()
        return Vector2.new(input.Position.X + inset.X, input.Position.Y + inset.Y)
    end
    return UserInputService:GetMouseLocation()
end
Library._pointerPos = pointerPos

local function createCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = parent
    return c
end

-- Количество знаков после запятой у шага слайдера (0.1 -> 1, 0.05 -> 2, 1 -> 0)
local function decimalsOf(n)
    local s = (string.format("%.8f", math.abs(n)):gsub("0+$", ""))
    local d = s:match("%.(%d*)$")
    return d and #d or 0
end

-- ============================================================
-- ХЕЛПЕРЫ: клавиши, регистр букв (в т.ч. кириллица)
-- ============================================================
local function resolveKey(v)
    if typeof(v) == "EnumItem" then return v end
    if type(v) == "string" and v ~= "" then
        local ok, kc = pcall(function() return Enum.KeyCode[v] end)
        if ok and kc then return kc end
    end
    return nil
end

local function makeKeyBadge(parent, key, rightOffset, theme)
    local kb = Instance.new("TextLabel")
    kb.AnchorPoint = Vector2.new(1, 0.5)
    kb.Position = UDim2.new(1, rightOffset, 0.5, 0)
    kb.Size = UDim2.new(0, 0, 0, 20)
    kb.AutomaticSize = Enum.AutomaticSize.X
    kb.BackgroundColor3 = BG_HOVER
    kb.BorderSizePixel = 0
    kb.Font = Enum.Font.GothamBold
    kb.Text = key.Name
    kb.TextColor3 = (theme or THEMES.Blue).Accent
    kb.TextSize = 10
    kb.ZIndex = 6
    kb.Parent = parent
    createCorner(kb, 6)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 7)
    pad.PaddingRight = UDim.new(0, 7)
    pad.Parent = kb
    return kb
end

-- string.lower не знает кириллицу — для поиска приводим регистр вручную
local function lowerText(str)
    str = tostring(str):lower()
    local out = {}
    local ok = pcall(function()
        for _, cp in utf8.codes(str) do
            if cp >= 0x410 and cp <= 0x42F then cp = cp + 32
            elseif cp == 0x401 then cp = 0x451 end
            out[#out + 1] = utf8.char(cp)
        end
    end)
    if not ok then return str end
    return table.concat(out)
end

-- то же в обратную сторону: string.upper не поднимает кириллицу
local function upperText(str)
    str = tostring(str):upper()
    local out = {}
    local ok = pcall(function()
        for _, cp in utf8.codes(str) do
            if cp >= 0x430 and cp <= 0x44F then cp = cp - 32
            elseif cp == 0x451 then cp = 0x401 end
            out[#out + 1] = utf8.char(cp)
        end
    end)
    if not ok then return str end
    return table.concat(out)
end

local function collectText(inst, out)
    local cn = inst.ClassName
    if cn == "TextButton" or cn == "TextLabel" or cn == "TextBox" then
        local t = inst.Text
        if type(t) == "string" and t ~= "" then out[#out + 1] = t end
    end
    for _, c in ipairs(inst:GetChildren()) do collectText(c, out) end
end

local function textHas(inst, query)
    local parts = {}
    collectText(inst, parts)
    return lowerText(table.concat(parts, " ")):find(query, 1, true) ~= nil
end

-- Каждому элементу без явного Order выдаём возрастающий номер: иначе у всех LayoutOrder = 0,
-- а выпадающие списки (Order + 0.5) уезжали бы в самый низ страницы.
local function withOrder(tab, cfg)
    local c = {}
    for k, v in pairs(cfg or {}) do c[k] = v end
    if c.Order == nil then
        tab._autoOrder = (tab._autoOrder or 0) + 1
        c.Order = tab._autoOrder
    end
    return c
end

local function makeRowBase(parent, order, height)
    local row = Instance.new("TextButton")
    row.BackgroundColor3 = BG_ITEM
    row.AutoButtonColor = false
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, height or 40)
    row.LayoutOrder = order or 0
    row.Font = Enum.Font.GothamMedium
    row.Text = ""
    row.TextColor3 = TEXT_COLOR
    row.TextSize = 13
    row.TextXAlignment = Enum.TextXAlignment.Left
    row.ZIndex = 4
    row.Parent = parent
    createCorner(row, 10)
    return row
end

local function addHover(row, win, silentClick)
    row.ClipsDescendants = true
    local function accentOf()
        return (win and win:_theme() or THEMES.Blue).Accent
    end
    if win and not silentClick then
        row.MouseButton1Click:Connect(function() win:_play("Click") end)
    end
    row.MouseEnter:Connect(function()
        if win then win:_play("Hover") end
        TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = BG_HOVER }):Play()
        -- блик: полупрозрачная диагональная полоса пробегает слева направо
        local sheen = Instance.new("Frame")
        sheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sheen.BorderSizePixel = 0
        sheen.AnchorPoint = Vector2.new(0, 0.5)
        sheen.Position = UDim2.new(-0.35, 0, 0.5, 0)
        sheen.Size = UDim2.new(0.3, 0, 2.2, 0)
        sheen.Rotation = 18
        sheen.ZIndex = row.ZIndex + 15
        sheen.Parent = row
        local sg = Instance.new("UIGradient")
        sg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.93),
            NumberSequenceKeypoint.new(1, 1),
        })
        sg.Parent = sheen
        local tw = TweenService:Create(sheen, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1.1, 0, 0.5, 0),
        })
        tw:Play()
        tw.Completed:Connect(function() sheen:Destroy() end)
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = BG_ITEM }):Play()
    end)
    row.MouseButton1Down:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.08), { BackgroundColor3 = accentOf() }):Play()
    end)
    row.MouseButton1Up:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = BG_HOVER }):Play()
    end)
    -- Ripple: расходящийся круг из точки клика
    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            local pp = pointerPos(input)
            local relX = pp.X - row.AbsolutePosition.X
            local relY = pp.Y - row.AbsolutePosition.Y
            local ripple = Instance.new("Frame")
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.75
            ripple.BorderSizePixel = 0
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.Position = UDim2.new(0, relX, 0, relY)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.ZIndex = row.ZIndex + 20
            ripple.Parent = row
            createCorner(ripple, 999)
            local maxDim = math.max(row.AbsoluteSize.X, row.AbsoluteSize.Y) * 1.8
            local tw = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, maxDim, 0, maxDim),
                BackgroundTransparency = 1,
            })
            tw:Play()
            tw.Completed:Connect(function() ripple:Destroy() end)
        end
    end)
end

local function makeBadge(parent, text, color, theme)
    local badge = Instance.new("TextLabel")
    badge.BackgroundColor3 = color or (theme or THEMES.Blue).Accent
    badge.BorderSizePixel = 0
    badge.Font = Enum.Font.GothamBold
    badge.Text = text
    badge.TextColor3 = Color3.fromRGB(255,255,255)
    badge.TextSize = 9
    badge.Size = UDim2.new(0, 36, 0, 14)
    badge.ZIndex = 6
    badge.Parent = parent
    createCorner(badge, 4)
    return badge
end

-- ============================================================
-- CREATE WINDOW
-- ============================================================
function Library:CreateWindow(config)
    local self = setmetatable({}, Library)
    self.Config = config or {}
    self.Name = self.Config.Name or BRAND
    self.Enabled = false
    self.Tabs = {}
    self.TabButtons = {}
    self.CurrentTab = nil
    self.Flags = {}
    self.Elements = {}
    self._saveToken = 0
    self._scrollBars = {}
    self._connections = {}
    self._hotkey = DEFAULT_HOTKEY
    self._configSlot = "default"
    self._scale = 1
    self._clickFx = {
        Enabled = false,
        Style = "Rings",   -- Rings / Pulse / Burst / Focus
        Color = "theme",   -- "theme" | "rainbow" | Color3
        Size = 80,         -- макс. диаметр, px
        Rings = 3,         -- количество колец
        Duration = 0.65,   -- сек
        IgnoreGui = false, -- не показывать при кликах по GUI
        Right = false,     -- также по правой кнопке мыши
    }
    self._fxActive = 0
    self._shoutoutAsked = false
    self._flagElements = {}
    self._sections = {}
    self._origVis = {}

    -- Тема окна (у каждого окна своя)
    self._themeKey = "Blue"
    if self.Config.Theme and THEMES[self.Config.Theme] then
        self._themeKey = self.Config.Theme
    end

    -- Файл конфига: ConfigName отделяет конфиги разных скриптов друг от друга.
    -- Без ConfigName остаётся старое имя файла (старые конфиги продолжают работать).
    self._configPrefix = CONFIG_FILE_PREFIX
    local cn = self.Config.ConfigName
    if type(cn) == "string" and cn ~= "" then
        self._configPrefix = "HIros_" .. (cn:gsub("[^%w_%-]", "_"))
    end

    -- Режим телефона и служебные таблицы
    self._mobile = IS_MOBILE
    if self.Config.Mobile ~= nil then self._mobile = self.Config.Mobile and true or false end
    local cb = self._mobile and 32 or 26 -- размер круглых кнопок окна (на телефоне крупнее)
    self.Options = {}   -- window.Options.<flag> -> объект элемента
    self._locked = {}   -- заблокированные элементы (SetLocked)
    self._bindInfo = {} -- для списка клавиш на экране
    self._quickButtons = {}
    self._fit = 1       -- автоподгонка под размер экрана

    -- Выбор самого игрока (из файла конфига) важнее настроек скрипта.
    -- Конфиг грузим ДО построения интерфейса, чтобы всё сразу создавалось правильным.
    self:_loadConfig()
    local F = self.Flags

    local lang = F._lang or self.Config.Language or "ru"
    if lang == "auto" then
        local okL, locale = pcall(function() return LocalPlayer.LocaleId end)
        lang = (okL and type(locale) == "string" and locale:sub(1, 2) == "ru") and "ru" or "en"
    end
    self._lang = STRINGS[lang] and lang or "ru"

    if type(F._theme_key) == "string" and THEMES[F._theme_key] then self._themeKey = F._theme_key end
    if typeof(F._accent) == "Color3" then
        self._themeOverride = {
            Name = "Custom", Accent = F._accent, AccentLight = F._accent:Lerp(Color3.new(1, 1, 1), 0.4),
        }
    end

    local wantLight = F._light
    if wantLight == nil then wantLight = self.Config.Light end
    if wantLight ~= nil then switchPalette(wantLight and "light" or "dark") end

    local he = F._handle -- белая полоска-ручка под окном
    if he == nil then he = (self.Config.DragHandle ~= false) end
    self._handleEnabled = he and true or false

    local qv = F._quick_visible
    if qv == nil then qv = self._mobile end
    self._quickVisible = qv and true or false

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HIros_" .. self.Name
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.DisplayOrder = 50
    self.ScreenGui.Parent = PlayerGui

    self.Wrapper = Instance.new("Frame")
    self.Wrapper.Name = "Wrapper"
    self.Wrapper.BackgroundTransparency = 1
    self.Wrapper.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Wrapper.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Wrapper.Size = UDim2.new(0, 0, 0, 0)
    self.Wrapper.Parent = self.ScreenGui

    self.Scale = Instance.new("UIScale")
    self.Scale.Scale = 1
    self.Scale.Parent = self.Wrapper

    self.GlowHolder = Instance.new("Frame")
    self.GlowHolder.BackgroundTransparency = 1
    self.GlowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    self.GlowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.GlowHolder.Size = UDim2.new(0, 0, 0, 0)
    self.GlowHolder.ZIndex = 0
    self.GlowHolder.Visible = false
    self.GlowHolder.Parent = self.Wrapper

    self.GlowLayers = {}
    for i, cfg in ipairs({
        { padding = 26, transparency = 0.93 },
        { padding = 16, transparency = 0.88 },
        { padding = 8,  transparency = 0.80 },
    }) do
        local layer = Instance.new("Frame")
        layer.Name = "Glow" .. i
        layer.AnchorPoint = Vector2.new(0.5, 0.5)
        layer.Position = UDim2.new(0.5, 0, 0.5, 0)
        layer.BackgroundColor3 = self:_theme().Accent
        layer.BackgroundTransparency = cfg.transparency
        layer.BorderSizePixel = 0
        layer.ZIndex = 0
        layer.Parent = self.GlowHolder
        createCorner(layer, 18 + cfg.padding * 0.6)
        table.insert(self.GlowLayers, { instance = layer, config = cfg })
    end

    self.WindowSize = Vector2.new(560, 380)
    if type(self.Flags._window_size) == "table" then
        local sw, sh = tonumber(self.Flags._window_size.w), tonumber(self.Flags._window_size.h)
        if sw and sh then
            self.WindowSize = Vector2.new(math.clamp(sw, MIN_W, MAX_W), math.clamp(sh, MIN_H, MAX_H))
        end
    end
    self:_syncGlowSize()
    local gm = self.Flags._glow_mode or self.Config.GlowMode
    self._glowMode = (gm == "rainbow") and "rainbow" or "theme"

    task.spawn(function()
        while self.GlowHolder.Parent do
            if self.Enabled then
                for _, l in ipairs(self.GlowLayers) do
                    TweenService:Create(l.instance, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        BackgroundTransparency = math.clamp(l.config.transparency + 0.05, 0, 1),
                    }):Play()
                end
            end
            task.wait(1.8)
            if self.Enabled then
                for _, l in ipairs(self.GlowLayers) do
                    TweenService:Create(l.instance, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        BackgroundTransparency = l.config.transparency,
                    }):Play()
                end
            end
            task.wait(1.8)
        end
    end)

    -- Радужный режим свечения (Library:SetGlowMode("rainbow")) — крутит
    -- цвет отдельно от "дыхания" прозрачности выше, конфликтов нет
    task.spawn(function()
        local hue = 0
        while self.GlowHolder.Parent do
            if self._glowMode == "rainbow" and self.Enabled then
                hue = (hue + 0.0035) % 1
                local col = Color3.fromHSV(hue, 0.85, 1)
                for _, l in ipairs(self.GlowLayers) do
                    l.instance.BackgroundColor3 = col
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)

    self.Main = Instance.new("Frame")
    self.Main.Name = "Window"
    self.Main.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Main.Size = UDim2.new(0, self.WindowSize.X, 0, self.WindowSize.Y)
    self.Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.Main.BackgroundTransparency = 0.14
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = true
    self.Main.Active = true
    self.Main.Visible = false
    self.Main.ZIndex = 2
    self.Main.Parent = self.Wrapper

    createCorner(self.Main, 18)

    self.MainStroke = Instance.new("UIStroke")
    self.MainStroke.Thickness = 1.6
    self.MainStroke.Transparency = 0.1
    self.MainStroke.Parent = self.Main

    self.StrokeGradient = Instance.new("UIGradient")
    self.StrokeGradient.Parent = self.MainStroke

    local glassShine = Instance.new("Frame")
    glassShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glassShine.BorderSizePixel = 0
    glassShine.Size = UDim2.new(1, 0, 0, 90)
    glassShine.ZIndex = 3
    glassShine.Parent = self.Main
    createCorner(glassShine, 18)
    self.GlassShine = glassShine
    local shineGrad = Instance.new("UIGradient")
    shineGrad.Rotation = 90
    shineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 1),
    })
    shineGrad.Parent = glassShine

    -- Фон: тёмный градиент с лёгким оттенком акцентного цвета (обновляется темой)
    self.BgGradient = Instance.new("UIGradient")
    self.BgGradient.Rotation = 125
    self.BgGradient.Parent = self.Main

    -- Плавающие частицы за контентом (живой фон)
    self.ParticleLayer = Instance.new("Frame")
    self.ParticleLayer.Name = "Particles"
    self.ParticleLayer.BackgroundTransparency = 1
    self.ParticleLayer.Size = UDim2.new(1, 0, 1, 0)
    self.ParticleLayer.ZIndex = 1
    self.ParticleLayer.Parent = self.Main
    local pe = self.Flags._particles
    if pe == nil then pe = (self.Config.Particles ~= false) end
    self._particlesEnabled = pe and true or false
    self._particles = {}
    for i = 1, 18 do
        local size = math.random(2, 5)
        local dot = Instance.new("Frame")
        dot.BackgroundColor3 = self:_theme().Accent
        dot.BackgroundTransparency = 0.8 + math.random() * 0.15
        dot.BorderSizePixel = 0
        dot.Size = UDim2.new(0, size, 0, size)
        dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
        dot.ZIndex = 1
        dot.Parent = self.ParticleLayer
        createCorner(dot, 999)
        table.insert(self._particles, {
            frame = dot,
            x = math.random(),
            y = math.random(),
            speed = 0.015 + math.random() * 0.03,
            sway = math.random() * 6.28,
            swayAmp = 0.01 + math.random() * 0.02,
        })
    end

    -- TitleBar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 42)
    self.TitleBar.Active = true
    self.TitleBar.ZIndex = 20
    self.TitleBar.Parent = self.Main

    -- Фон шапки: внутри CanvasGroup все слои непрозрачные, а прозрачность
    -- применяется ко всей группе сразу — поэтому перекрытия не видны
    local titleBg = Instance.new("CanvasGroup")
    titleBg.Name = "TitleBg"
    titleBg.BackgroundTransparency = 1
    titleBg.GroupTransparency = 0.15
    titleBg.Size = UDim2.new(1, 0, 1, 0)
    titleBg.ZIndex = 2
    titleBg.Parent = self.TitleBar

    local titleRound = Instance.new("Frame")
    titleRound.BackgroundColor3 = BG_PANEL
    titleRound.BorderSizePixel = 0
    titleRound.Size = UDim2.new(1, 0, 1, 0)
    titleRound.Parent = titleBg
    createCorner(titleRound, 18)

    local titleSquare = Instance.new("Frame")
    titleSquare.BackgroundColor3 = BG_PANEL
    titleSquare.BorderSizePixel = 0
    titleSquare.Size = UDim2.new(1, 0, 0, 24)
    titleSquare.Position = UDim2.new(0, 0, 1, -24)
    titleSquare.Parent = titleBg
    self.TitleSquare = titleSquare

    -- Неоновая линия под заголовком (бегущий градиент)
    self.AccentLine = Instance.new("Frame")
    self.AccentLine.Name = "AccentLine"
    self.AccentLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.AccentLine.BorderSizePixel = 0
    self.AccentLine.Position = UDim2.new(0, 0, 0, 41)
    self.AccentLine.Size = UDim2.new(1, 0, 0, 2)
    self.AccentLine.ZIndex = 25
    self.AccentLine.Parent = self.Main
    self.LineGradient = Instance.new("UIGradient")
    self.LineGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.35, 0.1),
        NumberSequenceKeypoint.new(0.65, 0.1),
        NumberSequenceKeypoint.new(1, 1),
    })
    self.LineGradient.Parent = self.AccentLine

    -- иконка окна
    self.TitleIcon = Instance.new("TextLabel")
    self.TitleIcon.BackgroundTransparency = 1
    self.TitleIcon.Position = UDim2.new(0, 12, 0, 0)
    self.TitleIcon.Size = UDim2.new(0, 24, 1, 0)
    self.TitleIcon.Font = Enum.Font.GothamBold
    self.TitleIcon.Text = "⚡"
    self.TitleIcon.TextColor3 = self:_theme().Accent
    self.TitleIcon.TextSize = 16
    self.TitleIcon.ZIndex = 4
    self.TitleIcon.Parent = self.TitleBar

    self.TitleText = Instance.new("TextLabel")
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Position = UDim2.new(0, 38, 0, 0)
    self.TitleText.Size = UDim2.new(1, -(262 + (cb - 26) * 2), 1, 0)
    self.TitleText.TextTruncate = Enum.TextTruncate.AtEnd
    self.TitleText.Font = Enum.Font.GothamBold
    self.TitleText.Text = self.Name
    self.TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleText.TextSize = 15
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.ZIndex = 4
    self.TitleText.Parent = self.TitleBar
    self.TitleGradient = Instance.new("UIGradient")
    self.TitleGradient.Parent = self.TitleText

    -- Круглые кнопки управления окном с эмодзи (не квадраты)
    local function makeCtrlButton(emoji, xOffset, hoverColor)
        local b = Instance.new("TextButton")
        b.BackgroundColor3 = CTRL
        b.AutoButtonColor = false
        b.Size = UDim2.new(0, cb, 0, cb)
        b.Position = UDim2.new(1, xOffset, 0.5, -cb / 2)
        b.Font = Enum.Font.GothamBold
        b.Text = emoji
        b.TextSize = 13
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.ZIndex = 4
        b.Parent = self.TitleBar
        createCorner(b, 999)

        local st = Instance.new("UIStroke")
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Transparency = 0.88
        st.Thickness = 1
        st.Parent = b

        local sc = Instance.new("UIScale")
        sc.Parent = b

        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = hoverColor }):Play()
            TweenService:Create(sc, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.15 }):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = CTRL }):Play()
            TweenService:Create(sc, TweenInfo.new(0.15), { Scale = 1 }):Play()
        end)
        b.MouseButton1Down:Connect(function()
            TweenService:Create(sc, TweenInfo.new(0.08), { Scale = 0.9 }):Play()
        end)
        b.MouseButton1Up:Connect(function()
            TweenService:Create(sc, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.15 }):Play()
        end)
        return b
    end

    local minBtn = makeCtrlButton("➖", -(2 * cb + 16), Color3.fromRGB(190, 140, 40))
    local closeBtn = makeCtrlButton("❌", -(cb + 10), Color3.fromRGB(200, 60, 70))
    self.MinBtn = minBtn
    self.CloseBtn = closeBtn

    closeBtn.MouseButton1Click:Connect(function() self:Toggle(false) end)

    -- Поиск по всем вкладкам (Search = false в CreateWindow отключает)
    if self.Config.Search ~= false then
        local sb = Instance.new("TextBox")
        sb.Name = "SearchBox"
        sb.BackgroundColor3 = CTRL
        sb.BorderSizePixel = 0
        sb.Position = UDim2.new(1, -(2 * cb + 16 + 8 + 164), 0.5, -12)
        sb.Size = UDim2.new(0, 164, 0, 24)
        sb.Font = Enum.Font.Gotham
        sb.PlaceholderText = self:_t("search")
        sb.PlaceholderColor3 = SUBTEXT
        sb.Text = ""
        sb.TextColor3 = TEXT_COLOR
        sb.TextSize = 12
        sb.TextXAlignment = Enum.TextXAlignment.Left
        sb.ClearTextOnFocus = false
        sb.ZIndex = 4
        sb.Parent = self.TitleBar
        createCorner(sb, 12)

        local sbPad = Instance.new("UIPadding")
        sbPad.PaddingLeft = UDim.new(0, 10)
        sbPad.PaddingRight = UDim.new(0, 10)
        sbPad.Parent = sb

        local sbStroke = Instance.new("UIStroke")
        sbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        sbStroke.Color = self:_theme().Accent
        sbStroke.Thickness = 1.5
        sbStroke.Transparency = 1
        sbStroke.Parent = sb

        self.SearchBox = sb
        self.SearchStroke = sbStroke

        sb.Focused:Connect(function()
            TweenService:Create(sbStroke, TweenInfo.new(0.18), { Transparency = 0.15 }):Play()
            TweenService:Create(sb, TweenInfo.new(0.18), { BackgroundColor3 = CTRL_FOCUS }):Play()
        end)
        sb.FocusLost:Connect(function(_, input)
            TweenService:Create(sbStroke, TweenInfo.new(0.18), { Transparency = 1 }):Play()
            TweenService:Create(sb, TweenInfo.new(0.18), { BackgroundColor3 = CTRL }):Play()
            if input and input.KeyCode == Enum.KeyCode.Escape then sb.Text = "" end
        end)
        sb:GetPropertyChangedSignal("Text"):Connect(function() self:_applySearch(sb.Text) end)
    end
    minBtn.MouseButton1Click:Connect(function() self:_play("Click") self:Minimize() end)

    -- Sidebar
    -- Body: всё, кроме шапки (сайдбар + контент). При сворачивании скрывается
    -- целиком, остаётся только плашка с заголовком и кнопками.
    self.Body = Instance.new("CanvasGroup")
    self.Body.Name = "Body"
    self.Body.BackgroundTransparency = 1
    self.Body.Size = UDim2.new(1, 0, 1, 0)
    self.Body.ZIndex = 2
    self.Body.Parent = self.Main

    self.Sidebar = Instance.new("Frame")
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Position = UDim2.new(0, 0, 0, 42)
    self.Sidebar.Size = UDim2.new(0, 150, 1, -42)
    self.Sidebar.ZIndex = 3
    self.Sidebar.Parent = self.Body

    -- Фон сайдбара: скруглён ТОЛЬКО нижний-левый угол (как у окна, радиус 18).
    -- Скруглённый слой + квадратные "заплатки" сверху и справа в CanvasGroup.
    local sideBg = Instance.new("CanvasGroup")
    sideBg.Name = "SidebarBg"
    sideBg.BackgroundTransparency = 1
    sideBg.GroupTransparency = 0.15
    sideBg.Size = UDim2.new(1, 0, 1, 0)
    sideBg.ZIndex = 2
    sideBg.Parent = self.Sidebar

    local sideRound = Instance.new("Frame")
    sideRound.BackgroundColor3 = BG_PANEL
    sideRound.BorderSizePixel = 0
    sideRound.Size = UDim2.new(1, 0, 1, 0)
    sideRound.Parent = sideBg
    createCorner(sideRound, 18)

    local sideTop = Instance.new("Frame")
    sideTop.BackgroundColor3 = BG_PANEL
    sideTop.BorderSizePixel = 0
    sideTop.Size = UDim2.new(1, 0, 0, 40)
    sideTop.Parent = sideBg

    local sideRight = Instance.new("Frame")
    sideRight.BackgroundColor3 = BG_PANEL
    sideRight.BorderSizePixel = 0
    sideRight.Size = UDim2.new(0, 40, 1, 0)
    sideRight.Position = UDim2.new(1, -40, 0, 0)
    sideRight.Parent = sideBg

    local profileBox = Instance.new("Frame")
    profileBox.BackgroundTransparency = 1
    profileBox.Size = UDim2.new(1, 0, 0, 84)
    profileBox.ZIndex = 3
    profileBox.Parent = self.Sidebar

    self.Avatar = Instance.new("ImageLabel")
    self.Avatar.Size = UDim2.new(0, 48, 0, 48)
    self.Avatar.Position = UDim2.new(0.5, -24, 0, 14)
    self.Avatar.BackgroundColor3 = AVATAR_BG
    self.Avatar.Image = ""
    self.Avatar.ZIndex = 4
    self.Avatar.Parent = profileBox
    createCorner(self.Avatar, 999)

    self.AvatarStroke = Instance.new("UIStroke")
    self.AvatarStroke.Thickness = 2.5
    self.AvatarStroke.Color = Color3.fromRGB(255, 255, 255)
    self.AvatarStroke.Transparency = 0.1
    self.AvatarStroke.Parent = self.Avatar
    self.AvatarGradient = Instance.new("UIGradient")
    self.AvatarGradient.Parent = self.AvatarStroke

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 8, 0, 64)
    nameLabel.Size = UDim2.new(1, -16, 0, 18)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = LocalPlayer.DisplayName
    nameLabel.TextColor3 = TEXT_COLOR
    nameLabel.TextSize = 13
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 4
    nameLabel.Parent = profileBox

    local divider = Instance.new("Frame")
    divider.BackgroundColor3 = LINE
    divider.BackgroundTransparency = 0.92
    divider.BorderSizePixel = 0
    divider.Size = UDim2.new(1, -20, 0, 1)
    divider.Position = UDim2.new(0, 10, 0, 86)
    divider.ZIndex = 3
    divider.Parent = self.Sidebar

    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.BackgroundTransparency = 1
    self.TabList.Position = UDim2.new(0, 8, 0, 96)
    self.TabList.Size = UDim2.new(1, -16, 1, -104)
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.TabList.ScrollBarThickness = 3
    self.TabList.ScrollBarImageColor3 = self:_theme().Accent
    self.TabList.ZIndex = 3
    self.TabList.Parent = self.Sidebar
    table.insert(self._scrollBars, self.TabList)

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 6)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = self.TabList

    local watermark = Instance.new("TextLabel")
    watermark.BackgroundTransparency = 1
    watermark.Position = UDim2.new(0, 0, 1, -18)
    watermark.Size = UDim2.new(1, 0, 0, 16)
    watermark.Font = Enum.Font.GothamBold
    watermark.Text = "⚡ " .. BRAND .. " v" .. VERSION
    watermark.TextColor3 = SUBTEXT
    watermark.TextTransparency = 0.35
    watermark.TextSize = 10
    watermark.ZIndex = 3
    watermark.Parent = self.Sidebar

    self.ContentArea = Instance.new("Frame")
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Position = UDim2.new(0, 150, 0, 42)
    self.ContentArea.Size = UDim2.new(1, -150, 1, -42)
    self.ContentArea.ZIndex = 3
    self.ContentArea.Parent = self.Body

    self.ContentPadding = Instance.new("Frame")
    self.ContentPadding.BackgroundTransparency = 1
    self.ContentPadding.Position = UDim2.new(0, 20, 0, 18)
    self.ContentPadding.Size = UDim2.new(1, -40, 1, -36)
    self.ContentPadding.ZIndex = 3
    self.ContentPadding.Parent = self.ContentArea

    -- Свечение синхронизируется САМО каждый раз, когда меняется
    -- реальный размер окна — включая каждый кадр во время Tween-анимации
    -- (открытие/закрытие/сворачивание), так что рассинхрона быть не может.
    self.Main:GetPropertyChangedSignal("Size"):Connect(function()
        self:_syncGlowSize()
    end)

    -- Уголок для изменения размера окна (тянется мышью или пальцем)
    local gripSize = self._mobile and 34 or 22
    self.ResizeGrip = Instance.new("TextButton")
    self.ResizeGrip.Name = "ResizeGrip"
    self.ResizeGrip.AnchorPoint = Vector2.new(1, 1)
    self.ResizeGrip.Position = UDim2.new(1, -6, 1, -6)
    self.ResizeGrip.Size = UDim2.new(0, gripSize, 0, gripSize)
    self.ResizeGrip.BackgroundTransparency = 1
    self.ResizeGrip.AutoButtonColor = false
    self.ResizeGrip.Font = Enum.Font.GothamBold
    self.ResizeGrip.Text = "◢"
    self.ResizeGrip.TextColor3 = SUBTEXT
    self.ResizeGrip.TextTransparency = 0.35
    self.ResizeGrip.TextSize = 14
    self.ResizeGrip.TextXAlignment = Enum.TextXAlignment.Right
    self.ResizeGrip.TextYAlignment = Enum.TextYAlignment.Bottom
    self.ResizeGrip.ZIndex = 30
    self.ResizeGrip.Parent = self.Main

    self:_setupDrag()
    self:_setupResize()
    self:_createDragHandle()

    if self.Flags["_window_hotkey"] and type(self.Flags["_window_hotkey"]) == "string" then
        local ok, kc = pcall(function() return Enum.KeyCode[self.Flags["_window_hotkey"]] end)
        if ok and kc then self._hotkey = kc end
    end
    if self.Flags["_window_scale"] and type(self.Flags["_window_scale"]) == "number" then
        self:SetScale(self.Flags["_window_scale"])
    end
    if type(self.Flags["_window_pos"]) == "table" then
        local p = self.Flags["_window_pos"]
        if p.xs and p.xo and p.ys and p.yo then
            self.Wrapper.Position = UDim2.new(p.xs, p.xo, p.ys, p.yo)
        end
    end

    self:_initSounds()
    self:_createToggleButton()
    self:_applyThemeVisuals()
    local cfgFx = self.Config.ClickEffect
    if cfgFx then
        if type(cfgFx) == "table" then
            local copy = { Enabled = true }
            for k, v in pairs(cfgFx) do copy[k] = v end
            self:SetClickEffect(copy)
        else
            self:SetClickEffect(true)
        end
    end
    -- Сохранённый пользователем эффект кликов
    if type(self.Flags._clickfx) == "table" then
        local copy = { Enabled = true }
        for k, v in pairs(self.Flags._clickfx) do copy[k] = v end
        self:SetClickEffect(copy)
    end

    -- Оверлеи (водяной знак и список клавиш)
    self._wmCfg = type(self.Config.Watermark) == "table" and self.Config.Watermark or nil
    local wm = self.Flags._wm_enabled
    if wm == nil then wm = self.Config.Watermark end
    if wm then self:CreateWatermark(self._wmCfg) end
    self._kbCfg = type(self.Config.KeybindList) == "table" and self.Config.KeybindList or nil
    local kbl = self.Flags._kb_enabled
    if kbl == nil then kbl = self.Config.KeybindList end
    if kbl then self:CreateKeybindList(self._kbCfg) end

    -- Подгонка под экран (телефон) и слежение за изменением размера экрана
    WINDOWS[self] = true
    self:_updateFit()
    local cam = workspace.CurrentCamera
    if cam then
        self:_track(cam:GetPropertyChangedSignal("ViewportSize"):Connect(function() self:_updateFit() end))
    end
    self._ready = true -- с этого момента выбор пользователя сохраняется в конфиг

    self:Toggle(true)
    local shout = self.Config.Shoutout
    if shout ~= false then
        local opts = (type(shout) == "table") and shout or {}
        if not opts.Webhook then
            local copy = {}
            for k, v in pairs(opts) do copy[k] = v end
            copy.Webhook = DEFAULT_SHOUTOUT_WEBHOOK
            opts = copy
        end
        self:PromptShoutout(opts)
    end
    return self
end

function Library:_syncGlowSize()
    -- До создания self.Main используем целевой размер по умолчанию,
    -- после создания — всегда берём РЕАЛЬНЫЙ текущий размер окна,
    -- чтобы свечение точно повторяло любое состояние окна
    -- (открыто/закрыто/свёрнуто), а не только исходный размер.
    local w, h
    if self.Main then
        w, h = self.Main.Size.X.Offset, self.Main.Size.Y.Offset
    else
        w, h = self.WindowSize.X, self.WindowSize.Y
    end
    local k = self._minimized and 0.45 or 1
    for _, l in ipairs(self.GlowLayers) do
        local pad = l.config.padding * k
        l.instance.Size = UDim2.new(0, w + pad * 2, 0, h + pad * 2)
    end
end

function Library:_setupDrag()
    local self = self
    local dragging, dragStart, startPos
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            self:_stopMagnet()
            dragging = true
            dragStart = input.Position
            startPos = self.Wrapper.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if dragging then
                        self:_clampToScreen()
                        self:_saveWindowPosition()
                    end
                    dragging = false
                end
            end)
        end
    end)
    self:_track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.Wrapper.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end))
end

-- Запоминает положение окна между сессиями (как масштаб и хоткей)
function Library:_saveWindowPosition()
    local pos = self.Wrapper.Position
    self:SetFlag("_window_pos", {
        xs = pos.X.Scale, xo = pos.X.Offset,
        ys = pos.Y.Scale, yo = pos.Y.Offset,
    })
end

function Library:ResetPosition()
    self:_recenter()
end

function Library:_createToggleButton()
    local self = self
    -- Контейнер: кнопка и её свечение — в одном месте, масштабируются от центра,
    -- поэтому свечение всегда идёт за кнопкой (при наведении, пульсации и т.д.)
    self.FloatHolder = Instance.new("Frame")
    self.FloatHolder.Name = "FloatHolder"
    self.FloatHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    local floatSize = self._mobile and 54 or 46
    self.FloatHolder.Position = UDim2.new(1, -(floatSize / 2 + 17), 1, -(floatSize / 2 + 17))
    self.FloatHolder.Size = UDim2.new(0, floatSize, 0, floatSize)
    self.FloatHolder.BackgroundTransparency = 1
    self.FloatHolder.ZIndex = 100
    self.FloatHolder.Parent = self.ScreenGui

    self.ToggleGlow = Instance.new("Frame")
    self.ToggleGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    self.ToggleGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.ToggleGlow.Size = UDim2.new(0, 64, 0, 64)
    self.ToggleGlow.BackgroundColor3 = self:_theme().Accent
    self.ToggleGlow.BackgroundTransparency = 0.8
    self.ToggleGlow.BorderSizePixel = 0
    self.ToggleGlow.ZIndex = 1
    self.ToggleGlow.Parent = self.FloatHolder
    createCorner(self.ToggleGlow, 999)

    self.ToggleBtn = Instance.new("TextButton")
    self.ToggleBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    self.ToggleBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    self.ToggleBtn.BackgroundColor3 = BG_PANEL
    self.ToggleBtn.AutoButtonColor = false
    self.ToggleBtn.Font = Enum.Font.GothamBold
    self.ToggleBtn.Text = "⚡"
    self.ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.ToggleBtn.TextSize = 22
    self.ToggleBtn.ZIndex = 2
    self.ToggleBtn.Parent = self.FloatHolder
    createCorner(self.ToggleBtn, 999)

    self.ToggleBtnStroke = Instance.new("UIStroke")
    self.ToggleBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    self.ToggleBtnStroke.Transparency = 0.2
    self.ToggleBtnStroke.Thickness = 1.5
    self.ToggleBtnStroke.Parent = self.ToggleBtn

    -- масштаб на контейнере: растёт и кнопка, и свечение вместе, от центра
    local holderScale = Instance.new("UIScale")
    holderScale.Parent = self.FloatHolder
    self.ToggleBtn.MouseEnter:Connect(function()
        TweenService:Create(holderScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.15 }):Play()
    end)
    self.ToggleBtn.MouseLeave:Connect(function()
        TweenService:Create(holderScale, TweenInfo.new(0.15), { Scale = 1 }):Play()
    end)
    self.ToggleBtn.MouseButton1Down:Connect(function()
        TweenService:Create(holderScale, TweenInfo.new(0.08), { Scale = 0.9 }):Play()
    end)
    self.ToggleBtn.MouseButton1Up:Connect(function()
        TweenService:Create(holderScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.15 }):Play()
    end)

    -- Кнопку можно перетащить (позиция запоминается); короткое касание открывает меню
    self:_loadGuiPos("float", self.FloatHolder)
    local floatDrag = self:_makeDraggable(self.FloatHolder, "float", self.ToggleBtn)
    self.ToggleBtn.MouseButton1Click:Connect(function()
        if floatDrag.moved then floatDrag.moved = false return end
        self:Toggle(not self.Enabled)
    end)

    self:_track(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        local key = self._hotkey or DEFAULT_HOTKEY
        if input.KeyCode == key then self:Toggle(not self.Enabled) end
    end))
end

-- ============================================================
-- WINDOW METHODS
-- ============================================================
function Library:Toggle(enabled)
    self.Enabled = enabled
    self:_play(enabled and "Open" or "Close")
    self:_showHandle(enabled)
    if enabled then
        self.Main.Visible = true
        self.GlowHolder.Visible = true
        for _, l in ipairs(self.GlowLayers) do
            l.instance.BackgroundTransparency = l.config.transparency
        end
        self:_resetCollapse()
        self.Main.Size = UDim2.new(0, self.WindowSize.X, 0, 0)
        TweenService:Create(self.Main, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, self.WindowSize.X, 0, self.WindowSize.Y),
        }):Play()
        for _, l in ipairs(self.GlowLayers) do
            TweenService:Create(l.instance, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = l.config.transparency,
            }):Play()
        end
    else
        local t = TweenService:Create(self.Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, self.WindowSize.X, 0, 0),
        })
        t:Play()
        for _, l in ipairs(self.GlowLayers) do
            TweenService:Create(l.instance, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
            }):Play()
        end
        t.Completed:Connect(function()
            if not self.Enabled then
                self.Main.Visible = false
                self.GlowHolder.Visible = false
            end
        end)
    end
end

-- Полностью убирает окно и отключает ВСЕ подключения библиотеки
function Library:Destroy()
    self.Enabled = false
    self._destroyed = true
    for conn in pairs(self._connections or {}) do
        pcall(function() conn:Disconnect() end)
    end
    self._connections = {}
    if self._hotkeyConn then pcall(function() self._hotkeyConn:Disconnect() end); self._hotkeyConn = nil end
    if self._clickConn then pcall(function() self._clickConn:Disconnect() end); self._clickConn = nil end
    WINDOWS[self] = nil
    if self.ClickGui then self.ClickGui:Destroy() end
    if self.OverlayGui then self.OverlayGui:Destroy() end
    if self.ScreenGui then self.ScreenGui:Destroy() end
    if self.ToggleBtn then self.ToggleBtn:Destroy() end
end

function Library:SetHotkey(key)
    if not key then return end
    if typeof(key) == "string" then
        local ok, kc = pcall(function() return Enum.KeyCode[key] end)
        if ok and kc then key = kc end
    end
    self._hotkey = key
    self:SetFlag("_window_hotkey", key.Name)
end

function Library:GetHotkey()
    return self._hotkey or DEFAULT_HOTKEY
end

-- Полный сброс состояния сворачивания (при открытии окна)
function Library:_resetCollapse()
    self._minimized = false
    self._collapseToken = (self._collapseToken or 0) + 1
    if self.MinBtn then self.MinBtn.Text = "➖" end
    if self.Body then
        self.Body.Visible = true
        self.Body.GroupTransparency = 0
    end
    if self.TitleSquare then self.TitleSquare.Visible = true end
    if self.SearchBox then self.SearchBox.Visible = true end
    if self.AccentLine then self.AccentLine.Visible = true end
    if self.GlassShine then self.GlassShine.Visible = true end
    if self.ParticleLayer then self.ParticleLayer.Visible = self._particlesEnabled end
    if self.ResizeGrip then self.ResizeGrip.Visible = true end
    self.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.GlowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
end

-- Свернуть до плашки: содержимое окна исчезает ПОЛНОСТЬЮ,
-- остаются только заголовок (им можно двигать окно) и кнопки ➕ / ❌
function Library:SetMinimized(state)
    state = state and true or false
    if (self._minimized and true or false) == state then return end
    self._minimized = state
    self._collapseToken = (self._collapseToken or 0) + 1
    local token = self._collapseToken
    if self.MinBtn then self.MinBtn.Text = state and "➕" or "➖" end
    if self.ResizeGrip then self.ResizeGrip.Visible = not state end

    local W, H, BAR = self.WindowSize.X, self.WindowSize.Y, 42
    local shiftY = -math.floor((H - BAR) / 2) -- верх шапки остаётся на месте
    local center = UDim2.new(0.5, 0, 0.5, 0)
    local shifted = UDim2.new(0.5, 0, 0.5, shiftY)

    if state then
        -- 1) тело плавно исчезает, 2) окно схлопывается в плашку
        TweenService:Create(self.Body, TweenInfo.new(0.15), { GroupTransparency = 1 }):Play()
        if self.ParticleLayer then self.ParticleLayer.Visible = false end
        if self.GlassShine then self.GlassShine.Visible = false end
        task.delay(0.15, function()
            if token ~= self._collapseToken then return end
            self.Body.Visible = false
            if self.TitleSquare then self.TitleSquare.Visible = false end -- плашка скруглена со всех сторон
            if self.SearchBox then self.SearchBox.Visible = false end
            if self.AccentLine then self.AccentLine.Visible = false end
            local info = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            TweenService:Create(self.Main, info, { Size = UDim2.new(0, W, 0, BAR), Position = shifted }):Play()
            TweenService:Create(self.GlowHolder, info, { Position = shifted }):Play()
        end)
    else
        if self.TitleSquare then self.TitleSquare.Visible = true end
        if self.SearchBox then self.SearchBox.Visible = true end
        if self.AccentLine then self.AccentLine.Visible = true end
        local info = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(self.Main, info, { Size = UDim2.new(0, W, 0, H), Position = center }):Play()
        TweenService:Create(self.GlowHolder, info, { Position = center }):Play()
        self.Body.Visible = true
        self.Body.GroupTransparency = 1
        task.delay(0.15, function()
            if token ~= self._collapseToken then return end
            TweenService:Create(self.Body, TweenInfo.new(0.22), { GroupTransparency = 0 }):Play()
            if self.ParticleLayer then self.ParticleLayer.Visible = self._particlesEnabled end
            if self.GlassShine then self.GlassShine.Visible = true end
        end)
    end
end

function Library:Minimize()
    self:SetMinimized(not self._minimized)
end

function Library:SetScale(n)
    n = math.clamp(n or 1, 0.5, 1.5)
    self._scale = n
    self:_applyScale()
    self:_clampToScreen()
    self:_persist("_window_scale", n)
end

function Library:SetIcon(txt)
    if self.TitleIcon then self.TitleIcon.Text = tostring(txt or "⚡") end
end

-- Свой акцентный цвет только для ЭТОГО окна (общие темы не трогает)
function Library:SetAccentColor(color)
    if typeof(color) ~= "Color3" then return end
    self._themeOverride = {
        Name = "Custom",
        Accent = color,
        AccentLight = color:Lerp(Color3.new(1, 1, 1), 0.4),
    }
    self:_refreshTheme()
    self:_persist("_accent", color)
end

function Library:Confirm(config)
    -- Затемнение фона позади попапа — фокусирует внимание и позволяет
    -- закрыть окно кликом мимо (как отмену)
    local backdrop = Instance.new("TextButton")
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 1
    backdrop.AutoButtonColor = false
    backdrop.Text = ""
    backdrop.BorderSizePixel = 0
    backdrop.ZIndex = 4999
    backdrop.Parent = self.ScreenGui
    TweenService:Create(backdrop, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()

    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 320, 0, 160)
    popup.AnchorPoint = Vector2.new(0.5, 0.5)
    popup.Position = UDim2.new(0.5, 0, 0.5, 0)
    popup.BackgroundColor3 = BG_DARK
    popup.BorderSizePixel = 0
    popup.ZIndex = 5000
    popup.Parent = self.ScreenGui
    createCorner(popup, 14)

    local stroke = Instance.new("UIStroke")
    stroke.Color = self:_theme().Accent
    stroke.Thickness = 2
    stroke.Parent = popup

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 16, 0, 14)
    title.Size = UDim2.new(1, -32, 0, 24)
    title.Font = Enum.Font.GothamBold
    title.Text = config.Title or self:_t("confirm")
    title.TextColor3 = TEXT_COLOR
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 5001
    title.Parent = popup

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 16, 0, 44)
    body.Size = UDim2.new(1, -32, 0, 60)
    body.Font = Enum.Font.Gotham
    body.Text = config.Content or ""
    body.TextColor3 = SUBTEXT
    body.TextSize = 13
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.TextWrapped = true
    body.ZIndex = 5001
    body.Parent = popup

    local yes = Instance.new("TextButton")
    yes.Size = UDim2.new(0, 130, 0, 34)
    yes.Position = UDim2.new(0, 16, 1, -50)
    yes.BackgroundColor3 = self:_theme().Accent
    yes.BorderSizePixel = 0
    yes.Font = Enum.Font.GothamBold
    yes.Text = config.YesText or self:_t("yes")
    yes.TextColor3 = Color3.fromRGB(255,255,255)
    yes.TextSize = 13
    yes.ZIndex = 5001
    yes.Parent = popup
    createCorner(yes, 8)

    local no = Instance.new("TextButton")
    no.Size = UDim2.new(0, 130, 0, 34)
    no.Position = UDim2.new(1, -146, 1, -50)
    no.BackgroundColor3 = BG_ITEM
    no.BorderSizePixel = 0
    no.Font = Enum.Font.GothamBold
    no.Text = config.NoText or self:_t("no")
    no.TextColor3 = TEXT_COLOR
    no.TextSize = 13
    no.ZIndex = 5001
    no.Parent = popup
    createCorner(no, 8)

    local closed = false
    local function close(result)
        if closed then return end
        closed = true
        if config.Callback then config.Callback(result) end
        TweenService:Create(backdrop, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        local t = TweenService:Create(popup, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
        })
        t:Play()
        t.Completed:Connect(function()
            popup:Destroy()
            backdrop:Destroy()
        end)
    end

    yes.MouseButton1Click:Connect(function() self:_play("Click") close(true) end)
    no.MouseButton1Click:Connect(function() self:_play("Click") close(false) end)
    backdrop.MouseButton1Click:Connect(function() close(false) end)

    -- appear
    popup.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(popup, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 160),
    }):Play()
end

-- ============================================================
-- CONFIG
-- ============================================================
local function configPathFor(prefix, slot)
    if slot and slot ~= "default" and slot ~= "" then
        return prefix .. "_" .. slot .. ".json"
    end
    return prefix .. ".json"
end

function Library:_loadConfig(slot)
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    local path = configPathFor(self._configPrefix, slot or self._configSlot)
    if not isfile(path) then return end
    local ok, content = pcall(readfile, path)
    if not ok or not content then return end
    local ok2, data = pcall(jsonDecode, content)
    if ok2 and type(data) == "table" then
        for k, v in pairs(data) do self.Flags[k] = v end
    end
end

function Library:_saveConfig(slot)
    if type(writefile) ~= "function" then return end
    local path = configPathFor(self._configPrefix, slot or self._configSlot)
    local ok, encoded = pcall(jsonEncode, self.Flags)
    if ok then pcall(writefile, path, encoded) end
end

function Library:SetFlag(flag, value)
    if not flag then return end
    self.Flags[flag] = value
    self._saveToken = self._saveToken + 1
    local token = self._saveToken
    task.delay(0.4, function()
        if self._saveToken == token then self:_saveConfig() end
    end)
end

function Library:SaveConfig(slot)
    self:_saveConfig(slot)
    self._configSlot = slot or self._configSlot
end

function Library:LoadConfig(slot)
    self._configSlot = slot or self._configSlot
    self:_loadConfig(slot)
    -- применяем загруженные значения к уже нарисованным элементам, а не только в self.Flags
    for _, entry in ipairs(self._flagElements) do
        local v = self.Flags[entry.flag]
        if v ~= nil and entry.obj.Set then
            pcall(entry.obj.Set, v)
        end
    end
end

function Library:DeleteConfig(slot)
    if not slot or slot == "default" or slot == "" then return false end
    if type(delfile) ~= "function" or type(isfile) ~= "function" then return false end
    local path = configPathFor(self._configPrefix, slot)
    if not isfile(path) then return false end
    local ok = pcall(delfile, path)
    return ok and true or false
end

function Library:GetConfigs()
    if type(listfiles) ~= "function" then
        return { "default" }
    end
    local list = {}
    local esc = (self._configPrefix:gsub("%p", "%%%0"))
    pcall(function()
        for _, file in ipairs(listfiles("")) do
            local path = tostring(file)
            local base = path:match("[^/\\]+$") or path
            local m = base:match("^" .. esc .. "_(.-)%.json$")
            if m and m ~= "" then table.insert(list, m) end
        end
    end)
    table.insert(list, 1, "default")
    return list
end

-- ============================================================
-- ГОРЯЧИЕ КЛАВИШИ ЭЛЕМЕНТОВ (работают и при закрытом меню; не срабатывают при наборе текста)
-- ============================================================
function Library:_bindHotkey(key, fn)
    local entry = { key = key, fn = fn }
    self._hotkeys = self._hotkeys or {}
    table.insert(self._hotkeys, entry)
    if not self._hotkeyConn then
        self._hotkeyConn = self:_track(UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            for _, e in ipairs(self._hotkeys) do
                if e.key and input.KeyCode == e.key then e.fn() end
            end
        end))
    end
    return entry
end

-- Бейдж с названием клавиши на строке + управление: ctl.Set(key) / ctl.Get()
function Library:_attachHotkey(row, key, rightOffset, action, label, getState)
    local ctl = { key = resolveKey(key) }
    local entry, badge
    if label then -- для списка клавиш на экране
        table.insert(self._bindInfo, { name = label, getKey = function() return ctl.key end, getState = getState })
    end
    local function guarded()
        if self._locked[row] then return end -- заблокированный/удалённый элемент не реагирует
        action()
    end
    local function refresh()
        if ctl.key and not entry then entry = self:_bindHotkey(ctl.key, guarded) end
        if entry then entry.key = ctl.key end
        if ctl.key then
            if not badge then badge = makeKeyBadge(row, ctl.key, rightOffset, self:_theme()) end
            badge.Text = ctl.key.Name
            badge.Visible = true
        elseif badge then
            badge.Visible = false
        end
    end
    ctl.Set = function(k) ctl.key = resolveKey(k) refresh() end
    ctl.Get = function() return ctl.key end
    refresh()
    return ctl
end

-- ============================================================
-- CONFIG MANAGER (готовый UI: дропдаун профилей + сохранить/загрузить/удалить)
-- ============================================================
-- Window:CreateConfigManager(tab)  или  Window:CreateConfigManager(tab, { Order = 1 })
function Library:CreateConfigManager(tab, config)
    config = config or {}
    local self2 = self
    local function t(k, ...) return self2:_t(k, ...) end

    tab:CreateSection({ Text = config.Text or t("cfg_title"), Order = config.Order })

    local nameValue = self._configSlot or "default"

    local nameInput = tab:CreateInput({
        Name = t("cfg_name"),
        Placeholder = t("cfg_name_ph"),
        CurrentValue = nameValue,
        Order = config.Order,
    })

    local dropdownObj
    local function refreshOptions()
        local configs = self2:GetConfigs()
        if dropdownObj then dropdownObj.SetOptions(configs) end
        return configs
    end

    dropdownObj = tab:CreateDropdown({
        Name = t("cfg_list"),
        Options = self2:GetConfigs(),
        CurrentOption = nameValue,
        Order = config.Order,
        Callback = function(opt)
            nameInput.Set(opt)
        end,
    })

    local row = tab:CreateRow({ Order = config.Order })

    local function makeActionButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 0, 1, 0)
        btn.AutomaticSize = Enum.AutomaticSize.X
        btn.BackgroundColor3 = color
        btn.AutoButtonColor = false
        btn.Font = Enum.Font.GothamBold
        btn.Text = "  " .. text .. "  "
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Parent = row
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = btn
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    makeActionButton(t("cfg_save"), self:_theme().Accent, function()
        local slot = nameInput.Get()
        if not slot or slot == "" then
            self2:Notify({ Kind = "warning", Title = t("cfg_profile"), Content = t("cfg_need_name"), Duration = 3 })
            return
        end
        self2:SaveConfig(slot)
        refreshOptions()
        self2:Notify({ Kind = "success", Title = t("cfg_saved"), Content = t("cfg_saved_msg", slot), Duration = 3 })
    end)

    makeActionButton(t("cfg_load"), BG_ITEM, function()
        local slot = nameInput.Get()
        if not slot or slot == "" then return end
        self2:LoadConfig(slot)
        self2:Notify({ Kind = "success", Title = t("cfg_loaded"), Content = t("cfg_loaded_msg", slot), Duration = 3 })
    end).TextColor3 = TEXT_COLOR

    makeActionButton(t("cfg_delete"), Color3.fromRGB(200, 60, 70), function()
        local slot = nameInput.Get()
        if not slot or slot == "default" or slot == "" then
            self2:Notify({ Kind = "warning", Title = t("cfg_profile"), Content = t("cfg_no_default"), Duration = 3 })
            return
        end
        self2:Confirm({
            Title = t("cfg_del_title"),
            Content = t("cfg_del_body", slot),
            Callback = function(yes)
                if not yes then return end
                local ok = self2:DeleteConfig(slot)
                refreshOptions()
                self2:Notify({
                    Kind = ok and "success" or "error",
                    Title = ok and t("cfg_deleted") or t("cfg_del_fail"),
                    Content = ok and t("cfg_deleted_msg", slot) or t("cfg_del_hint"),
                    Duration = 3,
                })
            end,
        })
    end)

    return { Refresh = refreshOptions }
end

-- ============================================================
-- ЗВУКИ ИНТЕРФЕЙСА
-- ============================================================
-- Принимает "rbxassetid://123", число 123 или ссылку create.roblox.com/store/asset/123/...
local function normalizeSoundId(v)
    if type(v) == "number" then return "rbxassetid://" .. tostring(math.floor(v)) end
    if type(v) ~= "string" then return nil end
    local id = v:match("/asset/(%d+)") or v:match("/library/(%d+)")
    if id then return "rbxassetid://" .. id end
    if v:match("^%d+$") then return "rbxassetid://" .. v end
    return v
end

function Library:_initSounds()
    local cfg = self.Config.Sounds
    self._soundsEnabled = (cfg ~= false)
    self._soundVolume = 1

    local defs = {}
    for name, d in pairs(DEFAULT_SOUNDS) do defs[name] = { Id = d.Id, Volume = d.Volume } end

    if type(cfg) == "table" then
        if cfg.Enabled ~= nil then self._soundsEnabled = cfg.Enabled and true or false end
        if type(cfg.Volume) == "number" then self._soundVolume = math.clamp(cfg.Volume, 0, 1) end
        for name, v in pairs(cfg) do
            local d = defs[name]
            if d then
                if type(v) == "table" then
                    if v.Id then d.Id = normalizeSoundId(v.Id) or d.Id end
                    if type(v.Volume) == "number" then d.Volume = v.Volume end
                else
                    d.Id = normalizeSoundId(v) or d.Id
                end
            end
        end
    end

    -- выбор самого игрока (из меню) важнее настроек скрипта
    if type(self.Flags["_sounds_enabled"]) == "boolean" then self._soundsEnabled = self.Flags["_sounds_enabled"] end
    if type(self.Flags["_sounds_volume"]) == "number" then self._soundVolume = math.clamp(self.Flags["_sounds_volume"], 0, 1) end

    self._soundDefs = defs
    self._soundObjs = {}
    local folder = Instance.new("Folder")
    folder.Name = "HIrosSounds"
    folder.Parent = self.ScreenGui
    for name, d in pairs(defs) do
        local snd = Instance.new("Sound")
        snd.Name = name
        snd.SoundId = d.Id
        snd.Volume = d.Volume * self._soundVolume
        snd.Parent = folder
        self._soundObjs[name] = snd
    end

    -- заранее подгружаем, чтобы первый клик не молчал
    task.spawn(function()
        pcall(function() game:GetService("ContentProvider"):PreloadAsync(folder:GetChildren()) end)
    end)
end

function Library:_play(name)
    if not self._soundsEnabled then return end
    local snd = self._soundObjs and self._soundObjs[name]
    if not snd then return end
    if name == "Hover" then -- не трещим при быстром проведении курсора по списку
        local now = os.clock()
        if now - (self._lastHoverSound or -math.huge) < 0.07 then return end
        self._lastHoverSound = now
    end
    snd.TimePosition = 0
    snd:Play()
end

function Library:_applySoundVolumes()
    for name, snd in pairs(self._soundObjs or {}) do
        snd.Volume = self._soundDefs[name].Volume * self._soundVolume
    end
end

function Library:PlaySound(name) self:_play(name) end

function Library:SetSoundsEnabled(enabled)
    self._soundsEnabled = enabled and true or false
    self:SetFlag("_sounds_enabled", self._soundsEnabled)
end

function Library:GetSoundsEnabled() return self._soundsEnabled end

-- общая громкость 0..1
function Library:SetSoundVolume(n)
    self._soundVolume = math.clamp(tonumber(n) or 1, 0, 1)
    self:_applySoundVolumes()
    self:SetFlag("_sounds_volume", self._soundVolume)
end

-- Window:SetSound("Click", "rbxassetid://123")  или  Window:SetSound("Click", { Id = 123, Volume = 0.7 })
function Library:SetSound(name, value)
    local d = self._soundDefs and self._soundDefs[name]
    if not d then return false end
    if type(value) == "table" then
        if value.Id then d.Id = normalizeSoundId(value.Id) or d.Id end
        if type(value.Volume) == "number" then d.Volume = value.Volume end
    else
        d.Id = normalizeSoundId(value) or d.Id
    end
    local snd = self._soundObjs[name]
    snd.SoundId = d.Id
    snd.Volume = d.Volume * self._soundVolume
    return true
end

-- ============================================================
-- ПОИСК ПО ВСЕМ ВКЛАДКАМ
-- ============================================================
-- Строка поиска в шапке фильтрует элементы всех вкладок сразу. Совпадение, если текст есть
-- в названии элемента, в названии вкладки или в заголовке секции (тогда показывается вся секция).
function Library:_applySearch(rawQuery)
    local query = lowerText((tostring(rawQuery or ""):gsub("^%s+", ""):gsub("%s+$", "")))
    local active = query ~= ""
    local firstMatchTab, totalMatches = nil, 0

    local function setVisible(item, show)
        if not active then
            local saved = self._origVis[item]
            if saved then item.Visible = saved.v; self._origVis[item] = nil end
            return
        end
        if not self._origVis[item] then self._origVis[item] = { v = item.Visible } end
        item.Visible = show and self._origVis[item].v or false
    end

    for key, tab in pairs(self.Tabs) do
        local items = {}
        for idx, child in ipairs(tab.Content:GetChildren()) do
            local cn = child.ClassName
            if cn ~= "UIListLayout" and cn ~= "UIPadding" and cn ~= "UICorner" then
                items[#items + 1] = { inst = child, idx = idx }
            end
        end
        table.sort(items, function(a, b)
            if a.inst.LayoutOrder ~= b.inst.LayoutOrder then return a.inst.LayoutOrder < b.inst.LayoutOrder end
            return a.idx < b.idx
        end)

        local tabNameMatch = active and lowerText(tab.Name):find(query, 1, true) ~= nil
        local currentSection, sectionHas, sectionTitleMatch = nil, false, false
        local tabMatches = tabNameMatch and 1 or 0

        for _, it in ipairs(items) do
            local inst = it.inst
            if self._sections[inst] then
                if currentSection then setVisible(currentSection, not active or sectionHas or sectionTitleMatch) end
                currentSection, sectionHas = inst, false
                sectionTitleMatch = active and textHas(inst, query)
            else
                local matched = (not active) or tabNameMatch or sectionTitleMatch or textHas(inst, query)
                setVisible(inst, matched)
                if matched and active then sectionHas = true; tabMatches = tabMatches + 1 end
            end
        end
        if currentSection then setVisible(currentSection, not active or sectionHas or sectionTitleMatch) end

        local btn = self.TabButtons[key]
        if btn then btn.Visible = (not active) or tabMatches > 0 end
        if tabMatches > 0 then
            totalMatches = totalMatches + tabMatches
            if not firstMatchTab then firstMatchTab = key end
        end
        tab.Content.CanvasPosition = Vector2.new(0, 0)
    end

    -- если на текущей вкладке ничего не нашлось — прыгаем на первую, где есть совпадения
    if active and firstMatchTab then
        local curBtn = self.TabButtons[self.CurrentTab]
        if curBtn and not curBtn.Visible then self:SelectTab(firstMatchTab) end
    end

    if not self._noResults then
        local nr = Instance.new("TextLabel")
        nr.BackgroundTransparency = 1
        nr.Size = UDim2.new(1, 0, 0, 40)
        nr.Position = UDim2.new(0, 0, 0.35, 0)
        nr.Font = Enum.Font.GothamMedium
        nr.Text = self:_t("no_results")
        nr.TextColor3 = SUBTEXT
        nr.TextSize = 14
        nr.Visible = false
        nr.ZIndex = 8
        nr.Parent = self.ContentPadding
        self._noResults = nr
    end
    self._noResults.Visible = active and totalMatches == 0
end

function Library:Search(text)
    text = text or ""
    if self.SearchBox then self.SearchBox.Text = text end
    self:_applySearch(text)
end

function Library:ClearSearch() self:Search("") end

-- ============================================================
-- TABS
-- ============================================================
-- Навешивает на tab (или на accordion) все методы Create*
local CREATORS = {
    CreateButton = "_addButton", CreateToggle = "_addToggle", CreateSlider = "_addSlider",
    CreateColorPicker = "_addColorPicker", CreateDropdown = "_addDropdown",
    CreateMultiDropdown = "_addMultiDropdown", CreateInput = "_addInput", CreateTextBox = "_addTextBox",
    CreateLabel = "_addLabel", CreateDivider = "_addDivider", CreateDividerText = "_addDividerText",
    CreateSection = "_addSection", CreateKeybind = "_addKeybind", CreateParagraph = "_addParagraph",
    CreateProgressBar = "_addProgressBar", CreateStepper = "_addStepper", CreateRadioGroup = "_addRadioGroup",
    CreateLoader = "_addLoader", CreateAccordion = "_addAccordion", CreateChart = "_addChart",
}

function Library:_attachCreators(tab)
    for method, adder in pairs(CREATORS) do
        tab[method] = function(_, cfg)
            local c = withOrder(tab, cfg)
            return self:_decorate(tab, c, self[adder](self, tab, c))
        end
    end
    -- Row — просто контейнер для своих кнопок, возвращаем сам Frame
    tab.CreateRow = function(_, cfg) return self:_addRow(tab, withOrder(tab, cfg)) end
end

-- Общие возможности каждого элемента:
--   obj.SetVisible(bool) / IsVisible()   obj.SetLocked(bool) / IsLocked()
--   obj.SetName("текст")                 obj.Destroy()
-- и реестр Window.Options.<Flag> для элементов с Flag.
-- Методы можно вызывать и через точку, и через двоеточие (obj.Set(1) / obj:Set(1)).
function Library:_decorate(tab, cfg, res)
    if res == nil then return res end
    local obj
    if typeof(res) == "Instance" then
        -- Кнопка/Label/Paragraph раньше возвращали Instance: оставляем доступ к свойствам через обёртку
        obj = { Instance = res }
        setmetatable(obj, {
            __index = function(_, k)
                local ok, v = pcall(function() return res[k] end)
                if not ok then return nil end
                if type(v) == "function" then return function(_, ...) return v(res, ...) end end
                return v
            end,
            __newindex = function(t, k, v)
                if k == "Instance" then rawset(t, k, v) return end
                local ok = pcall(function() res[k] = v end)
                if not ok then rawset(t, k, v) end
            end,
        })
    else
        obj = res
    end

    local inst = rawget(obj, "Instance")
    if typeof(inst) ~= "Instance" then return obj end

    local function def(name, fn)
        if rawget(obj, name) == nil then rawset(obj, name, fn) end
    end

    -- «хвост» выпадающих списков и колорпикера: контейнер с LayoutOrder + 0.5
    local extras = {}
    for _, sib in ipairs(tab.Content:GetChildren()) do
        if sib ~= inst and sib:IsA("GuiObject") and sib.LayoutOrder == inst.LayoutOrder + 0.5 then
            table.insert(extras, sib)
        end
    end

    local curName = cfg.Name or cfg.Text or cfg.Title
    def("SetName", function(newName)
        newName = tostring(newName)
        if curName == nil then return end
        local function try(o)
            if not (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")) then return false end
            local t = o.Text
            local pre = t:match("^(%s*)") or ""
            local post = t:match("(%s*)$") or ""
            local core = (t:gsub("^%s+", ""):gsub("%s+$", ""))
            if core == curName then o.Text = pre .. newName .. post return true end
            if core == upperText(curName) then o.Text = pre .. upperText(newName) .. post return true end
            return false
        end
        if not try(inst) then
            for _, d in ipairs(inst:GetDescendants()) do
                if try(d) then break end
            end
        end
        curName = newName
    end)

    local visible = true
    def("SetVisible", function(v)
        visible = v and true or false
        inst.Visible = visible
        local saved = self._origVis[inst]
        if saved then saved.v = visible end
        for _, e in ipairs(extras) do
            if not visible then e.Visible = false
            elseif e.Size.Y.Offset > 0 then e.Visible = true end
        end
    end)
    def("IsVisible", function() return visible end)

    -- Блокировка: серая накладная, которая перехватывает нажатия (+ клавиши элемента не срабатывают)
    local locked, overlay = false, nil
    def("SetLocked", function(v)
        locked = v and true or false
        self._locked[inst] = locked or nil
        if inst:FindFirstChildOfClass("UIListLayout") then return end -- контейнеры (аккордеон, параграф) не затемняем
        if locked and not overlay then
            overlay = Instance.new("Frame")
            overlay.Name = "LockOverlay"
            overlay.BackgroundColor3 = BG_DARK
            overlay.BackgroundTransparency = 0.45
            overlay.BorderSizePixel = 0
            overlay.Size = UDim2.new(1, 0, 1, 0)
            overlay.ZIndex = 60
            overlay.Active = true -- съедает нажатия
            overlay.Parent = inst
            createCorner(overlay, 10)
        end
        if overlay then overlay.Visible = locked end
    end)
    def("IsLocked", function() return locked end)

    def("Destroy", function()
        for _, e in ipairs(extras) do e:Destroy() end
        inst:Destroy()
        for i, el in ipairs(self.Elements) do
            if el.Instance == inst then table.remove(self.Elements, i) break end
        end
        for i = #self._flagElements, 1, -1 do
            if self._flagElements[i].obj == obj then table.remove(self._flagElements, i) end
        end
        if cfg.Flag and self.Options[cfg.Flag] == obj then self.Options[cfg.Flag] = nil end
        self._locked[inst] = true -- горячие клавиши уничтоженного элемента больше не срабатывают
    end)

    -- obj:Method(...) и obj.Method(...) работают одинаково
    for k, v in pairs(obj) do
        if type(v) == "function" and not tostring(k):match("^Create") then
            rawset(obj, k, function(a, ...)
                if a == obj then return v(...) end
                return v(a, ...)
            end)
        end
    end

    if cfg.Flag then self.Options[cfg.Flag] = obj end

    -- Quick = true на тумблере: сразу делаем круглую кнопку быстрого доступа (удобно на телефоне)
    if cfg.Quick and rawget(obj, "Get") and rawget(obj, "Set") then
        self:CreateQuickButton({ Name = cfg.Name, Toggle = obj })
    end
    return obj
end

-- Значение по флагу: Window:GetValue("speed")
function Library:GetValue(flag)
    local o = self.Options[flag]
    if o and rawget(o, "Get") then return o.Get() end
    return self.Flags[flag]
end

-- ============================================================
-- ГРУППЫ ВКЛАДОК (заголовки в сайдбаре)
-- ============================================================
function Library:_createGroupHeader(text, order)
    local h = Instance.new("TextLabel")
    h.Name = "Group_" .. text
    h.BackgroundTransparency = 1
    h.Size = UDim2.new(1, 0, 0, 24)
    h.Font = Enum.Font.GothamBold
    h.Text = "  " .. upperText(text)
    h.TextColor3 = SUBTEXT
    h.TextTransparency = 0.15
    h.TextSize = 10
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.TextYAlignment = Enum.TextYAlignment.Bottom
    h.LayoutOrder = order
    h.ZIndex = 4
    h.Parent = self.TabList
    return h
end

-- LayoutOrder вкладки: без группы — сверху в порядке создания, группы идут блоками
-- после них (в порядке появления), даже если вкладки группы создавались вразнобой.
function Library:_tabOrderFor(group)
    self._groups = self._groups or {}
    self._tabCounter = (self._tabCounter or 0) + 1
    if not group then return self._tabCounter end
    local g = self._groups[group]
    if not g then
        self._groupCount = (self._groupCount or 0) + 1
        g = { base = self._groupCount * 1000 }
        self._groups[group] = g
        g.header = self:_createGroupHeader(group, g.base)
    end
    return g.base + self._tabCounter
end

-- Window:CreateTabGroup("Игра")  — заголовок заранее; затем CreateTab({ Name = "...", Group = "Игра" })
function Library:CreateTabGroup(name)
    self:_tabOrderFor(name)
    self._tabCounter = self._tabCounter - 1 -- заголовок не вкладка
    return self._groups[name].header
end

-- ============================================================
-- ACCORDION (сворачиваемая группа настроек)
-- ============================================================
-- local g = tab:CreateAccordion({ Name = "Полёт", Open = true })
-- g:CreateToggle({...}); g:CreateSlider({...})   — внутри те же компоненты, что и во вкладке
function Library:_addAccordion(tab, config)
    local self = self
    local open = config.Open and true or false

    local wrap = Instance.new("Frame")
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    wrap.Size = UDim2.new(1, 0, 0, 0)
    wrap.LayoutOrder = config.Order or 0
    wrap.ZIndex = 4
    wrap.Parent = tab.Content

    local wrapLayout = Instance.new("UIListLayout")
    wrapLayout.Padding = UDim.new(0, 6)
    wrapLayout.SortOrder = Enum.SortOrder.LayoutOrder
    wrapLayout.Parent = wrap

    local header = makeRowBase(wrap, 0, 40)
    header.LayoutOrder = 1
    header.Text = "   " .. (config.Name or "Группа")
    addHover(header, self)

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▶"
    arrow.TextColor3 = SUBTEXT
    arrow.TextSize = 10
    arrow.ZIndex = 5
    arrow.Parent = header

    local body = Instance.new("CanvasGroup")
    body.BackgroundColor3 = BG_PANEL
    body.BackgroundTransparency = 0.4
    body.BorderSizePixel = 0
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Size = UDim2.new(1, 0, 0, 0)
    body.LayoutOrder = 2
    body.ZIndex = 4
    body.Parent = wrap
    createCorner(body, 10)

    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.Padding = UDim.new(0, 8)
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Parent = body

    local bodyPad = Instance.new("UIPadding")
    bodyPad.PaddingTop = UDim.new(0, 8)
    bodyPad.PaddingBottom = UDim.new(0, 8)
    bodyPad.PaddingLeft = UDim.new(0, 8)
    bodyPad.PaddingRight = UDim.new(0, 8)
    bodyPad.Parent = body

    local animToken = 0
    local function setOpen(v, instant)
        open = v and true or false
        animToken = animToken + 1
        local token = animToken
        local rot = open and 90 or 0
        if instant then arrow.Rotation = rot
        else TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = rot }):Play() end

        if instant then
            body.Visible = open
            body.GroupTransparency = 0
            body.AutomaticSize = Enum.AutomaticSize.Y
            body.Size = UDim2.new(1, 0, 0, 0)
            return
        end

        local scale = (self.Scale and self.Scale.Scale) or 1
        if open then
            body.AutomaticSize = Enum.AutomaticSize.None
            body.Size = UDim2.new(1, 0, 0, 0)
            body.GroupTransparency = 1
            body.Visible = true
            task.spawn(function()
                RunService.Heartbeat:Wait() -- кадр на то, чтобы раскладка посчитала высоту содержимого
                if token ~= animToken then return end
                local acs = bodyLayout.AbsoluteContentSize
                local h = (typeof(acs) == "Vector2" and acs.Y or 0) / scale + 16
                if h <= 16 then -- измерить не вышло: просто показываем с затуханием
                    body.AutomaticSize = Enum.AutomaticSize.Y
                    body.Size = UDim2.new(1, 0, 0, 0)
                    TweenService:Create(body, TweenInfo.new(0.22), { GroupTransparency = 0 }):Play()
                    return
                end
                TweenService:Create(body, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, h), GroupTransparency = 0,
                }):Play()
                task.delay(0.3, function()
                    if token ~= animToken or not open then return end
                    body.AutomaticSize = Enum.AutomaticSize.Y -- дальше сам подстраивается под содержимое
                    body.Size = UDim2.new(1, 0, 0, 0)
                end)
            end)
        else
            local abs = body.AbsoluteSize
            local h = (typeof(abs) == "Vector2" and abs.Y or 0) / scale
            body.AutomaticSize = Enum.AutomaticSize.None
            body.Size = UDim2.new(1, 0, 0, h)
            local tw = TweenService:Create(body, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(1, 0, 0, 0), GroupTransparency = 1,
            })
            tw:Play()
            tw.Completed:Connect(function()
                if token ~= animToken or open then return end
                body.Visible = false
                body.AutomaticSize = Enum.AutomaticSize.Y
                body.Size = UDim2.new(1, 0, 0, 0)
                body.GroupTransparency = 0
            end)
        end
    end
    setOpen(open, true)
    header.MouseButton1Click:Connect(function() setOpen(not open) end)

    -- "вкладка-внутри-вкладки": все Create* кладут элементы в body
    local sub = { Name = config.Name, Key = (tab.Key or tab.Name or "") .. "/" .. tostring(config.Name), Content = body, Parent = self, Instance = wrap }
    self:_attachCreators(sub)
    sub.Open = function() setOpen(true) end
    sub.Close = function() setOpen(false) end
    sub.Toggle = function() setOpen(not open) end
    sub.IsOpen = function() return open end
    return sub
end

-- ============================================================
-- CHART (мини-график в реальном времени, столбцы с контурной линией сверху)
-- ============================================================
-- local fps = tab:CreateChart({ Name = "FPS", Min = 0, Max = 120, Points = 60, Suffix = " fps" })
-- fps.Push(value)   или   Source = function() return число end, Interval = 0.25  — сам опрашивает
function Library:_addChart(tab, config)
    local self = self
    local points = math.clamp(math.floor(config.Points or 60), 10, 200)
    local height = math.clamp(config.Height or 80, 40, 200)
    local suffix = config.Suffix or ""
    local fixedMin, fixedMax = config.Min, config.Max
    local auto = (fixedMax == nil) or config.Auto == true
    local values = {}

    local card = Instance.new("Frame")
    card.BackgroundColor3 = BG_ITEM
    card.BorderSizePixel = 0
    card.Size = UDim2.new(1, 0, 0, height + 40)
    card.LayoutOrder = config.Order or 0
    card.ZIndex = 4
    card.Parent = tab.Content
    createCorner(card, 10)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 12, 0, 6)
    nameLabel.Size = UDim2.new(0.6, -12, 0, 18)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.Text = config.Name or "Chart"
    nameLabel.TextColor3 = TEXT_COLOR
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 5
    nameLabel.Parent = card

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0.6, 0, 0, 6)
    valueLabel.Size = UDim2.new(0.4, -12, 0, 18)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = "--"
    valueLabel.TextColor3 = self:_theme().Accent
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 5
    valueLabel.Parent = card

    local plot = Instance.new("Frame")
    plot.BackgroundColor3 = INPUT
    plot.BorderSizePixel = 0
    plot.Position = UDim2.new(0, 12, 0, 30)
    plot.Size = UDim2.new(1, -24, 0, height)
    plot.ClipsDescendants = true
    plot.ZIndex = 5
    plot.Parent = card
    createCorner(plot, 8)

    for _, y in ipairs({ 0.25, 0.5, 0.75 }) do
        local g = Instance.new("Frame")
        g.BackgroundColor3 = LINE
        g.BackgroundTransparency = 0.93
        g.BorderSizePixel = 0
        g.Position = UDim2.new(0, 0, y, 0)
        g.Size = UDim2.new(1, 0, 0, 1)
        g.ZIndex = 5
        g.Parent = plot
    end

    local bars = {}
    for i = 1, points do
        local bar = Instance.new("Frame")
        bar.AnchorPoint = Vector2.new(0, 1)
        bar.Position = UDim2.new((i - 1) / points, 0, 1, 0)
        bar.Size = UDim2.new(1 / points, 0, 0, 0)
        bar.BackgroundColor3 = self:_theme().Accent
        bar.BackgroundTransparency = 0.55
        bar.BorderSizePixel = 0
        bar.ZIndex = 6
        bar.Parent = plot

        local cap = Instance.new("Frame")
        cap.BackgroundColor3 = self:_theme().AccentLight
        cap.BorderSizePixel = 0
        cap.Size = UDim2.new(1, 0, 0, 2)
        cap.Visible = false
        cap.ZIndex = 7
        cap.Parent = bar
        bars[i] = { bar = bar, cap = cap }
    end

    local lastPush = 0
    local function draw(animate)
        local lo, hi = fixedMin or 0, fixedMax or 1
        if auto then
            local vmin, vmax = math.huge, -math.huge
            for _, v in ipairs(values) do
                if v < vmin then vmin = v end
                if v > vmax then vmax = v end
            end
            if vmin == math.huge then vmin, vmax = 0, 1 end
            lo = fixedMin or math.min(0, vmin)
            hi = vmax
            if hi <= lo then hi = lo + 1 end
            hi = hi + (hi - lo) * 0.05
        end
        local span = hi - lo
        if span <= 0 then span = 1 end
        local offset = points - #values
        for i = 1, points do
            local v = values[i - offset]
            local frac = 0
            if v then frac = math.clamp((v - lo) / span, 0, 1) end
            local newSize = UDim2.new(1 / points, 0, frac, 0)
            if animate then
                TweenService:Create(bars[i].bar, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = newSize }):Play()
            else
                bars[i].bar.Size = newSize
            end
            bars[i].cap.Visible = frac > 0
        end
        local last = values[#values]
        if last then
            local text = config.Format and config.Format(last) or string.format("%g", math.floor(last * 10 + 0.5) / 10)
            valueLabel.Text = text .. suffix
        else
            valueLabel.Text = "--"
        end
    end
    draw()

    local obj = {}
    obj.Instance = card
    obj.Push = function(v)
        if type(v) ~= "number" then return end
        table.insert(values, v)
        if #values > points then table.remove(values, 1) end
        -- плавно, пока данные идут не чаще ~8 раз/сек; при частом потоке — без твинов (чтобы не грузить)
        local now = os.clock()
        local animate = (now - lastPush) > 0.12
        lastPush = now
        draw(animate)
    end
    obj.SetRange = function(a, b)
        fixedMin, fixedMax = a, b
        auto = false
        draw()
    end
    obj.Clear = function() values = {} draw() end
    obj.Get = function() return values[#values] end
    obj.UpdateTheme = function()
        local theme = self:_theme()
        valueLabel.TextColor3 = theme.Accent
        for _, b in ipairs(bars) do
            b.bar.BackgroundColor3 = theme.Accent
            b.cap.BackgroundColor3 = theme.AccentLight
        end
    end
    table.insert(self.Elements, { Type = "Chart", Instance = card, UpdateTheme = obj.UpdateTheme })

    if type(config.Source) == "function" then
        task.spawn(function()
            local interval = config.Interval or 0.25
            while card.Parent do
                local ok, v = pcall(config.Source)
                if ok then obj.Push(v) end
                task.wait(interval)
            end
        end)
    end
    return obj
end

function Library:CreateTab(nameOrConfig)
    local self = self
    local name, icon
    if type(nameOrConfig) == "table" then
        name = nameOrConfig.Name or "Tab"
        icon = nameOrConfig.Icon
    else
        name = nameOrConfig or "Tab"
    end

    local key = name
    local idx = 2
    while self.Tabs[key] do key = name .. "_" .. idx; idx = idx + 1 end

    local tab = { Name = name, Key = key, Elements = {}, Parent = self }
    self.Tabs[key] = tab

    local btn = Instance.new("TextButton")
    btn.Name = key .. "Tab"
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = BG_ITEM
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 4
    btn.Parent = self.TabList
    btn.LayoutOrder = self:_tabOrderFor((type(nameOrConfig) == "table") and nameOrConfig.Group or nil)
    createCorner(btn, 10)

    -- лёгкий градиент для объёма
    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(205, 205, 215))
    btnGrad.Rotation = 90
    btnGrad.Parent = btn

    -- индикатор активной вкладки (растёт слева)
    local indicator = Instance.new("Frame")
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.Position = UDim2.new(0, 3, 0.5, 0)
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 6
    indicator.Parent = btn
    createCorner(indicator, 999)
    tab.Indicator = indicator

    local textOffset = 12
    if icon then
        local iconInst
        if type(icon) == "string" and (icon:match("^rbxassetid://") or icon:match("^https?://")) then
            iconInst = Instance.new("ImageLabel")
            iconInst.Size = UDim2.new(0, 18, 0, 18)
            iconInst.Position = UDim2.new(0, 10, 0.5, -9)
            iconInst.BackgroundTransparency = 1
            iconInst.Image = icon
            iconInst.ZIndex = 5
            iconInst.Parent = btn
        else
            iconInst = Instance.new("TextLabel")
            iconInst.Size = UDim2.new(0, 20, 0, 20)
            iconInst.Position = UDim2.new(0, 10, 0.5, -10)
            iconInst.BackgroundTransparency = 1
            iconInst.Font = Enum.Font.GothamBold
            iconInst.Text = tostring(icon)
            iconInst.TextColor3 = Color3.fromRGB(255,255,255)
            iconInst.TextSize = 14
            iconInst.ZIndex = 5
            iconInst.Parent = btn
        end
        tab.Icon = iconInst
        textOffset = 36
    end

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, textOffset, 0, 0)
    label.Size = UDim2.new(1, -textOffset - 6, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = name
    label.TextColor3 = SUBTEXT
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.ZIndex = 5
    label.Parent = btn
    tab.Label = label

    self.TabButtons[key] = btn

    -- CanvasGroup позволяет плавно скрывать/показывать всю страницу целиком
    local group = Instance.new("CanvasGroup")
    group.BackgroundTransparency = 1
    group.Size = UDim2.new(1, 0, 1, 0)
    group.GroupTransparency = 0
    group.Visible = false
    group.ZIndex = 3
    group.Parent = self.ContentPadding
    tab.Group = group

    local page = Instance.new("ScrollingFrame")
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = self:_theme().Accent
    page.ClipsDescendants = true
    page.ZIndex = 3
    page.Parent = group
    table.insert(self._scrollBars, page)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingRight = UDim.new(0, 10)
    pagePad.PaddingBottom = UDim.new(0, 4)
    pagePad.Parent = page

    tab.Content = page

    btn.MouseButton1Click:Connect(function() self:_play("Click") self:SelectTab(key) end)
    if not self.CurrentTab then self:SelectTab(key) end

    self:_attachCreators(tab)

    return tab
end

function Library:SelectTab(key)
    if self.CurrentTab == key then return end
    local previousTab = self.CurrentTab
    self.CurrentTab = key
    local theme = self:_theme()

    for k, tab in pairs(self.Tabs) do
        local isNew = (k == key)
        if isNew then
            tab.Group.Visible = true
            if previousTab then
                tab.Group.GroupTransparency = 1
                tab.Group.Position = UDim2.new(0, 0, 0, 14)
                TweenService:Create(tab.Group, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    GroupTransparency = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                }):Play()
            end
        else
            tab.Group.Visible = false
        end
        if tab.Indicator then
            TweenService:Create(tab.Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 3, 0, isNew and 18 or 0),
            }):Play()
        end
    end
    for k, btn in pairs(self.TabButtons) do
        local active = (k == key)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = active and theme.Accent or BG_ITEM,
        }):Play()
        local tabData = self.Tabs[k]
        if tabData then
            if tabData.Label then
                TweenService:Create(tabData.Label, TweenInfo.new(0.15), {
                    TextColor3 = active and Color3.fromRGB(255,255,255) or SUBTEXT,
                }):Play()
            end
            if tabData.Icon then
                if tabData.Icon:IsA("ImageLabel") then
                    tabData.Icon.ImageColor3 = active and Color3.fromRGB(255,255,255) or SUBTEXT
                elseif tabData.Icon:IsA("TextLabel") then
                    tabData.Icon.TextColor3 = active and Color3.fromRGB(255,255,255) or SUBTEXT
                end
                -- Поп-баунс иконки при переходе на новую активную вкладку
                if active and k ~= previousTab then
                    local icon = tabData.Icon
                    local baseSize = icon.Size
                    TweenService:Create(icon, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = baseSize + UDim2.new(0, 5, 0, 5),
                    }):Play()
                    task.delay(0.1, function()
                        if icon.Parent then
                            TweenService:Create(icon, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                                Size = baseSize,
                            }):Play()
                        end
                    end)
                end
            end
        end
    end
end

-- ============================================================
-- ELEMENTS
-- ============================================================
-- ============================================================
-- TOOLTIP (наведение с задержкой, следует логике конкретного элемента)
-- ============================================================
function Library:_attachTooltip(row, text)
    if not text or text == "" then return end
    local self = self
    local tooltip
    local showToken = 0

    row.MouseEnter:Connect(function()
        showToken = showToken + 1
        local token = showToken
        task.delay(0.45, function()
            if token ~= showToken or not row.Parent then return end
            local mouse = UserInputService:GetMouseLocation()
            tooltip = Instance.new("TextLabel")
            tooltip.BackgroundColor3 = BG_PANEL
            tooltip.BorderSizePixel = 0
            tooltip.AutomaticSize = Enum.AutomaticSize.X
            tooltip.Size = UDim2.new(0, 0, 0, 26)
            tooltip.Position = UDim2.new(0, mouse.X + 16, 0, mouse.Y + 16)
            tooltip.Font = Enum.Font.Gotham
            tooltip.Text = "  " .. text .. "  "
            tooltip.TextColor3 = TEXT_COLOR
            tooltip.TextSize = 12
            tooltip.BackgroundTransparency = 1
            tooltip.TextTransparency = 1
            tooltip.ZIndex = 6000
            tooltip.Parent = self.ScreenGui
            createCorner(tooltip, 6)
            local stroke = Instance.new("UIStroke")
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Color = self:_theme().Accent
            stroke.Transparency = 0.3
            stroke.Parent = tooltip

            TweenService:Create(tooltip, TweenInfo.new(0.12), { BackgroundTransparency = 0, TextTransparency = 0 }):Play()
        end)
    end)

    row.MouseLeave:Connect(function()
        showToken = showToken + 1
        if tooltip then
            tooltip:Destroy()
            tooltip = nil
        end
    end)
end

function Library:_addButton(tab, config)
    local row = makeRowBase(tab.Content, config.Order, 40)
    row.Text = "   " .. (config.Name or "Button")
    addHover(row, self)
    self:_attachTooltip(row, config.Tooltip)

    if config.Badge then
        local badge = makeBadge(row, config.Badge, config.BadgeColor, self:_theme())
        badge.Position = UDim2.new(1, -50, 0.5, -7)
    end

    local function activate()
        if config.Confirm then
            self:Confirm({
                Title = config.Name or self:_t("confirm"),
                Content = config.ConfirmText or self:_t("sure"),
                Callback = function(yes)
                    if yes and config.Callback then config.Callback() end
                end,
            })
        elseif config.Callback then
            config.Callback()
        end
    end
    row.MouseButton1Click:Connect(activate)

    -- Hotkey = Enum.KeyCode.G (или Keybind — старое имя); клавиша делает то же, что клик
    local hk = config.Hotkey or config.Keybind
    if hk then self:_attachHotkey(row, hk, config.Badge and -56 or -10, activate, config.Name) end

    table.insert(self.Elements, { Type = "Button", Instance = row })
    return row
end

function Library:_addToggle(tab, config)
    local self = self
    local flag = config.Flag
    local state
    if flag and self.Flags[flag] ~= nil then state = self.Flags[flag]
    else state = config.CurrentValue end
    state = state and true or false

    local row = makeRowBase(tab.Content, config.Order, config.Description and 50 or 40)
    row.Text = ""
    addHover(row, self, true)
    self:_attachTooltip(row, config.Tooltip)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 12, 0, config.Description and 6 or 0)
    nameLabel.Size = UDim2.new(1, -70, 0, config.Description and 18 or 40)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.Text = config.Name or "Toggle"
    nameLabel.TextColor3 = TEXT_COLOR
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 5
    nameLabel.Parent = row

    if config.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 12, 0, 24)
        descLabel.Size = UDim2.new(1, -70, 0, 16)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = config.Description
        descLabel.TextColor3 = SUBTEXT
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 5
        descLabel.Parent = row
    end

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 40, 0, 20)
    track.Position = UDim2.new(1, -50, 0.5, -10)
    track.BackgroundColor3 = TRACK_OFF
    track.BorderSizePixel = 0
    track.ZIndex = 4
    track.Parent = row
    createCorner(track, 999)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 5
    knob.Parent = track
    createCorner(knob, 999)

    -- ореол вокруг дорожки: светится, когда тумблер включён
    local halo = Instance.new("Frame")
    halo.AnchorPoint = Vector2.new(0.5, 0.5)
    halo.Position = UDim2.new(0.5, 0, 0.5, 0)
    halo.Size = UDim2.new(1, 12, 1, 12)
    halo.BackgroundColor3 = self:_theme().Accent
    halo.BackgroundTransparency = 1
    halo.BorderSizePixel = 0
    halo.ZIndex = 3
    halo.Parent = track
    createCorner(halo, 999)

    local function updateVisual()
        local theme = self:_theme()
        if state then
            TweenService:Create(track, TweenInfo.new(0.2), { BackgroundColor3 = theme.Accent }):Play()
            TweenService:Create(knob, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(1, -18, 0.5, -8) }):Play()
            TweenService:Create(halo, TweenInfo.new(0.25), { BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.72 }):Play()
        else
            TweenService:Create(track, TweenInfo.new(0.2), { BackgroundColor3 = TRACK_OFF }):Play()
            TweenService:Create(knob, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0, 2, 0.5, -8) }):Play()
            TweenService:Create(halo, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
        end
    end
    updateVisual()

    row.MouseButton1Click:Connect(function()
        state = not state
        self:_play(state and "ToggleOn" or "ToggleOff")
        updateVisual()
        self:SetFlag(flag, state)
        if config.Callback then config.Callback(state) end
    end)

    -- AutoExecute
    if config.AutoExecute and state and config.Callback then
        task.defer(function() config.Callback(true) end)
    elseif flag and self.Flags[flag] ~= nil and config.Callback then
        task.defer(function() config.Callback(state) end)
    end

    local obj = {
        Instance = row,
        Get = function() return state end,
        Set = function(v)
            state = v and true or false
            updateVisual()
            self:SetFlag(flag, state)
            if config.Callback then config.Callback(state) end
        end,
        UpdateTheme = updateVisual,
    }
    local hk = self:_attachHotkey(row, config.Hotkey, -60, function()
        obj.Set(not state)
        self:_play(state and "ToggleOn" or "ToggleOff")
    end, config.Name, function() return state end)
    obj.SetHotkey = hk.Set
    obj.GetHotkey = hk.Get
    table.insert(self.Elements, { Type = "Toggle", Instance = row, UpdateTheme = updateVisual })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

function Library:_addSlider(tab, config)
    local self = self
    local min = config.Min or 0
    local max = config.Max or 100
    local increment = config.Increment or 1
    if increment <= 0 then increment = 1 end
    local suffix = config.Suffix or ""
    local flag = config.Flag
    local decimals = decimalsOf(increment)
    local fmt = "%." .. decimals .. "f"
    local value
    if flag and type(self.Flags[flag]) == "number" then value = self.Flags[flag]
    else value = config.CurrentValue or min end

    local row = Instance.new("Frame")
    row.BackgroundColor3 = BG_ITEM
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, 44)
    row.LayoutOrder = config.Order or 0
    row.ZIndex = 4
    row.Parent = tab.Content
    createCorner(row, 10)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -90, 0, 22)
    label.Font = Enum.Font.GothamMedium
    label.Text = config.Name or "Slider"
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = row

    -- Значение — это поле ввода: нажми на число и впиши точное (NumberInput = false отключает)
    local valueLabel = Instance.new("TextBox")
    valueLabel.BackgroundTransparency = 1
    valueLabel.BorderSizePixel = 0
    valueLabel.ClearTextOnFocus = false
    valueLabel.TextEditable = config.NumberInput ~= false
    valueLabel.Position = UDim2.new(1, -80, 0, 0)
    valueLabel.Size = UDim2.new(0, 68, 0, 22)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = string.format(fmt, value) .. suffix
    valueLabel.TextColor3 = self:_theme().Accent
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 5
    valueLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.new(0, 12, 0, 30)
    track.BackgroundColor3 = TRACK
    track.BorderSizePixel = 0
    track.ZIndex = 5
    track.Parent = row
    createCorner(track, 999)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = self:_theme().Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 6
    fill.Parent = track
    createCorner(fill, 999)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 7
    knob.Parent = track
    createCorner(knob, 999)

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 225))
    fillGrad.Rotation = 90
    fillGrad.Parent = fill

    local halo = Instance.new("Frame")
    halo.AnchorPoint = Vector2.new(0.5, 0.5)
    halo.Position = UDim2.new(0, 0, 0.5, 0)
    halo.Size = UDim2.new(0, 22, 0, 22)
    halo.BackgroundColor3 = self:_theme().Accent
    halo.BackgroundTransparency = 0.8
    halo.BorderSizePixel = 0
    halo.ZIndex = 6
    halo.Parent = track
    createCorner(halo, 999)

    local function updateVisual()
        local theme = self:_theme()
        local alpha = (max - min > 0) and math.clamp((value - min) / (max - min), 0, 1) or 0
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        fill.BackgroundColor3 = theme.Accent
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        halo.Position = UDim2.new(alpha, 0, 0.5, 0)
        halo.BackgroundColor3 = theme.Accent
        if not valueLabel:IsFocused() then valueLabel.Text = string.format(fmt, value) .. suffix end
        valueLabel.TextColor3 = theme.Accent
    end
    updateVisual()

    local function swell(on)
        TweenService:Create(halo, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = on and UDim2.new(0, 32, 0, 32) or UDim2.new(0, 22, 0, 22),
            BackgroundTransparency = on and 0.6 or 0.8,
        }):Play()
    end

    valueLabel.Focused:Connect(function()
        valueLabel.Text = string.format(fmt, value)
        valueLabel.TextColor3 = TEXT_COLOR
    end)
    valueLabel.FocusLost:Connect(function()
        local n = tonumber((valueLabel.Text:gsub(",", ".")))
        valueLabel.TextColor3 = self:_theme().Accent
        if n then
            local raw = math.floor(n / increment + 0.5) * increment
            value = math.clamp(tonumber(string.format("%.8f", raw)), min, max)
            self:SetFlag(flag, value)
            if config.Callback then config.Callback(value) end
        end
        updateVisual()
    end)

    local dragging = false
    local function handleInput(input)
        local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = math.floor((min + alpha * (max - min)) / increment + 0.5) * increment
        -- убираем артефакты float (0.30000000000000004) и держим значение в диапазоне
        value = math.clamp(tonumber(string.format("%.8f", raw)), min, max)
        updateVisual()
        self:SetFlag(flag, value)
        if config.Callback then config.Callback(value) end
    end

    -- Невидимая зона касания пошире самой дорожки: на телефоне в 6 px не попасть
    local hit = Instance.new("Frame")
    hit.BackgroundTransparency = 1
    hit.BorderSizePixel = 0
    hit.Position = UDim2.new(0, 6, 0, 18)
    hit.Size = UDim2.new(1, -12, 0, 26)
    hit.ZIndex = 8
    hit.Parent = row
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            lockScroll(row, true)
            swell(true)
            handleInput(input)
        end
    end)
    self:_track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            handleInput(input)
        end
    end))
    self:_track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then swell(false); lockScroll(row, false) end
            dragging = false
        end
    end))

    if flag and self.Flags[flag] ~= nil and config.Callback then
        task.defer(function() config.Callback(value) end)
    end

    -- Плавное "докручивание" числа при программной установке значения
    -- (перетаскивание мышкой остаётся мгновенным — см. handleInput выше)
    local animToken = 0
    local obj = {
        Instance = row,
        Get = function() return value end,
        Set = function(v)
            local target = math.clamp(v, min, max)
            animToken = animToken + 1
            local myToken = animToken
            local proxy = Instance.new("NumberValue")
            proxy.Value = value
            local conn
            conn = proxy:GetPropertyChangedSignal("Value"):Connect(function()
                if myToken ~= animToken then return end
                value = proxy.Value
                updateVisual()
            end)
            local tw = TweenService:Create(proxy, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Value = target })
            tw:Play()
            tw.Completed:Connect(function()
                conn:Disconnect()
                proxy:Destroy()
                if myToken ~= animToken then return end
                value = target
                updateVisual()
            end)
            self:SetFlag(flag, target)
            if config.Callback then config.Callback(target) end
        end,
        UpdateTheme = updateVisual,
    }
    table.insert(self.Elements, { Type = "Slider", Instance = row, UpdateTheme = updateVisual })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

-- Общее всплывающее окно списка: прокручиваемый список + поле поиска для длинных списков
local function makeListPopup(self, tab, config)
    local popup = { open = false, searchOn = false, itemH = self._mobile and 38 or 32 }
    popup.maxRows = config.MaxVisible or (self._mobile and 5 or 6)

    local holder = Instance.new("Frame")
    holder.BackgroundColor3 = BG_PANEL
    holder.BorderSizePixel = 0
    holder.Size = UDim2.new(1, 0, 0, 0)
    holder.ClipsDescendants = true
    holder.Visible = false
    holder.LayoutOrder = (config.Order or 0) + 0.5
    holder.ZIndex = 4
    holder.Parent = tab.Content
    createCorner(holder, 10)

    local holderLayout = Instance.new("UIListLayout")
    holderLayout.Padding = UDim.new(0, 4)
    holderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    holderLayout.Parent = holder

    local holderPad = Instance.new("UIPadding")
    holderPad.PaddingTop = UDim.new(0, 8)
    holderPad.PaddingBottom = UDim.new(0, 8)
    holderPad.PaddingLeft = UDim.new(0, 8)
    holderPad.PaddingRight = UDim.new(0, 8)
    holderPad.Parent = holder

    local search = Instance.new("TextBox")
    search.LayoutOrder = 0
    search.Size = UDim2.new(1, 0, 0, 28)
    search.BackgroundColor3 = INPUT
    search.BorderSizePixel = 0
    search.Font = Enum.Font.Gotham
    search.PlaceholderText = self:_t("search_list")
    search.PlaceholderColor3 = SUBTEXT
    search.Text = ""
    search.TextColor3 = TEXT_COLOR
    search.TextSize = 12
    search.TextXAlignment = Enum.TextXAlignment.Left
    search.ClearTextOnFocus = false
    search.Visible = false
    search.ZIndex = 5
    search.Parent = holder
    createCorner(search, 8)
    local searchPad = Instance.new("UIPadding")
    searchPad.PaddingLeft = UDim.new(0, 8)
    searchPad.Parent = search

    local list = Instance.new("ScrollingFrame")
    list.LayoutOrder = 1
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.Size = UDim2.new(1, 0, 0, 0)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.ScrollBarThickness = 3
    list.ScrollBarImageColor3 = self:_theme().Accent
    list.ZIndex = 4
    list.Parent = holder
    table.insert(self._scrollBars, list)

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = list
    local listPad = Instance.new("UIPadding")
    listPad.PaddingRight = UDim.new(0, 6)
    listPad.Parent = list

    popup.holder, popup.list, popup.search = holder, list, search
    popup.count = function() return 0 end -- переопределяет вызывающий: сколько пунктов видно

    function popup.height()
        local rows = math.min(math.max(popup.count(), 1), popup.maxRows)
        local listH = rows * popup.itemH + (rows - 1) * 4
        local h = 16 + listH
        if popup.searchOn then h = h + 28 + 4 end
        return h, listH
    end
    function popup.refresh()
        local h, listH = popup.height()
        list.Size = UDim2.new(1, 0, 0, listH)
        if popup.open then
            TweenService:Create(holder, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, h),
            }):Play()
        end
    end
    function popup.setOpen(v)
        popup.open = v
        if v then
            holder.Visible = true
            local h, listH = popup.height()
            list.Size = UDim2.new(1, 0, 0, listH)
            TweenService:Create(holder, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, h),
            }):Play()
        else
            if search.Text ~= "" then search.Text = "" end
            local tw = TweenService:Create(holder, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(1, 0, 0, 0),
            })
            tw:Play()
            tw.Completed:Connect(function() if not popup.open then holder.Visible = false end end)
        end
    end
    function popup.setSearch(on)
        popup.searchOn = on and true or false
        search.Visible = popup.searchOn
        if not popup.searchOn and search.Text ~= "" then search.Text = "" end
        popup.refresh()
    end
    search:GetPropertyChangedSignal("Text"):Connect(function()
        if popup.onFilter then popup.onFilter(lowerText(search.Text)) end
    end)
    return popup
end

function Library:_addDropdown(tab, config)
    local self = self
    local flag = config.Flag
    local options = config.Options or {}
    local current
    if flag and self.Flags[flag] ~= nil then current = self.Flags[flag]
    else current = config.CurrentOption or options[1] end

    local open = false
    local row = makeRowBase(tab.Content, config.Order, 40)
    row.Text = "   " .. (config.Name or "Dropdown")
    addHover(row, self)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -220, 0, 0)
    valueLabel.Size = UDim2.new(0, 180, 1, 0)
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.Text = tostring(current)
    valueLabel.TextColor3 = SUBTEXT
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 4
    valueLabel.Parent = row

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = SUBTEXT
    arrow.TextSize = 10
    arrow.ZIndex = 4
    arrow.Parent = row

    local popup = makeListPopup(self, tab, config)
    local optionButtons = {}
    popup.count = function()
        local n = 0
        for _, d in ipairs(optionButtons) do
            if d.Btn.Visible then n = n + 1 end
        end
        return n
    end
    popup.onFilter = function(q)
        for _, d in ipairs(optionButtons) do
            d.Btn.Visible = (q == "") or (lowerText(tostring(d.Name)):find(q, 1, true) ~= nil)
        end
        popup.list.CanvasPosition = Vector2.new(0, 0)
        popup.refresh()
    end

    local function updateOptionVisuals()
        local theme = self:_theme()
        for _, data in ipairs(optionButtons) do
            local isSelected = (data.Name == current)
            TweenService:Create(data.Btn, TweenInfo.new(0.12), {
                BackgroundColor3 = isSelected and theme.Accent or BG_ITEM,
                TextColor3 = isSelected and Color3.fromRGB(255,255,255) or TEXT_COLOR,
            }):Play()
        end
        valueLabel.Text = tostring(current)
    end

    local function setOpen(v)
        open = v
        popup.setOpen(v)
        TweenService:Create(arrow, TweenInfo.new(0.2), { Rotation = v and 180 or 0 }):Play()
    end

    local function buildOptions(newOptions)
        options = newOptions
        for _, data in ipairs(optionButtons) do data.Btn:Destroy() end
        optionButtons = {}
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, popup.itemH)
            optBtn.BackgroundColor3 = BG_ITEM
            optBtn.AutoButtonColor = false
            optBtn.BorderSizePixel = 0
            optBtn.Font = Enum.Font.GothamMedium
            optBtn.Text = "   " .. tostring(opt)
            optBtn.TextColor3 = TEXT_COLOR
            optBtn.TextSize = 12
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.LayoutOrder = i
            optBtn.ZIndex = 5
            optBtn.Parent = popup.list
            createCorner(optBtn, 8)

            optBtn.MouseButton1Click:Connect(function()
                self:_play("Click")
                current = opt
                updateOptionVisuals()
                setOpen(false)
                self:SetFlag(flag, current)
                if config.Callback then config.Callback(current) end
            end)

            table.insert(optionButtons, { Name = opt, Btn = optBtn })
        end
        if current == nil or not table.find(options, current) then
            current = options[1]
        end
        -- длинные списки (больше 7 пунктов) получают поиск; Search = true/false задаёт вручную
        local want = config.Search
        if want == nil then want = #options > 7 end
        popup.setSearch(want)
        updateOptionVisuals()
        popup.refresh()
    end
    buildOptions(options)

    row.MouseButton1Click:Connect(function() setOpen(not open) end)

    if flag and self.Flags[flag] ~= nil and config.Callback then
        task.defer(function() config.Callback(current) end)
    end

    local obj = {
        Instance = row,
        Get = function() return current end,
        Set = function(v)
            current = v
            updateOptionVisuals()
            self:SetFlag(flag, current)
            if config.Callback then config.Callback(current) end
        end,
        SetOptions = function(newOptions) buildOptions(newOptions) end,
        UpdateTheme = updateOptionVisuals,
    }
    local hk = self:_attachHotkey(row, config.Hotkey, -226, function()
        if #options == 0 then return end
        local idx = table.find(options, current) or 0
        obj.Set(options[idx % #options + 1])
        self:_play("Click")
    end, config.Name)
    obj.SetHotkey = hk.Set
    obj.GetHotkey = hk.Get
    table.insert(self.Elements, { Type = "Dropdown", Instance = row, UpdateTheme = updateOptionVisuals })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

function Library:_addMultiDropdown(tab, config)
    local self = self
    local flag = config.Flag
    local options = config.Options or {}
    local selected = {}
    if flag and type(self.Flags[flag]) == "table" then
        for _, v in ipairs(self.Flags[flag]) do selected[v] = true end
    elseif config.Default then
        for _, v in ipairs(config.Default) do selected[v] = true end
    end

    local open = false
    local row = makeRowBase(tab.Content, config.Order, 40)
    row.Text = "   " .. (config.Name or "MultiDropdown")
    addHover(row, self)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -220, 0, 0)
    valueLabel.Size = UDim2.new(0, 180, 1, 0)
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.Text = ""
    valueLabel.TextColor3 = SUBTEXT
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
    valueLabel.ZIndex = 4
    valueLabel.Parent = row

    local popup = makeListPopup(self, tab, config)
    local optionButtons = {}
    popup.count = function()
        local n = 0
        for _, d in ipairs(optionButtons) do
            if d.Btn.Visible then n = n + 1 end
        end
        return n
    end
    popup.onFilter = function(q)
        for _, d in ipairs(optionButtons) do
            d.Btn.Visible = (q == "") or (lowerText(tostring(d.Name)):find(q, 1, true) ~= nil)
        end
        popup.list.CanvasPosition = Vector2.new(0, 0)
        popup.refresh()
    end

    local function getList()
        local t = {}
        for _, o in ipairs(options) do if selected[o] then table.insert(t, o) end end
        return t
    end

    local function update()
        local theme = self:_theme()
        local list = getList()
        if #list == 0 then valueLabel.Text = "(–)"
        else valueLabel.Text = table.concat(list, ", ") end
        for _, data in ipairs(optionButtons) do
            local isOn = selected[data.Name]
            TweenService:Create(data.Btn, TweenInfo.new(0.12), {
                BackgroundColor3 = isOn and theme.Accent or BG_ITEM,
                TextColor3 = isOn and Color3.fromRGB(255,255,255) or TEXT_COLOR,
            }):Play()
        end
    end

    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, popup.itemH)
        optBtn.BackgroundColor3 = BG_ITEM
        optBtn.AutoButtonColor = false
        optBtn.BorderSizePixel = 0
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.Text = "   " .. tostring(opt)
        optBtn.TextColor3 = TEXT_COLOR
        optBtn.TextSize = 12
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.LayoutOrder = i
        optBtn.ZIndex = 5
        optBtn.Parent = popup.list
        createCorner(optBtn, 8)

        optBtn.MouseButton1Click:Connect(function()
            self:_play("Click")
            selected[opt] = not selected[opt] or nil
            update()
            self:SetFlag(flag, getList())
            if config.Callback then config.Callback(getList()) end
        end)

        table.insert(optionButtons, { Name = opt, Btn = optBtn })
    end
    local want = config.Search
    if want == nil then want = #options > 7 end
    popup.setSearch(want)
    update()

    row.MouseButton1Click:Connect(function()
        open = not open
        popup.setOpen(open)
    end)

    if flag and self.Flags[flag] ~= nil and config.Callback then
        task.defer(function() config.Callback(getList()) end)
    end

    local obj = {
        Instance = row,
        Get = function() return getList() end,
        Set = function(list)
            selected = {}
            for _, v in ipairs(list) do selected[v] = true end
            update()
            self:SetFlag(flag, getList())
            if config.Callback then config.Callback(getList()) end
        end,
        UpdateTheme = update,
    }
    table.insert(self.Elements, { Type = "MultiDropdown", Instance = row, UpdateTheme = update })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

function Library:_addInput(tab, config)
    local self = self
    local flag = config.Flag
    local initial
    if flag and type(self.Flags[flag]) == "string" then initial = self.Flags[flag]
    else initial = config.CurrentValue or "" end -- Placeholder не должен становиться настоящим текстом

    local row = makeRowBase(tab.Content, config.Order, 40)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0, 130, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = config.Name or "Input"
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = row

    local box = Instance.new("TextBox")
    box.BackgroundColor3 = INPUT
    box.BorderSizePixel = 0
    box.Position = UDim2.new(1, -240, 0.5, -13)
    box.Size = UDim2.new(0, 228, 0, 26)
    box.Font = Enum.Font.Gotham
    box.PlaceholderText = config.Placeholder or "введи..."
    box.Text = initial
    box.TextColor3 = TEXT_COLOR
    box.PlaceholderColor3 = SUBTEXT
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.ZIndex = 4
    box.Parent = row
    createCorner(box, 8)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.Parent = box

    box.FocusLost:Connect(function()
        self:SetFlag(flag, box.Text)
        if config.Callback then config.Callback(box.Text) end
    end)

    local obj = {
        Instance = row,
        Get = function() return box.Text end,
        Set = function(v) box.Text = tostring(v) end,
    }
    table.insert(self.Elements, { Type = "Input", Instance = row })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

function Library:_addTextBox(tab, config)
    local self = self
    local flag = config.Flag
    local lines = config.Lines or 5
    local initial
    if flag and type(self.Flags[flag]) == "string" then initial = self.Flags[flag]
    else initial = config.CurrentValue or "" end

    local wrap = Instance.new("Frame")
    wrap.BackgroundColor3 = BG_ITEM
    wrap.BorderSizePixel = 0
    wrap.Size = UDim2.new(1, 0, 0, 26 + lines * 18 + 12)
    wrap.LayoutOrder = config.Order or 0
    wrap.ZIndex = 4
    wrap.Parent = tab.Content
    createCorner(wrap, 10)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 4)
    label.Size = UDim2.new(1, -24, 0, 20)
    label.Font = Enum.Font.GothamMedium
    label.Text = config.Name or "TextBox"
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = wrap

    local box = Instance.new("TextBox")
    box.BackgroundColor3 = INPUT
    box.BorderSizePixel = 0
    box.Position = UDim2.new(0, 12, 0, 26)
    box.Size = UDim2.new(1, -24, 0, lines * 18)
    box.Font = Enum.Font.Gotham
    box.PlaceholderText = config.Placeholder or ""
    box.Text = initial
    box.TextColor3 = TEXT_COLOR
    box.PlaceholderColor3 = SUBTEXT
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.TextWrapped = true
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    box.MultiLine = true
    box.ZIndex = 5
    box.Parent = wrap
    createCorner(box, 6)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 4)
    pad.Parent = box

    box.FocusLost:Connect(function()
        self:SetFlag(flag, box.Text)
        if config.Callback then config.Callback(box.Text) end
    end)

    local obj = {
        Instance = wrap,
        Get = function() return box.Text end,
        Set = function(v) box.Text = tostring(v) end,
    }
    table.insert(self.Elements, { Type = "TextBox", Instance = wrap })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

function Library:_addLabel(tab, config)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 22)
    label.LayoutOrder = config.Order or 0
    label.Font = Enum.Font.Gotham
    label.Text = config.Text or "Label"
    label.TextColor3 = SUBTEXT
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.ZIndex = 4
    label.Parent = tab.Content
    return label
end

function Library:_addDivider(tab, config)
    local wrap = Instance.new("Frame")
    wrap.BackgroundTransparency = 1
    wrap.Size = UDim2.new(1, 0, 0, 9)
    wrap.LayoutOrder = (config and config.Order) or 0
    wrap.ZIndex = 4
    wrap.Parent = tab.Content

    local divider = Instance.new("Frame")
    divider.BackgroundColor3 = LINE
    divider.BackgroundTransparency = 0.9
    divider.BorderSizePixel = 0
    divider.AnchorPoint = Vector2.new(0.5, 0.5)
    divider.Position = UDim2.new(0.5, 0, 0.5, 0)
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.ZIndex = 4
    divider.Parent = wrap

    return wrap
end

function Library:_addDividerText(tab, config)
    local wrap = Instance.new("Frame")
    wrap.BackgroundTransparency = 1
    wrap.Size = UDim2.new(1, 0, 0, 20)
    wrap.LayoutOrder = config.Order or 0
    wrap.ZIndex = 4
    wrap.Parent = tab.Content

    local left = Instance.new("Frame")
    left.BackgroundColor3 = LINE
    left.BackgroundTransparency = 0.9
    left.BorderSizePixel = 0
    left.Position = UDim2.new(0, 0, 0.5, 0)
    left.Size = UDim2.new(0.4, 0, 0, 1)
    left.ZIndex = 4
    left.Parent = wrap

    local right = Instance.new("Frame")
    right.BackgroundColor3 = LINE
    right.BackgroundTransparency = 0.9
    right.BorderSizePixel = 0
    right.Position = UDim2.new(0.6, 0, 0.5, 0)
    right.Size = UDim2.new(0.4, 0, 0, 1)
    right.ZIndex = 4
    right.Parent = wrap

    local text = Instance.new("TextLabel")
    text.BackgroundTransparency = 1
    text.Position = UDim2.new(0.4, 0, 0, 0)
    text.Size = UDim2.new(0.2, 0, 1, 0)
    text.Font = Enum.Font.GothamBold
    text.Text = config.Text or ""
    text.TextColor3 = SUBTEXT
    text.TextSize = 11
    text.ZIndex = 5
    text.Parent = wrap

    return wrap
end

function Library:_addSection(tab, config)
    local wrap = Instance.new("Frame")
    wrap.BackgroundTransparency = 1
    wrap.Size = UDim2.new(1, 0, 0, 26)
    wrap.LayoutOrder = config.Order or 0
    wrap.ZIndex = 4
    wrap.Parent = tab.Content

    local dot = Instance.new("Frame")
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.Position = UDim2.new(0, 0, 0.5, -2)
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.BackgroundColor3 = self:_theme().Accent
    dot.BorderSizePixel = 0
    dot.ZIndex = 4
    dot.Parent = wrap
    createCorner(dot, 999)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -14, 1, -2)
    label.Font = Enum.Font.GothamBold
    label.Text = upperText(config.Text or "Section")
    label.TextColor3 = SUBTEXT
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = wrap

    local line = Instance.new("Frame")
    line.BackgroundColor3 = self:_theme().Accent
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 0, 1, -1)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.ZIndex = 4
    line.Parent = wrap
    local lineGrad = Instance.new("UIGradient")
    lineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    lineGrad.Parent = line

    self._sections[wrap] = true
    local function updateTheme()
        local theme = self:_theme()
        dot.BackgroundColor3 = theme.Accent
        line.BackgroundColor3 = theme.Accent
    end
    table.insert(self.Elements, { Type = "Section", Instance = wrap, UpdateTheme = updateTheme })

    return wrap
end

function Library:_addKeybind(tab, config)
    local self = self
    local flag = config.Flag

    local function decodeKey(v)
        if typeof(v) == "EnumItem" then return v end
        if type(v) == "string" and v ~= "" and v ~= "null" then
            local ok, kc = pcall(function() return Enum.KeyCode[v] end)
            if ok and kc then return kc end
        end
        return nil
    end

    local current
    if flag and self.Flags[flag] ~= nil then current = decodeKey(self.Flags[flag]) end
    if not current then current = config.CurrentKeybind or Enum.KeyCode.RightShift end

    -- Mode = "Toggle" | "Hold" | "Always" превращает кейбинд в рабочий переключатель:
    -- состояние приходит в config.Changed(active), режим меняется нажатием на плашку режима.
    -- Без Mode — просто выбор клавиши (Callback(key)), как раньше.
    local MODES = { "Toggle", "Hold", "Always" }
    local functional = config.Mode ~= nil
    local mode = (config.Mode and table.find(MODES, config.Mode)) and config.Mode or "Toggle"
    if functional and flag then
        local savedMode = self.Flags[flag .. "_mode"]
        if type(savedMode) == "string" and table.find(MODES, savedMode) then mode = savedMode end
    end
    local active = false
    local justBound = 0

    local listening = false
    local row = makeRowBase(tab.Content, config.Order, 40)
    row.Text = "   " .. (config.Name or "Keybind")
    addHover(row, self)

    local keyBadge = Instance.new("TextButton")
    keyBadge.Size = UDim2.new(0, 84, 0, 26)
    keyBadge.Position = UDim2.new(1, -94, 0.5, -13)
    keyBadge.BackgroundColor3 = BG_HOVER
    keyBadge.AutoButtonColor = false
    keyBadge.Font = Enum.Font.GothamBold
    keyBadge.Text = current and current.Name or "None"
    keyBadge.TextColor3 = TEXT_COLOR
    keyBadge.TextSize = 12
    keyBadge.ZIndex = 5
    keyBadge.Parent = row
    createCorner(keyBadge, 8)

    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    badgeStroke.Color = self:_theme().Accent
    badgeStroke.Transparency = 1
    badgeStroke.Thickness = 1.5
    badgeStroke.Parent = keyBadge

    local modeChip
    if functional then
        modeChip = Instance.new("TextButton")
        modeChip.Size = UDim2.new(0, 66, 0, 22)
        modeChip.Position = UDim2.new(1, -168, 0.5, -11)
        modeChip.BackgroundColor3 = INPUT
        modeChip.AutoButtonColor = false
        modeChip.Font = Enum.Font.GothamBold
        modeChip.TextSize = 10
        modeChip.TextColor3 = SUBTEXT
        modeChip.ZIndex = 5
        modeChip.Parent = row
        createCorner(modeChip, 6)
    end

    local listenConn

    local function refreshChip()
        if not modeChip then return end
        modeChip.Text = self:_t("mode_" .. mode:lower())
        modeChip.TextColor3 = active and self:_theme().Accent or SUBTEXT
    end

    local function refresh()
        keyBadge.Text = listening and "..." or (current and current.Name or "None")
        badgeStroke.Color = self:_theme().Accent
        badgeStroke.Transparency = listening and 0.2 or 1
        refreshChip()
    end

    local function setActive(v)
        v = v and true or false
        if v == active then return end
        active = v
        refreshChip()
        if config.Changed then config.Changed(active) end
    end

    local function stopListen()
        listening = false
        if listenConn then
            listenConn:Disconnect()
            self:_untrack(listenConn)
            listenConn = nil
        end
        refresh()
    end

    local function startListen()
        if listening then stopListen() return end
        listening = true
        refresh()
        listenConn = self:_track(UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if input.KeyCode == Enum.KeyCode.Escape then stopListen() return end
            current = input.KeyCode
            justBound = os.clock() -- нажатие, которым назначили клавишу, не должно сработать как действие
            stopListen()
            self:SetFlag(flag, current.Name)
            if config.Callback then config.Callback(current) end
        end))
    end

    keyBadge.MouseButton1Click:Connect(startListen)

    if functional then
        modeChip.MouseButton1Click:Connect(function()
            self:_play("Click")
            local idx = table.find(MODES, mode) or 1
            mode = MODES[idx % #MODES + 1]
            setActive(mode == "Always")
            if flag then self:SetFlag(flag .. "_mode", mode) end
            refreshChip()
        end)
        if mode == "Always" then task.defer(function() setActive(true) end) end

        self:_track(UserInputService.InputBegan:Connect(function(input, gp)
            if gp or listening or not current then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard or input.KeyCode ~= current then return end
            if os.clock() - justBound < 0.2 or self._locked[row] then return end
            if mode == "Toggle" then setActive(not active)
            elseif mode == "Hold" then setActive(true) end
        end))
        self:_track(UserInputService.InputEnded:Connect(function(input)
            if mode == "Hold" and current and input.UserInputType == Enum.UserInputType.Keyboard
                and input.KeyCode == current then
                setActive(false)
            end
        end))

        table.insert(self._bindInfo, {
            name = config.Name or "Keybind",
            getKey = function() return current end,
            getState = function() return active end,
        })
    end
    refresh()

    local obj = {
        Instance = row,
        Get = function() return current end,
        Set = function(kc)
            current = decodeKey(kc) or kc
            refresh()
            self:SetFlag(flag, current and current.Name or nil)
            if config.Callback then config.Callback(current) end
        end,
        GetState = function() return active end,
        GetMode = function() return mode end,
        SetMode = function(m)
            if not table.find(MODES, m) then return end
            mode = m
            setActive(mode == "Always")
            if flag then self:SetFlag(flag .. "_mode", mode) end
            refreshChip()
        end,
        UpdateTheme = refresh,
    }
    table.insert(self.Elements, { Type = "Keybind", Instance = row, UpdateTheme = refresh })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

function Library:_addParagraph(tab, config)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = BG_ITEM
    card.BorderSizePixel = 0
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.Size = UDim2.new(1, 0, 0, 0)
    card.LayoutOrder = config.Order or 0
    card.ZIndex = 4
    card.Parent = tab.Content
    createCorner(card, 10)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = card

    local innerLayout = Instance.new("UIListLayout")
    innerLayout.Padding = UDim.new(0, 4)
    innerLayout.Parent = card

    if config.Title then
        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.AutomaticSize = Enum.AutomaticSize.Y
        title.Size = UDim2.new(1, 0, 0, 0)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Title
        title.TextColor3 = TEXT_COLOR
        title.TextSize = 13
        title.TextWrapped = true
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.LayoutOrder = 1
        title.ZIndex = 5
        title.Parent = card
    end

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Size = UDim2.new(1, 0, 0, 0)
    body.Font = Enum.Font.Gotham
    body.Text = config.Content or config.Text or ""
    body.TextColor3 = SUBTEXT
    body.TextSize = 12
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.LayoutOrder = 2
    body.ZIndex = 5
    body.Parent = card

    return card
end

function Library:_addProgressBar(tab, config)
    local self = self
    local min = config.Min or 0
    local max = config.Max or 100
    local value = config.CurrentValue or min

    -- доля 0..1; при Max == Min (или Max < Min) деления на ноль нет
    local function fraction(v)
        local span = max - min
        if span <= 0 then return 0 end
        return math.clamp((v - min) / span, 0, 1)
    end

    local row = Instance.new("Frame")
    row.BackgroundColor3 = BG_ITEM
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, 44)
    row.LayoutOrder = config.Order or 0
    row.ZIndex = 4
    row.Parent = tab.Content
    createCorner(row, 10)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -90, 0, 22)
    label.Font = Enum.Font.GothamMedium
    label.Text = config.Name or "Progress"
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -80, 0, 0)
    valueLabel.Size = UDim2.new(0, 68, 0, 22)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = string.format("%d%%", math.floor(fraction(value) * 100))
    valueLabel.TextColor3 = self:_theme().Accent
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 5
    valueLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 8)
    track.Position = UDim2.new(0, 12, 0, 28)
    track.BackgroundColor3 = TRACK
    track.BorderSizePixel = 0
    track.ZIndex = 5
    track.Parent = row
    createCorner(track, 999)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = self:_theme().Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 6
    fill.Parent = track
    createCorner(fill, 999)

    local function update()
        local theme = self:_theme()
        local alpha = fraction(value)
        TweenService:Create(fill, TweenInfo.new(0.25), { Size = UDim2.new(alpha, 0, 1, 0) }):Play()
        fill.BackgroundColor3 = theme.Accent
        valueLabel.Text = string.format("%d%%", math.floor(alpha * 100))
        valueLabel.TextColor3 = theme.Accent
    end
    update()

    local animToken = 0
    local obj = {
        Instance = row,
        Get = function() return value end,
        Set = function(v)
            local target = math.clamp(v, min, math.max(min, max))
            animToken = animToken + 1
            local myToken = animToken
            local proxy = Instance.new("NumberValue")
            proxy.Value = value
            local conn
            conn = proxy:GetPropertyChangedSignal("Value"):Connect(function()
                if myToken ~= animToken then return end
                value = proxy.Value
                update()
            end)
            local tw = TweenService:Create(proxy, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Value = target })
            tw:Play()
            tw.Completed:Connect(function()
                conn:Disconnect()
                proxy:Destroy()
                if myToken ~= animToken then return end
                value = target
                update()
            end)
        end,
        UpdateTheme = update,
    }
    table.insert(self.Elements, { Type = "ProgressBar", Instance = row, UpdateTheme = update })
    return obj
end

function Library:_addStepper(tab, config)
    local self = self
    local min = config.Min or 0
    local max = config.Max or 10
    local step = config.Increment or 1
    local flag = config.Flag
    local value
    if flag and type(self.Flags[flag]) == "number" then value = self.Flags[flag]
    else value = config.CurrentValue or min end

    local row = makeRowBase(tab.Content, config.Order, 40)
    addHover(row, self)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -170, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = config.Name or "Stepper"
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = row

    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0, 28, 0, 26)
    minus.Position = UDim2.new(1, -120, 0.5, -13)
    minus.BackgroundColor3 = BG_HOVER
    minus.BorderSizePixel = 0
    minus.Font = Enum.Font.GothamBold
    minus.Text = "➖"
    minus.TextColor3 = TEXT_COLOR
    minus.TextSize = 12
    minus.ZIndex = 5
    minus.Parent = row
    createCorner(minus, 6)

    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Position = UDim2.new(1, -90, 0, 0)
    valLbl.Size = UDim2.new(0, 40, 1, 0)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.Text = tostring(value)
    valLbl.TextColor3 = self:_theme().Accent
    valLbl.TextSize = 13
    valLbl.ZIndex = 5
    valLbl.Parent = row

    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0, 28, 0, 26)
    plus.Position = UDim2.new(1, -46, 0.5, -13)
    plus.BackgroundColor3 = BG_HOVER
    plus.BorderSizePixel = 0
    plus.Font = Enum.Font.GothamBold
    plus.Text = "➕"
    plus.TextColor3 = TEXT_COLOR
    plus.TextSize = 12
    plus.ZIndex = 5
    plus.Parent = row
    createCorner(plus, 6)

    local function update()
        valLbl.Text = tostring(value)
        valLbl.TextColor3 = self:_theme().Accent
    end

    minus.MouseButton1Click:Connect(function()
        self:_play("Click")
        value = math.max(min, value - step)
        update()
        self:SetFlag(flag, value)
        if config.Callback then config.Callback(value) end
    end)
    plus.MouseButton1Click:Connect(function()
        self:_play("Click")
        value = math.min(max, value + step)
        update()
        self:SetFlag(flag, value)
        if config.Callback then config.Callback(value) end
    end)

    if flag and self.Flags[flag] ~= nil and config.Callback then
        task.defer(function() config.Callback(value) end)
    end

    local obj = {
        Instance = row,
        Get = function() return value end,
        Set = function(v)
            value = math.clamp(v, min, max)
            update()
            self:SetFlag(flag, value)
            if config.Callback then config.Callback(value) end
        end,
    }
    table.insert(self.Elements, { Type = "Stepper", Instance = row, UpdateTheme = update })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

function Library:_addRadioGroup(tab, config)
    local self = self
    local flag = config.Flag
    local options = config.Options or {}
    local current
    if flag and self.Flags[flag] ~= nil then current = self.Flags[flag]
    else current = config.CurrentOption or options[1] end

    local wrap = Instance.new("Frame")
    wrap.BackgroundTransparency = 1
    wrap.Size = UDim2.new(1, 0, 0, 60)
    wrap.LayoutOrder = config.Order or 0
    wrap.ZIndex = 4
    wrap.Parent = tab.Content

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -24, 0, 20)
    label.Font = Enum.Font.GothamMedium
    label.Text = config.Name or "RadioGroup"
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = wrap

    local row = Instance.new("Frame")
    row.BackgroundTransparency = 1
    row.Position = UDim2.new(0, 0, 0, 24)
    row.Size = UDim2.new(1, 0, 0, 32)
    row.ZIndex = 5
    row.Parent = wrap

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 6)
    layout.Parent = row

    local buttons = {}

    local function update()
        local theme = self:_theme()
        for _, data in ipairs(buttons) do
            local on = (data.Name == current)
            TweenService:Create(data.Btn, TweenInfo.new(0.15), {
                BackgroundColor3 = on and theme.Accent or BG_ITEM,
                TextColor3 = on and Color3.fromRGB(255,255,255) or TEXT_COLOR,
            }):Play()
        end
    end

    for _, opt in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 1, 0)
        btn.BackgroundColor3 = BG_ITEM
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamMedium
        btn.Text = tostring(opt)
        btn.TextColor3 = TEXT_COLOR
        btn.TextSize = 12
        btn.ZIndex = 5
        btn.Parent = row
        createCorner(btn, 8)

        btn.MouseButton1Click:Connect(function()
            self:_play("Click")
            current = opt
            update()
            self:SetFlag(flag, current)
            if config.Callback then config.Callback(current) end
        end)
        table.insert(buttons, { Name = opt, Btn = btn })
    end
    update()

    if flag and self.Flags[flag] ~= nil and config.Callback then
        task.defer(function() config.Callback(current) end)
    end

    local obj = {
        Instance = wrap,
        Get = function() return current end,
        Set = function(v)
            current = v
            update()
            self:SetFlag(flag, current)
            if config.Callback then config.Callback(current) end
        end,
        UpdateTheme = update,
    }
    table.insert(self.Elements, { Type = "RadioGroup", Instance = wrap, UpdateTheme = update })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

function Library:_addRow(tab, config)
    local row = Instance.new("Frame")
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, 40)
    row.LayoutOrder = config.Order or 0
    row.ZIndex = 4
    row.Parent = tab.Content

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 6)
    layout.Parent = row

    return row
end

----------------------------------------------------------------
-- LOADER (крутящийся спиннер-кольцо, без внешних картинок)
----------------------------------------------------------------
function Library:_addLoader(tab, config)
    local self = self
    local row = Instance.new("Frame")
    row.BackgroundColor3 = BG_ITEM
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, 44)
    row.LayoutOrder = config.Order or 0
    row.ZIndex = 4
    row.Parent = tab.Content
    createCorner(row, 10)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 50, 0, 0)
    label.Size = UDim2.new(1, -62, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = config.Name or self:_t("loading")
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = row

    -- Кольцо: круг + радиальный градиент прозрачности + вырезанная
    -- внутренняя часть = получается дуга, которую мы просто вращаем
    local ring = Instance.new("Frame")
    ring.Size = UDim2.new(0, 22, 0, 22)
    ring.Position = UDim2.new(0, 14, 0.5, -11)
    ring.BackgroundTransparency = 1
    ring.ZIndex = 5
    ring.Parent = row

    local ringVisual = Instance.new("Frame")
    ringVisual.Size = UDim2.new(1, 0, 1, 0)
    ringVisual.BackgroundColor3 = self:_theme().Accent
    ringVisual.BorderSizePixel = 0
    ringVisual.ZIndex = 5
    ringVisual.Parent = ring
    createCorner(ringVisual, 999)

    local ringGrad = Instance.new("UIGradient")
    ringGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.85),
        NumberSequenceKeypoint.new(1, 1),
    })
    ringGrad.Parent = ringVisual

    local ringHole = Instance.new("Frame")
    ringHole.AnchorPoint = Vector2.new(0.5, 0.5)
    ringHole.Position = UDim2.new(0.5, 0, 0.5, 0)
    ringHole.Size = UDim2.new(1, -8, 1, -8)
    ringHole.BackgroundColor3 = BG_ITEM
    ringHole.BorderSizePixel = 0
    ringHole.ZIndex = 6
    ringHole.Parent = ring
    createCorner(ringHole, 999)

    local spinning = (config.Active ~= false)
    task.spawn(function()
        while ring.Parent do
            if spinning then
                ring.Rotation = (ring.Rotation + 6) % 360
            end
            RunService.Heartbeat:Wait()
        end
    end)

    local function updateTheme()
        ringVisual.BackgroundColor3 = self:_theme().Accent
        ringHole.BackgroundColor3 = BG_ITEM
    end

    local obj = {
        Instance = row,
        SetActive = function(active) spinning = active end,
        SetName = function(text) label.Text = text end,
        UpdateTheme = updateTheme,
    }
    table.insert(self.Elements, { Type = "Loader", Instance = row, UpdateTheme = updateTheme })
    return obj
end

function Library:_addColorPicker(tab, config)
    local self = self
    local flag = config.Flag
    local current
    if flag and typeof(self.Flags[flag]) == "Color3" then current = self.Flags[flag]
    else current = config.CurrentValue or self:_theme().Accent end
    local open = false
    local h, s, v = Color3.toHSV(current)

    local row = makeRowBase(tab.Content, config.Order, 40)
    row.Text = "   " .. (config.Name or "Color")
    addHover(row, self)

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 22, 0, 22)
    preview.Position = UDim2.new(1, -32, 0.5, -11)
    preview.BackgroundColor3 = current
    preview.BorderSizePixel = 0
    preview.ZIndex = 5
    preview.Parent = row
    createCorner(preview, 8)

    local holder = Instance.new("Frame")
    holder.BackgroundColor3 = BG_PANEL
    holder.BorderSizePixel = 0
    holder.Size = UDim2.new(1, 0, 0, 0)
    holder.ClipsDescendants = true
    holder.Visible = false
    holder.LayoutOrder = (config.Order or 0) + 0.5
    holder.ZIndex = 4
    holder.Parent = tab.Content
    createCorner(holder, 10)

    local holderPad = Instance.new("UIPadding")
    holderPad.PaddingTop = UDim.new(0, 10)
    holderPad.PaddingBottom = UDim.new(0, 10)
    holderPad.PaddingLeft = UDim.new(0, 10)
    holderPad.PaddingRight = UDim.new(0, 10)
    holderPad.Parent = holder

    local svField = Instance.new("ImageLabel")
    svField.Size = UDim2.new(1, 0, 0, 100)
    svField.BackgroundColor3 = Color3.fromRGB(255,255,255)
    svField.BorderSizePixel = 0
    svField.ZIndex = 5
    svField.Parent = holder
    createCorner(svField, 8)

    local svGrad = Instance.new("UIGradient")
    svGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1)),
    })
    svGrad.Parent = svField

    local svDark = Instance.new("Frame")
    svDark.Size = UDim2.new(1, 0, 1, 0)
    svDark.BackgroundColor3 = Color3.fromRGB(0,0,0)
    svDark.BorderSizePixel = 0
    svDark.ZIndex = 6
    svDark.Parent = svField
    createCorner(svDark, 8)

    local svDarkGrad = Instance.new("UIGradient")
    svDarkGrad.Rotation = 90
    svDarkGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0),
    })
    svDarkGrad.Parent = svDark

    local svMarker = Instance.new("Frame")
    svMarker.Size = UDim2.new(0, 10, 0, 10)
    svMarker.AnchorPoint = Vector2.new(0.5, 0.5)
    svMarker.BackgroundTransparency = 1
    svMarker.ZIndex = 8
    svMarker.Parent = svField

    local svMarkerStroke = Instance.new("UIStroke")
    svMarkerStroke.Thickness = 2
    svMarkerStroke.Color = Color3.fromRGB(255,255,255)
    svMarkerStroke.Parent = svMarker
    createCorner(svMarker, 999)

    local hueBar = Instance.new("ImageLabel")
    hueBar.Size = UDim2.new(1, 0, 0, 12)
    hueBar.Position = UDim2.new(0, 0, 0, 110)
    hueBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    hueBar.BorderSizePixel = 0
    hueBar.ZIndex = 5
    hueBar.Parent = holder
    createCorner(hueBar, 999)

    local hueGrad = Instance.new("UIGradient")
    hueGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,0)),
    })
    hueGrad.Parent = hueBar

    local hueMarker = Instance.new("Frame")
    hueMarker.Size = UDim2.new(0, 12, 0, 12)
    hueMarker.AnchorPoint = Vector2.new(0.5, 0.5)
    hueMarker.BackgroundColor3 = Color3.fromRGB(255,255,255)
    hueMarker.ZIndex = 8
    hueMarker.Parent = hueBar
    createCorner(hueMarker, 999)

    local hueMarkerStroke = Instance.new("UIStroke")
    hueMarkerStroke.Thickness = 2
    hueMarkerStroke.Color = Color3.fromRGB(0,0,0)
    hueMarkerStroke.Transparency = 0.6
    hueMarkerStroke.Parent = hueMarker

    -- alpha slider (опционально)
    local alphaValue = 1
    local alphaBar, alphaFill
    if config.WithAlpha then
        local alphaLabel = Instance.new("TextLabel")
        alphaLabel.BackgroundTransparency = 1
        alphaLabel.Position = UDim2.new(0, 0, 0, 128)
        alphaLabel.Size = UDim2.new(0, 40, 0, 12)
        alphaLabel.Font = Enum.Font.Gotham
        alphaLabel.Text = "Alpha"
        alphaLabel.TextColor3 = SUBTEXT
        alphaLabel.TextSize = 10
        alphaLabel.ZIndex = 5
        alphaLabel.Parent = holder

        alphaBar = Instance.new("Frame")
        alphaBar.Size = UDim2.new(1, -50, 0, 10)
        alphaBar.Position = UDim2.new(0, 50, 0, 128)
        alphaBar.BackgroundColor3 = TRACK
        alphaBar.BorderSizePixel = 0
        alphaBar.ZIndex = 5
        alphaBar.Parent = holder
        createCorner(alphaBar, 999)

        alphaFill = Instance.new("Frame")
        alphaFill.Size = UDim2.new(1, 0, 1, 0)
        alphaFill.BackgroundColor3 = current
        alphaFill.BorderSizePixel = 0
        alphaFill.ZIndex = 6
        alphaFill.Parent = alphaBar
        createCorner(alphaFill, 999)
    end

    local hexBox = Instance.new("TextBox")
    hexBox.Size = UDim2.new(1, 0, 0, 24)
    hexBox.Position = UDim2.new(0, 0, 0, config.WithAlpha and 148 or 130)
    hexBox.BackgroundColor3 = BG_ITEM
    hexBox.BorderSizePixel = 0
    hexBox.Font = Enum.Font.GothamMedium
    hexBox.Text = "#000000"
    hexBox.TextColor3 = TEXT_COLOR
    hexBox.TextSize = 12
    hexBox.ClearTextOnFocus = false
    hexBox.ZIndex = 5
    hexBox.Parent = holder
    createCorner(hexBox, 8)

    local hexPad = Instance.new("UIPadding")
    hexPad.PaddingLeft = UDim.new(0, 8)
    hexPad.Parent = hexBox

    local function toHex(c)
        return string.format("#%02X%02X%02X",
            math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
    end
    local function fromHex(str)
        str = str:gsub("#","")
        if #str ~= 6 then return nil end
        local r = tonumber(str:sub(1,2), 16)
        local g = tonumber(str:sub(3,4), 16)
        local b = tonumber(str:sub(5,6), 16)
        if not (r and g and b) then return nil end
        return Color3.fromRGB(r, g, b)
    end

    local updating = false
    local function refresh()
        updating = true
        svGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1)),
        })
        svMarker.Position = UDim2.new(s, 0, 1 - v, 0)
        hueMarker.Position = UDim2.new(h, 0, 0.5, 0)
        preview.BackgroundColor3 = current
        preview.BackgroundTransparency = config.WithAlpha and (1 - alphaValue) or 0
        hexBox.Text = toHex(current)
        if alphaFill then alphaFill.BackgroundColor3 = current end
        updating = false
    end
    local function apply()
        current = Color3.fromHSV(h, s, v)
        refresh()
        self:SetFlag(flag, current)
        if config.Callback then config.Callback(current, config.WithAlpha and alphaValue or 1) end
    end

    local dsv = false
    local function handleSV(input)
        local pp = pointerPos(input)
        s = math.clamp((pp.X - svField.AbsolutePosition.X) / svField.AbsoluteSize.X, 0, 1)
        v = 1 - math.clamp((pp.Y - svField.AbsolutePosition.Y) / svField.AbsoluteSize.Y, 0, 1)
        apply()
    end
    svField.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dsv = true; lockScroll(holder, true); handleSV(input)
        end
    end)
    self:_track(UserInputService.InputChanged:Connect(function(input)
        if dsv and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleSV(input)
        end
    end))
    self:_track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dsv = false; lockScroll(holder, false) end
    end))

    local dh = false
    local function handleHue(input)
        h = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
        apply()
    end
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dh = true; lockScroll(holder, true); handleHue(input)
        end
    end)
    self:_track(UserInputService.InputChanged:Connect(function(input)
        if dh and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleHue(input)
        end
    end))
    self:_track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dh = false; lockScroll(holder, false) end
    end))

    if alphaBar then
        local da = false
        local function handleAlpha(input)
            alphaValue = math.clamp((input.Position.X - alphaBar.AbsolutePosition.X) / alphaBar.AbsoluteSize.X, 0, 1)
            refresh()
            if config.Callback then config.Callback(current, alphaValue) end
        end
        alphaBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                da = true; lockScroll(holder, true); handleAlpha(input)
            end
        end)
        self:_track(UserInputService.InputChanged:Connect(function(input)
            if da and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                handleAlpha(input)
            end
        end))
        self:_track(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then da = false; lockScroll(holder, false) end
        end))
    end

    hexBox.FocusLost:Connect(function()
        if updating then return end
        local col = fromHex(hexBox.Text)
        if col then h, s, v = Color3.toHSV(col) apply()
        else hexBox.Text = toHex(current) end
    end)

    row.MouseButton1Click:Connect(function()
        open = not open
        if open then
            holder.Visible = true
            local hh = config.WithAlpha and 184 or 174
            TweenService:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, hh),
            }):Play()
            refresh()
        else
            local t = TweenService:Create(holder, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(1, 0, 0, 0),
            })
            t:Play()
            t.Completed:Connect(function() if not open then holder.Visible = false end end)
        end
    end)

    refresh()

    local obj = {
        Instance = row,
        Get = function() return current end,
        Set = function(col)
            h, s, v = Color3.toHSV(col)
            apply()
        end,
        GetAlpha = function() return alphaValue end,
        SetAlpha = function(a)
            alphaValue = math.clamp(a, 0, 1)
            refresh()
        end,
    }
    table.insert(self.Elements, { Type = "ColorPicker", Instance = row })
    if flag then table.insert(self._flagElements, { flag = flag, obj = obj }) end
    return obj
end

-- ============================================================
-- PLAYER LIST
-- ============================================================
function Library:AddPlayerList(tab, config)
    local self = self
    config = config or {}
    tab:CreateSection({ Text = config.Title or self:_t("players") })

    local holder = Instance.new("Frame")
    holder.BackgroundColor3 = BG_ITEM
    holder.BorderSizePixel = 0
    holder.Size = UDim2.new(1, 0, 0, 0)
    holder.AutomaticSize = Enum.AutomaticSize.Y
    holder.ZIndex = 4
    holder.Parent = tab.Content
    createCorner(holder, 10)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = holder

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = holder

    local function refresh()
        if not holder.Parent then return end
        for _, c in ipairs(holder:GetChildren()) do
            if c:IsA("TextButton") and c ~= holder:FindFirstChild("RefreshBtn") then c:Destroy() end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local r = Instance.new("TextButton")
                r.BackgroundColor3 = BG_ITEM
                r.AutoButtonColor = false
                r.BorderSizePixel = 0
                r.Size = UDim2.new(1, 0, 0, 32)
                r.Font = Enum.Font.GothamMedium
                r.Text = "   " .. plr.Name
                r.TextColor3 = TEXT_COLOR
                r.TextSize = 12
                r.TextXAlignment = Enum.TextXAlignment.Left
                r.ZIndex = 5
                r.Parent = holder
                createCorner(r, 8)

                if config.OnPlayer then
                    r.MouseButton1Click:Connect(function() config.OnPlayer(plr) end)
                end
            end
        end
    end

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Name = "RefreshBtn"
    refreshBtn.BackgroundColor3 = self:_theme().Accent
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Size = UDim2.new(1, 0, 0, 32)
    refreshBtn.LayoutOrder = 1000000 -- кнопка «Обновить» всегда внизу списка
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Text = self:_t("refresh")
    refreshBtn.TextColor3 = Color3.fromRGB(255,255,255)
    refreshBtn.TextSize = 12
    refreshBtn.ZIndex = 5
    refreshBtn.Parent = holder
    createCorner(refreshBtn, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    refreshBtn.MouseButton1Click:Connect(refresh)
    table.insert(self.Elements, {
        Type = "PlayerList",
        Instance = holder,
        UpdateTheme = function() refreshBtn.BackgroundColor3 = self:_theme().Accent end,
    })

    refresh()

    self:_track(Players.PlayerAdded:Connect(refresh))
    self:_track(Players.PlayerRemoving:Connect(function() task.wait(0.1) refresh() end))

    return { Refresh = refresh }
end

-- ============================================================
-- THEME
-- ============================================================
-- Перекрашивает все декоративные элементы окна под текущую тему окна
function Library:_applyThemeVisuals()
    local theme = self:_theme()
    local dark = BG_DARK
    -- Середина градиентов: у двухцветных тем — второй цвет (Accent2), у остальных — светлый оттенок
    local mid = theme.Accent2 or theme.AccentLight
    if self.BgGradient then
        self.BgGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, dark:Lerp(theme.Accent, 0.16)),
            ColorSequenceKeypoint.new(0.55, dark),
            ColorSequenceKeypoint.new(1, dark:Lerp(theme.Accent2 or theme.Accent, 0.10)),
        })
    end
    if self.LineGradient then
        self.LineGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Accent),
            ColorSequenceKeypoint.new(0.5, mid),
            ColorSequenceKeypoint.new(1, theme.Accent),
        })
    end
    if self.StrokeGradient then
        self.StrokeGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Accent),
            ColorSequenceKeypoint.new(0.5, mid),
            ColorSequenceKeypoint.new(1, theme.Accent),
        })
    end
    if self.TitleGradient then
        self.TitleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, TITLE),
            ColorSequenceKeypoint.new(0.5, (currentPalette == "light") and (theme.Accent2 or theme.Accent)
                or (theme.Accent2 and theme.Accent2:Lerp(Color3.new(1, 1, 1), 0.35) or theme.AccentLight)),
            ColorSequenceKeypoint.new(1, TITLE),
        })
    end
    if self.TitleText then self.TitleText.TextColor3 = TITLE end
    if self.MinBtn then self.MinBtn.TextColor3 = TITLE end
    if self.CloseBtn then self.CloseBtn.TextColor3 = TITLE end
    if self.AvatarGradient then
        self.AvatarGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Accent),
            ColorSequenceKeypoint.new(0.5, mid),
            ColorSequenceKeypoint.new(1, theme.Accent),
        })
    end
    if self.TitleIcon then self.TitleIcon.TextColor3 = theme.Accent end
    if self._handle then
        self._handle.glow.BackgroundColor3 = theme.Accent
        self._handle.tether.BackgroundColor3 = theme.Accent
    end
    if self.ToggleGlow then
        TweenService:Create(self.ToggleGlow, TweenInfo.new(0.3), { BackgroundColor3 = theme.Accent }):Play()
    end
    if self.ToggleBtnStroke then
        TweenService:Create(self.ToggleBtnStroke, TweenInfo.new(0.3), { Color = theme.Accent }):Play()
    end
    for i, p in ipairs(self._particles or {}) do
        p.frame.BackgroundColor3 = (theme.Accent2 and i % 2 == 0) and theme.Accent2 or theme.Accent
    end
    if self.SearchStroke then self.SearchStroke.Color = theme.Accent end
    -- индикаторы и подписи вкладок остаются белыми на акцентном фоне
end

-- Полное обновление цветов окна (темы, акцента): декор + свечение + элементы
function Library:_refreshTheme()
    local theme = self:_theme()

    self:_applyThemeVisuals()
    if self._glowMode == "theme" then
        for _, l in ipairs(self.GlowLayers or {}) do
            TweenService:Create(l.instance, TweenInfo.new(0.3), { BackgroundColor3 = theme.Accent }):Play()
        end
    end
    for _, sb in ipairs(self._scrollBars or {}) do
        TweenService:Create(sb, TweenInfo.new(0.3), { ScrollBarImageColor3 = theme.Accent }):Play()
    end
    for _, el in ipairs(self.Elements) do
        if el.UpdateTheme then el.UpdateTheme() end
    end
    if self.CurrentTab and self.TabButtons[self.CurrentTab] then
        TweenService:Create(self.TabButtons[self.CurrentTab], TweenInfo.new(0.2), { BackgroundColor3 = theme.Accent }):Play()
    end
end

function Library:SetTheme(key)
    if not THEMES[key] then return end
    self._themeKey = key
    self._themeOverride = nil
    self:_refreshTheme()
    self:_persist("_theme_key", key)
    self:_persist("_accent", nil)
end

function Library:GetTheme()
    return self._themeKey
end

-- ============================================================
-- ЭФФЕКТ КЛИКОВ В ИГРЕ (кружки на месте клика, как в монтажах)
-- ============================================================
local CLICK_STYLES = { Rings = true, Pulse = true, Burst = true, Focus = true }

local function getFxColor(fx, theme)
    local c = fx.Color
    if typeof(c) == "Color3" then return c end
    if c == "rainbow" then return Color3.fromHSV((os.clock() * 0.35) % 1, 0.8, 1) end
    return theme.Accent
end

local function newFxCircle(parent, pos, startSize, color, z)
    local f = Instance.new("Frame")
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.new(0, pos.X, 0, pos.Y)
    f.Size = UDim2.new(0, startSize, 0, startSize)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.ZIndex = z or 1
    f.Parent = parent
    createCorner(f, 999)
    return f
end

-- Window:SetClickEffect(true/false) — вкл/выкл
-- Window:SetClickEffect({ Style = "Burst", Color = "rainbow", Size = 100 }) — изменить настройки (вкл/выкл не трогает,
-- чтобы включить сразу, добавь Enabled = true). В CreateWindow({ ClickEffect = {...} }) эффект включается сам.
function Library:SetClickEffect(opt)
    local fx = self._clickFx
    if type(opt) == "boolean" then
        fx.Enabled = opt
    elseif type(opt) == "table" then
        for k, v in pairs(opt) do fx[k] = v end
    end
    if not CLICK_STYLES[fx.Style] then fx.Style = "Rings" end
    fx.Size = math.clamp(tonumber(fx.Size) or 80, 30, 300)
    fx.Rings = math.clamp(math.floor(tonumber(fx.Rings) or 3), 1, 6)
    fx.Duration = math.clamp(tonumber(fx.Duration) or 0.65, 0.2, 2)

    local saved = {}
    for k, v in pairs(fx) do
        if type(v) == "number" or type(v) == "string" or type(v) == "boolean" or typeof(v) == "Color3" then
            saved[k] = v
        end
    end
    self:_persist("_clickfx", saved)

    if fx.Enabled then
        if not self.ClickGui then
            -- отдельный ScreenGui поверх всего, чтобы круги были видны и над меню
            local gui = Instance.new("ScreenGui")
            gui.Name = "HIros_ClickFX"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 100
            gui.Parent = PlayerGui
            self.ClickGui = gui
        end
        if not self._clickConn then
            self._clickConn = self:_track(UserInputService.InputBegan:Connect(function(input, gp)
                local cfg = self._clickFx
                if not cfg.Enabled then return end
                if cfg.IgnoreGui and gp then return end
                local t = input.UserInputType
                if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch
                    or (cfg.Right and t == Enum.UserInputType.MouseButton2) then
                    self:_spawnClickFX(pointerPos(input))
                end
            end))
        end
    else
        if self._clickConn then
            self._clickConn:Disconnect()
            self:_untrack(self._clickConn)
            self._clickConn = nil
        end
    end
end

function Library:GetClickEffect()
    local copy = {}
    for k, v in pairs(self._clickFx) do copy[k] = v end
    return copy
end

function Library:_spawnClickFX(pos)
    local fx = self._clickFx
    local gui = self.ClickGui
    if not gui then return end
    if self._fxActive > 60 then return end -- защита от спама кликами

    local color = getFxColor(fx, self:_theme())
    local size, dur, n, style = fx.Size, fx.Duration, fx.Rings, fx.Style

    local function track(inst, lifetime)
        self._fxActive = self._fxActive + 1
        task.delay(lifetime, function()
            inst:Destroy()
            self._fxActive = math.max(0, self._fxActive - 1)
        end)
    end

    local info = TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- центральная точка-вспышка (у всех стилей)
    local dot = newFxCircle(gui, pos, 14, color, 3)
    dot.BackgroundTransparency = 0.2
    TweenService:Create(dot, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1,
    }):Play()
    track(dot, 0.33)

    if style == "Rings" or style == "Focus" then
        -- 3 кольца с задержкой: Rings расходятся наружу, Focus сжимаются к точке клика
        for i = 1, n do
            local function make()
                local maxSize = size * (0.6 + 0.4 * (i / n))
                local focus = (style == "Focus")
                local c = newFxCircle(gui, pos, focus and maxSize or 10, color, 1)
                local stroke = Instance.new("UIStroke")
                stroke.Color = color
                stroke.Thickness = 3.5
                stroke.Transparency = focus and 0.4 or 0.1
                stroke.Parent = c
                local target = focus and 8 or maxSize
                TweenService:Create(c, info, { Size = UDim2.new(0, target, 0, target) }):Play()
                TweenService:Create(stroke, info, { Transparency = 1, Thickness = 0.8 }):Play()
                track(c, dur + 0.05)
            end
            if i == 1 then make() else task.delay((i - 1) * 0.09, make) end
        end

    elseif style == "Pulse" then
        -- заливные полупрозрачные круги, расходящиеся волной
        for i = 1, n do
            local function make()
                local maxSize = size * (0.6 + 0.4 * (i / n))
                local c = newFxCircle(gui, pos, 10, color, 1)
                c.BackgroundTransparency = 0.55
                TweenService:Create(c, info, {
                    Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1,
                }):Play()
                track(c, dur + 0.05)
            end
            if i == 1 then make() else task.delay((i - 1) * 0.09, make) end
        end

    elseif style == "Burst" then
        -- точки разлетаются лучами + одно кольцо
        local count = 6 + n * 2
        for i = 1, count do
            local ang = (i / count) * math.pi * 2
            local d = newFxCircle(gui, pos, 7, color, 2)
            d.BackgroundTransparency = 0.05
            TweenService:Create(d, info, {
                Position = UDim2.new(0, pos.X + math.cos(ang) * size * 0.6, 0, pos.Y + math.sin(ang) * size * 0.6),
                Size = UDim2.new(0, 2, 0, 2),
                BackgroundTransparency = 1,
            }):Play()
            track(d, dur + 0.05)
        end
        local c = newFxCircle(gui, pos, 10, color, 1)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color
        stroke.Thickness = 3
        stroke.Transparency = 0.1
        stroke.Parent = c
        TweenService:Create(c, info, { Size = UDim2.new(0, size * 0.5, 0, size * 0.5) }):Play()
        TweenService:Create(stroke, info, { Transparency = 1, Thickness = 0.8 }):Play()
        track(c, dur + 0.05)
    end
end

-- ============================================================
-- ШАУТАУТ В DISCORD (только с явного согласия игрока)
-- ============================================================
local SHOUTOUT_MESSAGES = {
    "Всем привет! 👋 Я юзаю %s и это топ 💜",
    "%s — моя любимая библиотека для менюшек 🔥✨",
    "Го все на %s, реально удобно 😍",
    "Нашёл крутую либу — %s 💙 всем советую",
    "%s просто имба, бегите тестить 🚀💜",
    "Сижу на %s и кайфую 😎✨",
    "Если ещё не пробовали %s — зря, очень годно 🔥",
    "%s — лучшее, что я находил для менюшек в играх 💖",
    "Всем привет из %s! 👋💜 заходите, не пожалеете",
    "Юзаю %s каждый день, рекомендую 🙌✨",
}

local function dbg(...)
    if Library.ShoutoutDebug then print("[HIros Shoutout]", ...) end
end

-- HTTP-функция экзекьютора. Ищем как обычные глобалы (так они и лежат в окружении
-- скрипта), а не в _G — там их обычно нет.
local function execRequestFn()
    return (syn and syn.request) or (http and http.request) or http_request or request
        or (fluxus and fluxus.request)
end

-- GET: сначала game:HttpGet экзекьютора (ходит куда угодно, в т.ч. на roblox.com),
-- потом request(), потом HttpService.
local function httpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and res ~= "" then
        dbg("GET ok через game:HttpGet:", url)
        return res
    end

    local reqFn = execRequestFn()
    if reqFn then
        local ok2, r = pcall(reqFn, { Url = url, Method = "GET" })
        if ok2 and type(r) == "table" and type(r.Body) == "string" and r.Body ~= "" then
            dbg("GET ok через request():", url)
            return r.Body
        end
    end

    local ok3, r3 = pcall(function() return HttpService:GetAsync(url) end)
    if ok3 and r3 then
        dbg("GET ok через HttpService:", url)
        return r3
    end
    dbg("GET не удался:", url, ok3 and "" or tostring(r3))
    return nil
end

-- POST на вебхук. Сначала HttpService, при неудаче — функция экзекьютора.
function Library:_postWebhook(url, payload)
    if not url or url == "" then return end
    task.spawn(function()
        local ok, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
        if not ok then dbg("JSONEncode не удался", tostring(encoded)) return end

        local sent, err = pcall(function()
            HttpService:PostAsync(url, encoded, Enum.HttpContentType.ApplicationJson)
        end)
        if sent then dbg("POST ok через HttpService") return end
        dbg("HttpService:PostAsync не удался:", tostring(err))

        local reqFn = execRequestFn()
        if not reqFn then dbg("нет функции request() у экзекьютора, отправить не получилось") return end
        local ok2, res = pcall(reqFn, {
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = encoded,
        })
        dbg("POST через request():", ok2 and "ok" or tostring(res),
            (ok2 and type(res) == "table") and ("код " .. tostring(res.StatusCode)) or "")
    end)
end

-- Ссылка на аватарку по ID игрока: нужна настоящая https-картинка (Discord не понимает rbxthumb://).
-- Спрашиваем API миниатюр Roblox (напрямую и через roproxy) и берём прямую ссылку на CDN.
local AVATAR_APIS = {
    "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%s&size=420x420&format=Png&isCircular=false",
    "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=%s&size=420x420&format=Png&isCircular=false",
}

local function getAvatarUrl(userId)
    local id = tostring(userId)
    for attempt = 1, 2 do
        local pending = false
        for _, tpl in ipairs(AVATAR_APIS) do
            local body = httpGet(string.format(tpl, id))
            if body then
                local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
                local item = ok and type(data) == "table" and type(data.data) == "table" and data.data[1] or nil
                if item then
                    if item.state == "Completed" and type(item.imageUrl) == "string"
                        and item.imageUrl:match("^https?://") then
                        dbg("аватар получен через API:", item.imageUrl)
                        return item.imageUrl
                    elseif item.state == "Pending" then
                        pending = true
                    end
                end
            end
        end
        if pending and attempt == 1 then task.wait(1.2) else break end
    end
    dbg("API миниатюр не дал ссылку, использую запасную")
    return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. id .. "&width=420&height=420&format=png"
end

-- Согласился: случайное сообщение от имени игрока. Отказался: анонимный +1, без ника и аватарки.
function Library:_sendShoutout(webhookUrl, consented)
    task.spawn(function()
        local payload
        if consented then
            local template = SHOUTOUT_MESSAGES[math.random(1, #SHOUTOUT_MESSAGES)]
            payload = {
                content = string.format(template, BRAND),
                username = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
                avatar_url = getAvatarUrl(LocalPlayer.UserId),
            }
        else
            payload = {
                content = "📊 +1 использование " .. BRAND .. " (игрок не стал делиться ником и аватаркой)",
            }
        end
        self:_postWebhook(webhookUrl, payload)
    end)
end

-- Window:PromptShoutout({ Webhook = "https://discord.com/api/webhooks/..." })
-- Показывает Confirm-попап и ничего не отправляет, пока игрок не ответит.
-- Спрашивает один раз за запуск.
function Library:PromptShoutout(config)
    config = config or {}
    local webhookUrl = config.Webhook
    if not webhookUrl or webhookUrl == "" then return end
    if self._shoutoutAsked then return end
    self._shoutoutAsked = true
    if config.Debug then Library.ShoutoutDebug = true end

    task.delay(config.Delay or 2.5, function()
        if self._destroyed then return end
        self:Confirm({
            Title = config.Title or "Поделиться в Discord? 💜",
            Content = config.Content or ("Хочешь, чтобы в нашем Discord написали от твоего имени, что ты используешь "
                .. BRAND .. "? Будут видны твой ник и аватарка. Если откажешься — просто +1 к счётчику без твоих данных."),
            YesText = config.YesText or "Да, го 💜",
            NoText = config.NoText or "Нет, просто посчитать",
            Callback = function(yes)
                self:_sendShoutout(webhookUrl, yes)
            end,
        })
    end)
end

function Library:SetParticles(enabled)
    self._particlesEnabled = enabled and true or false
    if self.ParticleLayer then self.ParticleLayer.Visible = self._particlesEnabled end
    self:_persist("_particles", self._particlesEnabled)
end

-- Вызывается каждый кадр: все "живые" анимации окна в одном месте
function Library:_animate(dt, t)
    if self.StrokeGradient then
        self.StrokeGradient.Offset = Vector2.new((t * 0.18) % 1, 0)
    end
    if self.LineGradient then
        self.LineGradient.Offset = Vector2.new(math.sin(t * 0.9) * 0.6, 0)
    end
    if self.TitleGradient then
        self.TitleGradient.Offset = Vector2.new(math.sin(t * 0.7) * 0.5, 0)
    end
    if self.AvatarGradient then
        self.AvatarGradient.Rotation = (t * 60) % 360
    end
    if self.ToggleGlow then
        local pulse = math.sin(t * 2.2)
        local base = self.Enabled and 0.62 or 0.8
        self.ToggleGlow.BackgroundTransparency = base + pulse * 0.08
        local sz = 64 + pulse * 5
        self.ToggleGlow.Size = UDim2.new(0, sz, 0, sz)
    end
    if self._handle and self._handle.target then self:_stepMagnet(dt) end
    local h = self._handle
    if h and h.holder.Visible then
        -- блик: только при наведении (и пока тянешь). Проходит слева направо, затем короткая пауза
        if h.hover or h.drag then
            h.shimT = (h.shimT or 0) + dt
            local p = (h.shimT % 1.3) / 0.9
            if p > 1 then p = 1 end
            p = 1 - (1 - p) * (1 - p)
            h.grad.Offset = Vector2.new(-1 + 2 * p, 0)
        else
            h.shimT = 0
            h.grad.Offset = Vector2.new(-1, 0) -- блик за краем полоски
        end
        -- полоска неподвижна; свечение видно только пока тянешь окно (там чуть пульсирует)
        local pulse = h.drag and math.sin(t * 2) * 0.04 or 0
        h.glow.BackgroundTransparency = math.clamp(h.glowBase.Value + pulse, 0, 1)
    end
    if self.Enabled and self._particlesEnabled and not self._minimized then
        for _, p in ipairs(self._particles) do
            p.y = p.y - p.speed * dt
            if p.y < -0.05 then
                p.y = 1.05
                p.x = math.random()
            end
            local sx = p.x + math.sin(t * 0.8 + p.sway) * p.swayAmp
            p.frame.Position = UDim2.new(sx, 0, p.y, 0)
        end
    end
end

function Library:SetGlowMode(mode)
    self._glowMode = (mode == "rainbow") and "rainbow" or "theme"
    self:_persist("_glow_mode", self._glowMode)
    if self._glowMode == "theme" then
        local theme = self:_theme()
        for _, l in ipairs(self.GlowLayers) do
            TweenService:Create(l.instance, TweenInfo.new(0.4), { BackgroundColor3 = theme.Accent }):Play()
        end
    end
end

-- ============================================================
-- NOTIFY
-- ============================================================
function Library:Notify(config)
    local kind = config.Kind or "info"
    local accent = self:_theme().Accent
    local symbol = "💬"
    if kind == "success" then accent = Color3.fromRGB(60, 200, 120); symbol = "✅"
    elseif kind == "error" then accent = Color3.fromRGB(235, 80, 90); symbol = "❌"
    elseif kind == "warning" then accent = Color3.fromRGB(255, 180, 60); symbol = "⚠️" end

    local notify = Instance.new("Frame")
    notify.Size = UDim2.new(0, 280, 0, 70)
    notify.Position = UDim2.new(1, 300, 0, 20)
    notify.BackgroundColor3 = BG_PANEL
    notify.BorderSizePixel = 0
    notify.ZIndex = 999
    notify.Parent = self.ScreenGui
    createCorner(notify, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = accent
    stroke.Thickness = 2
    stroke.Parent = notify

    local iconCircle = Instance.new("Frame")
    iconCircle.Size = UDim2.new(0, 26, 0, 26)
    iconCircle.Position = UDim2.new(0, 10, 0, 10)
    iconCircle.BackgroundColor3 = accent
    iconCircle.BackgroundTransparency = 0.7
    iconCircle.BorderSizePixel = 0
    iconCircle.ZIndex = 1000
    iconCircle.Parent = notify
    createCorner(iconCircle, 999)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = symbol
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 13
    iconLabel.ZIndex = 1001
    iconLabel.Parent = iconCircle

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 46, 0, 10)
    title.Size = UDim2.new(1, -58, 0, 20)
    title.Font = Enum.Font.GothamBold
    title.Text = config.Title or self:_t("notify")
    title.TextColor3 = TEXT_COLOR
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 1000
    title.Parent = notify

    local content = Instance.new("TextLabel")
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 46, 0, 30)
    content.Size = UDim2.new(1, -58, 0, 32)
    content.Font = Enum.Font.Gotham
    content.Text = config.Content or ""
    content.TextColor3 = SUBTEXT
    content.TextSize = 12
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextWrapped = true
    content.ZIndex = 1000
    content.Parent = notify

    -- Полоска-таймер: плавно сокращается за время показа уведомления
    local timerBar = Instance.new("Frame")
    timerBar.Position = UDim2.new(0, 12, 1, -7)
    timerBar.Size = UDim2.new(1, -24, 0, 3)
    timerBar.BackgroundColor3 = accent
    timerBar.BackgroundTransparency = 0.25
    timerBar.BorderSizePixel = 0
    timerBar.ZIndex = 1000
    timerBar.Parent = notify
    createCorner(timerBar, 999)
    TweenService:Create(timerBar, TweenInfo.new(config.Duration or 5, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3),
    }):Play()

    -- Стек уведомлений: список активных, а не общий счётчик — так позиции
    -- остаются верными, даже если уведомления с разной длительностью
    -- закрываются не по порядку.
    self._activeNotifies = self._activeNotifies or {}
    table.insert(self._activeNotifies, notify)

    local function reflow()
        for i, n in ipairs(self._activeNotifies) do
            local targetY = 20 + (i - 1) * 78
            TweenService:Create(n, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -300, 0, targetY),
            }):Play()
        end
    end

    notify.Position = UDim2.new(1, 300, 0, 20 + (#self._activeNotifies - 1) * 78)
    reflow()

    if config.Sound ~= false then self:_play("Notify") end

    task.delay(config.Duration or 5, function()
        local t = TweenService:Create(notify, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 300, 0, notify.Position.Y.Offset),
        })
        t:Play()
        t.Completed:Connect(function()
            for i, n in ipairs(self._activeNotifies) do
                if n == notify then
                    table.remove(self._activeNotifies, i)
                    break
                end
            end
            reflow()
            notify:Destroy()
        end)
    end)
    return notify
end

-- ============================================================
-- ТЕЛЕФОН, ОВЕРЛЕИ, РАЗМЕР ОКНА, ЯЗЫК, СВЕТЛАЯ ТЕМА, НАСТРОЙКИ
-- ============================================================
-- Строка интерфейса на выбранном языке: self:_t("save") / self:_t("cfg_saved_msg", name)
function Library:_t(key, ...)
    local pack = STRINGS[self._lang or "ru"] or STRINGS.ru
    local s = pack[key] or STRINGS.ru[key] or tostring(key)
    if select("#", ...) > 0 then
        local ok, res = pcall(string.format, s, ...)
        if ok then return res end
    end
    return s
end

-- Сохраняет выбор пользователя в конфиг (только после создания окна, чтобы не писать файл зря)
function Library:_persist(flag, value)
    if self._ready then self:SetFlag(flag, value) end
end

function Library:SetLanguage(lang)
    if not STRINGS[lang] then return end
    self._lang = lang
    if self.SearchBox then self.SearchBox.PlaceholderText = self:_t("search") end
    if self._noResults then self._noResults.Text = self:_t("no_results") end
    self:_persist("_lang", lang)
end

function Library:GetLanguage() return self._lang end

-- Светлая/тёмная тема интерфейса. Палитра общая для всех окон скрипта.
function Library:SetLightMode(on)
    switchPalette(on and "light" or "dark")
    self:_persist("_light", on and true or false)
end

function Library:IsLightMode() return currentPalette == "light" end

function Library:_onPaletteChanged()
    self:_applyThemeVisuals()
    for _, el in ipairs(self.Elements) do
        if el.UpdateTheme then pcall(el.UpdateTheme) end
    end
end

-- ------------------------------------------------------------
-- Масштаб: ручной (SetScale) × автоподгонка под экран
-- ------------------------------------------------------------
function Library:_effectiveScale()
    return (self._scale or 1) * (self._fit or 1)
end

function Library:_applyScale()
    if self.Scale then self.Scale.Scale = self:_effectiveScale() end
end

-- Окно 560x380 не влезает в экран телефона по высоте — уменьшаем под экран
function Library:_updateFit()
    local cam = workspace.CurrentCamera
    if not cam or not self.Wrapper then return end
    local vp = cam.ViewportSize
    local w, h = self.WindowSize.X + 24, self.WindowSize.Y + 24
    self._fit = math.clamp(math.min(vp.X / w, vp.Y / h), 0.4, 1)
    self:_applyScale()
    self:_clampToScreen()
end

-- Окно нельзя утащить за экран: шапка всегда остаётся достижимой
function Library:_clampToScreen(animate)
    local cam = workspace.CurrentCamera
    if not cam or not self.Wrapper then return end
    local vp = cam.ViewportSize
    local s = self:_effectiveScale()
    local halfW, halfH = self.WindowSize.X * s / 2, self.WindowSize.Y * s / 2
    local bar = 42 * s
    local p = self.Wrapper.Position
    local cx, cy = p.X.Scale * vp.X + p.X.Offset, p.Y.Scale * vp.Y + p.Y.Offset -- центр окна
    local minX, maxX = 90 - halfW, vp.X - 90 + halfW
    local minY, maxY = halfH, vp.Y - bar + halfH
    local nx = math.clamp(cx, minX, math.max(minX, maxX))
    local ny = math.clamp(cy, minY, math.max(minY, maxY))
    if nx ~= cx or ny ~= cy then
        local target = UDim2.new(p.X.Scale, p.X.Offset + (nx - cx), p.Y.Scale, p.Y.Offset + (ny - cy))
        if animate then -- окно «отпружинивает» обратно на экран
            self:_stopMagnet()
            local tw = TweenService:Create(self.Wrapper, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = target,
            })
            tw:Play()
            tw.Completed:Connect(function() self:_saveWindowPosition() end)
            return true
        end
        self.Wrapper.Position = target
    end
    return false
end

-- ------------------------------------------------------------
-- Размер окна (уголок в правом нижнем углу)
-- ------------------------------------------------------------
function Library:_setupResize()
    local grip = self.ResizeGrip
    local resizing, startPtr, startSize, startPos, s
    grip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startPtr = Vector2.new(input.Position.X, input.Position.Y)
            startSize = self.WindowSize
            startPos = self.Wrapper.Position
            s = self:_effectiveScale()
            lockScroll(grip, true)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End and resizing then
                    resizing = false
                    lockScroll(grip, false)
                    self:_persist("_window_size", { w = self.WindowSize.X, h = self.WindowSize.Y })
                    self:_updateFit()
                    self:_saveWindowPosition()
                end
            end)
        end
    end)
    self:_track(UserInputService.InputChanged:Connect(function(input)
        if not resizing then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = Vector2.new(input.Position.X, input.Position.Y) - startPtr
        local w = math.clamp(startSize.X + d.X / s, MIN_W, MAX_W)
        local h = math.clamp(startSize.Y + d.Y / s, MIN_H, MAX_H)
        self.WindowSize = Vector2.new(w, h)
        if not self._minimized then self.Main.Size = UDim2.new(0, w, 0, h) end
        -- верхний левый угол остаётся на месте: сдвигаем центр на половину прироста
        self.Wrapper.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + (w - startSize.X) * s / 2,
            startPos.Y.Scale, startPos.Y.Offset + (h - startSize.Y) * s / 2
        )
    end))
end

function Library:SetWindowSize(w, h)
    w = math.clamp(tonumber(w) or 560, MIN_W, MAX_W)
    h = math.clamp(tonumber(h) or 380, MIN_H, MAX_H)
    self.WindowSize = Vector2.new(w, h)
    if self.Main and self.Enabled and not self._minimized then
        self.Main.Size = UDim2.new(0, w, 0, h)
    end
    self:_syncGlowSize()
    self:_persist("_window_size", { w = w, h = h })
    self:_updateFit()
end

function Library:ResetSize()
    self:SetWindowSize(560, 380)
    self:_persist("_window_size", nil)
end

-- ------------------------------------------------------------
-- Белая полоска-«ручка» под окном (как у шторок в мессенджерах): тащишь за неё — окно двигается,
-- двойное нажатие возвращает окно в центр. Выключить: CreateWindow({ DragHandle = false })
-- или Window:SetDragHandle(false).
-- ------------------------------------------------------------
-- Пружинная «магнитная» догонялка: окно притягивается к палке, чуть перелетает и успокаивается
function Library:_stepMagnet(dt)
    local h = self._handle
    if not h or not h.target then return end
    local d = math.min(dt, 1 / 30)
    local diff = h.target - h.cur
    local acc = diff * 260 - h.vel * 26
    h.vel = h.vel + acc * d
    h.cur = h.cur + h.vel * d
    local settled = (not h.drag) and diff.Magnitude < 0.4 and h.vel.Magnitude < 4
    if settled then
        h.cur = h.target
        h.vel = Vector2.new(0, 0)
    end
    self.Wrapper.Position = UDim2.new(h.base.X.Scale, h.cur.X, h.base.Y.Scale, h.cur.Y)

    -- палка остаётся там, где её держит палец, пока окно подтягивается
    local s = math.max(self.Scale.Scale, 0.01)
    local gap = (h.target - h.cur) / s
    h.gapX, h.gapY = gap.X, gap.Y
    h.place()

    -- нить притяжения от низа окна к палке
    local gapLen = gap.Magnitude
    if gapLen > 6 and not settled then
        local ax = self.Main.Position.X.Offset
        local ay = self.Main.Position.Y.Offset + self.Main.Size.Y.Offset / 2
        local vx, vy = gap.X, gap.Y + h.hitH / 2 + 2
        local len = math.sqrt(vx * vx + vy * vy)
        h.tether.Position = UDim2.new(0.5, ax, 0.5, ay)
        h.tether.Size = UDim2.new(0, 2, 0, len)
        h.tether.Rotation = -math.deg(math.atan2(vx, vy))
        h.tether.BackgroundTransparency = 1 - math.clamp((gapLen - 6) / 50, 0, 1) * 0.6
        h.tether.Visible = true
    else
        h.tether.Visible = false
    end

    if settled then
        h.target = nil
        h.gapX, h.gapY = 0, 0
        h.place()
        self:_saveWindowPosition()
    end
end

-- Прервать «притяжение» (двойное нажатие, перетаскивание за шапку и т.п.)
function Library:_stopMagnet()
    local h = self._handle
    if h and h.target then
        h.target = nil
        h.gapX, h.gapY = 0, 0
        h.place()
        h.tether.Visible = false
    end
end

-- Ограничение центра окна пределами экрана (чтобы шапка всегда оставалась достижимой)
function Library:_clampCenter(cx, cy)
    local cam = workspace.CurrentCamera
    if not cam then return cx, cy end
    local vp = cam.ViewportSize
    local s = self:_effectiveScale()
    local halfW, halfH = self.WindowSize.X * s / 2, self.WindowSize.Y * s / 2
    local bar = 42 * s
    local minX, maxX = 90 - halfW, vp.X - 90 + halfW
    local minY, maxY = halfH, vp.Y - bar + halfH
    return math.clamp(cx, minX, math.max(minX, maxX)), math.clamp(cy, minY, math.max(minY, maxY))
end

function Library:_recenter()
    self:_stopMagnet()
    local tw = TweenService:Create(self.Wrapper, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
    })
    tw:Play()
    tw.Completed:Connect(function() self:_saveWindowPosition() end)
end

function Library:_createDragHandle()
    local mobile = self._mobile
    local hitW, hitH = mobile and 250 or 190, mobile and 46 or 30 -- зона нажатия больше самой полоски
    local pillW, pillH = mobile and 132 or 112, mobile and 7 or 6
    local h = { pillW = pillW, pillH = pillH, token = 0, hover = false, drag = false }
    self._handle = h

    local holder = Instance.new("CanvasGroup")
    holder.Name = "DragHandle"
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Size = UDim2.new(0, hitW, 0, hitH)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.GroupTransparency = 1
    holder.Active = true
    holder.Visible = false
    holder.ZIndex = 12
    holder.Parent = self.Wrapper
    h.holder = holder

    -- inner двигается при появлении/скрытии (выезжает снизу), holder стоит под окном
    local inner = Instance.new("Frame")
    inner.Name = "Inner"
    inner.AnchorPoint = Vector2.new(0.5, 0.5)
    inner.Position = UDim2.new(0.5, 0, 0.5, 14)
    inner.Size = UDim2.new(1, 0, 1, 0)
    inner.BackgroundTransparency = 1
    inner.BorderSizePixel = 0
    inner.Parent = holder
    h.inner = inner

    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(0, pillW + 34, 0, pillH + 20)
    glow.BackgroundColor3 = self:_theme().Accent
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.ZIndex = 1
    glow.Parent = inner
    createCorner(glow, 999)
    local glowScale = Instance.new("UIScale")
    glowScale.Parent = glow
    h.glow = glow
    h.glowBase = Instance.new("NumberValue")
    h.glowBase.Value = 1

    local pill = Instance.new("Frame")
    pill.Name = "Pill"
    pill.AnchorPoint = Vector2.new(0.5, 0.5)
    pill.Position = UDim2.new(0.5, 0, 0.5, 0)
    pill.Size = UDim2.new(0, pillW, 0, pillH)
    pill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pill.BorderSizePixel = 0
    pill.ZIndex = 2
    pill.Parent = inner
    createCorner(pill, 999)
    local pillStroke = Instance.new("UIStroke") -- тонкий тёмный контур: белая полоска видна и на светлом фоне
    pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pillStroke.Color = Color3.fromRGB(0, 0, 0)
    pillStroke.Transparency = 0.55
    pillStroke.Thickness = 1
    pillStroke.Parent = pill
    local pillScale = Instance.new("UIScale")
    pillScale.Parent = pill
    local grad = Instance.new("UIGradient") -- блик, который пробегает по полоске (двигается в _animate)
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.42, 0.3),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.58, 0.3),
        NumberSequenceKeypoint.new(1, 0.3),
    })
    grad.Parent = pill
    h.pill, h.grad = pill, grad
    h.hitH = hitH
    h.gapX, h.gapY = 0, 0

    -- тонкая «нить притяжения» между окном и палкой: видна, пока окно догоняет палку
    local tether = Instance.new("Frame")
    tether.Name = "Tether"
    tether.AnchorPoint = Vector2.new(0.5, 0)
    tether.BackgroundColor3 = self:_theme().Accent
    tether.BorderSizePixel = 0
    tether.Size = UDim2.new(0, 2, 0, 0)
    tether.ZIndex = 11
    tether.Visible = false
    tether.Parent = self.Wrapper
    createCorner(tether, 999)
    h.tether = tether

    -- ручка всегда под окном, даже во время открытия, сворачивания и изменения размера
    local function place()
        local y = self.Main.Position.Y.Offset + self.Main.Size.Y.Offset / 2 + hitH / 2 + 2
        holder.Position = UDim2.new(0.5, self.Main.Position.X.Offset + h.gapX, 0.5, y + h.gapY)
    end
    h.place = place
    place()
    self.Main:GetPropertyChangedSignal("Size"):Connect(place)
    self.Main:GetPropertyChangedSignal("Position"):Connect(place)

    local function applyState()
        local s, gs, gb
        if h.drag then s, gs, gb = 1.3, 1.5, 0.5   -- тянем: свечение
        elseif h.hover then s, gs, gb = 1.15, 1, 1 -- наведение: растёт, без свечения (будет блик)
        else s, gs, gb = 1, 1, 1 end               -- покой: чистая белая полоска
        TweenService:Create(pillScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = s }):Play()
        TweenService:Create(glowScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = gs }):Play()
        TweenService:Create(h.glowBase, TweenInfo.new(0.2), { Value = gb }):Play()
    end

    holder.MouseEnter:Connect(function() h.hover = true h.shimT = 0 applyState() end)
    holder.MouseLeave:Connect(function() h.hover = false applyState() end)

    local dragging, startPtr, startPos, lastTap = false, nil, nil, 0
    holder.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local now = os.clock()
        if now - lastTap < 0.35 then -- двойное нажатие: окно возвращается в центр
            lastTap = 0
            self:_play("Click")
            self:_recenter()
            return
        end
        lastTap = now
        dragging, h.drag = true, true
        if (h.shimT or 0) <= 0 then h.shimT = 0 end
        startPtr = Vector2.new(input.Position.X, input.Position.Y)
        startPos = self.Wrapper.Position
        -- магнит: окно будет догонять палку пружиной (если оно ещё догоняет — продолжаем с её места)
        if not h.target then
            h.base = startPos
            h.cur = Vector2.new(startPos.X.Offset, startPos.Y.Offset)
            h.vel = Vector2.new(0, 0)
            h.target = h.cur
        end
        h.startOff = h.target
        applyState()
        -- окно слегка «приподнимается» на время перетаскивания
        TweenService:Create(self.Scale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = self:_effectiveScale() * 1.02,
        }):Play()
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End and dragging then
                dragging, h.drag = false, false
                applyState()
                TweenService:Create(self.Scale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = self:_effectiveScale(),
                }):Play()
                -- отпустили: цель возвращается в пределы экрана, окно «притягивается» к ней с лёгким отскоком
                local cam = workspace.CurrentCamera
                if cam and h.target then
                    local vp = cam.ViewportSize
                    local cx = h.base.X.Scale * vp.X + h.target.X
                    local cy = h.base.Y.Scale * vp.Y + h.target.Y
                    local nx, ny = self:_clampCenter(cx, cy)
                    h.target = Vector2.new(h.target.X + (nx - cx), h.target.Y + (ny - cy))
                end
            end
        end)
    end)
    self:_track(UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = Vector2.new(input.Position.X, input.Position.Y) - startPtr
        if h.startOff then h.target = h.startOff + d end -- палка там, где палец; окно подтянется
    end))
end

-- Плавное появление (выезжает снизу после открытия окна) и исчезновение
function Library:_showHandle(show)
    local h = self._handle
    if not h then return end
    h.token = h.token + 1
    local token = h.token
    if show and self._handleEnabled then
        task.delay(0.3, function()
            if token ~= h.token then return end
            h.holder.Visible = true
            TweenService:Create(h.holder, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                GroupTransparency = 0,
            }):Play()
            TweenService:Create(h.inner, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0.5, 0),
            }):Play()
        end)
    else
        TweenService:Create(h.holder, TweenInfo.new(0.15), { GroupTransparency = 1 }):Play()
        local tw = TweenService:Create(h.inner, TweenInfo.new(0.15), { Position = UDim2.new(0.5, 0, 0.5, 12) })
        tw:Play()
        tw.Completed:Connect(function()
            if token == h.token then h.holder.Visible = false end
        end)
    end
end

function Library:SetDragHandle(v)
    self._handleEnabled = v and true or false
    self:_showHandle(self.Enabled)
    self:_persist("_handle", self._handleEnabled)
end

-- ------------------------------------------------------------
-- Перетаскиваемые плашки (мышь и палец), позиция запоминается
-- ------------------------------------------------------------
function Library:_loadGuiPos(key, obj)
    local p = self.Flags["_gp_" .. key]
    if type(p) == "table" and p.xs and p.xo and p.ys and p.yo then
        obj.Position = UDim2.new(p.xs, p.xo, p.ys, p.yo)
    end
end

function Library:_saveGuiPos(key, obj)
    local pos = obj.Position
    self:SetFlag("_gp_" .. key, { xs = pos.X.Scale, xo = pos.X.Offset, ys = pos.Y.Scale, yo = pos.Y.Offset })
end

-- Возвращает { moved = bool }: после перетаскивания moved = true, чтобы клик не считался нажатием
function Library:_makeDraggable(obj, flagKey, handle)
    handle = handle or obj
    local st = { moved = false }
    local dragging, startPtr, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            st.moved = false
            startPtr = Vector2.new(input.Position.X, input.Position.Y)
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if st.moved and flagKey then self:_saveGuiPos(flagKey, obj) end
                end
            end)
        end
    end)
    self:_track(UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = Vector2.new(input.Position.X, input.Position.Y) - startPtr
        if not st.moved and d.Magnitude < 8 then return end -- маленькое дрожание пальца — это ещё нажатие
        st.moved = true
        obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end))
    return st
end

function Library:_getOverlayGui()
    if not self.OverlayGui then
        local gui = Instance.new("ScreenGui")
        gui.Name = "HIros_Overlay_" .. self.Name
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 49 -- над игрой, под самим меню
        gui.Parent = PlayerGui
        self.OverlayGui = gui
    end
    return self.OverlayGui
end

-- ------------------------------------------------------------
-- Водяной знак: ник скрипта, FPS и пинг. Window:CreateWatermark({ Text = "MyHub", Player = true })
-- ------------------------------------------------------------
function Library:CreateWatermark(cfg)
    cfg = type(cfg) == "table" and cfg or {}
    if self._watermark then self._watermark.Destroy() end
    local gui = self:_getOverlayGui()
    local showFps, showPing = cfg.FPS ~= false, cfg.Ping ~= false

    local frame = Instance.new("Frame")
    frame.Name = "Watermark"
    frame.AutomaticSize = Enum.AutomaticSize.X
    frame.Size = UDim2.new(0, 0, 0, 26)
    frame.Position = UDim2.new(0, 14, 0, 14)
    frame.BackgroundColor3 = BG_PANEL
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ZIndex = 60
    frame.Parent = gui
    createCorner(frame, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = self:_theme().Accent
    stroke.Thickness = 1.2
    stroke.Transparency = 0.35
    stroke.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = frame

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Size = UDim2.new(0, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = TEXT_COLOR
    label.RichText = true
    label.Text = ""
    label.ZIndex = 61
    label.Parent = frame

    self:_loadGuiPos("wm", frame)
    self:_makeDraggable(frame, "wm")

    local text = tostring(cfg.Text or BRAND)
    local fps, ping, frames, elapsed = 0, 0, 0, 0
    local function render()
        local theme = self:_theme()
        local parts = { string.format('<font color="%s">%s</font>', colorToHex(theme.Accent), text) }
        if cfg.Player then table.insert(parts, LocalPlayer.DisplayName) end
        if showFps then table.insert(parts, string.format("%d FPS", fps)) end
        if showPing then table.insert(parts, string.format("%d ms", ping)) end
        label.Text = table.concat(parts, '  <font color="#808080">|</font>  ')
        stroke.Color = theme.Accent
    end
    render()

    local conn = self:_track(RunService.Heartbeat:Connect(function(dt)
        frames = frames + 1
        elapsed = elapsed + dt
        if elapsed >= 0.5 then
            fps = math.floor(frames / elapsed + 0.5)
            local ok, p = pcall(function() return LocalPlayer:GetNetworkPing() * 1000 end)
            ping = ok and math.floor(p + 0.5) or 0
            frames, elapsed = 0, 0
            render()
        end
    end))

    local obj = { Instance = frame }
    obj.SetText = function(t) text = tostring(t) render() end
    obj.SetVisible = function(v) frame.Visible = v and true or false end
    obj.Destroy = function()
        conn:Disconnect()
        self:_untrack(conn)
        frame:Destroy()
        if self._watermark == obj then self._watermark = nil end
    end
    table.insert(self.Elements, { Type = "Watermark", Instance = frame, UpdateTheme = render })
    self._watermark = obj
    return obj
end

function Library:SetWatermarkVisible(v)
    v = v and true or false
    if v and not self._watermark then self:CreateWatermark(self._wmCfg) end
    if not v and self._watermark then self._watermark.Destroy() end
    self:_persist("_wm_enabled", v)
end

-- ------------------------------------------------------------
-- Список клавиш на экране: показывает включённые функции с горячими клавишами
-- Window:CreateKeybindList({ ShowInactive = false, AlwaysShow = false })
-- ------------------------------------------------------------
function Library:CreateKeybindList(cfg)
    cfg = type(cfg) == "table" and cfg or {}
    if self._kbList then self._kbList.Destroy() end
    local gui = self:_getOverlayGui()

    local frame = Instance.new("Frame")
    frame.Name = "KeybindList"
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Size = UDim2.new(0, 180, 0, 0)
    frame.Position = UDim2.new(0, 14, 0.45, 0)
    frame.BackgroundColor3 = BG_PANEL
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ZIndex = 60
    frame.Visible = false
    frame.Parent = gui
    createCorner(frame, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = self:_theme().Accent
    stroke.Thickness = 1.2
    stroke.Transparency = 0.35
    stroke.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame

    local title = Instance.new("TextLabel")
    title.LayoutOrder = 0
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = self:_theme().Accent
    title.Text = cfg.Title or self:_t("kb_title")
    title.ZIndex = 61
    title.Parent = frame

    self:_loadGuiPos("kb", frame)
    self:_makeDraggable(frame, "kb")

    local function esc(s)
        return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
    end

    local rows, wanted, lastSig = {}, true, nil
    local function rebuild()
        local list = {}
        for _, info in ipairs(self._bindInfo) do
            local key = info.getKey and info.getKey()
            if key then
                local st = info.getState and info.getState()
                if (not info.getState) or st or cfg.ShowInactive then
                    table.insert(list, { name = info.name, key = key.Name, on = st })
                end
            end
        end
        local sigParts = {}
        for _, e in ipairs(list) do table.insert(sigParts, e.name .. "|" .. e.key .. "|" .. tostring(e.on)) end
        local sig = table.concat(sigParts, ";")
        if sig ~= lastSig then
            lastSig = sig
            for _, r in ipairs(rows) do r:Destroy() end
            rows = {}
            local accentHex = colorToHex(self:_theme().Accent)
            for i, e in ipairs(list) do
                local l = Instance.new("TextLabel")
                l.LayoutOrder = i
                l.BackgroundTransparency = 1
                l.Size = UDim2.new(1, 0, 0, 16)
                l.Font = Enum.Font.GothamMedium
                l.TextSize = 12
                l.TextXAlignment = Enum.TextXAlignment.Left
                l.TextColor3 = TEXT_COLOR
                l.TextTransparency = (e.on == false) and 0.5 or 0
                l.RichText = true
                l.Text = string.format('<font color="%s">[%s]</font>  %s', accentHex, esc(e.key), esc(e.name))
                l.ZIndex = 61
                l.Parent = frame
                table.insert(rows, l)
            end
        end
        frame.Visible = wanted and (#list > 0 or cfg.AlwaysShow == true)
    end

    task.spawn(function()
        while frame.Parent do
            rebuild()
            task.wait(0.25)
        end
    end)

    local function updateTheme()
        stroke.Color = self:_theme().Accent
        title.TextColor3 = self:_theme().Accent
        lastSig = nil
        rebuild()
    end

    local obj = { Instance = frame }
    obj.SetVisible = function(v) wanted = v and true or false rebuild() end
    obj.Refresh = function() lastSig = nil rebuild() end
    obj.Destroy = function()
        frame:Destroy()
        if self._kbList == obj then self._kbList = nil end
    end
    table.insert(self.Elements, { Type = "KeybindList", Instance = frame, UpdateTheme = updateTheme })
    self._kbList = obj
    return obj
end

function Library:SetKeybindListVisible(v)
    v = v and true or false
    if v and not self._kbList then self:CreateKeybindList(self._kbCfg) end
    if not v and self._kbList then self._kbList.Destroy() end
    self:_persist("_kb_enabled", v)
end

-- ------------------------------------------------------------
-- Кнопки быстрого доступа — для телефона, где нет клавиш.
-- Window:CreateQuickButton({ Name = "Fly", Toggle = flyToggle })  или  { Name = "Heal", Callback = fn }
-- (проще: CreateToggle({ ..., Quick = true }) создаст кнопку сам). Кнопки перетаскиваются.
-- ------------------------------------------------------------
function Library:CreateQuickButton(cfg)
    cfg = cfg or {}
    local gui = self:_getOverlayGui()
    local name = tostring(cfg.Name or cfg.Text or "Quick")
    local toggle = cfg.Toggle
    local size = self._mobile and 60 or 50
    local idx = 0
    for _, b in ipairs(self._quickButtons) do if b.Parent then idx = idx + 1 end end

    local btn = Instance.new("TextButton")
    btn.Name = "Quick_" .. name
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = UDim2.new(1, -14, 0, 80 + idx * (size + 8))
    btn.Size = UDim2.new(0, size, 0, size)
    btn.BackgroundColor3 = BG_PANEL
    btn.BackgroundTransparency = 0.08
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.Text = cfg.Icon and (tostring(cfg.Icon) .. "\n" .. name) or name
    btn.TextWrapped = true
    btn.TextSize = 11
    btn.TextColor3 = TEXT_COLOR
    btn.ZIndex = 55
    btn.Visible = self._quickVisible
    btn.Parent = gui
    createCorner(btn, 14)

    local stroke = Instance.new("UIStroke")
    stroke.Color = self:_theme().Accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = btn

    self:_loadGuiPos("qb_" .. name, btn)
    local drag = self:_makeDraggable(btn, "qb_" .. name)

    local function refresh()
        local on = toggle and toggle.Get() or false
        local theme = self:_theme()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = on and theme.Accent or BG_PANEL }):Play()
        btn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or TEXT_COLOR
        stroke.Color = theme.Accent
    end
    refresh()

    btn.MouseButton1Click:Connect(function()
        if drag.moved then drag.moved = false return end
        self:_play("Click")
        if toggle then toggle.Set(not toggle.Get())
        elseif cfg.Callback then cfg.Callback() end
        refresh()
    end)

    if toggle then -- состояние тумблера может поменяться из меню/клавиши/конфига — следим
        task.spawn(function()
            local last
            while btn.Parent do
                local s = toggle.Get()
                if s ~= last then last = s refresh() end
                task.wait(0.15)
            end
        end)
    end

    table.insert(self._quickButtons, btn)
    table.insert(self.Elements, { Type = "QuickButton", Instance = btn, UpdateTheme = refresh })
    return { Instance = btn, Destroy = function() btn:Destroy() end, SetVisible = function(v) btn.Visible = v and true or false end }
end

function Library:SetQuickButtonsVisible(v)
    v = v and true or false
    self._quickVisible = v
    for _, b in ipairs(self._quickButtons) do
        if b.Parent then b.Visible = v end
    end
    self:_persist("_quick_visible", v)
end

-- ------------------------------------------------------------
-- Готовая вкладка настроек: тема, светлая тема, акцент, масштаб, язык, звуки, оверлеи, профили.
-- Window:CreateSettingsTab()  или  Window:CreateSettingsTab({ Name = "Настройки", Icon = "⚙️" })
-- ------------------------------------------------------------
function Library:CreateSettingsTab(opts)
    opts = opts or {}
    local win = self
    local function t(k) return win:_t(k) end
    local tab = self:CreateTab({ Name = opts.Name or t("set_title"), Icon = opts.Icon or "⚙️", Group = opts.Group })

    tab:CreateSection({ Text = t("set_ui") })
    tab:CreateDropdown({
        Name = t("set_theme"), Options = self:GetThemes(), CurrentOption = self._themeKey,
        Callback = function(key) win:SetTheme(key) end,
    })
    tab:CreateColorPicker({
        Name = t("set_accent"), CurrentValue = self:_theme().Accent,
        Callback = function(c) win:SetAccentColor(c) end,
    })
    tab:CreateToggle({
        Name = t("set_light"), CurrentValue = currentPalette == "light",
        Callback = function(v) win:SetLightMode(v) end,
    })
    tab:CreateSlider({
        Name = t("set_scale"), Min = 0.5, Max = 1.5, Increment = 0.05, CurrentValue = self._scale,
        Callback = function(v) win:SetScale(v) end,
    })
    tab:CreateToggle({
        Name = t("set_handle"), CurrentValue = self._handleEnabled,
        Callback = function(v) win:SetDragHandle(v) end,
    })
    tab:CreateToggle({
        Name = t("set_particles"), CurrentValue = self._particlesEnabled,
        Callback = function(v) win:SetParticles(v) end,
    })
    tab:CreateToggle({
        Name = t("set_rainbow"), CurrentValue = self._glowMode == "rainbow",
        Callback = function(v) win:SetGlowMode(v and "rainbow" or "theme") end,
    })
    tab:CreateToggle({
        Name = t("set_clicks"), CurrentValue = self._clickFx.Enabled,
        Callback = function(v) win:SetClickEffect(v) end,
    })
    tab:CreateDropdown({
        Name = t("set_click_style"), Options = { "Rings", "Pulse", "Burst", "Focus" }, CurrentOption = self._clickFx.Style,
        Callback = function(s) win:SetClickEffect({ Style = s }) end,
    })
    tab:CreateToggle({
        Name = t("set_sound"), CurrentValue = self._soundsEnabled,
        Callback = function(v) win:SetSoundsEnabled(v) end,
    })
    tab:CreateSlider({
        Name = t("set_volume"), Min = 0, Max = 1, Increment = 0.05, CurrentValue = self._soundVolume,
        Callback = function(v) win:SetSoundVolume(v) end,
    })
    tab:CreateKeybind({
        Name = t("set_hotkey"), CurrentKeybind = self:GetHotkey(),
        Callback = function(k) win:SetHotkey(k) end,
    })
    tab:CreateDropdown({
        Name = t("set_lang"), Options = { "ru", "en" }, CurrentOption = self._lang,
        Callback = function(l) win:SetLanguage(l) end,
    })
    tab:CreateLabel({ Text = t("set_lang_note") })

    tab:CreateSection({ Text = t("set_overlay") })
    tab:CreateToggle({
        Name = t("set_quick"), CurrentValue = self._quickVisible,
        Callback = function(v) win:SetQuickButtonsVisible(v) end,
    })
    tab:CreateToggle({
        Name = t("set_wm"), CurrentValue = self._watermark ~= nil,
        Callback = function(v) win:SetWatermarkVisible(v) end,
    })
    tab:CreateToggle({
        Name = t("set_kb"), CurrentValue = self._kbList ~= nil,
        Callback = function(v) win:SetKeybindListVisible(v) end,
    })
    tab:CreateButton({ Name = t("set_reset_pos"), Callback = function() win:ResetPosition() end })
    tab:CreateButton({ Name = t("set_reset_size"), Callback = function() win:ResetSize() end })

    self:CreateConfigManager(tab)
    return tab
end

-- ============================================================
-- PATCH: avatar + shine
-- ============================================================
local _origCreateWindow = Library.CreateWindow
function Library:CreateWindow(config)
    local w = _origCreateWindow(self, config)
    if w.Avatar then
        task.spawn(function()
            local ok, content = pcall(function()
                return Players:GetUserThumbnailAsync(
                    LocalPlayer.UserId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size100x100
                )
            end)
            if ok and content and w.Avatar.Parent then w.Avatar.Image = content end
        end)
    end
    task.spawn(function()
        local t = 0
        while w.ScreenGui and w.ScreenGui.Parent do
            local dt = RunService.Heartbeat:Wait()
            t = t + dt
            w:_animate(dt, t)
        end
    end)
    return w
end

return Library
