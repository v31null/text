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
:*?: !::  
{
    SendInput("{U+00A0}{U+0021}")
    return
}
:*?: ?::  
{
    SendInput("{U+00A0}?")
    return
}

:*?: / ::  
{
    SendInput("{U+00A0}/{U+00A0}")
    return
}
:*?: - ::  
{
    SendInput("{U+00A0}—{U+00A0}")
    return
}
:*?: -- ::  
{
    SendInput("{U+00A0}{U+2E3A}{U+00A0}")
    return
}
:*?: --- ::  
{
    SendInput("{U+00A0}{U+2E3B}{U+00A0}")
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
::summonme::I prithee , You shan't hesitate to summon Me at Thine Earlieﬆ convenience.
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
::illbeback::I shall return sꝏn , do — please — remain here a moment.
::idk::Mine heart confeßes that I , surely , am at a loſs.
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
    return
}

:*?:1 ::
{
    SendInput("1{U+00A0}")
    return
}

:*?:2 ::
{
    SendInput("2{U+00A0}")
    return
}

:*?:3 ::
{
    SendInput("3{U+00A0}")
    return
}

:*?:4 ::
{
    SendInput("4{U+00A0}")
    return
}

:*?:5 ::
{
    SendInput("5{U+00A0}")
    return
}

:*?:6 ::
{
    SendInput("6{U+00A0}")
    return
}

:*?:7 ::
{
    SendInput("7{U+00A0}")
    return
}

:*?:8 ::
{
    SendInput("8{U+00A0}")
    return
}

