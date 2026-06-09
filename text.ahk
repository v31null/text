#Requires AutoHotkey v2.0
#SingleInstance force



global autocompleteActive := false
global logicAutocompleteActive := false
global siAutocompleteActive := false
global QuoteLevel := 1
global QuoteMax   := 4
global ism := true 

global pitch := 660
global dot := 60       
global dash := 180      
global settingsFile := "C:\Users\aretha\Documents\AutoHotkey\metar_settings.ini"
global ICAO := IniRead(settingsFile, "Settings", "ICAO", "LTBJ")
global lastMetar := ""
global lastTAF := ""
global metarDataFile := "C:\Users\aretha\Documents\AutoHotkey\METARDATA.txt"

;----------------------------------------------- METAR
global PhoneticMap := Map(
    "A", "ALPHA", "B", "BRAVO", "C", "CHARLIE", "D", "DELTA", "E", "ECHO",
    "F", "FOXTROT", "G", "GOLF", "H", "HOTEL", "I", "INDIA", "J", "JULIETT",
    "K", "KILO", "L", "LIMA", "M", "MIKE", "N", "NOVEMBER", "O", "OSCAR",
    "P", "PAPA", "Q", "QUEBEC", "R", "ROMEO", "S", "SIERRA", "T", "TANGO",
    "U", "UNIFORM", "V", "VICTOR", "W", "WHISKEY", "X", "X-RAY", "Y", "YANKEE", "Z", "ZULU"
)
global WeatherMap := Map(
    "-", "LIGHT ", "+", "HEAVY ",
    "MI", "SHALLOW ", "PR", "PARTIAL ", "BC", "PATCHES ", "DR", "LOW DRIFTING ",
    "BL", "BLOWING ", "SH", "SHOWERS ", "TS", "THUNDERstORM ", "FZ", "FREEZING ",
    "VC", "IN THE VICINITY ", "RE", "RECENT ",
    "DZ", "DRIZZLE", "RA", "RAIN", "SN", "SNOW", "SG", "SNOW GRAINS",
    "IC", "ICE CRYSTALS", "PL", "ICE PELLETS", "GR", "HAIL", "GS", "SMALL HAIL OR SNOW PELLETS",
    "UP", "UNKNOWN PRECIPITATION", "RASN", "RAIN AND SNOW", "SNRA", "SNOW AND RAIN",
    "BR", "MIST", "FG", "FOG", "FU", "SMOKE", "VA", "VOLCANIC ASH",
    "DU", "WIDESPREAD DUST", "SA", "SAND", "HZ", "HAZE", "PY", "SPRAY",
    "PO", "DUST OR SAND WHIRLS", "SQ", "SQUALLS", "FC", "FUNNEL CLOUD",
    "SS", "SANDSTORM", "DS", "DUSTORM"
)
global AirportMap := Map(
    "LTBJ", "IZMIR ADNAN MENDERES AIRPORT",
    "LTFA", "ADANA SAKIRPASA AIRPORT",
    "LTBA", "ISTANBUL ATATURK AIRPORT",
    "LTFM", "ISTANBUL AIRPORT",
    "LTFJ", "SABIHA GOKCEN AIRPORT",
    "LTAI", "ANTALYA AIRPORT",
    "LTAF", "ADANA AIRPORT",
    "LTCG", "TRABZON AIRPORT",
    "LTAC", "ANKARA ESENBOGA AIRPORT"
)

:?*:\setmetar::
{
    OpenSettingsGui()
}

OpenSettingsGui() {
    global ICAO, settingsFile, AirportMap, lastMetar, lastTAF
    
    LoadAirportsFromINI()
    
    sg := Gui("+Resize -MaximizeBox", "METAR Settings")
    sg.SetFont("s9", "Segoe UI")
    
    tabs := sg.Add("Tab3", "x5 y5 w1190 h660", ["Airport Selection", "Airport Management", "Voice && Speech", "Timing && Display", "Data Files"])
    
    tabs.UseTab(1)
    
    sg.Add("Text", "x20 y40", "Active ICAO:")
    activeEdit := sg.Add("Edit", "x120 y37 w80 Uppercase Limit4 vActiveICAO", ICAO)
    applyBtn := sg.Add("Button", "x210 y36 w80", "Apply")
    
    sg.Add("Text", "x320 y40", "Search:")
    searchEdit := sg.Add("Edit", "x370 y37 w200 vSearchField")
    searchBtn := sg.Add("Button", "x580 y36 w60", "Filter")
    clearSearchBtn := sg.Add("Button", "x645 y36 w60", "Clear")
    
    sg.Add("GroupBox", "x20 y70 w1150 h580", "Registered Airports")
    
    airportLV := sg.Add("ListView", "x30 y90 w1130 h545 vAirportList Grid", ["ICAO", "Name", "Pronunciation"])
    airportLV.ModifyCol(1, 80)
    airportLV.ModifyCol(2, 400)
    airportLV.ModifyCol(3, 630)
    
    PopulateAirportList(airportLV, "")
    
    applyBtn.OnEvent("Click", (*) => ApplyActiveAirport(sg, activeEdit))
    searchBtn.OnEvent("Click", (*) => PopulateAirportList(airportLV, searchEdit.Value))
    clearSearchBtn.OnEvent("Click", (*) => (searchEdit.Value := "", PopulateAirportList(airportLV, "")))
    airportLV.OnEvent("DoubleClick", (*) => SelectAirportFromList(sg, airportLV, activeEdit))
    
    tabs.UseTab(2)
    
    sg.Add("GroupBox", "x20 y40 w560 h300", "Add New Airport")
    
    sg.Add("Text", "x40 y70", "ICAO Code:")
    newICAOEdit := sg.Add("Edit", "x160 y67 w100 Uppercase Limit4 vNewICAO")
    
    sg.Add("Text", "x40 y100", "Airport Name:")
    newNameEdit := sg.Add("Edit", "x160 y97 w400 vNewName")
    
    sg.Add("Text", "x40 y130", "Pronunciation:")
    newPronEdit := sg.Add("Edit", "x160 y127 w400 vNewPronunciation")
    
    sg.Add("Text", "x40 y165 w520", "Pronunciation is how the TTS will read the name. Leave blank to use the airport name as-is.")
    
    addBtn := sg.Add("Button", "x160 y200 w120 h30", "Add Airport")
    
    sg.Add("GroupBox", "x20 y350 w560 h310", "Edit Selected Airport")
    
    sg.Add("Text", "x40 y380", "ICAO Code:")
    editICAODisplay := sg.Add("Edit", "x160 y377 w100 ReadOnly vEditICAO")
    
    sg.Add("Text", "x40 y410", "Airport Name:")
    editNameEdit := sg.Add("Edit", "x160 y407 w400 vEditName")
    
    sg.Add("Text", "x40 y440", "Pronunciation:")
    editPronEdit := sg.Add("Edit", "x160 y437 w400 vEditPronunciation")
    
    loadSelBtn := sg.Add("Button", "x40 y480 w140 h30", "Load Selected")
    saveEditBtn := sg.Add("Button", "x190 y480 w140 h30", "Save Changes")
    deleteBtn := sg.Add("Button", "x340 y480 w140 h30", "Delete Airport")
    
    sg.Add("GroupBox", "x600 y40 w570 h620", "Airport List")
    manageLV := sg.Add("ListView", "x610 y60 w550 h585 vManageList Grid", ["ICAO", "Name", "Pronunciation"])
    manageLV.ModifyCol(1, 70)
    manageLV.ModifyCol(2, 230)
    manageLV.ModifyCol(3, 230)
    
    PopulateAirportList(manageLV, "")
    
    addBtn.OnEvent("Click", (*) => AddNewAirport(sg, newICAOEdit, newNameEdit, newPronEdit, airportLV, manageLV))
    loadSelBtn.OnEvent("Click", (*) => LoadSelectedAirport(manageLV, editICAODisplay, editNameEdit, editPronEdit))
    saveEditBtn.OnEvent("Click", (*) => SaveAirportEdit(sg, editICAODisplay, editNameEdit, editPronEdit, airportLV, manageLV))
    deleteBtn.OnEvent("Click", (*) => DeleteAirport(sg, manageLV, editICAODisplay, airportLV))
    
    tabs.UseTab(3)
    
    sg.Add("GroupBox", "x20 y40 w560 h200", "TTS Voice")
    
    sg.Add("Text", "x40 y70", "Voice:")
    voiceDD := sg.Add("DropDownList", "x160 y67 w380 vVoiceSelect")
    
    try {
        tempTTS := ComObject("SAPI.SpVoice")
        voiceNames := []
        selectedIndex := 0
        savedVoice := IniRead(settingsFile, "Voice", "VoiceName", "")
        idx := 0
        for voice in tempTTS.GetVoices() {
            idx++
            desc := voice.GetDescription()
            voiceNames.Push(desc)
            if (desc = savedVoice || (savedVoice = "" && InStr(desc, "David")))
                selectedIndex := idx
        }
        voiceDD.Add(voiceNames)
        if (selectedIndex > 0)
            voiceDD.Choose(selectedIndex)
        else if (voiceNames.Length > 0)
            voiceDD.Choose(1)
        tempTTS := ""
    } catch {
    }
    
    sg.Add("Text", "x40 y110", "Volume:")
    volSlider := sg.Add("Slider", "x160 y107 w300 Range0-100 TickInterval10 vVoiceVolume", Integer(IniRead(settingsFile, "Voice", "Volume", "60")))
    volLabel := sg.Add("Text", "x470 y110 w50", IniRead(settingsFile, "Voice", "Volume", "60"))
    volSlider.OnEvent("Change", (*) => volLabel.Value := volSlider.Value)
    
    sg.Add("Text", "x40 y150", "Rate:")
    rateSlider := sg.Add("Slider", "x160 y147 w300 Range-10-10 TickInterval1 vVoiceRate", Integer(IniRead(settingsFile, "Voice", "Rate", "0")))
    rateLabel := sg.Add("Text", "x470 y150 w50", IniRead(settingsFile, "Voice", "Rate", "0"))
    rateSlider.OnEvent("Change", (*) => rateLabel.Value := rateSlider.Value)
    
    sg.Add("Text", "x40 y190", "Pause Between Sections (ms):")
    pauseEdit := sg.Add("Edit", "x250 y187 w80 Number vPauseDuration", IniRead(settingsFile, "Voice", "PauseDuration", "500"))
    
    testVoiceBtn := sg.Add("Button", "x160 y215 w150 h30", "Test Voice")
    saveVoiceBtn := sg.Add("Button", "x320 y215 w150 h30", "Save Voice Settings")
    
    sg.Add("GroupBox", "x20 y260 w560 h200", "Morse Tone")
    
    sg.Add("Text", "x40 y290", "Pitch (Hz):")
    pitchEdit := sg.Add("Edit", "x160 y287 w100 Number vMorsePitch", IniRead(settingsFile, "Morse", "Pitch", "660"))
    
    sg.Add("Text", "x40 y320", "Dot Duration (ms):")
    dotEdit := sg.Add("Edit", "x160 y317 w100 Number vMorseDot", IniRead(settingsFile, "Morse", "Dot", "60"))
    
    sg.Add("Text", "x40 y350", "Dash Duration (ms):")
    dashEdit := sg.Add("Edit", "x160 y347 w100 Number vMorseDash", IniRead(settingsFile, "Morse", "Dash", "180"))
    
    saveMorseBtn := sg.Add("Button", "x160 y390 w150 h30", "Save Morse Settings")
    
    testVoiceBtn.OnEvent("Click", (*) => TestVoiceSettings(voiceDD, volSlider, rateSlider))
    saveVoiceBtn.OnEvent("Click", (*) => SaveVoiceSettings(sg, voiceDD, volSlider, rateSlider, pauseEdit))
    saveMorseBtn.OnEvent("Click", (*) => SaveMorseSettings(sg, pitchEdit, dotEdit, dashEdit))
    
    tabs.UseTab(4)
    
    sg.Add("GroupBox", "x20 y40 w560 h150", "METAR Check Interval")
    
    sg.Add("Text", "x40 y70", "Check Every (minutes):")
    intervalEdit := sg.Add("Edit", "x220 y67 w80 Number vCheckInterval", IniRead(settingsFile, "Timing", "IntervalMinutes", "60"))
    
    sg.Add("Text", "x40 y100", "Minimum: 1 minute. Standard: 60 minutes.")
    
    saveTimingBtn := sg.Add("Button", "x220 y130 w150 h30", "Save && Apply Interval")
    
    sg.Add("GroupBox", "x20 y200 w560 h180", "Scrolling Ticker")
    
    sg.Add("Text", "x40 y230", "Scroll Speed (pixels/tick):")
    scrollSpeedEdit := sg.Add("Edit", "x220 y227 w80 Number vScrollSpeed", IniRead(settingsFile, "Display", "ScrollSpeed", "1"))
    
    sg.Add("Text", "x40 y260", "Loop Count:")
    loopCountEdit := sg.Add("Edit", "x220 y257 w80 Number vLoopCount", IniRead(settingsFile, "Display", "LoopCount", "2"))
    
    sg.Add("Text", "x40 y290", "Font Size:")
    fontSizeEdit := sg.Add("Edit", "x220 y287 w80 Number vTickerFontSize", IniRead(settingsFile, "Display", "FontSize", "10"))
    
    saveDisplayBtn := sg.Add("Button", "x220 y330 w150 h30", "Save Display Settings")
    
    sg.Add("GroupBox", "x20 y400 w560 h100", "Manual Actions")
    
    fetchNowBtn := sg.Add("Button", "x40 y430 w150 h30", "Fetch METAR Now")
    replayBtn := sg.Add("Button", "x200 y430 w150 h30", "Replay Last METAR")
    
    saveTimingBtn.OnEvent("Click", (*) => SaveTimingSettings(sg, intervalEdit))
    saveDisplayBtn.OnEvent("Click", (*) => SaveDisplaySettings(sg, scrollSpeedEdit, loopCountEdit, fontSizeEdit))
    fetchNowBtn.OnEvent("Click", (*) => (sg.Hide(), CheckMetar(), sg.Show()))
    replayBtn.OnEvent("Click", (*) => ReplayLastMetar(sg))
    
    tabs.UseTab(5)
    
    sg.Add("GroupBox", "x20 y40 w560 h120", "File Paths")
    
    sg.Add("Text", "x40 y70", "Settings File:")
    sg.Add("Edit", "x160 y67 w400 ReadOnly", settingsFile)
    
    sg.Add("Text", "x40 y100", "METAR Data File:")
    sg.Add("Edit", "x160 y97 w400 ReadOnly", metarDataFile)
    
    sg.Add("GroupBox", "x20 y170 w560 h150", "Information Letter History")
    
    clearHistoryBtn := sg.Add("Button", "x40 y200 w180 h30", "Clear Letter History")
    
    sg.Add("Text", "x40 y245", "Current METAR:")
    currentMetarDisplay := sg.Add("Edit", "x40 y265 w530 h40 ReadOnly Multi", lastMetar != "" ? lastMetar : "(none)")
    
    clearHistoryBtn.OnEvent("Click", (*) => ClearLetterHistory())
    
    sg.Add("GroupBox", "x20 y330 w560 h120", "Export / Import")
    
    exportBtn := sg.Add("Button", "x40 y360 w150 h30", "Export Airports")
    importBtn := sg.Add("Button", "x200 y360 w150 h30", "Import Airports")
    
    exportBtn.OnEvent("Click", (*) => ExportAirports())
    importBtn.OnEvent("Click", (*) => ImportAirports(airportLV, manageLV))
    
    tabs.UseTab()
    
    sg.Show("w1200 h700")
}

LoadAirportsFromINI() {
    global AirportMap, settingsFile
    
    try {
        airportSection := IniRead(settingsFile, "Airports")
        if (airportSection != "") {
            for line in StrSplit(airportSection, "`n", "`r") {
                if RegExMatch(line, "^([A-Z]{4})=(.+)$", &m) {
                    AirportMap[m[1]] := StrSplit(m[2], "|")[1]
                }
            }
        }
    } catch {
    }
}

GetAirportPronunciation(icao) {
    global settingsFile
    try {
        val := IniRead(settingsFile, "Airports", icao, "")
        if (val != "") {
            parts := StrSplit(val, "|")
            if (parts.Length >= 2 && parts[2] != "")
                return parts[2]
            return parts[1]
        }
    } catch {
    }
    global AirportMap
    if (AirportMap.Has(icao))
        return AirportMap[icao]
    return ""
}

SaveAirportToINI(icao, name, pronunciation) {
    global settingsFile, AirportMap
    
    icao := StrUpper(icao)
    val := name . "|" . pronunciation
    
    try {
        IniWrite(val, settingsFile, "Airports", icao)
    } catch as e {
        MsgBox("Could not save: " . e.Message, "Error", "Icon!")
        return false
    }
    
    AirportMap[icao] := name
    return true
}

DeleteAirportFromINI(icao) {
    global settingsFile, AirportMap
    
    try {
        IniDelete(settingsFile, "Airports", icao)
    } catch {
    }
    
    if (AirportMap.Has(icao))
        AirportMap.Delete(icao)
}
PopulateAirportList(lv, filter) {
    global AirportMap, settingsFile
    
    lv.Delete()
    
    allAirports := Map()
    
    for code, name in AirportMap {
        allAirports[code] := Map("name", name, "pron", "")
    }
    
    try {
        airportSection := IniRead(settingsFile, "Airports")
        if (airportSection != "") {
            for line in StrSplit(airportSection, "`n", "`r") {
                if RegExMatch(line, "^([A-Z]{4})=(.+)$", &m) {
                    parts := StrSplit(m[2], "|")
                    nm := parts[1]
                    pr := parts.Length >= 2 ? parts[2] : ""
                    allAirports[m[1]] := Map("name", nm, "pron", pr)
                }
            }
        }
    } catch {
    }
    
    filter := StrUpper(Trim(filter))
    
    for code, data in allAirports {
        if (filter != "") {
            if (!InStr(code, filter) && !InStr(StrUpper(data["name"]), filter))
                continue
        }
        lv.Add(, code, data["name"], data["pron"])
    }
}

