#Requires AutoHotkey v2.0

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
    SendInput("0{U+2007}")
    return
}

:*?:1 ::
{
    SendInput("1{U+2007}")
    return
}

:*?:2 ::
{
    SendInput("2{U+2007}")
    return
}

:*?:3 ::
{
    SendInput("3{U+2007}")
    return
}

:*?:4 ::
{
    SendInput("4{U+2007}")
    return
}

:*?:5 ::
{
    SendInput("5{U+2007}")
    return
}

:*?:6 ::
{
    SendInput("6{U+2007}")
    return
}

:*?:7 ::
{
    SendInput("7{U+2007}")
    return
}

:*?:8 ::
{
    SendInput("8{U+2007}")
    return
}

:*?:9 ::
{
    SendInput("9{U+2007}")
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
    "leß", "<",
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
        Hotstring(":C*?:S" . letter, "ſ" . letter)
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
:C*?: h::
{
    rand := Random(0,9)
    
    if (rand != 0) {
        Send " h"
    } else {
        Send " ‘"
    }
}
:C*?: H::
{
    rand := Random(0,9)
    
    if (rand != 0) {
        Send " H"
    } else {
        Send " ‘"
    }
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
:O*?:bigprd::⎩   
:O*?:bigpe::⎪   
:O*?:bigpru::⎫
:O*?:bigprm::⎬
:O*?:bigprd::⎭
:O?:a/s::℁
:O?:a/c::℀
:O?:c/u::℆
:O?:c/o::℅
:CO?*:X|::╳
:CO?*:!?::⁉
:CO?*:?!::⁈
:O:dele::₰
:O:ioriten::〽
:O:coronis::⸎
:O:righthand::☞
:?O:''::
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
exceptionsa := Map()
Loop 10 {
    outerNumber := Chr(48 + A_Index)
    Loop 10 {
        innerNumber := Chr(48 + A_Index)
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
