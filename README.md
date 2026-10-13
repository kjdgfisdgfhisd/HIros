# HIros UI Library 6.3

Библиотека меню для Roblox: окно с вкладками, 20+ видов элементов, 21 тема (есть светлая), конфиги,
звуки, поиск по всем вкладкам, оверлеи и полная поддержка телефонов. Подходит и скриптерам, и тем,
кто собирает плейсы.

## Установка

```lua
local HIros = loadstring(game:HttpGet("https://ВАША_ССЫЛКА/HIros_library.lua"))()
```

## Минимальный пример

```lua
local Window = HIros:CreateWindow({ Name = "MyHub", Theme = "Ocean", ConfigName = "MyHub", Shoutout = false })
local Tab    = Window:CreateTab({ Name = "Игрок", Icon = "🏃" })

Tab:CreateToggle({ Name = "Бесконечный прыжок", Flag = "infjump", Quick = true,
    Callback = function(on) print("infjump", on) end })

Tab:CreateSlider({ Name = "Скорость", Flag = "speed", Min = 16, Max = 200, CurrentValue = 16,
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end })

Window:CreateSettingsTab()   -- готовая вкладка настроек (тема, язык, звуки, оверлеи, профили)
```

Меню открывается кнопкой ⚡ (её можно перетащить) или клавишей `RightShift`.

## Настройки окна (`CreateWindow`)

| Параметр | Значение | Что делает |
|---|---|---|
| `Name` | строка | Заголовок окна |
| `Theme` | ключ темы | Тема по умолчанию (выбор игрока важнее) |
| `Light` | `true/false` | Светлая тема по умолчанию |
| `ConfigName` | строка | Отдельный файл конфига для вашего скрипта (`HIros_<имя>.json`) |
| `Language` | `"ru"`, `"en"`, `"auto"` | Язык встроенных текстов |
| `Search` | `false` | Отключить строку поиска |
| `Particles` | `false` | Отключить частицы |
| `GlowMode` | `"rainbow"` | Радужное свечение |
| `ClickEffect` | `true` или таблица | Кружки на месте кликов (`Style`, `Color`, `Size`, ...) |
| `Sounds` | `false` или таблица | Свои звуки / громкость |
| `Watermark` | `true` или `{ Text, FPS, Ping, Player }` | Водяной знак с FPS и пингом |
| `KeybindList` | `true` или таблица | Список включённых клавиш на экране |
| `Mobile` | `true/false` | Принудительно включить/выключить режим телефона |
| `DragHandle` | `false` | Убрать белую полоску-ручку под окном |
| `Shoutout` | `false` | Отключить попап «поделиться в Discord» |

Всё, что игрок выбрал сам (тема, акцент, светлая тема, язык, масштаб, размер и позиция окна, оверлеи,
эффект кликов, звуки), **запоминается** и важнее настроек скрипта.

## Элементы

Все элементы создаются у вкладки (`Tab:CreateXxx`) или у аккордеона.
Общие поля: `Name`, `Flag` (сохранение в конфиг), `Order`, `Callback`.

| Метод | Особые поля |
|---|---|
| `CreateButton` | `Confirm`, `ConfirmText`, `Tooltip`, `Badge`, `Hotkey` |
| `CreateToggle` | `CurrentValue`, `Description`, `Hotkey`, `Quick`, `AutoExecute` |
| `CreateSlider` | `Min`, `Max`, `Increment` (можно 0.1, 0.05), `Suffix`, `NumberInput` |
| `CreateDropdown` | `Options`, `CurrentOption`, `Search`, `MaxVisible`, `Hotkey` |
| `CreateMultiDropdown` | `Options`, `Default`, `Search`, `MaxVisible` |
| `CreateColorPicker` | `CurrentValue`, `WithAlpha` |
| `CreateInput` / `CreateTextBox` | `Placeholder`, `CurrentValue`, `Lines` |
| `CreateKeybind` | `CurrentKeybind`, `Mode`, `Changed` |
| `CreateStepper`, `CreateRadioGroup`, `CreateProgressBar`, `CreateChart`, `CreateLoader` | см. тест |
| `CreateSection`, `CreateDivider`, `CreateDividerText`, `CreateLabel`, `CreateParagraph` | оформление |
| `CreateAccordion` | `Open`; внутри те же `Create*` |

### Управление любым элементом

```lua
local t = Tab:CreateToggle({ Name = "Fly", Flag = "fly" })
t.Get()  t.Set(true)         -- значение (можно и t:Get() / t:Set(true))
t.SetName("Полёт")           -- переименовать
t.SetVisible(false)          -- спрятать
t.SetLocked(true)            -- серый и некликабельный (клавиши тоже не срабатывают)
t.Destroy()                  -- удалить

Window.Options.fly.Get()     -- реестр по Flag
Window:GetValue("fly")
```

### Длинные списки
В дропдауне больше 7 пунктов автоматически появляется поиск, а сам список прокручивается
(`MaxVisible` — сколько строк видно сразу, `Search = true/false` — вручную).

### Слайдер
Нажми на число справа и впиши точное значение. `NumberInput = false` отключает это.