ApplyActiveAirport(sg, activeEdit) {
    global ICAO, settingsFile, lastMetar, lastTAF
    
    newCode := activeEdit.Value
    if (StrLen(newCode) != 4) {
        MsgBox("Enter a 4-letter ICAO code.", "Error", "Icon!")
        return
    }
    
    ICAO := StrUpper(newCode)
    
    try {
        IniWrite(ICAO, settingsFile, "Settings", "ICAO")
    } catch as e {
        MsgBox("Could not save: " . e.Message, "Error", "Icon!")
    }
    
    lastMetar := ""
    lastTAF := ""
    
    MsgBox("Active airport set to " . ICAO, "Airport Changed")
    CheckMetar()
}

SelectAirportFromList(sg, lv, activeEdit) {
    row := lv.GetNext(0, "F")
    if (!row)
        return
    
    code := lv.GetText(row, 1)
    activeEdit.Value := code
    ApplyActiveAirport(sg, activeEdit)
}

AddNewAirport(sg, icaoEdit, nameEdit, pronEdit, airportLV, manageLV) {
    newICAO := StrUpper(Trim(icaoEdit.Value))
    newName := Trim(nameEdit.Value)
    newPron := Trim(pronEdit.Value)
    
    if (StrLen(newICAO) != 4) {
        MsgBox("ICAO code must be exactly 4 characters.", "Error", "Icon!")
        return
    }
    if (newName = "") {
        MsgBox("Airport name is required.", "Error", "Icon!")
        return
    }
    if (newPron = "")
        newPron := newName
    
    if (SaveAirportToINI(newICAO, newName, newPron)) {
        icaoEdit.Value := ""
        nameEdit.Value := ""
        pronEdit.Value := ""
        PopulateAirportList(airportLV, "")
        PopulateAirportList(manageLV, "")
        MsgBox(newICAO . " added.", "Airport Added")
    }
}

LoadSelectedAirport(lv, icaoDisp, nameEdit, pronEdit) {
    row := lv.GetNext(0, "F")
    if (!row) {
        MsgBox("Select an airport from the list.", "No Selection", "Icon!")
        return
    }
    
    code := lv.GetText(row, 1)
    name := lv.GetText(row, 2)
    pron := lv.GetText(row, 3)
    
    icaoDisp.Value := code
    nameEdit.Value := name
    pronEdit.Value := pron
}

SaveAirportEdit(sg, icaoDisp, nameEdit, pronEdit, airportLV, manageLV) {
    code := Trim(icaoDisp.Value)
    if (code = "") {
        MsgBox("No airport loaded for editing.", "Error", "Icon!")
        return
    }
    
    newName := Trim(nameEdit.Value)
    newPron := Trim(pronEdit.Value)
    
    if (newName = "") {
        MsgBox("Airport name is required.", "Error", "Icon!")
        return
    }
    if (newPron = "")
        newPron := newName
    
    if (SaveAirportToINI(code, newName, newPron)) {
        PopulateAirportList(airportLV, "")
        PopulateAirportList(manageLV, "")
        MsgBox(code . " updated.", "Airport Updated")
    }
}

DeleteAirport(sg, lv, icaoDisp, airportLV) {
    row := lv.GetNext(0, "F")
    if (!row) {
        MsgBox("Select an airport to delete.", "No Selection", "Icon!")
        return
    }
    
    code := lv.GetText(row, 1)
    
    result := MsgBox("Delete " . code . "?", "Confirm Delete", "YesNo Icon!")
    if (result != "Yes")
        return
    
    DeleteAirportFromINI(code)
    icaoDisp.Value := ""
    PopulateAirportList(airportLV, "")
    PopulateAirportList(lv, "")
    MsgBox(code . " deleted.", "Airport Deleted")
}

TestVoiceSettings(voiceDD, volSlider, rateSlider) {
    try {
        tts := ComObject("SAPI.SpVoice")
        tts.Volume := volSlider.Value
        tts.Rate := rateSlider.Value
        
        selectedVoice := voiceDD.Text
        if (selectedVoice != "") {
            for voice in tts.GetVoices() {
                if (voice.GetDescription() = selectedVoice) {
                    tts.Voice := voice
                    break
                }
            }
        }
        
        tts.Speak("IZMIR ADNAN MENDERES AIRPORT INFORMATION BRAVO. WIND THREE FIVE ZERO DEGREES AT ONE TWO KNOTS. VISIBILITY ONE ZERO KILOMETERS OR MORE. TEMPERATURE TWO FIVE. Q N H ONE ZERO ONE THREE.", 1)
    } catch as e {
        MsgBox("TTS Error: " . e.Message, "Error", "Icon!")
    }
}

SaveVoiceSettings(sg, voiceDD, volSlider, rateSlider, pauseEdit) {
    global settingsFile
    
    try {
        IniWrite(voiceDD.Text, settingsFile, "Voice", "VoiceName")
        IniWrite(volSlider.Value, settingsFile, "Voice", "Volume")
        IniWrite(rateSlider.Value, settingsFile, "Voice", "Rate")
        IniWrite(pauseEdit.Value, settingsFile, "Voice", "PauseDuration")
        MsgBox("Voice settings saved.", "Saved")
    } catch as e {
        MsgBox("Could not save: " . e.Message, "Error", "Icon!")
    }
}

SaveMorseSettings(sg, pitchEdit, dotEdit, dashEdit) {
    global settingsFile, pitch, dot, dash
    
    try {
        pitch := Integer(pitchEdit.Value)
        dot := Integer(dotEdit.Value)
        dash := Integer(dashEdit.Value)
        
        IniWrite(pitch, settingsFile, "Morse", "Pitch")
        IniWrite(dot, settingsFile, "Morse", "Dot")
        IniWrite(dash, settingsFile, "Morse", "Dash")
        MsgBox("Morse settings saved.", "Saved")
    } catch as e {
        MsgBox("Could not save: " . e.Message, "Error", "Icon!")
    }
}

SaveTimingSettings(sg, intervalEdit) {
    global settingsFile
    
    mins := Integer(intervalEdit.Value)
    if (mins < 1)
        mins := 1
    
    try {
        IniWrite(mins, settingsFile, "Timing", "IntervalMinutes")
        SetTimer(CheckMetar, mins * 60000)
        MsgBox("Check interval set to " . mins . " minutes.", "Saved")
    } catch as e {
        MsgBox("Could not save: " . e.Message, "Error", "Icon!")
    }
}

SaveDisplaySettings(sg, scrollSpeedEdit, loopCountEdit, fontSizeEdit) {
    global settingsFile
    
    try {
        IniWrite(scrollSpeedEdit.Value, settingsFile, "Display", "ScrollSpeed")
        IniWrite(loopCountEdit.Value, settingsFile, "Display", "LoopCount")
        IniWrite(fontSizeEdit.Value, settingsFile, "Display", "FontSize")
        MsgBox("Display settings saved.", "Saved")
    } catch as e {
        MsgBox("Could not save: " . e.Message, "Error", "Icon!")
    }
}

ReplayLastMetar(sg) {
    global lastMetar, lastTAF
    if (lastMetar = "") {
        MsgBox("No METAR data available. Fetch first.", "No Data", "Icon!")
        return
    }
    
    infoLetter := GetInformationLetter(lastMetar)
    tafWarning := ParseTAFForWarning(lastTAF, "display")
    ShowScrollingTicker(lastMetar, tafWarning, infoLetter)
    speechText := ParseMetarToSpeech(lastMetar, lastTAF)
    SpeakText(speechText)
}

ClearLetterHistory() {
    global metarDataFile
    
    result := MsgBox("Clear all information letter history?", "Confirm", "YesNo Icon!")
    if (result != "Yes")
        return
    
    try {
        if FileExist(metarDataFile)
            FileDelete(metarDataFile)
        FileAppend("", metarDataFile)
        MsgBox("History cleared.", "Done")
    } catch as e {
        MsgBox("Error: " . e.Message, "Error", "Icon!")
    }
}

ExportAirports() {
    global AirportMap, settingsFile
    
    exportPath := FileSelect("S", , "Export Airports", "Text Files (*.txt)")
    if (exportPath = "")
        return
    
    content := ""
    
    allAirports := Map()
    for code, name in AirportMap {
        allAirports[code] := name . "|"
    }
    
    try {
        airportSection := IniRead(settingsFile, "Airports")
        if (airportSection != "") {
            for line in StrSplit(airportSection, "`n", "`r") {
                if RegExMatch(line, "^([A-Z]{4})=(.+)$", &m) {
                    allAirports[m[1]] := m[2]
                }
            }
        }
    } catch {
    }
    
    for code, val in allAirports {
        content .= code . "=" . val . "`n"
    }
    
    try {
        if FileExist(exportPath)
            FileDelete(exportPath)
        FileAppend(content, exportPath)
        MsgBox("Exported " . allAirports.Count . " airports.", "Export Complete")
    } catch as e {
        MsgBox("Export error: " . e.Message, "Error", "Icon!")
    }
}

ImportAirports(airportLV, manageLV) {
    global settingsFile, AirportMap
    
    importPath := FileSelect(1, , "Import Airports", "Text Files (*.txt)")
    if (importPath = "")
        return
    
    try {
        content := FileRead(importPath)
        count := 0
        
        for line in StrSplit(content, "`n", "`r") {
            if RegExMatch(Trim(line), "^([A-Z]{4})=(.+)$", &m) {
                parts := StrSplit(m[2], "|")
                nm := parts[1]
                pr := parts.Length >= 2 ? parts[2] : ""
                SaveAirportToINI(m[1], nm, pr)
                count++
            }
        }
        
        PopulateAirportList(airportLV, "")
        PopulateAirportList(manageLV, "")
        MsgBox("Imported " . count . " airports.", "Import Complete")
    } catch as e {
        MsgBox("Import error: " . e.Message, "Error", "Icon!")
    }
}
ParseMetarToSpeech(metarstring, tafstring := ""){
    
    global PhoneticMap
    speech := ""
    tokens := strSplit(metarstring, " ")
    local pauseXML := " <silence msec='500'/> "
    local informationLetter := GetInformationLetter(metarstring)

    for index, token in tokens {
        if (token = "METAR" || token = "SPECI") {
            continue
        }

        if RegExMatch(token, "^(\d{4})([NSEW]{1,2})$", &m) {
            local dirMap := Map("N", "NORTH", "S", "SOUTH", "E", "EAST", "W", "WEST", "NE", "NORTH EAST", "NW", "NORTH WEST", "SE", "SOUTH EAST", "SW", "SOUTH WEST")
            speech .= "VISIBILITY " . SpellNumbers(m[1]) . " METERS TO THE " . dirMap[m[2]] . " "
            speech .= pauseXML
            continue
        }

        if (token = "BECMG") {
            speech .= "BECOMING "
            speech .= pauseXML
            continue
        }
        if (token = "TEMPO") {
            speech .= "TEMPORARILY "
            speech .= pauseXML
            continue
        }
        if (token = "SPECI") {
            speech .= "SPECIAL "
            speech .= pauseXML
            continue
        }

        if (token = "NSW") {
            speech .= "NO SIGNIFICANT WEATHER "
            speech .= pauseXML
            continue
        }

        if RegExMatch(token, "^(TL|FM|AT)(\d{4})$", &m) {
            switch m[1] {
                case "TL": speech .= "UNTIL "
                case "FM": speech .= "FROM "
                case "AT": speech .= "AT "
            }
            speech .= SpellNumbers(m[2]) . " ZULU "
            speech .= pauseXML
            continue
        }

        if (token = "WS") {
            speech .= "WIND SHEAR "
            continue
        }
        if (token = "ALL") {
            speech .= "ALL "
            continue
        }
        
        if (token = "COR") {
            speech .= "CORRECTION "
            speech .= pauseXML
            continue
        }
        if (RegExMatch(token, "^[A-Z]{4}$") && index = (tokens[1]="METAR" ? 2 : 1)) {
            
            local customPron := GetAirportPronunciation(token)
            if (customPron != "") {
                speech .= customPron . " "
            } else if (AirportMap.Has(token)) {
                speech .= AirportMap[token] . " "
            } else {
                speech .= SpellPhonetic(token) . " "
            }

            speech .= "LOCAL INFORMATION REPORT " . SpellPhonetic(informationLetter) . " "
            speech .= pauseXML
            speech .= pauseXML
            continue
        }
        if RegExMatch(token, "^(\d{6})Z$") {
            speech .= "TIME " . SpellNumbers(Substr(token, 3, 4)) . " ZULU "
            speech .= pauseXML
            continue
        }

        if Instr(token, "KT") || Instr(token, "MPS") {
            local unit := Instr(token, "KT") ? "KNOTS" : "METERS PER SECOND"
            speech .= "WIND "
            
            if (RegExMatch(token, "^00000(KT|MPS)$")) {
                speech .= "CALM "
            } else {
                local windDir := Substr(token, 1, 3)
                
                if (windDir = "VRB") {
                    speech .= "VARIABLE AT "
                } else {
                    speech .= SpellNumbers(windDir) . " DEGREES AT "
                }
                
                if RegExMatch(token, "(\d{2,3})G(\d{2,3})(KT|MPS)", &m) {
                    speech .= SpellNumbers(m[1]) . " GUstING " . SpellNumbers(m[2]) . " " . unit . " "
                } else if RegExMatch(token, "^(?:VRB|\d{3})(\d{2,3})(KT|MPS)", &m) {
                    speech .= SpellNumbers(m[1]) . " " . unit . " "
                }
            }
            speech .= pauseXML
            continue
        }
        if RegExMatch(token, "^(\d{3})V(\d{3})$", &m) {
            speech .= "WIND VARIABLE BETWEEN " . SpellNumbers(m[1]) . " AND " . SpellNumbers(m[2]) . " DEGREES "
            speech .= pauseXML
            continue
        }

        if (token = "9999") {
            speech .= "VISIBILITY TEN KILOMETERS OR MORE "
            speech .= pauseXML
            continue
        }
        if (token = "CAVOK") {
            speech .= "CEILING AND VISIBILITY OK "
            speech .= pauseXML
            continue
        }
        if (RegExMatch(token, "^\d{4}$") && index > 2) { 
            speech .= "VISIBILITY " . SpellNumbers(token) . " METERS "
            speech .= pauseXML
            continue
        }

        if RegExMatch(token, "^R(\d{2}[RLC]?)\/(P|M)?(\d{4})(N|U|D)?$", &m) {
            speech .= "RUNWAY VISUAL RANGE RUNWAY " . SpellRunway(m[1]) . " "
            if (m[2] = "P")
                speech .= "GREATER THAN "
            else if (m[2] = "M")
                speech .= "LESS THAN "
            
            speech .= SpellNumbers(m[3]) . " METERS "
            
            if (m[4] = "N")
                speech .= "NO CHANGE "
            else if (m[4] = "U")
                speech .= "TREND UPWARD "
            else if (m[4] = "D")
                speech .= "TREND DOWNWARD "
            speech .= pauseXML
            continue
        }

        local weatherSpeech := ParseWeather(token)
        if (weatherSpeech != "") {
            speech .= weatherSpeech . " "
            speech .= pauseXML
            continue
        }

        if RegExMatch(token, "^(FEW|SCT|BKN|OVC)(\d{3})", &match) {
            local cloudType := ""
            Switch match[1] {
                Case "FEW": cloudType := "FEW CLOUDS AT "
                Case "SCT": cloudType := "SCATTERED CLOUDS AT "
                Case "BKN": cloudType := "BROKEN CLOUDS AT "
                Case "OVC": cloudType := "OVERCAST AT "
            }
            speech .= cloudType . SpellNumbers(match[2]) . " HUNDRED FEET "

            if Instr(token, "CB")
                speech .= "CUMULONIMBUS "
            else if Instr(token, "TCU")
                speech .= "TOWERING CUMULUS "
            
            speech .= pauseXML
            continue
        }
        if RegExMatch(token, "^VV(\d{3})$", &m) {
            speech .= "VERTICAL VISIBILITY " . SpellNumbers(m[1]) . " HUNDRED FEET "
            speech .= pauseXML
            continue
        }
        if (token = "NSC") {
            speech .= "NO SIGNIFICANT CLOUD "
            speech .= pauseXML
            continue
        }
        if (token = "SKC" || token = "CLR" || token = "NCD") {
            speech .= "SKY CLEAR "
            speech .= pauseXML
            continue
        }

        if RegExMatch(token, "^(M?)(\d{2})\/(M?)(\d{2})$", &m) {
            speech .= "TEMPERATURE "
            speech .= (m[1] = "M" ? "MINUS " : "") . SpellNumbers(m[2]) . " "
            speech .= pauseXML
            speech .= "DEW POINT "
            speech .= (m[3] = "M" ? "MINUS " : "") . SpellNumbers(m[4]) . " "
            speech .= pauseXML
            continue
        }

        if RegExMatch(token, "^Q(\d{4})$", &m) {
            speech .= "Q N H " . SpellNumbers(m[1]) . " "
            speech .= pauseXML
            continue
        }

        if (token = "NOSIG") {
            speech .= "NO SIGNIFICANT CHANGE "
            speech .= pauseXML
            continue
        }
        if (token = "RMK") {
            speech .= "REMARK "
            speech .= pauseXML
            continue
        }
        
        if RegExMatch(token, "^RWY(\d{2}[RLC]?)$", &m) {
            speech .= "RUNWAY " . SpellRunway(m[1]) . " "
            continue
        }

        if (RegExMatch(token, "^[A-Z0-9/]+$")) {
            speech .= SpellAlphanumeric(token) . " "
        }
    }
    
    local tafWarningSpeech := ""
    if (tafstring != "") {
        tafWarningSpeech := ParseTAFForWarning(tafstring, "speech")
        speech .= tafWarningSpeech
    }

    local finalSpeech := RTrim(speech)
    
    finalSpeech .= " INFORMATION " . SpellPhonetic(informationLetter) . " IS CURRENT."

    
    return finalSpeech
}

