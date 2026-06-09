#Requires AutoHotkey v2.0

global QuoteLevel := 1
global QuoteMax   := 4

QuoteLeft := [
    "{U+00AB}{U+00A0}",  ; « NBSP
    "{U+201E}{U+00A0}",  ; „ NBSP
    "{U+201C}{U+00A0}",  ; “ NBSP
    "{U+201D}{U+00A0}"   ; ” NBSP
]

QuoteRight := [
    "{U+00A0}{U+00BB}",  ; NBSP »
    "{U+00A0}{U+201E}",  ; NBSP „
    "{U+00A0}{U+201C}",  ; NBSP “
    "{U+00A0}{U+201E}"   ; NBSP „
]
if WinActive("ahk_exe Code.exe"){
:*?:":: {
    global QuoteLevel, QuoteRight
    SendInput QuoteLeft[QuoteLevel]
}

+":: {
    global QuoteLevel, QuoteRight
    SendInput QuoteRight[QuoteLevel]
}

^!":: {
    global QuoteLevel, QuoteRight
    if QuoteLevel < QuoteMax
        QuoteLevel++
    SendInput QuoteLeft[QuoteLevel]
}

^":: {
    global QuoteLevel, QuoteRight
	SendInput QuoteRight[QuoteLevel]
    if QuoteLevel > 1
        QuoteLevel--
}
}

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
:C*?:'t::‘t
:C*?:( ::( 
:C*?: ):: )
:C*?:[ ::[ 
:C*?: ]:: ]
:?O:'::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0027}"
        return
    }
    Send "{U+2019}"
    return
}
:?:'s::’s
:?:'m::’m
:?:'ll::’ll
:?:'ve::’ve
:?:'re::’re
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
:C*?:numero::
{
    Send "{U+2116}{U+00A0}"
    return
}
::ineedtogo::I am afraid I muﬆ now take My leave.
::illbeback::I shall return sꝏn , do — please — remain here a moment.
::idk::Mine heart confesses that I , surely , am at a loss.
::gmfriend::Gꝏd morning , My Dear friend — Hꜹe a Peaceful dꜽ. Hugs.
::gmenemy::Gꝏd morning , Mine Eﬆeemed enemy : I wish unto You a Pleasant dꜽ.
::gmenemybad::Gꝏd morning , My Despicable enemy : I wish unto You a Disaﬆrous dꜽ.
:C*?:1/1::1⁄1
:C*?:1/2::1⁄2
:C*?:1/3::1⁄3
:C*?:1/4::1⁄4
:C*?:1/5::1⁄5
:C*?:1/6::1⁄6
:C*?:1/7::1⁄7
:C*?:1/8::1⁄8
:C*?:1/9::1⁄9

:C*?:2/1::2⁄1
:C*?:2/2::2⁄2
:C*?:2/3::2⁄3
:C*?:2/4::2⁄4
:C*?:2/5::2⁄5
:C*?:2/6::2⁄6
:C*?:2/7::2⁄7
:C*?:2/8::2⁄8
:C*?:2/9::2⁄9

:C*?:3/1::3⁄1
:C*?:3/2::3⁄2
:C*?:3/3::3⁄3
:C*?:3/4::3⁄4
:C*?:3/5::3⁄5
:C*?:3/6::3⁄6
:C*?:3/7::3⁄7
:C*?:3/8::3⁄8
:C*?:3/9::3⁄9

:C*?:4/1::4⁄1
:C*?:4/2::4⁄2
:C*?:4/3::4⁄3
:C*?:4/4::4⁄4
:C*?:4/5::4⁄5
:C*?:4/6::4⁄6
:C*?:4/7::4⁄7
:C*?:4/8::4⁄8
:C*?:4/9::4⁄9

:C*?:5/1::5⁄1
:C*?:5/2::5⁄2
:C*?:5/3::5⁄3
:C*?:5/4::5⁄4
:C*?:5/5::5⁄5
:C*?:5/6::5⁄6
:C*?:5/7::5⁄7
:C*?:5/8::5⁄8
:C*?:5/9::5⁄9