### Кейбинд с режимами

```lua
Tab:CreateKeybind({ Name = "Aimbot", CurrentKeybind = Enum.KeyCode.E, Mode = "Hold", Flag = "aim",
    Changed = function(active) print("активно:", active) end })
```
Режимы: `Toggle` (переключатель), `Hold` (пока держишь), `Always` (всегда включено).
Режим меняется нажатием на плашку рядом с клавишей и запоминается. Без `Mode` кейбинд просто хранит клавишу
(`Callback(key)`), как раньше.

## Белая полоска под окном

Под окном есть белая полоска-ручка: тащишь за неё — окно двигается (его можно перетаскивать и за шапку).
При наведении она немного растёт, и по ней пробегает **блик**; пока тянешь, появляется **свечение** цвета темы
и окно слегка приподнимается. В покое это неподвижная чистая белая полоска.
Полоска работает как **магнит**: она идёт за пальцем/мышью, а окно упруго подтягивается к ней
(с лёгким отскоком), пока они связаны тонкой нитью. Если отпустить у края экрана, окно притянется обратно.
**Двойное нажатие** на полоску возвращает окно в центр. Отключить: `DragHandle = false` или `Window:SetDragHandle(false)`.

## Телефон

* Размер окна автоматически подгоняется под экран.
* Уголок `◢` справа внизу меняет размер окна (мышью и пальцем), кнопку `⚡` можно перетащить.
* Кнопки окна, строки списков и зоны слайдеров увеличены под палец; пока тянешь ползунок или цвет,
  страница не прокручивается.
* **Кнопки быстрого доступа**: круглые перетаскиваемые кнопки на экране для функций, у которых нет клавиш.
  Самый простой способ — `Quick = true` у тумблера. Вручную:
  `Window:CreateQuickButton({ Name = "Heal", Callback = fn })`. По умолчанию видны на телефоне,
  включаются в настройках или `Window:SetQuickButtonsVisible(true)`.

## Оверлеи

```lua
Window:CreateWatermark({ Text = "MyHub", Player = true })   -- FPS и пинг, перетаскивается
Window:CreateKeybindList()                                   -- включённые клавиши на экране
Window:SetWatermarkVisible(false)
Window:SetKeybindListVisible(false)
```

## Темы

21 тема: `Blue Red Yellow Green Purple Cyan Pink Orange Mint Crimson Lime Mono`
и двухцветные `Sunset Ocean Aurora Neon Sakura Gold Ice Lava Midnight`.

```lua
Window:SetTheme("Sunset")
Window:SetAccentColor(Color3.fromRGB(255, 120, 0))   -- свой цвет только для этого окна
Window:SetLightMode(true)                             -- светлый интерфейс
HIros:GetThemes()                                     -- список ключей
HIros:RegisterTheme("Моя", { Accent = Color3.fromRGB(...), Accent2 = Color3.fromRGB(...) }) -- Accent2 необязателен
```
Светлая/тёмная палитра общая для всех окон скрипта.

## Профили и конфиги

`Flag` у элемента сохраняет значение автоматически. Менеджер профилей: `Window:CreateConfigManager(Tab)`
(входит в `CreateSettingsTab`). Вручную: `SaveConfig(имя)`, `LoadConfig(имя)`, `DeleteConfig(имя)`, `GetConfigs()`.

## Язык

`Language = "ru" | "en"` в `CreateWindow` или `Window:SetLanguage("en")`. Переводятся встроенные тексты
(поиск, подтверждения, менеджер профилей, вкладка настроек). Полностью применяется после перезапуска скрипта.

## Прочее

```lua
Window:Notify({ Kind = "success", Title = "Готово", Content = "Сохранено", Duration = 3 })
Window:Confirm({ Title = "Точно?", Content = "...", Callback = function(yes) end })
Window:SetScale(1.2)   Window:SetWindowSize(640, 420)   Window:ResetPosition()   Window:ResetSize()
Window:SetHotkey(Enum.KeyCode.Insert)   Window:Search("fly")   Window:Destroy()
```

## Если что-то не работает

* Конфиги не сохраняются — у вашего экзекьютора нет `writefile`/`readfile`.
* Звук молчит — часть аудио Roblox недоступна в чужих играх; задайте свои ID через `Sounds = { Click = 123 }`.
* Ничего не появилось — проверьте, что ссылка в `loadstring` ведёт на «сырой» (raw) файл.

## Версии

* **6.3** — 21 тема, светлая тема, сохранение выбора игрока, управление элементами
  (`SetVisible/SetLocked/SetName/Destroy`, `Options`), прокрутка и поиск в списках, режимы кейбинда,
  ввод числа в слайдер, водяной знак и список клавиш, язык ru/en, изменяемый размер окна,
  поддержка телефонов (автоподгонка, быстрые кнопки, крупные зоны касания, перетаскиваемая кнопка меню).
* **6.2** — исправления: JSON конфигов (Color3, MultiDropdown), дробный шаг слайдера, отключение подключений при
  `Destroy`, тема отдельно у каждого окна, `ConfigName`, `ProgressBar` без деления на ноль.