ParseTAFForWarning(tafstring, returnFormat := "speech") {
    static callCount := 0
    callCount++
    
    
    local warningSpeech := ""
    local warningDisplay := ""
    local pauseXML := " <silence msec='500'/> "
    local significantWeather := "RA|SN|TS|BR|FG|GR|GS|PL|IC|DZ|SS|DS|FC|SQ" 

    local cleanedTAF := RegExReplace(tafstring, ".*?TAF [A-Z]{4} \d{6}Z \d{4}\/\d{4} ") 
    cleanedTAF := RegExReplace(cleanedTAF, "\\n", " ")
    cleanedTAF := RegExReplace(cleanedTAF, " {2,}", " ")
    cleanedTAF := Trim(cleanedTAF)
        
    local groupsArray := []
    local markers := ["BECMG", "PROB", "TEMPO"]
    local currentPos := 1
    
    while (currentPos <= strLen(cleanedTAF)) {
        local bestPos := strLen(cleanedTAF) + 1
        local bestMatch := ""
        
        for _, marker in markers {
            local matchstr := ""
            if (marker = "PROB") {
                if RegExMatch(cleanedTAF, "PROB\d{2}", &tempMatch, currentPos) {
                    matchstr := tempMatch[0]
                }
            } else {
                if RegExMatch(cleanedTAF, marker, &tempMatch, currentPos) {
                    matchstr := tempMatch[0]
                }
            }
            if (matchstr != "") {
                local tempPos := Instr(cleanedTAF, matchstr, , currentPos)
                if (tempPos > 0 && tempPos < bestPos) {
                    bestPos := tempPos
                    bestMatch := matchstr
                }
            }
        }
        
        if (bestMatch != "") {
            if (bestPos > currentPos) {
                local groupContent := Substr(cleanedTAF, currentPos, bestPos - currentPos)
                if (RTrim(LTrim(groupContent)) != "") {
                    groupsArray.Push(RTrim(LTrim(groupContent)))
                }
            }
            currentPos := bestPos + strLen(bestMatch)
            groupsArray.Push(bestMatch)
        } else {
            if (currentPos <= strLen(cleanedTAF)) {
                local remaining := Substr(cleanedTAF, currentPos)
                if (RTrim(LTrim(remaining)) != "") {
                    groupsArray.Push(RTrim(LTrim(remaining)))
                }
            }
            break
        }
    }
    
    local finalGroups := []
    local tempGroup := ""
    for index, token in groupsArray {
        if (RegExMatch(token, "^(BECMG|PROB\d{2}|TEMPO)$")) {
            if (tempGroup != "") {
                finalGroups.Push(tempGroup)
            }
            tempGroup := token . " "
        } else {
            tempGroup .= token . " "
        }
    }
    if (tempGroup != "") {
        finalGroups.Push(tempGroup)
    }

    for index, group in finalGroups {

        local tokens := strSplit(RTrim(LTrim(group)), " ")
        
        local groupType := ""
        local fromDay := ""
        local fromTime := ""
        local toDay := ""
        local toTime := ""
        local significantWeatherFound := ""
        local windGroup := ""
        local cloudGroup := ""

        for tokenIndex, token in tokens {
            if RegExMatch(token, "^(PROB\d{2}|TEMPO|BECMG)$", &m) {
                groupType := m[1]
                continue
            }
            
            if RegExMatch(token, "^(\d{4})\/(\d{4})$", &m) {
                fromDay := SpellNumbers(Substr(m[1], 1, 2))
                fromTime := SpellNumbers(Substr(m[1], 3, 2))
                toDay := SpellNumbers(Substr(m[2], 1, 2))
                toTime := SpellNumbers(Substr(m[2], 3, 2))
                continue
            }
            
            if RegExMatch(token, "^(\d{3}|VRB)\d{2}G?\d{2}?(KT|MPS)$") {
                windGroup := token
                continue
            }

            if (RegExMatch(token, significantWeather) || Instr(token, "BR") || Instr(token, "FG")) {
                significantWeatherFound := token 
                continue
            }
            
            if (Instr(token, "CB") || Instr(token, "TCU")) {
                cloudGroup := token 
                continue
            }
        }
        
        if (groupType != "" && (significantWeatherFound != "" || cloudGroup != "")) {
            local groupDisplay := RTrim(LTrim(group))
            
            warningDisplay .= (warningDisplay != "" ? " | " : "") . groupDisplay

            
            local groupSpeech := ""
            
            groupSpeech .= pauseXML
            
            if (groupType = "BECMG") {
                groupSpeech .= "BECOMING "
            } else if (groupType = "TEMPO") {
                groupSpeech .= "TEMPORARILY "
            } else if Instr(groupType, "PROB") {
                local prob := Substr(groupType, 5, 2)
                groupSpeech .= SpellNumbers(prob) . " PERCENT PROBABILITY "
            }
            
            groupSpeech .= pauseXML
            
            if (fromDay != "") {
                groupSpeech .= "DAY " . fromDay . " TIME " . fromTime . " "
                groupSpeech .= pauseXML
                groupSpeech .= "UNTIL DAY " . toDay . " TIME " . toTime . " "
                groupSpeech .= pauseXML
            }
            
            groupSpeech .= "EXPECT "
            
            if (windGroup != "") {
                local unit := Instr(windGroup, "KT") ? "KNOTS" : "METERS PER SECOND"
                local windDir := Substr(windGroup, 1, 3)
                
                if (windDir = "VRB") {
                    groupSpeech .= "WIND VARIABLE AT "
                } else {
                    groupSpeech .= SpellNumbers(windDir) . " DEGREES AT "
                }
                
                if RegExMatch(windGroup, "(\d{2,3})G(\d{2,3})(KT|MPS)", &m) {
                    groupSpeech .= SpellNumbers(m[1]) . " GUstING " . SpellNumbers(m[2]) . " " . unit . " "
                } else if RegExMatch(windGroup, "[A-Z]{3}(\d{2,3})(KT|MPS)", &m) {
                    groupSpeech .= SpellNumbers(m[1]) . " " . unit . " "
                }
            }

            if (significantWeatherFound != "") {
                groupSpeech .= ParseWeather(significantWeatherFound) . " "
            }

            if (cloudGroup != "") {
                if Instr(cloudGroup, "CB")
                    groupSpeech .= "CUMULONIMBUS "
                else if Instr(cloudGroup, "TCU")
                    groupSpeech .= "TOWERING CUMULUS "
            }

            warningSpeech .= groupSpeech . pauseXML
        }
    }
    
    if (returnFormat = "speech") {
        if (warningSpeech != "") {
            return "FORECAst WARNING " . pauseXML . pauseXML . warningSpeech
        }
        return ""
    } else {
        return warningDisplay
    }
}
ProcesstAFGroup(groupType, content, pauseXML) {
    local speech := ""
    local tokens := strSplit(content, " ")
    local timeSpan := ""
    local windGroup := ""
    local weatherGroup := ""
    local cloudGroup := ""
    local hasSignificantWeather := false
    
    for index, token in tokens {
        token := Trim(token)
        if (token = "") {
            continue
        }
        
        if RegExMatch(token, "^(PROB\d{2}|TEMPO|BECMG)$") {
            continue
        }
        
        if RegExMatch(token, "^(\d{4})\/(\d{4})$", &m) {
            timeSpan := "DAY " . SpellNumbers(Substr(m[1], 1, 2)) . " TIME " . SpellNumbers(Substr(m[1], 3, 2))
            timeSpan .= " UNTIL DAY " . SpellNumbers(Substr(m[2], 1, 2)) . " TIME " . SpellNumbers(Substr(m[2], 3, 2))
            continue
        }
        
        if RegExMatch(token, "^(\d{3}|VRB)\d{2}G?\d{0,2}(KT|MPS)$") {
            windGroup := token
            continue
        }
        
        if RegExMatch(token, "^-?(TS|SH|FZ|DZ|RA|SN|GR|GS|PL|IC|BR|FG|FU|VA|DU|SA|HZ|SQ|FC|SS|DS)") {
            weatherGroup := token
            hasSignificantWeather := true
            continue
        }
        
        if RegExMatch(token, "(CB|TCU)") {
            cloudGroup := token
            hasSignificantWeather := true
            continue
        }
    }
    
    if (!hasSignificantWeather) {
        return ""
    }
    
    if (groupType = "BECMG") {
        speech .= "BECOMING "
    } else if (groupType = "TEMPO") {
        speech .= "TEMPORARILY "
    } else if Instr(groupType, "PROB") {
        local prob := Substr(groupType, 5, 2)
        speech .= " " . SpellNumbers(prob) . " PERCENT PROBABILITY "
    }
    
    if (timeSpan != "") {
        speech .= timeSpan . " "
    }
    
    if (windGroup != "") {
        local unit := Instr(windGroup, "KT") ? "KNOTS" : "METERS PER SECOND"
        local windDir := Substr(windGroup, 1, 3)
        
        if (windDir = "VRB") {
            speech .= "WIND VARIABLE AT "
        } else {
            speech .= "WIND " . SpellNumbers(windDir) . " DEGREES AT "
        }
        
        if RegExMatch(windGroup, "(\d{2,3})G(\d{2,3})(KT|MPS)", &m) {
            speech .= SpellNumbers(m[1]) . " GUstING " . SpellNumbers(m[2]) . " " . unit . " "
        } else if RegExMatch(windGroup, "(\d{2,3})(KT|MPS)", &m) {
            speech .= SpellNumbers(m[1]) . " " . unit . " "
        }
    }
    
    if (weatherGroup != "") {
        speech .= ParseWeather(weatherGroup) . " "
    }
    
    if (cloudGroup != "") {
        if Instr(cloudGroup, "CB") {
            speech .= "CUMULONIMBUS "
        }
        if Instr(cloudGroup, "TCU") {
            speech .= "TOWERING CUMULUS "
        }
    }
    
    return speech . pauseXML
}
ParseWeather(token) {
    global WeatherMap
    local speech := ""
    local workToken := token
    
    local intensity := Substr(workToken, 1, 1)
    if (intensity = "+" || intensity = "-") {
        speech .= WeatherMap[intensity]
        workToken := Substr(workToken, 2)
    }
    
    while (strLen(workToken) >= 2) {
        if (strLen(workToken) >= 4) {
            local fourChar := Substr(workToken, 1, 4)
            if (WeatherMap.Has(fourChar)) {
                 speech .= WeatherMap[fourChar] . " "
                 workToken := Substr(workToken, 5)
                 continue
            }
        }
        
        local descriptor := Substr(workToken, 1, 2)
        if (WeatherMap.Has(descriptor)) {
            speech .= WeatherMap[descriptor] . " "
            workToken := Substr(workToken, 3)
        } else {
            break 
        }
    }
    
    return RTrim(speech)
}

SpellNumbers(text) {
    result := ""
    for char in strSplit(text) {
        Switch char {
            Case "0": result .= "ZERO " 
            Case "1": result .= "ONE "
            Case "2": result .= "TWO "
            Case "3": result .= "THREE "
            Case "4": result .= "FOUR "
            Case "5": result .= "FIVE "
            Case "6": result .= "SIX "
            Case "7": result .= "SEVEN "
            Case "8": result .= "EIGHT "
            Case "9": result .= "NINER "
            Default:  result .= char . " "
        }
    }
    return RTrim(result)
}

SpellPhonetic(text) {
    global PhoneticMap
    result := ""
    for char in strSplit(strUpper(text)) {
        if PhoneticMap.Has(char)
            result .= PhoneticMap[char] . " "
    }
    return RTrim(result)
}

SpellRunway(text) {
    local numPart := RegExReplace(text, "[RLC]$")
    local designator := Substr(text, strLen(numPart) + 1)
    local result := SpellNumbers(numPart) . " "
    
    Switch designator {
        Case "L": result .= "LEFT "
        Case "R": result .= "RIGHT "
        Case "C": result .= "CENTER "
    }
    return RTrim(result)
}

SpellAlphanumeric(text) {
    global PhoneticMap
    result := ""
    for char in strSplit(strUpper(text)) {
        if PhoneticMap.Has(char) {
            result .= PhoneticMap[char] . " "
        } else {
            Switch char {
                Case "0": result .= "ZEERO "
                Case "1": result .= "ONE "
                Case "2": result .= "TWO "
                Case "3": result .= "THREE "
                Case "4": result .= "FOVER "
                Case "5": result .= "FIFE "
                Case "6": result .= "SIX "
                Case "7": result .= "SEVEN "
                Case "8": result .= "EIGHT "
                Case "9": result .= "NINER "
                Case "/": result .= "SLANT "
                Case ".": result .= "DECIMAL "
                Default: result .= char . " "
            }
        }
    }
    return RTrim(result)
}

SpeakText(textToSpeak) {
    static tts := ""
    global settingsFile
    
    try {
        if (!IsObject(tts)) {
            tts := ComObject("SAPI.SpVoice")
        }
        
        tts.Volume := Integer(IniRead(settingsFile, "Voice", "Volume", "60"))
        
        try {
            tts.Rate := Integer(IniRead(settingsFile, "Voice", "Rate", "0"))
        } catch {
        }
        
        try {
            savedVoice := IniRead(settingsFile, "Voice", "VoiceName", "")
            if (savedVoice != "") {
                for voice in tts.GetVoices() {
                    if (voice.GetDescription() = savedVoice) {
                        tts.Voice := voice
                        break
                    }
                }
            } else {
                for voice in tts.GetVoices() {
                    if InStr(voice.GetDescription(), "David") {
                        tts.Voice := voice
                        break
                    }
                }
            }
        } catch {
        }
        
        local speechstring := "<speak>" . textToSpeak . "</speak>"
        tts.Speak(speechstring, 1 + 8)
    } catch as e {
        ToolTip("Error initializing TTS: " . e.Message)
        SetTimer(() => ToolTip(), -3000)
    }
}


GetInformationLetter(currentMetar := "") {
    global metarDataFile
    
    if (currentMetar = "") {
        return "A"
    }
    
    try {
        if !FileExist(metarDataFile) {
            FileAppend("", metarDataFile)
        }
        
        fileContent := FileRead(metarDataFile)
        lines := strSplit(fileContent, "`n", "`r")
        
        
        lastLetter := ""
        
        for index, line in lines {
            if (Trim(line) = "") {
                continue
            }
            
            
            try {
                entry := Jxon_Load(&line)
                
                if (entry.Has("metar") && entry.Has("letter")) {
                    if (entry["metar"] = currentMetar) {
                        return entry["letter"]
                    }
                    lastLetter := entry["letter"]
                }
            } catch as err {
            }
        }
        
        if (lastLetter = "") {
            nextLetter := "A"
        } else {
            nextCode := Ord(lastLetter) + 1
            if (nextCode > 90) {
                nextCode := 65
            }
            nextLetter := Chr(nextCode)
        }
        
        
        newEntry := Map("metar", currentMetar, "letter", nextLetter, "timestamp", A_Now)
        jsonLine := Jxon_Dump(newEntry)
        FileAppend(jsonLine . "`n", metarDataFile)
        
        return nextLetter
        
    } catch as e {
        MsgBox("Fatal error: " . e.Message)
        return "A"
    }
}
Jxon_Load(&src) {
    static q := Chr(34)
    
    result := Map()
    pos := 1
    
    while (pos := Instr(src, q, , pos)) {
        keystart := pos + 1
        keyEnd := Instr(src, q, , keystart)
        key := Substr(src, keystart, keyEnd - keystart)
        
        pos := Instr(src, q, , keyEnd + 1)
        if (!pos)
            break
            
        valuestart := pos + 1
        valueEnd := Instr(src, q, , valuestart)
        value := Substr(src, valuestart, valueEnd - valuestart)
        
        result[key] := value
        pos := valueEnd + 1
    }
    
    return result
}

