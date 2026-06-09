#Requires AutoHotkey v2.0
#SingleInstance Force

global QuoteLevel := 1
global QuoteMax   := 4
global ism := true 

global pitch := 660
global dot := 60       
global dash := 180      
mb(msg) {
    global pitch, dot, dash
    local last := ""
    for char in StrSplit(msg) {
        if (char = ".") {
            SoundBeep(pitch, dot)
            Sleep(dot)
        } else if (char = "-") {
            SoundBeep(pitch, dash)
            Sleep(dot)
        } else if (char = " ") {
            Sleep(dot * 3) 
        }
    }
}
ma(n) {
    morseMap := Map(
        1, ".----",
        2, "..---",
        3, "...--",
        4, "....-"
    )

    if morseMap.Has(n)
        mb(morseMap[n])
}

QuoteLeft := [
    "{U+00AB}{U+00A0}",  
    "{U+201E}{U+00A0}",  
    "{U+201C}{U+00A0}",  
    "{U+201D}{U+00A0}"   
]

QuoteRight := [
    "{U+00A0}{U+00BB}",  
    "{U+00A0}{U+201E}",  
    "{U+00A0}{U+201C}",  
    "{U+00A0}{U+201E}"   
]

:*?:":: {
    global ism, QuoteLevel, QuoteLeft
    if !ism {
        SendInput("{U+0022}")
        return
    }
    SendInput(QuoteLeft[QuoteLevel])
    return
}

+":: {
    global ism, QuoteLevel, QuoteRight
    if !ism {
        SendInput("{U+0022}")
        return
    }
    SendInput(QuoteRight[QuoteLevel])
    return
}

^!":: {
    global ism, QuoteLevel, QuoteMax, QuoteLeft
    if !ism {
        SendInput("{U+0022}")
        return
    }
    if QuoteLevel < QuoteMax
        QuoteLevel++
    SendInput(QuoteLeft[QuoteLevel])
    ma(QuoteLevel)
    return
}

^":: {
    global ism, QuoteLevel, QuoteRight
    if !ism {
        SendInput("{U+0022}")
        return
    }
    SendInput(QuoteRight[QuoteLevel])
    ma(QuoteLevel)
    if QuoteLevel > 1
        QuoteLevel--
    return
}
!":: {
    global ism
    ism := !ism

    if ism {
        mb("--- -.")
		Sleep 420
		ma(QuoteLevel)
    } else {
        mb("--- ..-. ..-.")
    }
    return
}

:?:'s::’s
:?:'m::’m
:?:'ll::’ll
:?:'ve::’ve
:?:'re::’re
:C*?:'t::‘t
:C*?:'h::‘
:*?: ,::
{
    SendInput("{U+00A0},")
    return
}
:*?: `;::
{
    SendInput("{U+00A0}{U+003B}")
    return
}

:*?: `:::  
{
    SendInput("{U+00A0}{U+003A}")
    return
}