:C*?:6/1::6⁄1
:C*?:6/2::6⁄2
:C*?:6/3::6⁄3
:C*?:6/4::6⁄4
:C*?:6/5::6⁄5
:C*?:6/6::6⁄6
:C*?:6/7::6⁄7
:C*?:6/8::6⁄8
:C*?:6/9::6⁄9

:C*?:7/1::7⁄1
:C*?:7/2::7⁄2
:C*?:7/3::7⁄3
:C*?:7/4::7⁄4
:C*?:7/5::7⁄5
:C*?:7/6::7⁄6
:C*?:7/7::7⁄7
:C*?:7/8::7⁄8
:C*?:7/9::7⁄9

:C*?:8/1::8⁄1
:C*?:8/2::8⁄2
:C*?:8/3::8⁄3
:C*?:8/4::8⁄4
:C*?:8/5::8⁄5
:C*?:8/6::8⁄6
:C*?:8/7::8⁄7
:C*?:8/8::8⁄8
:C*?:8/9::8⁄9

:C*?:9/1::9⁄1
:C*?:9/2::9⁄2
:C*?:9/3::9⁄3
:C*?:9/4::9⁄4
:C*?:9/5::9⁄5
:C*?:9/6::9⁄6
:C*?:9/7::9⁄7
:C*?:9/8::9⁄8
:C*?:9/9::9⁄9
:C*?:0/1::0⁄1
:C*?:0/2::0⁄2
:C*?:0/3::0⁄3
:C*?:0/4::0⁄4
:C*?:0/5::0⁄5
:C*?:0/6::0⁄6
:C*?:0/7::0⁄7
:C*?:0/8::0⁄8
:C*?:0/9::0⁄9

:C*?:1/0::1⁄0
:C*?:2/0::2⁄0
:C*?:3/0::3⁄0
:C*?:4/0::4⁄0
:C*?:5/0::5⁄0
:C*?:6/0::6⁄0
:C*?:7/0::7⁄0
:C*?:8/0::8⁄0
:C*?:9/0::9⁄0

:C*?:0/0::0⁄0
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
:O:caret::‸
:O:1dagger::†
:O:2dagger::‡
:O:3dagger::※
:O:4dagger::∗
:O:5dagger::⁑
:O:6dagger::⁂
:*?:<->::↔
:*?:->::→
:*?:<-::←
:*?:<=>>::⇄
:*?:<<=>::⇆
::arrowup::↑
::arrowdown::↓
::arrowupleft::↖
::arrowupright::↗
::arrowdownleft::↙
::arrowdownright::↘
::arrowleftg::⟲
::arrowrightg::⟳
::arrowrightu::↻
::arrowleftu::↺
::arrowleftc::⥀
::arrowrightc::⥁
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
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0066}{U+0066}{U+0020}"
        return
    }
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
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0073}{U+0074}"
        return
    }
	Send " {U+FB06}"
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
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0054}{U+005A}"
        return
    }
    Send "{U+A728}"
    return
}
:C*?:Tz::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0054}{U+005A}"
        return
    }
    Send "{U+A728}"
    return
}
:C*?:tz::
{
    if WinActive("ahk_exe Code.exe")
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

:C*?:Sa::ſa
:C*?:Sb::ſb
:C*?:Sc::ſc
:C*?:Sd::ſd
:C*?:Se::ſe
:C*?:Sf::ſf
:C*?:Sg::ſg
:C*?:Sh::ſh
:C*?:Si::ſi
:C*?:Sj::ſj
:C*?:Sk::ſk
:C*?:Sl::ſl
:C*?:Sm::ſm
:C*?:Sn::ſn
:C*?:So::ſo
:C*?:Sp::ſp
:C*?:Sq::ſq
:C*?:Sr::ſr
:C*?:Su::ſu
:C*?:Sv::ſv
:C*?:Sw::ſw
:C*?:Sx::ſx
:C*?:Sy::ſy
:C*?:Sz::ſʒ

:C*?:st::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0073}{U+0074}"
        return 
    }
	Send "{U+FB06}"
}
:C*?:St::
{

    if WinActive("ahk_exe Code.exe")
    {
        Send "St"
        return 
    }
	Send "ﬅ"
}
:C*?:ss::
{
    if WinActive("ahk_exe Code.exe")
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
}
:*?:sz::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "sz"
        return
    }
	Send "ſʒ"
}