Jxon_Dump(obj) {
    static q := Chr(34)
    
    if (Type(obj) = "Map") {
        str := "{"
        for k, v in obj {
            str .= q . k . q . ":" . q . v . q . ","
        }
        str := RTrim(str, ",") . "}"
        return str
    }
    
    return ""
}
CheckMetar() {
    global ICAO, lastMetar, lastTAF
    
    try {
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", "http://metartaf.ru/" . ICAO . ".json", true)
        whr.Send()
        whr.WaitForResponse()
        
        responseText := whr.ResponseText
        
        local currentMetar := ""
        local currentTAF := ""
        
        if RegExMatch(responseText, '"metar":".*?\\n(.*?)"', &metarMatch) {
            currentMetar := metarMatch[1]
        }
        
        if RegExMatch(responseText, '"taf":".*?\\n(.*?)"', &tafMatch) {
            currentTAF := tafMatch[1]
        }
        
        if (currentMetar != "" && currentMetar != lastMetar) {
            lastMetar := currentMetar
            lastTAF := currentTAF
            
            local infoLetter := GetInformationLetter(currentMetar)
            local tafWarning := ParseTAFForWarning(currentTAF, "display")

            ShowScrollingTicker(currentMetar, tafWarning, infoLetter)
            
            speechText := ParseMetarToSpeech(currentMetar, currentTAF)
            SpeakText(speechText)
        } else if (currentMetar != "" && currentMetar = lastMetar) {
            local existingLetter := GetInformationLetter(currentMetar)
        }
        
    } catch as e {
        ToolTip("Error fetching METAR: " . e.Message)
        SetTimer(() => ToolTip(), -3000)
    }
}
ShowScrollingTicker(metar, taf, infoLetter) {
    static tickerGui := ""
    static textCtrl := ""
    
    
    local icaoCode := ""
    local timeZ := ""
    
    if RegExMatch(metar, "METAR ([A-Z]{4}) (\d{6}Z)", &m) {
        icaoCode := m[1]
        timeZ := m[2]
    }
    
    local metarWithoutHeader := RegExReplace(metar, "METAR [A-Z]{4} \d{6}Z ", "")
    
    tickerText := icaoCode . " INFO " . infoLetter . " " . timeZ . " " . metarWithoutHeader . (taf != "" ? " | " . taf : "") . "          "

    if (tickerGui != "") {
        try tickerGui.Destroy()
    }
    
    tickerGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    tickerGui.BackColor := "Black"
    tickerGui.SetFont("s10 cYellow", "Consolas")
    
    textCtrl := tickerGui.Add("Text", "x0 y5 w2000 h16 BackgroundTrans cYellow", tickerText)
    
    tickerGui.Show("x0 y0 w654 h26 NoActivate")
    
    startPos := 654
    scrollSpeed := 1
    textWidth := strLen(tickerText) * 7
    loopCount := 0
    
    ScrollText() {
        static currentPos := startPos
        
        currentPos -= scrollSpeed
        
        if (currentPos < -textWidth) {
            loopCount++
            if (loopCount >= 2) {
                SetTimer(ScrollText, 0)
                try tickerGui.Destroy()
                loopCount := 0
                currentPos := startPos
                return
            }
            currentPos := startPos
        }
        
        textCtrl.Move(currentPos)
    }
    
    SetTimer(ScrollText, 13)
}
:*?:\soundmetar::
{
    global lastMetar, lastTAF
    if (lastMetar != "") {
        local infoLetter := GetInformationLetter(lastMetar)
        local tafWarning := ParseTAFForWarning(lastTAF, "display")
        
        ShowScrollingTicker(lastMetar, tafWarning, infoLetter)
        
        speechText := ParseMetarToSpeech(lastMetar, lastTAF)
        SpeakText(speechText)
    } else {
        CheckMetar()
    }
    return
}