:CO?*: !?::
{
    SendInput("{U+00A0}⁉")
    return
}
:CO?*: ?!::
{
    SendInput("{U+00A0}⁈")
    return
}
:*?: ! ::  
{
    SendInput("{U+00A0}{U+0021} ")
    return
}
:*?: ? ::  
{
    SendInput("{U+00A0}? ")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:*?: / ::  
{
    SendInput("{U+00A0}/{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:*?: - ::  
{
    SendInput("{U+00A0}—{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:*?: -- ::  
{
    SendInput("{U+00A0}{U+2E3A}{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:*?: --- ::  
{
    SendInput("{U+00A0}{U+2E3B}{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:( ::( 
:C*?: ):: )
:C*?:[ ::[ 
:C*?: ]:: ]

:*?:...::…
:C*?:_micro::µ
:C*?:_st::ˢᵗ
:C*?:_nd::ⁿᵈ
:C*?:_rd::ʳᵈ
:C*?:_th::ᵗʰ
::summonme::I prithee , You shan't hesitate to summon Me at Thine Earlieﬆ convenience.
:C*?:paragraph ::{
	Send "§{U+00A0}"
}
:C*?:paragraphs ::{
	Send "§§{U+00A0}"
}
:C*?:numero ::
{
    Send "{U+2116}{U+00A0}"
    return
}
:C*?:numeri ::
{
    Send "№ⁱ "
    return
}
:C*?:numeris ::
{
    Send "№ⁱˢ "
    return
}
:C*?:numerorum ::
{
    Send "№ʳᵘᵐ "
    return
}
:C*?:numerus ::
{
    Send "№ᵘˢ "
    return
}
:C*?:numerum ::
{
    Send "№ᵘᵐ "
    return
}
:C*?:numeros ::
{
    Send "№ˢ "
    return
}

:*?:NUMEROHELP::
{
    ShowNumeroHelp()
    return
}

ShowNumeroHelp()
{
    helpText := "
    (
		QUESTIONS TO ASK :
		1. Plural or Singular ?
		2. What case function — subject , poſseßion , indirect object , direct object , or means ?

		IF SG. & :
		⸺ Nominative , „ numerus „ — « The №ᵘˢ of participants is increasing. ».
		⸺ Genitive , write „ numeri „ — e.g./ « The size of №ⁱ is significant. ».
		⸺ Dative , write „ numero „ — e.g./ « I aßigned the code № 3. ».
		⸺ Accusative , write „ numerum „ — e.g./ « I marked the №ᵘᵐ 7 on the list. ».
		⸺ Ablative , write „ numero „  — e.g./ « The letter was sent by № 9. ».

		IF PL. & :
		⸺ Nominative , write „ numeri „ — e.g./ « The №ⁱ on the chart have been updated. ».
		⸺ Genitive , write „ numerorum „ — e.g./ « The significance of №ʳᵘᵐ increases. ».
		⸺ Dative , write „ numeris „ — « This was given to the №ⁱˢ. ».
		⸺ Accusative , write „ numeros „ — e.g./ « We reviewed the №ˢ 10 to 20. ».
		⸺ Ablative , write „ numeris „ — e.g./ « The data was sorted by Uniquͤ №ⁱˢ. ».
    )"
    
    
    helpGui := Gui("+AlwaysOnTop +ToolWindow", "LATIN CASE REFERENCE FOR „ NUMERO „ :")
    helpGui.BackColor := "0x000000" 
    helpGui.MarginX := 20
    helpGui.MarginY := 20
    
    textCtrl := helpGui.Add("Text", "cWhite w600 h400", helpText)
	textCtrl.SetFont("s12", "Junicode VF")
	textCtrl.SetFont("s12", "Times New Roman")
    
    okBtn := helpGui.Add("Button", "w100 h30 x250 y430", "OK")
    okBtn.OnEvent("Click", (*) => helpGui.Destroy())
    
    helpGui.Show("w640 h480")
}
::ineedtogo::I am afraid I muﬆ now take My leave.
::illbeback::I shall return sꝏn , do — please — remain here a moment.
::idk::Mine heart confeßes that I , surely , am at a loſs.
::gmfriend::Gꝏd morning , My Dear friend — Hꜹe a Peaceful dꜽ. Hugs.
::gmenemy::Gꝏd morning , Mine Eﬆeemed enemy : I wish unto You a Pleasant dꜽ.
::gmenemybad::Gꝏd morning , My Despicable enemy : I wish unto You a Disaﬆrous dꜽ.



Loop 10 {
    outerNum := A_Index - 1 
    Loop 10 {
        innerNum := A_Index - 1  
        Hotstring(":C*?:" . outerNum . "/" . innerNum, outerNum . "⁄" . innerNum)
    }
}
:*?:0 ::
{
    SendInput("0{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:1 ::
{
    SendInput("1{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:2 ::
{
    SendInput("2{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:3 ::
{
    SendInput("3{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:4 ::
{
    SendInput("4{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:5 ::
{
    SendInput("5{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:6 ::
{
    SendInput("6{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:7 ::
{
    SendInput("7{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:8 ::
{
    SendInput("8{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:9 ::
{
    SendInput("9{U+00A0}")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:*?:-*::‑
:*?:<->::↔
:*?:->::→
:*?:<-::←

arrowOptions := Map(
    "up", "↑",
    "down", "↓",
    "notleft", "↚",
    "left", "←",
    "notright", "↛",
    "right", "→",
    "both", "↔",
    "notboth", "↮",
    "updown", "↕",
    "updownsep", "⇅",
    "upleft", "↖",
    "upright", "↗",
    "downleft", "↙",
    "downright", "↘",
    "trbl", "⇄",
    "tlbr", "⇆",
    "metro", "⇋"
)
turnedOptions := Map(
    "ul", "↰",
    "dl", "↲",
    "ur", "↱",
    "dr", "↳",
    "gou", "⭜",
    "god", "⭝",
)
directionOptions := Map(
    "dup", "🡹",
    "dright", "🡺",
    "ddown", "🡻",
    "dtl", "🡼",
    "dtr", "🡽",
    "ddr", "🡾",
    "ddl", "🡿"
)

crossingOptions := Map(
    "udrcroß", "⤭",
    "durcroß", "⤮",
    "rurcroß", "⤱",
    "lulcroß", "⤲"
)

circleOptions := Map(
    "leftg", "⟲",
    "rightg", "⟳",
    "rightu", "↻",
    "leftu", "↺",
    "leftc", "⥀",
    "rightc", "⥁"
)

uncertainOptions := Map(
    "ul", "⇠",
    "uu", "⇡",
    "ur", "⇢",
    "ud", "⇣"
)

autocompleteActive := false
currentMenu := "main"
currentOptions := []
selectedIndex := 0

categoriesarrow := Map(
    "Direction !", "direction",
    "Croßings !", "crossings",
    "Circles !", "circles",
    "Un-certain !", "uncertain",
    "Turned !", "turned"
)

:C*O?:menuarrow::
{
    global
    autocompleteActive := true
    currentMenu := "main"
    selectedIndex := 0
    ShowMainMenu()
}

ShowMainMenu() {
    global
    
    currentOptions := []
    suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
    
    for key, symbol in arrowOptions {
        currentOptions.Push({key: key, symbol: symbol, type: "arrow"})
        prefix := (currentOptions.Length == selectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
    }
    for categoryName, categoryKey in categoriesarrow {
        currentOptions.Push({key: categoryName, symbol: "", type: "menu", menuKey: categoryKey})
        prefix := (currentOptions.Length == selectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . categoryName . "`n"
    }
    
    ToolTip(suggestions, , , 1)
}

ShowSubmenu(menuType) {
    global
    
    currentOptions := []
    local menuOptions := ""
    local menuTitle := ""
    
    switch menuType {
        case "direction":
            menuOptions := directionOptions
            menuTitle := "Direction Arrows"
        case "crossings":
            menuOptions := crossingOptions
            menuTitle := "Crossing Arrows"
        case "circles":
            menuOptions := circleOptions
            menuTitle := "Circle Arrows"
        case "uncertain":
            menuOptions := uncertainOptions
            menuTitle := "Uncertain Arrows"
        case "turned":
            menuOptions := turnedOptions
            menuTitle := "Turned Arrows"
    }
    
    suggestions := menuTitle . "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , & „ → „ for ſub-menus.`n"
    
    for key, symbol in menuOptions {
        currentOptions.Push({key: key, symbol: symbol, type: "arrow"})
        prefix := (currentOptions.Length == selectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
    }
    
    ToolTip(suggestions, , , 1)
}

#HotIf autocompleteActive

Up::
{
    global
    if (currentOptions.Length > 0) {
        selectedIndex := selectedIndex - 1
        if (selectedIndex < 0) {
            selectedIndex := currentOptions.Length - 1
        }
        UpdateDisplay()
    }
}

Down::
{
    global
    if (currentOptions.Length > 0) {
        selectedIndex := Mod(selectedIndex + 1, currentOptions.Length)
        UpdateDisplay()
    }
}

Right::
{
    global
    if (currentOptions.Length > 0 && selectedIndex < currentOptions.Length) {
        selectedOption := currentOptions[selectedIndex + 1]
        if (selectedOption.type == "menu") {
            currentMenu := selectedOption.menuKey
            selectedIndex := 0
            ShowSubmenu(currentMenu)
        }
    }
}

Left::
{
    global
    if (currentMenu != "main") {
        currentMenu := "main"
        selectedIndex := 0
        ShowMainMenu()
    }
}

Enter::
{
    global
    if (currentOptions.Length > 0 && selectedIndex < currentOptions.Length) {
        selectedOption := currentOptions[selectedIndex + 1]
        
        if (selectedOption.type == "arrow") {
            backspaceCount := 0
            Send("{Backspace " . backspaceCount . "}")
            Send(selectedOption.symbol)
            
            autocompleteActive := false
            ToolTip("", , , 1)
        } else if (selectedOption.type == "menu") {
            currentMenu := selectedOption.menuKey
            selectedIndex := 0
            ShowSubmenu(currentMenu)
        }
    }
}

Escape::
{
    global
    autocompleteActive := false
    ToolTip("", , , 1)
}

Backspace::
{
    global
    siAutocompleteActive := false
    ToolTip("", , , 1)
}
Space::
{
    global
    autocompleteActive := false
    ToolTip("", , , 1)
    Send(" ")
}

#HotIf

UpdateDisplay() {
    global
    if (currentMenu == "main") {
        ShowMainMenu()
    } else {
        ShowSubmenu(currentMenu)
    }
}

for key, symbol in arrowOptions {
    Hotstring(":CO*?:arrow" . key, symbol)
}

for key, symbol in directionOptions {
    Hotstring(":CO*?:arrow" . key, symbol)
}

for key, symbol in crossingOptions {
    Hotstring(":CO*?:arrow" . key, symbol)
}

for key, symbol in circleOptions {
    Hotstring(":CO*?:arrow" . key, symbol)
}

for key, symbol in uncertainOptions {
    Hotstring(":CO*?:arrow" . key, symbol)
}
for key, symbol in turnedOptions {
    Hotstring(":CO*?:arrow" . key, symbol)
}

~LButton::
~RButton::
{
    global
    if (autocompleteActive) {
        autocompleteActive := false
        ToolTip("", , , 1)
    }
}



logicOptions := Map(
    "and", "∧",
    "or", "∨",
    "multiply", "×",
    "approx", "≈",
    "notequal", "≠",
    "all", "∀",
    "ex", "∃",
    "notex", "∄",
    "in", "∈",
    "isnt", "̸",
    "notin", "∉",
    "notleß", "≮",
    "leß", "{U+003C}",
    "more", ">",
    "notmore", "≯",
    "contains", "∋",
    "containsnot", "∌",
    "null", "∅",
    "notapprox", "≉",
    "congruent", "≅",
    "equivalent", "≡",
    "nand", "⊼",
    "nor", "⊽",
    "therefore", "∴",
    "because", "∵",
    "not", "¬"
)

logicAutocompleteActive := false
logicCurrentOptions := []
logicSelectedIndex := 0

:C*O?:menuloggic::
{
    global
    logicAutocompleteActive := true
    logicSelectedIndex := 0
    ShowLogicMenu()
}

ShowLogicMenu() {
    global
    
    logicCurrentOptions := []
    suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select.`n"
    
    for key, symbol in logicOptions {
        logicCurrentOptions.Push({key: key, symbol: symbol, type: "logic"})
        prefix := (logicCurrentOptions.Length == logicSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
    }
    
    ToolTip(suggestions, , , 1)
}

#HotIf logicAutocompleteActive

Up::
{
    global
    if (logicCurrentOptions.Length > 0) {
        logicSelectedIndex := logicSelectedIndex - 1
        if (logicSelectedIndex < 0) {
            logicSelectedIndex := logicCurrentOptions.Length - 1
        }
        ShowLogicMenu()
    }
}

Down::
{
    global
    if (logicCurrentOptions.Length > 0) {
        logicSelectedIndex := Mod(logicSelectedIndex + 1, logicCurrentOptions.Length)
        ShowLogicMenu()
    }
}

Enter::
{
    global
    if (logicCurrentOptions.Length > 0 && logicSelectedIndex < logicCurrentOptions.Length) {
        selectedOption := logicCurrentOptions[logicSelectedIndex + 1]
        
        if (selectedOption.type == "logic") {
            backspaceCount := 0
            Send("{Backspace " . backspaceCount . "}")
            Send(selectedOption.symbol)
            
            logicAutocompleteActive := false
            ToolTip("", , , 1)
        }
    }
}

Escape::
{
    global
    logicAutocompleteActive := false
    ToolTip("", , , 1)
}

Backspace::
{
    global
    siAutocompleteActive := false
    ToolTip("", , , 1)
}
Space::
{
    global
    logicAutocompleteActive := false
    ToolTip("", , , 1)
    Send(" ")
}

#HotIf

for key, symbol in logicOptions {
    Hotstring(":C*O?:loggic" . key, symbol)
}


:CO*?: v. ::
{
    Send "{U+00A0}{U+1D463}{U+2024}{U+00A0}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:?O:gra::α
:?O:grb::β
:?O:grg::γ
:?O:grd::δ
:?O:gre::ε
:?O:grz::ζ
:?O:grth::θ
:?O:gri::ι
:?O:grk::κ
:?O:grl::λ
:?O:grm::μ
:?O:grn::ν
:?O:grx::ξ
:?O:gro::ο
:?O:grp::π
:?O:grr::ρ
:?O:grs::σ
:?O:grt::τ
:?O:gru::υ
:?O:grph::φ
:?O:grch::χ
:?O:grps::ψ
:?O:gromega::ω
:*O?:letterth::þ
:*O?:letterdh::ð
:C*?:ij::ĳ
:C*?:IJ::Ĳ
:C*?:ffi::ﬃ
:C*?:ffl::ﬄ
:C*?:fi::ﬁ
:C*?:fl::ﬂ
:C*?:fau::fꜷ
:C*?:ffa::ﬀa
:C*?:ffb::ﬀb
:C*?:ffc::ﬀc
:C*?:ffd::ﬀd
:C*?:ffe::ﬀe
:C*?:fff::ﬀf
:C*?:ffg::ﬀg
:C*?:ffh::ﬀh
:C*?:ffj::ﬀj
:C*?:ffk::ﬀk
:C*?:ffm::ﬀm
:C*?:ffn::ﬀn
:C*?:ffo::ﬀo
:C*?:ffp::ﬀp
:C*?:ffq::ﬀq
:C*?:ffr::ﬀr
:C*?:ffs::ﬀs
:C*?:fft::ﬀt
:C*?:ffu::ﬀu
:C*?:ffv::ﬀv
:C*?:ffw::ﬀw
:C*?:ffx::ﬀx
:C*?:ffy::ﬀy
:C*?:ffz::ﬀz
:C*?:ff ::
{
    Send "{U+FB00}{U+0020}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:C*?: terticolon::
{
    Send "{U+00A0}{U+F56C}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:C*?: quarticolon::
{
    Send "{U+00A0}{U+F56B}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}


Loop 26 {
    letter := Chr(96 + A_Index) 
    
    if (letter = "z") {
        Hotstring(":C*?:S" . letter, "ſʒ")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    }if (letter = "t") {
        Hotstring(":C*?:S" . letter, "ﬅ")
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    } else {
        Hotstring(":C*?:S" . letter, "ʃ" . letter)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    }
}
:C*?:st::
{
    if !ism
    {
        Send "{U+0073}{U+0074}"
        return 
    }
	Send "{U+FB06}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
}
:C*?:ss::
{
    if !ism
    {
        Send "ss"
        return
    }

    rand := Random(0, 1)
    
    if (rand = 0) {
        Send "ſs"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    } else {
        Send "ß"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    }
	return
}
:*?:sz::
{
    if !ism
    {
        Send "sz"
        return
    }
	Send "ſʒ"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
}

:C*?:AO::
{
    if !ism
    {
        Send "{U+0041}{U+004F}"
        return
    }
    Send "{U+A734}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:C*?:ao::
{
    if !ism
    {
        Send "{U+0061}{U+006F}"
        return
    }
    Send "{U+A735}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:AU::
{
    if !ism
    {
        Send "{U+0041}{U+0055}"
        return
    }
    Send "{U+A736}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:C*?:au::
{
    if !ism
    {
        Send "{U+0061}{U+0075}"
        return
    }
    Send "{U+A737}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:AV::
{
    if !ism
    {
        Send "{U+0041}{U+0056}"
        return
    }
    Send "{U+A738}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:C*?:lz::
{
    if !ism
    {
        Send "{U+006C}{U+007A}"
        return
    }
    Send "{U+026E}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:lj::
{
    if !ism
    {
        Send "{U+006C}{U+006A}"
        return
    }
    Send "{U+01C9}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:LJ::
{
    if !ism
    {
        Send "{U+004C}{U+004A}"
        return
    }
    Send "{U+01C7}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:Lj::
{
    if !ism
    {
        Send "{U+004C}{U+006A}"
        return
    }
    Send "{U+01C8}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:NJ::
{
    if !ism
    {
        Send "{U+004E}{U+004A}"
        return
    }
    Send "{U+01CA}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:Nj::
{
    if !ism
    {
        Send "{U+004E}{U+006A}"
        return
    }
    Send "{U+01CB}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:nj::
{
    if !ism
    {
        Send "{U+006E}{U+006A}"
        return
    }
    Send "{U+01CC}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}

:C*?:av::
{
    if !ism
    {
        Send "{U+0061}{U+0076}"
        return
    }
    Send "{U+A739}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:C*?:AY::
{
    if !ism
    {
        Send "{U+0041}{U+0059}"
        return
    }
    Send "{U+A73C}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
    return
}
:C*?:ay::
{
   if !ism
   {
       Send "{U+0061}{U+0079}"
       return
   }
   Send "{U+A73D}"
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0)
   DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0)
   return
}

:C*?:Hv::
{
    if !ism
    {
        Send "{U+0048}{U+0076}"
        return
    }
    Send "{U+01F6}"
    return
}
:C*?:hv::
{
    if !ism
    {
        Send "{U+0068}{U+0076}"
        return
    }
    Send "{U+0195}"
    return
}

:C*?:OO::
{
    if !ism
    {
        Send "{U+004F}{U+004F}"
        return
    }
    Send "{U+A74E}"
    return
}
:C*?:oo::
{
    if !ism
    {
        Send "{U+006F}{U+006F}"
        return
    }
    Send "{U+A74F}"
    return
}
:C*?:VY::
{
    if !ism
    {
        Send "{U+0056}{U+0059}"
        return
    }
    Send "{U+A760}"
    return
}
:C*?:vy::
{
    if !ism
    {
        Send "{U+0076}{U+0079}"
        return
    }
    Send "{U+A761}"
    return
}

:?OC: eg::{
    Send "e.g./ "
    return
}
:?OC: ie::{
    Send "i.e./ "
    return
}
:?OC: ai::{
    Send "a.i./ "
    return
}

:C*?:az ::
{
	Send "aʒ "
}
:C*?:bz ::
{
	Send "bʒ "
}
:C*?:cz ::
{
	Send "cʒ "
}
:C*?:dz ::
{
	Send "dʒ "
}
:C*?:ez ::
{
	Send "eʒ "
}
:C*?:fz ::
{
	Send "fʒ "
}
:C*?:gz ::
{
	Send "gʒ "
}
:C*?:hz ::
{
	Send "hʒ "
}
:C*?:iz ::
{
	Send "iʒ "
}
:C*?:jz ::
{
	Send "jʒ "
}
:C*?:kz ::
{
	Send "kʒ "
}
:C*?:lz ::
{
	Send "lʒ "
}
:C*?:mz ::
{
	Send "mʒ "
}
:C*?:nz ::
{
	Send "nʒ "
}
:C*?:oz ::
{
	Send "oʒ "
}
:C*?:pz ::
{
	Send "pʒ "
}
:C*?:qz ::
{
	Send "qʒ "
}
:C*?:rz ::
{
	Send "rʒ "
}
:C*?:TZ::
{
    if !ism
    {
        Send "{U+0054}{U+005A}"
        return
    }
    Send "{U+A728}"
    return
}
:C*?:Tz::
{
    if !ism
    {
        Send "{U+0054}{U+005A}"
        return
    }
    Send "{U+A728}"
    return
}
:C*?:tz::
{
    if !ism
    {
        Send "{U+0074}{U+007A}"
        return
    }
    Send "{U+A729}"
    return
}
:C*?:uz ::
{
	Send "uʒ "
}
:C*?:vz ::
{
	Send "vʒ "
}
:C*?:wz ::
{
	Send "wʒ "
}
:C*?:xz ::
{
	Send "xʒ "
}
:C*?:yz ::
{
	Send "yʒ "
}	
:C*?:zz ::
{
	Send "ʒʒ "
}
:?O:~~::〜
:*C?O:a_e::aͤ
:*C?O:o_e::oͤ
:*C?O:u_e::uͤ
:*C?O:y_e::yͤ
::oz::℥
::ounce::℥
:C*?O:_00::⁰
:C*?O:_01::¹
:C*?O:_02::²
:C*?O:_03::³
:C*?O:_04::⁴
:C*?O:_05::⁵
:C*?O:_06::⁶
:C*?O:_07::⁷
:C*?O:_08::⁸
:C*?O:_09::⁹
:C*?O:_10::¹⁰
:C*?O:_11::¹¹
:C*?O:_12::¹²
:C*?O:_13::¹³
:C*?O:_14::¹⁴
:C*?O:_15::¹⁵
:C*?O:_16::¹⁶
:C*?O:_17::¹⁷
:C*?O:_18::¹⁸
:C*?O:_19::¹⁹
:C*?O:_20::²⁰
:C*?O:_21::²¹
:C*?O:_22::²²
:C*?O:_23::²³
:C*?O:_24::²⁴
:C*?O:_25::²⁵
:C*?O:_26::²⁶
:C*?O:_27::²⁷
:C*?O:_28::²⁸
:C*?O:_29::²⁹
:C*?O:_30::³⁰
:C*?O:_31::³¹
:C*?O:_32::³²
:C*?O:_33::³³
:C*?O:_34::³⁴
:C*?O:_35::³⁵
:C*?O:_36::³⁶
:C*?O:_37::³⁷
:C*?O:_38::³⁸
:C*?O:_39::³⁹
:C*?O:_40::⁴⁰
:C*?O:_41::⁴¹
:C*?O:_42::⁴²
:C*?O:_43::⁴³
:C*?O:_44::⁴⁴
:C*?O:_45::⁴⁵
:C*?O:_46::⁴⁶
:C*?O:_47::⁴⁷
:C*?O:_48::⁴⁸
:C*?O:_49::⁴⁹
:C*?O:_50::⁵⁰
:C*?O:_51::⁵¹
:C*?O:_52::⁵²
:C*?O:_53::⁵³
:C*?O:_54::⁵⁴
:C*?O:_55::⁵⁵
:C*?O:_56::⁵⁶
:C*?O:_57::⁵⁷
:C*?O:_58::⁵⁸
:C*?O:_59::⁵⁹
:C*?O:_60::⁶⁰
:C*?O:_61::⁶¹
:C*?O:_62::⁶²
:C*?O:_63::⁶³
:C*?O:_64::⁶⁴
:C*?O:_65::⁶⁵
:C*?O:_66::⁶⁶
:C*?O:_67::⁶⁷
:C*?O:_68::⁶⁸
:C*?O:_69::⁶⁹
:C*?O:_70::⁷⁰
:C*?O:_71::⁷¹
:C*?O:_72::⁷²
:C*?O:_73::⁷³
:C*?O:_74::⁷⁴
:C*?O:_75::⁷⁵
:C*?O:_76::⁷⁶
:C*?O:_77::⁷⁷
:C*?O:_78::⁷⁸
:C*?O:_79::⁷⁹
:C*?O:_80::⁸⁰
:C*?O:_81::⁸¹
:C*?O:_82::⁸²
:C*?O:_83::⁸³
:C*?O:_84::⁸⁴
:C*?O:_85::⁸⁵
:C*?O:_86::⁸⁶
:C*?O:_87::⁸⁷
:C*?O:_88::⁸⁸
:C*?O:_89::⁸⁹
:C*?O:_90::⁹⁰
:C*?O:_91::⁹¹
:C*?O:_92::⁹²
:C*?O:_93::⁹³
:C*?O:_94::⁹⁴
:C*?O:_95::⁹⁵
:C*?O:_96::⁹⁶
:C*?O:_97::⁹⁷
:C*?O:_98::⁹⁸
:C*?O:_99::⁹⁹
:C*?O:sub00::₀
:C*?O:sub01::₁
:C*?O:sub02::₂
:C*?O:sub03::₃
:C*?O:sub04::₄
:C*?O:sub05::₅
:C*?O:sub06::₆
:C*?O:sub07::₇
:C*?O:sub08::₈
:C*?O:sub09::₉
:C*?O:sub10::₁₀
:C*?O:sub11::₁₁
:C*?O:sub12::₁₂
:C*?O:sub13::₁₃
:C*?O:sub14::₁₄
:C*?O:sub15::₁₅
:C*?O:sub16::₁₆
:C*?O:sub17::₁₇
:C*?O:sub18::₁₈
:C*?O:sub19::₁₉
:C*?O:sub20::₂₀
:C*?O:sub21::₂₁
:C*?O:sub22::₂₂
:C*?O:sub23::₂₃
:C*?O:sub24::₂₄
:C*?O:sub25::₂₅
:C*?O:sub26::₂₆
:C*?O:sub27::₂₇
:C*?O:sub28::₂₈
:C*?O:sub29::₂₉
:C*?O:sub30::₃₀
:C*?O:sub31::₃₁
:C*?O:sub32::₃₂
:C*?O:sub33::₃₃
:C*?O:sub34::₃₄
:C*?O:sub35::₃₅
:C*?O:sub36::₃₆
:C*?O:sub37::₃₇
:C*?O:sub38::₃₈
:C*?O:sub39::₃₉
:C*?O:sub40::₄₀
:C*?O:sub41::₄₁
:C*?O:sub42::₄₂
:C*?O:sub43::₄₃
:C*?O:sub44::₄₄
:C*?O:sub45::₄₅
:C*?O:sub46::₄₆
:C*?O:sub47::₄₇
:C*?O:sub48::₄₈
:C*?O:sub49::₄₉
:C*?O:sub50::₅₀
:C*?O:sub51::₅₁
:C*?O:sub52::₅₂
:C*?O:sub53::₅₃
:C*?O:sub54::₅₄
:C*?O:sub55::₅₅
:C*?O:sub56::₅₆
:C*?O:sub57::₅₇
:C*?O:sub58::₅₈
:C*?O:sub59::₅₉
:C*?O:sub60::₆₀
:C*?O:sub61::₆₁
:C*?O:sub62::₆₂
:C*?O:sub63::₆₃
:C*?O:sub64::₆₄
:C*?O:sub65::₆₅
:C*?O:sub66::₆₆
:C*?O:sub67::₆₇
:C*?O:sub68::₆₈
:C*?O:sub69::₆₉
:C*?O:sub70::₇₀
:C*?O:sub71::₇₁
:C*?O:sub72::₇₂
:C*?O:sub73::₇₃
:C*?O:sub74::₇₄
:C*?O:sub75::₇₅
:C*?O:sub76::₇₆
:C*?O:sub77::₇₇
:C*?O:sub78::₇₈
:C*?O:sub79::₇₉
:C*?O:sub80::₈₀
:C*?O:sub81::₈₁
:C*?O:sub82::₈₂
:C*?O:sub83::₈₃
:C*?O:sub84::₈₄
:C*?O:sub85::₈₅
:C*?O:sub86::₈₆
:C*?O:sub87::₈₇
:C*?O:sub88::₈₈
:C*?O:sub89::₈₉
:C*?O:sub90::₉₀
:C*?O:sub91::₉₁
:C*?O:sub92::₉₂
:C*?O:sub93::₉₃
:C*?O:sub94::₉₄
:C*?O:sub95::₉₅
:C*?O:sub96::₉₆
:C*?O:sub97::₉₇
:C*?O:sub98::₉₈
:C*?O:sub99::₉₉
:*?O:_-::⁻
:O:caret::‸
:O*?:1dagger::†
:O*?:2dagger::‡
:O*?:3dagger::※
:O*?:4dagger::∗
:O*?:5dagger::⁑
:O*?:6dagger::⁂
:O:emspace:: 
:O?:mminus::−
:O*?:bigplu::⎧   
:O*?:bigplm::⎨   
:O*?:bigpld::⎩   
:O*?:bigpe::⎪   
:O*?:bigpru::⎫
:O*?:bigprm::⎬
:O*?:bigprd::⎭
:O?:a/s::℁
:O?:a/c::℀
:CO?*:X|::╳
:CO?*:/|::⧸
:O:dele::₰
:O:ioriten::〽
:O:coronis::⸎
:O:manicule::☞
:?O:'::
{
    Send "{U+2019}"
    return
}
:CO*?:breakhere::⸿
:CO*?:1prime::′
:CO*?:2do::〃
:CO*?:2prime::″
:CO*?:3prime::‴
:CO*?:4prime::⁗
:C*?O:sub-::₋
:*?O:_+::⁺
:C*?O:sub+::₊
:*O?:jpfume::不明
:*O?:jptext::馊銚ﾉﾔﾌﾀ
:C:perthousand::‰
:C:perman::‱
:?:s-h::ſome‑how  
:?:h-e::How‑ever ;
:O*?:s-t ::
{
	Send "ſome‑thing "
}
:?:s-ti::ſome‑times
:?:s-e::ſome‑one
:?:s-w::ſome‑where
:?:n-o::No‑one
:O*?:a-t ::
{
	Send "Any‑thing "
}
:?:a-e::Any‑one
:?:a-ti::Any‑time
:?:a-m::Any‑more
:?:a-n::Any‑thing
:?:a-w::Any‑where
:?:e-t::Every‑thing
:?:e-o::Every‑one
:?:e-w::Every‑where
:?:w-e::What‑ever
:O?:u-s::Under‑ﬆand
exceptions := ["s-h", "h-e", "u-s", "s-t", "s-ti", "s-e", "s-w", "n-o", "a-t", "a-e", "a-ti", "a-n", "a-m", "a/s", "a/c", "a-w", "e-t", "e-o", "e-w", "w-e"]

Loop 52 {
    outerLetter := A_Index <= 26 ? Chr(96 + A_Index) : Chr(38 + A_Index)
    Loop 52 {
        innerLetter := A_Index <= 26 ? Chr(96 + A_Index) : Chr(38 + A_Index)
        combination := outerLetter . "-" . innerLetter
        
        isException := false
        for exception in exceptions {
            if (combination = exception) {
                isException := true
                break
            }
        }
        
        if (!isException) {
            Hotstring(":C*?:" . combination, outerLetter . "‑" . innerLetter)
        }
    }
}

Loop 52 {
    outerLetter := A_Index <= 26 ? Chr(96 + A_Index) : Chr(38 + A_Index)
    Loop 52 {
        innerLetter := A_Index <= 26 ? Chr(96 + A_Index) : Chr(38 + A_Index)
        combination := outerLetter . "/" . innerLetter
        
        isException := false
        for exception in exceptions {
            if (combination = exception) {
                isException := true
                break
            }
        }
        
        if (!isException) {
            Hotstring(":C*?:" . combination, outerLetter . "⧸" . innerLetter)
        }
    }
}
exceptionsa := Map()
Loop 10 {
    outerNumber := Chr(48 + A_Index-1)
    Loop 10 {
        innerNumber := Chr(48 + A_Index-1)
        combination := outerNumber . "-" . innerNumber
            Hotstring(":C*?:" . combination, outerNumber . "‒" . innerNumber)
    }
}


metersLinear := Map(
    "nm", "N.‑m.",
    "mim", "μ.‑m.",
    "mm", "M.‑m.",
    "cm", "C.‑m.",
    "dm", "D.‑m.",
    "m", "m.",
    "dam", "Da.‑m.",
    "hm", "H.‑m.",
    "km", "K.‑m."
)

metersArea := Map(
    "nmo", "N.‑m.²",
    "mimo", "μ.‑m.²",
    "mmo", "M.‑m.²",
    "cmo", "C.‑m.²",
    "dmo", "D.‑m.²",
    "mo", "m.²",
    "damo", "Da.‑m.²",
    "hmo", "H.‑m.²",
    "kmo", "K.‑m.²"
)

metersCube := Map(
    "nme", "N.‑m.³",
    "mime", "μ.‑m.³",
    "mme", "M.‑m.³",
    "cme", "C.‑m.³",
    "dme", "D.‑m.³",
    "me", "m.³",
    "dame", "Da.‑m.³",
    "hme", "H.‑m.³",
    "kme", "K.‑m.³"
)

gramsUnits := Map(
    "ng", "N.‑gr.",
    "mig", "μ.‑gr.",
    "cg", "C.‑gr.",
    "dg", "D.‑gr.",
    "g", "gr.",
    "dag", "Da.‑gr.",
    "hg", "H.‑gr.",
    "kg", "K.‑gr.",
    "mg", "M.‑gr.",
    "gg", "G.‑gr.",
    "tg", "T.‑gr."
)

litersUnits := Map(
    "nl", "N.‑l.",
    "mil", "μ.‑l.",
    "ml", "M.‑l.",
    "cl", "C.‑l.",
    "dl", "D.‑l.",
    "l", "l.",
    "dal", "Da.‑l.",
    "hl", "H.‑l.",
    "kl", "K.‑l."
)
temperatureUnits := Map(
    "dk", " DK",
    "dc", " DC"
)

amperesCurrent := Map(
    "na", "N.‑A.",
    "mia", "μ.‑A.",
    "ma", "M.‑A.",
    "ca", "C.‑A.",
    "da", "D.‑A.",
    "a", "A.",
    "daa", "Da.‑A.",
    "ha", "H.‑A.",
    "ka", "K.‑A."
)

amperesVoltage := Map(
    "nv", "N.‑V.",
    "miv", "μ.‑V.",
    "cv", "C.‑V.",
    "dv", "D.‑V.",
    "v", "V.",
    "dav", "Da.‑V.",
    "hv", "H.‑V.",
    "kv", "K.‑V.",
    "mv", "M.‑V."
)

amperesResistance := Map(
    "nohm", "N.‑Ω",
    "miohm", "μ.‑Ω",
    "mohm", "M.‑Ω",
    "cohm", "C.‑Ω",
    "dohm", "D.‑Ω",
    "ohm", "Ω",
    "daohm", "Da.‑Ω",
    "hohm", "H.‑Ω",
    "kohm", "K.‑Ω",
    "mohm", "M.‑Ω",
    "gohm", "G.‑Ω"
)

amperesPower := Map(
    "cw", "C.‑W.",
    "dw", "D.‑W.",
    "w", "W.",
    "daw", "Da.‑W.",
    "hw", "H.‑W.",
    "kw", "K.‑W.",
    "mw", "M.‑W.",
    "gw", "G.‑W."
)

energyUnits := Map(
    "cj", "C.‑J.",
    "dj", "D.‑J.",
    "j", "J.",
    "daj", "Da.‑J.",
    "hj", "H.‑J.",
    "kj", "K.‑J.",
    "mj", "M.‑J.",
    "gj", "G.‑J.",
    "wh", "W.‑hrs.",
    "kwh", "K.‑W.‑hrs.",
    "mwh", "M.‑W.‑hrs.",
    "gwh", "G.‑W.‑hrs.",
    "cal", "cal.",
    "kcal", "K.‑cal."
)

pressureUnits := Map(
    "cpa", "C.‑Pa.",
    "dpa", "D.‑Pa.",
    "pa", "P.‑a.",
    "dapa", "Da.‑Pa.",
    "hpa", "H.‑Pa.",
    "kpa", "K.‑Pa.",
    "mpa", "M.‑Pa.",
    "gpa", "G.‑Pa.",
    "mbar", "M.‑bar",
    "mmhg", "M.‑m.‑of‑Hg."
)

frequencyUnits := Map(
    "mhz", "M.‑Hz.",
    "chz", "C.‑Hz.",
    "dhz", "D.‑Hz.",
    "hz", "Hz.",
    "dahz", "Da.‑Hz",
    "hhz", "H.‑Hz",
    "khz", "K.‑Hz",
    "mhz", "M.‑Hz",
    "ghz", "G.‑Hz",
    "thz", "T.‑Hz"
)

siAutocompleteActive := false
siCurrentMenu := "main"
siCurrentOptions := []
siSelectedIndex := 0

categories := Map(
    "Meters !", "meters",
    "Grams !", "grams",
    "Liters !", "liters",
    "Temperature !", "temperature",
    "Amperes !", "amperes",
    "Energy !", "energy",
    "Preßure !", "pressure",
    "Frequͤncy !", "frequency"
)

meterSubcategories := Map(
    "Linear !", "linear",
    "Area !", "area",
    "Cube !", "cube"
)

ampereSubcategories := Map(
    "Current !", "current",
    "Voltage !", "voltage",
    "Resistance !", "resistance",
    "Power !", "power"
)

:C*O?:menusi::
{
    global
    siAutocompleteActive := true
    siCurrentMenu := "main"
    siSelectedIndex := 0
    ShowSIMainMenu()
}
SIMainOptions := Map(
    "mim", "μ.‑m.",
    "mm", "M.‑m.",
    "cm", "C.‑m.",
    "km", "K.‑m.",
    "m", "m.",
    "ml", "M.‑l.",
    "l", "l.",
    "dc", " DC"
)
ShowSIMainMenu() {
    global
    
    siCurrentOptions := []
    suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn."
    suggestions .= "`nCommon :`n"

    for key, symbol in SIMainOptions {
        siCurrentOptions.Push({key: key, symbol: symbol, type: "unit"})
        prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
    }
    
    suggestions .= "`nCategories :`n"
    
    for categoryName, categoryKey in categories {
        siCurrentOptions.Push({key: categoryName, symbol: "", type: "category", menuKey: categoryKey})
        prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . categoryName . "`n"
    }
    
    ToolTip(suggestions, , , 1)
}

ShowSISubmenu(menuType) {
    global
    
    siCurrentOptions := []
    local suggestions := ""
    
    switch menuType {
        case "meters":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            for subName, subKey in meterSubcategories {
                siCurrentOptions.Push({key: subName, symbol: "", type: "subcategory", menuKey: subKey, parentMenu: "meters"})
                prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
                suggestions .= prefix . subName . "`n"
            }
            
        case "amperes":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            for subName, subKey in ampereSubcategories {
                siCurrentOptions.Push({key: subName, symbol: "", type: "subcategory", menuKey: subKey, parentMenu: "amperes"})
                prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
                suggestions .= prefix . subName . "`n"
            }
            
        case "grams":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(gramsUnits, suggestions)
            
        case "liters":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(litersUnits, suggestions)
                        
        case "temperature":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(temperatureUnits, suggestions)
            
        case "energy":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(energyUnits, suggestions)
            
        case "pressure":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(pressureUnits, suggestions)
            
        case "frequency":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(frequencyUnits, suggestions)
    }
    
    ToolTip(suggestions, , , 1)
}

ShowSISubSubmenu(menuType) {
    global
    
    siCurrentOptions := []
    local suggestions := ""
    
    switch menuType {
        case "linear":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(metersLinear, suggestions)
            
        case "area":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(metersArea, suggestions)
            
        case "cube":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(metersCube, suggestions)
            
        case "current":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(amperesCurrent, suggestions)
            
        case "voltage":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(amperesVoltage, suggestions)
            
        case "resistance":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(amperesResistance, suggestions)
            
        case "power":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(amperesPower, suggestions)
    }
    
    ToolTip(suggestions, , , 1)
}

ShowUnitsFromMap(unitsMap, suggestions) {
    global
    for key, symbol in unitsMap {
        siCurrentOptions.Push({key: key, symbol: symbol, type: "unit"})
        prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
    }
    return suggestions
}

#HotIf siAutocompleteActive

Up::
{
    global
    if (siCurrentOptions.Length > 0) {
        siSelectedIndex := siSelectedIndex - 1
        if (siSelectedIndex < 0) {
            siSelectedIndex := siCurrentOptions.Length - 1
        }
        UpdateSIDisplay()
    }
}

Down::
{
    global
    if (siCurrentOptions.Length > 0) {
        siSelectedIndex := Mod(siSelectedIndex + 1, siCurrentOptions.Length)
        UpdateSIDisplay()
    }
}

Right::
{
    global
    if (siCurrentOptions.Length > 0 && siSelectedIndex < siCurrentOptions.Length) {
        selectedOption := siCurrentOptions[siSelectedIndex + 1]
        if (selectedOption.type == "category") {
            siCurrentMenu := selectedOption.menuKey
            siSelectedIndex := 0
            ShowSISubmenu(siCurrentMenu)
        } else if (selectedOption.type == "subcategory") {
            siCurrentMenu := selectedOption.menuKey
            siSelectedIndex := 0
            ShowSISubSubmenu(siCurrentMenu)
        }
    }
}

Left::
{
    global
    if (siCurrentMenu == "linear" || siCurrentMenu == "area" || siCurrentMenu == "cube") {
        siCurrentMenu := "meters"
        siSelectedIndex := 0
        ShowSISubmenu(siCurrentMenu)
    } else if (siCurrentMenu == "current" || siCurrentMenu == "voltage" || siCurrentMenu == "resistance" || siCurrentMenu == "power") {
        siCurrentMenu := "amperes"
        siSelectedIndex := 0
        ShowSISubmenu(siCurrentMenu)
    } else if (siCurrentMenu != "main") {
        siCurrentMenu := "main"
        siSelectedIndex := 0
        ShowSIMainMenu()
    }
}

Enter::
{
    global
    if (siCurrentOptions.Length > 0 && siSelectedIndex < siCurrentOptions.Length) {
        selectedOption := siCurrentOptions[siSelectedIndex + 1]
        
        if (selectedOption.type == "unit") {
            backspaceCount := 0
            Send("{Backspace " . backspaceCount . "}")
            Send(selectedOption.symbol)
            
            siAutocompleteActive := false
            ToolTip("", , , 1)
        } else if (selectedOption.type == "category") {
            siCurrentMenu := selectedOption.menuKey
            siSelectedIndex := 0
            ShowSISubmenu(siCurrentMenu)
        } else if (selectedOption.type == "subcategory") {
            siCurrentMenu := selectedOption.menuKey
            siSelectedIndex := 0
            ShowSISubSubmenu(siCurrentMenu)
        }
    }
}

Escape::
{
    global
    siAutocompleteActive := false
    ToolTip("", , , 1)
}

Backspace::
{
    global
    siAutocompleteActive := false
    ToolTip("", , , 1)
}

Space::
{
    global
    siAutocompleteActive := false
    ToolTip("", , , 1)
    Send(" ")
}

#HotIf

UpdateSIDisplay() {
    global
    if (siCurrentMenu == "main") {
        ShowSIMainMenu()
    } else if (siCurrentMenu == "linear" || siCurrentMenu == "area" || siCurrentMenu == "cube" || siCurrentMenu == "current" || siCurrentMenu == "voltage" || siCurrentMenu == "resistance" || siCurrentMenu == "power") {
        ShowSISubSubmenu(siCurrentMenu)
    } else {
        ShowSISubmenu(siCurrentMenu)
    }
}

for key, symbol in metersLinear {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in metersArea {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in metersCube {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in gramsUnits {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in litersUnits {
    Hotstring(":O:si" . key, symbol)
}
for key, symbol in temperatureUnits {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in amperesCurrent {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in amperesVoltage {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in amperesResistance {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in amperesPower {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in energyUnits {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in pressureUnits {
    Hotstring(":O:si" . key, symbol)
}

for key, symbol in frequencyUnits {
    Hotstring(":O:si" . key, symbol)
}
class a {
    static b := ""
    static c() {
        Hotstring(":*O?:\sd", (*) => a.d())
    }
    static d() {
        e := Gui("+AlwaysOnTop +ToolWindow -MaximizeBox -MinimizeBox", "")
        e.MarginX := 2
        e.MarginY := 2
        f := [0,1,2,3,4,5,6,7,8,9]
        for g, h in f {
            i := e.Add("Button", "x" . (g*22+2) . " y2 w20 h20", h)
            i.OnEvent("Click", ((j) => (*) => a.k(j*10, e))(h))
        }
        e.Show("w222 h24")
    }
    static k(l, m) {
        a.n()
        if (l > 0) {
            a.o(l)
        }
        m.Destroy()
    }
    static o(p) {
        a.b := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20", "")
        a.b.BackColor := "0x000000"
        a.b.Show("x0 y0 w" . A_ScreenWidth . " h" . A_ScreenHeight . " NoActivate")
        q := Integer(p * 255 / 100)
        WinSetTransparent(q, a.b.Hwnd)
    }
    static n() {
        if (a.b) {
            try {
                a.b.Destroy()
            }
            a.b := ""
        }
    }
}
a.c()
; ----------------------------------------

class UnifiedDreamEncoder {
    static mainGui := ""
    static controls := Map()
    static fragmentList := []
    static realityTests := []
    static currentTab := 1
    static scmCompleted := false
    static sclCompleted := false
    
    static Init() {
        Hotstring(":O?*:\scm", (*) => this.OpenGUI())
        Hotstring(":O?*:\scl", (*) => this.OpenGUI())
    }
    
    static OpenGUI() {
        if (this.mainGui && IsObject(this.mainGui)) {
            try {
                this.mainGui.Destroy()
            } catch {
            }
        }
        
        this.mainGui := Gui("+Resize +MinSize600x650", "Dream Encoder")
        this.mainGui.SetFont("s10", "Consolas")
        
        this.controls := Map()
        this.fragmentList := []
        this.realityTests := []
        this.scmCompleted := false
        this.sclCompleted := false
        
        this.CreateGUI()
        this.mainGui.OnEvent("Close", (*) => this.mainGui.Destroy())
        this.mainGui.Show("w600 h680")
    }
    
    static CreateGUI() {
        gui := this.mainGui
        
        this.controls["TabControl"] := gui.Add("Tab3", "x10 y10 w580 h660", ["SCM", "SCL", "Deploy"])
        this.controls["TabControl"].OnEvent("Change", (*) => this.CheckTabAccess())
        
        this.controls["TabControl"].UseTab(1)
        this.CreateSCMTab()
        
        this.controls["TabControl"].UseTab(2)
        this.CreateSCLTab()
        
        this.controls["TabControl"].UseTab(3)
        this.CreateDeployTab()
        
        this.controls["TabControl"].UseTab()
        
        this.SetupEvents()
        this.GenerateSCMEncoding()
        this.GenerateSCLEncoding()
        this.CheckTabAccess()
    }
    
    static CreateSCMTab() {
        gui := this.mainGui
        
        gui.Add("Text", "x20 y40 w550 Center", "DREAM EN-CODING SYSTEM").SetFont("s12 Bold")
        
        gui.Add("Text", "x20 y70", "Dream № :")
        this.controls["Dn"] := gui.Add("Edit", "x+10 yp w80 Number")
        this.controls["Dn"].Text := ""
        
        gui.Add("Text", "x20 y100", "Date :")
        this.controls["DateTime"] := gui.Add("Edit", "x+10 yp w100 ReadOnly -E0x200")
        this.controls["DateTime"].Opt("+Background0xF0F0F0")
        this.UpdateDateTime()
        
        gui.Add("Text", "x20 y130 w550", "Re‑called locks").SetFont("s11 Bold")
        gui.Add("Text", "x20 y155", "Count :")
        this.controls["RecalledCount"] := gui.Add("Edit", "x+10 yp w50")
        
        gui.Add("Text", "x+20 yp", "Cer. % :")
        this.controls["RecalledCertainty"] := gui.Add("Edit", "x+10 yp w50")
        
        gui.Add("Text", "x20 y190 w550", "Fragment count").SetFont("s11 Bold")
        gui.Add("Text", "x20 y215", "Type :")
        this.controls["FragmentRole"] := gui.Add("DropDownList", "x+10 yp w100", ["MER", "PRO", "SEQ", "SEP","FLB", "UNK"])
        this.controls["FragmentRole"].Choose(1)
        
        gui.Add("Text", "x+20 yp", "Count :")
        this.controls["FragmentCount"] := gui.Add("Edit", "x+10 yp w30 Limit1")
        this.controls["FragmentCount"].Enabled := false
        
        this.controls["FragmentX"] := gui.Add("Checkbox", "x+10 yp", "X")
        this.controls["FragmentX"].Enabled := false
        
        gui.Add("Text", "x20 y250", "Fragments :")
        this.controls["FragmentList"] := gui.Add("ListBox", "x20 y270 w400 h80")
        gui.Add("Button", "x440 yp w100 h34", "Add fragment").OnEvent("Click", (*) => this.AddFragment())
        gui.Add("Button", "x440 y305 w100 h34", "Re‑move fragment").OnEvent("Click", (*) => this.RemoveFragment())
        
        gui.Add("Text", "x20 y365", "V :")
        this.controls["VQ5"] := gui.Add("Checkbox", "x20 y385", "V5")
        this.controls["VQ4"] := gui.Add("Checkbox", "x+20 yp", "V4")
        this.controls["VQ3"] := gui.Add("Checkbox", "x+20 yp", "V3")
        this.controls["VQ2"] := gui.Add("Checkbox", "x+20 yp", "V2")
        this.controls["VQ1"] := gui.Add("Checkbox", "x+20 yp", "V1")
        
        gui.Add("Text", "x20 y410", "R :")
        this.controls["RQ0"] := gui.Add("Checkbox", "x20 y430", "R0")
        this.controls["RQ1"] := gui.Add("Checkbox", "x+20 yp", "R1")
        this.controls["RQ2"] := gui.Add("Checkbox", "x+20 yp", "R2")
        this.controls["RQ3"] := gui.Add("Checkbox", "x+20 yp", "R3")
        
        gui.Add("Text", "x20 y470 w550", "OUTPUT").SetFont("s11 Bold")
        
        gui.Add("Button", "x20 y500 w100 h30", "Clear All").OnEvent("Click", (*) => this.ClearAllSCM())
        gui.Add("Button", "x130 yp w100 h30", "En-grave").OnEvent("Click", (*) => this.EngraveFromSCM())
        
        gui.Add("Text", "x20 y540", "Re‑sult :")
        this.controls["OutputLine"] := gui.Add("Edit", "x20 y560 w550 h25 ReadOnly -E0x200")
        this.controls["OutputLine"].Opt("+Background0xF0F0F0")
    }
    
    static CreateSCLTab() {
        gui := this.mainGui
        
        gui.Add("Text", "x20 y40 w550 Center", "DREAM EN-CODING SYSTEM").SetFont("s12 Bold")
        
        gui.Add("Text", "x20 y70 w550", "MAIN FIELDS").SetFont("s11 Bold")
        
        gui.Add("Text", "x20 y95", "M :")
        this.controls["M1"] := gui.Add("Checkbox", "x+10 yp", "M1")
        this.controls["M2"] := gui.Add("Checkbox", "x+10 yp", "M2")
        this.controls["MX"] := gui.Add("Checkbox", "x+10 yp", "MX")
        
        gui.Add("Text", "x20 y120", "C :")
        this.controls["C"] := gui.Add("Checkbox", "x+10 yp", "C")
        
        gui.Add("Text", "x20 y145", "E⧸N :")
        this.controls["E"] := gui.Add("Checkbox", "x+10 yp", "E")
        this.controls["N"] := gui.Add("Checkbox", "x+10 yp", "N")
        this.controls["CX"] := gui.Add("Checkbox", "x+10 yp", "CX")
        
        gui.Add("Text", "x20 y170", "ﬅ :")
        this.controls["S1"] := gui.Add("Checkbox", "x+10 yp", "S1")
        this.controls["S2"] := gui.Add("Checkbox", "x+10 yp", "S2")
        this.controls["SX"] := gui.Add("Checkbox", "x+10 yp", "SX")
        
        gui.Add("Text", "x20 y205", "Note :")
        this.controls["Note"] := gui.Add("Edit", "x20 y225 w550 h40 VScroll")
        
        gui.Add("Text", "x20 y280", "L :")
        this.controls["F"] := gui.Add("Checkbox", "x+10 yp", "F")
        this.controls["T"] := gui.Add("Checkbox", "x+10 yp", "T")
        this.controls["U"] := gui.Add("Checkbox", "x+10 yp", "U")
        this.controls["LX"] := gui.Add("Checkbox", "x+10 yp", "LX")
        
        gui.Add("Text", "x20 y305", "B/N :")
        this.controls["B"] := gui.Add("Checkbox", "x+10 yp", "B")
        this.controls["BN"] := gui.Add("Checkbox", "x+10 yp", "N")
        this.controls["BX"] := gui.Add("Checkbox", "x+10 yp", "BX")
        
        gui.Add("Text", "x20 y340 w550", "REALITY TESTS").SetFont("s11 Bold")
        gui.Add("Text", "x20 y365", "Teﬆ :")
        this.controls["TestType"] := gui.Add("DropDownList", "x+10 yp w100", ["breath", "hand","nꜷght"])
        this.controls["TestType"].Choose(1)
        
        gui.Add("Button", "x+10 yp w80 h23", "Add Test").OnEvent("Click", (*) => this.AddRealityTest())
        
        gui.Add("Text", "x20 y395", "Added :")
        this.controls["TestList"] := gui.Add("ListBox", "x20 y415 w400 h80")
        gui.Add("Button", "x440 yp w100 h34", "Remove Test").OnEvent("Click", (*) => this.RemoveRealityTest())
        
        gui.Add("Text", "x20 y510 w550", "OUTPUT").SetFont("s11 Bold")
        
        gui.Add("Button", "x20 y540 w100 h30", "Clear All").OnEvent("Click", (*) => this.ClearAllSCL())
        gui.Add("Button", "x130 yp w100 h30", "En-grave").OnEvent("Click", (*) => this.EngraveFromSCL())
        
        gui.Add("Text", "x20 y580", "Data :")
        this.controls["Output1"] := gui.Add("Edit", "x20 y600 w550 h23 ReadOnly -E0x200")
        this.controls["Output1"].Opt("+Background0xF0F0F0")
        this.controls["Output2"] := gui.Add("Edit", "x20 y623 w550 h23 ReadOnly -E0x200")
        this.controls["Output2"].Opt("+Background0xF0F0F0")
    }
    
    static CreateDeployTab() {
        gui := this.mainGui
        
        gui.Add("Text", "x20 y40 w550 Center", "DEPLOY SYSTEM").SetFont("s12 Bold")
        
        gui.Add("Text", "x20 y80", "SCM Output :")
        this.controls["DeployOutput1"] := gui.Add("Edit", "x20 y100 w550 h23 ReadOnly -E0x200")
        this.controls["DeployOutput1"].Opt("+Background0xF0F0F0")
        
        gui.Add("Text", "x20 y140", "SCL Row 1 :")
        this.controls["DeployOutput2"] := gui.Add("Edit", "x20 y160 w550 h23 ReadOnly -E0x200")
        this.controls["DeployOutput2"].Opt("+Background0xF0F0F0")
        
        gui.Add("Text", "x20 y200", "SCL Row 2 :")
        this.controls["DeployOutput3"] := gui.Add("Edit", "x20 y220 w550 h23 ReadOnly -E0x200")
        this.controls["DeployOutput3"].Opt("+Background0xF0F0F0")
        
        gui.Add("Button", "x20 y270 w150 h40", "Deploy").OnEvent("Click", (*) => this.DeployFinal())
    }
    
    static SetupEvents() {
        this.controls["Dn"].OnEvent("Change", (*) => this.FilterDn())
        this.controls["RecalledCount"].OnEvent("Change", (*) => this.FilterDigits("RecalledCount"))
        this.controls["RecalledCertainty"].OnEvent("Change", (*) => this.FilterDigits("RecalledCertainty"))
        this.controls["FragmentCount"].OnEvent("Change", (*) => this.FilterFragmentCount())
        this.controls["FragmentX"].OnEvent("Click", (*) => this.HandleFragmentX())
        this.controls["FragmentRole"].OnEvent("Change", (*) => this.HandleFragmentRole())
        
        this.controls["VQ1"].OnEvent("Click", (*) => this.HandleVQSelection(1))
        this.controls["VQ2"].OnEvent("Click", (*) => this.HandleVQSelection(2))
        this.controls["VQ3"].OnEvent("Click", (*) => this.HandleVQSelection(3))
        this.controls["VQ4"].OnEvent("Click", (*) => this.HandleVQSelection(4))
        this.controls["VQ5"].OnEvent("Click", (*) => this.HandleVQSelection(5))
        
        this.controls["RQ0"].OnEvent("Click", (*) => this.HandleRQSelection(0))
        this.controls["RQ1"].OnEvent("Click", (*) => this.HandleRQSelection(1))
        this.controls["RQ2"].OnEvent("Click", (*) => this.HandleRQSelection(2))
        this.controls["RQ3"].OnEvent("Click", (*) => this.HandleRQSelection(3))
        
        this.controls["M1"].OnEvent("Click", (*) => this.HandleMetacognition("M1"))
        this.controls["M2"].OnEvent("Click", (*) => this.HandleMetacognition("M2"))
        this.controls["MX"].OnEvent("Click", (*) => this.HandleMetacognition("MX"))
        
        this.controls["C"].OnEvent("Click", (*) => this.HandleCognition())
        
        this.controls["E"].OnEvent("Click", (*) => this.HandleControl("E"))
        this.controls["N"].OnEvent("Click", (*) => this.HandleControl("N"))
        this.controls["CX"].OnEvent("Click", (*) => this.HandleControl("CX"))
        
        this.controls["S1"].OnEvent("Click", (*) => this.HandleStability("S1"))
        this.controls["S2"].OnEvent("Click", (*) => this.HandleStability("S2"))
        this.controls["SX"].OnEvent("Click", (*) => this.HandleStability("SX"))
        
        this.controls["F"].OnEvent("Click", (*) => this.HandleLucidityType("F"))
        this.controls["T"].OnEvent("Click", (*) => this.HandleLucidityType("T"))
        this.controls["U"].OnEvent("Click", (*) => this.HandleLucidityType("U"))
        this.controls["LX"].OnEvent("Click", (*) => this.HandleLucidityType("LX"))
        
        this.controls["B"].OnEvent("Click", (*) => this.HandleLucidityBoundary("B"))
        this.controls["BN"].OnEvent("Click", (*) => this.HandleLucidityBoundary("BN"))
        this.controls["BX"].OnEvent("Click", (*) => this.HandleLucidityBoundary("BX"))
        
        this.controls["Note"].OnEvent("Change", (*) => this.GenerateSCLEncoding())
    }
    
    static CheckTabAccess() {
        currentTab := this.controls["TabControl"].Value
        
        if (currentTab == 2 && !this.scmCompleted) {
            this.controls["TabControl"].Choose(1)
            return
        }
        
        if (currentTab == 3 && (!this.scmCompleted || !this.sclCompleted)) {
            if (!this.scmCompleted) {
                this.controls["TabControl"].Choose(1)
            } else {
                this.controls["TabControl"].Choose(2)
            }
            return
        }
    }
    
    static FilterDn() {
        text := this.controls["Dn"].Text
        filtered := RegExReplace(text, "[^0-9]", "")
        
        if (text != filtered) {
            this.controls["Dn"].Text := filtered
        }
        this.GenerateSCMEncoding()
    }
    
    static FilterFragmentCount() {
        text := this.controls["FragmentCount"].Text
        filtered := RegExReplace(text, "[^1-9]", "")
        filtered := SubStr(filtered, 1, 1)
        
        if (text != filtered) {
            this.controls["FragmentCount"].Text := filtered
        }
    }
    
    static HandleVQSelection(selected) {
        for i in [1, 2, 3, 4, 5] {
            if (i != selected) {
                this.controls["VQ" . i].Value := 0
            }
        }
        this.GenerateSCMEncoding()
    }
    
    static HandleRQSelection(selected) {
        for i in [0, 1, 2, 3] {
            if (i != selected) {
                this.controls["RQ" . i].Value := 0
            }
        }
        this.GenerateSCMEncoding()
    }
    
    static FilterDigits(controlName) {
        text := this.controls[controlName].Text
        filtered := RegExReplace(text, "[^0-9]", "")
        filtered := SubStr(filtered, 1, 2)
        
        if (text != filtered) {
            this.controls[controlName].Text := filtered
        }
        this.GenerateSCMEncoding()
    }
    
    static HandleFragmentRole() {
        role := this.controls["FragmentRole"].Text
        
        if (role != "MER") {
            this.controls["FragmentCount"].Enabled := true
            this.controls["FragmentX"].Enabled := true
        } else {
            this.controls["FragmentCount"].Enabled := false
            this.controls["FragmentX"].Enabled := false
            this.controls["FragmentCount"].Text := ""
            this.controls["FragmentX"].Value := 0
        }
    }
    
    static HandleFragmentX() {
        if (this.controls["FragmentX"].Value) {
            this.controls["FragmentCount"].Text := "X"
            this.controls["FragmentCount"].Enabled := false
        } else {
            this.controls["FragmentCount"].Text := ""
            this.controls["FragmentCount"].Enabled := true
        }
    }
    
    static UpdateDateTime() {
        currentTime := A_Now
        day := SubStr(currentTime, 7, 2)
        hour := SubStr(currentTime, 9, 2)
        minute := SubStr(currentTime, 11, 2)
        
        dateTime := day . hour . minute . "j"
        
        this.controls["DateTime"].Text := dateTime
    }
    
    static AddFragment() {
        role := this.controls["FragmentRole"].Text
        count := this.controls["FragmentCount"].Text
        
        if (role == "MER") {
            this.fragmentList.Push(role)
            this.UpdateFragmentList()
            this.GenerateSCMEncoding()
            return
        }
        
        if (count == "" && !this.controls["FragmentX"].Value) {
            MsgBox("err", "Error")
            return
        }
        
        if (this.controls["FragmentX"].Value) {
            count := "X"
        }
        
        fragment := role . count
        this.fragmentList.Push(fragment)
        this.UpdateFragmentList()
        this.GenerateSCMEncoding()
    }
    
    static RemoveFragment() {
        selected := this.controls["FragmentList"].Value
        if (selected > 0 && selected <= this.fragmentList.Length) {
            this.fragmentList.RemoveAt(selected)
            this.UpdateFragmentList()
            this.GenerateSCMEncoding()
        }
    }
    
    static UpdateFragmentList() {
        this.controls["FragmentList"].Delete()
        for i, fragment in this.fragmentList {
            this.controls["FragmentList"].Add([fragment])
        }
    }
    
    static GenerateSCMEncoding() {
        this.UpdateDateTime()
        
        dn := this.controls["Dn"].Text
        
        if (dn == "") {
            dn := "0"
        } else {
            dn := String(Integer(dn))
        }
        dnFormatted := "D" . dn
        
        dateTime := this.controls["DateTime"].Text
        
        recalledCount := this.controls["RecalledCount"].Text
        recalledCertainty := this.controls["RecalledCertainty"].Text
        
        if (recalledCount == "") {
            recalledCount := "0"
        } else {
            recalledCount := String(Integer(recalledCount))
        }
        
        if (recalledCertainty == "") {
            recalledCertainty := "00"
        } else {
            num := Integer(recalledCertainty)
            recalledCertainty := (num < 10) ? "0" . String(num) : String(num)
        }
        
        recalled := recalledCount . recalledCertainty
        
        vq := "V>"
        for i in [1, 2, 3, 4, 5] {
            if (this.controls["VQ" . i].Value) {
                vq := "V" . i
                break
            }
        }
        
        rq := "R>"
        for i in [0, 1, 2, 3] {
            if (this.controls["RQ" . i].Value) {
                rq := "R" . i
                break
            }
        }
        
        fragmentStr := ""
        for i, fragment in this.fragmentList {
            if (i > 1) {
                fragmentStr .= " "
            }
            fragmentStr .= fragment
        }
        
        fragmentSection := (fragmentStr == "") ? "F " : "F " . fragmentStr
        
        output := dnFormatted . " " . dateTime . " " . recalled . " " . vq . " " . rq . " " . fragmentSection
        
        this.controls["OutputLine"].Text := output
    }
    
    static ClearAllSCM() {
        this.controls["Dn"].Text := ""
        this.controls["RecalledCount"].Text := ""
        this.controls["RecalledCertainty"].Text := ""
        this.controls["FragmentRole"].Choose(1)
        this.controls["FragmentCount"].Text := ""
        this.controls["FragmentCount"].Enabled := true
        this.controls["FragmentX"].Value := 0
        this.controls["FragmentX"].Enabled := true
        
        for i in [1, 2, 3, 4, 5] {
            this.controls["VQ" . i].Value := 0
        }
        this.controls["VQ3"].Value := 1
        
        for i in [0, 1, 2, 3] {
            this.controls["RQ" . i].Value := 0
        }
        this.controls["RQ1"].Value := 1
        
        this.controls["OutputLine"].Text := ""
        
        this.fragmentList := []
        this.controls["FragmentList"].Delete()
        
        this.scmCompleted := false
        
        this.UpdateDateTime()
        this.GenerateSCMEncoding()
    }
    static previousState := Map()
    static previousDisabled := Map()
    static lastPressed := ""
    static nowPressed := ""
    static HandleMetacognition(selected) {
        this.nowPressed := selected
        
        if (this.lastPressed == this.nowPressed && this.controls[selected].Value == 0) {
            this.RestorePreviousState()
            this.lastPressed := ""
            this.nowPressed := ""
            this.GenerateSCLEncoding()
            return
        }
        
        if (this.lastPressed != this.nowPressed) {
            this.SaveToArray()
        }
        
        for key in ["M1", "M2", "MX"] {
            if (key != selected) {
                this.controls[key].Value := 0
            }
        }
        
        this.lastPressed := this.nowPressed
        this.ApplySCLRules()
        this.GenerateSCLEncoding()
    }

    static HandleCognition() {
        this.nowPressed := "C"
        
        if (this.lastPressed == this.nowPressed && this.controls["C"].Value == 0) {
            this.RestorePreviousState()
            this.lastPressed := ""
            this.nowPressed := ""
            this.GenerateSCLEncoding()
            return
        }
        
        if (this.lastPressed != this.nowPressed) {
            this.SaveToArray()
        }
        
        this.lastPressed := this.nowPressed
        this.ApplySCLRules()
        this.GenerateSCLEncoding()
    }

    static HandleControl(selected) {
        this.nowPressed := selected
        
        if (this.lastPressed == this.nowPressed && this.controls[selected].Value == 0) {
            this.RestorePreviousState()
            this.lastPressed := ""
            this.nowPressed := ""
            this.GenerateSCLEncoding()
            return
        }
        
        if (this.lastPressed != this.nowPressed) {
            this.SaveToArray()
        }
        
        for key in ["E", "N", "CX"] {
            if (key != selected) {
                this.controls[key].Value := 0
            }
        }
        
        this.lastPressed := this.nowPressed
        this.ApplySCLRules()
        this.GenerateSCLEncoding()
    }

    static HandleStability(selected) {
        this.nowPressed := selected
        
        if (this.lastPressed == this.nowPressed && this.controls[selected].Value == 0) {
            this.RestorePreviousState()
            this.lastPressed := ""
            this.nowPressed := ""
            this.GenerateSCLEncoding()
            return
        }
        
        if (this.lastPressed != this.nowPressed) {
            this.SaveToArray()
        }
        
        for key in ["S1", "S2", "SX"] {
            if (key != selected) {
                this.controls[key].Value := 0
            }
        }
        
        this.lastPressed := this.nowPressed
        this.ApplySCLRules()
        this.GenerateSCLEncoding()
    }

    static HandleLucidityType(selected) {
        this.nowPressed := selected
        
        if (this.lastPressed == this.nowPressed && this.controls[selected].Value == 0) {
            this.RestorePreviousState()
            this.lastPressed := ""
            this.nowPressed := ""
            this.GenerateSCLEncoding()
            return
        }
        
        if (this.lastPressed != this.nowPressed) {
            this.SaveToArray()
        }
        
        for key in ["F", "T", "U", "LX"] {
            if (key != selected) {
                this.controls[key].Value := 0
            }
        }
        
        this.lastPressed := this.nowPressed
        this.ApplySCLRules()
        this.GenerateSCLEncoding()
    }

    static HandleLucidityBoundary(selected) {
        this.nowPressed := selected
        
        if (this.lastPressed == this.nowPressed && this.controls[selected].Value == 0) {
            this.RestorePreviousState()
            this.lastPressed := ""
            this.nowPressed := ""
            this.GenerateSCLEncoding()
            return
        }
        
        if (this.lastPressed != this.nowPressed) {
            this.SaveToArray()
        }
        
        for key in ["B", "BN", "BX"] {
            if (key != selected) {
                this.controls[key].Value := 0
            }
        }
        
        this.lastPressed := this.nowPressed
        this.ApplySCLRules()
        this.GenerateSCLEncoding()
    }


    static SaveToArray() {
        this.previousState := Map()
        this.previousDisabled := Map()
        for key in ["M1", "M2", "MX", "C", "E", "N", "CX", "S1", "S2", "SX", "F", "T", "U", "LX", "B", "BN", "BX"] {
            this.previousState[key] := this.controls[key].Value
            this.previousDisabled[key] := !this.controls[key].Enabled
        }
    }
    static RestorePreviousState() {
        this.EnableAllControls()
        
        for key in ["M1", "M2", "MX", "C", "E", "N", "CX", "S1", "S2", "SX", "F", "T", "U", "LX", "B", "BN", "BX"] {
            if (this.previousState.Has(key)) {
                this.controls[key].Value := this.previousState[key]
            }
        }
        
        for key in ["M1", "M2", "MX", "C", "E", "N", "CX", "S1", "S2", "SX", "F", "T", "U", "LX", "B", "BN", "BX"] {
            if (this.previousDisabled.Has(key) && this.previousDisabled[key]) {
                this.controls[key].Enabled := false
            }
        }
        
        this.controls[this.nowPressed].Value := 0
        this.previousState := Map()
        this.previousDisabled := Map()
    }

    static ApplySCLRules() {
        this.EnableAllControls()
        
        if (this.controls["MX"].Value) {
            this.controls["C"].Value := 1
            this.controls["M1"].Value := 0
            this.controls["M2"].Value := 0
            this.DisableControls(["M1", "M2"])
        }
        
        if (this.controls["B"].Value || this.controls["BN"].Value) {
            this.controls["C"].Value := 1
            this.controls["MX"].Value := 1
            this.controls["M1"].Value := 0
            this.controls["M2"].Value := 0
            this.controls["CX"].Value := 1
            this.controls["E"].Value := 0
            this.controls["N"].Value := 0
            this.controls["SX"].Value := 1
            this.controls["BX"].Value := 0
            this.controls["S1"].Value := 0
            this.controls["S2"].Value := 0
            this.controls["LX"].Value := 1
            this.controls["F"].Value := 0
            this.controls["T"].Value := 0
            this.controls["U"].Value := 0
            
            this.DisableControls(["M1", "M2", "E", "N", "S1", "S2", "F", "T","BX", "U"])
        }
        if (this.controls["BN"].Value) {
            this.controls["B"].Value := 0
            this.DisableControls(["B"])
        }
        if (this.controls["BX"].Value) {
            this.controls["B"].Value := 0
            this.controls["BN"].Value := 0
            this.controls["CX"].Value := 0
            this.controls["SX"].Value := 0
            this.controls["LX"].Value := 0
            this.DisableControls(["BN","B","CX","SX","LX"])
        }
        if (this.controls["C"].Value) {
            this.controls["M1"].Value := 0
            this.controls["M2"].Value := 0 
            this.controls["MX"].Value := 1
            this.DisableControls(["M1", "M2"])
        }
        
        if (this.controls["E"].Value || this.controls["N"].Value) {
            this.controls["SX"].Value := 0
            this.DisableControls(["SX"])
        }
        
        if (this.controls["F"].Value || this.controls["T"].Value || this.controls["U"].Value) {
            this.controls["B"].Value := 0
            this.controls["BN"].Value := 0
            this.controls["BX"].Value := 1
            this.DisableControls(["B", "BN"])
        }
        
        if (this.controls["S1"].Value || this.controls["S2"].Value || this.controls["F"].Value || this.controls["T"].Value || this.controls["U"].Value || this.controls["E"].Value || this.controls["N"].Value || this.controls["M1"].Value || this.controls["M2"].Value) {
            this.controls["B"].Value := 0
            this.controls["BN"].Value := 0
            this.controls["BX"].Value := 1
            this.DisableControls(["B", "BN"])
        }
        
        if (this.controls["M1"].Value || this.controls["M2"].Value) {
            this.controls["C"].Value := 0
            this.DisableControls(["C"])
        }

        if (this.controls["S1"].Value || this.controls["S2"].Value) {
            this.controls["CX"].Value := 0
            this.DisableControls(["CX","SX"])
        }

        if (this.controls["M1"].Value || this.controls["M2"].Value) {
            this.controls["MX"].Value := 0
            this.DisableControls(["MX"])
        }

        if (this.controls["E"].Value || this.controls["N"].Value) {
            this.controls["CX"].Value := 0
            this.DisableControls(["CX"])
        }

        if (this.controls["LX"].Value) {
            this.DisableControls(["F","T", "BX", "U"])
        }
        if (this.controls["F"].Value) {
            this.DisableControls(["LX","T", "U"])
        }
        if (this.controls["T"].Value) {
            this.DisableControls(["F","LX", "U"])
        }
        if (this.controls["U"].Value) {
            this.DisableControls(["F","T", "LX"])
        }
        
        if (this.controls["E"].Value || this.controls["N"].Value || this.controls["S1"].Value || this.controls["S2"].Value) {
            this.controls["LX"].Value := 0
            this.DisableControls(["LX"])
        }
        
        if (this.controls["CX"].Value || this.controls["SX"].Value) {
            this.controls["E"].Value := 0
            this.controls["N"].Value := 0
            this.controls["S1"].Value := 0
            this.controls["S2"].Value := 0
            this.controls["SX"].Value := 1
            this.controls["F"].Value := 0
            this.controls["T"].Value := 0
            this.controls["U"].Value := 0
            this.controls["LX"].Value := 1
            this.DisableControls(["E", "N", "S1", "S2", "F", "T", "U"])
        }
    }
    static EnableAllControls() {
        for key in ["M1", "M2", "MX", "C", "E", "N", "CX", "S1", "S2", "SX", "F", "T", "U", "LX", "B", "BN", "BX"] {
            this.controls[key].Enabled := true
        }
    }
    
    static DisableControls(controlList) {
        for key in controlList {
            this.controls[key].Enabled := false
        }
    }
    
    static AddRealityTest() {
        testType := this.controls["TestType"].Text
        testIndex := this.realityTests.Length + 1
        
        if (testIndex <= 14) {
            this.realityTests.Push(testType)
            this.UpdateTestList()
            this.GenerateSCLEncoding()
        } else {
            MsgBox("Max. 14 entries", "Error")
        }
    }
    
    static RemoveRealityTest() {
        selected := this.controls["TestList"].Value
        if (selected > 0 && selected <= this.realityTests.Length) {
            this.realityTests.RemoveAt(selected)
            this.UpdateTestList()
            this.GenerateSCLEncoding()
        }
    }
    
    static UpdateTestList() {
        this.controls["TestList"].Delete()
        for i, test in this.realityTests {
            this.controls["TestList"].Add([i . "R" . SubStr(test, 1, 1)])
        }
    }
    
    static GenerateSCLEncoding() {
        row1 := this.GenerateRow1()
        row2 := this.GenerateRow2()
        checksum := this.CalculateChecksum(row1)
        
        this.controls["Output1"].Text := row1 . checksum
        this.controls["Output2"].Text := row2
    }
    
    static GenerateRow1() {
        result := ""
        
        result .= "M>"
        if (this.controls["M1"].Value) {
            result .= "1"
        } else if (this.controls["M2"].Value) {
            result .= "2"
        } else {
            result .= "X"
        }
        
        result .= ">>>>"
        
        if (this.controls["C"].Value && this.controls["MX"].Value) {
            result .= "C"
        } else {
            result .= "X"
        }
        
        if (this.controls["E"].Value) {
            result .= "E"
        } else if (this.controls["N"].Value) {
            result .= "N"
        } else {
            result .= "X"
        }
        
        result .= "S>"
        if (this.controls["S1"].Value) {
            result .= "1"
        } else if (this.controls["S2"].Value) {
            result .= "2"
        } else {
            result .= "X"
        }
        
        result .= ">"
        
        noteText := StrUpper(this.controls["Note"].Text)
        noteText := RegExReplace(noteText, "[^A-Z0-9 ]", "")
        noteText := RegExReplace(noteText, " ", ">")
        noteText := RegExReplace(noteText, " ", ">")
        noteText := SubStr(noteText, 1, 28)
        
        while (StrLen(noteText) < 28) {
            noteText .= ">"
        }
        result .= noteText
        
        result .= ">"
        
        if (this.controls["F"].Value) {
            result .= "F"
        } else if (this.controls["T"].Value) {
            result .= "T"
        } else if (this.controls["U"].Value) {
            result .= "U"
        } else if (this.controls["B"].Value || this.controls["BN"].Value) {
            result .= "X"
        } else {
            result .= ">"
        }
        
        result .= ">>"
        
        if (this.controls["B"].Value) {
            result .= "B"
        } else if (this.controls["BN"].Value) {
            result .= "N"
        } else {
            result .= ">"
        }
        
        result .= ">>"
        
        return result
    }
    
    static GenerateRow2() {
        result := ""
        
        for i, test in this.realityTests {
            result .= i . "R" . SubStr(test, 1, 1)
        }
        
        while (StrLen(result) < 49) {
            result .= ">"
        }
        
        return SubStr(result, 1, 49)
    }
    
    static CalculateChecksum(row1) {
        sum := 0
        
        for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48] {
            if (i <= StrLen(row1)) {
                sum += Ord(SubStr(row1, i, 1))
            }
        }
        
        while (sum > 9) {
            sum := Mod(sum, 6)
        }
        
        return String(sum)
    }
    
    static ClearAllSCL() {
        this.EnableAllControls()
        
        this.controls["M1"].Value := 0
        this.controls["M2"].Value := 0
        this.controls["MX"].Value := 0
        this.controls["C"].Value := 0
        this.controls["E"].Value := 0
        this.controls["N"].Value := 0
        this.controls["CX"].Value := 0
        this.controls["S1"].Value := 0
        this.controls["S2"].Value := 0
        this.controls["SX"].Value := 0
        this.controls["F"].Value := 0
        this.controls["T"].Value := 0
        this.controls["U"].Value := 0
        this.controls["LX"].Value := 0
        this.controls["B"].Value := 0
        this.controls["BN"].Value := 0
        this.controls["BX"].Value := 0
        
        this.controls["Note"].Text := ""
        this.controls["Output1"].Text := ""
        this.controls["Output2"].Text := ""
        
        this.realityTests := []
        this.controls["TestList"].Delete()
        
        this.sclCompleted := false
        
        this.GenerateSCLEncoding()
    }
    
    static EngraveFromSCM() {
        scmOutput := this.controls["OutputLine"].Text
        
        this.scmCompleted := true
        
        this.controls["DeployOutput1"].Text := scmOutput
        
        this.controls["DeployOutput2"].Text := ""
        this.controls["DeployOutput3"].Text := ""
        
        this.controls["TabControl"].Choose(2)
    }
    
    static EngraveFromSCL() {
        sclRow1 := this.controls["Output1"].Text
        sclRow2 := this.controls["Output2"].Text
        
        this.sclCompleted := true
        
        this.controls["DeployOutput2"].Text := sclRow1
        this.controls["DeployOutput3"].Text := sclRow2
        
        this.controls["TabControl"].Choose(3)
    }
    
    static DeployFinal() {
        output := this.controls["DeployOutput1"].Text
        row1 := this.controls["DeployOutput2"].Text
        row2 := this.controls["DeployOutput3"].Text
        
        if (output != "" || row1 != "" || row2 != "") {
            this.mainGui.Hide()
            Sleep(100)
            
            if (output != "") {
                Send(output)
            }
            if (row1 != "") {
                Send("+{Enter}")
                Send(row1)
            }
            if (row2 != "") {
                Sleep(100)
                Send("+{Enter}")
                Send(row2)
            }
            
            this.mainGui.Destroy()
        }
    }
}

UnifiedDreamEncoder.Init()


ColorPicker := ""

::\shex::
{
    global ColorPicker
    if (!ColorPicker) {
        ColorPicker := ColorPickerClass()
    }
    ColorPicker.Show()
}


class ColorPickerClass {
    
    GUI := ""
    MainRect := ""
    HueStrip := ""
    DisplayField := ""
    MainPointer := ""
    HuePointer := ""
    MainBitmap := ""
    HueBitmap := ""
    CurrentHue := 0          
    CurrentSat := 100        
    CurrentBright := 100     
    IsDragging := false
    DragTarget := ""
    
    __New() {
        this.CurrentHue := 0
        this.CurrentSat := 100
        this.CurrentBright := 100
        this.IsDragging := false
        this.DragTarget := ""
    }
    
    Show() {
        this.GUI := Gui("+Resize +MinSize450x350", "Color Picker")
        this.GUI.MarginX := 10
        this.GUI.MarginY := 10
        this.GUI.OnEvent("Close", (*) => this.Hide())
        this.GUI.OnEvent("Escape", (*) => this.Hide())
        
        this.DisplayField := this.GUI.Add("Edit", "x10 y10 w410 h35 ReadOnly Center Background0xFFFFFF")
        this.DisplayField.SetFont("s16 Bold")
        
        this.MainRect := this.GUI.Add("Picture", "x10 y55 w360 h200 Border")
        this.MainRect.OnEvent("Click", (ctrl, info) => this.MainRect_Click(ctrl, info))
        
        this.MainPointer := this.GUI.Add("Text", "x10 y55 w8 h8 Center BackgroundWhite Border", "")
        
        this.HueStrip := this.GUI.Add("Picture", "x380 y55 w30 h200 Border")
        this.HueStrip.OnEvent("Click", (ctrl, info) => this.HueStrip_Click(ctrl, info))
        
        this.HuePointer := this.GUI.Add("Text", "x380 y55 w30 h2 Center BackgroundBlack", "")
        
        SendNBtn := this.GUI.Add("Button", "x125 y270 w100 h35", "SEND N")
        SendNBtn.OnEvent("Click", (*) => this.SendNormal())
        
        SendFBtn := this.GUI.Add("Button", "x235 y270 w100 h35", "SEND F")
        SendFBtn.OnEvent("Click", (*) => this.SendFormatted())
        
        this.CreateHueBitmap()
        this.CreateMainBitmap()
        this.UpdateDisplayHex()
        this.UpdatePointers()
        
        this.GUI.Show("w450 h350")
        this.CenterWindow()
        
        SetTimer(() => this.CheckMouseDrag(), 5)
    }
    
    Hide() {
        if (this.GUI) {
            SetTimer(() => this.CheckMouseDrag(), 0)
            this.CleanupBitmaps()
            this.GUI.Destroy()
            this.GUI := ""
        }
    }
    
    CenterWindow() {
        this.GUI.GetPos(,, &Width, &Height)
        NewX := (A_ScreenWidth - Width) / 2
        NewY := (A_ScreenHeight - Height) / 2
        this.GUI.Move(NewX, NewY)
    }
    
    RGBtoBGR(RGB) {
        R := (RGB >> 16) & 0xFF
        G := (RGB >> 8) & 0xFF
        B := RGB & 0xFF
        
        return (B << 16) | (G << 8) | R
    }
    HSVtoRGB(H, S, V) {
        
        H := Mod(H, 360) / 360  
        S := S / 100            
        V := V / 100            
        
        
        C := V * S
        X := C * (1 - Abs(Mod(H * 6, 2) - 1))
        M := V - C
        
        if (H < 1/6) {          
            R := C, G := X, B := 0
        } else if (H < 2/6) {   
            R := X, G := C, B := 0
        } else if (H < 3/6) {   
            R := 0, G := C, B := X
        } else if (H < 4/6) {   
            R := 0, G := X, B := C
        } else if (H < 5/6) {   
            R := X, G := 0, B := C
        } else {                
            R := C, G := 0, B := X
        }
        
        
        R := Round((R + M) * 255)
        G := Round((G + M) * 255)
        B := Round((B + M) * 255)
        
        
        return (R << 16) | (G << 8) | B
    }
    
    RGBtoHex(RGB) {
        R := (RGB >> 16) & 0xFF
        G := (RGB >> 8) & 0xFF
        B := RGB & 0xFF
        return Format("#{:02X}{:02X}{:02X}", R, G, B)
    }
    
    GetRGBComponents(RGB) {
        R := (RGB >> 16) & 0xFF
        G := (RGB >> 8) & 0xFF
        B := RGB & 0xFF
        return {R: R, G: G, B: B}
    }
    
    CreateBitmap(Width, Height) {
        hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
        hMemDC := DllCall("CreateCompatibleDC", "Ptr", hDC, "Ptr")
        hBitmap := DllCall("CreateCompatibleBitmap", "Ptr", hDC, "Int", Width, "Int", Height, "Ptr")
        DllCall("SelectObject", "Ptr", hMemDC, "Ptr", hBitmap, "Ptr")
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
        DllCall("DeleteDC", "Ptr", hMemDC)
        return hBitmap
    }
    
    CreateHueBitmap() {
        this.HueBitmap := this.CreateBitmap(30, 200)
        
        hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
        hMemDC := DllCall("CreateCompatibleDC", "Ptr", hDC, "Ptr")
        hOldBitmap := DllCall("SelectObject", "Ptr", hMemDC, "Ptr", this.HueBitmap, "Ptr")
        
        Loop 200 {
            Y := A_Index - 1
            Hue := (Y / 199) * 360  
            
            RGB := this.HSVtoRGB(Hue, 100, 100)
            BGR := this.RGBtoBGR(RGB)

            hBrush := DllCall("CreateSolidBrush", "UInt", BGR, "Ptr")
            Rect := Buffer(16, 0)
            NumPut("Int", 0, Rect, 0)       
            NumPut("Int", Y, Rect, 4)       
            NumPut("Int", 30, Rect, 8)      
            NumPut("Int", Y+1, Rect, 12)    
            DllCall("FillRect", "Ptr", hMemDC, "Ptr", Rect, "Ptr", hBrush)
            DllCall("DeleteObject", "Ptr", hBrush)
        }
        
        DllCall("SelectObject", "Ptr", hMemDC, "Ptr", hOldBitmap, "Ptr")
        DllCall("DeleteDC", "Ptr", hMemDC)
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
        
        this.HueStrip.Value := "HBITMAP:" . this.HueBitmap
    }
    
    CreateMainBitmap() {
        this.MainBitmap := this.CreateBitmap(360, 200)
        
        hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
        hMemDC := DllCall("CreateCompatibleDC", "Ptr", hDC, "Ptr")
        hOldBitmap := DllCall("SelectObject", "Ptr", hMemDC, "Ptr", this.MainBitmap, "Ptr")
        
        Loop 200 {
            Y := A_Index - 1
            Brightness := 100 - ((Y / 199) * 100)  
            
            Loop 360 {
                X := A_Index - 1
                Saturation := (X / 359) * 100  
                RGB := this.HSVtoRGB(this.CurrentHue, Saturation, Brightness)
                BGR := this.RGBtoBGR(RGB)
                
                DllCall("SetPixel", "Ptr", hMemDC, "Int", X, "Int", Y, "UInt", BGR)
            }
        }
        
        DllCall("SelectObject", "Ptr", hMemDC, "Ptr", hOldBitmap, "Ptr")
        DllCall("DeleteDC", "Ptr", hMemDC)
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
        
        this.MainRect.Value := "HBITMAP:" . this.MainBitmap
    }
    
    UpdateDisplayHex() {
        RGB := this.HSVtoRGB(this.CurrentHue, this.CurrentSat, this.CurrentBright)
        HexColor := this.RGBtoHex(RGB)
        ColorBlocks := "██████"
        
        DisplayText := "HEX " . HexColor . " " . ColorBlocks
        this.DisplayField.Text := DisplayText
        
        
        this.DisplayField.SetFont("c" . Format("0x{:06X}", RGB))
    }
    
    UpdatePointers() {
        
        X := Round((this.CurrentSat / 100) * 359) + 10 - 4
        Y := Round(((100 - this.CurrentBright) / 100) * 199) + 55 - 4
        this.MainPointer.Move(X, Y)
        
        
        HueY := Round((this.CurrentHue / 360) * 199) + 55 - 1
        this.HuePointer.Move(380, HueY)
    }
    
    MainRect_Click(GuiCtrlObj, Info) {
        CoordMode("Mouse", "Client")
        MouseGetPos(&X, &Y)
        this.MainRect.GetPos(&CtrlX, &CtrlY)
        
        RelX := Max(0, Min(359, X - CtrlX))
        RelY := Max(0, Min(199, Y - CtrlY))
        
        this.CurrentSat := (RelX / 359) * 100
        this.CurrentBright := 100 - ((RelY / 199) * 100)
        
        this.UpdateDisplayHex()
        this.UpdatePointers()
        
        this.IsDragging := true
        this.DragTarget := "Main"
    }
    
    HueStrip_Click(GuiCtrlObj, Info) {
        CoordMode("Mouse", "Client")
        MouseGetPos(&X, &Y)
        this.HueStrip.GetPos(&CtrlX, &CtrlY)
        
        RelY := Max(0, Min(199, Y - CtrlY))
        this.CurrentHue := (RelY / 199) * 360
        
        this.CreateMainBitmap()
        this.UpdateDisplayHex()
        this.UpdatePointers()
        
        this.IsDragging := true
        this.DragTarget := "Hue"
    }
    
    CheckMouseDrag() {
        if (!this.IsDragging || !this.GUI) {
            return
        }
        
        if (!GetKeyState("LButton", "P")) {
            this.IsDragging := false
            this.DragTarget := ""
            return
        }
        
        CoordMode("Mouse", "Client")
        MouseGetPos(&X, &Y)
        
        if (this.DragTarget = "Main") {
            this.MainRect.GetPos(&CtrlX, &CtrlY)
            RelX := Max(0, Min(359, X - CtrlX))
            RelY := Max(0, Min(199, Y - CtrlY))
            
            NewSat := (RelX / 359) * 100
            NewBright := 100 - ((RelY / 199) * 100)
            
            if (Abs(NewSat - this.CurrentSat) > 0.1 || Abs(NewBright - this.CurrentBright) > 0.1) {
                this.CurrentSat := NewSat
                this.CurrentBright := NewBright
                this.UpdateDisplayHex()
                this.UpdatePointers()
            }
        }
        else if (this.DragTarget = "Hue") {
            this.HueStrip.GetPos(&CtrlX, &CtrlY)
            RelY := Max(0, Min(199, Y - CtrlY))
            NewHue := (RelY / 199) * 360
            
            if (Abs(NewHue - this.CurrentHue) > 0.5) {
                this.CurrentHue := NewHue
                this.CreateMainBitmap()
                this.UpdateDisplayHex()
                this.UpdatePointers()
            }
        }
    }
    
    SendNormal() {
        RGB := this.HSVtoRGB(this.CurrentHue, this.CurrentSat, this.CurrentBright)
        HexColor := this.RGBtoHex(RGB)
        ColorBlocks := "██████"
        
        this.Hide()
        Sleep(50)
        SendText("HEX " . HexColor . " " . ColorBlocks)
    }
    
    SendFormatted() {
        RGB := this.HSVtoRGB(this.CurrentHue, this.CurrentSat, this.CurrentBright)
        HexColor := this.RGBtoHex(RGB)
        ColorBlocks := "██████"
        Components := this.GetRGBComponents(RGB)
        
        FormattedText := "<span style='color:rgb(" . Components.R . "," . Components.G . "," . Components.B . ");font-weight: bolder;'>HEX " . HexColor . " " . ColorBlocks . "</span>"
        this.Hide()
        Sleep(50)
        SendText(FormattedText)
    }
    
    CleanupBitmaps() {
        if (this.MainBitmap) {
            DllCall("DeleteObject", "Ptr", this.MainBitmap)
            this.MainBitmap := ""
        }
        if (this.HueBitmap) {
            DllCall("DeleteObject", "Ptr", this.HueBitmap)
            this.HueBitmap := ""
        }
    }
}

~Esc::
{
    global ColorPicker
    if (ColorPicker && ColorPicker.GUI) {
        ColorPicker.Hide()
    }
}

OnExit(CleanupOnExit)

CleanupOnExit(*) {
    global ColorPicker
    if (ColorPicker) {
        ColorPicker.CleanupBitmaps()
    }
}

class x7f9a2 {
    __New() {
        this.b4e8c := Gui("+Resize", "D.O.A.R. - Dead on Arrival Report")
        this.b4e8c.OnEvent("Close", (*) => this.m9d3f())
        this.b4e8c.Move(, , 1723, 617)
        this.k8h2n()
        this.v3x1p()
        this.t5m4j := this.b4e8c.Add("Tab3", "x10 y10 w1703 h597", ["INPUT", "PRINT FORM", "VIEW"])
        this.t5m4j.OnEvent("Change", this.r2q8v.Bind(this))
        this.t5m4j.UseTab(1)
        this.w6y7u()
        this.t5m4j.UseTab(2)
        this.z1n5e()
        this.t5m4j.UseTab(3)
        this.v7k3m()
        this.l4s9k()
        Hotstring(":O?*:\prdoar", (*) => this.q8p2m())
    }
    m9d3f() {
        c3l7x := MsgBox("Close the D.o.A.R. form ?`nAny Un‑saved datum will be lost.", "Confirm Close", "4")
        if (c3l7x == "Yes") {
            this.b4e8c.Destroy()
            this.h7n8r := true
        }
    }
    v7k3m() {
        this.q2w8x := this.b4e8c.Add("ListView", "x20 y40 w300 h557 Grid", ["№", "Form №"])
        this.q2w8x.OnEvent("ItemSelect", (*) => this.f5t9h())
        
        try {
            this.r8j2s := this.b4e8c.Add("ActiveX", "x330 y40 w1373 h557", "Shell.Explorer")
            this.m6k4p := true
            
            wb := this.r8j2s.Value
            wb.Navigate("about:blank")
            Sleep(500)
            
        } catch Error as err {
            this.m6k4p := false
            this.r8j2s := this.b4e8c.Add("Edit", "x330 y40 w1373 h557 VScroll ReadOnly")
        }
        
        this.d9l1v()
    }
    d9l1v() {
        this.q2w8x.Delete()
        
        try {
            o6y2k := "E:\wwwwww\dosyâlar\dreams\doar.txt"
            
            if (!FileExist(o6y2k)) {
                return
            }
            
            z1r5v := FileRead(o6y2k, "UTF-8")
            d4m9n := StrSplit(z1r5v, "`n")
            
            r8k3m := []
            
            for line in d4m9n {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                y4w9k := this.c6k4w(line)
                if (y4w9k != "") {
                    r8k3m.Push({form_id: y4w9k, line: line})
                }
            }
            
            h3x7c := r8k3m.Length
            loop r8k3m.Length {
                item := r8k3m[r8k3m.Length - A_Index + 1]
                this.q2w8x.Add(, h3x7c, item.form_id)
                h3x7c--
            }
            
        } catch Error as err {
        }
    }
    
    f5t9h() {
        if (this.q2w8x.GetNext() == 0) {
            return
        }
        
        s8n2t := this.q2w8x.GetNext()
        u7p3k := this.q2w8x.GetText(s8n2t, 2)
        
        try {
            o6y2k := "E:\wwwwww\dosyâlar\dreams\doar.txt"
            
            if (!FileExist(o6y2k)) {
                return
            }
            
            z1r5v := FileRead(o6y2k, "UTF-8")
            d4m9n := StrSplit(z1r5v, "`n")
            
            for lineData in d4m9n {
                line := Trim(lineData)
                if (line == "") {
                    continue
                }
                
                if (this.c6k4w(line) == u7p3k) {
                    v2g6x := this.k4z8m(line)
                    this.n8v5w(v2g6x)
                    break
                }
            }
            
        } catch Error as err {
        }
    }
    n8v5w(p5w9d) {
        html := '<!DOCTYPE html>'
        html .= '<html><head><meta charset="UTF-8"><title>D.O.A.R. Form</title></head>'
        html .= '<body><style>#ga tr,td,table{padding:0;margin:0;font-family: Times New Roman, Times, serif;}table{width:100%;border-collapse:collapse;}</style>'
        html .= '<table id="ga">'
        html .= '<tr><td colspan="2" style="text-align:center;font-weight:bolder;font-size:16pt">DEAD on ARRIVAL REPORT</td></tr>'
        html .= '<tr><td style="text-align:left;">№ : ' . (p5w9d.HasOwnProp("doar_form_number") ? p5w9d.doar_form_number : "") . '</td><td style="text-align:right;">Creation : ' . (p5w9d.HasOwnProp("creation_date") ? p5w9d.creation_date : "") . '</td></tr>'
        html .= '<tr><td style="text-align:left;width:50%;">Eﬆ. On-set time : ' . (p5w9d.HasOwnProp("estimated_onset") ? p5w9d.estimated_onset : "") . '</td><td style="text-align:right;">Eﬆ. Wake time : ' . (p5w9d.HasOwnProp("estimated_wake") ? p5w9d.estimated_wake : "") . '</td></tr>'
        html .= '</table>'
        
        html .= '<table><tr><td>"response_wrapper": { "state": ' . (p5w9d.HasOwnProp("state") ? p5w9d.state : "") . ', "message": "' . (p5w9d.HasOwnProp("message") ? p5w9d.message : "") . '", "result_completeness": "' . (p5w9d.HasOwnProp("completeness") ? p5w9d.completeness : "") . '"}</td></tr></table>'
        
        html .= '<table id="ga" style="border:1px solid black;">'
        html .= '<tr style="height:50%;"><td style="width:50%;vertical-align:top;">'
        
        html .= '<table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">A - DREAM INFORMATION</td></tr>'
        html .= '<tr><td style="width:50%;">Dated : ' . (p5w9d.HasOwnProp("dated") ? p5w9d.dated : "") . '</td><td style="width:50%;">Wake time : ' . (p5w9d.HasOwnProp("wake_time") ? p5w9d.wake_time : "") . '</td></tr>'
        html .= '<tr><td style="width:50%;">Eﬆ. On‑set start : ' . (p5w9d.HasOwnProp("onset_start") ? p5w9d.onset_start : "") . '</td><td style="width:50%;">Eﬆ. On‑set end : ' . (p5w9d.HasOwnProp("onset_end") ? p5w9d.onset_end : "") . '</td></tr>'
        html .= '<tr><td style="width:50%;">ʃcraps exist ? ' . (p5w9d.HasOwnProp("scraps_exist") ? p5w9d.scraps_exist : "") . '</td><td style="width:50%;">Comfort dr. sleep : ' . (p5w9d.HasOwnProp("comfort") ? p5w9d.comfort : "") . '</td></tr>'
        html .= '<tr><td style="width:50%;">Fruﬆration : ' . (p5w9d.HasOwnProp("frustration") ? p5w9d.frustration : "") . '</td><td style="width:50%;">Almoﬆ remembered ? ' . (p5w9d.HasOwnProp("almost_had_it") ? p5w9d.almost_had_it : "") . '</td></tr>'
        html .= '<tr><td style="width:50%;">Was It tangible ? ' . (p5w9d.HasOwnProp("could_feel_losing") ? p5w9d.could_feel_losing : "") . '</td><td style="width:50%;">ʃhowed eﬀort to maintain ? ' . (p5w9d.HasOwnProp("effort_to_maintain") ? p5w9d.effort_to_maintain : "") . '</td></tr>'
        html .= '</table>'
        
        html .= '<table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">D - A extended</td></tr>'
        html .= '<tr><td style="width:50%;">ʃleep location : ' . (p5w9d.HasOwnProp("sleep_location") ? p5w9d.sleep_location : "") . '</td><td style="width:50%;">Noise claſsiﬁcation : ' . (p5w9d.HasOwnProp("noise_level") ? p5w9d.noise_level : "") . '</td></tr>'
        html .= '<tr><td style="width:50%;">Environmental zone : ' . (p5w9d.HasOwnProp("environment_type") ? p5w9d.environment_type : "") . '</td><td style="width:50%;">Acceß type : ' . (p5w9d.HasOwnProp("access_type") ? p5w9d.access_type : "") . '</td></tr>'
        html .= '</table>'
        
        html .= '<table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">B - FILER INFORMATION</td></tr>'
        html .= '<tr><td style="width:50%;">Filer name : ' . (p5w9d.HasOwnProp("system") ? p5w9d.system : "") . '</td><td style="width:50%;">Filing date : ' . (p5w9d.HasOwnProp("filing_date") ? p5w9d.filing_date : "") . '</td></tr>'
        html .= '<tr><td style="width:100%;text-align:center;" colspan="2">' . (p5w9d.HasOwnProp("checksum") ? p5w9d.checksum : "") . '</td></tr>'
        html .= '</table>'
        
        html .= '</td><td style="width:50%;vertical-align:top;height:100%;position:relative;">'
        
        html .= '<table style="border:1px solid black;position:absolute;top:0;height:50%;width:100%;"><tr><td colspan="2" style="font-weight:bolder;">V - TYPE OF DEATH</td></tr>'
        html .= '<tr><td style="width:50%;">With reasons ' . (p5w9d.HasOwnProp("with_reasons") ? p5w9d.with_reasons : "") . '</td><td style="width:50%;">With reasons ( inveﬆigation req. ) ' . (p5w9d.HasOwnProp("with_reasons_investment") ? p5w9d.with_reasons_investment : "") . ' - G</td></tr>'
        html .= '<tr><td style="width:50%;">Without reasons ' . (p5w9d.HasOwnProp("without_reasons") ? p5w9d.without_reasons : "") . '</td><td style="width:50%;">Without reasons ( inveﬆigation req. ) ' . (p5w9d.HasOwnProp("without_reasons_investment") ? p5w9d.without_reasons_investment : "") . ' - G</td></tr>'
        html .= '</table>'
        
        html .= '<table style="border:1px solid black;position:absolute;top:50%;height:50%;width:100%;"><tr><td colspan="2" style="font-weight:bolder;">G - Investigation</td></tr>'
        html .= '<tr><td style="width:100%;">1. Was It inveﬆigated ? ' . (p5w9d.HasOwnProp("was_investigated") ? p5w9d.was_investigated : "") . '</td></tr>'
        html .= '<tr><td style="width:100%;">2. Is an inveﬆigation required ? ' . (p5w9d.HasOwnProp("investigation_required") ? p5w9d.investigation_required : "") . '</td></tr>'
        html .= '<tr><td style="width:100%;">3. ʃcene integrity ? ' . (p5w9d.HasOwnProp("scene_integrity") ? p5w9d.scene_integrity : "") . '</td></tr>'
        html .= '<tr><td style="width:100%;">4. Witneß ꜹailable ? ' . (p5w9d.HasOwnProp("witness_available") ? p5w9d.witness_available : "") . '</td></tr>'
        html .= '</table>'
        
        html .= '</td></tr>'
        
        html .= '<tr><td colspan="2"><table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">E - Reason( s ) for death</td></tr>'
        html .= '<tr><td style="width:50%;"><table><tr><td>' . (p5w9d.HasOwnProp("primary_cause") ? p5w9d.primary_cause : "") . (p5w9d.HasOwnProp("primary_other") && p5w9d.primary_other ? " ( " . p5w9d.primary_other . " )" : "") . '</td></tr><tr><td>⮴ secondary to ' . (p5w9d.HasOwnProp("secondary_cause") ? p5w9d.secondary_cause : "") . (p5w9d.HasOwnProp("secondary_other") && p5w9d.secondary_other ? " ( " . p5w9d.secondary_other . " )" : "") . '</td></tr><tr><td>⮴ tertiary to ' . (p5w9d.HasOwnProp("tertiary_cause") ? p5w9d.tertiary_cause : "") . (p5w9d.HasOwnProp("tertiary_other") && p5w9d.tertiary_other ? " ( " . p5w9d.tertiary_other . " )" : "") . '</td></tr><tr><td>⮴ quaternary to ' . (p5w9d.HasOwnProp("quaternary_cause") ? p5w9d.quaternary_cause : "") . (p5w9d.HasOwnProp("quaternary_other") && p5w9d.quaternary_other ? " ( " . p5w9d.quaternary_other . " )" : "") . '</td></tr></table></td>'
        html .= '<td><table style="width:100%;"><tr><td><table style="width:100%;"><tr style="text-align:center;"><td>' . (p5w9d.HasOwnProp("primary_time") ? p5w9d.primary_time : "") . '</td></tr><tr style="text-align:center;"><td>' . (p5w9d.HasOwnProp("secondary_time") ? p5w9d.secondary_time : "") . '</td></tr><tr style="text-align:center;"><td>' . (p5w9d.HasOwnProp("tertiary_time") ? p5w9d.tertiary_time : "") . '</td></tr><tr style="text-align:center;"><td>' . (p5w9d.HasOwnProp("quaternary_time") ? p5w9d.quaternary_time : "") . '</td></tr></table></td></tr></table></td></tr>'
        html .= '</table></td></tr>'
        
        if (p5w9d.HasOwnProp("investigation_required") && p5w9d.investigation_required == "y") {
            html .= '<tr><table style="border:1px solid black;">'
            
            html .= '<tr>'
            html .= '<td colspan="1" style="font-weight:bolder;">Z - Inv. ext. ( when G 2 y )</td>'
            html .= '<td style="width: 25%;">Im. analysis :' . (p5w9d.HasOwnProp("investigation_flag") && p5w9d.investigation_flag == "y" ? "☑" : "☐") . '</td>'
            html .= '<td style="width: 25%;">Pr. level : ' . (p5w9d.HasOwnProp("priority_level") ? p5w9d.priority_level : "") . '</td>'
            html .= '<td style="width: 25%;">Monitoring ' . (p5w9d.HasOwnProp("monitoring_required") && p5w9d.monitoring_required == "y" ? "☑" : "☐") . '</td>'
            html .= '</tr>'
            
            html .= '<tr>'
            html .= '<td style="vertical-align:top;width:25%">ʃcene documentation :<br>Immediate : ' . (p5w9d.HasOwnProp("immediate_notes") ? p5w9d.immediate_notes : "") . '<br>Environmental : ' . (p5w9d.HasOwnProp("environmental_changes") ? p5w9d.environmental_changes : "") . '<br>Equipment : ' . (p5w9d.HasOwnProp("equipment_status") ? p5w9d.equipment_status : "") . '<br>Evidence : ' . (p5w9d.HasOwnProp("physical_evidence") ? p5w9d.physical_evidence : "") . '</td>'
            html .= '<td style="vertical-align:top;width:25%">Time‑line Re-conﬆruction :<br>Pre-failure : ' . (p5w9d.HasOwnProp("pre_failure_sequence") ? p5w9d.pre_failure_sequence : "") . '<br>Failure moment : ' . (p5w9d.HasOwnProp("failure_moment") ? p5w9d.failure_moment : "") . '<br>Post-failure : ' . (p5w9d.HasOwnProp("post_failure_actions") ? p5w9d.post_failure_actions : "") . '<br>Time‑line : ' . (p5w9d.HasOwnProp("estimated_timeline") ? p5w9d.estimated_timeline : "") . '</td>'
            html .= '<td style="width:25%;vertical-align:top;">Witneſs information :<br><table><tr><td>reliability : ' . (p5w9d.HasOwnProp("reliability") ? p5w9d.reliability : "") . '</td><td>relationship : ' . (p5w9d.HasOwnProp("relationship") ? p5w9d.relationship : "") . '</td></tr><tr><td colspan="2">ﬆatement : ' . (p5w9d.HasOwnProp("statement") ? p5w9d.statement : "") . (p5w9d.HasOwnProp("timeline") && p5w9d.timeline ? " , " . p5w9d.timeline . " ago" : "") . '</td></tr></table></td>'
            html .= '<td style="width:25%;vertical-align:top;">Pattern analysis :<br>Match : ' . (p5w9d.HasOwnProp("pattern_match") ? p5w9d.pattern_match : "") . '<br>Re-ocurring : ' . (p5w9d.HasOwnProp("recurring_elements") ? p5w9d.recurring_elements : "") . '<br>Anomaly : ' . (p5w9d.HasOwnProp("anomaly_detection") ? p5w9d.anomaly_detection : "") . '<br>Co‑relation : ' . (p5w9d.HasOwnProp("case_correlation") ? p5w9d.case_correlation : "") . '</td>'
            html .= '</tr>'
            
            html .= '<tr><table style="border:1px solid black;">'
            html .= '<tr><td style="width: 25%;">Photo : ' . (p5w9d.HasOwnProp("photo_documentation") && p5w9d.photo_documentation == "y" ? "☑" : "☐") . '</td><td style="width: 25%;">Audio : ' . (p5w9d.HasOwnProp("audio_evidence") && p5w9d.audio_evidence == "y" ? "☑" : "☐") . '</td><td colspan="2">Markers : ' . (p5w9d.HasOwnProp("markers") ? p5w9d.markers : "") . '</td></tr>'
            html .= '<tr><td style="width: 25%;">Immediate ' . (p5w9d.HasOwnProp("immediate_actions") && p5w9d.immediate_actions ? "☑" : "☐") . '</td><td style="width: 25%;">Prevention ' . (p5w9d.HasOwnProp("prevention_measures") && p5w9d.prevention_measures ? "☑" : "☐") . '</td><td style="width: 50%;">Actions : ' . (p5w9d.HasOwnProp("immediate_actions") ? p5w9d.immediate_actions : "") . " | Tasks : " . (p5w9d.HasOwnProp("investigation_tasks") ? p5w9d.investigation_tasks : "") . " | " . (p5w9d.HasOwnProp("prevention_measures") ? p5w9d.prevention_measures : "") . '</td></tr>'
            html .= '</table></tr>'
            
            html .= '</table></tr>'
        }            
        html .= '</table>'
        
        html .= '<table style="width:100%;"><tr><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;">/s/ ʃunt Vĳelie</td></tr><tr> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"><img src="https://files.catbox.moe/k6q0p2.png" width="206px"></td> </tr></table>'
        html .= '</body></html>'
        
        if (this.m6k4p) {
            try {
                wb := this.r8j2s.Value
                
                wb.Navigate("about:blank")
                
                t2x5k := 0
                while (t2x5k < 100) {
                    try {
                        if (wb.ReadyState == 4) {
                            break
                        }
                    } catch {
                    }
                    Sleep(50)
                    t2x5k++
                }
                
                doc := wb.Document
                if (!doc) {
                    throw Error("Document not available")
                }
                
                doc.Open()
                doc.Write(html)
                doc.Close()
                
            } catch Error as err {
                this.m6k4p := false
                this.r8j2s.Opt("+Hidden")
                this.r8j2s := this.b4e8c.Add("Edit", "x330 y40 w1373 h557 VScroll ReadOnly")
                this.r8j2s.Text := "ActiveX failed: " . err.Message . "`n`nHTML Content:`n`n" . html
            }
        } else {
            if (HasProp(this, "r8j2s")) {
                this.r8j2s.Text := html
            }
        }
    }
    k4z8m(jsonStr) {
        data := {}
        
        if (RegExMatch(jsonStr, '"doar_form_number":"([^"]+)"', &match)) {
            data.doar_form_number := match[1]
        }
        if (RegExMatch(jsonStr, '"creation_date":"([^"]+)"', &match)) {
            data.creation_date := match[1]
        }
        if (RegExMatch(jsonStr, '"filing_date":"([^"]+)"', &match)) {
            data.filing_date := match[1]
        }
        if (RegExMatch(jsonStr, '"checksum":"([^"]+)"', &match)) {
            data.checksum := match[1]
        }
        if (RegExMatch(jsonStr, '"state":"([^"]+)"', &match)) {
            data.state := match[1]
        }
        if (RegExMatch(jsonStr, '"message":"([^"]+)"', &match)) {
            data.message := match[1]
        }
        if (RegExMatch(jsonStr, '"completeness":"([^"]+)"', &match)) {
            data.completeness := match[1]
        }
        
        if (RegExMatch(jsonStr, '"estimated_onset":"([^"]+)"', &match)) {
            data.estimated_onset := match[1]
        }
        if (RegExMatch(jsonStr, '"estimated_wake":"([^"]+)"', &match)) {
            data.estimated_wake := match[1]
        }
        
        if (RegExMatch(jsonStr, '"dated":"([^"]+)"', &match)) {
            data.dated := match[1]
        }
        if (RegExMatch(jsonStr, '"wake_time":"([^"]+)"', &match)) {
            data.wake_time := match[1]
        }
        if (RegExMatch(jsonStr, '"onset_start":"([^"]+)"', &match)) {
            data.onset_start := match[1]
        }
        if (RegExMatch(jsonStr, '"onset_end":"([^"]+)"', &match)) {
            data.onset_end := match[1]
        }
        if (RegExMatch(jsonStr, '"scraps_exist":"([^"]+)"', &match)) {
            data.scraps_exist := match[1]
        }
        if (RegExMatch(jsonStr, '"comfort":"([^"]+)"', &match)) {
            data.comfort := match[1]
        }
        if (RegExMatch(jsonStr, '"frustration":"([^"]+)"', &match)) {
            data.frustration := match[1]
        }
        if (RegExMatch(jsonStr, '"almost_had_it":"([^"]+)"', &match)) {
            data.almost_had_it := match[1]
        }
        if (RegExMatch(jsonStr, '"could_feel_losing":"([^"]+)"', &match)) {
            data.could_feel_losing := match[1]
        }
        if (RegExMatch(jsonStr, '"effort_to_maintain":"([^"]+)"', &match)) {
            data.effort_to_maintain := match[1]
        }
        
        if (RegExMatch(jsonStr, '"sleep_location":"([^"]+)"', &match)) {
            data.sleep_location := match[1]
        }
        if (RegExMatch(jsonStr, '"noise_level":"([^"]+)"', &match)) {
            data.noise_level := match[1]
        }
        if (RegExMatch(jsonStr, '"environment_type":"([^"]+)"', &match)) {
            data.environment_type := match[1]
        }
        if (RegExMatch(jsonStr, '"access_type":"([^"]+)"', &match)) {
            data.access_type := match[1]
        }
        
        if (RegExMatch(jsonStr, '"system":"([^"]+)"', &match)) {
            data.system := match[1]
        }
        
        if (RegExMatch(jsonStr, '"with_reasons":"([^"]+)"', &match)) {
            data.with_reasons := match[1]
        }
        if (RegExMatch(jsonStr, '"with_reasons_investigation":"([^"]+)"', &match)) {
            data.with_reasons_investment := match[1]
        }
        if (RegExMatch(jsonStr, '"without_reasons":"([^"]+)"', &match)) {
            data.without_reasons := match[1]
        }
        if (RegExMatch(jsonStr, '"without_reasons_investigation":"([^"]+)"', &match)) {
            data.without_reasons_investment := match[1]
        }
        
        if (RegExMatch(jsonStr, '"was_investigated":"([^"]+)"', &match)) {
            data.was_investigated := match[1]
        }
        if (RegExMatch(jsonStr, '"investigation_required":"([^"]+)"', &match)) {
            data.investigation_required := match[1]
        }
        if (RegExMatch(jsonStr, '"scene_integrity":"([^"]+)"', &match)) {
            data.scene_integrity := match[1]
        }
        if (RegExMatch(jsonStr, '"witness_available":"([^"]+)"', &match)) {
            data.witness_available := match[1]
        }
        
        if (RegExMatch(jsonStr, '"causes":\[([^\]]*)\]', &causesMatch)) {
            causesStr := causesMatch[1]
            
            data.primary_cause := ""
            data.secondary_cause := ""
            data.tertiary_cause := ""
            data.quaternary_cause := ""
            data.primary_time := ""
            data.secondary_time := ""
            data.tertiary_time := ""
            data.quaternary_time := ""
            data.primary_other := ""
            data.secondary_other := ""
            data.tertiary_other := ""
            data.quaternary_other := ""
            
            primaryMatch := ""
            secondaryMatch := ""
            tertiaryMatch := ""
            quaternaryMatch := ""
            
            if (RegExMatch(causesStr, '\{[^}]*"level":"primary"[^}]*\}', &primaryMatch)) {
                primaryObj := primaryMatch[0]
                if (RegExMatch(primaryObj, '"cause":"([^"]*)"', &match)) {
                    data.primary_cause := match[1]
                }
                if (RegExMatch(primaryObj, '"time":"([^"]*)"', &match)) {
                    data.primary_time := match[1]
                }
                if (RegExMatch(primaryObj, '"other_details":"([^"]*)"', &match)) {
                    data.primary_other := match[1]
                }
            }
            
            if (RegExMatch(causesStr, '\{[^}]*"level":"secondary"[^}]*\}', &secondaryMatch)) {
                secondaryObj := secondaryMatch[0]
                if (RegExMatch(secondaryObj, '"cause":"([^"]*)"', &match)) {
                    data.secondary_cause := match[1]
                }
                if (RegExMatch(secondaryObj, '"time":"([^"]*)"', &match)) {
                    data.secondary_time := match[1]
                }
                if (RegExMatch(secondaryObj, '"other_details":"([^"]*)"', &match)) {
                    data.secondary_other := match[1]
                }
            }
            
            if (RegExMatch(causesStr, '\{[^}]*"level":"tertiary"[^}]*\}', &tertiaryMatch)) {
                tertiaryObj := tertiaryMatch[0]
                if (RegExMatch(tertiaryObj, '"cause":"([^"]*)"', &match)) {
                    data.tertiary_cause := match[1]
                }
                if (RegExMatch(tertiaryObj, '"time":"([^"]*)"', &match)) {
                    data.tertiary_time := match[1]
                }
                if (RegExMatch(tertiaryObj, '"other_details":"([^"]*)"', &match)) {
                    data.tertiary_other := match[1]
                }
            }
            
            if (RegExMatch(causesStr, '\{[^}]*"level":"quaternary"[^}]*\}', &quaternaryMatch)) {
                quaternaryObj := quaternaryMatch[0]
                if (RegExMatch(quaternaryObj, '"cause":"([^"]*)"', &match)) {
                    data.quaternary_cause := match[1]
                }
                if (RegExMatch(quaternaryObj, '"time":"([^"]*)"', &match)) {
                    data.quaternary_time := match[1]
                }
                if (RegExMatch(quaternaryObj, '"other_details":"([^"]*)"', &match)) {
                    data.quaternary_other := match[1]
                }
            }
        }
        
        if (RegExMatch(jsonStr, '"investigation_extended":', &match)) {
            if (RegExMatch(jsonStr, '"investigation_flag":"([^"]+)"', &match)) {
                data.investigation_flag := match[1]
            }
            if (RegExMatch(jsonStr, '"priority_level":"([^"]+)"', &match)) {
                data.priority_level := match[1]
            }
            if (RegExMatch(jsonStr, '"monitoring_required":"([^"]+)"', &match)) {
                data.monitoring_required := match[1]
            }
            if (RegExMatch(jsonStr, '"immediate_notes":"([^"]*)"', &match)) {
                data.immediate_notes := match[1]
            }
            if (RegExMatch(jsonStr, '"environmental_changes":"([^"]*)"', &match)) {
                data.environmental_changes := match[1]
            }
            if (RegExMatch(jsonStr, '"equipment_status":"([^"]*)"', &match)) {
                data.equipment_status := match[1]
            }
            if (RegExMatch(jsonStr, '"physical_evidence":"([^"]*)"', &match)) {
                data.physical_evidence := match[1]
            }
            if (RegExMatch(jsonStr, '"pre_failure_sequence":"([^"]*)"', &match)) {
                data.pre_failure_sequence := match[1]
            }
            if (RegExMatch(jsonStr, '"failure_moment":"([^"]*)"', &match)) {
                data.failure_moment := match[1]
            }
            if (RegExMatch(jsonStr, '"post_failure_actions":"([^"]*)"', &match)) {
                data.post_failure_actions := match[1]
            }
            if (RegExMatch(jsonStr, '"estimated_timeline":"([^"]*)"', &match)) {
                data.estimated_timeline := match[1]
            }
            if (RegExMatch(jsonStr, '"relationship":"([^"]*)"', &match)) {
                data.relationship := match[1]
            }
            if (RegExMatch(jsonStr, '"reliability":"([^"]*)"', &match)) {
                data.reliability := match[1]
            }
            if (RegExMatch(jsonStr, '"statement":"([^"]*)"', &match)) {
                data.statement := match[1]
            }
            if (RegExMatch(jsonStr, '"timeline":"([^"]*)"', &match)) {
                data.timeline := match[1]
            }
            if (RegExMatch(jsonStr, '"markers":"([^"]*)"', &match)) {
                data.markers := match[1]
            }
            if (RegExMatch(jsonStr, '"photo_documentation":"([^"]+)"', &match)) {
                data.photo_documentation := match[1]
            }
            if (RegExMatch(jsonStr, '"audio_evidence":"([^"]+)"', &match)) {
                data.audio_evidence := match[1]
            }
            if (RegExMatch(jsonStr, '"pattern_match":"([^"]*)"', &match)) {
                data.pattern_match := match[1]
            }
            if (RegExMatch(jsonStr, '"recurring_elements":"([^"]*)"', &match)) {
                data.recurring_elements := match[1]
            }
            if (RegExMatch(jsonStr, '"anomaly_detection":"([^"]*)"', &match)) {
                data.anomaly_detection := match[1]
            }
            if (RegExMatch(jsonStr, '"case_correlation":"([^"]*)"', &match)) {
                data.case_correlation := match[1]
            }
            if (RegExMatch(jsonStr, '"immediate_actions":"([^"]*)"', &match)) {
                data.immediate_actions := match[1]
            }
            if (RegExMatch(jsonStr, '"investigation_tasks":"([^"]*)"', &match)) {
                data.investigation_tasks := match[1]
            }
            if (RegExMatch(jsonStr, '"prevention_measures":"([^"]*)"', &match)) {
                data.prevention_measures := match[1]
            }
        }
        
        return data
    }
    k8h2n() {
        this.f2d9w := [
            "",
            "D.1.01 - Memory-consolidation failure during transition to C1",
            "D.1.02 - External ﬅimuli interference during somnium", 
            "D.1.03 - Rapid Un-planned awakening",
            "D.1.04 - Absence of Immediate-recording method",
            "D.1.05 - R.E.-M.-intrusion phenomena",
            "D.1.06 - Lucid-dream techniquͤ failure",
            "D.1.07 - Hypno-pompic-recording failure",
            "D.1.98 - Other",
            "D.1.99 - Un-known",
            "D.2.01 - ʃubﬆance interference",
            "D.2.02 - Pre-sleep Meal-timing",
            "D.2.03 - Hydration extremes", 
            "D.2.04 - Sleep-position complications",
            "D.2.05 - Pre-sleep ʃcreen-exposure",
            "D.2.06 - Exercise timing disruption",
            "D.2.07 - Partner ʃleep-disturbances",
            "D.2.08 - Performance anxiety",
            "D.2.09 - Temperature Dis-comfort",
            "D.2.10 - Environmental noise",
            "D.2.11 - Environmental light",
            "D.2.12 - Bladder preßure",
            "D.2.13 - Stress / worry ﬆate",
            "D.2.98 - Other",
            "D.2.99 - Un-known",
            "D.3.01 - Chronic ʃleep-debt",
            "D.3.02 - Ir-regular ʃleep-schedule",
            "D.3.03 - Medication use",
            "D.3.04 - Sleep-practice In-experience",
            "D.3.05 - Environmental conditioning",
            "D.3.06 - Sleep Dis-order symptoms",
            "D.3.98 - Other",
            "D.3.99 - Un-known",
            "D.4.01 - Work-schedule streß",
            "D.4.02 - Living-situation impacts",
            "D.4.03 - Information Over‑load",
            "D.4.98 - Other",
            "D.4.99 - Un-known"
        ]
    }
    
    v3x1p() {
        d8m2s := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        this.a6t4k := ""
        loop 13 {
            this.a6t4k .= SubStr(d8m2s, Random(1, StrLen(d8m2s)), 1)
        }
    }
    
    w6y7u() {
        j9g3h := this.b4e8c.Add("GroupBox", "x20 y40 w1683 h80", "HEADER INFORMATION")
        this.b4e8c.Add("Text", "x30 y60 w100 h20", "№ :")
        this.o1p7r := this.b4e8c.Add("Edit", "x135 y60 w200 h20 ReadOnly")
        this.b4e8c.Add("Text", "x350 y60 w100 h20", "Creation date:")
        this.e5s2t := this.b4e8c.Add("Edit", "x455 y60 w120 h20")
        this.b4e8c.Add("Text", "x30 y85 w100 h20", "Eﬆ. On‑set time :")
        this.u9v6n := this.b4e8c.Add("Edit", "x135 y85 w120 h20")
        this.b4e8c.Add("Text", "x270 y85 w100 h20", "Eﬆ. Wake time :")
        this.y2c8l := this.b4e8c.Add("Edit", "x375 y85 w120 h20")
        this.y2c8l.OnEvent("Change", (*) => this.n7w3q())
        i4f5g := this.b4e8c.Add("GroupBox", "x20 y130 w1683 h50", "RESPONSE WRAPPER")
        this.b4e8c.Add("Text", "x30 y150 w50 h20", "ﬅate :")
        this.x8k9b := this.b4e8c.Add("DropDownList", "x85 y150 w60 h120", ["0", "1", "2"])
        this.x8k9b.Choose(2)
        this.b4e8c.Add("Text", "x160 y150 w60 h20", "Meßage :")
        this.m3t1d := this.b4e8c.Add("Edit", "x225 y150 w100 h20", "norm")
        this.b4e8c.Add("Text", "x340 y150 w80 h20", "Completeneſs :")
        this.p7h4y := this.b4e8c.Add("DropDownList", "x425 y150 w100 h120", ["basic", "full"])
        this.p7h4y.Choose(1)
        s6z2a := this.b4e8c.Add("GroupBox", "x20 y190 w840 h300", "")
        r9l5c := this.b4e8c.Add("GroupBox", "x30 y200 w820 h120", "A - DREAM INFORMATION")
        this.b4e8c.Add("Text", "x40 y220 w60 h20", "Dated :")
        this.q4w7v := this.b4e8c.Add("Edit", "x105 y220 w100 h20")
        this.b4e8c.Add("Text", "x220 y220 w70 h20", "Wake time :")
        this.j8x5n := this.b4e8c.Add("Edit", "x295 y220 w100 h20")
        this.j8x5n.OnEvent("Change", (*) => this.n7w3q())
        this.b4e8c.Add("Text", "x40 y245 w80 h20", "On‑set ﬆart :")
        this.k2g9m := this.b4e8c.Add("Edit", "x125 y245 w100 h20")
        this.b4e8c.Add("Text", "x240 y245 w70 h20", "On‑set end :")
        this.f1c6t := this.b4e8c.Add("Edit", "x315 y245 w100 h20")
        this.i5y3e := this.b4e8c.Add("Checkbox", "x40 y270 w120 h20", "ʃcraps exist")
        this.h7b8d := this.b4e8c.Add("Checkbox", "x170 y270 w120 h20", "Almoﬆ remembered")
        this.l9s4f := this.b4e8c.Add("Checkbox", "x300 y270 w120 h20", "‘twas tangible")
        this.w3n1j := this.b4e8c.Add("Checkbox", "x430 y270 w150 h20", "ʃhowed eﬀort to maintain")
        this.b4e8c.Add("Text", "x40 y295 w80 h20", "Comfort level :")
        this.v8p2r := this.b4e8c.Add("DropDownList", "x125 y295 w50 h120", ["1", "2", "3", "4", "5"])
        this.b4e8c.Add("Text", "x190 y295 w90 h20", "Fruﬆration level :")
        this.t4m7g := this.b4e8c.Add("DropDownList", "x285 y295 w50 h120", ["1", "2", "3", "4", "5"])
        z5q6u := this.b4e8c.Add("GroupBox", "x30 y330 w820 h80", "D - EXTENDED INFORMATION")
        this.b4e8c.Add("Text", "x40 y350 w90 h20", "ʃleep Location :")
        this.d8l3k := this.b4e8c.Add("DropDownList", "x135 y350 w120 h120", ["Bed‑rꝏm", "couch", "hotel", "Guͤﬆ rꝏm", "out‑of‑dꝏrs", "other"])
        this.b4e8c.Add("Text", "x270 y350 w80 h20", "Noise level :")
        this.c7x9w := this.b4e8c.Add("DropDownList", "x355 y350 w120 h120", ["quiet", "moderate", "noisy", "chaotic", "other"])
        this.b4e8c.Add("Text", "x40 y375 w80 h20", "Environment :")
        this.a1f5h := this.b4e8c.Add("DropDownList", "x125 y375 w120 h120", ["urban", "ʃub‑urban", "rural", "travel", "other"])
        this.b4e8c.Add("Text", "x260 y375 w80 h20", "Acceſs type :")
        this.s9v2y := this.b4e8c.Add("DropDownList", "x345 y375 w120 h120", ["personal", "shared", "guͤﬆ", "other"])
        b6n8c := this.b4e8c.Add("GroupBox", "x30 y420 w820 h60", "B - FILER INFORMATION (Auto-Generated)")
        this.b4e8c.Add("Text", "x40 y440 w50 h20", "Filer :")
        this.g3t7p := this.b4e8c.Add("Edit", "x95 y440 w100 h20 ReadOnly", "ELECTRONIC")
        this.b4e8c.Add("Text", "x210 y440 w70 h20", "Filing date :")
        this.r5k1z := this.b4e8c.Add("Edit", "x285 y440 w150 h20 ReadOnly")
        this.b4e8c.Add("Text", "x40 y460 w60 h20", "Check-sum :")
        this.n4j8x := this.b4e8c.Add("Edit", "x105 y460 w300 h20 ReadOnly")
        m2w7l := this.b4e8c.Add("GroupBox", "x870 y190 w833 h300", "")
        q1d6s := this.b4e8c.Add("GroupBox", "x880 y200 w813 h140", "V - TYPE OF DEATH")
        this.p8h3y := this.b4e8c.Add("Radio", "x890 y220 w200 h20", "With Reasons")
        this.p8h3y.OnEvent("Click", (*) => this.e7m9f())
        this.u2b5r := this.b4e8c.Add("Radio", "x890 y245 w250 h20", "With Reasons ( inv. rq. )")
        this.u2b5r.OnEvent("Click", (*) => this.e7m9f())
        this.k6l4n := this.b4e8c.Add("Radio", "x890 y270 w200 h20", "Without Reasons")
        this.k6l4n.OnEvent("Click", (*) => this.e7m9f())
        this.t3s8w := this.b4e8c.Add("Radio", "x890 y295 w250 h20", "Without Reasons ( inv. req. )")
        this.t3s8w.OnEvent("Click", (*) => this.e7m9f())
        this.x1v7c := this.b4e8c.Add("GroupBox", "x880 y350 w813 h140 Disabled", "G - INVESTIGATION BASIC")
        this.f9g2j := this.b4e8c.Add("Checkbox", "x890 y370 w200 h20 Disabled", "1. Was It inveﬆigated ?")
        this.h4k6m := this.b4e8c.Add("Checkbox", "x890 y405 w250 h20 Disabled", "2. Is an Inveﬆigation req. ?")
        this.h4k6m.OnEvent("Click", (*) => this.z8p1q())
        this.l7n3d := this.b4e8c.Add("Checkbox", "x890 y430 w200 h20 Disabled", "3. ʃcene integrity ?")
        this.y5t9e := this.b4e8c.Add("Checkbox", "x890 y455 w200 h20 Disabled", "4. Witneß ꜹailable ?")
        o8i2v := this.b4e8c.Add("GroupBox", "x20 y500 w1683 h80", "E - REASONS FOR DEATH")
        this.b4e8c.Add("Text", "x30 y520 w80 h20", "Primary Cause:")
        this.w6u4g := this.b4e8c.Add("DropDownList", "x115 y520 w300 h120", this.f2d9w)
        this.w6u4g.OnEvent("Change", (*) => this.c2x5l("primary"))
        this.b4e8c.Add("Text", "x30 y545 w80 h20", "ʃecondary to :")
        this.d1m8s := this.b4e8c.Add("DropDownList", "x115 y545 w300 h120 Disabled", this.f2d9w)
        this.d1m8s.OnEvent("Change", (*) => this.c2x5l("secondary"))
        this.b4e8c.Add("Text", "x430 y520 w70 h20", "Tertiary to :")
        this.r7q3f := this.b4e8c.Add("DropDownList", "x505 y520 w300 h120 Disabled", this.f2d9w)
        this.r7q3f.OnEvent("Change", (*) => this.c2x5l("tertiary"))
        this.b4e8c.Add("Text", "x430 y545 w80 h20", "Quaternary to :")
        this.j9k2h := this.b4e8c.Add("DropDownList", "x515 y545 w300 h120 Disabled", this.f2d9w)
        this.j9k2h.OnEvent("Change", (*) => this.c2x5l("quaternary"))
        this.b4e8c.Add("Text", "x830 y520 w100 h20", "Primary time :")
        this.i3w7b := this.b4e8c.Add("Edit", "x930 y520 w50 h20 Number Center")
        this.b4e8c.Add("Text", "x985 y520 w10 h20 Center", "/")
        this.v4n1t := this.b4e8c.Add("Edit", "x1000 y520 w50 h20 Center")
        this.b4e8c.Add("Text", "x830 y545 w100 h20", "ʃecondary time :")
        this.s8l6z := this.b4e8c.Add("Edit", "x930 y545 w50 h20 Number Center Disabled")
        this.b4e8c.Add("Text", "x985 y545 w10 h20 Center", "/")
        this.a5p9x := this.b4e8c.Add("Edit", "x1000 y545 w50 h20 Center Disabled")
        this.b4e8c.Add("Text", "x1070 y520 w80 h20", "Tertiary time :")
        this.m2j4r := this.b4e8c.Add("Edit", "x1155 y520 w50 h20 Number Center Disabled")
        this.b4e8c.Add("Text", "x1210 y520 w10 h20 Center", "/")
        this.g8c3e := this.b4e8c.Add("Edit", "x1225 y520 w50 h20 Center Disabled")
        this.b4e8c.Add("Text", "x1070 y545 w90 h20", "Quaternary time :")
        this.f7v5k := this.b4e8c.Add("Edit", "x1165 y545 w50 h20 Number Center Disabled")
        this.b4e8c.Add("Text", "x1220 y545 w10 h20 Center", "/")
        this.b1h9u := this.b4e8c.Add("Edit", "x1235 y545 w50 h20 Center Disabled")
        this.q6d2y := this.b4e8c.Add("Edit", "x1300 y520 w200 h20 Hidden")
        this.w9x1p := this.b4e8c.Add("Edit", "x1300 y545 w200 h20 Hidden")
        this.l3f8n := this.b4e8c.Add("Edit", "x1520 y520 w200 h20 Hidden")
        this.t4s7m := this.b4e8c.Add("Edit", "x1520 y545 w200 h20 Hidden")
        this.z5g4j := this.b4e8c.Add("Text", "x1300 y500 w200 h20 Hidden", "Primary Other details :")
        this.c8k1w := this.b4e8c.Add("Text", "x1300 y525 w200 h20 Hidden", "ʃecondary Other details :")
        this.h6v9r := this.b4e8c.Add("Text", "x1520 y500 w200 h20 Hidden", "Tertiary Other details :")
        this.o2l3q := this.b4e8c.Add("Text", "x1520 y525 w200 h20 Hidden", "Quaternary Other details :")
        this.u7n4s := this.b4e8c.Add("GroupBox", "x20 y590 w1683 h340 Hidden", "Z - INVESTIGATION EXTENDED ( Fill when G 2 is y )")
        a9m5t := this.b4e8c.Add("GroupBox", "x30 y610 w820 h50", "Initial aſseßment")
        this.b4e8c.Add("Text", "x40 y630 w100 h20", "Investigation ﬂag :")
        this.e4p8v := this.b4e8c.Add("Checkbox", "x145 y630 w200 h20 Disabled", "Req. Immediate ʃcene‑analysis")
        this.b4e8c.Add("Text", "x360 y630 w80 h20", "Priority level :")
        this.k7y2f := this.b4e8c.Add("DropDownList", "x445 y630 w100 h120 Disabled", ["", "low", "medium", "high", "critical"])
        x1w6g := this.b4e8c.Add("GroupBox", "x860 y610 w820 h50", "Additional Case information")
        this.b4e8c.Add("Text", "x870 y630 w100 h20", "Case Correlation:")
        this.n3q9h := this.b4e8c.Add("Edit", "x975 y630 w300 h20 Disabled")
        this.d6s2c := this.b4e8c.Add("Checkbox", "x1290 y630 w200 h20 Disabled", "Monitoring req. ?")
        r8b5z := this.b4e8c.Add("GroupBox", "x30 y670 w540 h120", "Scene documentation")
        this.b4e8c.Add("Text", "x40 y690 w120 h20", "Immediate scene notes :")
        this.m7t1k := this.b4e8c.Add("Edit", "x165 y690 w390 h25 VScroll Disabled")
        this.b4e8c.Add("Text", "x40 y720 w120 h20", "Environmental changes :")
        this.p4x8j := this.b4e8c.Add("Edit", "x165 y720 w390 h25 VScroll Disabled")
        this.b4e8c.Add("Text", "x40 y750 w100 h20", "Equipment ﬆatus :")
        this.v9l3w := this.b4e8c.Add("Edit", "x145 y750 w180 h20 Disabled")
        this.b4e8c.Add("Text", "x340 y750 w100 h20", "Physical evidence :")
        this.f2h7u := this.b4e8c.Add("Edit", "x445 y750 w110 h20 Disabled")
        q5i6n := this.b4e8c.Add("GroupBox", "x580 y670 w540 h120", "Time‑line Re-conﬆruction")
        this.b4e8c.Add("Text", "x590 y690 w120 h20", "Pre-failure sequͤnce :")
        this.g1c9r := this.b4e8c.Add("Edit", "x715 y690 w390 h25 VScroll Disabled")
        this.b4e8c.Add("Text", "x590 y720 w100 h20", "Failure moment :")
        this.y6s4d := this.b4e8c.Add("Edit", "x695 y720 w410 h25 VScroll Disabled")
        this.b4e8c.Add("Text", "x590 y750 w120 h20", "Post-failure actions :")
        this.k3m2l := this.b4e8c.Add("Edit", "x715 y750 w180 h20 Disabled")
        this.b4e8c.Add("Text", "x905 y750 w100 h20", "Eﬆ. Time‑line :")
        this.j8w5f := this.b4e8c.Add("Edit", "x1010 y750 w95 h20 Disabled")
        h4z7v := this.b4e8c.Add("GroupBox", "x1130 y670 w540 h120", "Witness ﬆatements")
        this.b4e8c.Add("Text", "x1140 y690 w80 h20", "Relationship :")
        this.t9x1b := this.b4e8c.Add("DropDownList", "x1225 y690 w120 h120 Disabled", ["", "partner", "Rꝏm‑mate", "family", "other"])
        this.b4e8c.Add("Text", "x1360 y690 w60 h20", "Reliability :")
        this.r2p6k := this.b4e8c.Add("DropDownList", "x1425 y690 w60 h120 Disabled", ["", "1", "2", "3", "4", "5"])
        this.b4e8c.Add("Text", "x1140 y720 w60 h20", "ﬅatement :")
        this.n5q8m := this.b4e8c.Add("Edit", "x1205 y720 w450 h25 VScroll Disabled")
        this.b4e8c.Add("Text", "x1140 y750 w60 h20", "Time‑line :")
        this.l7d3g := this.b4e8c.Add("Edit", "x1205 y750 w280 h20 Disabled")
        s4y9e := this.b4e8c.Add("GroupBox", "x30 y800 w540 h120", "Evidence Collection")
        this.b4e8c.Add("Text", "x40 y820 w100 h20", "Evidence markers :")
        this.v8h1c := this.b4e8c.Add("Edit", "x145 y820 w390 h25 VScroll Disabled")
        this.i6f4x := this.b4e8c.Add("Checkbox", "x40 y850 w150 h20 Disabled", "Photo documentation")
        this.w3j7z := this.b4e8c.Add("Checkbox", "x200 y850 w120 h20 Disabled", "Audio evidence")
        c1b8u := this.b4e8c.Add("GroupBox", "x580 y800 w540 h120", "Pattern analysis")
        this.b4e8c.Add("Text", "x590 y820 w80 h20", "Pattern match :")
        this.o9k2t := this.b4e8c.Add("Edit", "x675 y820 w430 h25 VScroll Disabled")
        this.b4e8c.Add("Text", "x590 y850 w100 h20", "Re-occuring elements :")
        this.a7l5s := this.b4e8c.Add("Edit", "x695 y850 w410 h20 Disabled")
        this.b4e8c.Add("Text", "x590 y875 w100 h20", "Anomaly detection :")
        this.m4n6p := this.b4e8c.Add("Edit", "x695 y875 w410 h20 Disabled")
        z2e9w := this.b4e8c.Add("GroupBox", "x1130 y800 w540 h120", "Follow-up actions")
        this.b4e8c.Add("Text", "x1140 y820 w120 h20", "Immediate actions :")
        this.u5r3q := this.b4e8c.Add("Edit", "x1265 y820 w390 h25 VScroll Disabled")
        this.b4e8c.Add("Text", "x1140 y850 w100 h20", "Inveﬆigation tasks :")
        this.x1g8d := this.b4e8c.Add("Edit", "x1245 y850 w410 h20 Disabled")
        this.b4e8c.Add("Text", "x1140 y875 w120 h20", "Prevention measures :")
        this.f6t4y := this.b4e8c.Add("Edit", "x1265 y875 w390 h20 Disabled")
        this.b9s7v()
    }

    b8x4k() {
    l3m2s := 1000
    c9w7f := 0
    
    while (c9w7f < l3m2s) {
        c9w7f++
        
        p5n1q := this.i2d6x()
        j4r8v := 0
        
        for i, char in StrSplit(this.a6t4k) {
            j4r8v += Ord(char) * i
        }
        
        for key, value in p5n1q.OwnProps() {
            if (Type(value) == "String") {
                for i, char in StrSplit(value) {
                    j4r8v += Ord(char) * i
                }
            }
        }
        
        j4r8v += c9w7f * 7919
        
        h9t2e := ""
        d8l5k := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        y7b3n := Mod(j4r8v, 238328)
        
        loop 3 {
            h9t2e := SubStr(d8l5k, Mod(y7b3n, 62) + 1, 1) . h9t2e
            y7b3n := y7b3n // 62
        }
        
        w1x6u := SubStr(this.a6t4k, 1, 4) . "-" . SubStr(this.a6t4k, 5, 4) . "-" . SubStr(this.a6t4k, 9, 2) . "-" . SubStr(this.a6t4k, 11, 3) . "/" . h9t2e . "="
        
        if (!this.s4c9m(w1x6u)) {
            this.n4j8x.Text := w1x6u
            return
        }
        
        this.v3x1p()
    }
    
    this.n4j8x.Text := "ERROR-DUPLICATE-CHECKSUM"
    }

    t3z7g() {
    v2k8h := 1000
    f9l1c := 0
    
    r6m4x := this.q7u2n()
    
    while (f9l1c < v2k8h) {
        f9l1c++
        
        s3w5j := [
            this.e4p1t(this.w6u4g.Text),
            this.e4p1t(this.d1m8s.Text), 
            this.e4p1t(this.r7q3f.Text),
            this.e4p1t(this.j9k2h.Text)
        ]
        
        z8y6b := 0
        for i, cause in s3w5j {
            if (cause > 0) {
                z8y6b += cause * i
            }
        }
        
        z8y6b += f9l1c * 17
        
        u4h9d := Format("{:03d}", Mod(z8y6b, 1000))
        
        a1k7n := ""
        loop 5 {
            a1k7n .= Random(0, 9)
        }
        
        p2x3m := "E.FRM/DAR-" . u4h9d . "-" . a1k7n . "/" . r6m4x
        
        if (!this.g8v5s(p2x3m)) {
            return p2x3m
        }
        
        Random(, A_TickCount + f9l1c)
    }
    
    return "E.FRM/DAR-ERROR-DUPLICATE/" . r6m4x
    }

    s4c9m(h3w8q) {
        try {
            o6y2k := "E:\wwwwww\dosyâlar\dreams\doar.txt"
            
            if (!FileExist(o6y2k)) {
                return false
            }
            
            z1r5v := FileRead(o6y2k, "UTF-8")
            
            d4m9n := StrSplit(z1r5v, "`n")
            
            for line in d4m9n {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                if (this.l7t3x(line) == h3w8q) {
                    return true
                }
            }
            
            return false
            
        } catch Error as err {
            return false
        }
    }

    g8v5s(j2f9u) {
        try {
            o6y2k := "E:\wwwwww\dosyâlar\dreams\doar.txt"
            
            if (!FileExist(o6y2k)) {
                return false
            }
            
            z1r5v := FileRead(o6y2k, "UTF-8")
            
            d4m9n := StrSplit(z1r5v, "`n")
            
            for line in d4m9n {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                if (this.c6k4w(line) == j2f9u) {
                    return true
                }
            }
            
            return false
            
        } catch Error as err {
            return false
        }
    }

    q7u2n() {
        try {
            o6y2k := "E:\wwwwww\dosyâlar\dreams\doar.txt"
            
            if (!FileExist(o6y2k)) {
                return 1
            }
            
            z1r5v := FileRead(o6y2k, "UTF-8")
            
            d4m9n := StrSplit(z1r5v, "`n")
            m8x3e := 0
            
            for line in d4m9n {
                line := Trim(line)
                if (line != "") {
                    m8x3e++
                }
            }
            
            return m8x3e + 1
            
        } catch Error as err {
            return 1
        }
    }

    l7t3x(s9b6p) {
        try {
            if (RegExMatch(s9b6p, '"checksum":"([^"]+)"', &match)) {
                return match[1]
            }
            
            if (RegExMatch(s9b6p, '"metadata":\s*{[^}]*"checksum":"([^"]+)"', &match)) {
                return match[1]
            }
            
            return ""
            
        } catch Error as err {
            return ""
        }
    }

    b9s7v() {
        k4w2s := [this.e5s2t, this.u9v6n, this.y2c8l,
                    this.q4w7v, this.j8x5n, this.k2g9m, this.f1c6t,
                    this.w6u4g, this.d1m8s, this.r7q3f, this.j9k2h]
        
        for control in k4w2s {
            if (control.HasMethod("OnEvent")) {
                control.OnEvent("Change", (*) => this.b8x4k())
            }
        }
    }

    c6k4w(s9b6p) {
        try {
            if (RegExMatch(s9b6p, '"doar_form_number":"([^"]+)"', &match)) {
                return match[1]
            }
            
            if (RegExMatch(s9b6p, '"metadata":\s*{[^}]*"doar_form_number":"([^"]+)"', &match)) {
                return match[1]
            }
            
            return ""
            
        } catch Error as err {
            return ""
        }
    }

        e4p1t(v7n2k) {
            if (RegExMatch(v7n2k, "D\.(\d)\.(\d+)", &match)) {
                return Integer(match[2])
            }
            return 0
        }
        
    e7m9f() {
        g1x4m := this.h8d2y(FormatTime(, "yyyyMMddhhmmsstt"))
        this.r5k1z.Text := g1x4m
        
        w3f6s := this.u2b5r.Value || this.t3s8w.Value
        
        if (w3f6s) {
            this.x1v7c.Enabled := true
            this.f9g2j.Enabled := true
            this.h4k6m.Enabled := true
            this.l7n3d.Enabled := true
            this.y5t9e.Enabled := true
        } else {
            this.x1v7c.Enabled := false
            this.f9g2j.Enabled := false
            this.h4k6m.Enabled := false
            this.l7n3d.Enabled := false
            this.y5t9e.Enabled := false
            
            this.u7n4s.Visible := false
            this.h4k6m.Value := false
            
            this.b4e8c.Move(, , 1723, 657)
            this.t5m4j.Move(, , 1703, 637)
            
            if (this.j6n8r) {
                this.z4x1w.Move(, , 1683, 500)
            } else {
                if (HasProp(this, "k2m7t")) {
                    this.k2m7t.Move(, , 1683, 500)
                } else {
                    this.z4x1w.Move(, , 1683, 500)
                }
            }
            
            this.s3f9k.Move(, 570, , )
            this.p1h5v.Move(, 570, , )
            this.l8w4n.Move(, 570, , )
        }
    }
        
        c2x5l(level) {
            g1x4m := this.h8d2y(FormatTime(, "yyyyMMddhhmmsstt"))
            this.r5k1z.Text := g1x4m
            
            this.n9q3b()
            
            switch level {
                case "primary":
                    if (InStr(this.w6u4g.Text, "Other")) {
                        this.q6d2y.Visible := true
                        this.z5g4j.Visible := true
                    } else {
                        this.q6d2y.Visible := false
                        this.z5g4j.Visible := false
                    }
                case "secondary":
                    if (InStr(this.d1m8s.Text, "Other")) {
                        this.w9x1p.Visible := true
                        this.c8k1w.Visible := true
                    } else {
                        this.w9x1p.Visible := false
                        this.c8k1w.Visible := false
                    }
                case "tertiary":
                    if (InStr(this.r7q3f.Text, "Other")) {
                        this.l3f8n.Visible := true
                        this.h6v9r.Visible := true
                    } else {
                        this.l3f8n.Visible := false
                        this.h6v9r.Visible := false
                    }
                case "quaternary":
                    if (InStr(this.j9k2h.Text, "Other")) {
                        this.t4s7m.Visible := true
                        this.o2l3q.Visible := true
                    } else {
                        this.t4s7m.Visible := false
                        this.o2l3q.Visible := false
                    }
            }
            this.x5k7p()
            this.b8x4k()
        }
        
        n9q3b() {
            if (this.w6u4g.Text && this.w6u4g.Text != "") {
                this.d1m8s.Enabled := true
                this.s8l6z.Enabled := true
                this.a5p9x.Enabled := true
            } else {
                this.d1m8s.Enabled := false
                this.d1m8s.Choose(1)
                this.s8l6z.Enabled := false
                this.a5p9x.Enabled := false
                this.s8l6z.Text := ""
                this.a5p9x.Text := ""
            }
            
            if (this.d1m8s.Text && this.d1m8s.Text != "") {
                this.r7q3f.Enabled := true
                this.m2j4r.Enabled := true
                this.g8c3e.Enabled := true
            } else {
                this.r7q3f.Enabled := false
                this.r7q3f.Choose(1)
                this.m2j4r.Enabled := false
                this.g8c3e.Enabled := false
                this.m2j4r.Text := ""
                this.g8c3e.Text := ""
            }
            
            if (this.r7q3f.Text && this.r7q3f.Text != "") {
                this.j9k2h.Enabled := true
                this.f7v5k.Enabled := true
                this.b1h9u.Enabled := true
            } else {
                this.j9k2h.Enabled := false
                this.j9k2h.Choose(1)
                this.f7v5k.Enabled := false
                this.b1h9u.Enabled := false
                this.f7v5k.Text := ""
                this.b1h9u.Text := ""
            }
        }
        
        x5k7p() {
            this.o1p7r.Text := this.t3z7g()
        }
        
        n7w3q() {
            g1x4m := this.h8d2y(FormatTime(, "yyyyMMddhhmmsstt"))
            this.r5k1z.Text := g1x4m
            
            if (this.y2c8l.Focused) {
                this.j8x5n.Text := this.y2c8l.Text
            } else if (this.j8x5n.Focused) {
                this.y2c8l.Text := this.j8x5n.Text
            }
        }
        z8p1q() {
            if (this.h4k6m.Value) {
                this.u7n4s.Visible := true
                
                this.b4e8c.Move(, , 1723, 1015)
                this.t5m4j.Move(, , 1703, 995)
                
                if (this.j6n8r) {
                    this.z4x1w.Move(, , 1683, 898)
                } else {
                    if (HasProp(this, "k2m7t")) {
                        this.k2m7t.Move(, , 1683, 898)
                    } else {
                        this.z4x1w.Move(, , 1683, 898)
                    }
                }
                
                this.s3f9k.Move(, 948, , )
                this.p1h5v.Move(, 948, , )
                this.l8w4n.Move(, 948, , )
                
                this.e4p8v.Enabled := true
                this.k7y2f.Enabled := true
                this.n3q9h.Enabled := true
                this.d6s2c.Enabled := true
                
                this.m7t1k.Enabled := true
                this.p4x8j.Enabled := true
                this.v9l3w.Enabled := true
                this.f2h7u.Enabled := true
                
                this.g1c9r.Enabled := true
                this.y6s4d.Enabled := true
                this.k3m2l.Enabled := true
                this.j8w5f.Enabled := true
                
                this.t9x1b.Enabled := true
                this.r2p6k.Enabled := true
                this.n5q8m.Enabled := true
                this.l7d3g.Enabled := true
                
                this.v8h1c.Enabled := true
                this.i6f4x.Enabled := true
                this.w3j7z.Enabled := true
                
                this.o9k2t.Enabled := true
                this.a7l5s.Enabled := true
                this.m4n6p.Enabled := true
                
                this.u5r3q.Enabled := true
                this.x1g8d.Enabled := true
                this.f6t4y.Enabled := true
                
            } else {
                this.u7n4s.Visible := false
                
                this.b4e8c.Move(, , 1723, 657)
                this.t5m4j.Move(, , 1703, 637)
                
                if (this.j6n8r) {
                    this.z4x1w.Move(, , 1683, 500)
                } else {
                    if (HasProp(this, "k2m7t")) {
                        this.k2m7t.Move(, , 1683, 500)
                    } else {
                        this.z4x1w.Move(, , 1683, 500)
                    }
                }
                
                this.s3f9k.Move(, 570, , )
                this.p1h5v.Move(, 570, , )
                this.l8w4n.Move(, 570, , )
                
                this.e4p8v.Enabled := false
                this.k7y2f.Enabled := false
                this.n3q9h.Enabled := false
                this.d6s2c.Enabled := false
                
                this.m7t1k.Enabled := false
                this.p4x8j.Enabled := false
                this.v9l3w.Enabled := false
                this.f2h7u.Enabled := false
                
                this.g1c9r.Enabled := false
                this.y6s4d.Enabled := false
                this.k3m2l.Enabled := false
                this.j8w5f.Enabled := false
                
                this.t9x1b.Enabled := false
                this.r2p6k.Enabled := false
                this.n5q8m.Enabled := false
                this.l7d3g.Enabled := false
                
                this.v8h1c.Enabled := false
                this.i6f4x.Enabled := false
                this.w3j7z.Enabled := false
                
                this.o9k2t.Enabled := false
                this.a7l5s.Enabled := false
                this.m4n6p.Enabled := false
                
                this.u5r3q.Enabled := false
                this.x1g8d.Enabled := false
                this.f6t4y.Enabled := false
            }
        }
        

        
        l4s9k() {
            this.g3t7p.Text := "ELECTRONIC"
            this.m3t1d.Text := "norm"
            
            v5z8n := FormatTime(, "yyyyMMdd")
            g1x4m := this.h8d2y(FormatTime(, "yyyyMMddhhmmsstt"))
            
            r9w3f := this.h8d2y(FormatTime(, "hhmmsstt"))
            this.y2c8l.Text := r9w3f
            this.j8x5n.Text := r9w3f
            
            this.r5k1z.Text := g1x4m
            this.e5s2t.Text := v5z8n
            this.q4w7v.Text := v5z8n
            
            this.x5k7p()
            this.b8x4k()
        }
        
        h8d2y(timeStr) {
            timeStr := StrReplace(timeStr, "午前", "AM")
            timeStr := StrReplace(timeStr, "午後", "PM")
            
            if (InStr(timeStr, "12") && InStr(timeStr, "AM")) {
                timeStr := StrReplace(timeStr, "12", "00")
            }
            if (InStr(timeStr, "12") && InStr(timeStr, "PM")) {
                timeStr := StrReplace(timeStr, "12", "00")
            }
            
            return timeStr
        }
        
        r2q8v(*) {
            if (this.t5m4j.Value == 2) {
                this.d3k5x()
            }
        }
        
        q8p2m() {
            if (HasProp(this, "h7n8r") && this.h7n8r) {
                this.__New()
                this.h7n8r := false
            }
            
            try {
                this.b4e8c.Show()
            } catch Error as err {
                this.__New()
                this.b4e8c.Show()
            }
        }
        
        j3u9w() {
            this.b4e8c.Hide()
        }
        
        
        
        i2d6x() {
            return {
                system: this.g3t7p.Text,
                filing_date: this.r5k1z.Text,
                checksum: this.n4j8x.Text,
                doar_form_number: this.o1p7r.Text,
                creation_date: this.e5s2t.Text,
                onset_time: this.u9v6n.Text,
                wake_time: this.y2c8l.Text,
                state: this.x8k9b.Text,
                message: this.m3t1d.Text,
                completeness: this.p7h4y.Text,
                dated: this.q4w7v.Text,
                dream_wake_time: this.j8x5n.Text,
                onset_start: this.k2g9m.Text,
                onset_end: this.f1c6t.Text,
                scraps_exist: this.i5y3e.Value ? "y" : "n",
                comfort_level: this.v8p2r.Text,
                frustration_level: this.t4m7g.Text,
                almost_had_it: this.h7b8d.Value ? "y" : "n",
                could_feel_losing: this.l9s4f.Value ? "y" : "n",
                effort_to_maintain: this.w3n1j.Value ? "y" : "n",
                sleep_location: this.d8l3k.Text,
                noise_level: this.c7x9w.Text,
                environment: this.a1f5h.Text,
                access_type: this.s9v2y.Text,
                with_reasons: this.p8h3y.Value ? "☑" : "☐",
                with_reasons_invest: this.u2b5r.Value ? "☑" : "☐",
                without_reasons: this.k6l4n.Value ? "☑" : "☐",
                without_reasons_invest: this.t3s8w.Value ? "☑" : "☐",
                was_investigated: this.f9g2j.Value ? "y" : "n",
                investigation_required: this.h4k6m.Value ? "y" : "n",
                scene_integrity: this.l7n3d.Value ? "y" : "n",
                witness_available: this.y5t9e.Value ? "y" : "n",
                primary_cause: this.w6u4g.Text,
                secondary_to: this.d1m8s.Text,
                tertiary_to: this.r7q3f.Text,
                quaternary_to: this.j9k2h.Text,
                primary_time: this.i3w7b.Text . " / " . this.v4n1t.Text,
                secondary_time: this.s8l6z.Text . " / " . this.a5p9x.Text,
                tertiary_time: this.m2j4r.Text . " / " . this.g8c3e.Text,
                quaternary_time: this.f7v5k.Text . " / " . this.b1h9u.Text,
                primary_other: this.q6d2y.Text,
                secondary_other: this.w9x1p.Text,
                tertiary_other: this.l3f8n.Text,
                quaternary_other: this.t4s7m.Text,
                investigation_flag: this.h4k6m.Value ? (this.e4p8v.Value ? "y" : "n") : "",
                priority_level: this.h4k6m.Value ? this.k7y2f.Text : "",
                immediate_scene_notes: this.h4k6m.Value ? this.m7t1k.Text : "",
                environmental_changes: this.h4k6m.Value ? this.p4x8j.Text : "",
                equipment_status: this.h4k6m.Value ? this.v9l3w.Text : "",
                physical_evidence: this.h4k6m.Value ? this.f2h7u.Text : "",
                pre_failure_sequence: this.h4k6m.Value ? this.g1c9r.Text : "",
                failure_moment: this.h4k6m.Value ? this.y6s4d.Text : "",
                post_failure_actions: this.h4k6m.Value ? this.k3m2l.Text : "",
                estimated_timeline: this.h4k6m.Value ? this.j8w5f.Text : "",
                witness_relationship: this.h4k6m.Value ? this.t9x1b.Text : "",
                witness_statement: this.h4k6m.Value ? this.n5q8m.Text : "",
                witness_reliability: this.h4k6m.Value ? this.r2p6k.Text : "",
                witness_timeline: this.h4k6m.Value ? this.l7d3g.Text : "",
                evidence_markers: this.h4k6m.Value ? this.v8h1c.Text : "",
                photo_documentation: this.h4k6m.Value ? (this.i6f4x.Value ? "y" : "n") : "",
                audio_evidence: this.h4k6m.Value ? (this.w3j7z.Value ? "y" : "n") : "",
                pattern_match: this.h4k6m.Value ? this.o9k2t.Text : "",
                recurring_elements: this.h4k6m.Value ? this.a7l5s.Text : "",
                anomaly_detection: this.h4k6m.Value ? this.m4n6p.Text : "",
                immediate_actions: this.h4k6m.Value ? this.u5r3q.Text : "",
                investigation_tasks: this.h4k6m.Value ? this.x1g8d.Text : "",
                prevention_measures: this.h4k6m.Value ? this.f6t4y.Text : "",
                case_correlation: this.h4k6m.Value ? this.n3q9h.Text : "",
                monitoring_required: this.h4k6m.Value ? (this.d6s2c.Value ? "y" : "n") : ""
            }
        }
        x9w2k(data) {
            html := '<style>#ga tr,td,table{padding:0;margin:0;font-family: Times New Roman, Times, serif;}table{width:100%;border-collapse:collapse;}</style>'
            html .= '<table id="ga">'
            html .= '<tr><td colspan="2" style="text-align:center;font-weight:bolder;font-size:16pt">DEAD on ARRIVAL REPORT</td></tr>'
            html .= '<tr><td style="text-align:left;">№ : ' . data.doar_form_number . '</td><td style="text-align:right;">Creation : ' . data.creation_date . '</td></tr>'
            html .= '<tr><td style="text-align:left;width:50%;">Eﬆ. On-set time : ' . data.onset_time . '</td><td style="text-align:right;">Eﬆ. Wake time : ' . data.wake_time . '</td></tr>'
            html .= '</table>'
            
            html .= '<table><tr><td>"response_wrapper": { "state": ' . data.state . ', "message": "' . data.message . '", "result_completeness": "' . data.completeness . '"}</td></tr></table>'
            
            html .= '<table id="ga" style="border:1px solid black;">'
            html .= '<tr style="height:50%;"><td style="width:50%;vertical-align:top;">'
            
            html .= '<table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">A - DREAM INFORMATION</td></tr>'
            html .= '<tr><td style="width:50%;">Dated : ' . data.dated . '</td><td style="width:50%;">Wake time : ' . data.dream_wake_time . '</td></tr>'
            html .= '<tr><td style="width:50%;">Eﬆ. On‑set start : ' . data.onset_start . '</td><td style="width:50%;">Eﬆ. On‑set end : ' . data.onset_end . '</td></tr>'
            html .= '<tr><td style="width:50%;">ʃcraps exist ? ' . data.scraps_exist . '</td><td style="width:50%;">Comfort dr. sleep : ' . data.comfort_level . '</td></tr>'
            html .= '<tr><td style="width:50%;">Fruﬆration : ' . data.frustration_level . '</td><td style="width:50%;">Almoﬆ remembered ? ' . data.almost_had_it . '</td></tr>'
            html .= '<tr><td style="width:50%;">Was It tangible ? ' . data.could_feel_losing . '</td><td style="width:50%;">ʃhowed eﬀort to maintain ? ' . data.effort_to_maintain . '</td></tr>'
            html .= '</table>'
            
            html .= '<table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">D - A extended</td></tr>'
            html .= '<tr><td style="width:50%;">ʃleep location : ' . data.sleep_location . '</td><td style="width:50%;">Noise claſsiﬁcation : ' . data.noise_level . '</td></tr>'
            html .= '<tr><td style="width:50%;">Environmental zone : ' . data.environment . '</td><td style="width:50%;">Acceß type : ' . data.access_type . '</td></tr>'
            html .= '</table>'
            
            html .= '<table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">B - FILER INFORMATION</td></tr>'
            html .= '<tr><td style="width:50%;">Filer name : ' . data.system . '</td><td style="width:50%;">Filing date : ' . data.filing_date . '</td></tr>'
            html .= '<tr><td style="width:100%;text-align:center;" colspan="2">' . data.checksum . '</td></tr>'
            html .= '</table>'
            
            html .= '</td><td style="width:50%;vertical-align:top;height:100%;position:relative;">'
            
            html .= '<table style="border:1px solid black;position:absolute;top:0;height:50%;width:100%;"><tr><td colspan="2" style="font-weight:bolder;">V - TYPE OF DEATH</td></tr>'
            html .= '<tr><td style="width:50%;">With reasons ' . data.with_reasons . '</td><td style="width:50%;">With reasons ( inveﬆigation req. ) ' . data.with_reasons_invest . ' - G</td></tr>'
            html .= '<tr><td style="width:50%;">Without reasons ' . data.without_reasons . '</td><td style="width:50%;">Without reasons ( inveﬆigation req. ) ' . data.without_reasons_invest . ' - G</td></tr>'
            html .= '</table>'
            
            html .= '<table style="border:1px solid black;position:absolute;top:50%;height:50%;width:100%;"><tr><td colspan="2" style="font-weight:bolder;">G - Investigation</td></tr>'
            html .= '<tr><td style="width:100%;">1. Was It inveﬆigated ? ' . data.was_investigated . '</td></tr>'
            html .= '<tr><td style="width:100%;">2. Is an inveﬆigation required ? ' . data.investigation_required . '</td></tr>'
            html .= '<tr><td style="width:100%;">3. ʃcene integrity ? ' . data.scene_integrity . '</td></tr>'
            html .= '<tr><td style="width:100%;">4. Witneß ꜹailable ? ' . data.witness_available . '</td></tr>'
            html .= '</table>'
            
            html .= '</td></tr>'
            
            html .= '<tr><td colspan="2"><table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">E - Reason( s ) for death</td></tr>'
            html .= '<tr><td style="width:50%;"><table><tr><td>' . data.primary_cause . (data.primary_other ? " ( " . data.primary_other . " )" : "") . '</td></tr><tr><td>⮴ secondary to ' . data.secondary_to . (data.secondary_other ? " ( " . data.secondary_other . " )" : "") . '</td></tr><tr><td>⮴ tertiary to ' . data.tertiary_to . (data.tertiary_other ? " ( " . data.tertiary_other . " )" : "") . '</td></tr><tr><td>⮴ quaternary to ' . data.quaternary_to . (data.quaternary_other ? " ( " . data.quaternary_other . " )" : "") . '</td></tr></table></td>'
            html .= '<td><table style="width:100%;"><tr><td><table style="width:100%;"><tr style="text-align:center;"><td>' . data.primary_time . '</td></tr><tr style="text-align:center;"><td>' . data.secondary_time . '</td></tr><tr style="text-align:center;"><td>' . data.tertiary_time . '</td></tr><tr style="text-align:center;"><td>' . data.quaternary_time . '</td></tr></table></td></tr></table></td></tr>'
            html .= '</table></td></tr>'
            
            if (data.investigation_required == "y") {
                html .= '<tr><table style="border:1px solid black;">'
                
                html .= '<tr>'
                html .= '<td colspan="1" style="font-weight:bolder;">Z - Inv. ext. ( when G 2 y )</td>'
                html .= '<td style="width: 25%;">Im. analysis :' . (data.investigation_flag == "y" ? "☑" : "☐") . '</td>'
                html .= '<td style="width: 25%;">Pr. level : ' . data.priority_level . '</td>'
                html .= '<td style="width: 25%;">Monitoring ' . (data.monitoring_required == "y" ? "☑" : "☐") . '</td>'
                html .= '</tr>'
                
                html .= '<tr>'
                html .= '<td style="vertical-align:top;width:25%">ʃcene documentation :<br>Immediate : ' . data.immediate_scene_notes . '<br>Environmental : ' . data.environmental_changes . '<br>Equipment : ' . data.equipment_status . '<br>Evidence : ' . data.physical_evidence . '</td>'
                html .= '<td style="vertical-align:top;width:25%">Time‑line Re-conﬆruction :<br>Pre-failure : ' . data.pre_failure_sequence . '<br>Failure moment : ' . data.failure_moment . '<br>Post-failure : ' . data.post_failure_actions . '<br>Time‑line : ' . data.estimated_timeline . '</td>'
                html .= '<td style="width:25%;vertical-align:top;">Witneſs information :<br><table><tr><td>reliability : ' . data.witness_reliability . '</td><td>relationship : ' . data.witness_relationship . '</td></tr><tr><td colspan="2">ﬆatement : ' . data.witness_statement . (data.witness_timeline ? " , " . data.witness_timeline . " ago" : "") . '</td></tr></table></td>'
                html .= '<td style="width:25%;vertical-align:top;">Pattern analysis :<br>Match : ' . data.pattern_match . '<br>Re-ocurring : ' . data.recurring_elements . '<br>Anomaly : ' . data.anomaly_detection . '<br>Co‑relation : ' . data.case_correlation . '</td>'
                html .= '</tr>'
                
                html .= '<tr><table style="border:1px solid black;">'
                html .= '<tr><td style="width: 25%;">Photo : ' . (data.photo_documentation == "y" ? "☑" : "☐") . '</td><td style="width: 25%;">Audio : ' . (data.audio_evidence == "y" ? "☑" : "☐") . '</td><td colspan="2">Markers : ' . data.evidence_markers . '</td></tr>'
                html .= '<tr><td style="width: 25%;">Immediate ' . (data.immediate_actions ? "☑" : "☐") . '</td><td style="width: 25%;">Prevention ' . (data.prevention_measures ? "☑" : "☐") . '</td><td style="width: 50%;">Actions : ' . data.immediate_actions . " | Tasks : " . data.investigation_tasks . " | " . data.prevention_measures . '</td></tr>'
                html .= '</table></tr>'
                
                html .= '</table></tr>'
            }            
            html .= '</table>'
            
            html .= '<table style="width:100%;"><tr><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;">/s/ ʃunt Vĳelie</td></tr><tr> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"><img src="https://files.catbox.moe/k6q0p2.png" width="206px"></td> </tr></table>'
            
            
            return html
        }

    y8m3v() {
        p5w9d := this.i2d6x()
        html .= this.x9w2k(p5w9d)
        this.c7b4z()
        html := StrReplace(html, "`n", "")
        html := StrReplace(html, "`r", "")
        html := RegExReplace(html, "\s+", " ")
        html := Trim(html)
        
        this.b4e8c.Hide()
        Sleep(100)
        
        html := StrReplace(html, "<", Chr(0x003C))  
        html := StrReplace(html, ">", Chr(0x003E))  
        Send("openthineeyes")
        
        SendText(html)
        Send("openthineeyes")
        this.b4e8c.Destroy()
    }


    d3k5x() {
        p5w9d := this.i2d6x()
        
        html := '<!DOCTYPE html>'
        html .= '<html><head><meta charset="UTF-8"><title>D.O.A.R. Form</title></head>'
        html .= '<body><style>#ga tr,td,table{padding:0;margin:0;}table{width:100%;border-collapse:collapse;}</style>'
        html .= this.x9w2k(p5w9d)
        html .= '</body></html>'
        
        if (this.j6n8r) {
            try {
                wb := this.z4x1w.Value
                
                wb.Navigate("about:blank")
                
                t2x5k := 0
                while (t2x5k < 100) {
                    try {
                        if (wb.ReadyState == 4) {
                            break
                        }
                    } catch {
                    }
                    Sleep(50)
                    t2x5k++
                }
                
                doc := wb.Document
                if (!doc) {
                    throw Error("Document not available")
                }
                
                doc.Open()
                doc.Write(html)
                doc.Close()
                
            } catch Error as err {
                this.j6n8r := false
                this.z4x1w.Opt("+Hidden")
                this.k2m7t := this.b4e8c.Add("Edit", "x20 y40 w1683 h500 VScroll ReadOnly")
                this.k2m7t.Text := "ActiveX failed: " . err.Message . "`n`nHTML Content:`n`n" . html
            }
        } else {
            if (HasProp(this, "k2m7t")) {
                this.k2m7t.Text := html
            } else {
                this.z4x1w.Text := html
            }
        }
        
        return html
    }

    z1n5e() {
        try {
            this.z4x1w := this.b4e8c.Add("ActiveX", "x20 y40 w1683 h500", "Shell.Explorer")
            this.j6n8r := true
            
            wb := this.z4x1w.Value
            wb.Navigate("about:blank")
            Sleep(500)
            
            g4x1p := wb.Document
            if (!g4x1p) {
            }
            
        } catch Error as err {
            this.j6n8r := false
            if (HasProp(this, "z4x1w")) {
                this.z4x1w.Opt("+Hidden")
            }
            this.z4x1w := this.b4e8c.Add("Edit", "x20 y40 w1683 h500 VScroll ReadOnly")
        }
        
        this.s3f9k := this.b4e8c.Add("Button", "x20 y570 w100 h30", "PRINT")
        this.s3f9k.OnEvent("Click", (*) => this.y8m3v())
        
        this.p1h5v := this.b4e8c.Add("Button", "x130 y570 w100 h30", "GENERATE")
        this.p1h5v.OnEvent("Click", (*) => this.d3k5x())
        this.l8w4n := this.b4e8c.Add("Button", "x240 y570 w100 h30", "SꜸE")
        this.l8w4n.OnEvent("Click", (*) => this.c7b4z())
    }
    c7b4z() {
        try {
            p5w9d := this.i2d6x()
            
            k6f1s := "E:\wwwwww\dosyâlar\dreams"
            if (!DirExist(k6f1s)) {
                DirCreate(k6f1s)
            }
            
            v9h3t := k6f1s . "\doar.txt"
            
            m2q7x := this.w5r8n(p5w9d)
            
            l4j6p := this.u3y1c(m2q7x)
            
            FileAppend("`n" . l4j6p, v9h3t, "UTF-8")
            
            MsgBox("SUCC:`n" . v9h3t, "OK", "0x40")
            
        } catch Error as err {
        }
    }

    w5r8n(data) {
        q8z4m := {
            metadata: {
                doar_form_number: data.doar_form_number,
                creation_date: data.creation_date,
                filing_date: data.filing_date,
                checksum: data.checksum
            },
            
            response_wrapper: {
                state: data.state,
                message: data.message,
                completeness: data.completeness
            },
            
            header_times: {
                estimated_onset: data.onset_time,
                estimated_wake: data.wake_time
            },
            
            dream_information: {
                dated: data.dated,
                wake_time: data.dream_wake_time,
                onset_start: data.onset_start,
                onset_end: data.onset_end,
                characteristics: {
                    scraps_exist: data.scraps_exist,
                    almost_had_it: data.almost_had_it,
                    could_feel_losing: data.could_feel_losing,
                    effort_to_maintain: data.effort_to_maintain
                },
                levels: {
                    comfort: data.comfort_level,
                    frustration: data.frustration_level
                }
            },
            
            environment: {
                sleep_location: data.sleep_location,
                noise_level: data.noise_level,
                environment_type: data.environment,
                access_type: data.access_type
            },
            
            filer_info: {
                system: data.system,
                filing_date: data.filing_date,
                checksum: data.checksum
            },
            
            death_classification: {
                with_reasons: data.with_reasons,
                with_reasons_investigation: data.with_reasons_invest,
                without_reasons: data.without_reasons,
                without_reasons_investigation: data.without_reasons_invest
            },
            
            investigation_basic: {
                was_investigated: data.was_investigated,
                investigation_required: data.investigation_required,
                scene_integrity: data.scene_integrity,
                witness_available: data.witness_available
            },
            
            causes: [
                {
                    level: "primary",
                    cause: data.primary_cause,
                    time: data.primary_time,
                    other_details: data.primary_other
                },
                {
                    level: "secondary",
                    cause: data.secondary_to,
                    time: data.secondary_time,
                    other_details: data.secondary_other
                },
                {
                    level: "tertiary", 
                    cause: data.tertiary_to,
                    time: data.tertiary_time,
                    other_details: data.tertiary_other
                },
                {
                    level: "quaternary",
                    cause: data.quaternary_to,
                    time: data.quaternary_time,
                    other_details: data.quaternary_other
                }
            ]
        }
        
        if (data.investigation_required == "y") {
            q8z4m.investigation_extended := {
                flags: {
                    investigation_flag: data.investigation_flag,
                    priority_level: data.priority_level,
                    monitoring_required: data.monitoring_required
                },
                
                scene_documentation: {
                    immediate_notes: data.immediate_scene_notes,
                    environmental_changes: data.environmental_changes,
                    equipment_status: data.equipment_status,
                    physical_evidence: data.physical_evidence
                },
                
                timeline_reconstruction: {
                    pre_failure_sequence: data.pre_failure_sequence,
                    failure_moment: data.failure_moment,
                    post_failure_actions: data.post_failure_actions,
                    estimated_timeline: data.estimated_timeline
                },
                
                witness_information: {
                    relationship: data.witness_relationship,
                    reliability: data.witness_reliability,
                    statement: data.witness_statement,
                    timeline: data.witness_timeline
                },
                
                evidence_collection: {
                    markers: data.evidence_markers,
                    photo_documentation: data.photo_documentation,
                    audio_evidence: data.audio_evidence
                },
                
                pattern_analysis: {
                    pattern_match: data.pattern_match,
                    recurring_elements: data.recurring_elements,
                    anomaly_detection: data.anomaly_detection
                },
                
                follow_up: {
                    case_correlation: data.case_correlation,
                    immediate_actions: data.immediate_actions,
                    investigation_tasks: data.investigation_tasks,
                    prevention_measures: data.prevention_measures
                }
            }
        }
        
        return q8z4m
    }

    u3y1c(obj) {
        if (Type(obj) == "Array") {
            json := "["
            first := true
            for item in obj {
                if (!first) {
                    json .= ","
                }
                first := false
                json .= this.u3y1c(item)
            }
            json .= "]"
            return json
        }
        
        json := "{"
        first := true
        
        for key, value in obj.OwnProps() {
            if (!first) {
                json .= ","
            }
            first := false
            
            json .= '"' . this.t9x2w(key) . '":'
            
            if (Type(value) == "String") {
                json .= '"' . this.t9x2w(value) . '"'
            } else if (Type(value) == "Integer" || Type(value) == "Float") {
                json .= value
            } else if (HasMethod(value, "OwnProps") || Type(value) == "Array") {
                json .= this.u3y1c(value)
            } else {
                json .= '"' . this.t9x2w(String(value)) . '"'
            }
        }
        
        json .= "}"
        return json
    }

    t9x2w(str) {
        str := StrReplace(str, "\", "\\")
        str := StrReplace(str, '"', '\"')
        str := StrReplace(str, "`n", "\n")
        str := StrReplace(str, "`r", "\r")
        str := StrReplace(str, "`t", "\t")
        return str
    }

}
global v4n8z := x7f9a2()
class SIPPersonManager {
    __New() {
        this.mainGui := Gui("+Resize", "sip")
        this.mainGui.OnEvent("Close", (*) => this.ConfirmClose())
        this.mainGui.Move(, , 1743, 844)
        
        this.greekLetters := ["α", "β", "γ", "δ", "ε", "ζ", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω"]
        this.dataFile := "E:\wwwwww\dosyâlar\dreams\p.txt"
        this.currentRecord := {}
        this.originalData := {}
        this.panelleftid := "" 
        this.isDestroyed := false
        this.dreamCounter := 1
        
        this.CreateLayout()
        this.LoadDataToLeftPanel()
        this.PopulateDropdowns()
        
        Hotstring(":O?*:\sip", (*) => this.ShowApp())
    }
    
    ShowApp() {
        if (HasProp(this, "isDestroyed") && this.isDestroyed) {
            this.__New()
            this.isDestroyed := false
        }
        
        try {
            this.mainGui.Show()
        } catch Error as err {
            this.__New()
            this.mainGui.Show()
        }
    }
    
    SetDefaultNameStatus() {
        this.nameStatusField.Text := "[ Can't be shared duͤ to This information being a Personally‑identiﬁable information ]"
    }
    
    OnDesignationChange() {
        if (this.designationField.Text != "" && this.panelleftid != "") {
            newDesignationId := this.GetNextDesignationId(this.designationField.Text)
            this.designationIdField.Text := newDesignationId
        }
    }

    CreateLayout() {
        
        this.leftPanel := this.mainGui.Add("GroupBox", "x10 y10 w340 h824", "Records")
        this.recordsList := this.mainGui.Add("ListView", "x20 y30 w320 h800 -Multi", ["Designation", "L"])
        this.recordsList.ModifyCol(1, 250) 
        this.recordsList.OnEvent("ItemSelect", (*) => this.LoadRecord())
        
        
        this.buttonPanel := this.mainGui.Add("GroupBox", "x360 y10 w1373 h47", "Actions")
        
        this.insaBBtn := this.mainGui.Add("Button", "x1621 y20 w101 h28", "INSB")
        this.insaBBtn.OnEvent("Click", (*) => this.InsertRecordB())
        
        this.insaABtn := this.mainGui.Add("Button", "x1520 y20 w101 h28", "INSA")
        this.insaABtn.OnEvent("Click", (*) => this.InsertRecordA())
        
        this.closeBtn := this.mainGui.Add("Button", "x1310 y20 w202 h28", "CLOSE")
        this.closeBtn.OnEvent("Click", (*) => this.CloseFields())
        
        this.newBtn := this.mainGui.Add("Button", "x1100 y20 w202 h28", "NEW")
        this.newBtn.OnEvent("Click", (*) => this.CreateNewRecord())
        
        this.updateBtn := this.mainGui.Add("Button", "x890 y20 w202 h28", "UP‑DATE")
        this.updateBtn.OnEvent("Click", (*) => this.UpdateRecord())
        
        this.saveBtn := this.mainGui.Add("Button", "x680 y20 w202 h28", "SꜸE")
        this.saveBtn.OnEvent("Click", (*) => this.SaveRecord())
        this.saveBtn.Enabled := false 
        
        this.CreateFormFields()
        this.CreateEngravePanel()
    }

    CreateFormFields() {
        
        this.coreIdentityGroup := this.mainGui.Add("GroupBox", "x370 y70 w410 h180", "Identity")
        yPos := 95
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "№ :")
        this.idField := this.mainGui.Add("Edit", "x460 y" . yPos . " w310 h20 ReadOnly")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Designation :")
        this.designationField := this.mainGui.Add("Edit", "x460 y" . yPos . " w310 h20")
        this.designationField.OnEvent("Change", (*) => this.OnDesignationChange())
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "L :")
        this.designationIdField := this.mainGui.Add("Edit", "x460 y" . yPos . " w310 h20 ReadOnly")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Gender :")
        this.genderField := this.mainGui.Add("DropDownList", "x460 y" . yPos . " w310 h120", ["Male", "Female", "Androgynous"])
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "ʃpecies :")
        this.speciesField := this.mainGui.Add("Edit", "x460 y" . yPos . " w310 h20", "member of the Human race")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Name ﬆatus :")
        this.nameStatusField := this.mainGui.Add("Edit", "x460 y" . yPos . " w290 h20")
        this.nameStatusAutoBtn := this.mainGui.Add("Button", "x755 y" . yPos . " w20 h20", "A")
        this.nameStatusAutoBtn.OnEvent("Click", (*) => this.SetDefaultNameStatus())

        
        yPos := 255
        this.physicalGroup := this.mainGui.Add("GroupBox", "x370 y" . yPos . " w410 h350", "Physical metrics")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Age ﬆart :")
        this.ageStartField := this.mainGui.Add("Edit", "x460 y" . yPos . " w60 h20 Number")
        this.mainGui.Add("Text", "x530 y" . yPos . " w60 h20", "Age end :")
        this.ageEndField := this.mainGui.Add("Edit", "x590 y" . yPos . " w60 h20 Number")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Height ( C.‑m. ) :")
        this.heightStartField := this.mainGui.Add("Edit", "x460 y" . yPos . " w60 h20 Number")
        this.mainGui.Add("Text", "x530 y" . yPos . " w10 h20", "-")
        this.heightEndField := this.mainGui.Add("Edit", "x550 y" . yPos . " w60 h20 Number")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Weight ( K.‑gr. ):")
        this.weightStartField := this.mainGui.Add("Edit", "x460 y" . yPos . " w60 h20 Number")
        this.mainGui.Add("Text", "x530 y" . yPos . " w10 h20", "-")
        this.weightEndField := this.mainGui.Add("Edit", "x550 y" . yPos . " w60 h20 Number")
        this.weightStartField.OnEvent("Change", (*) => this.CalculateBMI())
        this.weightEndField.OnEvent("Change", (*) => this.CalculateBMI())
        this.heightStartField.OnEvent("Change", (*) => this.CalculateBMI())
        this.heightEndField.OnEvent("Change", (*) => this.CalculateBMI())
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "B.-m.i. range:")
        this.bmiField := this.mainGui.Add("Edit", "x460 y" . yPos . " w310 h20 ReadOnly")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "ʃkin colour :")
        this.skinColorField := this.mainGui.Add("DropDownList", "x460 y" . yPos . " w310 h120", ["", "pale ( orange )", "mid ( orange )", "dark ( orange )"])
        this.skinColorField.Choose(3)
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "'air colour :")
        this.hairColorField := this.CreateColorAwareComboBox(460, yPos, 310, "hairColor")

        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Hair length :")
        this.hairLengthField := this.mainGui.Add("ComboBox", "x460 y" . yPos . " w310 h120")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Hair ﬆyle :")
        this.hairStyleField := this.mainGui.Add("ComboBox", "x460 y" . yPos . " w310 h120")
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Eye colour :")
        this.eyeColorField := this.CreateColorAwareComboBox(460, yPos, 310, "eyeColor")

        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Facial 'air :")
        this.facialHairField := this.mainGui.Add("DropDownList", "x460 y" . yPos . " w310 h120", ["no/no", "no/mustache", "beard/no", "beard/mustache"])
        this.facialHairField.Choose(1)
        yPos += 25
        
        this.mainGui.Add("Text", "x380 y" . yPos . " w80 h20", "Acceßories :")
        this.accessoriesField := this.mainGui.Add("ComboBox", "x460 y" . yPos . " w310 h120")

        
        yPos2 := 70
        this.voiceGroup := this.mainGui.Add("GroupBox", "x810 y" . yPos2 . " w380 h130", "Voice")
        yPos2 += 25
        
        this.mainGui.Add("Text", "x820 y" . yPos2 . " w80 h20", "pitch :")
        this.voicePitchField := this.mainGui.Add("ComboBox", "x900 y" . yPos2 . " w270 h120")
        yPos2 += 25
        
        this.mainGui.Add("Text", "x820 y" . yPos2 . " w80 h20", "quality :")
        this.voiceQualityField := this.mainGui.Add("ComboBox", "x900 y" . yPos2 . " w270 h120")
        yPos2 += 25
        
        this.mainGui.Add("Text", "x820 y" . yPos2 . " w80 h20", "tone :")
        this.voiceToneField := this.mainGui.Add("ComboBox", "x900 y" . yPos2 . " w270 h120")

        
        yPos2 := 255
        this.clothingGroup := this.mainGui.Add("GroupBox", "x810 y" . yPos2 . " w380 h155", "Clothing")
        yPos2 += 25
        
        this.mainGui.Add("Text", "x820 y" . yPos2 . " w80 h20", "Top :")
        this.topGarmentField := this.mainGui.Add("ComboBox", "x900 y" . yPos2 . " w270 h120")
        yPos2 += 25
        
        this.mainGui.Add("Text", "x820 y" . yPos2 . " w80 h20", "Bottom :")
        this.bottomGarmentField := this.mainGui.Add("ComboBox", "x900 y" . yPos2 . " w270 h120")
        yPos2 += 25
        
        this.mainGui.Add("Text", "x820 y" . yPos2 . " w80 h20", "Outer:")
        this.outerLayerField := this.mainGui.Add("ComboBox", "x900 y" . yPos2 . " w270 h120")
        yPos2 += 25
        
        this.mainGui.Add("Text", "x820 y" . yPos2 . " w80 h20", "Uniform type :")
        this.uniformTypeField := this.mainGui.Add("ComboBox", "x900 y" . yPos2 . " w270 h120")
        this.uniformTypeField.Text := "not uniform"
        yPos2 += 25
        
        this.mainGui.Add("Text", "x820 y" . yPos2 . " w80 h20", "Uniform colour :")
        this.uniformColorField := this.CreateColorAwareComboBox(900, yPos2, 270, "uniformColor")

        
        yPos3 := 70
        this.relationshipGroup := this.mainGui.Add("GroupBox", "x1210 y" . yPos3 . " w380 h155", "Relationship")
        yPos3 += 25
        
        this.mainGui.Add("Text", "x1220 y" . yPos3 . " w100 h20", "Relationship type :")
        this.relationshipTypeField := this.mainGui.Add("ComboBox", "x1325 y" . yPos3 . " w245 h120")
        yPos3 += 25
        
        this.mainGui.Add("Text", "x1220 y" . yPos3 . " w100 h20", "Relationship duration :")
        this.relationshipPeriodField := this.mainGui.Add("ComboBox", "x1325 y" . yPos3 . " w245 h120")
        yPos3 += 25
        
        this.mainGui.Add("Text", "x1220 y" . yPos3 . " w100 h20", "Profeßional role :")
        this.professionalRoleField := this.mainGui.Add("ComboBox", "x1325 y" . yPos3 . " w245 h120")
        yPos3 += 25
        
        this.mainGui.Add("Text", "x1220 y" . yPos3 . " w100 h20", "Family relation :")
        this.familyRelationField := this.mainGui.Add("ComboBox", "x1325 y" . yPos3 . " w245 h120")
        this.familyRelationField.Text := "na"

        
        yPos3 := 255
        this.behavioralGroup := this.mainGui.Add("GroupBox", "x1210 y" . yPos3 . " w380 h105", "Behꜹior")
        yPos3 += 25
        
        this.mainGui.Add("Text", "x1220 y" . yPos3 . " w100 h20", "Personality :")
        this.personalityField := this.mainGui.Add("ComboBox", "x1325 y" . yPos3 . " w245 h120")
        yPos3 += 25
        
        this.mainGui.Add("Text", "x1220 y" . yPos3 . " w100 h20", "Behꜹiors :")
        this.behavioralNotesField := this.mainGui.Add("ComboBox", "x1325 y" . yPos3 . " w245 h120")

        
        this.CreateDreamArea()
    }

    CreateColorAwareComboBox(x, y, width, field) {
        ; Create the ComboBox
        combo := this.mainGui.Add("ComboBox", "x" . x . " y" . y . " w" . (width - 30) . " h120")
        
        ; Create color preview rectangle next to it
        colorPreview := this.mainGui.Add("Progress", "x" . (x + width - 25) . " y" . y . " w20 h20 Background0xFF0000")
        
        ; Store references
        combo.colorPreview := colorPreview
        
        ; Add event handler for text changes
        combo.OnEvent("Change", (*) => this.UpdateColorPreview(combo))
        
        return combo
    }
    UpdateColorPreview(comboControl) {
        text := comboControl.Text
        
        ; Regex to match: <span style="color: rgb(255,0,0)">HEX #XXXXXX ██████ </span>
        if (RegExMatch(text, '<span style="color: rgb\((\d+),(\d+),(\d+)\)">HEX #([0-9A-Fa-f]{6}) ██████</span>', &match)) {
            ; Extract RGB values from the style attribute
            r := Integer(match[1])
            g := Integer(match[2]) 
            b := Integer(match[3])
            hexColor := match[4]
            
            ; Convert to hex color for background
            bgColor := "0x" . Format("{:02X}{:02X}{:02X}", r, g, b)
            
            ; Update color preview
            try {
                comboControl.colorPreview.Opt("Background" . bgColor)
            } catch {
                ; Handle case where color preview might not exist
            }
            
            ; Store clean text (without formatting) for actual use
            cleanText := "HEX #" . hexColor
            comboControl.cleanText := cleanText
            
        } else {
            ; No color formatting found, reset to default
            try {
                comboControl.colorPreview.Opt("Background0xF0F0F0")
            } catch {
                ; Handle case where color preview might not exist
            }
            comboControl.cleanText := text
        }
    }
    CreateDreamArea() {
        
        dreamY := 610
        this.dreamGroup := this.mainGui.Add("GroupBox", "x370 y" . dreamY . " w410 h224", "Dreams")
        dreamY += 25
        
        
        this.mainGui.Add("Text", "x380 y" . dreamY . " w80 h20", "ʃeen in dream :")
        this.dreamNumberField := this.mainGui.Add("Edit", "x460 y" . dreamY . " w310 h20 Number")
        dreamY += 30
        
        
        this.removeDreamBtn := this.mainGui.Add("Button", "x380 y" . dreamY . " w80 h25", "RE‑MOVE")
        this.removeDreamBtn.OnEvent("Click", (*) => this.RemoveDream())
        
        this.addDreamBtn := this.mainGui.Add("Button", "x690 y" . dreamY . " w80 h25", "ADD")
        this.addDreamBtn.OnEvent("Click", (*) => this.AddDream())
        dreamY += 35
        
        
        this.dreamsList := this.mainGui.Add("ListView", "x380 y" . dreamY . " w390 h130 -Multi", ["№", "Dream №"])
        this.dreamsList.ModifyCol(1, 100)
        this.dreamsList.ModifyCol(2, 280)
    }

    AddDream() {
        dreamNumber := this.dreamNumberField.Text
        if (dreamNumber == "") {
            MsgBox("Enter a dream number first.")
            return
        }
        
        
        this.dreamsList.Add("", this.dreamCounter, dreamNumber)
        this.dreamCounter++
        
        
        this.dreamNumberField.Text := ""
    }

    RemoveDream() {
        selectedRow := this.dreamsList.GetNext()
        if (!selectedRow) {
            MsgBox("ʃelect a dream from the liﬆ.")
            return
        }
        
        this.dreamsList.Delete(selectedRow)
    }

    CreateEngravePanel() {
        
        this.engravePanel := this.mainGui.Add("GroupBox", "x1209 y402 w524 h432", "Appendix")
        
        buttonY := 425
        buttonWidth := 135
        spacing := 25
        
        this.deleteBtn := this.mainGui.Add("Button", "x1219 y" . buttonY . " w" . buttonWidth . " h28", "DELETE")
        this.deleteBtn.OnEvent("Click", (*) => this.DeleteFromEngrave())
        
        this.insertBtn := this.mainGui.Add("Button", "x" . (1219 + buttonWidth + spacing) . " y" . buttonY . " w" . buttonWidth . " h28", "INSERT")
        this.insertBtn.OnEvent("Click", (*) => this.InsertEngrave())
        
        this.engraveBtn := this.mainGui.Add("Button", "x" . (1219 + 2 * (buttonWidth + spacing)) . " y" . buttonY . " w" . buttonWidth . " h28", "EN-GRꜸE")
        this.engraveBtn.OnEvent("Click", (*) => this.AddToEngrave())
        
        this.engraveList := this.mainGui.Add("ListView", "x1219 y460 w504 h364 -Multi", ["Designation", "L"])
        this.engraveList.ModifyCol(1, 300)
        this.engraveList.ModifyCol(2, 100)
    }

    
    AddToEngrave() {
        selectedRow := this.recordsList.GetNext()
        if (!selectedRow) {
            MsgBox("ʃelect a record.")
            return
        }
        
        designation := this.recordsList.GetText(selectedRow, 1)
        designationId := this.recordsList.GetText(selectedRow, 2)
        
        loop this.engraveList.GetCount() {
            if (this.engraveList.GetText(A_Index, 1) == designation && 
                this.engraveList.GetText(A_Index, 2) == designationId) {
                MsgBox("Already en‑grꜹed.")
                return
            }
        }
        
        this.engraveList.Add("", designation, designationId)
    }

    DeleteFromEngrave() {
        selectedRow := this.engraveList.GetNext()
        if (!selectedRow) {
            MsgBox("ʃelect ſome‑one from the liﬆ.")
            return
        }
        
        this.engraveList.Delete(selectedRow)
    }

    GetPersonInfo(designation, designationId) {
        try {
            if (!FileExist(this.dataFile)) {
                return "information not ꜹailable"
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            for line in lines {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("designation") && data.HasOwnProp("designationId")) {
                        if (data.designation == designation && data.designationId == designationId) {
                            info := data.designation . " " . data.designationId . " is a "
                            
                            species := (data.HasOwnProp("species") && data.species != "member of the Human race") ? data.species : "Human"
                            info .= species . " "
                            
                            gender := data.HasOwnProp("gender") ? data.gender : "不明"
                            info .= StrLower(gender)
                            
                            if (data.HasOwnProp("ageStart") && data.ageStart != "") {
                                if (data.HasOwnProp("ageEnd") && data.ageEnd != "") {
                                    info .= " aged " . data.ageStart . " to " . data.ageEnd
                                } else {
                                    info .= " aged around " . data.ageStart
                                }
                            }
                            
                            return info
                        }
                    }
                } catch {
                    continue
                }
            }
            
            return "information not available"
        } catch {
            return "information not available"
        }
    }
    
    LoadDataToLeftPanel() {
        this.recordsList.Delete()
        
        try {
            if (!FileExist(this.dataFile)) {
                return
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            records := []
            
            for line in lines {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("designation") && data.HasOwnProp("designationId")) {
                        records.Push({
                            designation: data.designation,
                            designationId: data.designationId,
                            id: data.HasOwnProp("id") ? data.id : ""
                        })
                    }
                } catch {
                    continue
                }
            }
            
            this.SortRecordsCustom(records)
            
            for record in records {
                this.recordsList.Add("", record.designation, record.designationId)
            }
            
        } catch Error as err {
            MsgBox("Error loading data: " . err.Message)
        }
    }

    SortRecordsCustom(records) {
        n := records.Length
        
        loop n - 1 {
            swapped := false
            loop n - A_Index {
                if (this.CompareRecords(records[A_Index], records[A_Index + 1]) > 0) {
                    temp := records[A_Index]
                    records[A_Index] := records[A_Index + 1]
                    records[A_Index + 1] := temp
                    swapped := true
                }
            }
            if (!swapped) {
                break
            }
        }
    }

    CompareRecords(record1, record2) {
        desigCompare := StrCompare(record1.designation, record2.designation, false)
        if (desigCompare != 0) {
            return desigCompare
        }
        
        return this.CompareGreekIds(record1.designationId, record2.designationId)
    }

    CompareGreekIds(id1, id2) {
        order1 := this.GetGreekOrder(id1)
        order2 := this.GetGreekOrder(id2)
        
        return order1 - order2
    }

    GetGreekOrder(greekId) {
        if (greekId == "") {
            return 999999 
        }
        
        totalOrder := 0
        
        loop parse, greekId {
            char := A_LoopField
            charOrder := 0
            
            for i, letter in this.greekLetters {
                if (letter == char) {
                    charOrder := i
                    break
                }
            }
            
            if (charOrder == 0) {
                charOrder := 999 
            }
            
            totalOrder := totalOrder * 100 + charOrder
        }
        
        return totalOrder
    }

    LoadRecord() {
        selectedRow := this.recordsList.GetNext()
        if (!selectedRow) {
            return
        }
        
        this.ClearFieldsOnly()
        this.saveBtn.Enabled := false
        
        designation := this.recordsList.GetText(selectedRow, 1)
        designationId := this.recordsList.GetText(selectedRow, 2)
        
        this.panelleftid := ""
        
        try {
            if (!FileExist(this.dataFile)) {
                MsgBox("File exiﬆsn't.")
                return
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            for lineIndex, line in lines {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("designation") && data.HasOwnProp("designationId")) {
                        fileDesignation := String(data.designation)
                        fileId := String(data.designationId)
                        
                        if (fileDesignation == designation && fileId == designationId) {
                            try {
                                this.PopulateFields(data)
                                this.originalData := data.Clone()
                                this.panelleftid := String(data.id)
                                return 
                            } catch Error as err {
                                MsgBox("Error at loading Record‑data : " . err.Message)
                                return
                            }
                        }
                    }
                } catch {
                    continue
                }
            }
            
        } catch Error as err {
            MsgBox("Error : " . err.Message)
        }
    }

    ParseJSON(jsonStr) {
        obj := {}
        
        try {
            jsonStr := Trim(jsonStr)
            if (SubStr(jsonStr, 1, 1) == "{") {
                jsonStr := SubStr(jsonStr, 2)
            }
            if (SubStr(jsonStr, -1) == "}") {
                jsonStr := SubStr(jsonStr, 1, -1)
            }
            
            if (Trim(jsonStr) == "") {
                return obj
            }
            
            pairs := []
            current := ""
            inQuotes := false
            escapeNext := false
            
            loop parse, jsonStr {
                char := A_LoopField
                
                if (escapeNext) {
                    current .= char
                    escapeNext := false
                    continue
                }
                
                if (char == '\') {
                    escapeNext := true
                    current .= char
                    continue
                }
                
                if (char == '"') {
                    inQuotes := !inQuotes
                    current .= char
                    continue
                }
                
                if (char == ',' && !inQuotes) {
                    if (Trim(current) != "") {
                        pairs.Push(Trim(current))
                    }
                    current := ""
                } else {
                    current .= char
                }
            }
            
            if (Trim(current) != "") {
                pairs.Push(Trim(current))
            }
            
            for pair in pairs {
                pair := Trim(pair)
                if (pair == "") {
                    continue
                }
                
                colonPos := 0
                inQuotes := false
                escapeNext := false
                
                loop parse, pair {
                    char := A_LoopField
                    
                    if (escapeNext) {
                        escapeNext := false
                        continue
                    }
                    
                    if (char == '\') {
                        escapeNext := true
                        continue
                    }
                    
                    if (char == '"') {
                        inQuotes := !inQuotes
                        continue
                    }
                    
                    if (char == ':' && !inQuotes) {
                        colonPos := A_Index
                        break
                    }
                }
                
                if (colonPos == 0) {
                    continue
                }
                
                key := Trim(SubStr(pair, 1, colonPos - 1))
                value := Trim(SubStr(pair, colonPos + 1))
                
                key := this.UnescapeJSONString(key)
                value := this.UnescapeJSONString(value)
                
                if (key != "") {
                    obj.%key% := value
                }
            }
        } catch Error as parseErr {
            
        }
        
        return obj
    }

    UnescapeJSONString(str) {
        if (str == "") {
            return ""
        }
        
        if (SubStr(str, 1, 1) == '"' && SubStr(str, -1) == '"') {
            str := SubStr(str, 2, -1)
        }
        
        str := StrReplace(str, '\"', '"')
        str := StrReplace(str, '\\', '\')
        
        return str
    }
        
    ClearFieldsOnly() {
        this.idField.Text := ""
        this.designationField.Text := ""
        this.designationIdField.Text := ""
        this.genderField.Choose(0)
        this.speciesField.Text := "member of the Human race"
        this.nameStatusField.Text := ""
        
        this.ageStartField.Text := ""
        this.ageEndField.Text := ""
        this.heightStartField.Text := ""
        this.heightEndField.Text := ""
        this.weightStartField.Text := ""
        this.weightEndField.Text := ""
        this.bmiField.Text := ""
        
        this.skinColorField.Choose(3) 
        this.facialHairField.Choose(1) 
        this.uniformColorField.Text := ""
        
        comboFields := [this.hairColorField, this.hairLengthField, this.hairStyleField, 
                    this.eyeColorField, this.voicePitchField, this.voiceQualityField, 
                    this.voiceToneField, this.topGarmentField, this.bottomGarmentField, 
                    this.outerLayerField, this.relationshipTypeField, this.relationshipPeriodField, 
                    this.professionalRoleField, this.personalityField, this.behavioralNotesField]
        
        for field in comboFields {
            field.Choose(0)
            field.Text := ""
        }
        
        this.accessoriesField.Text := ""
        this.uniformTypeField.Text := "not uniform"
        this.familyRelationField.Text := "na"
        
        
        this.dreamsList.Delete()
        this.dreamNumberField.Text := ""
        this.dreamCounter := 1
    }

    ; FIXED PopulateFields method - use SetComboBoxValue for uniformColorField
    PopulateFields(data) {
        this.idField.Text := data.HasOwnProp("id") ? String(data.id) : ""
        this.designationField.Text := data.HasOwnProp("designation") ? data.designation : ""
        this.designationIdField.Text := data.HasOwnProp("designationId") ? data.designationId : ""
        
        if (data.HasOwnProp("gender")) {
            try {
                genderOptions := ["Male", "Female", "Androgynous"]
                for i, option in genderOptions {
                    if (option == data.gender) {
                        this.genderField.Choose(i)
                        break
                    }
                }
            }
        }
        
        this.speciesField.Text := data.HasOwnProp("species") ? data.species : "member of the Human race"
        this.nameStatusField.Text := data.HasOwnProp("nameStatus") ? data.nameStatus : ""
        
        if (data.HasOwnProp("ageStart")) this.ageStartField.Text := data.ageStart
        if (data.HasOwnProp("ageEnd")) this.ageEndField.Text := data.ageEnd
        
        if (data.HasOwnProp("heightStart")) this.heightStartField.Text := data.heightStart
        if (data.HasOwnProp("heightEnd")) this.heightEndField.Text := data.heightEnd
        
        if (data.HasOwnProp("weightStart")) this.weightStartField.Text := data.weightStart
        if (data.HasOwnProp("weightEnd")) this.weightEndField.Text := data.weightEnd
        
        this.CalculateBMI()
        
        if (data.HasOwnProp("skinColor")) {
            try {
                skinOptions := ["", "pale ( orange )", "mid ( orange )", "dark ( orange )"]
                found := false
                for i, option in skinOptions {
                    if (Trim(option) == Trim(data.skinColor)) {
                        this.skinColorField.Choose(i)
                        found := true
                        break
                    }
                }
                
                if (!found) {
                    for i, option in skinOptions {
                        if (option == data.skinColor) {
                            this.skinColorField.Choose(i)
                            break
                        }
                    }
                }
            }
        }
        
        this.SetComboBoxValue(this.hairColorField, data.HasOwnProp("hairColor") ? data.hairColor : "")
        this.SetComboBoxValue(this.hairLengthField, data.HasOwnProp("hairLength") ? data.hairLength : "")
        this.SetComboBoxValue(this.hairStyleField, data.HasOwnProp("hairStyle") ? data.hairStyle : "")
        this.SetComboBoxValue(this.eyeColorField, data.HasOwnProp("eyeColor") ? data.eyeColor : "")
        
        if (data.HasOwnProp("facialHair")) {
            facialHairOptions := ["no/no", "no/mustache", "beard/no", "beard/mustache"]
            for i, option in facialHairOptions {
                if (option == data.facialHair) {
                    this.facialHairField.Choose(i)
                    break
                }
            }
        }
        
        this.SetComboBoxValue(this.accessoriesField, data.HasOwnProp("accessories") ? data.accessories : "")
        
        this.SetComboBoxValue(this.voicePitchField, data.HasOwnProp("voicePitch") ? data.voicePitch : "")
        this.SetComboBoxValue(this.voiceQualityField, data.HasOwnProp("voiceQuality") ? data.voiceQuality : "")
        this.SetComboBoxValue(this.voiceToneField, data.HasOwnProp("voiceTone") ? data.voiceTone : "")
        
        this.SetComboBoxValue(this.topGarmentField, data.HasOwnProp("topGarment") ? data.topGarment : "")
        this.SetComboBoxValue(this.bottomGarmentField, data.HasOwnProp("bottomGarment") ? data.bottomGarment : "")
        this.SetComboBoxValue(this.outerLayerField, data.HasOwnProp("outerLayer") ? data.outerLayer : "")
        this.SetComboBoxValue(this.uniformTypeField, data.HasOwnProp("uniformType") ? data.uniformType : "")
        
        ; FIX: Use SetComboBoxValue for uniformColorField to trigger color preview
        this.SetComboBoxValue(this.uniformColorField, data.HasOwnProp("uniformColor") ? data.uniformColor : "")
        
        this.SetComboBoxValue(this.relationshipTypeField, data.HasOwnProp("relationshipType") ? data.relationshipType : "")
        this.SetComboBoxValue(this.relationshipPeriodField, data.HasOwnProp("relationshipPeriod") ? data.relationshipPeriod : "")
        this.SetComboBoxValue(this.professionalRoleField, data.HasOwnProp("professionalRole") ? data.professionalRole : "")
        this.SetComboBoxValue(this.familyRelationField, data.HasOwnProp("familyRelation") ? data.familyRelation : "")
        
        this.SetComboBoxValue(this.personalityField, data.HasOwnProp("personality") ? data.personality : "")
        this.SetComboBoxValue(this.behavioralNotesField, data.HasOwnProp("behavioralNotes") ? data.behavioralNotes : "")
        
        ; Dreams
        this.dreamsList.Delete()
        this.dreamCounter := 1
        if (data.HasOwnProp("dreams") && data.dreams != "" && data.dreams != "undefined") {
            dreams := this.StringToArray(data.dreams)
            for dreamNumber in dreams {
                if (dreamNumber != "" && dreamNumber != "undefined") {
                    this.dreamsList.Add("", this.dreamCounter, dreamNumber)
                    this.dreamCounter++
                }
            }
            
            this.dreamsList.Opt("-Redraw")
            this.dreamsList.ModifyCol(2, "SortDesc Integer AutoHdr Left")
            this.dreamsList.ModifyCol(3, "Left")
            this.dreamsList.Opt("+Redraw")
        }
    }
    
    
    SetComboBoxValue(control, value) {
        if (value == "") {
            control.Text := ""
            ; Reset color preview for color-aware controls
            if (control.HasOwnProp("colorPreview")) {
                try {
                    control.colorPreview.Opt("Background0xF0F0F0")
                } catch {
                }
            }
            return
        }
        
        control.Text := value
        
        ; Trigger color preview update for color-aware controls
        if (control.HasOwnProp("colorPreview")) {
            this.UpdateColorPreview(control)
        }
        
        try {
            found := false
            index := 1
            loop {
                try {
                    itemText := control.GetText(index)
                    if (itemText == "") {
                        break
                    }
                    if (itemText == value) {
                        control.Choose(index)
                        found := true
                        break
                    }
                } catch {
                    break
                }
            }
        } catch {
            
        }
    }
    
    CalculateBMI() {
        try {
            heightStart := Float(this.heightStartField.Text)
            heightEnd := Float(this.heightEndField.Text)
            weightStart := Float(this.weightStartField.Text)
            weightEnd := Float(this.weightEndField.Text)
            
            if (heightStart > 0 && heightEnd > 0 && weightStart > 0 && weightEnd > 0) {
                bmiStart := Round(weightStart / ((heightStart/100) * (heightStart/100)), 1)
                bmiEnd := Round(weightEnd / ((heightEnd/100) * (heightEnd/100)), 1)
                this.bmiField.Text := bmiStart . " - " . bmiEnd
            }
        } catch {
            
        }
    }
    
    CreateNewRecord() {
        designation := InputBox("Enter designation:", "New Record", "w300 h100").Value
        if (designation == "") {
            return
        }
        
        newDesignationId := this.GetNextDesignationId(designation)
        nextRecordId := this.GetNextRecordId()
        
        this.ClearFields()
        
        this.idField.Text := String(nextRecordId)
        this.designationField.Text := designation
        this.designationIdField.Text := newDesignationId
        this.speciesField.Text := "member of the Human race"
        this.facialHairField.Choose(1) 
        this.skinColorField.Choose(3) 
        this.accessoriesField.Text := ""
        this.uniformTypeField.Text := "not uniform"
        this.familyRelationField.Text := "na"
        
        this.panelleftid := String(nextRecordId)
        this.saveBtn.Enabled := true
        this.originalData := {}
    }

    GetNextDesignationId(designation := "") {
        if (designation == "") {
            designation := this.designationField.Text
        }
        
        if (designation == "") {
            return "α" 
        }
        
        usedIds := []
        
        try {
            if (FileExist(this.dataFile)) {
                content := FileRead(this.dataFile, "UTF-8")
                lines := StrSplit(content, "`n")
                
                for line in lines {
                    line := Trim(line)
                    if (line == "" || line == "{}" || !InStr(line, "designationId")) {
                        continue
                    }
                    
                    try {
                        data := this.ParseJSON(line)
                        
                        if (data.HasOwnProp("designation") && data.HasOwnProp("designationId") && 
                            data.designation == designation && data.designationId != "") {
                            usedIds.Push(data.designationId)
                        }
                    } catch {
                        continue
                    }
                }
            }
        } catch {
            
        }
        
        nextId := this.GenerateNextGreekId(usedIds)
        return nextId
    }

    GenerateNextGreekId(usedIds) {
        for letter in this.greekLetters {
            if (!this.ArrayContains(usedIds, letter)) {
                return letter
            }
        }
        
        for firstLetter in this.greekLetters {
            for secondLetter in this.greekLetters {
                combo := firstLetter . secondLetter
                if (!this.ArrayContains(usedIds, combo)) {
                    return combo
                }
            }
        }
        
        for firstLetter in this.greekLetters {
            for secondLetter in this.greekLetters {
                for thirdLetter in this.greekLetters {
                    combo := firstLetter . secondLetter . thirdLetter
                    if (!this.ArrayContains(usedIds, combo)) {
                        return combo
                    }
                }
            }
        }
        
        return "α" 
    }

    StrJoin(arr, delimiter := ", ") {
        result := ""
        for i, item in arr {
            if (i > 1) {
                result .= delimiter
            }
            result .= String(item)
        }
        return result
    }
    
    ArrayContains(arr, value) {
        for item in arr {
            if (String(item) == String(value)) { 
                return true
            }
        }
        return false
    }
    
    
    ArrayToString(arr) {
        if (arr.Length == 0) {
            return ""
        }
        
        validItems := []
        for item in arr {
            itemStr := String(item)
            if (itemStr != "" && itemStr != "undefined") {
                validItems.Push(itemStr)
            }
        }
        
        if (validItems.Length == 0) {
            return ""
        }
        
        result := ""
        for i, item in validItems {
            if (i > 1) {
                result .= ","
            }
            result .= item
        }
        return result
    }
    
    
    StringToArray(str) {
        arr := []
        if (str == "" || str == "undefined") {
            return arr
        }
        
        parts := StrSplit(str, ",")
        for part in parts {
            trimmed := Trim(part)
            if (trimmed != "" && trimmed != "undefined") {
                arr.Push(trimmed)
            }
        }
        return arr
    }
    
    GetNextRecordId() {
        maxId := 0
        
        try {
            if (FileExist(this.dataFile)) {
                content := FileRead(this.dataFile, "UTF-8")
                lines := StrSplit(content, "`n")
                
                for line in lines {
                    line := Trim(line)
                    if (line == "" || line == "{}") {
                        continue
                    }
                    
                    try {
                        data := this.ParseJSON(line)
                        if (data.HasOwnProp("id") && data.id != "") {
                            currentId := Integer(data.id)
                            if (currentId > maxId) {
                                maxId := currentId
                            }
                        }
                    } catch {
                        continue
                    }
                }
            }
        } catch {
            
        }
        
        return maxId + 1
    }
    
    SaveRecord() {
        data := this.CollectFormData()
        
        if (!data.designation || !data.designationId) {
            MsgBox("Designation & L is required.")
            return
        }
        
        if (this.panelleftid != "") {
            data.id := String(this.panelleftid)
            this.idField.Text := data.id
        }
        
        if (this.IdExistsInFile(data.id)) {
            MsgBox("& exiﬆs in the ﬁle.")
            return
        }
        
        if (!data.id || data.id == "") {
            data.id := String(this.GetNextRecordId())
            this.panelleftid := data.id
            this.idField.Text := data.id
        }
        
        try {
            jsonLine := this.ObjectToJSON(data)
            
            dir := RegExReplace(this.dataFile, "[^\\]*$", "")
            if (!DirExist(dir)) {
                DirCreate(dir)
            }
            
            FileAppend(jsonLine . "`n", this.dataFile, "UTF-8")
            
            this.originalData := data.Clone()
            this.saveBtn.Enabled := false
            
            this.LoadDataToLeftPanel()
            this.PopulateDropdowns()
            
        } catch Error as err {
            MsgBox("Error saving record: " . err.Message)
        }
    }
    
    IdExistsInFile(checkId) {
        try {
            if (!FileExist(this.dataFile)) {
                return false
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            for line in lines {
                line := Trim(line)
                if (line == "" || line == "{}") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("id") && String(data.id) == String(checkId)) {
                        return true
                    }
                } catch {
                    continue
                }
            }
            
            return false
        } catch {
            return false
        }
    }


    UpdateRecord() {
        if (!this.panelleftid || this.panelleftid == "" || Trim(this.panelleftid) == "") {
            MsgBox("panelleftid is : '" . this.panelleftid . "'")
            return
        }
        
        data := this.CollectFormData()
        
        data.id := String(this.panelleftid)
        this.idField.Text := data.id
        
        if (this.originalData.HasOwnProp("designation") && data.designation != this.originalData.designation) {
            result := MsgBox("Designation changed from '" . this.originalData.designation . "' to '" . data.designation . "'. Conﬁrm ?", "Confirmation", "YesNo")
            if (result == "No") {
                return
            }
        }
        
        try {
            if (!FileExist(this.dataFile)) {
                MsgBox("Data ﬁle not found.")
                return
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            updatedLines := []
            found := false
            
            totalRecords := 0
            
            for line in lines {
                line := Trim(line)
                if (line == "" || line == "{}") {
                    continue
                }
                
                totalRecords++
                
                try {
                    existingData := this.ParseJSON(line)
                    
                    if (existingData.HasOwnProp("id")) {
                        currentId := String(existingData.id)
                        targetId := String(this.panelleftid)
                        
                        if (currentId == targetId) {
                            updatedLines.Push(this.ObjectToJSON(data))
                            found := true
                        } else {
                            updatedLines.Push(line)
                        }
                    } else {
                        updatedLines.Push(line)
                    }
                } catch {
                    updatedLines.Push(line)
                }
            }
            
            if (!found) {
                MsgBox("Err L: '" . this.panelleftid)
                return
            }
            
            newContent := ""
            for line in updatedLines {
                newContent .= line . "`n"
            }
            
            FileDelete(this.dataFile)
            FileAppend(newContent, this.dataFile, "UTF-8")
            
            this.originalData := data.Clone()
            
            this.LoadDataToLeftPanel()
            this.PopulateDropdowns()
            
        } catch Error as err {
            MsgBox("Error Up‑date : " . err.Message)
        }
    }
    CloseFields() {
        if (this.panelleftid != "") {
            currentData := this.CollectFormData()
            
            if (this.HasDataChanged(currentData)) {
                result := MsgBox("Current data diﬀers , close ?", "Data Changed", "YesNo")
                if (result == "No") {
                    return
                }
            }
        }
        
        this.ClearFields()
        this.originalData := {}
    }
    
    HasDataChanged(currentData) {
        if (!this.panelleftid || this.panelleftid == "") {
            return currentData.designation != "" || currentData.designationId != "" || 
                   currentData.gender != "" || currentData.hairColor != "" || 
                   currentData.ageStart != "" || currentData.ageEnd != "" ||
                   currentData.dreams != ""
        }
        
        if (!this.originalData.HasOwnProp("id")) {
            return true 
        }
        
        fields := ["designation", "designationId", "gender", "species", "ageStart", "ageEnd", 
                   "heightStart", "heightEnd", "weightStart", "weightEnd", "skinColor", 
                   "hairColor", "hairLength", "hairStyle", "eyeColor", "facialHair", 
                   "voicePitch", "voiceQuality", "voiceTone", "relationshipType", "familyRelation",
                   "dreams"]
        
        for field in fields {
            currentVal := currentData.HasOwnProp(field) ? String(currentData.%field%) : ""
            originalVal := this.originalData.HasOwnProp(field) ? String(this.originalData.%field%) : ""
            
            if (currentVal != originalVal) {
                return true
            }
        }
        
        return false
    }
    
    ClearFields() {
        this.panelleftid := ""
        
        this.ClearFieldsOnly()
        
        this.saveBtn.Enabled := false
        this.originalData := {}
        
        try {
            this.recordsList.Modify(0, "-Select") 
        } catch {
            
        }
    }

    GetPersonData(designation, designationId) {
        try {
            if (!FileExist(this.dataFile)) {
                return {}
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            for line in lines {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("designation") && data.HasOwnProp("designationId")) {
                        if (data.designation == designation && data.designationId == designationId) {
                            return data
                        }
                    }
                } catch {
                    continue
                }
            }
            
            return {}
        } catch {
            return {}
        }
    }

    InsertRecordA() {
        data := this.CollectFormData()
        
        if (!data.designation || !data.designationId) {
            MsgBox("Fill designation & designation L ﬁrﬆ.")
            return
        }
        
        detailedInfo := this.GeneratePersonInfo(data)
        
        insertText := "— [ " . data.designation . " " . data.designationId . " ] : " . detailedInfo . " —"
        
        this.mainGui.Hide()
        Sleep(100)
        SendText(insertText)
    }

    GeneratePersonInfo(data) {
        if (!data.designation || !data.designationId) {
            return "In‑complete data"
        }
        
        infoText := data.designation . " " . data.designationId . " is a "
        
        gender := data.gender ? data.gender : "不明"
        species := data.species
        infoText .= gender . " " . species
        
        pronoun := ""
        if (StrLower(gender) == "male") {
            pronoun := "His"
        } else if (StrLower(gender) == "female") {
            pronoun := "Her"
        } else {
            pronoun := "Their"
        }
        
        if (data.ageStart && data.ageEnd) {
            infoText .= " with an age around " . data.ageStart . "‒" . data.ageEnd
        } else if (data.ageStart) {
            infoText .= " with an age around " . data.ageStart
        } else {
            infoText .= " with an age of 不明"
        }
        
        infoText .= " and " . pronoun . " traits are : "
        
        if (data.hairColor && data.hairColor != "") {
            infoText .= "has " . data.hairColor . " hair"
            if (data.hairLength && data.hairLength != "") {
                infoText .= " with " . data.hairLength
            }
            if (data.hairStyle && data.hairStyle != "") {
                infoText .= " " . data.hairStyle
            }
        } else {
            infoText .= "has 不明 hair"
        }
        
        infoText .= " , "
        
        if (data.eyeColor && data.eyeColor != "") {
            infoText .= data.eyeColor . " Iris‑color"
        } else {
            infoText .= "不明 Iris‑color"
        }
        
        infoText .= " , "
        
        if (data.accessories && data.accessories != "" && data.accessories != "without glaſses") {
            infoText .= "has " . data.accessories . " , "
        }
        
        infoText .= pronoun . " height is "
        if (data.heightStart && data.heightEnd) {
            infoText .= data.heightStart . "‒" . data.heightEnd . " C.‑m."
        } else if (data.heightStart) {
            infoText .= "around " . data.heightStart . " C.‑m."
        } else {
            infoText .= "不明 C.‑m."
        }
        
        infoText .= " , " . pronoun . " Skin colour is "
        if (data.skinColor && data.skinColor != "") {
            infoText .= data.skinColor
        } else {
            infoText .= "不明"
        }
        
        infoText .= " , weight "
        if (data.weightStart && data.weightEnd) {
            infoText .= data.weightStart . "‒" . data.weightEnd . " K.‑gr."
        } else if (data.weightStart) {
            infoText .= "around " . data.weightStart . " K.‑gr."
        } else {
            infoText .= "不明 K.‑gr."
        }
        
        infoText .= " , name : "
        if (data.nameStatus && data.nameStatus != "") {
            infoText .= data.nameStatus
        } else {
            infoText .= "不明"
        }
        
        infoText .= " , & "
        if (data.facialHair && data.facialHair != "") {
            infoText .= StrReplace(data.facialHair, "/", "⧸")
        }
        
        infoText .= " , " . pronoun . " relationship with Me : "
        if (data.relationshipType && data.relationshipType != "") {
            relationship := data.relationshipType
            
            if (data.relationshipPeriod && data.relationshipPeriod != "") {
                relationship .= " of " . data.relationshipPeriod
            }
            infoText .= relationship
            
            if (data.familyRelation && data.familyRelation != "" && data.familyRelation != "na") {
                infoText .= " with " . pronoun . " Family ﬆatus being " . data.familyRelation
            }
        } else {
            infoText .= "不明"
        }
        
        if (data.professionalRole && data.professionalRole != "") {
            infoText .= " , Professional role : " . data.professionalRole
        }
        
        if (data.personality && data.personality != "") {
            infoText .= " , personality : " . data.personality
        }
        
        if (data.behavioralNotes && data.behavioralNotes != "") {
            infoText .= " , behꜹiors : " . data.behavioralNotes
        }
        
        clothing := []
        if (data.topGarment && data.topGarment != "") clothing.Push(data.topGarment)
        if (data.bottomGarment && data.bottomGarment != "") clothing.Push(data.bottomGarment)
        if (data.outerLayer && data.outerLayer != "") clothing.Push(data.outerLayer)
        
        if (clothing.Length > 0) {
            infoText .= " , clothing : "
            for i, item in clothing {
                if (i > 1) infoText .= ", "
                infoText .= item
            }
        }
        
        if (data.uniformType && data.uniformType != "" && data.uniformType != "not uniform") {
            infoText .= " , Uniform type : " . data.uniformType
            if (data.uniformColor && data.uniformColor != "") {
                infoText .= " , Uniform colour : " . data.uniformColor
            }
        } else if (data.uniformType && data.uniformType != "") {
            infoText .= " , Uniform type : " . data.uniformType
        }
        if ((data.voicePitch && data.voicePitch != "") || (data.voiceQuality && data.voiceQuality != "") || (data.voiceTone && data.voiceTone != "")) {
            infoText .= " , & " . pronoun . " voice is : "
            
            firstVoice := true
            if (data.voicePitch && data.voicePitch != "") {
                infoText .= data.voicePitch
                firstVoice := false
            }
            if (data.voiceQuality && data.voiceQuality != "") {
                if (!firstVoice) infoText .= " , "
                infoText .= data.voiceQuality
                firstVoice := false
            }
            if (data.voiceTone && data.voiceTone != "") {
                if (!firstVoice) infoText .= " , "
                infoText .= data.voiceTone
            }
        }
        
        if (data.HasOwnProp("dreams") && data.dreams != "" && data.dreams != "undefined") {
            dreams := this.StringToArray(data.dreams)
            validDreams := []
            
            
            for dreamNumber in dreams {
                if (dreamNumber != "" && dreamNumber != "undefined") {
                    validDreams.Push(dreamNumber)
                }
            }
            
            if (validDreams.Length > 0) {
                infoText .= " , appears in dreams : "
                for i, dreamNumber in validDreams {
                    infoText .= "№ " . dreamNumber
                    if (i < validDreams.Length) { 
                        infoText .= " , "
                    }
                }
            }
        }
        
        return infoText
    }

    InsertEngrave() {
        if (this.engraveList.GetCount() == 0) {
            MsgBox("Engrave list is empty!")
            return
        }
        
        insertText := '<div style="text-align: justify;"><center>APPENDIX :</center>'
        
        loop this.engraveList.GetCount() {
            designation := this.engraveList.GetText(A_Index, 1)
            designationId := this.engraveList.GetText(A_Index, 2)
            
            personData := this.GetPersonData(designation, designationId)
            
            if (personData.HasOwnProp("designation")) {
                detailedInfo := this.GeneratePersonInfo(personData)
                insertText .= "<p>[ " . designation . " " . designationId . " ] : " . detailedInfo . ".</p>"
            } else {
                insertText .= "<p>[ " . designation . " " . designationId . " ] : information not ꜹailable.`</p>"
            }
        }
        
        insertText .= "<center>++--++</center>"
        currentDate := FormatTime(, "yyyyMMdd")
        insertText .= '<table style="width:100%;"><tr><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;">/s/ ʃunt Vĳelie<br>Data correct as of : ' . currentDate . '</td></tr><tr> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"></td> <td style="text-align:center;width:25%;"><img src="https://files.catbox.moe/k6q0p2.png" width="206px"></td> </tr></table></div>'

        
        this.mainGui.Hide()
        Sleep(100)
        SendText(insertText)
        this.mainGui.Destroy()
        this.isDestroyed := true
    }

    InsertRecordB() {
        data := this.CollectFormData()
        
        if (!data.designation || !data.designationId) {
            MsgBox("Please fill designation and designation ID first!")
            return
        }
        
        insertText := "[ " . data.designation . " " . data.designationId . " ]"
        
        this.mainGui.Hide()
        Sleep(100)
        SendText(insertText)
    }

    CollectFormData() {
        data := {}
        
        data.id := this.idField.Text
        data.designation := this.designationField.Text
        data.designationId := this.designationIdField.Text
        data.gender := this.genderField.Text
        data.species := this.speciesField.Text
        data.nameStatus := this.nameStatusField.Text
        
        data.ageStart := this.ageStartField.Text
        data.ageEnd := this.ageEndField.Text
        data.heightStart := this.heightStartField.Text
        data.heightEnd := this.heightEndField.Text
        data.weightStart := this.weightStartField.Text
        data.weightEnd := this.weightEndField.Text
        data.bmiRange := this.bmiField.Text
        
        data.skinColor := this.skinColorField.Text
        data.hairColor := this.hairColorField.Text  ; RAW TEXT - KEEPS FORMATTING
        data.hairLength := this.hairLengthField.Text
        data.hairStyle := this.hairStyleField.Text
        data.eyeColor := this.eyeColorField.Text  ; RAW TEXT - KEEPS FORMATTING
        data.facialHair := this.facialHairField.Text
        data.accessories := this.accessoriesField.Text
        
        data.voicePitch := this.voicePitchField.Text
        data.voiceQuality := this.voiceQualityField.Text
        data.voiceTone := this.voiceToneField.Text
        
        data.topGarment := this.topGarmentField.Text
        data.bottomGarment := this.bottomGarmentField.Text
        data.outerLayer := this.outerLayerField.Text
        data.uniformType := this.uniformTypeField.Text
        data.uniformColor := this.uniformColorField.Text  ; RAW TEXT - KEEPS FORMATTING
        
        data.relationshipType := this.relationshipTypeField.Text
        data.relationshipPeriod := this.relationshipPeriodField.Text
        data.professionalRole := this.professionalRoleField.Text
        data.familyRelation := this.familyRelationField.Text
        
        data.personality := this.personalityField.Text
        data.behavioralNotes := this.behavioralNotesField.Text
        
        ; Dreams
        dreams := []
        loop this.dreamsList.GetCount() {
            dreamNumber := this.dreamsList.GetText(A_Index, 2)
            if (dreamNumber != "") {
                dreams.Push(dreamNumber)
            }
        }
        data.dreams := this.ArrayToString(dreams)
        
        return data
    }

    
    PopulateDropdowns() {
        distinctValues := {
            hairColor: [],
            hairLength: [],
            hairStyle: [],
            eyeColor: [],
            accessories: [],
            voicePitch: [],
            voiceQuality: [],
            voiceTone: [],
            topGarment: [],
            bottomGarment: [],
            outerLayer: [],
            uniformType: [],
            relationshipType: [],
            relationshipPeriod: [],
            professionalRole: [],
            familyRelation: [],
            personality: [],
            behavioralNotes: []
        }
        
        try {
            if (FileExist(this.dataFile)) {
                content := FileRead(this.dataFile, "UTF-8")
                lines := StrSplit(content, "`n")
                
                for line in lines {
                    line := Trim(line)
                    if (line == "" || line == "{}") {
                        continue
                    }
                    
                    try {
                        data := this.ParseJSON(line)
                        
                        for field, values in distinctValues.OwnProps() {
                            if (data.HasOwnProp(field) && data.%field% != "" && !this.ArrayContains(values, data.%field%)) {
                                values.Push(data.%field%)
                            }
                        }
                    } catch {
                        continue
                    }
                }
            }
        } catch {
            
        }
        
        this.UpdateComboBox(this.hairColorField, distinctValues.hairColor)
        this.UpdateComboBox(this.hairLengthField, distinctValues.hairLength)
        this.UpdateComboBox(this.hairStyleField, distinctValues.hairStyle)
        this.UpdateComboBox(this.eyeColorField, distinctValues.eyeColor)
        this.UpdateComboBox(this.accessoriesField, distinctValues.accessories)
        this.UpdateComboBox(this.voicePitchField, distinctValues.voicePitch)
        this.UpdateComboBox(this.voiceQualityField, distinctValues.voiceQuality)
        this.UpdateComboBox(this.voiceToneField, distinctValues.voiceTone)
        this.UpdateComboBox(this.topGarmentField, distinctValues.topGarment)
        this.UpdateComboBox(this.bottomGarmentField, distinctValues.bottomGarment)
        this.UpdateComboBox(this.outerLayerField, distinctValues.outerLayer)
        this.UpdateComboBox(this.uniformTypeField, distinctValues.uniformType)
        this.UpdateComboBox(this.relationshipTypeField, distinctValues.relationshipType)
        this.UpdateComboBox(this.relationshipPeriodField, distinctValues.relationshipPeriod)
        this.UpdateComboBox(this.professionalRoleField, distinctValues.professionalRole)
        this.UpdateComboBox(this.familyRelationField, distinctValues.familyRelation)
        this.UpdateComboBox(this.personalityField, distinctValues.personality)
        this.UpdateComboBox(this.behavioralNotesField, distinctValues.behavioralNotes)
    }
    
    UpdateComboBox(control, values) {
        currentText := control.Text
        control.Delete()
        
        if (values.Length > 0) {
            control.Add(values)
        }
        
        if (currentText != "") {
            control.Text := currentText
        }
    }

    ObjectToJSON(obj) {
        jsonStr := "{"
        first := true
        
        for key, value in obj.OwnProps() {
            if (!first) {
                jsonStr .= ","
            }
            first := false
            
            value := StrReplace(String(value), '"', '\"')
            jsonStr .= '"' . key . '":"' . value . '"'
        }
        
        jsonStr .= "}"
        return jsonStr
    }
    
    ConfirmClose() {
        if (this.panelleftid != "") {
            currentData := this.CollectFormData()
            
            if (this.HasDataChanged(currentData)) {
                result := MsgBox("Close ? Un‑sꜹed hanges will be loﬆ.", "Confirm Close", "YesNo")
                if (result == "No") {
                    return
                }
            }
        }
        
        this.mainGui.Destroy()
        this.isDestroyed := true
    }
}
global SIPManager := SIPPersonManager()

class DreamManager {
    __New() {
        this.mainGui := Gui("+Resize", "Dream Manager")
        this.mainGui.OnEvent("Close", (*) => this.ConfirmClose())
        this.mainGui.Move(, , 1765, 956)
        
        this.doarFile := "E:\wwwwww\dosyâlar\dreams\doar.txt"
        this.dataFile := "E:\wwwwww\dosyâlar\dreams\dreams.txt"
        this.currentRecord := {}
        this.originalData := {}
        this.dreamId := ""
        this.isDestroyed := false
        this.mentalLockCounter := 1
        this.hasUnsavedChanges := false
        
        this.CreateLayout()
        this.LoadDataToLeftPanel()
        
        Hotstring(":O?*:\dream", (*) => this.ShowApp())
    }
    
    ShowApp() {
        if (HasProp(this, "isDestroyed") && this.isDestroyed) {
            this.__New()
            this.isDestroyed := false
        }
        
        try {
            this.mainGui.Show()
        } catch Error as err {
            this.__New()
            this.mainGui.Show()
        }
    }
    
    CreateLayout() {
        this.leftPanel := this.mainGui.Add("GroupBox", "x10 y10 w208 h932", "")
        this.dreamsList := this.mainGui.Add("ListView", "x20 y30 w188 h850 -Multi", ["№", "D", "W"])
        this.dreamsList.ModifyCol(1, 60)
        this.dreamsList.ModifyCol(2, 60)
        this.dreamsList.ModifyCol(3, 60)
        this.dreamsList.OnEvent("ItemSelect", (*) => this.OnItemSelect())
        this.timelineBtn := this.mainGui.Add("Button", "x20 y890 w188 h42", "VIEW TIME‑LINE")
        this.timelineBtn.OnEvent("Click", (*) => this.ViewTimeline())


        this.buttonPanel := this.mainGui.Add("GroupBox", "x228 y10 w1535 h57", "")

        this.encoderBtn := this.mainGui.Add("Button", "x238 y25 w141 h28", "EN‑CODER")
        this.encoderBtn.OnEvent("Click", (*) => this.OpenEncoder())

        this.somniumPeopleBtn := this.mainGui.Add("Button", "x389 y25 w141 h28", "ʃomnium people")
        this.somniumPeopleBtn.OnEvent("Click", (*) => this.OpenSomniumPeople())

        this.somniumHexBtn := this.mainGui.Add("Button", "x540 y25 w141 h28", "ʃomnium HEX")
        this.somniumHexBtn.OnEvent("Click", (*) => this.OpenSomniumHex())

        this.viewBtn := this.mainGui.Add("Button", "x1612 y25 w141 h28", "VIEW")
        this.viewBtn.OnEvent("Click", (*) => this.ViewDream())

        this.saveBtn := this.mainGui.Add("Button", "x1461 y25 w141 h28", "SꜸE")
        this.saveBtn.OnEvent("Click", (*) => this.SaveRecord())
        this.saveBtn.Enabled := false

        this.newBtn := this.mainGui.Add("Button", "x1310 y25 w141 h28", "NEW")
        this.newBtn.OnEvent("Click", (*) => this.CreateNewRecord())

        this.updateBtn := this.mainGui.Add("Button", "x1159 y25 w141 h28", "UP‑DATE")
        this.updateBtn.OnEvent("Click", (*) => this.UpdateRecord())
        this.infoPanel := this.mainGui.Add("GroupBox", "x228 y77 w1523 h32", "")
        
        this.mainGui.Add("Text", "x238 y85 w80 h20 Center", "Dream № :")
        this.dreamNumberField := this.mainGui.Add("Edit", "x318 y85 w200 h20 ReadOnly")
        
        this.mainGui.Add("Text", "x1321 y85 w80 h20 Center", "Wake time :")
        this.wakeTimeField := this.mainGui.Add("Edit", "x1401 y85 w115 h20")
        this.wakeTimeField.OnEvent("Change", (*) => this.OnFieldChange())
        
        this.mainGui.Add("Text", "x1541 y85 w100 h20 Center", "Eﬆ. Onset time :")
        this.onsetTimeField := this.mainGui.Add("Edit", "x1641 y85 w115 h20")
        this.onsetTimeField.OnEvent("Change", (*) => this.OnFieldChange())
        
        this.CreateMainArea()
        this.CreateRightPanel()
    }
    CreateMainArea() {
        this.ocrArea := this.mainGui.Add("GroupBox", "x228 y119 w1183 h109", "")
        this.ocrTextArea := this.mainGui.Add("Edit", "x238 y139 w1163 h79 VScroll +Multi +Center")
        this.ocrTextArea.SetFont("s12", "OCR-B")
        this.ocrTextArea.OnEvent("Change", (*) => this.OnFieldChange())
        
        this.dreamContentArea := this.mainGui.Add("GroupBox", "x228 y237 w1183 h529", "")
        this.dreamTextArea := this.mainGui.Add("Edit", "x238 y258 w1163 h499 VScroll +Multi +Center")
        this.dreamTextArea.SetFont("s12", "Times New Roman")
        this.dreamTextArea.OnEvent("Change", (*) => this.OnFieldChange())
        
        OnMessage(0x0100, this.OnWM_KEYDOWN.Bind(this))
        
        this.symbolArea := this.mainGui.Add("GroupBox", "x228 y774 w1183 h168", "")
        yPos := 786
        symbols := ["†", "‡", "※", "∗", "⁑", "⁂"]
        this.symbolFields := []
        
        for i, symbol in symbols {
            this.mainGui.Add("Text", "x238 y" . yPos . " w20 h20", symbol)
            field := this.mainGui.Add("Edit", "x268 y" . yPos . " w1133 h20")
            field.OnEvent("Change", (*) => this.OnFieldChange())
            this.symbolFields.Push(field)
            yPos += 25
        }
    }


    OnWM_KEYDOWN(wParam, lParam, msg, hwnd) {
        if (this.isDestroyed || !HasProp(this, "dreamTextArea"))
            return
            
        try {
            if (hwnd == this.dreamTextArea.Hwnd && wParam == 8 && GetKeyState("Ctrl", "P")) {
                Send("{Shift down}{Ctrl down}{Left}{Ctrl up}{Shift up}{Backspace}")
                return 0
            }
        } catch {
            return
        }
    }

    CreateRightPanel() {
        this.statePanel := this.mainGui.Add("GroupBox", "x1421 y119 w342 h110", "")
        
        this.soberRadio := this.mainGui.Add("Radio", "x1431 y139 w100 h20 Checked", "Sober")
        this.ethanolRadio := this.mainGui.Add("Radio", "x1431 y159 w150 h20", "Ethanol Intoxication")
        this.otherRadio := this.mainGui.Add("Radio", "x1431 y179 w150 h20", "Intoxication ( Other )")
        this.otherRadio.OnEvent("Click", (*) => this.ToggleOtherField())
        this.soberRadio.OnEvent("Click", (*) => this.ToggleOtherField())
        this.ethanolRadio.OnEvent("Click", (*) => this.ToggleOtherField())
        
        this.otherField := this.mainGui.Add("Edit", "x1431 y199 w322 h20")
        this.otherField.Enabled := false
        this.otherField.OnEvent("Change", (*) => this.OnFieldChange())
        
        this.mentalLockPanel := this.mainGui.Add("GroupBox", "x1421 y239 w342 h379", "")
        
        this.mentalLockInput := this.mainGui.Add("Edit", "x1431 y259 w322 h20")
        
        this.removeBtn := this.mainGui.Add("Button", "x1431 y289 w120 h25", "REMOVE")
        this.removeBtn.OnEvent("Click", (*) => this.RemoveMentalLock())
        this.removeBtn.Enabled := false
        
        this.addBtn := this.mainGui.Add("Button", "x1633 y289 w120 h25", "ADD")
        this.addBtn.OnEvent("Click", (*) => this.AddMentalLock())
        
        this.mentalLockList := this.mainGui.Add("ListView", "x1431 y324 w322 h284 -Multi", ["№", "Mental‑lock"])
        this.mentalLockList.ModifyCol(1, 50)
        this.mentalLockList.ModifyCol(2, 260)
        this.mentalLockList.OnEvent("ItemSelect", (*) => this.OnMentalLockSelect())
        
        this.evaluationCheck := this.mainGui.Add("CheckBox", "x1421 y628 w20 h20")
        this.evaluationCheck.OnEvent("Click", (*) => this.ToggleEvaluation())
        this.mainGui.Add("Text", "x1446 y628 w100 h20 Center", "EVALUATION")
        
        this.evaluationField := this.mainGui.Add("Edit", "x1421 y658 w342 h283 VScroll +Multi")
        this.evaluationField.Enabled := false
        this.evaluationField.OnEvent("Change", (*) => this.OnFieldChange())
    }
    
    OnFieldChange() {
        if (this.dreamId != "" && !this.hasUnsavedChanges) {
            this.hasUnsavedChanges := false
            this.newBtn.Enabled := true
        }
    }
    
    OnItemSelect() {
        if (this.hasUnsavedChanges) {
            result := MsgBox("Un‐sꜹed data.", "", "YesNo")
            if (result == "No") {
                return
            }
            this.hasUnsavedChanges := false
            this.newBtn.Enabled := true
        }
        this.LoadRecord()
    }
    
    ToggleOtherField() {
        this.otherField.Enabled := this.otherRadio.Value
        if (!this.otherRadio.Value) {
            this.otherField.Text := ""
        }
        this.OnFieldChange()
    }
    
    ToggleEvaluation() {
        this.evaluationField.Enabled := this.evaluationCheck.Value
        if (!this.evaluationCheck.Value) {
            this.evaluationField.Text := ""
        }
        this.OnFieldChange()
    }
    
    OnMentalLockSelect() {
        this.removeBtn.Enabled := this.mentalLockList.GetNext() > 0
    }
    
    AddMentalLock() {
        lockText := this.mentalLockInput.Text
        if (lockText == "") {
            MsgBox("Enter mental‑lock text first.")
            return
        }
        
        this.mentalLockList.Add("", this.mentalLockCounter, lockText)
        this.mentalLockCounter++
        this.mentalLockInput.Text := ""
        this.OnFieldChange()
    }
    
    RemoveMentalLock() {
        selectedRow := this.mentalLockList.GetNext()
        if (!selectedRow) {
            MsgBox("Select a mental‑lock from the list.")
            return
        }
        
        this.mentalLockList.Delete(selectedRow)
        this.removeBtn.Enabled := false
        this.OnFieldChange()
    }
    ViewTimeline() {
        try {
            scriptPath := "E:\wwwwww\dosyâlar\dreams\a.py"
            
            if (!FileExist(scriptPath)) {
                MsgBox("a.py not found at: " . scriptPath)
                return
            }
            
            pythonPaths := ["python", "python3", "py", "c:\Users\aretha\AppData\Local\Programs\Python\Python312\python.exe"]
            
            success := false
            for pythonPath in pythonPaths {
                try {
                    Run(pythonPath . " `"" . scriptPath . "`"", "E:\wwwwww\dosyâlar\dreams", "")
                    success := true
                    break
                } catch {
                    continue
                }
            }
            
            if (!success) {
                MsgBox("Could not run Python script")
            }
            
        } catch Error as err {
            MsgBox("Error running timeline: " . err.Message)
        }
    }
    ViewDream() {
        selectedRow := this.dreamsList.GetNext()
        if (!selectedRow) {
            MsgBox("No dream selected.")
            return
        }
        
        dreamNumber := this.dreamsList.GetText(selectedRow, 1)
        
        try {
            if (!FileExist(this.dataFile)) {
                MsgBox("File doesn't exist.")
                return
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            for line in lines {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("dreamNumber") && String(data.dreamNumber) == dreamNumber) {
                        this.GenerateHTMLView(data)
                        return
                    }
                } catch {
                    continue
                }
            }
            
            MsgBox("Dream record not found.")
            
        } catch Error as err {
            MsgBox("Error: " . err.Message)
        }
    }

    GenerateHTMLView(data) {
        dreamDate := data.HasOwnProp("date") ? data.date : ""
        
        wakeTime := data.HasOwnProp("wakeTime") ? data.wakeTime : "X"
        onsetTime := data.HasOwnProp("onsetTime") ? data.onsetTime : "X"
        dreamNum := data.HasOwnProp("dreamNumber") ? data.dreamNumber : "X"
        

        ocrRows := ["", "", ""]
        if (data.HasOwnProp("ocrText")) {
            ocrText := this.HTMLToPlainText(data.ocrText)
            ocrText := StrReplace(ocrText, "`r`n", "`n")
            ocrText := StrReplace(ocrText, "`r", "`n")
            ocrText := Trim(ocrText)
            
            ocrLines := StrSplit(ocrText, "`n")
            
            validLines := []
            for line in ocrLines {
                trimmedLine := Trim(line)
                if (trimmedLine != "") {
                    validLines.Push(trimmedLine)
                }
            }
            
            loop 3 {
                if (A_Index <= validLines.Length) {
                    ocrRows[A_Index] := validLines[A_Index]
                }
            }
        }
        
        dreamContent := ""
        if (data.HasOwnProp("dreamText")) {
            dreamContent := data.dreamText
            dreamContent := StrReplace(dreamContent, "`r`n", "<br>")
            dreamContent := StrReplace(dreamContent, "`n", "<br>")
        }
        
        mentalStateX := ["", "", ""]
        if (data.HasOwnProp("mentalState")) {
            switch data.mentalState {
                case "Sober":
                    mentalStateX[1] := "X"
                case "Ethanol Intoxication":
                    mentalStateX[2] := "X"
                case "Other":
                    mentalStateX[3] := "X"
            }
        }
        
        mentalLocksHTML := ""
        if (data.HasOwnProp("mentalLocks") && data.mentalLocks != "") {
            locks := this.StringToArray(data.mentalLocks)
            if (locks.Length > 0) {
                mentalLocksHTML := "<p>Mental-locks recorded :</p>`n"
                for i, lockText in locks {
                    if (i == locks.Length) {
                        mentalLocksHTML .= "<p>ʃomnium " . i . " : " . lockText . ".</p>`n"
                    } else {
                        mentalLocksHTML .= "<p>ʃomnium " . i . " : " . lockText . ",</p>`n"
                    }
                }
            } else {
                mentalLocksHTML := "<p>Mental-locks recorded : Moﬆ Un‑known</p>`n"
            }
        } else {
            mentalLocksHTML := "<p>Mental-locks recorded : Moﬆ Un‑known</p>`n"
        }
        
        symbolFields := []
        symbolData := ["symbol1", "symbol2", "symbol3", "symbol4", "symbol5", "symbol6"]
        symbols := ["†", "‡", "※", "∗", "⁑", "⁂"]
        hasAnySymbol := false
        
        for i, symbolKey in symbolData {
            fieldText := ""
            if (data.HasOwnProp(symbolKey) && data.%symbolKey% != "") {
                fieldText := data.%symbolKey%
                hasAnySymbol := true
            }
            symbolFields.Push(fieldText)
        }
        
        symbolHTML := ""
        if (hasAnySymbol) {
            symbolHTML := "<hr>`n"
            for i, fieldText in symbolFields {
                if (fieldText != "") {
                    symbolHTML .= "<p>" . symbols[i] . fieldText . "</p>`n"
                }
            }
        }
        
        evaluationHTML := ""
        if (data.HasOwnProp("hasEvaluation") && data.hasEvaluation == "true") {
            evaluationField := data.HasOwnProp("evaluation") ? data.evaluation : ""
            evaluationHTML := "<center>EVALUATION</center>`n"
            evaluationHTML .= "<p style='text-align: justify;'>It appears that " . evaluationField . "</p>`n"
        }
        
        html := "<!DOCTYPE html>`n"
        html .= "<html lang=`"en`">`n"
        html .= "    <head>`n"
        html .= "        <meta charset=`"UTF-8`">`n"
        html .= "        <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0`">`n"
        html .= "        <title>dream</title>`n"
        html .= "        <style>`n"
        html .= "        *{`n"
        html .= "            margin: 0;`n"
        html .= "            padding: 0;`n"
        html .= "        }`n"
        html .= "        @font-face {`n"
        html .= "            font-family: OCR‑B;`n"
        html .= "            src: url(E:\\wwwwww\\dosyâlar\\dreams\\OCR-B-regular-web.ttf);`n"
        html .= "        }`n"
        html .= "        @font-face {`n"
        html .= "            font-family: nullpunktsenergiefont;`n"
        html .= "            src: url(E:\\wwwwww\\dosyâlar\\dreams\nullpunktsenergiefont-Regular.ttf);`n"
        html .= "        }`n"
        html .= "        @font-face {`n"
        html .= "            font-family: Junicode;`n"
        html .= "            src: url(E:\\wwwwww\\dosyâlar\\dreams\\JunicodeVF-Roman.woff2);`n"
        html .= "        }`n"
        html .= "        .katex,`n"
        html .= "        .katex * {`n"
        html .= "            -webkit-font-smoothing: antialiased;`n"
        html .= "            -moz-osx-font-smoothing: grayscale;`n"
        html .= "            text-rendering: optimizeLegibility;`n"
        html .= "            font-smooth: always;`n"
        html .= "            letter-spacing: 0pt;`n"
        html .= "            font-size: 1em;`n"
        html .= "            text-indent: 0 !important;`n"
        html .= "        }`nbody:not(.katex):not(.katex *) { font-family: 'Junicode', 'nullpunktsenergiefont'; letter-spacing: 0; text-rendering: auto; image-rendering: optimizeQuality !important; font-variant-ligatures:discretionary-ligatures contextual common-ligatures; font-feature-settings: 'ss17', 'cv01','cv02','cv22' 2,'cv48'; font-variant-numeric: lining-nums; }`n"
        html .= "        </style>`n"
        html .= "        <link rel=`"stylesheet`" href=`"https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.css`" integrity=`"sha384-5TcZemv2l/9On385z///+d7MSYlvIEw9FuZTIdZ14vJLqWphw7e7ZPuOiCHJcFCP`" crossorigin=`"anonymous`">`n"
        html .= "        <script defer src=`"https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.js`" integrity=`"sha384-cMkvdD8LoxVzGF/RPUKAcvmm49FQ0oxwDF3BGKtDXcEc+T1b2N+teh/OJfpU0jr6`" crossorigin=`"anonymous`"></script>`n"
        html .= "        <script defer src=`"https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/contrib/auto-render.min.js`" integrity=`"sha384-hCXGrW6PitJEwbkoStFjeJxv+fSOOQKOPbJxSfM6G5sWZjAyWhXiTIIAmQqnlLlh`" crossorigin=`"anonymous`"`n"
        html .= "            onload=`"renderMathInElement(document.body);`"></script>`n"
        html .= "    </head>`n"
        html .= "    <body>`n"
        html .= '    <p style="font-weight: bolder;text-align: center;font-size: xx-large;">Oneiric report</p>`n'
        html .= "        <div style=`"width: 100%;`">`n"
        html .= "            <table width=`"100%`">`n"
        html .= "                <tr>`n"
        html .= "                    <td style=`"font: normal 1.21em KaTeX_TypeWriter`">" . dreamDate . "</td>`n"
        html .= "                    <td style=`"text-align: right;font: normal 1.21em KaTeX_TypeWriter`">Wake time : " . wakeTime . " | Est. On‑set time : " . onsetTime . "</td>`n"
        html .= "                </tr>`n"
        html .= "            </table>`n"
        html .= "            <p style=`"border:1px solid black;padding: 2em;width: 25%; margin:0 auto;text-align: center;font-weight: bolder`">Place-holder Statement</p>`n"
        html .= "            <div style=`"text-align: center;font-family: OCR‑B;`">`n"
        html .= "                <p>" . ocrRows[1] . "</p>`n"
        html .= "                <p>" . ocrRows[2] . "</p>`n"
        html .= "                <p>" . ocrRows[3] . "</p>`n"
        html .= "            </div>`n"
        html .= "            <p style=`"text-align: center;`"><strong>Events & appendix :</strong></p>`n"
        html .= "            <table width=`"100%`" cellspacing=`"0`" cellpadding=`"0`">`n"
        html .= "                <tbody>`n"
        html .= "                    <tr>`n"
        html .= "                        <td>`n"
        html .= "                            <p>🙤</p>`n"
        html .= "                        </td>`n"
        html .= "                        <td style=`"text-align: center;`">`n"
        html .= "                            <p><span lang=`"ja-JP`">︽</span></p>`n"
        html .= "                        </td>`n"
        html .= "                        <td style=`"text-align: right;`">`n"
        html .= "                            <p>🙦</p>`n"
        html .= "                        </td>`n"
        html .= "                    </tr>`n"
        html .= "                </tbody>`n"
        html .= "            </table>`n"
        html .= "            <div style=`"text-align: center;`">`n"
        html .= "                " . dreamContent . "`n"
        html .= "            </div>`n"
        html .= "            <table width=`"100%`" cellspacing=`"0`" cellpadding=`"0`">`n"
        html .= "                <tbody>`n"
        html .= "                    <tr>`n"
        html .= "                        <td >`n"
        html .= "                            <p>🙥</p>`n"
        html .= "                        </td>`n"
        html .= "                        <td style=`"text-align: center;`">`n"
        html .= "                            <p><span lang=`"ja-JP`">︾</span></p>`n"
        html .= "                        </td>`n"
        html .= "                        <td style=`"text-align: right;`">`n"
        html .= "                            <p>🙧</p>`n"
        html .= "                        </td>`n"
        html .= "                    </tr>`n"
        html .= "                </tbody>`n"
        html .= "            </table>`n"
        html .= "            <p>Dream № : " . dreamNum . "</p>`n"
        html .= "            <table width=`"100%`" cellspacing=`"0`" cellpadding=`"4`" style=`"text-align: center;`">`n"
        html .= "                <tbody>`n"
        html .= "                    <tr>`n"
        html .= "                        <td width=`"11`">`n"
        html .= "                            <p>" . mentalStateX[1] . "</p>`n"
        html .= "                        </td>`n"
        html .= "                        <td>`n"
        html .= "                            <p>Sober</p>`n"
        html .= "                        </td>`n"
        html .= "                        <td width=`"11`">" . mentalStateX[2] . "</td>`n"
        html .= "                        <td>`n"
        html .= "                            <p>Ethanol Intoxication</p>`n"
        html .= "                        </td>`n"
        html .= "                        <td width=`"11`">" . mentalStateX[3] . "</td>`n"
        html .= "                        <td>`n"
        html .= "                            <p>Intoxication ( Other )</p>`n"
        html .= "                        </td>`n"
        html .= "                    </tr>`n"
        html .= "                </tbody>`n"
        html .= "            </table>`n"
        html .= "            " . mentalLocksHTML . "`n"
        html .= "            " . symbolHTML . "`n"
        html .= "            " . evaluationHTML . "`n"
        html .= "        </div>`n"
        html .= "    </body>`n"
        html .= "</html>"
        
        tempFile := "E:\wwwwww\dosyâlar\dreams\dream\№_" . dreamNum . ".html"
        try {
            FileDelete(tempFile)
        } catch {
        }
        
        FileAppend(html, tempFile, "UTF-8")
        
        Run(tempFile)
    }
    h8d2y(timeStr) {
    timeStr := StrReplace(timeStr, "午前", "AM")
    timeStr := StrReplace(timeStr, "午後", "PM")
    
    if (InStr(timeStr, "AM")) {
        timeStr := RegExReplace(timeStr, "^12", "00")
    }
    if (InStr(timeStr, "PM")) {
        timeStr := RegExReplace(timeStr, "^12", "00")
    }
    
    return timeStr
    }
    CreateNewRecord() {
        if (this.hasUnsavedChanges) {
            result := MsgBox("Un‐sꜹed data.", "", "YesNo")
            if (result == "No") {
                return
            }
        }
        
        this.dreamsList.Modify(0, "-Select")
        
        nextDreamNumber := this.GetNextDreamNumber()
        
        this.ClearFields()
        
        this.dreamNumberField.Text := String(nextDreamNumber)
        this.dreamId := String(nextDreamNumber)
        
        currentTime := FormatTime(, "hhmmsstt")
        formattedTime := this.h8d2y(currentTime)
        this.wakeTimeField.Text := formattedTime
        
        this.saveBtn.Enabled := true
        this.updateBtn.Enabled := false
        this.newBtn.Enabled := true
        this.originalData := {}
        this.hasUnsavedChanges := false
    }
    
    GetNextDreamNumber() {
        maxNumber := 0
        
        try {
            if (FileExist(this.dataFile)) {
                content := FileRead(this.dataFile, "UTF-8")
                lines := StrSplit(content, "`n")
                
                for line in lines {
                    line := Trim(line)
                    if (line == "" || line == "{}") {
                        continue
                    }
                    
                    try {
                        data := this.ParseJSON(line)
                        if (data.HasOwnProp("dreamNumber")) {
                            currentNumber := Integer(data.dreamNumber)
                            if (currentNumber > maxNumber) {
                                maxNumber := currentNumber
                            }
                        }
                    } catch {
                        continue
                    }
                }
            }
        } catch {
        }
        
        return maxNumber + 1
    }
    
    LoadDataToLeftPanel() {
        this.dreamsList.Delete()
        
        try {
            if (!FileExist(this.dataFile)) {
                return
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            records := []
            
            for line in lines {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("dreamNumber")) {
                        records.Push({
                            dreamNumber: data.dreamNumber,
                            date: data.HasOwnProp("date") ? data.date : "",
                            wakeTime: data.HasOwnProp("wakeTime") ? data.wakeTime : ""
                        })
                    }
                } catch {
                    continue
                }
            }
            
            this.SortRecords(records)
            
            for record in records {
                this.dreamsList.Add("", record.dreamNumber, record.date, record.wakeTime)
            }
            
        } catch Error as err {
            MsgBox("Error loading data: " . err.Message)
        }
    }
    
    SortRecords(records) {
        n := records.Length
        
        loop n - 1 {
            swapped := false
            loop n - A_Index {
                if (Integer(records[A_Index].dreamNumber) < Integer(records[A_Index + 1].dreamNumber)) {
                    temp := records[A_Index]
                    records[A_Index] := records[A_Index + 1]
                    records[A_Index + 1] := temp
                    swapped := true
                }
            }
            if (!swapped) {
                break
            }
        }
    }
    


    LoadRecord() {
        selectedRow := this.dreamsList.GetNext()
        if (!selectedRow) {
            return
        }
        
        
        this.ClearFields()
        this.saveBtn.Enabled := false
        this.updateBtn.Enabled := true
        this.newBtn.Enabled := false
        this.hasUnsavedChanges := false
        
        dreamNumber := this.dreamsList.GetText(selectedRow, 1)
        this.dreamId := dreamNumber
        
        try {
            if (!FileExist(this.dataFile)) {
                MsgBox("File doesn't exist.")
                return
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            for line in lines {
                line := Trim(line)
                if (line == "") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("dreamNumber") && String(data.dreamNumber) == dreamNumber) {
                        this.PopulateFields(data)
                        this.originalData := data.Clone()
                        return
                    }
                } catch {
                    continue
                }
            }
            
        } catch Error as err {
            MsgBox("Error: " . err.Message)
        }
        
    }

    PopulateFields(data) {
        this.dreamNumberField.Text := data.HasOwnProp("dreamNumber") ? String(data.dreamNumber) : ""
        this.wakeTimeField.Text := data.HasOwnProp("wakeTime") ? data.wakeTime : ""
        this.onsetTimeField.Text := data.HasOwnProp("onsetTime") ? data.onsetTime : ""
        
        if (data.HasOwnProp("ocrText")) {
            this.ocrTextArea.Text := this.HTMLToPlainText(data.ocrText)
        } else {
            this.ocrTextArea.Text := ""
        }
        
        if (data.HasOwnProp("dreamText")) {
            this.dreamTextArea.Text := this.HTMLToPlainText(data.dreamText)
        } else {
            this.dreamTextArea.Text := ""
        }
        
        if (data.HasOwnProp("mentalState")) {
            switch data.mentalState {
                case "Sober":
                    this.soberRadio.Value := 1
                case "Ethanol Intoxication":
                    this.ethanolRadio.Value := 1
                case "Other":
                    this.otherRadio.Value := 1
                    this.otherField.Enabled := true
                    this.otherField.Text := data.HasOwnProp("otherIntoxication") ? data.otherIntoxication : ""
            }
        }
        
        symbolData := ["symbol1", "symbol2", "symbol3", "symbol4", "symbol5", "symbol6"]
        for i, field in this.symbolFields {
            if (data.HasOwnProp(symbolData[i])) {
                field.Text := data.%symbolData[i]%
            }
        }
        
        this.mentalLockList.Delete()
        this.mentalLockCounter := 1
        if (data.HasOwnProp("mentalLocks") && data.mentalLocks != "") {
            locks := this.StringToArray(data.mentalLocks)
            for lockText in locks {
                if (lockText != "") {
                    this.mentalLockList.Add("", this.mentalLockCounter, lockText)
                    this.mentalLockCounter++
                }
            }
        }
        
        if (data.HasOwnProp("hasEvaluation") && data.hasEvaluation == "true") {
            this.evaluationCheck.Value := 1
            this.evaluationField.Enabled := true
            this.evaluationField.Text := data.HasOwnProp("evaluation") ? data.evaluation : ""
        }
    }
    HTMLToPlainText(html) {
        if (html == "") {
            return ""
        }
        
        if (InStr(html, "<div") || InStr(html, "<table") || InStr(html, "<center")) {
            return html
        }
        
        text := html
        
        text := RegExReplace(text, "<p>", "")
        text := RegExReplace(text, "</p>", "`n")
        text := RegExReplace(text, "<br>", "`n")
        text := RegExReplace(text, "<br/>", "`n")
        text := RegExReplace(text, "<br />", "`n")
        
        text := StrReplace(text, '\"', '"')
        text := StrReplace(text, "\'", "'")
        text := StrReplace(text, '\n', "`n")
        text := StrReplace(text, '\r', "`r")
        text := StrReplace(text, '\t', "`t")
        
        
        return text
    }


    PlainTextToHTML(text) {
        if (text == "") {
            return ""
        }
        
        lines := StrSplit(text, "`n")
        cleanLines := []
        
        for line in lines {
            trimmed := Trim(line)
            if (trimmed != "") {
                cleanLines.Push(trimmed)
            }
        }
        
        if (cleanLines.Length > 3) {
            MsgBox(">3 rows.", "", "OK")
            return ""
        }
        
        while (cleanLines.Length < 3) {
            cleanLines.Push("")
        }
        
        html := ""
        for i, line in cleanLines {
            html .= "<p>" . line . "</p>"
            if (i < cleanLines.Length) {
                html .= "`n"
            }
        }
        
        return html
    }   
    
    FormatDreamText(text) {
            if (text == "") {
                return ""
            }
            
            if (InStr(text, "<div") || InStr(text, "<p>") || InStr(text, "<table") || InStr(text, "<center")) {
                return text
            }
            
            text := StrReplace(text, "`r`n", "`n")
            text := StrReplace(text, "`r", "`n")
            text := Trim(text)
            
            lines := StrSplit(text, "`n")
            formattedText := ""
            
            for i, line in lines {
                line := Trim(line)
                if (line != "") {
                    if (formattedText != "") {
                        formattedText .= "`n"
                    }
                    formattedText .= "<p>" . line . "</p>"
                }
            }
            
            return formattedText
        }

    SaveRecord() {
        ocrHTML := this.PlainTextToHTML(this.ocrTextArea.Text)
        if (ocrHTML == "" && this.ocrTextArea.Text != "") {
            return
        }
        
        data := this.CollectFormData()
        data.ocrText := ocrHTML
        data.dreamText := this.FormatDreamText(data.dreamText)
        
        if (!data.dreamNumber) {
            MsgBox("Dream number is required.")
            return
        }
        
        if (this.DreamExistsInFile(data.dreamNumber)) {
            MsgBox("Dream number already exists in file.")
            return
        }
        
        try {
            jsonLine := this.ObjectToJSON(data)
            
            dir := RegExReplace(this.dataFile, "[^\\]*$", "")
            if (!DirExist(dir)) {
                DirCreate(dir)
            }
            
            FileAppend(jsonLine . "`n", this.dataFile, "UTF-8")
            
            this.originalData := data.Clone()
            this.saveBtn.Enabled := false
            this.updateBtn.Enabled := true
            this.hasUnsavedChanges := false
            
            this.LoadDataToLeftPanel()
            
        } catch Error as err {
            MsgBox("Error saving record: " . err.Message)
        }
    }
    
    UpdateRecord() {
        if (!this.dreamId || this.dreamId == "") {
            MsgBox("No dream selected for update.")
            return
        }
        
        ocrHTML := this.PlainTextToHTML(this.ocrTextArea.Text)
        if (ocrHTML == "" && this.ocrTextArea.Text != "") {
            return
        }
        
        data := this.CollectFormData()
        data.dreamNumber := this.dreamId
        data.ocrText := ocrHTML
        data.dreamText := this.FormatDreamText(data.dreamText)
        
        try {
            if (!FileExist(this.dataFile)) {
                MsgBox("Data file not found.")
                return
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            updatedLines := []
            found := false
            
            for line in lines {
                line := Trim(line)
                if (line == "" || line == "{}") {
                    continue
                }
                
                try {
                    existingData := this.ParseJSON(line)
                    
                    if (existingData.HasOwnProp("dreamNumber") && String(existingData.dreamNumber) == String(this.dreamId)) {
                        updatedLines.Push(this.ObjectToJSON(data))
                        found := true
                    } else {
                        updatedLines.Push(line)
                    }
                } catch {
                    updatedLines.Push(line)
                }
            }
            
            if (!found) {
                MsgBox("Dream record not found for update.")
                return
            }
            
            newContent := ""
            for line in updatedLines {
                newContent .= line . "`n"
            }
            
            FileDelete(this.dataFile)
            FileAppend(newContent, this.dataFile, "UTF-8")
            
            this.originalData := data.Clone()
            this.hasUnsavedChanges := false
            this.LoadDataToLeftPanel()
            
        } catch Error as err {
            MsgBox("Error updating record: " . err.Message)
        }
    }
    
    DreamExistsInFile(dreamNumber) {
        try {
            if (!FileExist(this.dataFile)) {
                return false
            }
            
            content := FileRead(this.dataFile, "UTF-8")
            lines := StrSplit(content, "`n")
            
            for line in lines {
                line := Trim(line)
                if (line == "" || line == "{}") {
                    continue
                }
                
                try {
                    data := this.ParseJSON(line)
                    if (data.HasOwnProp("dreamNumber") && String(data.dreamNumber) == String(dreamNumber)) {
                        return true
                    }
                } catch {
                    continue
                }
            }
            
            return false
        } catch {
            return false
        }
    }
    
    CollectFormData() {
        data := {}
        
        data.dreamNumber := this.dreamNumberField.Text
        data.wakeTime := this.wakeTimeField.Text
        data.onsetTime := this.onsetTimeField.Text
        data.dreamText := this.dreamTextArea.Text
        data.date := FormatTime(, "yyyyMMdd")
        
        if (this.soberRadio.Value) {
            data.mentalState := "Sober"
        } else if (this.ethanolRadio.Value) {
            data.mentalState := "Ethanol Intoxication"
        } else if (this.otherRadio.Value) {
            data.mentalState := "Other"
            data.otherIntoxication := this.otherField.Text
        }
        
        symbolData := ["symbol1", "symbol2", "symbol3", "symbol4", "symbol5", "symbol6"]
        for i, field in this.symbolFields {
            data.%symbolData[i]% := field.Text
        }
        
        mentalLocks := []
        loop this.mentalLockList.GetCount() {
            lockText := this.mentalLockList.GetText(A_Index, 2)
            if (lockText != "") {
                mentalLocks.Push(lockText)
            }
        }
        data.mentalLocks := this.ArrayToString(mentalLocks)
        
        data.hasEvaluation := this.evaluationCheck.Value ? "true" : "false"
        if (this.evaluationCheck.Value) {
            data.evaluation := this.evaluationField.Text
        }
        
        return data
    }
    
    ClearFields() {
        this.dreamNumberField.Text := ""
        this.wakeTimeField.Text := ""
        this.onsetTimeField.Text := ""
        this.ocrTextArea.Text := ""
        this.dreamTextArea.Text := ""
        
        this.soberRadio.Value := 1
        this.ethanolRadio.Value := 0
        this.otherRadio.Value := 0
        this.otherField.Text := ""
        this.otherField.Enabled := false
        
        for field in this.symbolFields {
            field.Text := ""
        }
        
        this.mentalLockList.Delete()
        this.mentalLockInput.Text := ""
        this.mentalLockCounter := 1
        this.removeBtn.Enabled := false
        
        this.evaluationCheck.Value := 0
        this.evaluationField.Text := ""
        this.evaluationField.Enabled := false
        
        this.dreamId := ""
        this.originalData := {}
    }
    
    ParseJSON(jsonStr) {
        obj := {}
        
        try {
            jsonStr := Trim(jsonStr)
            if (SubStr(jsonStr, 1, 1) == "{") {
                jsonStr := SubStr(jsonStr, 2)
            }
            if (SubStr(jsonStr, -1) == "}") {
                jsonStr := SubStr(jsonStr, 1, -1)
            }
            
            if (Trim(jsonStr) == "") {
                return obj
            }
            
            pairs := []
            current := ""
            inQuotes := false
            escapeNext := false
            braceLevel := 0
            
            loop parse, jsonStr {
                char := A_LoopField
                
                if (escapeNext) {
                    current .= char
                    escapeNext := false
                    continue
                }
                
                if (char == '\') {
                    escapeNext := true
                    current .= char
                    continue
                }
                
                if (char == '"' && !escapeNext) {
                    inQuotes := !inQuotes
                    current .= char
                    continue
                }
                
                if (!inQuotes) {
                    if (char == '{') {
                        braceLevel++
                    } else if (char == '}') {
                        braceLevel--
                    }
                }
                
                if (char == ',' && !inQuotes && braceLevel == 0) {
                    if (Trim(current) != "") {
                        pairs.Push(Trim(current))
                    }
                    current := ""
                } else {
                    current .= char
                }
            }
            
            if (Trim(current) != "") {
                pairs.Push(Trim(current))
            }
            
            for pair in pairs {
                pair := Trim(pair)
                if (pair == "") {
                    continue
                }
                
                colonPos := 0
                inQuotes := false
                escapeNext := false
                braceLevel := 0
                
                loop parse, pair {
                    char := A_LoopField
                    
                    if (escapeNext) {
                        escapeNext := false
                        continue
                    }
                    
                    if (char == '\') {
                        escapeNext := true
                        continue
                    }
                    
                    if (char == '"' && !escapeNext) {
                        inQuotes := !inQuotes
                        continue
                    }
                    
                    if (!inQuotes) {
                        if (char == '{') {
                            braceLevel++
                        } else if (char == '}') {
                            braceLevel--
                        }
                    }
                    
                    if (char == ':' && !inQuotes && braceLevel == 0) {
                        colonPos := A_Index
                        break
                    }
                }
                
                if (colonPos == 0) {
                    continue
                }
                
                key := Trim(SubStr(pair, 1, colonPos - 1))
                value := Trim(SubStr(pair, colonPos + 1))
                
                if (SubStr(key, 1, 1) == '"' && SubStr(key, -1) == '"') {
                    key := SubStr(key, 2, -1)
                }
                
                if (SubStr(value, 1, 1) == '"' && SubStr(value, -1) == '"') {
                    value := SubStr(value, 2, -1)
                }
                
                value := StrReplace(value, '\"', '"')
                value := StrReplace(value, '\\', '\')
                value := StrReplace(value, '\n', "`n")
                value := StrReplace(value, '\r', "`r")
                value := StrReplace(value, '\t', "`t")
                
                if (key != "") {
                    obj.%key% := value
                }
            }
        } catch Error as parseErr {
        }
        
        return obj
    }
    
    ObjectToJSON(obj) {
        jsonStr := "{"
        first := true
        
        for key, value in obj.OwnProps() {
            if (!first) {
                jsonStr .= ","
            }
            first := false
            
            valueStr := String(value)
            valueStr := StrReplace(valueStr, '\', '\\')
            valueStr := StrReplace(valueStr, '"', '\"')
            valueStr := StrReplace(valueStr, "`n", '\n')
            valueStr := StrReplace(valueStr, "`r", '\r')
            valueStr := StrReplace(valueStr, "`t", '\t')
            
            jsonStr .= '"' . key . '":"' . valueStr . '"'
        }
        
        jsonStr .= "}"
        return jsonStr
    }
    
    ArrayToString(arr) {
        if (arr.Length == 0) {
            return ""
        }
        
        result := ""
        for i, item in arr {
            if (i > 1) {
                result .= ","
            }
            result .= String(item)
        }
        return result
    }
    
    StringToArray(str) {
        arr := []
        if (str == "") {
            return arr
        }
        
        parts := StrSplit(str, ",")
        for part in parts {
            trimmed := Trim(part)
            if (trimmed != "") {
                arr.Push(trimmed)
            }
        }
        return arr
    }



    ConfirmClose() {
        if (HasProp(this, "keydownHandler")) {
            OnMessage(0x0100, this.keydownHandler, 0)
        }
        this.mainGui.Destroy()
        this.isDestroyed := true
    }
    OpenEncoder() {
        this.ocrTextArea.Focus()
        ControlSend("{Ctrl down}a{Ctrl up}", this.ocrTextArea)
        UnifiedDreamEncoder.OpenGUI()
    }
    OpenSomniumPeople() {
        this.dreamTextArea.Focus()
        global SIPManager
        SIPManager.ShowApp()
    }
    
    OpenSomniumHex() {
        this.dreamTextArea.Focus()  
        global ColorPicker
        if (!ColorPicker) {
            ColorPicker := ColorPickerClass()
        }
        ColorPicker.Show()
    }
}

global DreamMsasanager := DreamManager()