:C*?:AO::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0041}{U+004F}"
        return
    }
    Send "{U+A734}"
    return
}
:C*?:ao::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0061}{U+006F}"
        return
    }
    Send "{U+A735}"
    return
}

:C*?:AU::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0041}{U+0055}"
        return
    }
    Send "{U+A736}"
    return
}
:C*?:au::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0061}{U+0075}"
        return
    }
    Send "{U+A737}"
    return
}

:C*?:AV::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0041}{U+0056}"
        return
    }
    Send "{U+A738}"
    return
}
:C*?:lz::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+006C}{U+007A}"
        return
    }
    Send "{U+026E}"
    return
}

:C*?:lj::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+006C}{U+006A}"
        return
    }
    Send "{U+01C9}"
    return
}

:C*?:LJ::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+004C}{U+004A}"
        return
    }
    Send "{U+01C7}"
    return
}

:C*?:Lj::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+004C}{U+006A}"
        return
    }
    Send "{U+01C8}"
    return
}

:C*?:NJ::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+004E}{U+004A}"
        return
    }
    Send "{U+01CA}"
    return
}

:C*?:Nj::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+004E}{U+006A}"
        return
    }
    Send "{U+01CB}"
    return
}

:C*?:nj::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+006E}{U+006A}"
        return
    }
    Send "{U+01CC}"
    return
}

:C*?:av::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0061}{U+0076}"
        return
    }
    Send "{U+A739}"
    return
}
:C*?:AY::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0041}{U+0059}"
        return
    }
    Send "{U+A73C}"
    return
}
:C*?:ay::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0061}{U+0079}"
        return
    }
    Send "{U+A73D}"
    return
}


:C*?:Hv::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0048}{U+0076}"
        return
    }
    Send "{U+01F6}"
    return
}
:C*?:hv::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0068}{U+0076}"
        return
    }
    Send "{U+0195}"
    return
}

:C*?:OO::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+004F}{U+004F}"
        return
    }
    Send "{U+A74E}"
    return
}
:C*?:oo::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+006F}{U+006F}"
        return
    }
    Send "{U+A74F}"
    return
}
:C*?:VY::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0056}{U+0059}"
        return
    }
    Send "{U+A760}"
    return
}
:C*?:vy::
{
    if WinActive("ahk_exe Code.exe")
    {
        Send "{U+0076}{U+0079}"
        return
    }
    Send "{U+A761}"
    return
}
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
:C*?O:sub-::₋
:*?O:_+::⁺
:C*?O:sub+::₊
::eg::e.g./
::ie::i.e./
::ai::a.i./
:O?:logicand::∧
:O?:logicor::∨
:O?:logicmultiply::×
:O?:logicapprox::≈
:O?:notequal::≠
:O?:letterth::þ
:O?:letterdh::ð
:O?:logicall::∀
:O?:logicex::∃
:O?:logicnotex::∄
:O?:logicin::∈
:O?:notin::∉
:O?:logiccontains::∋
:O?:notcontains::∌
:O?:nullset::∅
:O?:notapprox::≉
:O?:logiccongruent::≅
:O?:logicequivalent::≡
:O?:nand::⊼
:O?:logicnor::⊽
:O?:logictherefore::∴
:O?:logicbecause::∵
:O?:logicnot::¬
:CO*?:perthousand::‰
:CO*?:perman::‱
::s-h::Some-how  
::h-e::How-ever ;
::s-t::Some-thing
::s-e::Some-one
::s-w::Some-where
::n-o::No-one
::a-t::Any-thing
::a-e::Any-one
::a-t::Any-time
::a-n::Any-thing
::a-w::Any-where
::e-t::Every-thing
::e-o::Every-one
::e-w::Every-where
::w-e::What-ever
::mg::M.-gr.
::kg::K.-gr.
::ng::N.-gr.
::pg::P.-gr.
::mm::M.-m.
::cm::C.-m.
::dm::D.-m.
::km::K.-m.
::nm::N.-m.
::ml::M.-l.
::cl::C.-l.
::dl::D.-l.
::mm2::M.-m.²
::cm2::C.-m.²
::m2::m.²
::km2::K.-m.²
::ms::M.-s.