global savedInterval := Integer(IniRead(settingsFile, "Timing", "IntervalMinutes", "60"))
SetTimer(CheckMetar, savedInterval * 60000)
CheckMetar()
;----------------------------------------------- QUOTES
mb(msg) {
    global pitch, dot, dash
    local last := ""
    for char in strSplit(msg) {
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


:C*?:rrtq:: {
    SendInput("{U+2E04}{U+00A0}{U+00A0}{U+2E05} ")
    SendInput("{Left 3}")
    NudgeCursor()
    return
}
:C*?:rrtw:: {
    global rtwActive
    SendInput("{U+2E04}{U+00A0}{U+00A0}: {U+00A0}{U+2E05} ")
    SendInput("{Left 6}")
    rtwActive := true
    NudgeCursor()
    return
}
:C*?:rtt:: {
    SendInput("{U+2E02}{U+00A0}{U+00A0}{U+2E03}")
    SendInput("{Left 2}")
    NudgeCursor()
    return
}
:C*?:rtw:: {
    global rtwActive
    SendInput("{U+2E02}{U+00A0}{U+00A0}⸫ {U+00A0}{U+2E03}")
    SendInput("{Left 5}")
    rtwActive := true
    NudgeCursor()
    return
}

;----------------------------------------------- TYPO‑GRAPHICAL 1

:*?: `:-::  
{
    SendInput("{U+00A0}{U+003A}{U+200D}{U+2014}")
    NudgeCursor()
    return
}
:?:'s::’s
:?:'m::’m
:?:'ll::’ll
:?:'ve::’ve
:?:'re::’re
:C*?:'t::‘t
:*?:'h::‘
:*?: ,::
{
    SendInput("{U+00A0},")
    NudgeCursor()
    return
}
:*?: `;::
{
    SendInput("{U+00A0}{U+003B}")
    NudgeCursor()
    return
}

:*?: `: ::  
{
    SendInput("{U+00A0}{U+003A}{U+0020}")
    NudgeCursor()
    return
}

:CO?*:!?::
{
    SendInput("⁉")
    NudgeCursor()
    return
}
:CO?*:?!::
{
    SendInput("⁈")
    NudgeCursor()
    return
}
:CO?*: & ::
{
    SendInput("{U+00A0}&{U+00A0}")
    NudgeCursor()
    return
}
:*?: !::  
{
    SendInput("{U+00A0}{U+0021}")
    NudgeCursor()
    return
}
:*?: ?::  
{
    SendInput("{U+00A0}?")
    NudgeCursor()
    return
}
:*?: / ::  
{
    SendInput("{U+00A0}／{U+00A0}")
    NudgeCursor()
    return
}
:*?: - ::  
{
    SendInput("{U+00A0}—{U+00A0}")
    NudgeCursor()
    return
}
:*?: -- ::  
{
    SendInput("{U+00A0}{U+2E3A}{U+00A0}")
    NudgeCursor()
    return
}
:*?: --- ::  
{
    SendInput("{U+00A0}{U+2E3B}{U+00A0}")
    NudgeCursor()
    return
}

:C*?:( ::{
    SendInput "{U+0028}{U+00A0}"
        NudgeCursor()
    return
}
:C*?: )::{
    SendInput "{U+00A0}{U+0029}"
        NudgeCursor()
    return
}
:C*?:[ ::{
    SendInput "{U+005B}{U+00A0}"
        NudgeCursor()
    return
}
:C*?: ]::{
    SendInput "{U+00A0}{U+005D}"
    NudgeCursor()
}

:*?:...::…
:C*?:_micro::µ
:C*?:_st::ˢᵗ
:C*?:_nd::ⁿᵈ
:C*?:_rd::ʳᵈ
:C*?:_th::ᵗʰ
:C*?:paragraph ::{
	Send "§{U+00A0}"
        NudgeCursor()
}
:C*?:paragraphs ::{
	Send "§§{U+00A0}"
        NudgeCursor()
}


;----------------------------------------------- NUMERO 
:C*?:numero ::
{
    Send "{U+2116}{U+00A0}"
        NudgeCursor()
    return
}
:C*?:numeri ::
{
    Send "№ⁱ{U+00A0}"
        NudgeCursor()
    return
}
:C*?:numeris ::
{
    Send "№ⁱˢ{U+00A0}"
        NudgeCursor()
    return
}
:C*?:numerorum ::
{
    Send "№ʳᵘᵐ{U+00A0}"
        NudgeCursor()
    return
}
:C*?:numerus ::
{
    Send "№ᵘˢ{U+00A0}"
        NudgeCursor()
    return
}
:C*?:numerum ::
{
    Send "№ᵘᵐ{U+00A0}"
        NudgeCursor()
    return
}

:C*?:trr::{
    SendInput("{U+0028}{U+00A0}{U+2026}{U+00A0}{U+0029}")
        NudgeCursor()
    return
}
:C*?:numeros ::
{
    Send "№ˢ{U+00A0}"
        NudgeCursor()
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
        Sg. / Pl.
        1. Is the № the Main subject — the one executing the action — in the sentence ?
            Quͤstion : « Who or what is increasing ? » → « The №ᵘˢ / №ⁱ is / are increasing. »

        2. Is the № an indicator of poſseßion — as in , belonging to Some-thing — in the sentence ?
            Quͤstion : « The size of what ? » → « The size of the №ⁱ / №ʳᵘᵐ. ».

        3. Is the № the Indirect recipient of an action — meaning : Some-thing is given to It — in the sentence ?
            Quͤstion : « To what did I aßign the code ? » → « To the № / №ⁱˢ 3 / 3‒13. ».

        4. Is the № the Direct object in the sentence , which is to say ; the thing that is receiving the action ?
            Quͤstion : « What did I mark ? » → « I marked the №ᵘᵐ / №ˢ 7 / 7‒10. ».

        5. Is the № the instrument or means by which Some‑thing is accomplished in the sentence ?
            Quͤstion : « By what was the letter sent ? » → « By the № / №ⁱˢ 9 / 9‒13. »

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
;----------------------------------------------- SLANG

::prte::
{
    static MyPreambleTransitions := [
        "That being noted , I find It pertinent to mention that :—",
        "Verily , Your point is Well‑taken , How‑ever ; ",
        "Against the Current trajectory of Our discourse ,",
        "Let Us stray from the path ℀ allow Me to say that :—",
        "Un-like the light of what ‘as been discuſsed ,",
        "And so We arrive at the juncture where :— ",
        "With that being said :—",
        "Let Me Right now pivot Our focus Else‑where :—",
        "I ought to mention that :—",
        "By the way :—",
        "To turn Our attention to Another affair entirely :—",
        "If I may be So bold as to change the subject in It’s entirity :—",
        "By the way :—",
    ]
    
    Send(MyPreambleTransitions[Random(1, MyPreambleTransitions.Length)] . "{U+00A0}")
    NudgeCursor()
    return
}


::itg::
{
    static MyDepartures := [
        "I am afraid I must now take My leave.",
        "Alas ;  I find I must take My leave.",
        "The Preßing matters of the ‘our demand Mine attention Else-where.",
        "I prithee , do , please , eꭗcuse Mine Imminent departure.",
        "I bid Thee⧸Ye a Fare well — I ought to be gone.",
        "With All Duͤ‑respect :— I must ‘ence‑forth absent My‑self."
    ]
    
    Send(MyDepartures[Random(1, MyDepartures.Length)])
    NudgeCursor() ; Good practice to keep the cursor consistent
    return
}
::ibb::
{
    static MyReturns := [
        "I shall Re‑turn soon , do — please — remain ‘ere a moment.",
        "Mine absence shall be but a Fleeting moment , I shall Re‑turn before long.",
        "Await My Re‑turn — ‘tshall not be a Lengthy delay.",
        "Pray ; wait a moment , for Mine awaiting Re‑turn is imminent.",
        "I shall be back , ‘twill be of Utmost respect by You to wait Me , lest We lose the Impromptu‑agreement of genteelneß betwiꭗt Us."
    ]
    
    Send(MyReturns[Random(1, MyReturns.Length)])
    NudgeCursor()
    return
}
::idk::
{
    static MyUncertainties := [
        "Mine heart confeßes that I , surely , am at a loſs.",
        "Such knowledge Presently is Over‑stood by Me.",
        "On This matter ,  My mind is a Clouded tableau — I can’t say for certain.",
        "Alas ; I am be‑set by a Profound perplexity on This subject.",
        "I shall note that :— I know naught."
    ]
    
    Send(MyUncertainties[Random(1, MyUncertainties.Length)])
    NudgeCursor()
    return
}
::gmfriend::Good morning , My Dear friend — Have a Peaceful day. Hugs.
::gnfriend::
{
    static MyFriendGoodnights := [
        "Good night , My Dear friend — may : Your rest be deep & Your dreams be peaceful , I bid Thee well until the Next morrow.",
        "As the day In‑evitably yields to the cloak of the night , I wish Thee Good night My Cherished companion — may the quietude of the ‘our enfold Thee while keeping All Worldly‑worries at bay.",
        "The day’s labours are done , My Trusted friend — may the Gentle stillneß of the night engulf Your spirit ℀ grant Thee Un‑troubled sleep , bis spaͤter ; until We speak again.",
        "Wishes of Peaceful dreams to You , My friend Important , may morpheus treat Thee kindly and‑consequently deliver You safely to the New day.",
        "Good night , My love on earth — shall the ravens of night ward Ill omens away when You are deep in somniums of Thine , indubitabilis ; take care of Your-self , for mori is Always up-on Us Oney‑where Oney‑time — I bid Thee well , I prithee , please , You shan't hesitate to summon Me at Thine Earliest convenience.",
        "Another day’s Long journey reaches It’s conclusion , Mon ami — a Fare night to Thee is wished up-on by Me :— may Your paßage in‑to the land of dreams be steady ℀ free from Oney‑kind of Turbulent thought , verily ; I shall await Your Re‑turn at the First light , please :— I prithee , You shan't hesitate to summon Me at Thine Earliest convenience.",
        "The world switches to a Gentle murmur , Mine Esteemed friend — I wish You dreams of Utmost verisimilitude , expectedly ; may the : stillneß & calmneſs of To‑‘our be the candle to Your spirit ℀ diſsipate All troubles of the day like mist — sleep soundly , kißes‑&‑‘ugs.",
        "As the : luna aßumes ‘er Nightly throne & stars begin Their Silent watch , I send Thee wishes for a Good night , My friend — may Your slumber be profound so that :— You may awaken with Renewed vigour up‑on the morrow.",
        "Good night , My Dearest friend — as You prepare for rest know that :— You are held in Mine ‘ighest regard — may sleep find Thee Forth‑with ℀ grant Thee the Full measure of It’s profound peace , until We Tele-communicate again in a Further date.",
        "The curtain of night falls , marking the closure of Another chapter in Our lives , My Auspicous friend , ℀ ; I wish Thee Kind dreams :— may the darkneß offer a sanctuary for the mind , a Brief ceßation from the world’s Un‑ceasing march — rest well , for Our energies are finite.",
        "The Celestial tapestry Un‑folds above , My friend , and‑consequently so I wish Thee dreams of relaxation — may Your rest be as deep as the cosmos while Your dreams are as bright as the Distant stars."
        "Let the day’s Final breath be a Gentle sigh , My Worthy friend — may Your journey in‑to Deep sleep be a voyage on a Tranquil Soft sea free from All Tempestuous thoughts , rest now :— for This-morrow awaits Our Re‑union.",
        "Good night , My friend — shall the moon’s Gentle light be a guide at Your window :— guarding You from Oney‑thing that might disturb Your peace.",
        "The time ‘as come to cast oﬀ the ‘eavy mantle of the day , Mine Esteemed friend — Good night to Thee :— may the darkneß serve not as a void but as a Velvet cloak that Over‑whelms All troubles ℀ brings‑forth a Peaceful oblivion until the sol’s In‑evitable Re‑turn."
    ]
    
    Send(MyFriendGoodnights[Random(1, MyFriendGoodnights.Length)])
    NudgeCursor()
    return
}
::gmenemy::Good morning , Mine Esteemed enemy : I wish unto You a Pleasant day.
::gmenemybad::Good morning , My Despicable enemy : I wish unto You a Disastrous day.
::summonme::I prithee , You shan't hesitate to summon Me at Thine Earliest convenience.
::frq::
{
    static MyQueries := [
        "Is It truly so ?",
        "Pray , tell Me this is not some Fanciful jest ?",
        "Can So‑like a thing be in All truthfulneſs ?",
        "Verily ? You speak of things that strain credulity.",
        "Speak plainly :— does the truth of the matter align with Your words ?",
        "Forgive Mine incredulity , alas ; Your words do strain the Very bounds of reason.",
        "Do You but jest with Me or does verity attend Your claim ?",
        "Surely ; You speak in riddles , I prithee :— clarify Your meaning without delay , lest I get lost in the Implicit meaning.",
        "Thine utterance do Verily astound the senses , My fellow , How‑ever ; can You aﬃrm ‘tis without exaggeration of Oney-kind ?",
        "By what certainty do You make So‑like a declaration , meaning ; is It grounded in an Un‑deniable fact ?"
    ]
    
    Send(MyQueries[Random(1, MyQueries.Length)])
    NudgeCursor()
    return
}
::tbh::
{
    static MyTruths := [
        "If I am to be truthful :—",
        "I — also — ought to mention that :—",
        "Let Me lay aside All pretense and‑consequently state the matter as thus :—",
        "In All frankneß the situation appears to Me as So‑like :—",
        "If You would permit Me a moment of Plain speaking :—"
    ]
    
    Send(MyTruths[Random(1, MyTruths.Length)])
    NudgeCursor()
    return
}
::ok::
{
    static MyOKs := [
        "You shall consider It settled.",
        "I ‘ave Under‑stood.",
        "Verily ; one may consider that ‘tis agreed up‑on.",
        "Your⧸Yer words ‘ave been heard and duly noted.",
        "Let the matter be considered Re‑solved.",
        "So shall It be.",
        "All correct.",
        "The matter — which ‘as been presented before Me — shall be considered by All : males , females , other , & All‑other members of the Man‑kind eﬀective ‘ence‑forth — shall No‑one utter a word as presented ‘ere‑in‑after as : eꭗactly or in Similar nature to : « They⧸She⧸‘e ‘ave⧸‘as not ‘eard It at all ! » , Immediate ‘ence‑fore.",
        "Oll korrect.",
        "All korrect.",
        "All right.",
        "All fine.",
        "All Under‑stood.",
        "Duly noted.",
        "Under‑stood.",
        "I grant Mine aſsent , It may : proceed or be considered Under‑stood.",
        "‘tis Under‑stood.",
        "Thus I acknowledge the matter.",
        "It stands established.",
        "I record Mine agreement without Oney‑kind of reserve.",
        "So It shall be.",
        "The point is Firmly received.",
        "It is taken as granted.",
        "The fact ‘ave been recorded in My remembrance.",
        "I incline Mine head in affirmation.",
        "So marked , so noted.",
        "To My Best‑knowledge , the thing is Under‑stood.",
        "No‑thing further need be said , ‘tis clear.",
        "As sure as day breaks , It stands confirmed.",
        "It shall be as stated.",
        "By All means , I am in accord.",
        "No‑thing ‘inders Me , I grant aßent.",
        "Thus :— the covenant is sealed.",
        "All is agreed.",
        "The matter is : respected & taken in.",
        "Thine⧸Your utterance is engraven on My thought.",
        "Indeed , the matter ‘as found Mine Under‑standing.",
        "It’s Re‑solved beyond doubt."
    ]
    
    randomIndex := Random(1, MyOKs.Length)
    
    Send(MyOKs[randomIndex])
    NudgeCursor()
    return
}
:O:fw::
{
    static MyForthwiths := [
        "Forth‑with",
        "at once",
        "immediately",
        "without delay",
        "Post‑‘aste",
        "In‑continently",
        "This Very‑instant",
        "without a moment’s ‘esitation",
        "In a Short amount of time",
        "At the Earliest convenience",
        "straight‑away",
        "directly",
        "Right now"
    ]
    
    Send(MyForthwiths[Random(1, MyForthwiths.Length)])
    NudgeCursor()
    return
}
::omw::My conveyance is in motion , expect Mine arrival in Duͤ course.

:O:hnt::‘ither‑&‑thither
:O:eiab::‘ere‑in‑above
:O:eib::‘ere‑in‑before
:O:eiaf::‘ere‑in‑after
:O:eiu::‘ere‑in‑under
:O:hsit::‘e⧸She⧸It⧸They
:O:teyr::Thee⧸Yer
:O:tiyr::Thine⧸Your

:OC:due::duͤ 
:OC:Due::Duͤ
:O:tiyr::Thine⧸Your





:?:s-h::Some‑how  
:?:h-e::How‑ever ;
:O*?:s-t ::
{
	Send "Some‑thing "
}
:?:s-ti::Some‑times
:?:s-e::Some‑one
:?:s-w::Some‑where
:?:n-o::No‑one
:O*?:a-t ::
{
	Send "Oney‑thing "
}
:?:a-ti::Oney‑time
:?:a-e::Oney‑one
:?:a-m::Oney‑more
:?:a-n::Oney‑thing
:?:a-w::Oney‑where
:?:e-t::Aye‑each‑thing
:?:e-o::Aye‑each‑one
:?:e-w::Aye‑each‑where
:?:w-e::What‑ever 
:?:aewt::Aye‑each‑whicher-of-two

:?:s-p::Some‑place
:?:a-p::Oney‑place
:?:e-p::Aye‑each‑place
:?:n-p::No‑place
:O?:u-s::Under‑stand
:O?:u-sb::Under‑standable
:O?:u-so::Under‑stood
:O?:o-s::Over‑stand
:O?:o-sb::Over‑standable
:O?:o-so::Over‑stood
:O?:e-d::Aye‑each‑day
:O?:e-w::Aye‑each‑week
:O?:e-m::Aye‑each‑month
:O?:e-y::Aye‑each‑year
:O?:e-de::Aye‑each‑decade
:O?:e-c::Aye‑each‑century
:O?:e-mi::Aye‑each‑millennium

:O?:s-k::Some‑kind
:O?:n-k::None‑kind
:O?:e-k::Aye‑each‑kind
:O?:a-c::
{
    local ac := (Random(0, 1) = 0) ? "and‑consequently" : "℀"
    Send(ac)
}
:O?:a-me::Afore‑mentioned 

:O?:t-c::thus‑consequently
:O?:a-s::and‑so
:O?:a-o::and‑obviously
:O*?:a-th::and‑then
:O*?:i-cn::Inter‑connected network
:O:html::H.‑t.M.‑u.l.


exceptions := ["a/c", "a/s", "a-e", "a-m", "a-n", "a-t", "a-ti","a-me", "a-w", 
               "e-c", "e-d", "e-de", "e-m", "e-mi", "e-o", "e-t", "e-w", "e-y", 
               "h-e","a-o","a-t","a-o","a-s",
               "n-o", "a-c", "e-k", "s-k", "t-k", "n-k", "f-m",
               "o-s", "o-sb", "o-so", "t-c", 
               "s-e", "s-h", "s-t", "s-ti","i-c", "s-w", 
               "u-s", "u-sb", "u-so", "s-p", "a-p", "e-p", "n-p",
               "w-e"]


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
exceptionsa := Map()
Loop 10 {
    outerNumber := Chr(48 + A_Index-1)
    Loop 10 {
        innerNumber := Chr(48 + A_Index-1)
        combination := outerNumber . "-" . innerNumber
            Hotstring(":C*?:" . combination, outerNumber . "‒" . innerNumber)
    }
}

SendRandomContraction(contraction, fullForm)
{
    local choice := Random(0, 1)
    Send(choice = 0 ? contraction : fullForm)
    Send(" ")
    NudgeCursor()
}

contractions := Map(
    "arent", ["aren’t", "are not"],
    "cant", ["can’t", "can not"],
    "isnt", ["isn’t", "is not"],
    "doesnt", ["doesn’t", "does not"],
    "didnt", ["didn’t", "did not"],
    "wont", ["won’t", "will not"],
    "wouldnt", ["wouldn’t", "would not"],
    "shouldnt", ["shouldn’t", "should not"],
    "couldnt", ["couldn’t", "could not"],
    "wasnt", ["wasn’t", "was not"],
    "werent", ["weren’t", "were not"],
    "dont", ["don’t", "do not"],
    "youve", ["You’ve", "You ‘ave"],
    "weve", ["We’ve", "We ‘ave"],
    "theyve", ["They’ve", "They ‘ave"],
    "youd", ["You’d", "You would"],
    "wed", ["We’d", "We would"],
    "theyd", ["They’d", "They would"],
    "youll", ["You’ll", "You will"],
    "shell", ["She’ll", "She will"],
    "theyll", ["They’ll", "They will"],
    "youre", ["You’re", "You are"],
    "hes", ["He’s", "He is"],
    "shes", ["She’s", "She is"],
    "theyre", ["They’re", "They are"],
    "whats", ["what’s", "what is"],
    "thats", ["that’s", "that is"],
    "wheres", ["Where’s", "Where is"],
    "theres", ["There’s", "There is"],
    "mustnt", ["mustn’t", "must not"],
    "shant", ["shan’t", "shall not"],
    "oughtnt", ["oughtn’t", "ought not"],
    "mightnt", ["mightn’t", "might not"],
    "neednt", ["needn’t", "need not"]
)

for trigger, forms in contractions {
    Hotstring(":C:" . trigger, ((f) => (*) => SendRandomContraction(f[1], f[2]))(forms))
}
;----------------------------------------------- LIST FORMATTER , LOWER‑CASIZATION , & CAPITALIZATION


global capitalizationMap := Map(
    "ﬁ", "Fi",
    "ﬂ", "Fl",
    "ﬀ", "Ff",
    "st", "st",
    "ß", "Ss",
    "ĳ", "Ij",
    "ꜷ", "Au",
    "av", "Av",
    "ꜵ", "Ao",
    "oo", "Oo",
    "st", "st",
    "s", "S"
)

:*?:cczx::
{
    CapitalizePreviousChar()
    return
}

CapitalizePreviousChar() {
    global capitalizationMap
    
    local savedClipboard := ClipboardAll()
    A_Clipboard := ""

    SendInput("^{Left}")

    SendInput("+{Right}")
    SendInput("^c")
    
    if !ClipWait(0.1) {
        A_Clipboard := savedClipboard
        SendInput("{Right}")
        return
    }
    
    local charToCapitalize := A_Clipboard
    A_Clipboard := savedClipboard
    
    SendInput("{Left}") 

    if (charToCapitalize = "") {
        SendInput("^{Right}")
        return
    }

    SendInput("{Del}")

    local capitalizedChar := ""
    if capitalizationMap.Has(charToCapitalize) {
        capitalizedChar := capitalizationMap[charToCapitalize]
    } else {
        capitalizedChar := strUpper(charToCapitalize)
    }

    SendInput(capitalizedChar)

    SendInput("^{Right}")
    
    return
}
global decapitalizationMap := Map(
    "Fi", "ﬁ",
    "Fl", "ﬂ",
    "Ff", "ﬀ",
    "St", "st",
    "Ij", "ĳ",
    "Au", "ꜷ",
    "Av", "av",
    "Ao", "ꜵ",
    "Oo", "oo",
    "S", "s"
)

:*?:ccxz::
{
    DecapitalizePreviousChar()
    return
}

DecapitalizePreviousChar() {
    global decapitalizationMap
    
    local savedClipboard := ClipboardAll()
    A_Clipboard := ""

    SendInput("^{Left}")

    SendInput("+{Right}")
    SendInput("^c")
    
    if !ClipWait(0.1) {
        A_Clipboard := savedClipboard
        SendInput("{Right}")
        return
    }
    
    local charToDecapitalize := A_Clipboard
    A_Clipboard := savedClipboard
    
    SendInput("{Left}") 

    if (charToDecapitalize = "") {
        SendInput("^{Right}")
        return
    }

    SendInput("{Del}")

    local decapitalizedChar := ""
    if decapitalizationMap.Has(charToDecapitalize) {
        decapitalizedChar := decapitalizationMap[charToDecapitalize]
    } else {
        decapitalizedChar := strLower(charToDecapitalize)
    }

    SendInput(decapitalizedChar)

    SendInput("^{Right}")
    
    return
}
;----------------------------------------------- MISC.


NudgeCursor() {
    DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 0, "Ptr", 0) ; Left Press
    DllCall("keybd_event", "UChar", 0x25, "UChar", 0, "UInt", 2, "Ptr", 0) ; Left Release
    DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 0, "Ptr", 0) ; Right Press
    DllCall("keybd_event", "UChar", 0x27, "UChar", 0, "UInt", 2, "Ptr", 0) ; Right Release
}

;----------------------------------------------- LOGIC MENU 


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

:C*O?:arrowmenu::
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

logicCommon := [
    ["01", "∧", "AND"],
    ["02", "∨", "OR"],
    ["03", "¬", "NOT"],
    ["04", "→", "IMPLIES"],
    ["05", "↔", "IFF"],
    ["06", "∀", "FORALL"],
    ["07", "∃", "EXISTS"],
    ["08", "∈", "IN"],
    ["09", "∴", "THEREFORE"],
    ["0A", "∵", "BECAUSE"]
]

logicCategories := [
    ["Propositional Logic !", "propositional"],
    ["Quantifiers !", "quantifiers"],
    ["Sets ( Menu ) !", "sets"],
    ["Relations ( Menu ) !", "relations"],
    ["Inference/Proof !", "inference"],
    ["Modal Logic/Miscellaneous !", "modal"],
    ["Calculus/Analysis !", "calculus"],
    ["Algebra/Operators !", "algebra"],
    ["Geometry !", "geometry"],
    ["Delimiters/Brackets !", "delims"],
    ["Mathematical Alphabets !", "mathalpha"]
]

logicSetSubCategories := [
    ["Set Membership !", "setmember"],
    ["Set Operations !", "setops"],
    ["Set Comparison !", "setcomp"],
    ["Special Sets !", "setmisc"]
]

logicAlphaSubCategories := [
    ["Double-struck ( Blackboard Bold ) !", "alphabb"],
    ["Script ( Calligraphic ) !", "alphascr"],
    ["Fraktur !", "alphafrak"],
    ["Greek ( Bold ) !", "alphagreek"]
]

logicRelSubCategories := [
    ["Equality Relations !", "relequal"],
    ["Inequality Relations !", "relinequal"],
    ["Order/Precedence Relations !", "relorder"]
]
logicPropositional := [
    ["11", "∧", "AND ( Conjunction )"],
    ["12", "∨", "OR ( Disjunction )"],
    ["13", "¬", "NOT ( Negation )"],
    ["14", "⊕", "XOR ( Exclusive Or )"],
    ["15", "⊼", "NAND ( Not And )"],
    ["16", "⊽", "NOR ( Not Or )"],
    ["17", "→", "IMPLIES ( Implication )"],
    ["18", "←", "IMPLIED BY"],
    ["19", "↔", "IFF ( If and Only If )"],
    ["110", "↛", "NOT IMPLIES"],
    ["111", "↮", "NOT IFF"]
]

logicQuantifiers := [
    ["21", "∀", "FORALL ( Universal Quantifier )"],
    ["22", "∃", "EXISTS ( Existential Quantifier )"],
    ["23", "∄", "NOT EXISTS"],
    ["24", "∃!", "UNIQUE EXISTS"],
    ["25", "⊤", "TOP ( Tautology )"],
    ["26", "⊥", "BOTTOM ( Contradiction )"]
]

logicSetsMember := [
    ["311", "∈", "IN ( Element Of )"],
    ["312", "∉", "NOT IN ( Not Element Of )"],
    ["313", "∋", "OWNS ( Contains )"],
    ["314", "∌", "NOT OWNS ( Does Not Contain )"],
    ["315", "∊", "SMALL IN"],
    ["316", "∍", "SMALL OWNS"]
]

logicSetsOps := [
    ["321", "∪", "UNION"],
    ["322", "∩", "INTERSECTION"],
    ["323", "⋃", "BIG UNION"],
    ["324", "⋂", "BIG INTERSECTION"],
    ["325", "∖", "SET MINUS ( Difference )"],
    ["326", "∆", "SYMMETRIC DIFFERENCE"],
    ["327", "×", "CARTESIAN PRODUCT"],
    ["328", "∐", "COPRODUCT"],
    ["329", "∔", "DOT PLUS"]
]

logicSetsComp := [
    ["331", "⊂", "SUBSET ( Proper )"],
    ["332", "⊆", "SUBSET OR EQUAL"],
    ["333", "⊄", "NOT SUBSET"],
    ["334", "⊈", "NOT SUBSET OR EQUAL"],
    ["335", "⊃", "SUPERSET ( Proper )"],
    ["336", "⊇", "SUPERSET OR EQUAL"],
    ["337", "⊅", "NOT SUPERSET"],
    ["338", "⊉", "NOT SUPERSET OR EQUAL"],
    ["339", "⊊", "SUBSET NOT EQUAL"],
    ["3310", "⊋", "SUPERSET NOT EQUAL"]
]

logicSetsMisc := [
    ["341", "∅", "EMPTY SET"],
    ["342", "ø", "EMPTY SET ( Alternative )"],
    ["343", "ℵ", "ALEPH ( Cardinal Number )"],
    ["344", "ℶ", "BETH ( Cardinal Number )"],
    ["345", "℘", "POWER SET"],
    ["346", "ℕ", "NATURAL NUMBERS"],
    ["347", "ℤ", "INTEGERS"],
    ["348", "ℚ", "RATIONAL NUMBERS"],
    ["349", "ℝ", "REAL NUMBERS"],
    ["3410", "ℂ", "COMPLEX NUMBERS"]
]

logicRelEqual := [
    ["411", "=", "EQUAL"],
    ["412", "≠", "NOT EQUAL"],
    ["413", "≡", "EQUIVALENT"],
    ["414", "≢", "NOT EQUIVALENT"],
    ["415", "≈", "APPROXIMATELY EQUAL"],
    ["416", "≉", "NOT APPROXIMATELY EQUAL"],
    ["417", "≅", "CONGRUENT"],
    ["418", "≇", "NOT CONGRUENT"],
    ["419", "∼", "SIMILAR"],
    ["4110", "≁", "NOT SIMILAR"],
    ["4111", "≃", "SIMILAR OR EQUAL"],
    ["4112", "∝", "PROPORTIONAL TO"],
    ["4113", "≍", "ASYMPTOTICALLY EQUAL"],
    ["4114", "≏", "BUMP EQUALS"],
    ["4115", "≑", "BUMP EQUALS ( Variant )"],
    ["4116", "≐", "DOT EQUALS"],
    ["4117", "≖", "EQUALS WITH CIRCLE"],
    ["4118", "≜", "TRIANGLE EQUALS"]
]

logicRelInequal := [
    ["421", "≤", "LESS THAN OR EQUAL"],
    ["422", "≥", "GREATER THAN OR EQUAL"],
    ["423", "≰", "NOT LESS THAN OR EQUAL"],
    ["424", "≱", "NOT GREATER THAN OR EQUAL"],
    ["425", "≪", "MUCH LESS THAN"],
    ["426", "≫", "MUCH GREATER THAN"],
    ["427", "≨", "LESS THAN NOT EQUAL"],
    ["428", "≩", "GREATER THAN NOT EQUAL"],
    ["429", "<", "LESS THAN"],
    ["4210", ">", "GREATER THAN"],
    ["4211", "≬", "BETWEEN"]
]

logicRelOrder := [
    ["431", "≺", "PRECEDES"],
    ["432", "≻", "SUCCEEDS"],
    ["433", "≼", "PRECEDES OR EQUAL"],
    ["434", "≽", "SUCCEEDS OR EQUAL"],
    ["435", "⊀", "NOT PRECEDES"],
    ["436", "⊁", "NOT SUCCEEDS"],
    ["437", "≾", "PRECEDES OR SIMILAR"],
    ["438", "≿", "SUCCEEDS OR SIMILAR"],
    ["439", "⊰", "PRECEDES UNDER"],
    ["4310", "⊱", "SUCCEEDS UNDER"],
    ["4311", "⊲", "TRIANGLE LEFT ( Normal Subgroup )"],
    ["4312", "⊳", "TRIANGLE RIGHT"],
    ["4313", "⊴", "TRIANGLE LEFT OR EQUAL"],
    ["4314", "⊵", "TRIANGLE RIGHT OR EQUAL"]
]

logicInference := [
    ["51", "∴", "THEREFORE"],
    ["52", "∵", "BECAUSE"],
    ["53", "∎", "QED ( End of Proof )"],
    ["54", "⊢", "PROVES ( Turnstile )"],
    ["55", "⊬", "NOT PROVES"],
    ["56", "⊨", "MODELS ( Semantic Consequence )"],
    ["57", "⊭", "NOT MODELS"],
    ["58", "⊩", "FORCES"],
    ["59", "⊮", "NOT FORCES"],
    ["510", "⊤", "TRUE ( Verum )"],
    ["511", "⊥", "FALSE ( Falsum )"]
]

logicModal := [
    ["61", "□", "BOX ( Necessarily )"],
    ["62", "◇", "DIAMOND ( Possibly )"],
    ["63", "◊", "LOZENGE"],
    ["64", "⌖", "CIRCLE IN RECTANGLE"],
    ["65", "■", "BLACK SQUARE"],
    ["66", "⧫", "BLACK LOZENGE"],
    ["67", "∠", "ANGLE"],
    ["68", "∡", "MEASURED ANGLE"],
    ["69", "∢", "SPHERICAL ANGLE"],
    ["610", "⊥", "PERPENDICULAR"],
    ["611", "∥", "PARALLEL"],
    ["612", "∦", "NOT PARALLEL"],
    ["613", "∫", "INTEGRAL"],
    ["614", "∮", "CONTOUR INTEGRAL"],
    ["615", "∂", "PARTIAL DERIVATIVE"],
    ["616", "∇", "NABLA ( Gradient )"],
    ["617", "∞", "INFINITY"]
]

logicCalculus := [
    ["71", "∫", "INTEGRAL"],
    ["72", "∬", "DOUBLE INTEGRAL"],
    ["73", "∭", "TRIPLE INTEGRAL"],
    ["74", "∮", "CONTOUR INTEGRAL"],
    ["75", "∯", "SURFACE INTEGRAL"],
    ["76", "∰", "VOLUME INTEGRAL"],
    ["77", "∂", "PARTIAL DERIVATIVE"],
    ["78", "∇", "NABLA ( Gradient )"],
    ["79", "√", "SQUARE ROOT"],
    ["710", "∛", "CUBE ROOT"],
    ["711", "∜", "FOURTH ROOT"],
    ["712", "∞", "INFINITY"],
    ["713", "∆", "INCREMENT ( Delta )"],
    ["714", "ϖ", "VARIANT PI"],
    ["715", "∑", "SUMMATION"],
    ["716", "∏", "PRODUCT"],
    ["717", "∐", "COPRODUCT"]
]

logicAlgebra := [
    ["81", "±", "PLUS MINUS"],
    ["82", "∓", "MINUS PLUS"],
    ["83", "∣", "DIVIDES"],
    ["84", "∤", "NOT DIVIDES"],
    ["85", "⋅", "DOT ( Multiplication )"],
    ["86", "×", "CROSS ( Multiplication )"],
    ["87", "∘", "CIRCLE ( Composition )"],
    ["88", "∙", "BULLET OPERATOR"],
    ["89", "∗", "AstERISK OPERATOR"],
    ["810", "⋆", "stAR OPERATOR"],
    ["811", "⋄", "DIAMOND OPERATOR"],
    ["812", "⊕", "OPLUS ( Direct Sum )"],
    ["813", "⊖", "OMINUS"],
    ["814", "⊗", "OTIMES ( Tensor Product )"],
    ["815", "⊘", "OSLASH"],
    ["816", "⊙", "ODOT"],
    ["817", "⊎", "UPLUS ( Multiset Union )"],
    ["818", "⊓", "SQUARE CAP"],
    ["819", "⊔", "SQUARE CUP"],
    ["820", "≀", "WREATH PRODUCT"],
    ["821", "⨿", "AMALGAMATION"]
]

logicGeometry := [
    ["91", "⊥", "PERPENDICULAR"],
    ["92", "∠", "ANGLE"],
    ["93", "∡", "MEASURED ANGLE"],
    ["94", "∢", "SPHERICAL ANGLE"],
    ["95", "∟", "RIGHT ANGLE"],
    ["96", "∥", "PARALLEL"],
    ["97", "∦", "NOT PARALLEL"],
    ["98", "△", "TRIANGLE"],
    ["99", "□", "SQUARE"],
    ["910", "◊", "LOZENGE"],
    ["911", "○", "CIRCLE"],
    ["912", "⌀", "DIAMETER"],
    ["913", "⊤", "TOP"],
    ["914", "⊥", "BOTTOM"]
]

logicDelims := [
    ["101", "⌈", "LEFT CEILING"],
    ["102", "⌉", "RIGHT CEILING"],
    ["103", "⌊", "LEFT FLOOR"],
    ["104", "⌋", "RIGHT FLOOR"],
    ["105", "⟨", "LEFT ANGLE BRACKET"],
    ["106", "⟩", "RIGHT ANGLE BRACKET"],
    ["107", "⟦", "DOUBLE BRACKET LEFT"],
    ["108", "⟧", "DOUBLE BRACKET RIGHT"],
    ["109", "⌜", "UPPER LEFT CORNER"],
    ["1010", "⌝", "UPPER RIGHT CORNER"],
    ["1011", "⌞", "LOWER LEFT CORNER"],
    ["1012", "⌟", "LOWER RIGHT CORNER"],
    ["1013", "…", "DOTS ( Horizontal Ellipsis )"],
    ["1014", "⋯", "MIDLINE DOTS ( For Products/Sums )"],
    ["1015", "⋮", "VERTICAL DOTS"],
    ["1016", "⋱", "DIAGONAL DOTS ( Down-Right )"],
    ["1017", "⋰", "DIAGONAL DOTS ( Up-Right )"]
]

logicAlphaBB := [
    ["111A", "𝔸", "BLACKBOARD BOLD A"], ["111a", "𝕒", "BLACKBOARD BOLD a"],
    ["111B", "𝔹", "BLACKBOARD BOLD B"], ["111b", "𝕓", "BLACKBOARD BOLD b"],
    ["111C", "ℂ", "BLACKBOARD BOLD C"], ["111c", "𝕔", "BLACKBOARD BOLD c"],
    ["111D", "𝔻", "BLACKBOARD BOLD D"], ["111d", "𝕕", "BLACKBOARD BOLD d"],
    ["111E", "𝔼", "BLACKBOARD BOLD E"], ["111e", "𝕖", "BLACKBOARD BOLD e"],
    ["111F", "𝔽", "BLACKBOARD BOLD F"], ["111f", "𝕗", "BLACKBOARD BOLD f"],
    ["111G", "𝔾", "BLACKBOARD BOLD G"], ["111g", "𝕘", "BLACKBOARD BOLD g"],
    ["111H", "ℍ", "BLACKBOARD BOLD H"], ["111h", "𝕙", "BLACKBOARD BOLD h"],
    ["111I", "𝕀", "BLACKBOARD BOLD I"], ["111i", "𝕚", "BLACKBOARD BOLD i"],
    ["111J", "𝕁", "BLACKBOARD BOLD J"], ["111j", "𝕛", "BLACKBOARD BOLD j"],
    ["111K", "𝕂", "BLACKBOARD BOLD K"], ["111k", "𝕜", "BLACKBOARD BOLD k"],
    ["111L", "𝕃", "BLACKBOARD BOLD L"], ["111l", "𝕝", "BLACKBOARD BOLD l"],
    ["111M", "𝕄", "BLACKBOARD BOLD M"], ["111m", "𝕞", "BLACKBOARD BOLD m"],
    ["111N", "ℕ", "BLACKBOARD BOLD N"], ["111n", "𝕟", "BLACKBOARD BOLD n"],
    ["111O", "𝕆", "BLACKBOARD BOLD O"], ["111o", "𝕠", "BLACKBOARD BOLD o"],
    ["111P", "ℙ", "BLACKBOARD BOLD P"], ["111p", "𝕡", "BLACKBOARD BOLD p"],
    ["111Q", "ℚ", "BLACKBOARD BOLD Q"], ["111q", "𝕢", "BLACKBOARD BOLD q"],
    ["111R", "ℝ", "BLACKBOARD BOLD R"], ["111r", "𝕣", "BLACKBOARD BOLD r"],
    ["111S", "𝕊", "BLACKBOARD BOLD S"], ["111s", "𝕤", "BLACKBOARD BOLD s"],
    ["111T", "𝕋", "BLACKBOARD BOLD T"], ["111t", "𝕥", "BLACKBOARD BOLD t"],
    ["111U", "𝕌", "BLACKBOARD BOLD U"], ["111u", "𝕦", "BLACKBOARD BOLD u"],
    ["111V", "𝕍", "BLACKBOARD BOLD V"], ["111v", "𝕧", "BLACKBOARD BOLD v"],
    ["111W", "𝕎", "BLACKBOARD BOLD W"], ["111w", "𝕨", "BLACKBOARD BOLD w"],
    ["111X", "𝕏", "BLACKBOARD BOLD X"], ["111x", "𝕩", "BLACKBOARD BOLD x"],
    ["111Y", "𝕐", "BLACKBOARD BOLD Y"], ["111y", "𝕪", "BLACKBOARD BOLD y"],
    ["111Z", "ℤ", "BLACKBOARD BOLD Z"], ["111z", "𝕫", "BLACKBOARD BOLD z"],
    ["1110", "𝟘", "BLACKBOARD BOLD 0"], ["1111", "𝟙", "BLACKBOARD BOLD 1"],
    ["1112", "𝟚", "BLACKBOARD BOLD 2"], ["1113", "𝟛", "BLACKBOARD BOLD 3"],
    ["1114", "𝟜", "BLACKBOARD BOLD 4"], ["1115", "𝟝", "BLACKBOARD BOLD 5"],
    ["1116", "𝟞", "BLACKBOARD BOLD 6"], ["1117", "𝟟", "BLACKBOARD BOLD 7"],
    ["1118", "𝟠", "BLACKBOARD BOLD 8"], ["1119", "𝟡", "BLACKBOARD BOLD 9"],
    ["111gamma", "ℾ", "BLACKBOARD BOLD GAMMA"],
    ["111pi", "ℿ", "BLACKBOARD BOLD PI"],
    ["111sigma", "⅀", "BLACKBOARD BOLD SIGMA"]
]

logicAlphaScr := [
    ["112A", "𝒜", "SCRIPT A"], ["112a", "𝒶", "SCRIPT a"],
    ["112B", "ℬ", "SCRIPT B"], ["112b", "𝒷", "SCRIPT b"],
    ["112C", "𝒞", "SCRIPT C"], ["112c", "𝒸", "SCRIPT c"],
    ["112D", "𝒟", "SCRIPT D"], ["112d", "𝒹", "SCRIPT d"],
    ["112E", "ℰ", "SCRIPT E"], ["112e", "ℯ", "SCRIPT e"],
    ["112F", "ℱ", "SCRIPT F"], ["112f", "𝒻", "SCRIPT f"],
    ["112G", "𝒢", "SCRIPT G"], ["112g", "ℊ", "SCRIPT g"],
    ["112H", "ℋ", "SCRIPT H"], ["112h", "𝒽", "SCRIPT h"],
    ["112I", "ℐ", "SCRIPT I"], ["112i", "𝒾", "SCRIPT i"],
    ["112J", "𝒥", "SCRIPT J"], ["112j", "𝒿", "SCRIPT j"],
    ["112K", "𝒦", "SCRIPT K"], ["112k", "𝓀", "SCRIPT k"],
    ["112L", "ℒ", "SCRIPT L"], ["112l", "𝓁", "SCRIPT l"],
    ["112M", "ℳ", "SCRIPT M"], ["112m", "𝓂", "SCRIPT m"],
    ["112N", "𝒩", "SCRIPT N"], ["112n", "𝓃", "SCRIPT n"],
    ["112O", "𝒪", "SCRIPT O"], ["112o", "ℴ", "SCRIPT o"],
    ["112P", "𝒫", "SCRIPT P"], ["112p", "𝓅", "SCRIPT p"],
    ["112Q", "𝒬", "SCRIPT Q"], ["112q", "𝓆", "SCRIPT q"],
    ["112R", "ℛ", "SCRIPT R"], ["112r", "𝓇", "SCRIPT r"],
    ["112S", "𝒮", "SCRIPT S"], ["112s", "𝓈", "SCRIPT s"],
    ["112T", "𝒯", "SCRIPT T"], ["112t", "𝓉", "SCRIPT t"],
    ["112U", "𝒰", "SCRIPT U"], ["112u", "𝓊", "SCRIPT u"],
    ["112V", "𝒱", "SCRIPT V"], ["112v", "𝓋", "SCRIPT v"],
    ["112W", "𝒲", "SCRIPT W"], ["112w", "𝓌", "SCRIPT w"],
    ["112X", "𝒳", "SCRIPT X"], ["112x", "𝓍", "SCRIPT x"],
    ["112Y", "𝒴", "SCRIPT Y"], ["112y", "𝓎", "SCRIPT y"],
    ["112Z", "𝒵", "SCRIPT Z"], ["112z", "𝓏", "SCRIPT z"]
]

logicAlphaFrak := [
    ["113A", "𝔄", "FRAKTUR A"], ["113a", "𝔞", "FRAKTUR a"],
    ["113B", "𝔅", "FRAKTUR B"], ["113b", "𝔟", "FRAKTUR b"],
    ["113C", "ℭ", "FRAKTUR C"], ["113c", "𝔠", "FRAKTUR c"],
    ["113D", "𝔇", "FRAKTUR D"], ["113d", "𝔡", "FRAKTUR d"],
    ["113E", "𝔈", "FRAKTUR E"], ["113e", "𝔢", "FRAKTUR e"],
    ["113F", "𝔉", "FRAKTUR F"], ["113f", "𝔣", "FRAKTUR f"],
    ["113G", "𝔊", "FRAKTUR G"], ["113g", "𝔤", "FRAKTUR g"],
    ["113H", "ℌ", "FRAKTUR H"], ["113h", "𝔥", "FRAKTUR h"],
    ["113I", "ℑ", "FRAKTUR I"], ["113i", "𝔦", "FRAKTUR i"],
    ["113J", "𝔍", "FRAKTUR J"], ["113j", "𝔧", "FRAKTUR j"],
    ["113K", "𝔎", "FRAKTUR K"], ["113k", "𝔨", "FRAKTUR k"],
    ["113L", "𝔏", "FRAKTUR L"], ["113l", "𝔩", "FRAKTUR l"],
    ["113M", "𝔐", "FRAKTUR M"], ["113m", "𝔪", "FRAKTUR m"],
    ["113N", "𝔑", "FRAKTUR N"], ["113n", "𝔫", "FRAKTUR n"],
    ["113O", "𝔒", "FRAKTUR O"], ["113o", "𝔬", "FRAKTUR o"],
    ["113P", "𝔓", "FRAKTUR P"], ["113p", "𝔭", "FRAKTUR p"],
    ["113Q", "𝔔", "FRAKTUR Q"], ["113q", "𝔮", "FRAKTUR q"],
    ["113R", "ℜ", "FRAKTUR R"], ["113r", "𝔯", "FRAKTUR r"],
    ["113S", "𝔖", "FRAKTUR S"], ["113s", "𝔰", "FRAKTUR s"],
    ["113T", "𝔗", "FRAKTUR T"], ["113t", "𝔱", "FRAKTUR t"],
    ["113U", "𝔘", "FRAKTUR U"], ["113u", "𝔲", "FRAKTUR u"],
    ["113V", "𝔙", "FRAKTUR V"], ["113v", "𝔳", "FRAKTUR v"],
    ["113W", "𝔚", "FRAKTUR W"], ["113w", "𝔴", "FRAKTUR w"],
    ["113X", "𝔛", "FRAKTUR X"], ["113x", "𝔵", "FRAKTUR x"],
    ["113Y", "𝔜", "FRAKTUR Y"], ["113y", "𝔶", "FRAKTUR y"],
    ["113Z", "ℨ", "FRAKTUR Z"], ["113z", "𝔷", "FRAKTUR z"]
]
logicAlphaGreek := [
    ["114a", "𝛂", "BOLD GREEK ALPHA"],
    ["114b", "𝛃", "BOLD GREEK BETA"],
    ["114g", "𝛄", "BOLD GREEK GAMMA"],
    ["114d", "𝛅", "BOLD GREEK DELTA"],
    ["114e", "𝛆", "BOLD GREEK EPSILON"],
    ["114z", "𝛇", "BOLD GREEK ZETA"],
    ["114eta", "𝛈", "BOLD GREEK ETA"],
    ["114th", "𝛉", "BOLD GREEK THETA"],
    ["114i", "𝛊", "BOLD GREEK IOTA"],
    ["114k", "𝛋", "BOLD GREEK KAPPA"],
    ["114l", "𝛌", "BOLD GREEK LAMBDA"],
    ["114m", "𝛍", "BOLD GREEK MU"],
    ["114n", "𝛎", "BOLD GREEK NU"],
    ["114chi", "𝛏", "BOLD GREEK CHI"],
    ["114o", "𝛐", "BOLD GREEK OMICRON"],
    ["114p", "𝛑", "BOLD GREEK PI"],
    ["114r", "𝛒", "BOLD GREEK RHO"],
    ["114s", "𝛔", "BOLD GREEK SIGMA"],
    ["114t", "𝛕", "BOLD GREEK TAU"],
    ["114u", "𝛖", "BOLD GREEK UPSILON"],
    ["114ph", "𝛗", "BOLD GREEK PHI"],
    ["114ch", "𝛘", "BOLD GREEK CHI"],
    ["114ps", "𝛙", "BOLD GREEK PSI"],
    ["114omega", "𝛚", "BOLD GREEK OMEGA"]
]

logicAutocompleteActive := false
logicCurrentMenu := "main"
logicCurrentOptions := []
logicSelectedIndex := 0

:C*O?:loggicmenu::
{
    global
    logicAutocompleteActive := true
    logicCurrentMenu := "main"
    logicSelectedIndex := 0
    ShowLogicMainMenu()
}

ShowLogicMainMenu() {
    global
    
    logicCurrentOptions := []
    suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`nCommon :`n"
    
    for item in logicCommon {
        logicCurrentOptions.Push({code: item[1], symbol: item[2], name: item[3], type: "symbol"})
        prefix := (logicCurrentOptions.Length == logicSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . item[3] . " , " . item[2] . "`n"
    }
    
    suggestions .= "Categories :`n"
    
    for item in logicCategories {
        logicCurrentOptions.Push({key: item[1], symbol: "", type: "category", menuKey: item[2]})
        prefix := (logicCurrentOptions.Length == logicSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . item[1] . "`n"
    }
    
    ToolTip(suggestions, , , 1)
}

ShowLogicSubmenu(menuType) {
    global
    
    logicCurrentOptions := []
    local suggestions := ""
    
    switch menuType {
        case "sets":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            for item in logicSetSubCategories {
                logicCurrentOptions.Push({key: item[1], symbol: "", type: "subcategory", menuKey: item[2], parentMenu: "sets"})
                prefix := (logicCurrentOptions.Length == logicSelectedIndex + 1) ? "☞ " : "  "
                suggestions .= prefix . item[1] . "`n"
            }
            
        case "relations":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            for item in logicRelSubCategories {
                logicCurrentOptions.Push({key: item[1], symbol: "", type: "subcategory", menuKey: item[2], parentMenu: "relations"})
                prefix := (logicCurrentOptions.Length == logicSelectedIndex + 1) ? "☞ " : "  "
                suggestions .= prefix . item[1] . "`n"
            }
            
        case "mathalpha":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            for item in logicAlphaSubCategories {
                logicCurrentOptions.Push({key: item[1], symbol: "", type: "subcategory", menuKey: item[2], parentMenu: "mathalpha"})
                prefix := (logicCurrentOptions.Length == logicSelectedIndex + 1) ? "☞ " : "  "
                suggestions .= prefix . item[1] . "`n"
            }
            
        case "propositional":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicPropositional, suggestions)
            
        case "quantifiers":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicQuantifiers, suggestions)
            
        case "inference":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicInference, suggestions)
            
        case "modal":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicModal, suggestions)
            
        case "calculus":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicCalculus, suggestions)
            
        case "algebra":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicAlgebra, suggestions)
            
        case "geometry":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicGeometry, suggestions)
            
        case "delims":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicDelims, suggestions)
    }
    
    ToolTip(suggestions, , , 1)
}