:*?:9 ::
{
    SendInput("9{U+00A0}")
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
    suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
    
    for key, symbol in arrowOptions {
        currentOptions.Push({key: key, symbol: symbol, type: "arrow"})
        prefix := (currentOptions.Length == selectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
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
    
    suggestions := menuTitle . "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , & „ → „ for ſub-menus.`n"
    
    for key, symbol in menuOptions {
        currentOptions.Push({key: key, symbol: symbol, type: "arrow"})
        prefix := (currentOptions.Length == selectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
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
    suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select.`n"
    
    for key, symbol in logicOptions {
        logicCurrentOptions.Push({key: key, symbol: symbol, type: "logic"})
        prefix := (logicCurrentOptions.Length == logicSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
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
    return
}
:C*?: terticolon::
{
    Send "{U+00A0}{U+F56C}"
    return
}
:C*?: quarticolon::
{
    Send "{U+00A0}{U+F56B}"
    return
}


:C*?: st::
{
    if !ism
    {
        Send "{U+0073}{U+0074}"
        return
    }
	Send " {U+FB06}"
	return
}



Loop 26 {
    letter := Chr(96 + A_Index) 
    
    if (letter = "z") {
        Hotstring(":C*?:S" . letter, "ſʒ")
    }if (letter = "t") {
        Hotstring(":C*?:S" . letter, "ﬅ")
    } else {
        Hotstring(":C*?:S" . letter, "ʃ" . letter)
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
    } else {
        Send "ß"
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
}

:C*?:AO::
{
    if !ism
    {
        Send "{U+0041}{U+004F}"
        return
    }
    Send "{U+A734}"
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
:CO?*:!?::⁉
:CO?*:?!::⁈
:O:dele::₰
:O:ioriten::〽
:O:coronis::⸎
:O:manicule::☞
:?*O:do.::
{
    Send "{U+3003}"
    return
}
:?O:'::
{
    Send "{U+2019}"
    return
}
:CO*?:’::〃
:CO*?:breakhere::⸿
:CO*?:1prime::′
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

exceptions := Map()
exceptions["s-h"] := true
exceptions["h-e"] := true
exceptions["u-s"] := true
exceptions["s-t"] := true
exceptions["s-ti"] := true
exceptions["s-e"] := true
exceptions["s-w"] := true
exceptions["n-o"] := true
exceptions["a-t"] := true
exceptions["a-e"] := true
exceptions["a-ti"] := true
exceptions["a-n"] := true
exceptions["a-m"] := true
exceptions["a-w"] := true
exceptions["e-t"] := true
exceptions["e-o"] := true
exceptions["e-w"] := true
exceptions["w-e"] := true

Loop 26 {
    outerLetter := Chr(96 + A_Index) 
    Loop 26 {
        innerLetter := Chr(96 + A_Index)  
        combination := outerLetter . "-" . innerLetter
        
        if (!exceptions.Has(combination)) {
            Hotstring(":C*?:" . combination, outerLetter . "‑" . innerLetter)
        }
    }
}
Loop 26 {
    outerLetter := Chr(96 + A_Index) 
    Loop 26 {
        innerLetter := Chr(96 + A_Index)  
        combination := outerLetter . "/" . innerLetter
        
        if (!exceptions.Has(combination)) {
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
    suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn."
    suggestions .= "`nCommon :`n"

    for key, symbol in SIMainOptions {
        siCurrentOptions.Push({key: key, symbol: symbol, type: "unit"})
        prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
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
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            for subName, subKey in meterSubcategories {
                siCurrentOptions.Push({key: subName, symbol: "", type: "subcategory", menuKey: subKey, parentMenu: "meters"})
                prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
                suggestions .= prefix . subName . "`n"
            }
            
        case "amperes":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            for subName, subKey in ampereSubcategories {
                siCurrentOptions.Push({key: subName, symbol: "", type: "subcategory", menuKey: subKey, parentMenu: "amperes"})
                prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
                suggestions .= prefix . subName . "`n"
            }
            
        case "grams":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(gramsUnits, suggestions)
            
        case "liters":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(litersUnits, suggestions)
                        
        case "temperature":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(temperatureUnits, suggestions)
            
        case "energy":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(energyUnits, suggestions)
            
        case "pressure":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(pressureUnits, suggestions)
            
        case "frequency":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
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
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(metersLinear, suggestions)
            
        case "area":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(metersArea, suggestions)
            
        case "cube":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(metersCube, suggestions)
            
        case "current":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(amperesCurrent, suggestions)
            
        case "voltage":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(amperesVoltage, suggestions)
            
        case "resistance":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(amperesResistance, suggestions)
            
        case "power":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowUnitsFromMap(amperesPower, suggestions)
    }
    
    ToolTip(suggestions, , , 1)
}

ShowUnitsFromMap(unitsMap, suggestions) {
    global
    for key, symbol in unitsMap {
        siCurrentOptions.Push({key: key, symbol: symbol, type: "unit"})
        prefix := (siCurrentOptions.Length == siSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . key . " , " . symbol . "`n"
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
mainGui := ""
controls := Map()

:O?*:\sdl::{
    OpenDreamDecoderGUI()
}

OpenDreamDecoderGUI() {
    global mainGui, controls
    
    if (mainGui && IsObject(mainGui)) {
        try {
            mainGui.Destroy()
        }
    }
    
    mainGui := Gui("+Resize +MinSize400x500", "sdl")
    mainGui.SetFont("s10", "Consolas")
    
    controls := Map()
    
    CreateDecoderGUI()
    mainGui.OnEvent("Close", (*) => mainGui.Destroy())
    mainGui.Show("w580 h525")
}

CreateDecoderGUI() {
    global mainGui, controls
    
    mainGui.Add("Text", "xm y10 w580 Center", "DREAM DE-CODING SYSTEM").SetFont("s12 Bold")
    
    mainGui.Add("Text", "xm y40", "Data :")
    controls["Input"] := mainGui.Add("Edit", "xm y60 w560 h80 VScroll")
    
    mainGui.Add("Button", "xm y150 w120 h30", "DECODE").OnEvent("Click", DecodeData)
    mainGui.Add("Button", "x+10 yp w120 h30", "Clear").OnEvent("Click", ClearAlldec)
    
    mainGui.Add("Text", "xm y190", "Re‑sult :")
    controls["Output"] := mainGui.Add("Edit", "xm y210 w560 h250 VScroll ReadOnly")
    
    mainGui.Add("Text", "xm y470", "ﬅatus :")
    controls["Status"] := mainGui.Add("Edit", "xm y490 w560 h20 ReadOnly")
}
CalculateChecksum(row1) {
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
DecodeData(*) {
    global controls
    
    inputText := controls["Input"].Text
    if (inputText == "") {
        controls["Status"].Text := "No In‑put data."
        return
    }
    
    lines := StrSplit(inputText, "`r`n")
    if (lines.Length < 2) {
        controls["Status"].Text := "Need Both rows."
        return
    }
    
    row1 := Trim(lines[1])
    row2 := Trim(lines[2])
    
    if (StrLen(row1) < 49) {
        controls["Status"].Text := "Row is 1 Tꝏ short."
        return
    }
    
    providedChecksum := SubStr(row1, 49, 1)
    calculatedChecksum := CalculateChecksum(SubStr(row1, 1, 48))
    
    if (providedChecksum != calculatedChecksum) {
        controls["Status"].Text := "Warning : Check‑sum Mis‑match."
    } else {
        controls["Status"].Text := "OK"
    }
    
    decoded := DecodeRow1(SubStr(row1, 1, 48)) . "`r`n`r`n" . DecodeRow2(row2)
    
    controls["Output"].Text := decoded
}

DecodeRow1(row1) {
    result := "===DREAM PARA-AMETERS===`r`n`r`n"
    
    mValue := SubStr(row1, 3, 1)
    result .= "Dream was "
    if (mValue == "1") {
        result .= "with memories of Real-world"
    } else if (mValue == "2") {
        result .= "without memories of Real‑world"
    } else {
        result .= "without Meta‑cognitive capabilities"
    }
    
    cValue := SubStr(row1, 8, 1)
    result .= " and had In‑dream‑cognitive capabilities "
    if (cValue == "C") {
        result .= "present , moreover ; "
    } else {
        result .= "not present , moreover ; "
    }
	
    enValue := SubStr(row1, 9, 1)
    result .= "Dream control was "
    if (enValue == "E") {
        result .= "existent and "
    } else if (enValue == "N") {
        result .= "Non-existent and "
    } else {
        result .= "不明 and "
    }
    
    sValue := SubStr(row1, 12, 1)
    result .= "Dream ﬆability was "
    if (sValue == "1") {
        result .= "ﬆable.`r`n"
    } else if (sValue == "2") {
        result .= "Non‑ﬆable.`r`n"
    } else {
        result .= "不明.`r`n"
    }
    
    noteSection := SubStr(row1, 14, 28)
    noteSection := RegExReplace(noteSection, ">", " ")
    noteSection := Trim(noteSection)
    result .= "Note : "
    if (noteSection != "") {
        result .= noteSection . ".`r`n"
    } else {
        result .= "na.`r`n"
    }
    
    lucidityValue := SubStr(row1, 43, 1)
    result .= "Lucidity type"
    if (lucidityValue == "F") {
        result .= " was false and "
    } else if (lucidityValue == "T") {
        result .= " was truͤ and "
    } else if (lucidityValue == "U") {
        result .= " was 不明 and "
    } else if (lucidityValue == "X") {
        result .= "isn’t applicable and "
    } else {
        result .= " isn’t present and "
    }
    
    borderValue := SubStr(row1, 45, 1)
    result .= "Dream"
    if (borderValue == "B") {
        result .= " achieved Border-line lucidity.`r`n"
    } else if (borderValue == "N") {
        result .= " is not a Lucid dream.`r`n"
    } else {
        result .= " is a Normal Lucid‑dream.`r`n"
    }
    
    return result
}

DecodeRow2(row2) {
    result := "===REALITY TESTS===`r`n`r`n"
    
    if (row2 == "" || RegExReplace(row2, ">", "") == "") {
        result .= "No Reality teﬆs.`r`n"
        return result
    }
    
    cleanRow2 := RegExReplace(row2, ">+$", "")
    
    testCount := 0
    i := 1
    while (i <= StrLen(cleanRow2)) {
        if (i + 2 <= StrLen(cleanRow2)) {
            testNum := SubStr(cleanRow2, i, 1)
            rChar := SubStr(cleanRow2, i + 1, 1)
            testType := SubStr(cleanRow2, i + 2, 1)
            
            if (rChar == "R" && IsDigit(testNum)) {
                testCount++
                result .= testCount . ". "
                
                if (testType == "b") {
                    result .= "Breath check.`r`n"
                } else if (testType == "h") {
                    result .= "Hand check.`r`n"
                } else if (testType == "n") {
                    result .= "Nꜷght check.`r`n"
                } else if (testType == "m") {
                    result .= "Mirror check.`r`n"
                } else {
                    result .= "Un‑known Teﬆ type : " . testType . "`r`n"
                }
                
                i += 3
            } else {
                i++
            }
        } else {
            i++
        }
    }
    
    if (testCount == 0) {
        result .= "No Reality teﬆs were found.`r`n"
    }
    
    return result
}


IsDigit(char) {
    return (char >= "0" && char <= "9")
}

ClearAlldec(*) {
    global controls
    
    controls["Input"].Text := ""
    controls["Output"].Text := ""
    controls["Status"].Text := ""
}

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
        filtered := RegExReplace(text, "[^1-9]", "")
        
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
                Send(" ")
                Send(row1)
            }
            if (row2 != "") {
                Sleep(100)
                Send("+{Enter}")
                Send(" ")
                Send(row2)
            }
            
            this.mainGui.Destroy()
        }
    }
}

UnifiedDreamEncoder.Init()
class x7f9a2 {
    __New() {
        this.b4e8c := Gui("+Resize", "D.O.A.R. - Dead on Arrival Report")
        this.b4e8c.OnEvent("Close", (*) => this.m9d3f())
        this.b4e8c.Move(, , 1723, 617)
        this.k8h2n()
        this.v3x1p()
        this.t5m4j := this.b4e8c.Add("Tab3", "x10 y10 w1703 h597", ["INPUT", "PRINT FORM"])
        this.t5m4j.OnEvent("Change", this.r2q8v.Bind(this))
        this.t5m4j.UseTab(1)
        this.w6y7u()
        this.t5m4j.UseTab(2)
        this.z1n5e()
        this.l4s9k()
        Hotstring(":O?*:\prdoar", (*) => this.q8p2m())
    }
    m9d3f() {
        c3l7x := MsgBox("Are you sure you want to close the DOAR form?`nAny unsaved data will be lost.", "Confirm Close", "4")
        if (c3l7x == "Yes") {
            this.b4e8c.Destroy()
            this.h7n8r := true
        }
    }
    k8h2n() {
        this.f2d9w := [
            "",
            "D.1.01 - Memory Consolidation failure during transition to C1",
            "D.1.02 - External Stimuli interference during somnium", 
            "D.1.03 - Rapid Unplanned awakening",
            "D.1.04 - Absence of Immediate recording method",
            "D.1.05 - REM Intrusion phenomena",
            "D.1.06 - Lucid dream technique failure",
            "D.1.07 - Hypnopompic recording failure",
            "D.1.98 - Other",
            "D.1.99 - Unknown",
            "D.2.01 - Substance interference",
            "D.2.02 - Pre-sleep meal timing",
            "D.2.03 - Hydration extremes", 
            "D.2.04 - Sleep position complications",
            "D.2.05 - Pre-sleep screen exposure",
            "D.2.06 - Exercise timing disruption",
            "D.2.07 - Partner sleep disturbances",
            "D.2.08 - Performance anxiety",
            "D.2.09 - Temperature discomfort",
            "D.2.10 - Environmental noise",
            "D.2.11 - Environmental light",
            "D.2.12 - Bladder pressure",
            "D.2.13 - Stress/worry state",
            "D.2.98 - Other",
            "D.2.99 - Unknown",
            "D.3.01 - Chronic sleep debt",
            "D.3.02 - Irregular sleep schedule",
            "D.3.03 - Medication use",
            "D.3.04 - Sleep practice inexperience",
            "D.3.05 - Environmental conditioning",
            "D.3.06 - Sleep disorder symptoms",
            "D.3.98 - Other",
            "D.3.99 - Unknown",
            "D.4.01 - Work schedule stress",
            "D.4.02 - Living situation impacts",
            "D.4.03 - Information overload",
            "D.4.98 - Other",
            "D.4.99 - Unknown"
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
        this.h7b8d := this.b4e8c.Add("Checkbox", "x170 y270 w120 h20", "Almoﬆ Re‑membered")
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
        this.t3s8w := this.b4e8c.Add("Radio", "x890 y295 w250 h20", "Without Reasons ( inv. req. )")
        this.t3s8w.OnEvent("Click", (*) => this.e7m9f())
        this.x1v7c := this.b4e8c.Add("GroupBox", "x880 y350 w813 h140 Disabled", "G - INVESTIGATION BASIC")
        this.f9g2j := this.b4e8c.Add("Checkbox", "x890 y370 w200 h20 Disabled", "1. Was It inveﬆigated ?")
        this.h4k6m := this.b4e8c.Add("Checkbox", "x890 y405 w250 h20 Disabled", "2. Is an Inveﬆigation req. ?")
        this.h4k6m.OnEvent("Click", (*) => this.z8p1q())
        this.l7n3d := this.b4e8c.Add("Checkbox", "x890 y430 w200 h20 Disabled", "3. ʃcene integrity ?")
        this.y5t9e := this.b4e8c.Add("Checkbox", "x890 y455 w200 h20 Disabled", "4. Witneß ꜹailable ?")
        o8i2v := this.b4e8c.Add("GroupBox", "x20 y500 w1683 h80", "E - REASONS FOR DEATH")
        this.b4e8c.Add("Text", "x30 y520 w80 h20", "Primary Cause:")
        this.w6u4g := this.b4e8c.Add("DropDownList", "x115 y520 w200 h120", this.f2d9w)
        this.w6u4g.OnEvent("Change", (*) => this.c2x5l("primary"))
        this.b4e8c.Add("Text", "x30 y545 w80 h20", "ʃecondary to :")
        this.d1m8s := this.b4e8c.Add("DropDownList", "x115 y545 w200 h120 Disabled", this.f2d9w)
        this.d1m8s.OnEvent("Change", (*) => this.c2x5l("secondary"))
        this.b4e8c.Add("Text", "x330 y520 w70 h20", "Tertiary to :")
        this.r7q3f := this.b4e8c.Add("DropDownList", "x405 y520 w200 h120 Disabled", this.f2d9w)
        this.r7q3f.OnEvent("Change", (*) => this.c2x5l("tertiary"))
        this.b4e8c.Add("Text", "x330 y545 w80 h20", "Quaternary to :")
        this.j9k2h := this.b4e8c.Add("DropDownList", "x415 y545 w200 h120 Disabled", this.f2d9w)
        this.j9k2h.OnEvent("Change", (*) => this.c2x5l("quaternary"))
        this.b4e8c.Add("Text", "x630 y520 w100 h20", "Primary time :")
        this.i3w7b := this.b4e8c.Add("Edit", "x730 y520 w50 h20 Number Center")
        this.b4e8c.Add("Text", "x785 y520 w10 h20 Center", "/")
        this.v4n1t := this.b4e8c.Add("Edit", "x800 y520 w50 h20 Center")
        this.b4e8c.Add("Text", "x630 y545 w100 h20", "ʃecondary time :")
        this.s8l6z := this.b4e8c.Add("Edit", "x730 y545 w50 h20 Number Center Disabled")
        this.b4e8c.Add("Text", "x785 y545 w10 h20 Center", "/")
        this.a5p9x := this.b4e8c.Add("Edit", "x800 y545 w50 h20 Center Disabled")
        this.b4e8c.Add("Text", "x870 y520 w80 h20", "Tertiary time :")
        this.m2j4r := this.b4e8c.Add("Edit", "x955 y520 w50 h20 Number Center Disabled")
        this.b4e8c.Add("Text", "x1010 y520 w10 h20 Center", "/")
        this.g8c3e := this.b4e8c.Add("Edit", "x1025 y520 w50 h20 Center Disabled")
        this.b4e8c.Add("Text", "x870 y545 w90 h20", "Quaternary time :")
        this.f7v5k := this.b4e8c.Add("Edit", "x965 y545 w50 h20 Number Center Disabled")
        this.b4e8c.Add("Text", "x1020 y545 w10 h20 Center", "/")
        this.b1h9u := this.b4e8c.Add("Edit", "x1035 y545 w50 h20 Center Disabled")
        this.q6d2y := this.b4e8c.Add("Edit", "x1100 y520 w200 h20 Hidden")
        this.w9x1p := this.b4e8c.Add("Edit", "x1100 y545 w200 h20 Hidden")
        this.l3f8n := this.b4e8c.Add("Edit", "x1320 y520 w200 h20 Hidden")
        this.t4s7m := this.b4e8c.Add("Edit", "x1320 y545 w200 h20 Hidden")
        this.z5g4j := this.b4e8c.Add("Text", "x1100 y500 w200 h20 Hidden", "Primary Other details :")
        this.c8k1w := this.b4e8c.Add("Text", "x1100 y525 w200 h20 Hidden", "ʃecondary Other details :")
        this.h6v9r := this.b4e8c.Add("Text", "x1320 y500 w200 h20 Hidden", "Tertiary Other details :")
        this.o2l3q := this.b4e8c.Add("Text", "x1320 y525 w200 h20 Hidden", "Quaternary Other details :")
        this.u7n4s := this.b4e8c.Add("GroupBox", "x20 y590 w1683 h340 Hidden", "Z - INVESTIGATION EXTENDED ( Fill when G 2 is y )")
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
            html := '<style>#ga tr,td,table{padding:0;margin:0;}table{width:100%;border-collapse:collapse;}</style>'
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
            html .= '<tr><td style="width:50%;">Fruﬆration : ' . data.frustration_level . '</td><td style="width:50%;">Almoﬆ Re‑membered ? ' . data.almost_had_it . '</td></tr>'
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
            html .= '<tr><td style="width:50%;">With reasons ' . data.with_reasons . '</td><td style="width:50%;">With reasons ( inveﬆigation req. ) ' . data.with_reasons_invest . ' - G</td></tr>'
            html .= '<tr><td style="width:50%;">Without reasons ' . data.without_reasons . '</td><td style="width:50%;">Without reasons ( inveﬆigation req. ) ' . data.without_reasons_invest . ' - G</td></tr>'
            html .= '</table>'
            
            html .= '<table style="border:1px solid black;position:absolute;top:50%;height:50%;width:100%;"><tr><td colspan="2" style="font-weight:bolder;">G - Investigation</td></tr>'
            html .= '<tr><td style="width:100%;">1. Was It inveﬆigated ? ' . data.was_investigated . '</td></tr>'
            html .= '<tr><td style="width:100%;">2. Is an inveﬆigation required ? ' . data.investigation_required . '</td></tr>'
            html .= '<tr><td style="width:100%;">3. ʃcene integrity ? ' . data.scene_integrity . '</td></tr>'
            html .= '<tr><td style="width:100%;">4. Witneß ꜹailable ? ' . data.witness_available . '</td></tr>'
            html .= '</table>'
            
            html .= '</td></tr>'
            
            html .= '<tr><td colspan="2"><table style="border:1px solid black;"><tr><td colspan="2" style="font-weight:bolder;">E - Reason( s ) for death</td></tr>'
            html .= '<tr><td style="width:50%;"><table><tr><td>' . data.primary_cause . (data.primary_other ? " ( " . data.primary_other . " )" : "") . '</td></tr><tr><td>⮴ secondary to ' . data.secondary_to . (data.secondary_other ? " ( " . data.secondary_other . " )" : "") . '</td></tr><tr><td>⮴ tertiary to ' . data.tertiary_to . (data.tertiary_other ? " ( " . data.tertiary_other . " )" : "") . '</td></tr><tr><td>⮴ quaternary to ' . data.quaternary_to . (data.quaternary_other ? " ( " . data.quaternary_other . " )" : "") . '</td></tr></table></td>'
            html .= '<td><table style="width:100%;"><tr><td><table style="width:100%;"><tr style="text-align:center;"><td>' . data.primary_time . '</td></tr><tr style="text-align:center;"><td>' . data.secondary_time . '</td></tr><tr style="text-align:center;"><td>' . data.tertiary_time . '</td></tr><tr style="text-align:center;"><td>' . data.quaternary_time . '</td></tr></table></td></tr></table></td></tr>'
            html .= '</table></td></tr>'
            
            if (data.investigation_required == "y") {
                html .= '<tr><table style="border:1px solid black;">'
                
                html .= '<tr>'
                html .= '<td colspan="1" style="font-weight:bolder;">Z - Inv. ext. ( when G 2 y )</td>'
                html .= '<td style="width: 25%;">Im. analysis :' . (data.investigation_flag == "y" ? "☑" : "☐") . '</td>'
                html .= '<td style="width: 25%;">Pr. level : ' . data.priority_level . '</td>'
                html .= '<td style="width: 25%;">Monitoring ' . (data.monitoring_required == "y" ? "☑" : "☐") . '</td>'
                html .= '</tr>'
                
                html .= '<tr>'
                html .= '<td style="vertical-align:top;width:25%">ʃcene documentation :<br>Immediate : ' . data.immediate_scene_notes . '<br>Environmental : ' . data.environmental_changes . '<br>Equipment : ' . data.equipment_status . '<br>Evidence : ' . data.physical_evidence . '</td>'
                html .= '<td style="vertical-align:top;width:25%">Time‑line Re-conﬆruction :<br>Pre-failure : ' . data.pre_failure_sequence . '<br>Failure moment : ' . data.failure_moment . '<br>Post-failure : ' . data.post_failure_actions . '<br>Time‑line : ' . data.estimated_timeline . '</td>'
                html .= '<td style="width:25%;vertical-align:top;">Witneſs information :<br><table><tr><td>reliability : ' . data.witness_reliability . '</td><td>relationship : ' . data.witness_relationship . '</td></tr><tr><td colspan="2">ﬆatement : ' . data.witness_statement . (data.witness_timeline ? " , " . data.witness_timeline . " ago" : "") . '</td></tr></table></td>'
                html .= '<td style="width:25%;vertical-align:top;">Pattern analysis :<br>Match : ' . data.pattern_match . '<br>Re-ocurring : ' . data.recurring_elements . '<br>Anomaly : ' . data.anomaly_detection . '<br>Co‑relation : ' . data.case_correlation . '</td>'
                html .= '</tr>'
                
                html .= '<tr><table style="border:1px solid black;">'
                html .= '<tr><td style="width: 25%;">Photo : ' . (data.photo_documentation == "y" ? "☑" : "☐") . '</td><td style="width: 25%;">Audio : ' . (data.audio_evidence == "y" ? "☑" : "☐") . '</td><td colspan="2">Markers : ' . data.evidence_markers . '</td></tr>'
                html .= '<tr><td style="width: 25%;">Immediate ' . (data.immediate_actions ? "☑" : "☐") . '</td><td style="width: 25%;">Prevention ' . (data.prevention_measures ? "☑" : "☐") . '</td><td style="width: 50%;">Actions : ' . data.immediate_actions . " | Tasks : " . data.investigation_tasks . " | " . data.prevention_measures . '</td></tr>'
                html .= '</table></tr>'
                
                html .= '</table></tr>'
            }            
            html .= '</table>'
            
            html .= '<table style="width:100%;"><tr><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;"></td><td style="text-align:center;width:25%;">/s/ ʃunt Vĳelie</td></tr></table>'
            
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