ShowLogicSubSubmenu(menuType) {
    global
    
    logicCurrentOptions := []
    local suggestions := ""
    
    switch menuType {
        case "setmember":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicSetsMember, suggestions)
            
        case "setops":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicSetsOps, suggestions)
            
        case "setcomp":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicSetsComp, suggestions)
            
        case "setmisc":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicSetsMisc, suggestions)
            
        case "relequal":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicRelEqual, suggestions)
            
        case "relinequal":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicRelInequal, suggestions)
            
        case "relorder":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicRelOrder, suggestions)
            
        case "alphabb":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicAlphaBB, suggestions)
            
        case "alphascr":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicAlphaScr, suggestions)
            
        case "alphafrak":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicAlphaFrak, suggestions)
            
        case "alphagreek":
            suggestions := "Preß : „ ↑↓ „ to navigate , „ Enter „ to select , „ → „ or „ Enter „ for ſub-menus , & „ ← „ to Re-turn.`n"
            suggestions := ShowSymbolsFromArray(logicAlphaGreek, suggestions)
    }
    
    ToolTip(suggestions, , , 1)
}

ShowSymbolsFromArray(symbolsArray, suggestions) {
    global
    for item in symbolsArray {
        logicCurrentOptions.Push({code: item[1], symbol: item[2], name: item[3], type: "symbol"})
        prefix := (logicCurrentOptions.Length == logicSelectedIndex + 1) ? "☞ " : "  "
        suggestions .= prefix . item[3] . " , " . item[2] . " — № : " . item[1] . "`n"
    }
    return suggestions
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
        UpdateLogicDisplay()
    }
}

Down::
{
    global
    if (logicCurrentOptions.Length > 0) {
        logicSelectedIndex := Mod(logicSelectedIndex + 1, logicCurrentOptions.Length)
        UpdateLogicDisplay()
    }
}

Right::
{
    global
    if (logicCurrentOptions.Length > 0 && logicSelectedIndex < logicCurrentOptions.Length) {
        selectedOption := logicCurrentOptions[logicSelectedIndex + 1]
        if (selectedOption.type == "category") {
            logicCurrentMenu := selectedOption.menuKey
            logicSelectedIndex := 0
            ShowLogicSubmenu(logicCurrentMenu)
        } else if (selectedOption.type == "subcategory") {
            logicCurrentMenu := selectedOption.menuKey
            logicSelectedIndex := 0
            ShowLogicSubSubmenu(logicCurrentMenu)
        }
    }
}

Left::
{
    global
    if (logicCurrentMenu == "setmember" || logicCurrentMenu == "setops" || logicCurrentMenu == "setcomp" || logicCurrentMenu == "setmisc") {
        logicCurrentMenu := "sets"
        logicSelectedIndex := 0
        ShowLogicSubmenu(logicCurrentMenu)
    } else if (logicCurrentMenu == "relequal" || logicCurrentMenu == "relinequal" || logicCurrentMenu == "relorder") {
        logicCurrentMenu := "relations"
        logicSelectedIndex := 0
        ShowLogicSubmenu(logicCurrentMenu)
    } else if (logicCurrentMenu == "alphabb" || logicCurrentMenu == "alphascr" || logicCurrentMenu == "alphafrak" || logicCurrentMenu == "alphagreek") {
        logicCurrentMenu := "mathalpha"
        logicSelectedIndex := 0
        ShowLogicSubmenu(logicCurrentMenu)
    } else if (logicCurrentMenu != "main") {
        logicCurrentMenu := "main"
        logicSelectedIndex := 0
        ShowLogicMainMenu()
    }
}

Enter::
{
    global
    if (logicCurrentOptions.Length > 0 && logicSelectedIndex < logicCurrentOptions.Length) {
        selectedOption := logicCurrentOptions[logicSelectedIndex + 1]
        
        if (selectedOption.type == "symbol") {
            Send(selectedOption.symbol)
            logicAutocompleteActive := false
            ToolTip()
        } else if (selectedOption.type == "category") {
            logicCurrentMenu := selectedOption.menuKey
            logicSelectedIndex := 0
            ShowLogicSubmenu(logicCurrentMenu)
        } else if (selectedOption.type == "subcategory") {
            logicCurrentMenu := selectedOption.menuKey
            logicSelectedIndex := 0
            ShowLogicSubSubmenu(logicCurrentMenu)
        }
    }
}

Escape::
{
    global
    logicAutocompleteActive := false
    ToolTip()
}

Backspace::
{
    global
    logicAutocompleteActive := false
    ToolTip()
    Send("{Backspace}")
}

Space::
{
    global
    logicAutocompleteActive := false
    ToolTip()
    Send(" ")
}

#HotIf

UpdateLogicDisplay() {
    global
    if (logicCurrentMenu == "main") {
        ShowLogicMainMenu()
    } 
    else if (logicCurrentMenu == "setmember" || logicCurrentMenu == "setops" || logicCurrentMenu == "setcomp" || logicCurrentMenu == "setmisc" 
          || logicCurrentMenu == "relequal" || logicCurrentMenu == "relinequal" || logicCurrentMenu == "relorder"
          || logicCurrentMenu == "alphabb" || logicCurrentMenu == "alphascr" || logicCurrentMenu == "alphafrak" || logicCurrentMenu == "alphagreek") {
        ShowLogicSubSubmenu(logicCurrentMenu)
    } 
    else {
        ShowLogicSubmenu(logicCurrentMenu)
    }
}
AllLogicArrays := [
    logicCommon, logicPropositional, logicQuantifiers, 
    logicSetsMember, logicSetsOps, logicSetsComp, logicSetsMisc,
    logicRelEqual, logicRelInequal, logicRelOrder,
    logicInference, logicModal, logicCalculus, 
    logicAlgebra, logicGeometry, logicDelims,
    logicAlphaBB, logicAlphaScr, logicAlphaFrak, logicAlphaGreek
]

for arrayObj in AllLogicArrays {
    for item in arrayObj {
        try {
            code := item[1]
            symbol := item[2]
            Hotstring(":CO?:loggic" . code, symbol)
        }
    }
}




;----------------------------------------------- TYPO‑GRAPHICAL 2

Loop 10 {
    outerNum := A_Index - 1 
    Loop 10 {
        innerNum := A_Index - 1  
        Hotstring(":C*?:" . outerNum . "/" . innerNum, outerNum . "⁄" . innerNum)
    }
}

$^+v::
{
    if (A_Clipboard != "" && RegExMatch(A_Clipboard, "\R")) {
        marker := Chr(0xA0) . "\" . Chr(0xA0)
        txt := RegExReplace(A_Clipboard, "\R", marker)
        
        if WinActive("ahk_exe soffice.bin") {
            savedClip := A_Clipboard
        } else {
            savedClip := ClipboardAll()
        }
        
        A_Clipboard := ""
        A_Clipboard := txt
        ClipWait(1)
        SendEvent("{Blind}{vk07}")
        SendEvent("^v")
        Sleep(150)
        A_Clipboard := savedClip
        savedClip := ""
    } else {
        SendEvent("{Blind}{vk07}")
        SendEvent("^v")
    }
}

:*?:0 ::{
    SendInput("0{U+2007}")
    NudgeCursor()
}

:*?:1 ::{
    SendInput("1{U+2007}")
    NudgeCursor()
}

:*?:2 ::{
    SendInput("2{U+2007}")
    NudgeCursor()
}

:*?:3 ::{
    SendInput("3{U+2007}")
    NudgeCursor()
}

:*?:4 ::{
    SendInput("4{U+2007}")
    NudgeCursor()
}

:*?:5 ::{
    SendInput("5{U+2007}")
    NudgeCursor()
}

:*?:6 ::{
    SendInput("6{U+2007}")
    NudgeCursor()
}

:*?:7 ::{
    SendInput("7{U+2007}")
    NudgeCursor()
}

:*?:8 ::{
    SendInput("8{U+2007}")
    NudgeCursor()
}

:*?:9 ::{
    SendInput("9{U+2007}")
    NudgeCursor()
}
:*?:-*::‑
:*?:.-::.‑
:*?:-&-::
{
    SendInput("{U+2011}{U+0026}{U+2011}")
    NudgeCursor()
    return
}
:*?:&-::&‑
:*?:<.>::↔
:*?:->::→
:*?:<-::←



:CO*?: v. ::
{
    Send "{U+00A0}{U+1D463}{U+2024}{U+00A0}"
    NudgeCursor()
    return
}


;----------------------------------------------- GREEK LETTERS
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
:?O:grchi::ξ
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
;----------------------------------------------- LIGATURES
:*O?:letterth::þ
:*O?:letterdh::ð
:C*?: terticolon::
{
    Send "{U+00A0}{U+F56C}"
    NudgeCursor()
    return
}
:C*?: quarticolon::
{
    Send "{U+00A0}{U+F56B}"
    NudgeCursor()
    return
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
    NudgeCursor()
    } else {
        Send "ß"
    NudgeCursor()
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
    NudgeCursor()
}


:C*?:VY::
{
    if !ism
    {
        Send "{U+0056}{U+0059}"
        return
    }
    Send "{U+A760}"
    NudgeCursor()
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
    NudgeCursor()
    return
}
;----------------------------------------------- LATIN PHRASES

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
:?OC:ehgo::{
    Send " & ‘oc genus omne "
    return
}
;----------------------------------------------- LIGATURES CONTINUED 

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
	Send "ʤ "
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
;----------------------------------------------- SPECIAL CHARACTERS
:?O:~~::
{
    Send "〜"
    NudgeCursor()
    return
}

:*C?O:I ::I 
:*C?O:-T ::Þͤ 
:*C?O:-t ::þͤ 
:*C?O:_î::̃
:*C?O:_a::ͣ
:*C?O:_e::ͤ
:*C?O:_i::ͥ
:*C?O:_o::ͦ
:*C?O:_u::ͧ
:*C?O:_c::ͨ
:*C?O:_h::ͪ
:*C?O:_m::ͫ
:*C?O:_v::ͮ
:*C?O:_x::ͯ
:c*:Th::Þ
:c*:TH::Þ
:c*:th::þ

thBal := 0

BiasedTh(upper) {
    global thBal
    p := Max(5, Min(95, 50 - thBal * 5))
    if (Random(1, 100) <= p) {
        Send(upper ? "Þ" : "þ")
        thBal++
    } else {
        Send(upper ? "Ð" : "ð")
        thBal--
    }
}

:c?*:Th::{
BiasedTh(true)
}
:c?*:th::{
BiasedTh(false)
}
:c?*:TH::{
BiasedTh(true)
}

::oz::℥
::ounce::℥
;----------------------------------------------- NUMERI
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
;----------------------------------------------- EDITORAL SYMBOLS & MISC.
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
:CO*?:katex::$\KaTeX$
:CO*?:latex::$\LaTeX$
:CO*?:\v31null::
{
    SendInput("$\underline{{}\raisebox{{}-0.74ex{}}{{}V{}}\kern{{}-0.15em{}}31\raisebox{{}-0.74ex{}}{{}\kern{{}-0.08em{}}$n${}}{}}$")
}
RAlt & 4::Send("$")
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
;----------------------------------------------- TIME
:*O?:idatea::
{
    dt := FormatTime(A_Now, "yyyy/MM/dd")
    Send(dt)
    NudgeCursor()
    return
}

:*O?:idateb::
{
    year := FormatTime(A_Now, "yyyy")
    month := FormatTime(A_Now, "MM")
    day := FormatTime(A_Now, "dd")
    hour24 := Integer(FormatTime(A_Now, "HH"))
    minute := FormatTime(A_Now, "mm")
    second := FormatTime(A_Now, "ss")
    
    ampm := (hour24 < 12) ? "AM" : "PM"
    
    if (hour24 = 0) {
        hour := "00"
    } else if (hour24 < 12) {
        hour := Format("{:d}", hour24)
    } else if (hour24 = 12) {
        hour := "00"
    } else {
        hour := Format("{:d}", hour24 - 12)
    }
    
    result := year . "/" . month . "/" . day . " " . hour . ":" . minute . ":" . second . " " . ampm
    Send(result)
    NudgeCursor()
    return
}
;----------------------------------------------- ROMAN NUMERI.
global romanUpper := Map(
    100000, "ↈ", 90000, "ↂↈ", 50000, "ↇ", 40000, "ↂↇ", 10000, "ↂ",
    9000, "ↂↁ", 5000, "ↁ", 4000, "Ⅿↁ", 1000, "Ⅿ",
    900, "ⅭⅯ", 500, "Ⅾ", 400, "ⅭⅮ", 100, "Ⅽ",
    90, "ⅩⅭ", 50, "Ⅼ", 40, "ⅩⅬ", 10, "Ⅹ", 9, "Ⅸ", 
    5, "Ⅴ", 4, "Ⅳ", 1, "Ⅰ"
)

global romanLower := Map(
    1000, "ⅿ", 900, "ⅽⅿ", 500, "ⅾ", 400, "ⅽⅾ", 100, "ⅽ",
    90, "ⅹⅽ", 50, "ⅼ", 40, "ⅹⅼ", 10, "ⅹ", 9, "ⅸ", 
    5, "ⅴ", 4, "ⅳ", 1, "ⅰ"
)

ConvertToRomanUnicode(num, useSmall := false) {
    if (num <= 0)
        return string(num)
    
    symbols := useSmall ? romanLower : romanUpper
    result := ""
    
    ; Get sorted values in descending order
    values := []
    for value in symbols {
        values.Push(value)
    }
    
    ; Sort descending
    loop values.Length - 1 {
        swapped := false
        loop values.Length - A_Index {
            if (values[A_Index] < values[A_Index + 1]) {
                temp := values[A_Index]
                values[A_Index] := values[A_Index + 1]
                values[A_Index + 1] := temp
                swapped := true
            }
        }
        if (!swapped)
            break
    }
    
    ; Build the Roman numeral
    for value in values {
        while (num >= value && symbols.Has(value)) {
            result .= symbols[value]
            num -= value
        }
    }
    
    return result
}

:B0*CX:romannumero::
{
    static romanRegex := "^\d+$"
    
    ih := InputHook("V", "{Space}{Tab}{Enter}{Esc}{,}{.}{!}{?}{:}{;}")
    ih.start()
    ih.Wait()
    
    if (RegExMatch(ih.Input, romanRegex)) {
        num := Integer(ih.Input)
        Send("{BS " . (12 + strLen(ih.Input)) . "}")
        Send(ConvertToRomanUnicode(num))
        if (ih.EndReason = "EndKey" && ih.EndKey != "Escape") {
            Send("{" . ih.EndKey . "}")
        }
    } else {
        Send("roman" . ih.Input)
        if (ih.EndReason = "EndKey" && ih.EndKey != "Escape") {
            Send("{" . ih.EndKey . "}")
        }
    }
}

SendRandomTimePrefix(suffix)
{
    local prefix := (Random(0, 1) = 0) ? "To‑" : "This‑"
    Send(prefix . suffix)
}



;----------------------------------------------- SYMBOLS MENU



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
    "ngr", "N.‑gr.",
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

:C*O?:simenu::
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

;----------------------------------------------- DIMMER
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
;----------------------------------------------- KOPIER

class KopierApp {
    
    static Init() {
        Hotstring(":O?*:\kopier", (*) => KopierApp.Show())
    }

    static Show() {
        if (HasProp(this, "MyGui") && this.MyGui) {
            this.MyGui.Show()
            return
        }

        this.fileList := []
        this.pathToFileObj := Map()
        this.activeTempDirs := []
        this.folderKeys := Map()
        this.isUpdating := false

        this.MyGui := Gui("+Resize", "File Formatter")
        this.MyGui.SetFont("s10", "Consolas")

        this.dropZone := this.MyGui.AddEdit("x10 y10 w445 h485 ReadOnly Center", "drop files place")
        this.flatList := this.MyGui.AddListView("x465 y10 w645 h485 Checked", ["File", "Chars"])
        this.fileTree := this.MyGui.AddTreeView("Checked x10 y505 w445 h485")
        this.extList := this.MyGui.AddListView("x465 y505 w645 h485 Checked", ["Extension", "Chars"])

        this.output := this.MyGui.AddEdit("x1120 y10 w703 h980 ReadOnly Multi VScroll HScroll")

        this.flatList.ModifyCol(1, 520)
        this.flatList.ModifyCol(2, "95 Integer")
        this.extList.ModifyCol(1, 400)
        this.extList.ModifyCol(2, "200 Integer")

        this.MyGui.OnEvent("Close", ObjBindMethod(this, "GuiClose"))
        this.fileTree.OnEvent("Click", ObjBindMethod(this, "TreeViewClicked"))
        this.flatList.OnEvent("ItemCheck", ObjBindMethod(this, "OnFlatListCheck"))
        this.extList.OnEvent("ItemCheck", ObjBindMethod(this, "OnExtListCheck"))

        DllCall("shell32\DragAcceptFiles", "Ptr", this.dropZone.Hwnd, "Int", 1)
        
        this.DropFunc := ObjBindMethod(this, "WM_DROPFILES")
        this.KeyFunc := ObjBindMethod(this, "WM_KEYDOWN")
        
        OnMessage(0x233, this.DropFunc)
        OnMessage(0x0100, this.KeyFunc)

        this.MyGui.Show("w1833 h1000")
    }

    static GuiClose(guiObj) {
        for tempDir in this.activeTempDirs {
            try DirDelete(tempDir, true)
        }
        this.activeTempDirs := []
        
        OnMessage(0x233, this.DropFunc, 0)
        OnMessage(0x0100, this.KeyFunc, 0)
        
        this.MyGui.Destroy()
        this.MyGui := ""
    }

    static WM_DROPFILES(wParam, lParam, msg, hwnd) {
        if (!HasProp(this, "dropZone") || hwnd != this.dropZone.Hwnd)
            return
            
        count := DllCall("shell32\DragQueryFileW", "Ptr", wParam, "UInt", 0xFFFFFFFF, "Ptr", 0, "UInt", 0)
        if count < 1
            return
        
        this.isUpdating := true
        this.fileTree.Opt("-Redraw")
        this.flatList.Opt("-Redraw")
        this.extList.Opt("-Redraw")
        
        this.fileTree.Delete()
        this.flatList.Delete()
        this.extList.Delete()
        
        this.fileList := []
        this.pathToFileObj.Clear()
        this.folderKeys.Clear()
        
        for tempDir in this.activeTempDirs {
            try DirDelete(tempDir, true)
        }
        this.activeTempDirs := []

        loop count {
            buf := Buffer(1024 * 2)
            DllCall("shell32\DragQueryFileW", "Ptr", wParam, "UInt", A_Index - 1, "Ptr", buf, "UInt", 512)
            droppedPath := StrGet(buf, "UTF-16")
            this.ProcessItem(droppedPath)
        }
        
        DllCall("shell32\DragFinish", "Ptr", wParam)
        
        extCount := Map()
        for fileObj in this.fileList {
            ext := fileObj.ext == "" ? "<none>" : fileObj.ext
            if !extCount.Has(ext)
                extCount[ext] := 0
            extCount[ext] += fileObj.charCount
        }
        
        for ext, chars in extCount {
            this.extList.Add("Check", ext, chars)
        }
        
        this.fileTree.Opt("+Redraw")
        this.flatList.Opt("+Redraw")
        this.extList.Opt("+Redraw")
        this.isUpdating := false
        
        this.UpdateOutput()
    }

    static ProcessItem(path) {
        static tempCounter := 0
        archiveExtensions := ",zip,rar,7z,tar,gz,"

        if DirExist(path) {
            SplitPath(path, &dirName)
            this.ProcessFolder(path, path, dirName)
        } else {
            SplitPath(path, &fileName, , &ext)
            extL := StrLower(ext)
            
            if extL != "" && InStr(archiveExtensions, "," extL ",") {
                tempCounter++
                tempDir := A_Temp "\FileFormatter_" A_TickCount "_" tempCounter
                if this.ExtractArchive(path, tempDir) {
                    this.activeTempDirs.Push(tempDir)
                    this.ProcessFolder(tempDir, tempDir, fileName)
                } else {
                    this.fileTree.Add("Error: Failed to extract " fileName, 0, "Icon0")
                }
            } else {
                this.AddFileToTree(path, "", "")
            }
        }
    }

    static ProcessFolder(folderPath, baseDir, prefix) {
        Loop Files, folderPath "\*", "R" {
            this.AddFileToTree(A_LoopFileFullPath, baseDir, prefix)
        }
    }

    static AddFileToTree(fullPath, baseDir, prefix) {
        parentID := 0
        displayPath := ""
        
        if (baseDir == "") {
            SplitPath(fullPath, &fileName)
            treeID := this.fileTree.Add(fileName, 0, "Check")
            displayPath := fileName
        } else {
            relPath := SubStr(fullPath, StrLen(baseDir) + 2)
            parts := StrSplit(relPath, "\")
            
            currentPath := prefix
            
            if prefix != "" {
                if !this.folderKeys.Has(prefix) {
                    this.folderKeys[prefix] := this.fileTree.Add(prefix, 0, "Expand Check")
                }
                parentID := this.folderKeys[prefix]
            }
            
            loop parts.Length - 1 {
                part := parts[A_Index]
                currentPath .= (currentPath != "" ? "\" : "") part
                if !this.folderKeys.Has(currentPath) {
                    this.folderKeys[currentPath] := this.fileTree.Add(part, parentID, "Expand Check")
                }
                parentID := this.folderKeys[currentPath]
            }
            
            fileName := parts[parts.Length]
            treeID := this.fileTree.Add(fileName, parentID, "Check")
            displayPath := (prefix != "" ? prefix "\" : "") relPath
        }
        
        SplitPath(fullPath, , , &ext)
        extL := StrLower(ext)
        
        isBinary := false
        charCount := 0
        content := ""
        
        if (extL == "odt") {
            content := this.GetOdtContent(fullPath)
            charCount := StrLen(content)
        } else if this.IsBinaryFile(fullPath) {
            isBinary := true
            charCount := 0
        } else {
            charCount := FileGetSize(fullPath)
        }
        
        this.flatList.Add("Check", displayPath, charCount)
        
        fileObj := {path: fullPath, displayPath: displayPath, ext: extL, charCount: charCount, content: content, isBinary: isBinary, treeID: treeID, isChecked: true}
        
        this.fileList.Push(fileObj)
        this.pathToFileObj[displayPath] := fileObj
    }

    static TreeViewClicked(guiCtrl, itemID) {
        if itemID {
            SetTimer(ObjBindMethod(this, "UpdateTreeState", itemID), -10)
        }
    }

    static WM_KEYDOWN(wParam, lParam, msg, hwnd) {
        if (!HasProp(this, "fileTree") || !this.fileTree)
            return
            
        if hwnd == this.fileTree.Hwnd && wParam == 32 { 
            selectedID := this.fileTree.GetSelection()
            if selectedID {
                SetTimer(ObjBindMethod(this, "UpdateTreeState", selectedID), -10)
            }
        }
    }

    static UpdateTreeState(itemID) {
        if this.isUpdating
            return
            
        isChecked := this.fileTree.Get(itemID, "Checked")
        
        this.isUpdating := true
        this.fileTree.Opt("-Redraw")
        this.flatList.Opt("-Redraw")
        this.extList.Opt("-Redraw")
        
        this.SetChildChecks(itemID, isChecked)
        this.UpdateParentChecks(itemID)
        
        this.SyncStateFromTree()
        
        this.fileTree.Opt("+Redraw")
        this.flatList.Opt("+Redraw")
        this.extList.Opt("+Redraw")
        this.isUpdating := false
        
        this.UpdateOutput()
    }

    static SyncStateFromTree() {
        for fileObj in this.fileList {
            checked := this.fileTree.Get(fileObj.treeID, "Checked")
            fileObj.isChecked := checked
        }
        
        loop this.flatList.GetCount() {
            displayPath := this.flatList.GetText(A_Index, 1)
            fileObj := this.pathToFileObj[displayPath]
            if (fileObj) {
                this.flatList.Modify(A_Index, fileObj.isChecked ? "Check" : "-Check")
            }
        }
        this.UpdateExtList()
    }

    static UpdateExtList() {
        extCount := Map()
        extChecked := Map()
        for fileObj in this.fileList {
            ext := fileObj.ext == "" ? "<none>" : fileObj.ext
            if !extCount.Has(ext) {
                extCount[ext] := 0
                extChecked[ext] := false
            }
            if fileObj.isChecked {
                extCount[ext] += fileObj.charCount
                extChecked[ext] := true
            }
        }
        
        loop this.extList.GetCount() {
            rowExt := this.extList.GetText(A_Index, 1)
            count := extCount.Has(rowExt) ? extCount[rowExt] : 0
            checked := extChecked.Has(rowExt) ? extChecked[rowExt] : false
            
            this.extList.Modify(A_Index, (checked ? "Check" : "-Check"), , count)
        }
    }

    static OnFlatListCheck(guiCtrl, item, checked) {
        if this.isUpdating
            return
        this.isUpdating := true

        this.fileTree.Opt("-Redraw")
        this.extList.Opt("-Redraw")

        displayPath := this.flatList.GetText(item, 1)
        fileObj := this.pathToFileObj[displayPath]
        
        if (fileObj) {
            fileObj.isChecked := checked
            this.fileTree.Modify(fileObj.treeID, checked ? "Check" : "-Check")
            this.UpdateParentChecks(fileObj.treeID)
        }
        
        this.UpdateExtList()
        
        this.fileTree.Opt("+Redraw")
        this.extList.Opt("+Redraw")
        this.isUpdating := false
        
        this.UpdateOutput()
    }

    static OnExtListCheck(guiCtrl, item, checked) {
        if this.isUpdating
            return
        this.isUpdating := true

        this.fileTree.Opt("-Redraw")
        this.flatList.Opt("-Redraw")

        ext := this.extList.GetText(item, 1)
        for fileObj in this.fileList {
            fExt := fileObj.ext == "" ? "<none>" : fileObj.ext
            if (fExt == ext) {
                if (fileObj.isChecked != checked) {
                    fileObj.isChecked := checked
                    this.fileTree.Modify(fileObj.treeID, checked ? "Check" : "-Check")
                    this.UpdateParentChecks(fileObj.treeID)
                }
            }
        }
        
        loop this.flatList.GetCount() {
            displayPath := this.flatList.GetText(A_Index, 1)
            fileObj := this.pathToFileObj[displayPath]
            if (fileObj) {
                this.flatList.Modify(A_Index, fileObj.isChecked ? "Check" : "-Check")
            }
        }
        
        this.UpdateExtList()
        
        this.fileTree.Opt("+Redraw")
        this.flatList.Opt("+Redraw")
        this.isUpdating := false
        
        this.UpdateOutput()
    }

    static SetChildChecks(parentID, isChecked) {
        childID := this.fileTree.GetChild(parentID)
        while childID {
            this.fileTree.Modify(childID, isChecked ? "Check" : "-Check")
            this.SetChildChecks(childID, isChecked)
            childID := this.fileTree.GetNext(childID)
        }
    }

    static UpdateParentChecks(childID) {
        parentID := this.fileTree.GetParent(childID)
        if !parentID
            return
            
        anyChecked := false
        siblingID := this.fileTree.GetChild(parentID)
        while siblingID {
            if this.fileTree.Get(siblingID, "Checked") {
                anyChecked := true
                break
            }
            siblingID := this.fileTree.GetNext(siblingID)
        }
        
        this.fileTree.Modify(parentID, anyChecked ? "Check" : "-Check")
        this.UpdateParentChecks(parentID)
    }

    static UpdateOutput() {
        result := ""
        for fileObj in this.fileList {
            if fileObj.isChecked {
                displayPath := fileObj.displayPath
                fullPath := fileObj.path
                
                if fileObj.isBinary {
                    result .= displayPath "`n[`n[ Unsupported file: Binary or non-text format ]`n]`n`n"
                } else if (fileObj.ext == "odt") {
                    result .= displayPath "`n[`n" fileObj.content "`n]`n`n"
                } else {
                    try {
                        content := FileRead(fullPath, "UTF-8")
                        result .= displayPath "`n[`n" content "`n]`n`n"
                    } catch {
                        result .= displayPath "`n[`n[ Error reading file ]`n]`n`n"
                    }
                }
            }
        }
        this.output.Value := Trim(result)
    }

    static IsBinaryFile(filePath) {
        try {
            fileObj := FileOpen(filePath, "r")
            bufSize := Min(fileObj.Length, 1024)
            if bufSize == 0 {
                fileObj.Close()
                return false
            }
                
            buf := Buffer(bufSize)
            fileObj.RawRead(buf, bufSize)
            fileObj.Close()
            
            loop bufSize {
                byte := NumGet(buf, A_Index - 1, "UChar")
                if byte == 0 || (byte < 32 && byte != 9 && byte != 10 && byte != 13)
                    return true
            }
            return false
        } catch {
            return true
        }
    }

    static GetOdtContent(path) {
        tempDir := A_Temp "\OdtExtract_" A_TickCount "_" Random(1000, 9999)
        DirCreate(tempDir)
        
        archiver := this.FindArchiver()
        extracted := false
        if (archiver != "" && InStr(archiver, "7z.exe")) {
            code := RunWait('"' archiver '" e "' path '" -o"' tempDir '" content.xml -y', , "Hide")
            extracted := (code == 0)
        }
        
        if (!extracted) {
            code := RunWait('tar -xf "' path '" -C "' tempDir '" content.xml', , "Hide")
        }
        
        xmlPath := tempDir "\content.xml"
        if FileExist(xmlPath) {
            content := FileRead(xmlPath, "UTF-8")
            text := RegExReplace(content, "<[^>]+>", "")
            text := StrReplace(text, "&amp;", "&")
            text := StrReplace(text, "&lt;", "<")
            text := StrReplace(text, "&gt;", ">")
            text := StrReplace(text, "&quot;", "`"")
            text := StrReplace(text, "&apos;", "'")
            try DirDelete(tempDir, true)
            return text
        }
        try DirDelete(tempDir, true)
        return ""
    }

    static FindArchiver() {
        paths := [
            "C:\Program Files\7-Zip\7z.exe",
            "C:\Program Files (x86)\7-Zip\7z.exe",
            "C:\Program Files\WinRAR\UnRAR.exe",
            "C:\Program Files\WinRAR\WinRAR.exe"
        ]
        for path in paths {
            if FileExist(path)
                return path
        }
        return ""
    }

    static ExtractArchive(archivePath, destDir) {
        if !DirExist(destDir)
            DirCreate(destDir)
            
        archiver := this.FindArchiver()
        SplitPath(archivePath, , , &ext)
        extL := StrLower(ext)
        
        if archiver != "" {
            if InStr(archiver, "7z.exe") {
                code := RunWait('"' archiver '" x "' archivePath '" -o"' destDir '" -y', , "Hide")
                return code == 0
            } else {
                code := RunWait('"' archiver '" x -ibck -y "' archivePath '" * "' destDir '"', , "Hide")
                return code == 0
            }
        }
        
        if extL == "zip" {
            cmd := "powershell -NoProfile -WindowStyle Hidden -Command `"Expand-Archive -Path '" archivePath "' -DestinationPath '" destDir "' -Force`""
            code := RunWait(cmd, , "Hide")
            return code == 0
        } else {
            code := RunWait('tar -xf "' archivePath '" -C "' destDir '"', , "Hide")
            return code == 0
        }
    }
}

KopierApp.Init()
