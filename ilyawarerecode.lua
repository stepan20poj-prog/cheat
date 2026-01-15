

local ultimate                          = {}
local me                                = LocalPlayer()

require("zxcmodule")

jit.flush()

/*
    Localization start
*/

local global 		                    = _G //table.Copy( _G )

local gRunCmd                           = global.RunConsoleCommand

local Angle                             = Angle
local Material                          = Material
local Vector                            = Vector
local Color                             = Color
local pairs                             = pairs
local ipairs                            = ipairs
local IsValid                           = IsValid
local tostring                          = tostring
local tonumber                          = tonumber
local CurTime                           = CurTime
local IsFirstTimePredicted              = IsFirstTimePredicted
local Lerp                              = Lerp
local LerpAngle                         = LerpAngle

local gFindMeta                         = global.FindMetaTable

local MetaPly                           = gFindMeta("Player")

local gVgui                             = global.vgui
local gGui                              = global.gui
local gString                           = global.string
local gTable                            = global.table
local gUtil                             = global.util
local gHttp                             = global.http
local gFile                             = global.file
local gSurface                          = global.surface
local gDraw                             = global.draw
local gRender                           = global.render
local gCam                              = global.cam
local gInput                            = global.input
local gHook                             = global.hook
local gNet                              = global.net
local gMath                             = global.math
local gBit                              = global.bit
local gEnts                             = global.ents
local gPlys                             = global.player
local gGame                             = global.game
local gEngine                           = global.engine
local gTeam                             = global.team

local gPlayer                            = global.Player
local gEntity                            = global.Entity

local team_GetColor                     = gTeam.GetColor
local team_GetName                      = gTeam.GetName

local surface_DrawLine                  = gSurface.DrawLine
local surface_DrawOutlinedRect          = gSurface.DrawOutlinedRect
local surface_DrawPoly                  = gSurface.DrawPoly
local surface_DrawRect                  = gSurface.DrawRect
local surface_DrawText                  = gSurface.DrawText
local surface_DrawTexturedRect          = gSurface.DrawTexturedRect
local surface_DrawTexturedRectRotated   = gSurface.DrawTexturedRectRotated
local surface_GetTextSize               = gSurface.GetTextSize
local surface_PlaySound                 = gSurface.PlaySound
local surface_SetAlphaMultiplier        = gSurface.SetAlphaMultiplier
local surface_SetDrawColor              = gSurface.SetDrawColor
local surface_SetFont                   = gSurface.SetFont
local surface_SetMaterial               = gSurface.SetMaterial
local surface_SetTextColor              = gSurface.SetTextColor
local surface_SetTextPos                = gSurface.SetTextPos
local surface_CreateFont                = gSurface.CreateFont

local math_abs                          = gMath.abs
local math_Round                        = gMath.Round
local math_floor                        = gMath.floor
local math_ceil                         = gMath.ceil
local math_min                          = gMath.min
local math_max                          = gMath.max
local math_Clamp                        = gMath.Clamp
local math_sin                          = gMath.sin
local math_cos                          = gMath.cos
local math_tan                          = gMath.tan
local math_rad                          = gMath.rad
local math_Rand                         = gMath.Rand
local math_randomseed                   = gMath.randomseed
local math_deg                          = gMath.deg
local math_atan                         = gMath.atan
local math_atan2                        = gMath.atan2
local math_random                       = gMath.random
local math_huge                         = gMath.huge
local math_sqrt                         = gMath.sqrt

local math_Approach                     = gMath.Approach
local math_NormalizeAngle               = gMath.NormalizeAngle
local math_DistanceSqr                  = gMath.DistanceSqr

local hook_Add                          = gHook.Add
local hook_Remove                       = gHook.Remove
local hook_GetTable                     = gHook.GetTable
local hook_Call                         = gHook.Call
local hook_Run                          = gHook.Run

local bor                               = gBit.bor

local vgui_Create                       = gVgui.Create
local vgui_Register                     = gVgui.Register

local table_Count                       = gTable.Count
local table_Empty                      = gTable.Empty
local table_concat                      = gTable.concat
local table_insert                      = gTable.insert
local table_remove                      = gTable.remove
local table_RemoveByValue               = gTable.RemoveByValue
local table_sort                        = gTable.sort

function table.Empty( tbl )
    if tbl == _G then return end

    return table_Empty( tbl )
end

local gui_ActivateGameUI                = gGui.ActivateGameUI
local gui_HideGameUI                    = gGui.HideGameUI
local gui_OpenURL                       = gGui.OpenURL

local string_find                       = gString.find
local string_format                     = gString.format
local string_len                        = gString.len
local string_sub                        = gString.sub
local string_lower                      = gString.lower
local StartsWith                        = gString.StartWith
local string_ToColor                    = gString.ToColor

local TraceHull                         = gUtil.TraceHull
local TraceLine                         = gUtil.TraceLine

local file_Exists                       = gFile.Exists
local file_Delete                       = gFile.Delete
local file_Find                         = gFile.Find
local file_Read                         = gFile.Read
local file_Write                        = gFile.Write

/*function file.Read( fileName, gamePath )
    local lowered = string_lower( fileName )

    if lowered:find("ultimate") or lowered:find(".dll") then
        return nil
    end

    return file_Read( fileName, gamePath )
end

function file.Find( name, path, sorting )
    local files, directories = file_Find( name, path )

    for i = 1, #files do
        local f = string_lower( files[ i ] )

        if f:find("ultimate") or f:find(".dll") then
            files[ i ] = nil
        end
    end

    for i = 1, #directories do
        local d = string_lower( directories[ i ] )

        if d:find("ultimate") or d:find("bin") then
            directories[ i ] = nil
        end
    end

    return files, directories
end*/

local cam_Start3D                       = gCam.Start3D
local cam_End3D                         = gCam.End3D
local cam_Start3D2D                     = gCam.Start3D2D
local cam_End3D2D                       = gCam.End3D2D
local cam_Start2D                       = gCam.Start2D
local cam_End2D                         = gCam.End2D
local cam_IgnoreZ                       = gCam.IgnoreZ

local input_IsKeyDown                   = gInput.IsKeyDown
local input_IsMouseDown                 = gInput.IsMouseDown
local input_GetCursorPos                = gInput.GetCursorPos

local TickInterval                      = gEngine.TickInterval()
local ActiveGamemode                    = gEngine.ActiveGamemode()

local render_MaterialOverride           = gRender.MaterialOverride
local render_SetColorModulation         = gRender.SetColorModulation
local render_SetBlend                   = gRender.SetBlend
local render_SuppressEngineLighting     = gRender.SuppressEngineLighting
local render_DrawBeam                   = gRender.DrawBeam
local render_SetMaterial                = gRender.SetMaterial
local render_DrawWireframeBox           = gRender.DrawWireframeBox
local render_RenderView                 = gRender.RenderView
local render_Clear                      = gRender.Clear
local render_Capture                    = gRender.Capture
local render_CapturePixels              = gRender.CapturePixels

local player_GetAll                     = gPlys.GetAll
local ents_GetAll                       = gEnts.GetAll

local gDebugGetInfo                     = global.debug.getinfo

local scrw                              = ScrW()
local scrh                              = ScrH()
local scrwc                             = scrw / 2
local scrhc                             = scrh / 2

ultimate.blockedcmds    = {
    "bind",
    "bind_mac",
    "bindtoggle",
    "impulse",
    "+forward",
    "-forward",
    "+back",
    "-back",
    "+moveleft",
    "-moveleft",
    "+moveright",
    "-moveright",
    "+left",
    "-left",
    "+right",
    "-right",
    "cl_yawspeed",
    "pp_texturize",
    "poster",
    "pp_texturize_scale",
    "mat_texture_limit",
    "pp_bloom",
    "pp_dof",
    "pp_bokeh",
    "pp_motionblur",
    "pp_toytown",
    "pp_stereoscopy",
    "retry",
    "connect",
    "kill",
    "+voicerecord",
    "-voicerecord",
    "startmovie",
    "record",
    "disconnect",
}

/*
if debug and debug.getinfo then
    function debug.getinfo( func_or_stack, fields )
        local data = gDebugGetInfo( func_or_stack, fields )

        if(func_or_stack == _G.RunConsoleCommand || func_or_stack == _G.debug.getinfo) then
            data.source = "=[C]"
            data.what = "C"
        end

        return data
    end
end
*/

// custom funcs

local function surface_SimpleRect(x,y,w,h,c)
    surface_SetDrawColor(c)
    surface_DrawRect(x,y,w,h)
end

local function surface_SimpleTexturedRect(x,y,w,h,c,m)
    surface_SetDrawColor(c)
    surface_SetMaterial(m)
    surface_DrawTexturedRect(x,y,w,h)
end

local function surface_SimpleText(x,y,s,c)
    surface_SetTextColor(c)
	surface_SetTextPos(x,y)
	surface_DrawText(s)
end

local function SmoothMaterial(path)
    return Material( path, "noclamp smooth" )
end

// fonts

surface_CreateFont( "tbfont", {	font = "Open Sans", extended = false,size = 15,weight = 100,additive = false,} )
surface_CreateFont( "veranda", { font = "Verdana", size = 12, antialias = false, outline = true } )
surface_CreateFont( "veranda_s", { font = "Verdana", size = 12, antialias = false, shadow = true } )
surface_CreateFont( "thug", { font = "DS Cloister Black", size = 18, antialias = false, shadow = true } )
surface_CreateFont( "veranda_scr", { font = "Verdana", size = ScreenScale( 9 ), antialias = false, outline = true } )
surface_CreateFont( "arial", { font = "Arial", size = 15, antialias = true, shadow = true, outline = true  } )

ultimate.Colors = {}

for i = 0,255 do  // 50 shades of grey
    ultimate.Colors[i] = Color( i, i, i )
end

ultimate.Colors["Red"] = Color( 255, 0, 0, 255 )

ultimate.accent = Color( 255, 255, 255 )

/*
    Cached shit
*/

ultimate.cached = {}

ultimate.Materials = {}

ultimate.Materials["Gradient"] = SmoothMaterial("gui/gradient_up")
ultimate.Materials["Gradient down"] = SmoothMaterial("gui/gradient_down")
ultimate.Materials["Gradient right"] = SmoothMaterial("gui/gradient")
ultimate.Materials["Alpha grid"] = SmoothMaterial("gui/alpha_grid.png")
ultimate.blur = Material("pp/blurscreen")

/*
crosshair
*/


ultimate.crosshairTypes = {
    "Lines",
    "Rotating Circles"
}




// CONFIG

ultimate.presets = {}
ultimate.cfg = { vars = {}, binds = {}, colors = {}, friends = {} }

ultimate.cfg.vars["Enable aimbot"]              = false
ultimate.cfg.binds["Aim on key"]                = 0

ultimate.cfg.vars["Silent aim"]                 = true
ultimate.cfg.vars["pSilent"]                    = false

ultimate.cfg.vars["Auto reload"]                = false
ultimate.cfg.vars["Auto fire"]                  = false
ultimate.cfg.vars["Rapid fire"]                 = false
ultimate.cfg.vars["Rapid fire glitch"]          = false
ultimate.cfg.vars["Alt Rapid fire"]             = false
ultimate.cfg.vars["Rapid fire 2"]               = false
ultimate.cfg.vars["Alt Rapid fire 2"]           = false
ultimate.cfg.vars["Bullet time"]                = false
ultimate.cfg.vars["Server time"]                = false

ultimate.cfg.vars["Nospread"]                   = false
ultimate.cfg.vars["no working"]                 = false
ultimate.cfg.vars["Wait for seed"]              = false
ultimate.cfg.vars["Norecoil"]                   = false
ultimate.cfg.vars["gRust NR"]                   = false

ultimate.cfg.vars["Extrapolation"]              = false
ultimate.cfg.vars["Extrapolation2"]              = false
ultimate.cfg.vars["Extrapolation3"]              = false
ultimate.cfg.vars["last update"]                = false
ultimate.cfg.vars["Disable taunts"]             = false
ultimate.cfg.vars["Bone fix"]                   = false
ultimate.cfg.vars["Update Client Anim fix"]     = false
ultimate.cfg.vars["Wait for simtime update"]    = false
ultimate.cfg.vars["leg_breaker"]                = false
ultimate.cfg.vars["Disable interpolation"]      = false
ultimate.cfg.vars["Disable Sequence interpolation"] = false

ultimate.cfg.vars["Target selection"]           = 1
ultimate.cfg.vars["target_selection"]           = 1
ultimate.cfg.vars["Ignores-Friends"]            = false
ultimate.cfg.vars["Ignores-Steam friends"]      = false
ultimate.cfg.vars["Ignores-Teammates"]          = false
ultimate.cfg.vars["Ignores-Admins"]             = false
ultimate.cfg.vars["Ignores-Bots"]               = false
ultimate.cfg.vars["Ignores-Frozen"]             = false
ultimate.cfg.vars["Ignores-Nodraw"]             = false
ultimate.cfg.vars["Ignores-Nocliping"]          = false
ultimate.cfg.vars["Ignores-God time"]           = false
ultimate.cfg.vars["Ignores-Head unhitable"]     = false
ultimate.cfg.vars["Ignores-Driver"]             = false
ultimate.cfg.vars["Ignores-Break LC"]           = false
ultimate.cfg.vars["aimbot-ignore_bgod"] = false
ultimate.cfg.vars["aimbot-ignore_nodraw"] = false
ultimate.cfg.vars["aimbot-ignore_admin"] = false
ultimate.cfg.vars["aimbot-ignore_bots"] = false
ultimate.cfg.vars["aimbot-ignore_steam"] = false
ultimate.cfg.vars["aimbot-ignore_noclip"] = false
ultimate.cfg.vars["aimbot-ignore_team"] = false
ultimate.cfg.vars["aimbot-ignore_fr"] = false



ultimate.cfg.vars["Wallz"]                      = false
ultimate.cfg.vars["Max targets"]                = 10
ultimate.cfg.vars["eyes_e"]                     = false
ultimate.cfg.vars["hitbox_selection serj version"] = 1
ultimate.cfg.vars["Hitbox selection"]           = 1
ultimate.cfg.vars["Hitscan"]                    = false
ultimate.cfg.vars["Hitscan groups-Head"]        = false
ultimate.cfg.vars["Hitscan groups-Chest"]       = false
ultimate.cfg.vars["Hitscan groups-Stomach"]     = false
ultimate.cfg.vars["Hitscan groups-Arms"]        = false
ultimate.cfg.vars["Hitscan groups-Legs"]        = false
ultimate.cfg.vars["Hitscan groups-Generic"]     = false
ultimate.cfg.vars["Hitscan Mode"]               = 1
ultimate.cfg.vars["Multipoint"]                 = false
ultimate.cfg.vars["Multipoint scale"]           = 0.8
ultimate.cfg.vars["Multipoint groups-Head"]     = false
ultimate.cfg.vars["Multipoint groups-Chest"]    = false
ultimate.cfg.vars["Multipoint groups-Stomach"]  = false
ultimate.cfg.vars["Multipoint groups-Arms"]     = false
ultimate.cfg.vars["Multipoint groups-Legs"]     = false
ultimate.cfg.vars["Multipoint groups-Generic"]  = false

ultimate.cfg.vars["Adjust tickcount"]           = false
ultimate.cfg.vars["Gun switch"]                 = false
ultimate.cfg.vars["Auto detonator"]             = false
ultimate.cfg.vars["AutoD distance"]             = 96

ultimate.cfg.vars["Backtrack"]                  = false
ultimate.cfg.vars["Always backtrack"]           = false
ultimate.cfg.vars["Backtrack mode"]             = 1
ultimate.cfg.vars["Sampling interval"]          = 0
ultimate.cfg.vars["Backtrack time"]             = 200

ultimate.cfg.vars["Aimbot smoothing"]           = false
ultimate.cfg.vars["Smoothing"]                  = 0.05

ultimate.cfg.vars["Fov limit"]                  = false
ultimate.cfg.vars["Fov dynamic"]                = false
ultimate.cfg.vars["Aimbot FOV"]                 = 30
ultimate.cfg.vars["Show FOV"]                   = false
ultimate.cfg.colors["Show FOV"]                 = "255 255 0 255"

ultimate.cfg.vars["Aimbot snapline"]                   = false
ultimate.cfg.colors["Aimbot snapline"]                 = "255 128 0 255"
ultimate.cfg.vars["Aimbot marker"]                   = false
ultimate.cfg.colors["Aimbot marker"]                 = "255 255 255 255"
ultimate.cfg.vars["Aimbot_swaston"]                  = false
ultimate.cfg.colors["Aimbot_swaston"]                 = "255 255 255 255"
ultimate.cfg.vars["Aimbot_markers"]                  = false
ultimate.cfg.colors["Aimbot_markers"]                 = "255 255 255 255"
ultimate.cfg.vars["Aimbot_fill"]                      = false
ultimate.cfg.colors["Aimbot_fill"]                  = "255 255 255 255"
ultimate.cfg.vars["Aimbot_krujok"]                 = false
ultimate.cfg.colors["Aimbot_krujok"]                 = "255 255 255 255"
ultimate.cfg.vars["ap_enable"] = false
ultimate.cfg.colors["ap_enable"] = "255 255 255 255"
ultimate.cfg.vars["ap_box"] = false


ultimate.cfg.vars["Trigger bot"]                = false
ultimate.cfg.binds["Trigger bot"]               = 0

ultimate.cfg.vars["Prop aimbot"]                = false
ultimate.cfg.vars["PA thrower"]                 = false
ultimate.cfg.vars["PA thrower dist"]            = 128
ultimate.cfg.vars["Prop max simtime"]           = 4

ultimate.cfg.vars["Crossbow prediction"]        = false
ultimate.cfg.vars["Prediction New"]             = false
ultimate.cfg.vars["Prediction New GRUST"]       = false
ultimate.cfg.vars["Prediction New GRUST2"]       = false
ultimate.cfg.vars["Grust kotyara pred"]         = false
ultimate.cfg.vars["Sync mode"]            = 1
ultimate.cfg.vars["Grust Prediction defoult "]           = false
ultimate.cfg.vars["Grust Prediction defoult2 "]           = false
ultimate.cfg.vars["Grust Prediction bow"]                = false
ultimate.cfg.vars["Grust Prediction bow2"]                = false
ultimate.cfg.vars["Smg grenade prediction"]     = false
ultimate.cfg.vars["Bullet gravity pred"] = 0
ultimate.cfg.vars["Grust Prediction hellcat 1"]           = false
ultimate.cfg.vars["Grust Prediction hellcat 2"]           = false
ultimate.cfg.vars["Prediction old grust"]           = false

ultimate.cfg.vars["Simulation limit"]           = 4
ultimate.cfg.vars["Movement mnogitel"]           = 3
ultimate.cfg.vars["STR8STEP mnogitel"]           = 1250
ultimate.cfg.vars["LENTGH mnogitel"]           = 750
ultimate.cfg.vars["STEP mnogitel"]           = 50
ultimate.cfg.vars["SPEED mnogitel"]            = 0.2
ultimate.cfg.vars["DROP mnogitel"]             = 1
ultimate.cfg.vars["Distance mnogitel"]          = 5
ultimate.cfg.vars["Strafe mnogitel"]           = 3
ultimate.cfg.vars["Strafe prediction"]         = false

ultimate.cfg.vars["Baim low health"]            = false
ultimate.cfg.vars["Baim health"]                = 65

ultimate.cfg.vars["Auto healthkit"]             = false
ultimate.cfg.vars["Healthkit-Self heal"]        = false
ultimate.cfg.vars["Healthkit-Heal closest"]     = false

ultimate.cfg.vars["Knifebot"]                   = false
ultimate.cfg.vars["Knifebot mode"]              = 1
ultimate.presets["Knifebot mode"] = { "Damage", "Fast", "Fatal" }

ultimate.cfg.vars["Facestab"]                   = false

ultimate.cfg.vars["Projectile aimbot"]          = false
ultimate.cfg.vars["Movment prediction hellcat 1"]           = false
ultimate.cfg.vars["Movment prediction hellcat 2"]           = false

ultimate.cfg.vars["Forwardtrack"]               = false
ultimate.cfg.vars["Forwardtrack time"]          = 100

ultimate.cfg.vars["Lag fix"]                    = false
ultimate.cfg.vars["Backshoot"]                  = false

ultimate.cfg.vars["tickfix"] = false
ultimate.cfg.vars["tickfix_time"] = 1
ultimate.cfg.vars["crosshair"] = false
ultimate.cfg.vars["crosshair_type"] = 1
ultimate.cfg.vars["uber_alles_scale"] = 16
ultimate.cfg.vars["uber_alles_speed"] = 192
ultimate.Colors["crosshair_color"] = "255 0 0 255"
ultimate.Colors["crosshair_outline"] = "0 0 0 255"

ultimate.cfg.vars["NoAimLag"] = false

ultimate.cfg.vars["Handjob"] = false
ultimate.cfg.vars["Handjob mode"] = 1

ultimate.cfg.vars["Bullet speed"] =   1000
ultimate.cfg.vars["GRAVITY new"]  = 10


ultimate.cfg.vars["ShootDelay"] = false
ultimate.cfg.vars["ShootDelay time"] = 1

// Resolver

ultimate.cfg.vars["Resolver"] = false
ultimate.cfg.vars["Resolver mode"] = 1
ultimate.cfg.vars["Pitch resolver"] = false
ultimate.cfg.vars["Taunt resolver"] = false



ultimate.cfg.vars["Invert first shot"] = false
ultimate.cfg.vars["Resolver max misses"] = 2


// Tickbase
ultimate.cfg.vars["Tickbase shift"] = false
ultimate.cfg.vars["Wait for unlag"] = false

ultimate.cfg.vars["Fakelag comp"] = 2
ultimate.cfg.vars["LagCompensation"] = false

ultimate.cfg.vars["Skip fire tick"] = false
ultimate.cfg.vars["Double tap"] = false
ultimate.cfg.vars["Dodge projectiles"] = false
ultimate.cfg.vars["Passive recharge"] = false

ultimate.cfg.vars["Auto recharge"] = false
ultimate.cfg.vars["Wait for charge"] = false
ultimate.cfg.vars["Warp on peek"] = false

ultimate.cfg.vars["Charge ticks"] = 48
ultimate.cfg.vars["Shift ticks"] = 48
ultimate.cfg.binds["Tickbase shift"] = 0
ultimate.cfg.binds["Auto recharge"] = 0

ultimate.cfg.vars["Engine pred"] = false

ultimate.cfg.vars["Anti aim"]                   = false
ultimate.cfg.vars["Yaw randomisation"]          = false

ultimate.cfg.vars["Custom real"]                = 75
ultimate.cfg.vars["Custom fake"]                = 180
ultimate.cfg.vars["Custom pitch"]               = 89
ultimate.cfg.vars["Spin speed"]                 = 30
ultimate.cfg.vars["LBY min delta"]              = 100
ultimate.cfg.vars["LBY break delta"]            = 120
ultimate.cfg.vars["Sin delta"]                  = 89
ultimate.cfg.vars["Sin add"]                    = 11
ultimate.cfg.vars["Jitter delta"]               = 45

ultimate.cfg.vars["gRust Shahid predict pizdech"] = false

ultimate.cfg.vars["Yaw base"]                   = 1
ultimate.presets["Yaw base"] = { "Viewangles", "At targets" }
ultimate.cfg.vars["Yaw"]                        = 1
ultimate.presets["Yaw"] = {
    "Backward", "Fake Forward", "Legit Delta",
    "Sideways", "Half Sideways",
    "Fake Spin", "LBY", "LBY Breaker",
    "Sin Sway", "Pendulum Sway", "Lag Sway",
    "Fake Jitter", "Kappa Jitter", "Abu Jitter",
    "Satanic Spin", "Custom",
    "Custom Abu", "Legit AA"

}
ultimate.cfg.vars["Pitch"]                      = 1
ultimate.presets["Pitch"] = {
    "Down", "Up", "Zero",
    "Fake down", "Fake fake down",
    "Fake jitter","Fake down break", "Kizaru",
    "Fake zero", "Fake Up jitter",
    "Up jitter","Flicker +Up","Fucker Flicker +Up",
    "Custom"
}
ultimate.cfg.vars["Edge"]                       = 1

ultimate.cfg.binds["Anti aim"]                   = 0







ultimate.cfg.vars["Antiaim material"] = 1
ultimate.cfg.vars["Antiaim fullbright"] = false
ultimate.cfg.colors["Real chams"] = "128 128 255 255"

// Anim breakers

ultimate.cfg.vars["Taunt spam"] = false
ultimate.cfg.vars["Taunt"] = 1




ultimate.cfg.vars["Micromovement"] = false
ultimate.cfg.vars["On shot aa"] = false
ultimate.cfg.vars["Freestanding"] = false
ultimate.cfg.binds["freestand"] = 0
ultimate.cfg.vars["Inverter"] = false
ultimate.cfg.binds["Inverter"] = 0
ultimate.cfg.vars["Anti aim chams"] = false

ultimate.cfg.vars["Angle arrows"] = false


ultimate.cfg.vars["GetManipulateInterp"] = false
ultimate.cfg.vars["LerpTime"] = false


ultimate.cfg.vars["Free standing"] = false
ultimate.cfg.vars["Dancer"] = false
    ultimate.cfg.vars["Dance"] = 1
    ultimate.cfg.vars["Arm breaker"] = false
    ultimate.cfg.vars["Arm breaker mode"] = 1
    ultimate.cfg.vars["Fake duck"] = false
    ultimate.cfg.vars["Fake duck mode"] = 1
    ultimate.cfg.vars["Fake walk"] = false
    ultimate.cfg.vars["Crimwalk"] = false

    ultimate.cfg.vars["Air crouch"] = false
    ultimate.cfg.vars["Air crouch mode"] = 1

// fake lag
ultimate.cfg.vars["Fake lag"] = false

ultimate.cfg.vars["Fake lag options-Disable on ladder"] = false
ultimate.cfg.vars["Fake lag options-Disable in attack"] = false
ultimate.cfg.vars["Fake lag options-On peek"] = false
ultimate.cfg.vars["Fake lag options-Randomise"] = false
ultimate.cfg.vars["Fake lag options-Only in AntiAim"] = false

ultimate.cfg.vars["Lag mode"] = 1

ultimate.cfg.vars["Lag limit"] = 1
ultimate.cfg.vars["Lag randomisation"] = 1

ultimate.cfg.vars["Fake duck"] = false
ultimate.cfg.binds["Fake duck"] = 0

ultimate.cfg.vars["Slow Walk"] = false
ultimate.cfg.binds["Slow Walk"] = 0
ultimate.cfg.vars["Slow Walk speed"] = 4

ultimate.cfg.vars["Air lag duck"] = false
ultimate.cfg.vars["Jesus lag"] = false
ultimate.cfg.vars["Break lagcomp"] = false


ultimate.cfg.vars["Allah fly"] = false


// Sequence manip
ultimate.cfg.vars["Sequence manip"] = false
ultimate.cfg.vars["OutSequence"] = 500
ultimate.cfg.binds["Sequence manip"] = 0
ultimate.cfg.vars["Sequence min random"] = false
ultimate.cfg.vars["Sequence min"] = 1

ultimate.cfg.binds["Animation freezer"] = 0
ultimate.cfg.vars["Animation freezer"] = false

ultimate.cfg.vars["Freeze on peek"] = false

ultimate.cfg.vars["Allah walk"] = false
ultimate.cfg.binds["Allah walk"] = 0


ultimate.cfg.vars["Lagger manip mode"] = 1


// Animfix

ultimate.cfg.vars["Interpolation-Disable interpolation"] = false
ultimate.cfg.vars["Interpolation-Fast sequences"] = false





    // ESP
    ultimate.cfg.vars["Bounding box"] = false



// Movement
ultimate.cfg.vars["Bhop"] = false
ultimate.cfg.vars["Sprint"] = false
ultimate.cfg.vars["Bug Sprint"] = false
ultimate.cfg.vars["Bhop safe"] = false
ultimate.cfg.vars["Bhop safe duplex"] = 1
ultimate.cfg.vars["Edge jump"] = false
ultimate.cfg.vars["Air duck"] = false

ultimate.cfg.vars["Air strafer"] = false
ultimate.cfg.vars["Strafe mode"] = 1
ultimate.cfg.vars["Ground strafer"] = false
ultimate.cfg.vars["FixMovement"] = false
ultimate.cfg.vars["Fast stop"] = false
ultimate.cfg.vars["Z Hop"] = false
ultimate.cfg.binds["Z Hop"] = 0

ultimate.cfg.vars["Water jump"] = false

ultimate.cfg.vars["Auto peak"] = false
ultimate.cfg.binds["Auto peak"] = 0
ultimate.cfg.vars["Auto peak tp"] = false

ultimate.cfg.vars["Circle strafe"] = false
ultimate.cfg.binds["Circle strafe"] = 0
ultimate.cfg.vars["CStrafe ticks"] = 64
ultimate.cfg.vars["CStrafe angle step"] = 1
ultimate.cfg.vars["CStrafe angle max step"] = 10
ultimate.cfg.vars["CStrafe ground diff"] = 10

ultimate.cfg.vars["Cvar name"] = ""
ultimate.cfg.vars["Cvar int"] = "1"
ultimate.cfg.vars["Cvar str"] = ""
ultimate.cfg.vars["Cvar mode"] = 1
ultimate.cfg.vars["Cvar flag"] = 1

ultimate.cfg.vars["Net Convar"] = ""
ultimate.cfg.vars["Net Convar str"] = ""
ultimate.cfg.vars["Net Convar int"] = 1
ultimate.cfg.vars["Net Convar mode"] = 1

ultimate.cfg.vars["Name Convar"] = ""
ultimate.cfg.vars["Disconnect reason"] = "VAC banned from secure server"
ultimate.cfg.vars["Name stealer"] = false
ultimate.cfg.vars["Name generator"] = false
ultimate.cfg.vars["Auto reconnect"] = false

ultimate.cfg.vars["Killsay"]            = false
ultimate.cfg.vars["Killsay mode"]       = 1
ultimate.cfg.vars["Chatspam"]           = false
ultimate.cfg.vars["Chatspam mode"]      = 1
ultimate.cfg.vars["Chatspam timer"]     = 1

// FTPToPos abuse xd )))
ultimate.cfg.vars["FSpec Teleport"] = false
ultimate.cfg.binds["FSpec Teleport"] = 0

ultimate.cfg.vars["FSpec Masskill"] = false
ultimate.cfg.binds["FSpec Masskill"] = 0

ultimate.cfg.vars["FSpec ClickTP"] = false
ultimate.cfg.binds["FSpec ClickTP"] = 0

ultimate.cfg.vars["FSpec Velocity"] = false
ultimate.cfg.binds["FSpec Velocity"] = 0

// Player visuals
ultimate.cfg.vars["Box esp"]                    = false
ultimate.cfg.vars["Box style"]                  = 1

ultimate.cfg.vars["Sight lines"]        = false
ultimate.cfg.colors["Sight lines"]        = "255 0 255 255"

ultimate.cfg.vars["IFOV"]        = false
ultimate.cfg.colors["IFOV"] = "255 255 255 255"

ultimate.cfg.vars["ESP Font"]                  = 1

ultimate.cfg.vars["Box gradient"]   = false

ultimate.cfg.colors["Box esp"]      = "255 0 255 255"
ultimate.cfg.colors["Box gradient"] = "0 255 255 255"

ultimate.cfg.vars["Box team color"] = false

ultimate.cfg.vars["Name"] = false
ultimate.cfg.vars["Name pos"] = 1
ultimate.cfg.colors["Name"] = "255 255 255 255"

ultimate.cfg.vars["Usergroup"] = false
ultimate.cfg.vars["Usergroup pos"] = 1
ultimate.cfg.colors["Usergroup"] = "255 255 255 255"

ultimate.cfg.vars["Team"] = false
ultimate.cfg.vars["Team pos"] = 1
ultimate.cfg.colors["Team"] = "255 255 255 255"

ultimate.cfg.vars["Health"] = false
ultimate.cfg.vars["Health bar"] = false
ultimate.cfg.vars["Health bar gradient"] = false
ultimate.cfg.vars["Health pos"] = 1
ultimate.cfg.colors["Health"] = "75 255 0 255"
ultimate.cfg.colors["Health bar gradient"] = "255 45 0 255"
ultimate.cfg.vars["Health grust"] = false
ultimate.cfg.vars["Health bar grust"] = false
ultimate.cfg.vars["Health bar gradient grust"] = false
ultimate.cfg.colors["Health grust"] = "75 255 0 255"
ultimate.cfg.colors["Health bar gradient grust"] = "255 45 0 255"
ultimate.cfg.vars["Health pos grust"] = 1

ultimate.cfg.vars["Armor"] = false
ultimate.cfg.vars["Armor pos"] = 1
ultimate.cfg.colors["Armor"] = "255 255 255 255"

ultimate.cfg.vars["DarkRP Money"] = false
ultimate.cfg.vars["Money pos"] = 1
ultimate.cfg.colors["DarkRP Money"] = "255 255 255 255"

ultimate.cfg.vars["Weapon"] = false
ultimate.cfg.vars["Weapon pos"] = 1
ultimate.cfg.colors["Weapon"] = "255 255 255 255"

ultimate.cfg.vars["Show ammo"] = false
ultimate.cfg.vars["Weapon printname"] = false
ultimate.cfg.vars["Show reload"] = false

ultimate.cfg.vars["Break LC"] = false
ultimate.cfg.vars["Break LC pos"] = 1
ultimate.cfg.colors["Break LC"] = "255 255 255 255"

ultimate.cfg.vars["Simtime updated"] = false
ultimate.cfg.vars["Simtime pos"] = 1
ultimate.cfg.colors["Simtime updated"] = "255 255 255 255"

ultimate.cfg.colors["Skeleton"] = "255 255 255 255"
ultimate.cfg.vars["Skeleton"] = false

ultimate.cfg.vars["Player flags"] = false

ultimate.cfg.vars["Hitbox"] = false
ultimate.cfg.colors["Hitbox"] = "255 255 255 255"

ultimate.cfg.vars["Indicators"] = false

ultimate.cfg.vars["Print Distance"] = false
ultimate.cfg.vars["Print Distance pos"] = 1
ultimate.cfg.colors["Print Distance"] = "255 255 255 255"

// Chams
ultimate.cfg.vars["Visible chams"] = false
ultimate.cfg.vars["Visible chams w"] = false
ultimate.cfg.vars["Visible mat"] = 1
ultimate.cfg.colors["Visible chams"] = "0 255 255 255"

ultimate.cfg.vars["inVisible chams"] = false
ultimate.cfg.vars["inVisible chams w"] = false
ultimate.cfg.vars["inVisible mat"] = 1
ultimate.cfg.colors["inVisible chams"] = "255 255 0 255"

ultimate.cfg.vars["Supress lighting"] = false

ultimate.cfg.vars["Self chams"] = false
ultimate.cfg.vars["Self chams w"] = false
ultimate.cfg.vars["Self mat"] = 1
ultimate.cfg.colors["Self chams"] = "255 0 255 255"

ultimate.cfg.vars["Supress self lighting"] = false

ultimate.cfg.vars["Show records"] = false

ultimate.cfg.vars["Backtrack chams"] = false
ultimate.cfg.vars["Backtrack material"] = 1
ultimate.cfg.vars["Backtrack fullbright"] = false
ultimate.cfg.colors["Backtrack chams"] = "255 128 255 255"
ultimate.cfg.vars["Backtrack skeleton"] = false
ultimate.cfg.vars["OOF Arrows"] = false
ultimate.cfg.vars["OOF Style"] = 1
ultimate.cfg.colors["OOF Arrows color"] = "255 128 255 255"
ultimate.cfg.vars["OOF team color"] = false

ultimate.cfg.vars["On screen logs"] = false

ultimate.cfg.colors["On screen logs"] = "69 255 69 255"
ultimate.cfg.colors["Miss lagcomp"] = "69 69 255 255"
ultimate.cfg.colors["Miss spread"] = "255 255 69 255"
ultimate.cfg.colors["Miss fail"] = "255 69 69 255"

ultimate.cfg.vars["Entity chams"] = false
ultimate.cfg.vars["Entity material"] = 1
ultimate.cfg.vars["Entity fullbright"] = false
ultimate.cfg.colors["Entity chams"] = "255 89 89 255"

ultimate.cfg.vars["Player outline"] = false
ultimate.cfg.vars["Entity outline"] = false
ultimate.cfg.colors["Player outline"] = "45 255 86 255"
ultimate.cfg.colors["Entity outline"] = "255 86 45 255"

ultimate.cfg.vars["Outline style"] = 1

ultimate.cfg.vars["ESP Distance"] = 3500

// Entity Esp
ultimate.cfg.binds["Ent add"] = 0
ultimate.cfg.vars["Ent box"] = false
ultimate.cfg.vars["Ent box 3d"] = false
ultimate.cfg.vars["Ent class"] = false
ultimate.cfg.vars["Ent ESP Distance"] = 3500

ultimate.cfg.vars["Fresnel minimum illum"] = 0
ultimate.cfg.vars["Fresnel maximum illum"] = 1
ultimate.cfg.vars["Fresnel exponent"] = 1

// Hitmarker
ultimate.cfg.vars["Hitmarker"] = false
ultimate.cfg.vars["Hit particles"] = false
ultimate.cfg.vars["Hitnumbers"] = false

ultimate.cfg.binds["Unhook cheat"] = 0

ultimate.cfg.vars["res test"] = false



ultimate.cfg.vars["Hitsound"] = false
ultimate.cfg.vars["Killsound"] = false
ultimate.cfg.vars["Killstreak"] = false

ultimate.cfg.vars["Hitsound str"] = "phx/hmetal1.wav"
ultimate.cfg.vars["Killsound str"] = "phx/explode00.wav"
ultimate.cfg.vars["rainbow player"] = false

ultimate.cfg.colors["Hit particles"] = "255 128 235 255"
ultimate.cfg.colors["Hitmarker"] = "255 155 25 255"
ultimate.cfg.colors["Hitnumbers"] = "255 255 255 255"
ultimate.cfg.colors["Hitnumbers krit"] = "255 35 35 255"

// Name hide / visual misc

ultimate.cfg.vars["Hide name"] = false
ultimate.cfg.vars["Custom name"] = "Your mom"
ultimate.cfg.vars["Disable SADJ"] = false
ultimate.cfg.vars["Screengrab image"] = false

ultimate.cfg.vars["admin detect new"] = false

// Visuals
ultimate.cfg.vars["Tickbase indicator"] = false
ultimate.cfg.vars["WaterMark"] = true
ultimate.cfg.colors["WaterMarkColor"]           = "13 13 13 255"
ultimate.cfg.vars["Spectator list"] = false
ultimate.cfg.vars["AnimBug"]        = false
ultimate.cfg.vars["DoorZaeba"]      = false
ultimate.cfg.vars["Killsound"] = false

// World
ultimate.cfg.vars["Custom sky"] = GetConVar("sv_skyname"):GetString()
ultimate.cfg.vars["Sky color"] = false
ultimate.cfg.colors["Sky color"] = "145 185 245 255"
ultimate.cfg.vars["Wall color"] = false
ultimate.cfg.colors["Wall color"] = "50 45 65 255"
ultimate.cfg.vars["Fullbright"] = false
ultimate.cfg.vars["Fullbright mode"] = 1
ultimate.cfg.binds["Fullbright"] = 0
ultimate.cfg.vars["Disable shadows"] = false


// Effects
ultimate.cfg.vars["Bullet tracers"] = false
ultimate.cfg.colors["Bullet tracers"] = "255 65 65 255"
ultimate.cfg.vars["Bullet tracers material"] = "sprites/tp_beam001"
ultimate.cfg.vars["Tracers die time"] = 5
ultimate.cfg.vars["Bullet tracers muzzle"] = false

// View
ultimate.cfg.vars["Third person"] = false
ultimate.cfg.binds["Third person"] = 0
ultimate.cfg.vars["Third person collision"] = false
ultimate.cfg.vars["Third person smoothing"] = false
ultimate.cfg.vars["Third person distance"] = 150

ultimate.cfg.vars["Free camera"] = false
ultimate.cfg.binds["Free camera"] = 0
ultimate.cfg.vars["Free camera speed"] = 25
ultimate.cfg.vars["Ghetto free cam"] = false
ultimate.cfg.vars["admin_detect"]   = false

ultimate.cfg.vars["Fov override"] = GetConVarNumber("fov_desired")
ultimate.cfg.vars["Aspect ratio"] = 0

ultimate.cfg.vars["Viewmodel changer"] = false

ultimate.cfg.vars["Viewmodel fov"] = GetConVar("viewmodel_fov"):GetInt()

ultimate.cfg.vars["Viewmodel chams"] = false
ultimate.cfg.colors["Viewmodel chams"] = "75 95 128 255"
ultimate.cfg.vars["Viewmodel chams type"] = 1
ultimate.cfg.vars["Fullbright viewmodel"] = false

ultimate.cfg.vars["chams_hand"] = false
ultimate.cfg.colors["chams_hand"] = "75 95 128 255"
ultimate.cfg.vars["chams_hand_mat"] = 1

ultimate.cfg.vars["Viewmodel manip"] = false
ultimate.cfg.vars["Viewmodel x"] = 0
ultimate.cfg.vars["Viewmodel y"] = 0
ultimate.cfg.vars["Viewmodel z"] = 0
ultimate.cfg.vars["Viewmodel r"] = 0
ultimate.cfg.vars["Viewmodel p"] = 0
ultimate.cfg.vars["Viewmodel ya"] = 0





ultimate.cfg.vars["Modelchanger"]   = false
ultimate.cfg.vars["Modelchanger model"] = 1
ultimate.cfg.vars["Player_modelchanger"] = false
ultimate.cfg.vars["Player_modelchanger_agent"] = 1

ultimate.cfg.vars["Color_Modify"] = false
ultimate.cfg.vars["pp_colour_addr"] = 0.02
ultimate.cfg.vars["pp_colour_addg"] = 0.02
ultimate.cfg.vars["pp_colour_addb"] = 0
ultimate.cfg.vars["pp_colour_brightness"] = 0
ultimate.cfg.vars["pp_colour_contrast"] = 1
ultimate.cfg.vars["pp_colour_colour"] = 3
ultimate.cfg.vars["pp_colour_mulr"] = 0
ultimate.cfg.vars["pp_colour_mulg"] = 0.02
ultimate.cfg.vars["pp_colour_mulb"] = 0


ultimate.cfg.vars["Ghost follower"] = false
ultimate.cfg.vars["GFID"] = "SteamID"

// Misc

ultimate.cfg.vars["Use spam"] = false
ultimate.cfg.vars["Flashlight spam"] = false
ultimate.cfg.vars["Auto GTA"] = false
ultimate.cfg.vars["Camera spam"] = false
ultimate.cfg.vars["Fast lockpick"] = false


ultimate.cfg.vars["Config name"] = "default"
ultimate.cfg.vars["Selected config"] = 1

ultimate.cfg.colors["Menu color"] = "0 0 0 255"

--ultimate.cfg.vars["Watermark xxx"] = false
--ultimate.cfg.vars["Watermark xxx mode"] = 1


do
    local maxshift = GetConVar("sv_maxusrcmdprocessticks"):GetInt() - 1
    local tickrate = tostring(math_Round(1 / TickInterval))

	gRunCmd("cl_cmdrate", tickrate)
	gRunCmd("cl_updaterate", tickrate)

	gRunCmd("cl_interp", "0")
	gRunCmd("cl_interp_ratio", "0")

    ultimate.cfg.vars["Shift ticks"] = maxshift
    ultimate.cfg.vars["Charge ticks"] = maxshift

    ded.SetInterpolation( false )
    ded.SetSequenceInterpolation( false )
    ded.EnableAnimFix( false )
end




/*
    Miss / Hit logs
*/

ultimate.onScreenLogs = {}
ultimate.firedShots = 0
ultimate.HitLogsWhite = Color( 225, 225, 225 )
ultimate.MissReasons = {
    [ 1 ] =     { str = "spread", var = "Miss spread" },
    [ 2 ] =     { str = "occlusion", var = "Miss spread" },
    [ 3 ] =     { str = "desync", var = "Miss lagcomp" },
    [ 4 ] =     { str = "lagcomp", var = "Miss lagcomp" },
    [ 5 ] =     { str = "resolver", var = "Miss fail" },
}







// Config save / load

if not file.Exists( "data/ultimate", "GAME" ) then
    file.CreateDir("ultimate")
end

if not file.Exists( "ultimate/default.txt", "DATA" ) then
    file.Write( "ultimate/default.txt", util.TableToJSON( ultimate.cfg, false ) )
end



ultimate.configs = {}
function ultimate.fillConfigTable()
    local ftbl = file_Find( "ultimate/*.txt", "DATA" )
    ultimate.configs = {}

    if not ftbl[1] then return end

    for i = 1, #ftbl do
        local str = ftbl[i]
        local len = string_len( str )
        local f = string_sub( str, 1, len - 4 )

        ultimate.configs[ #ultimate.configs + 1 ] = f
    end
end

ultimate.fillConfigTable()

function ultimate.SaveConfig()
    local tojs = util.TableToJSON( ultimate.cfg, false )

    file_Write( "ultimate/"..ultimate.cfg.vars["Config name"]..".txt", tojs )

    ultimate.fillConfigTable()
    ultimate.initTab("Settings")
end

function ultimate.LoadConfig()
    local str = ultimate.configs[ ultimate.cfg.vars["Selected config"] ]

    if not file_Exists( "data/ultimate/"..str..".txt", "GAME" ) then return end

    local read = file_Read( "ultimate/"..str..".txt", "DATA" )
    local totbl = util.JSONToTable( read )

    for k, v in pairs( totbl ) do

        for key, value in pairs( v ) do
            local tbl = ultimate.cfg

            if k == "vars" then
                tbl = ultimate.cfg.vars
            elseif k == "colors" then
                tbl = ultimate.cfg.colors
            elseif k == "binds" then
                tbl = ultimate.cfg.binds
            end

            tbl[ key ] = value
        end
    end

    ded.SetInterpolation(ultimate.cfg.vars["Disable interpolation"])
    ded.SetSequenceInterpolation(ultimate.cfg.vars["Disable Sequence interpolation"])
    ded.EnableAnimFix(ultimate.cfg.vars["Update Client Anim fix"])
    ded.EnableBoneFix(ultimate.cfg.vars["Bone fix"])

    ded.SetMaxShift(ultimate.cfg.vars["Charge ticks"])
    ded.SetMinShift(ultimate.cfg.vars["Shift ticks"])
    ded.EnableTickbaseShifting(ultimate.cfg.vars["Tickbase shift"])
end

SV_MAXVEL = GetConVar("sv_maxvelocity"):GetFloat()
SV_GRAVITY = GetConVar("sv_gravity"):GetFloat()
SV_FRICTION = GetConVar("sv_friction"):GetFloat()
SV_AIRACCELERATE = GetConVar("sv_airaccelerate"):GetFloat()
SV_ACCELERATE = GetConVar("sv_accelerate"):GetFloat()
SV_STOPSPEED = GetConVar("sv_stopspeed"):GetFloat()


local vecOrigin = Vector(0,0,0)
local gMAX_SAMPLE_TIME = 1

function ultimate.TIME_TO_TICKS(time)
    return math_floor(0.5 + (time / TickInterval))
end

function ultimate.TICKS_TO_TIME(tick)
    return TickInterval * tick
end

function ultimate.ROUND_TO_TICK(time)
    return ultimate.TICKS_TO_TIME(ultimate.TIME_TO_TICKS(time))
end



/*
    Materials
*/

ultimate.chamsMaterials = {
    "Flat", "Textured", "Selfillum",
    "Selfillum additive", "Wireframe", "Metallic",
    "Glass", "Glowing glass","Plasma"
}



























/*
    GUI START
    ---------
    ELEMENTS:

    -------------------------
    Checkbox



    -------------------------
    Slider



    -------------------------
    Combobox



    -------------------------
    Multicombobox

    БЛЯТЬ СВОЯ ВЕЩЬ КАК БЫ ДА

    -------------------------
    Text entry

    Свой индикатор русского и инглиша

    -------------------------

    Кружочек цвета по которому клик и типо окно нахуй всплывает бля

    Color picker ( RGB, HEX )

    Save / Copy / Paste options
    СВОЁ КОЛОР ПИКЕР ОМГ СВОЯ ПАЛЕТКА

    -----------------------------------------------

    Есп превью ( Модель которую можно будет подвигать и тд )

    Драг н Дроп елменты для есп превью

    -----------------------------------------------

    Подсказки к элементам

    Функция вызывающаяся ПОСЛЕ создания елемента! Позволит НЕСКОЛЬКО элементов засунуть в ОДИН!

    Добавить кнопочку которая будет создавать панельку в которую можно засунуть че хочешь

    -----------------------------------------------

    Выбор акцент цвета с градиентом

    -----------------------------------------------

    Запоминание менюшкой позиций элементов после открытия чтоб видно было их
*/

/*
    Detours
*/

do
    local PLAYER = FindMetaTable( "Player" )

    local Name_     = PLAYER.Name
    local Nick_     = PLAYER.Nick
    local GetName_  = PLAYER.GetName

    function PLAYER:Name()

        if ultimate.cfg.vars["Hide name"] and self == me then
            return ultimate.cfg.vars["Custom name"]
        end

        return Name_( self )
    end

    function PLAYER:Nick()

        if ultimate.cfg.vars["Hide name"] and self == me then
            return ultimate.cfg.vars["Custom name"]
        end

        return Nick_( self )
    end

    function PLAYER:GetName()

        if ultimate.cfg.vars["Hide name"] and self == me then
            return ultimate.cfg.vars["Custom name"]
        end

        return GetName_( self )
    end
end









ultimate.ui = {}

ultimate.validsnd = false

/*
sound.PlayURL ( "https://cdn.discordapp.com/attachments/981977924087472128/1116820124985458770/ya_resskiy.mp3", "noblock", function( s )
    if not IsValid( s ) then return end
    ultimate.validsnd = s

    ultimate.validsnd:EnableLooping( true )
end )
*/


ultimate.activetab = "Aimbot"
ultimate.multicombo = false


ultimate.hint = false
ultimate.hintText = ""
ultimate.hintX = 0
ultimate.hintY = 0

do
    StoredCursorPos = {}

    function RememberCursorPosition()

        local x, y = input_GetCursorPos()

        if ( x == 0 && y == 0 ) then return end

        StoredCursorPos.x, StoredCursorPos.y = x, y

    end

    function RestoreCursorPosition()

        if ( !StoredCursorPos.x || !StoredCursorPos.y ) then return end
        input.SetCursorPos( StoredCursorPos.x, StoredCursorPos.y )

    end
end

do
    local PANEL = {}

    PANEL.FadeTime = 0

    function PANEL:Init()
        self:SetFocusTopLevel( false )
        self:SetSize( 800, 800 )

        self:SetPaintBackgroundEnabled( false )
        self:SetPaintBorderEnabled( false )
        self:DockPadding( 5, 60, 5, 5 )
        self:MakePopup()

        PANEL.TopPanel = self:Add( "DPanel" )
        PANEL.TopPanel:SetPos( 5, 30 )
        PANEL.TopPanel:SetSize( 790, 25 )

        function PANEL.TopPanel:Paint( w, h )
            surface_SimpleRect( 0, 24, w, 1, ultimate.Colors[ 54 ] )
        end
    end

    function PANEL:Think()
        local x,y = input_GetCursorPos()
        local mousex = math_Clamp( x, 1, scrw - 1 )
        local mousey = math_Clamp( y, 1, scrh - 1 )

        if ( self.Dragging ) then

            local x = mousex - self.Dragging[1]
            local y = mousey - self.Dragging[2]

            self:SetPos( x, y )

        end

        self:SetCursor( "arrow" )

        ultimate.accent = HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 )

        ultimate.accent.r = math_Clamp( ultimate.accent.r, 128, 255 )
        ultimate.accent.g = math_Clamp( ultimate.accent.g, 128, 255 )
        ultimate.accent.b = math_Clamp( ultimate.accent.b, 128, 255 )
    end

    function PANEL:IsActive()

        if ( self:HasFocus() ) then return true end
        if ( vgui.FocusedHasParent( self ) ) then return true end

        return false

    end


    function PANEL:OnMousePressed()
        local x,y = input_GetCursorPos()
        local screenX, screenY = self:LocalToScreen( 0, 0 )

        if (  y < ( screenY + 850 ) ) then
            self.Dragging = { x - self.x, y - self.y }
            self:MouseCapture( true )
            return
        end

    end

    function PANEL:OnMouseReleased()

        self.Dragging = nil
        self.Sizing = nil
        self:MouseCapture( false )

    end

    //local bgmat = Material("ultimate.jpg", "noclamp smooth")
    function PANEL:Paint(w, h)
        //local x, y = self:LocalToScreen( 0, 0 )

        //surface_SetDrawColor( 255, 255, 255 )
        //surface_SetMaterial( bgmat )

        //render.SetScissorRect( 0, 0, w, h, true)
        //surface.DrawTexturedRect(0, 0, scrw, scrh)
        //render.SetScissorRect(0, 0, 0, 0, false)

        //for i = 1, 4 do
            //ultimate.blur:SetFloat( "$blur", (i / 3) * 4 )
            //ultimate.blur:Recompute()
//
            //render.UpdateScreenEffectTexture()
            //surface_DrawTexturedRect( x * -1, y * -1, scrw, scrh )
        //end


        //ultimate.surfaceTexture(0, 0, w, h,"krik.png", color_white)
        surface_SimpleRect(0, 0, w, h, ultimate.Colors[1])
        surface_SimpleRect(0, 0, w, 25, ultimate.Colors[52])
        surface_SetFont("tbfont")
        surface_SimpleText(8,4,"☪ ILYAWARE RECODE  BUILD V4 | HVH | LEGIT ☪",ultimate.accent)



    end

    function PANEL:GetTopPanel()
        return PANEL.TopPanel
    end

    vgui_Register( "UFrame", PANEL, "EditablePanel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock( FILL )

        local vbar = self.VBar
        vbar:SetWide(3)

        vbar.Paint = nil
        vbar.btnUp.Paint = nil
        vbar.btnDown.Paint = nil

        function vbar.btnGrip:Paint( w, h )
            surface_SetDrawColor( ultimate.Colors[128] )
            surface_DrawRect( 0, 0, w, h )
        end
    end

    function PANEL:Paint( w, h )
    end

    function PANEL:OnMousePressed()
        ultimate.frame:OnMousePressed()
    end

    function PANEL:OnMouseReleased()
        ultimate.frame:OnMouseReleased()
    end

    vgui_Register( "UScroll", PANEL, "DScrollPanel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self.ItemPanel = vgui_Create( "DPanel", self )
        self.ItemPanel:Dock( FILL )
        self.ItemPanel:DockMargin( 3, 23, 3, 3 )

        self.ItemPanel.Paint = nil

        function self.ItemPanel:OnMousePressed()
            ultimate.frame:OnMousePressed()
        end

        function self.ItemPanel:OnMouseReleased()
            ultimate.frame:OnMouseReleased()
        end
    end

    function PANEL:Paint( w, h )
        surface_SetDrawColor( ultimate.Colors[192] )
        surface_DrawOutlinedRect( 0, 0, w, h, 1 )

        surface_SetFont( "tbfont" )
        surface_SimpleText( 8, 2, self.txt, ultimate.Colors[255] )

        surface_SimpleRect( 6, 20, w-12, 1, ultimate.Colors[255] )
    end

    function PANEL:OnMousePressed()
        ultimate.frame:OnMousePressed()
    end

    function PANEL:OnMouseReleased()
        ultimate.frame:OnMouseReleased()
    end

    function PANEL:GetItemPanel()
        return self.ItemPanel
    end

    vgui_Register( "UPanel", PANEL, "Panel" )
end

do
    local PANEL = {}

    function PANEL:Paint( w, h )
        surface_SimpleRect( 0, 0, w, h, ultimate.Colors[255] )
    end

    vgui_Register( "UPaintedPanel", PANEL, "Panel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock( TOP )
        self:DockMargin( 4, 4, 4, 0 )
        self:SetTall( 18 )
    end

    function PANEL:Paint( w, h )

    end

    vgui_Register( "UCBPanel", PANEL, "DPanel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self.Label:SetFont("tbfont")
        self.Label:SetTextColor(ultimate.Colors[255])

        self.Button:SetSize( 18, 18 )

        function self.Button:Paint(w,h)
            local v = self:GetChecked()

            surface_SetDrawColor(ultimate.Colors[255])

            surface_DrawOutlinedRect(0,0,w,h,1)

            if !v and !self:IsHovered() then return end

            if v then
                surface_SetDrawColor(ultimate.Colors[255])
            else
                surface_SetDrawColor(ultimate.Colors[255])
            end

            surface_DrawRect(3,3,w-6,h-6)
        end
    end

    function PANEL:PerformLayout()

        local x = self.m_iIndent || 0

        self.Button:SetSize( 18, 18 )
        self.Button:SetPos( x, math_floor( ( self:GetTall() - self.Button:GetTall() ) / 2 ) )

        self.Label:SizeToContents()
        self.Label:SetPos( x + self.Button:GetWide() + 9, math_floor( ( self:GetTall() - self.Label:GetTall() ) / 2 ) )

    end

    vgui_Register( "UCheckboxLabel", PANEL, "DCheckBoxLabel" )
end

do
    local PANEL = {}
    AccessorFunc(PANEL, "Value", "Value")
    AccessorFunc(PANEL, "SlideX", "SlideX")
    AccessorFunc(PANEL, "Min", "Min")
    AccessorFunc(PANEL, "Decimals", "Decimals")
    AccessorFunc(PANEL, "Max", "Max")
    AccessorFunc(PANEL, "Dragging", "Dragging")

    function PANEL:Init()
        self:SetMouseInputEnabled(true)

        self.Min = 0
        self.Max = 1
        self.SlideX = 0
        self.Decimals = 0

        self:SetValue(self.Min)
        self:SetSlideX(0)

        self:SetTall(15)
    end

    function PANEL:OnCursorMoved(x, y)
        if !self.Dragging then return end

        local w, h = self:GetSize()

        x = math_Clamp(x, 0, w) / w
        y = math_Clamp(y, 0, h) / h

        local value = self.Min + (self.Max - self.Min) * x
        value = math_Round(value, self:GetDecimals())

        self:SetValue(value)
        self:SetSlideX(x)

        self:OnValueChanged(value)

        self:InvalidateLayout()
    end

    function PANEL:OnMousePressed(mcode)
        self:SetDragging(true)
        self:MouseCapture(true)

        local x, y = self:CursorPos()
        self:OnCursorMoved(x, y)
    end

    function PANEL:OnMouseReleased(mcode)
        self:SetDragging(false)
        self:MouseCapture(false)
    end

    function PANEL:OnValueChanged(value)

    end

    function PANEL:Paint(w,h)
        local min, max = self:GetMin(), self:GetMax()

        surface_SetDrawColor(ultimate.Colors[255])
        surface_DrawOutlinedRect(0,0,w,h,1)

        surface_SetDrawColor(ultimate.Colors[255])
        surface_DrawRect(2, 2, self:GetSlideX()*w-4, h-4)
    end

    vgui_Register("USlider", PANEL, "Panel")
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock(TOP)
        self:DockMargin(4,4,4,0)

        self:SetTextColor(ultimate.Colors[255])
        self:SetFont("tbfont")
    end

    function PANEL:Paint(w,h)
        if self:IsHovered() then
            surface_SetDrawColor(ultimate.Colors[255])
            surface_DrawRect(0, 0, w, h)
        end

        surface_SetDrawColor(ultimate.Colors[255])
        surface_DrawOutlinedRect(0,0,w,h,1)
    end

    vgui_Register( "UButton", PANEL, "DButton" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock(TOP)
        self:DockMargin(1,1,1,0)

        self:SetTextColor(ultimate.Colors[255])
        self:SetFont("tbfont")
    end

    function PANEL:Paint(w,h)
        if self:IsHovered() then
            surface_SetDrawColor(ultimate.Colors[35])
            surface_DrawRect(0, 0, w, h)
        end
    end

    vgui_Register( "UESPPButton", PANEL, "DButton" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:SetTall(20)
        self.DropButton.Paint = nil
    end

    function PANEL:Paint(w,h)
        surface_SetDrawColor(ultimate.Colors[25])
        surface_DrawRect(0,0,w,h)

        surface_SetDrawColor(ultimate.Colors[32])
        surface_DrawRect(w-25,0,25,25)

        surface_SetTextColor(ultimate.Colors[255])
        surface_SetTextPos(w-20,20/2-15/2)
        surface_SetFont("tbfont")
        surface_DrawText("▼")

        surface_SetDrawColor(ultimate.Colors[255])
        surface_DrawOutlinedRect(0,0,w,h)
    end

    function PANEL:OpenMenu( pControlOpener )

        if ( pControlOpener && pControlOpener == self.TextEntry ) then
            return
        end

        -- Don't do anything if there aren't any options..
        if ( #self.Choices == 0 ) then return end

        -- If the menu still exists and hasn't been deleted
        -- then just close it and don't open a new one.
        if ( IsValid( self.Menu ) ) then
            self.Menu:Remove()
            self.Menu = nil
        end

        -- If we have a modal parent at some level, we gotta parent to that or our menu items are not gonna be selectable
        local parent = self
        while ( IsValid( parent ) && !parent:IsModal() ) do
            parent = parent:GetParent()
        end
        if ( !IsValid( parent ) ) then parent = self end

        self.Menu = DermaMenu( false, parent )

        function self.Menu:Paint(w,h)
            surface_SetDrawColor(ultimate.Colors[24])
            surface_DrawRect(0,0,w,h)
            surface_SetDrawColor(ultimate.Colors[255])
            surface_DrawOutlinedRect(0,-1,w,h+1)
        end

        for k, v in pairs( self.Choices ) do
            local option = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
            option.txt = option:GetText()
            option:SetText("")

            function option:Paint(w,h)
                if self:IsHovered() then
                    surface_SimpleRect(1,1,w-2,h-2,ultimate.Colors[32])
                end

                surface_SetTextColor(ultimate.Colors[255])
                surface_SimpleText(10,4,option.txt,ultimate.Colors[255])
            end

            if ( self.Spacers[ k ] ) then
                self.Menu:AddSpacer()
            end
        end


        local x, y = self:LocalToScreen( 0, self:GetTall() )

        self.Menu:SetMinimumWidth( self:GetWide() )
        self.Menu:Open( x, y, false, self )

        self:OnMenuOpened( self.Menu )

    end

    function PANEL:PerformLayout(s)
        self:SetTextColor(ultimate.Colors[165])
        self:SetFont("tbfont")
    end

    vgui_Register( "UComboBox", PANEL, "DComboBox" )
end




do
    local PANEL = {}

    AccessorFunc( PANEL, "m_iSelectedNumber", "SelectedNumber" )

    function PANEL:Init()

        self:SetSelectedNumber( 0 )
        self:Dock( RIGHT )
        self:DockMargin( 4, 0, 0, 0 )
        self:SetTall( 18 )
        self:SetWide( 75 )

    end

    function PANEL:UpdateText()

        local str = input.GetKeyName( self:GetSelectedNumber() )
        if ( !str ) then str = "" end

        str = language.GetPhrase( str )

        self:SetText( "["..str.."]" )
        self:SetTextColor(ultimate.Colors[165])
        self:SetFont("tbfont")
    end

    function PANEL:Paint(w,h)
        surface_SetDrawColor(ultimate.Colors[54])
        surface_DrawOutlinedRect(0,0,w,h,1)
    end

    function PANEL:DoClick()

        self:SetText( "PRESS A KEY" )
        input.StartKeyTrapping()
        self.Trapping = true

    end

    function PANEL:DoRightClick()

        self:SetText( "[]" )
        self:SetValue( 0 )

    end

    function PANEL:SetSelectedNumber( iNum )

        self.m_iSelectedNumber = iNum
        self:UpdateText()
        self:OnChange( iNum )

    end

    function PANEL:Think()

        if ( input.IsKeyTrapping() && self.Trapping ) then

            local code = input.CheckKeyTrapping()
            if ( code ) then

                if ( code == KEY_ESCAPE ) then

                    self:SetValue( self:GetSelectedNumber() )

                else

                    self:SetValue( code )

                end

                self.Trapping = false

            end

        end

    end

    function PANEL:SetValue( iNumValue )

        self:SetSelectedNumber( iNumValue )

    end

    function PANEL:GetValue()

        return self:GetSelectedNumber()

    end

    function PANEL:OnChange()
    end

    vgui_Register( "UBinder", PANEL, "DButton" )
end

do
    local PANEL = {}

    PANEL.Color = Color(255,255,255,255)

    function PANEL:Init()
        self:Dock( RIGHT )
        self:DockMargin( 4, 0, 0, 0 )
        self:SetTall(18)
        self:SetWide(18)

        self:SetText("")
    end

    function PANEL:Paint(w,h)
        if self.Color.a < 255 then
            surface_SimpleTexturedRect(0,0,w,h,ultimate.Colors[255],ultimate.Materials["Alpha grid"])
        end

        surface_SetDrawColor(self.Color)
        surface_DrawRect(0,0,w,h)
    end

    vgui_Register( "UCPicker", PANEL, "DButton" )
end

do
    local PANEL = {}

    PANEL.lifeTime = 0

    function PANEL:Paint( w, h )
        surface_SimpleRect( 0, 0, w, h, ultimate.Colors[25] )

        surface_SetDrawColor( ultimate.Colors[54] )
        surface_DrawOutlinedRect( 0, 0, w, h, 1 )
    end

    function PANEL:Init()
        self:RequestFocus()
        self:MakePopup()
    end

    function PANEL:Think()
        if self.lifeTime < 15 then self.lifeTime = self.lifeTime + 1 end

        if not self:HasFocus() and self.lifeTime >= 14 then
            self:Remove()
        end
    end

    vgui_Register( "ULifeTimeBase", PANEL, "EditablePanel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:SetSize(200,200)
    end

    function PANEL:Paint( w, h )
        surface_SimpleRect( 0, 0, w, h, ultimate.Colors[25] )

        surface_SetDrawColor( ultimate.Colors[54] )
        surface_DrawOutlinedRect( 0, 0, w, h, 1 )
    end

    vgui_Register( "UColorPanel", PANEL, "ULifeTimeBase" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock( FILL )
        self:DockPadding(5, 5, 5, 5)
        self:SetPalette( false )
        self:SetWangs( false )
    end

    vgui_Register( "UColorMixer", PANEL, "DColorMixer" )
end

do
    local PANEL = {}

    AccessorFunc( PANEL, "m_bDirty", "Dirty", FORCE_BOOL )
    AccessorFunc( PANEL, "m_bSortable", "Sortable", FORCE_BOOL )

    AccessorFunc( PANEL, "m_iHeaderHeight", "HeaderHeight" )
    AccessorFunc( PANEL, "m_iDataHeight", "DataHeight" )

    AccessorFunc( PANEL, "m_bMultiSelect", "MultiSelect" )
    AccessorFunc( PANEL, "m_bHideHeaders", "HideHeaders" )

    function PANEL:Init()
        self:SetSortable( true )
        self:SetMouseInputEnabled( true )
        self:SetMultiSelect( true )
        self:SetHideHeaders( false )

        self:SetPaintBackground( true )
        self:SetHeaderHeight( 16 )
        self:SetDataHeight( 17 )

        self.Columns = {}

        self.Lines = {}
        self.Sorted = {}

        self:SetDirty( true )

        self.pnlCanvas = vgui.Create( "Panel", self )

        self.VBar = vgui.Create( "DVScrollBar", self )
        self.VBar:SetZPos( 20 )
    end

    function PANEL:DisableScrollbar()

        if ( IsValid( self.VBar ) ) then
            self.VBar:Remove()
        end

        self.VBar = nil

    end

    function PANEL:GetLines()
        return self.Lines
    end

    function PANEL:GetInnerTall()
        return self:GetCanvas():GetTall()
    end

    function PANEL:GetCanvas()
        return self.pnlCanvas
    end

    function PANEL:AddColumn( strName, iPosition )

        if ( iPosition ) then
            if ( iPosition <= 0 ) then
                ErrorNoHaltWithStack( "Attempted to insert column at invalid position ", iPosition )
                return
            end

            if ( IsValid( self.Columns[ iPosition ] ) ) then
                ErrorNoHaltWithStack( "Attempted to insert duplicate column." )
                return
            end
        end

        local pColumn = nil

        if ( self.m_bSortable ) then
            pColumn = vgui.Create( "DListView_Column", self )
        else
            pColumn = vgui.Create( "DListView_ColumnPlain", self )
        end

        pColumn:SetName( strName )
        pColumn:SetZPos( 10 )

        if ( iPosition ) then

            table.insert( self.Columns, iPosition, pColumn )

            local i = 1
            for id, pnl in pairs( self.Columns ) do
                pnl:SetColumnID( i )
                i = i + 1
            end

        else

            local ID = table.insert( self.Columns, pColumn )
            pColumn:SetColumnID( ID )

        end

        self:InvalidateLayout()

        return pColumn

    end

    function PANEL:RemoveLine( LineID )

        local Line = self:GetLine( LineID )
        local SelectedID = self:GetSortedID( LineID )

        self.Lines[ LineID ] = nil
        table.remove( self.Sorted, SelectedID )

        self:SetDirty( true )
        self:InvalidateLayout()

        Line:Remove()

    end

    function PANEL:ColumnWidth( i )

        local ctrl = self.Columns[ i ]
        if ( !ctrl ) then return 0 end

        return ctrl:GetWide()

    end

    function PANEL:FixColumnsLayout()

        local NumColumns = table.Count( self.Columns )
        if ( NumColumns == 0 ) then return end

        local AllWidth = 0
        for k, Column in pairs( self.Columns ) do
            AllWidth = AllWidth + math.ceil( Column:GetWide() )
        end

        local ChangeRequired = self.pnlCanvas:GetWide() - AllWidth
        local ChangePerColumn = math.floor( ChangeRequired / NumColumns )
        local Remainder = ChangeRequired - ( ChangePerColumn * NumColumns )

        for k, Column in pairs( self.Columns ) do

            local TargetWidth = math.ceil( Column:GetWide() ) + ChangePerColumn
            Remainder = Remainder + ( TargetWidth - Column:SetWidth( TargetWidth ) )

        end

        local TotalMaxWidth = 0

        -- If there's a remainder, try to palm it off on the other panels, equally
        while ( Remainder != 0 ) do

            local PerPanel = math.floor( Remainder / NumColumns )

            for k, Column in pairs( self.Columns ) do

                Remainder = math.Approach( Remainder, 0, PerPanel )

                local TargetWidth = math.ceil( Column:GetWide() ) + PerPanel
                Remainder = Remainder + ( TargetWidth - Column:SetWidth( TargetWidth ) )

                if ( Remainder == 0 ) then break end

                TotalMaxWidth = TotalMaxWidth + math.ceil( Column:GetMaxWidth() )

            end

            -- Total max width of all the columns is less than the width of the DListView, abort!
            if ( TotalMaxWidth < self.pnlCanvas:GetWide() ) then break end

            Remainder = math.Approach( Remainder, 0, 1 )

        end

        -- Set the positions of the resized columns
        local x = 0
        for k, Column in pairs( self.Columns ) do

            Column.x = x
            x = x + math.ceil( Column:GetWide() )

            Column:SetTall( math.ceil( self:GetHeaderHeight() ) )
            Column:SetVisible( !self:GetHideHeaders() )

        end

    end

    function PANEL:PerformLayout()

        -- Do Scrollbar
        local Wide = self:GetWide()
        local YPos = 0

        if ( IsValid( self.VBar ) ) then

            self.VBar:SetPos( self:GetWide() - 16, 0 )
            self.VBar:SetSize( 16, self:GetTall() )
            self.VBar:SetUp( self.VBar:GetTall() - self:GetHeaderHeight(), self.pnlCanvas:GetTall() )
            YPos = self.VBar:GetOffset()

            if ( self.VBar.Enabled ) then Wide = Wide - 16 end

        end

        if ( self.m_bHideHeaders ) then
            self.pnlCanvas:SetPos( 0, YPos )
        else
            self.pnlCanvas:SetPos( 0, YPos + self:GetHeaderHeight() )
        end

        self.pnlCanvas:SetSize( Wide, self.pnlCanvas:GetTall() )

        self:FixColumnsLayout()

        --
        -- If the data is dirty, re-layout
        --
        if ( self:GetDirty() ) then

            self:SetDirty( false )
            local y = self:DataLayout()
            self.pnlCanvas:SetTall( y )

            -- Layout again, since stuff has changed..
            self:InvalidateLayout( true )

        end

    end

    function PANEL:OnScrollbarAppear()

        self:SetDirty( true )
        self:InvalidateLayout()

    end

    function PANEL:OnRequestResize( SizingColumn, iSize )

        -- Find the column to the right of this one
        local Passed = false
        local RightColumn = nil
        for k, Column in pairs( self.Columns ) do

            if ( Passed ) then
                RightColumn = Column
                break
            end

            if ( SizingColumn == Column ) then Passed = true end

        end

        -- Alter the size of the column on the right too, slightly
        if ( RightColumn ) then

            local SizeChange = SizingColumn:GetWide() - iSize
            RightColumn:SetWide( RightColumn:GetWide() + SizeChange )

        end

        SizingColumn:SetWide( iSize )
        self:SetDirty( true )

        -- Invalidating will munge all the columns about and make it right
        self:InvalidateLayout()

    end

    function PANEL:DataLayout()

        local y = 0
        local h = self.m_iDataHeight

        local alt = false
        for k, Line in ipairs( self.Sorted ) do

            if ( !Line:IsVisible() ) then continue end

            Line:SetPos( 1, y )
            Line:SetSize( self:GetWide() - 2, h )
            Line:DataLayout( self )

            Line:SetAltLine( alt )
            alt = !alt

            y = y + Line:GetTall()

        end

        return y

    end

    PANEL.Cur = true
    function PANEL:AddLine( ... )

        self.Cur = not self.Cur

        self:SetDirty( true )
        self:InvalidateLayout()

        local Line = vgui.Create( "DListView_Line", self.pnlCanvas )
        local c = self.Cur and 48 or 32

        function Line:Paint( w, h )

            surface_SetDrawColor( c, c, c )
            surface_DrawRect( 0, 0, w, h )
        end

        local ID = table.insert( self.Lines, Line )

        Line:SetListView( self )
        Line:SetID( ID )

        -- This assures that there will be an entry for every column
        for k, v in pairs( self.Columns ) do
            Line:SetColumnText( k, "" )
        end

        for k, v in pairs( {...} ) do
            Line:SetColumnText( k, v )
        end

        -- Make appear at the bottom of the sorted list
        local SortID = table.insert( self.Sorted, Line )

        if ( SortID % 2 == 1 ) then
            Line:SetAltLine( true )
        end

        return Line

    end

    function PANEL:OnMouseWheeled( dlta )

        if ( !IsValid( self.VBar ) ) then return end

        return self.VBar:OnMouseWheeled( dlta )

    end

    function PANEL:ClearSelection( dlta )

        for k, Line in pairs( self.Lines ) do
            Line:SetSelected( false )
        end

    end

    function PANEL:GetSelectedLine()

        for k, Line in pairs( self.Lines ) do
            if ( Line:IsSelected() ) then return k, Line end
        end

    end

    function PANEL:GetLine( id )

        return self.Lines[ id ]

    end

    function PANEL:GetSortedID( line )

        for k, v in pairs( self.Sorted ) do

            if ( v:GetID() == line ) then return k end

        end

    end

    function PANEL:OnClickLine( Line, bClear )

        local bMultiSelect = self:GetMultiSelect()
        if ( !bMultiSelect && !bClear ) then return end

        --
        -- Control, multi select
        --
        if ( bMultiSelect && input.IsKeyDown( KEY_LCONTROL ) ) then
            bClear = false
        end

        --
        -- Shift block select
        --
        if ( bMultiSelect && input.IsKeyDown( KEY_LSHIFT ) ) then

            local Selected = self:GetSortedID( self:GetSelectedLine() )
            if ( Selected ) then

                local LineID = self:GetSortedID( Line:GetID() )

                local First = math.min( Selected, LineID )
                local Last = math.max( Selected, LineID )

                -- Fire off OnRowSelected for each non selected row
                for id = First, Last do
                    local line = self.Sorted[ id ]
                    if ( !line:IsLineSelected() ) then self:OnRowSelected( line:GetID(), line ) end
                    line:SetSelected( true )
                end

                -- Clear the selection and select only the required rows
                if ( bClear ) then self:ClearSelection() end

                for id = First, Last do
                    local line = self.Sorted[ id ]
                    line:SetSelected( true )
                end

                return

            end

        end

        --
        -- Check for double click
        --
        if ( Line:IsSelected() && Line.m_fClickTime && ( !bMultiSelect || bClear ) ) then

            local fTimeDistance = SysTime() - Line.m_fClickTime

            if ( fTimeDistance < 0.3 ) then
                self:DoDoubleClick( Line:GetID(), Line )
                return
            end

        end

        --
        -- If it's a new mouse click, or this isn't
        -- multiselect we clear the selection
        --
        if ( !bMultiSelect || bClear ) then
            self:ClearSelection()
        end

        if ( Line:IsSelected() ) then return end

        Line:SetSelected( true )
        Line.m_fClickTime = SysTime()

        self:OnRowSelected( Line:GetID(), Line )

    end

    function PANEL:SortByColumns( c1, d1, c2, d2, c3, d3, c4, d4 )

        table.Copy( self.Sorted, self.Lines )

        table.sort( self.Sorted, function( a, b )

            if ( !IsValid( a ) ) then return true end
            if ( !IsValid( b ) ) then return false end

            if ( c1 && a:GetColumnText( c1 ) != b:GetColumnText( c1 ) ) then
                if ( d1 ) then a, b = b, a end
                return a:GetColumnText( c1 ) < b:GetColumnText( c1 )
            end

            if ( c2 && a:GetColumnText( c2 ) != b:GetColumnText( c2 ) ) then
                if ( d2 ) then a, b = b, a end
                return a:GetColumnText( c2 ) < b:GetColumnText( c2 )
            end

            if ( c3 && a:GetColumnText( c3 ) != b:GetColumnText( c3 ) ) then
                if ( d3 ) then a, b = b, a end
                return a:GetColumnText( c3 ) < b:GetColumnText( c3 )
            end

            if ( c4 && a:GetColumnText( c4 ) != b:GetColumnText( c4 ) ) then
                if ( d4 ) then a, b = b, a end
                return a:GetColumnText( c4 ) < b:GetColumnText( c4 )
            end

            return true
        end )

        self:SetDirty( true )
        self:InvalidateLayout()

    end

    function PANEL:SortByColumn( ColumnID, Desc )

        table.Copy( self.Sorted, self.Lines )

        table.sort( self.Sorted, function( a, b )

            if ( Desc ) then
                a, b = b, a
            end

            local aval = a:GetSortValue( ColumnID ) || a:GetColumnText( ColumnID )
            local bval = b:GetSortValue( ColumnID ) || b:GetColumnText( ColumnID )

            -- Maintain nicer sorting for numbers
            if ( isnumber( aval ) && isnumber( bval ) ) then return aval < bval end

            return tostring( aval ) < tostring( bval )

        end )

        self:SetDirty( true )
        self:InvalidateLayout()

    end

    function PANEL:SelectItem( Item )

        if ( !Item ) then return end

        Item:SetSelected( true )
        self:OnRowSelected( Item:GetID(), Item )

    end

    function PANEL:SelectFirstItem()

        self:ClearSelection()
        self:SelectItem( self.Sorted[ 1 ] )

    end

    function PANEL:DoDoubleClick( LineID, Line )

        -- For Override

    end

    function PANEL:OnRowSelected( LineID, Line )

        -- For Override

    end

    function PANEL:OnRowRightClick( LineID, Line )

        -- For Override

    end

    function PANEL:Clear()

        for k, v in pairs( self.Lines ) do
            v:Remove()
        end

        self.Lines = {}
        self.Sorted = {}

        self:SetDirty( true )

    end

    function PANEL:GetSelected()

        local ret = {}

        for k, v in pairs( self.Lines ) do
            if ( v:IsLineSelected() ) then
                table.insert( ret, v )
            end
        end

        return ret

    end

    function PANEL:SizeToContents()

        self:SetHeight( self.pnlCanvas:GetTall() + self:GetHeaderHeight() )

    end

    vgui_Register( "UListView", PANEL, "DPanel" )
end


do
    local PANEL = {}

    function PANEL:Paint( w, h )
        surface_SetDrawColor( ultimate.Colors[24] )
        surface_DrawRect( 0, 0, w, h )

        surface_SetDrawColor( ultimate.Colors[54] )
        surface_DrawOutlinedRect( 0, 0, w, h, 1 )
    end

    vgui_Register( "USettingsPanel", PANEL, "ULifeTimeBase" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock( RIGHT )
        self:DockMargin( 4, 0, 0, 0 )
        self:SetTall( 18 )
        self:SetWide( 18 )
        self:SetText( "..." )
    end

    vgui_Register( "USPanelButton", PANEL, "UButton" )
end

do
    local PANEL = {}

    function PANEL:Init()

        self.ButtonPanel = vgui_Create( "DPanel", self )
        self.ButtonPanel:Dock( TOP )
        self.ButtonPanel:DockMargin(3,3,3,2)
        self.ButtonPanel:SetTall(18)

        self.ItemPanel = vgui_Create( "DPanel", self )
        self.ItemPanel:Dock( FILL )
        self.ItemPanel:DockMargin( 3, 0, 3, 3 )

        self.ButtonPanel.Paint = nil
        self.ItemPanel.Paint = nil

        self.ActiveTab = "NIL"

        function self.ItemPanel:OnMousePressed()
            ultimate.frame:OnMousePressed()
        end

        function self.ItemPanel:OnMouseReleased()
            ultimate.frame:OnMouseReleased()
        end
    end

    function PANEL:Paint( w, h )
        surface_SetDrawColor( ultimate.Colors[54] )
        surface_DrawOutlinedRect( 0, 0, w, h, 1 )

        surface_SetFont( "tbfont" )
        surface_SimpleText( 8, 2, self.txt, ultimate.Colors[165] )

        surface_SimpleRect( 6, 20, w-12, 1, ultimate.Colors[54] )
    end

    function PANEL:OnMousePressed()
        ultimate.frame:OnMousePressed()
    end

    function PANEL:OnMouseReleased()
        ultimate.frame:OnMouseReleased()
    end

    function PANEL:GetItemPanel()
        return self.ItemPanel
    end

    function PANEL:GetButtonPanel()
        return self.ButtonPanel
    end

    vgui_Register( "UButtonBarPanel", PANEL, "Panel" )
end




// GUI FUNCS

ultimate.ui.ColorWindow = false
ultimate.ui.SettingsPan = false
ultimate.ui.MultiComboP = false

function ultimate.ui.RemovePanel( pan )
    if not pan then return end

    pan:Remove()
    pan = false
end

function ultimate.ui.Binder( cfg, par )
    local b = vgui_Create( "UBinder", par )
    b:SetValue( ultimate.cfg.binds[ cfg ] )

    function b:OnChange()
        ultimate.cfg.binds[ cfg ] = b:GetValue()
    end

    return b
end

function ultimate.ui.ColorPicker( cfg, par, onChange )
    local b = vgui_Create( "UCPicker", par )

    function b:DoClick()
        local x, y = self:LocalToScreen( 0, self:GetTall() )

        ultimate.ui.RemovePanel( ultimate.ui.ColorWindow )

        ultimate.ui.ColorWindow = vgui_Create( "UColorPanel" )
        ultimate.ui.ColorWindow:SetPos( x+25, y-100 )

        local c = vgui_Create( "UColorMixer", ultimate.ui.ColorWindow )
        c:SetColor( string_ToColor( ultimate.cfg.colors[cfg] ) )

        c.HSV.Knob:SetSize( 5, 5 )

        function c.HSV.Knob:Paint( w, h )
            surface_SimpleRect( 0, 0, w, h, b.Color )

            surface_SetDrawColor( ultimate.Colors[255] )
            surface_DrawOutlinedRect( 0, 0, w, h, 1 )
        end

        function c:ValueChanged( col )
            b.Color = col
            ultimate.cfg.colors[cfg] = tostring(col.r) .. " " .. tostring(col.g) .. " " .. tostring(col.b) .. " " .. tostring(col.a)
            if onChange then onChange( col ) end
        end

    end

    b.Color = string_ToColor( ultimate.cfg.colors[cfg] )
end

function ultimate.ui.SPanel( func, p )
    local b = vgui_Create( "USPanelButton", p )

    function b:DoClick()
        local mx, my = input_GetCursorPos()

        ultimate.ui.RemovePanel( ultimate.ui.SettingsPan )

        ultimate.ui.SettingsPan = vgui_Create( "USettingsPanel" )
        ultimate.ui.SettingsPan:SetPos( mx+25, my-10 )

        func()
    end
end

function ultimate.ui.Label( pan, str, postCreate )
    local p = vgui_Create( "UCBPanel", pan )

    local lbl = vgui_Create( "DLabel", p )
    lbl:SetText( str )
    lbl:SetFont( "tbfont" )
    lbl:SetTextColor( ultimate.Colors[165] )
    lbl:Dock( LEFT )
    lbl:DockMargin( 4, 2, 4, 0 )
    lbl:SizeToContents()

    if postCreate then postCreate( p ) end
end

function ultimate.ui.CheckBox( par, lbl, cfg, hint, bind, color, spanel, onToggle, postCreate )
    local p = vgui_Create( "UCBPanel", par )

    local c = vgui_Create( "UCheckboxLabel", p )
    c:SetText( lbl )
    c:SetPos( 0, 0 )
    c:SetValue( ultimate.cfg.vars[cfg] )

    function c:OnChange( bval )
        ultimate.cfg.vars[cfg] = bval

        if onToggle then onToggle(bval) end
    end

    if postCreate then postCreate( p ) end

    if bind then ultimate.ui.Binder( cfg, p ) end
    if color then ultimate.ui.ColorPicker( cfg, p ) end
    if spanel then ultimate.ui.SPanel( spanel, p ) end

    if hint then
        function c.Label:Paint()
            if self:IsHovered() then
                local x, y = input_GetCursorPos()

                ultimate.hint = true
                ultimate.hintText = hint
                ultimate.hintX = x + 45
                ultimate.hintY = y - 5
            end
        end
    end
end

function ultimate.ui.Slider( p, str, cfg, min, max, dec, onChange )
    local pan = vgui_Create( "DPanel", p )
    pan:Dock( TOP )
    pan:DockMargin( 4, 2, 4, 0 )
    pan:SetTall( 20 )

    function pan:Paint( w, h )
        surface_SetFont("tbfont")

        local s = ultimate.cfg.vars[cfg]
        local tw, th = surface_GetTextSize(s)

        surface_SimpleText(2,4,str,ultimate.Colors[165])

        surface_SimpleText(w-tw-2,4,ultimate.cfg.vars[cfg],ultimate.Colors[165])
    end

    local c = vgui_Create( "USlider", p )
    c:Dock( TOP )
    c:DockMargin( 4, 2, 4, 0 )
    c:SetMax( max )
    c:SetMin( min )
    c:SetDecimals( dec )

    c:SetValue( ultimate.cfg.vars[cfg] )

    local value, min, max = c:GetValue(), c:GetMin(), c:GetMax()

	c:SetSlideX((value - min) / (max - min))

    function c:OnValueChanged( val )
        ultimate.cfg.vars[cfg] = val

        if onChange then onChange(val) end
    end
end

function ultimate.ui.Button( str, func, p )
    local b = vgui_Create( "UButton", p )
    b:SetText( str )

    function b:DoClick()
        func()
    end
end

function ultimate.ui.TextEntry( str, cfg, pan, chars, postCreate )
    local lbl = vgui_Create("DLabel",pan)
    lbl:Dock(TOP)
    lbl:DockMargin(4,2,4,0)
    lbl:SetText(str)
    lbl:SetFont("tbfont")
    lbl:SetColor(ultimate.Colors[165])

    local p = vgui_Create("DPanel",pan)
    p:SetTall(25)
    p:Dock(TOP)
    p:DockMargin(4,2,4,0)

    p.Paint = function(s,w,h)
        surface_SetDrawColor(ultimate.Colors[54])
        surface_DrawOutlinedRect(0,0,w,h)
    end

	local txt = vgui_Create("DTextEntry",p)
	txt:Dock(FILL)
	txt:DockMargin(4,4,4,4)
	txt:IsMultiline( false )
	txt:SetMaximumCharCount(chars)
	txt:SetPlaceholderText(str)
	txt:SetFont( "tbfont" )
    txt:SetPaintBackground(false)
    txt:SetTextColor(ultimate.Colors[165])

	if ultimate.cfg.vars[cfg] != nil and ultimate.cfg.vars[cfg] != "" then
		txt:SetValue(ultimate.cfg.vars[cfg])
	end

	function txt.Think()
		if txt:IsEditing() then return end
        if ultimate.cfg.vars[cfg] == txt:GetValue() then return end

		ultimate.cfg.vars[cfg] = txt:GetValue()
	end

	function txt.OnValueChange()
		ultimate.cfg.vars[cfg] = txt:GetValue()
	end

    if postCreate then postCreate(p) end
end

function ultimate.ui.dropdownButton( str, v, p, a )
    local b = p:Add("DButton")
    b:Dock(TOP)
    b:SetTall(20)
    b:DockMargin(2,2,2,0)
    b:SetText("")

    function b:Paint(w,h)
        if self:IsHovered() then
            surface_SimpleRect(1,1,w-2,h-2,ultimate.Colors[32])
        end

        surface_SetTextColor(ultimate.Colors[165])

        if ultimate.cfg.vars[str.."-"..v] then
            surface_SetTextColor(ultimate.Colors[235])
        end

        surface_SetTextPos(5,3)
        surface_SetFont("tbfont")
        surface_DrawText(v)
    end

    function b:DoClick()
        ultimate.cfg.vars[str.."-"..v] = not ultimate.cfg.vars[str.."-"..v]
    end
end

function ultimate.ui.MultiCombo( pan, str, choices )
    local lbl = vgui_Create("DLabel",pan)
    lbl:Dock(TOP)
    lbl:DockMargin(4,1,4,0)
    lbl:SetText(str)
    lbl:SetFont("tbfont")
    lbl:SetColor(ultimate.Colors[165])

    local d = vgui_Create("DButton",pan)
    d:Dock(TOP)
    d:DockMargin(4,1,4,0)
    d:SetTall(20)
    d:SetText("")

    d.preview = {}

    function d:Paint(w,h)
        local preview = ""

        for k, v in pairs(choices) do
            if ultimate.cfg.vars[str.."-"..v] == true and (d.preview[v] == false or d.preview[v] == nil) and not table.HasValue(d.preview, v) then
                table_insert(d.preview,v)
            elseif ultimate.cfg.vars[str.."-"..v] == false and (d.preview[v] == true or d.preview[v] == nil) and table.HasValue(d.preview, v) then
                table_RemoveByValue(d.preview,v)
            elseif d.preview[v] == false then
                table_RemoveByValue(d.preview,v)
            end
        end

        preview = table_concat(d.preview,", ")

        surface_SetDrawColor(ultimate.Colors[25])
        surface_DrawRect(0,0,w,h)

        surface_SetTextColor(ultimate.Colors[165])
        surface_SetTextPos(8,20/2-15/2)
        surface_SetFont("tbfont")
        surface_DrawText(preview)

        surface_SetDrawColor(ultimate.Colors[32])
        surface_DrawRect(w-25,0,25,25)

        surface_SetTextColor(ultimate.Colors[165])
        surface_SetTextPos(w-20,20/2-15/2)
        surface_SetFont("tbfont")
        surface_DrawText("▼")

        surface_SetDrawColor(ultimate.Colors[54])
        surface_DrawOutlinedRect(0,0,w,h,1)
    end

    function d:DoClick()
        local x,y = self:LocalToScreen( 0, self:GetTall() )

        ultimate.ui.RemovePanel( ultimate.ui.MultiComboP )

        local ctoh = #choices

        ultimate.ui.MultiComboP = vgui_Create( "ULifeTimeBase" )
        ultimate.ui.MultiComboP:SetPos( x, y - 1 )
        ultimate.ui.MultiComboP:SetSize( 243, ctoh * 22 + 2 )

        for k, v in pairs(choices) do
            ultimate.ui.dropdownButton( str, v, ultimate.ui.MultiComboP, d.preview )
        end
    end
end

function ultimate.ui.ComboBox( pan, str, cfg, choices )
    local lbl = vgui_Create("DLabel",pan)
    lbl:Dock(TOP)
    lbl:DockMargin(4,1,4,0)
    lbl:SetText(str)
    lbl:SetFont("tbfont")
    lbl:SetColor(ultimate.Colors[165])

    local dropdown = vgui_Create("UComboBox",pan)
    dropdown:Dock(TOP)
    dropdown:DockMargin(4,1,4,0)

    if ultimate.presets[ cfg ] then
        choices = ultimate.presets[ cfg ]
    end

    for k, v in ipairs( choices ) do
        dropdown:AddChoice( v )
    end

    dropdown:SetSortItems(false)

    if ultimate.cfg.vars[cfg] <= #choices then
        dropdown:ChooseOptionID(ultimate.cfg.vars[cfg])
    else
        dropdown:ChooseOptionID(1)
    end

    function dropdown:OnSelect(index, value, data)
        ultimate.cfg.vars[cfg] = index
    end

    return lbl, dropdown
end

function ultimate.ui.InitMT( p, postCreate )
    p.ItemPanel:Remove()

    p.ItemPanel = vgui_Create( "DPanel", p )
    p.ItemPanel:Dock( FILL )
    p.ItemPanel:DockMargin( 3, 0, 3, 3 )

    p.ItemPanel.Paint = nil

    if postCreate then postCreate( p.ItemPanel ) end
end

function ultimate.ui.MTButton( p, str, postCreate )
    surface_SetFont("tbfont")
    local w, h = surface_GetTextSize(str)

    local fw = w + 5

    local tx, ty = fw/2 - w/2, 18 / 2-h / 2 - 1

    local b = p:GetButtonPanel():Add("DButton")
    b:Dock(RIGHT)
    b:DockMargin(2,0,2,1)
    b:SetWide(fw)
    b:SetText("")

    function b:DoClick()
        p.ActiveTab = str
        ultimate.ui.InitMT( p, postCreate )
    end

    function b:Paint(width,height)
        if p.ActiveTab == str then
            surface_SetTextColor(235,235,235,255)
        else
            surface_SetTextColor(165,165,165,255)
        end

        surface_DrawRect(0,0,width,height)

        surface_SetFont("tbfont")
        surface_SetTextPos(tx,ty)
        surface_DrawText(str)
    end

    p.ActiveTab = str
    ultimate.ui.InitMT( p, postCreate )
end

ultimate.pty = { 5, 5, 5 }
do
    local xt = {
        [1] = 5,
        [2] = 267,
        [3] = 529
    }

    function ultimate.itemPanel( str, tbl, h )
        local p = vgui_Create( "UPanel", ultimate.scrollpanel )
        p:SetPos( xt[tbl], ultimate.pty[tbl] )
        p:SetSize( 257, h )
        p.txt = str

        ultimate.pty[ tbl ] = ultimate.pty[ tbl ] + h + 5

        return p
    end

    function ultimate.itemPanelB( str, tbl, h, buttonsFunc )
        local p = vgui_Create( "UButtonBarPanel", ultimate.scrollpanel )
        p:SetPos( xt[tbl], ultimate.pty[tbl] )
        p:SetSize( 257, h )
        p.txt = str

        if buttonsFunc then buttonsFunc( p ) end

        ultimate.pty[ tbl ] = ultimate.pty[ tbl ] + h + 5

        return p
    end

end

/*
    Drag n drop
*/

ultimate.espposes = {"Up","Down","Right","Left"}
ultimate.espelements = {"Name pos","Usergroup pos","Health pos","Armor pos","Money pos","Weapon pos","Team pos","Break LC pos","Simtime pos"}
ultimate.lastdrag = ""
ultimate.esppans = {}

ultimate.esppansposes = {
    [1] = {
        x = 85,
        y = 0,
    },
    [2] = {
        x = 85,
        y = 250,
    },
    [3] = {
        x = 170,
        y = 125,
    },
    [4] = {
        x = 0,
        y = 125,
    },
}

for i = 1, 4 do
    ultimate.esppans[i] = {}
end

function ultimate.DoDrop( self, panels, bDoDrop, Command, x, y )
    if ( bDoDrop ) then
        local newpos = self.pos

        for i = 1, #panels do
            local v = panels[i]

            ultimate.cfg.vars[ v:GetText() ] = newpos
            v:SetParent( self )
        end
    end
end

ultimate.spfuncs = {}

// PANEL CREATION

ultimate.frame = vgui_Create("UFrame")
ultimate.scrollpanel = vgui_Create("UScroll",ultimate.frame)

ultimate.tabs = {}

// Aimbot


ultimate.spfuncs[2] = function()
    ultimate.ui.SettingsPan:SetSize( 300, 350 )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Rapid fire", "Rapid fire", "Allows to quickly fire semi-automatic weapons." )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Rapid fire glitch", "Rapid fire glitch", "Allows to quickly fire semi-automatic weapons." )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Bullet time", "Bullet time", "Aim will not work until weapon can fire." )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Rapid fire two method", "Rapid fire 2", "Allows to quickly fire semi-automatic weapons." )
    /*ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Server time", "Server time", "Aim will not work until weapon can fire." )*/
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Wait for simtime update", "Wait for simtime update" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "ShootDelay", "ShootDelay", "Waiting for a delay before the shooting" )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "ShootDelay time", "ShootDelay time", 0, 1000, 0 )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Alt Rapid fire", "Alt Rapid fire" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Alt Rapid fire two method", "Alt Rapid fire 2" )
end

ultimate.spfuncs[3] = function()
    ultimate.ui.SettingsPan:SetSize( 250, 68 )

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Knifebot mode", "Knifebot mode"  )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Facestab", "Facestab" )
end

ultimate.spfuncs[4] = function()
    ultimate.ui.SettingsPan:SetSize( 250, 85 )

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Smooth amount", "Smoothing", 0, 1, 2 )
end

ultimate.spfuncs[5] = function()
    ultimate.ui.SettingsPan:SetSize( 250, 128 )

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Dynamic fov", "Fov dynamic" )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Aimbot FOV", "Aimbot FOV", 0, 180, 0 )
end

ultimate.spfuncs[30] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "", "" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Random seed", "Wait for seed" )


end

ultimate.spfuncs[32] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Max simulation time", "Crossbow max simtime", 1, 10, 2 )

end

function ultimate.tabs.Aimbot()

    local p = ultimate.itemPanel("Main",1,160):GetItemPanel()

    ultimate.ui.CheckBox( p, "Enable Aimbot", "Enable aimbot", false, false, false, false, false, function( p ) ultimate.ui.Binder( "Aim on key", p ) end )
    ultimate.ui.CheckBox( p, "Auto fire", "Auto fire", "Automatically fires when targets can be damaged.", false, false, ultimate.spfuncs[2] )
    ultimate.ui.CheckBox( p, "Auto reload", "Auto reload", "Automatically reloads weapon when clip is empty." )
    ultimate.ui.CheckBox( p, "Silent aim", "Silent aim", "Makes the aim visually invisible" )
    ultimate.ui.CheckBox( p, "pSilent", "pSilent", "Context vector will be used to make aim completely invisible." )
    ultimate.ui.CheckBox( p, "Knife bot", "Knifebot", false, false, false, ultimate.spfuncs[3] )

    local p = ultimate.itemPanel("Legit",1,140):GetItemPanel()

    ultimate.ui.CheckBox( p, "Aimbot smoothing", "Aimbot smoothing", false, false, false, ultimate.spfuncs[4] )
    ultimate.ui.CheckBox( p, "Fov limit", "Fov limit", false, false, false, ultimate.spfuncs[5] )
    ultimate.ui.CheckBox( p, "Trigger", "Trigger bot", false, true )

    local p = ultimate.itemPanel( "Tickbase", 1, 200 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Engine pred(need for grust)", "need for grust" )
    //ultimate.ui.Slider( p, "TicksTime", "tickfix_time", 0, 6, 2 )
    ultimate.ui.CheckBox( p, "NoPlyLag", "NoAimLag", "Off comp lag" )
    //ultimate.ui.CheckBox( p, "GetManipulateInterp", "GetManipulateInterp" )
    ultimate.ui.CheckBox( p, "LagCompensation", "LagCompensation", "Compensate ping loss" )
    ultimate.ui.CheckBox( p, "LerpTime abjust", "LerpTime", "abuse lerptime target" )


    local p = ultimate.itemPanel( "Visualisation", 1, 250 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Show FOV", "Show FOV", false, false, true )
    ultimate.ui.CheckBox( p, "Snapline", "Aimbot snapline", false, false, true )
    ultimate.ui.CheckBox( p, "Marker", "Aimbot marker", false, false, true )
    //ultimate.ui.CheckBox( p, "Swaston", "Aimbot_swaston", false, false, true )
    //ultimate.ui.CheckBox( p, "Markers huyna", "Aimbot_markers", false, false, true )
    //ultimate.ui.CheckBox( p, "Fill", "Aimbot_fill", false, false, true )
    //ultimate.ui.CheckBox( p, "Krujochek", "Aimbot_krujok", false, false, true )
    //ultimate.ui.CheckBox( p, "box", "ap_enable", false,false,true)
    //ultimate.ui.CheckBox( p, "box", "ap_box" )

    local p = ultimate.itemPanel( "Accuracy", 2, 165 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Compensate recoil", "Norecoil", "Disable PunchAngles" )
    ultimate.ui.CheckBox( p, "Compensate recoil for tfa", "gRust NR", "Disable PunchAngles !ONLY GRUST" )
    ultimate.ui.CheckBox( p, "Remove spread", "Nospread", "Supported HL2, M9K, FAS2, CW2, SWB", false, false, ultimate.spfuncs[30] )

    local p = ultimate.itemPanel( "Prediction", 2, 200 ):GetItemPanel()
    //ultimate.ui.CheckBox( p, "Crossbow", "Crossbow prediction" )
    //ultimate.ui.CheckBox( p, "Prediction old", "Prediction New" )
    //ultimate.ui.CheckBox( p, "Prediction old grust", "Prediction old grust" )
    //ultimate.ui.CheckBox( p, "Prediction grust", "Grust kotyara pred" )
    //ultimate.ui.CheckBox( p, "Prediction NEW GRUST", "Prediction New GRUST" )
    //ultimate.ui.CheckBox( p, "Prediction NEW GRUST two method", "Prediction New GRUST2" )
    //ultimate.ui.CheckBox( p, "Prediction weapons", "Grust Prediction defoult" )
    //ltimate.ui.CheckBox( p, "Prediction weapons two method", "Grust Prediction defoult2" )
    //ultimate.ui.CheckBox( p, "Prediction bow", "Grust Prediction bow")
    //ultimate.ui.CheckBox( p, "Prediction bow two method", "Grust Prediction bow2")
    //ultimate.ui.Slider( p, "Bullet gravity prediction", "Bullet gravity pred", 0, 5, 3 )
    //ultimate.ui.Slider( p, "Max simulation time", "Prop max simtime", 1, 10, 2 )
    //ultimate.ui.Slider( p, "Simulation limit", "Simulation limit", 1, 10, 2 )
    //ultimate.ui.CheckBox( p, "Prediction perfect", "Grust Prediction hellcat 1", "unique prediction for grust" )
    ultimate.ui.CheckBox( p, "ILYAWARE PREDICT", "gRust Shahid predict pizdech", "unique prediction for grust" )
    //ultimate.ui.CheckBox( p, "Movement prediction", "Movment prediction hellcat 1", "unique prediction for grust" )
    //ultimate.ui.CheckBox( p, "Grust Prediction", "Grust Prediction hellcat 2","unique prediction for grust" )
    //ultimate.ui.CheckBox( p, "Movement prediction", "Movment prediction hellcat 2", "unique prediction for grust" )
    //ultimate.ui.CheckBox( p, "Strafe prediction", "Strafe prediction", "unique prediction for grust" )
    //ultimate.ui.Slider( p, "Movement ", "Movement mnogitel", 13, 15, 2 )
    //ultimate.ui.Slider( p, "Distance ", "Distance mnogitel", 1, 20, 0 )
    //ultimate.ui.Slider( p, "STR8STEP ", "STR8STEP mnogitel", 1, 5000, 0 )
    //ultimate.ui.Slider( p, "LENTGH ", "LENTGH mnogitel", 1, 3000, 0 )
    //ultimate.ui.Slider( p, "SPEED", "SPEED mnogitel", 1, 1000, 0 )
    //ultimate.ui.Slider( p, "STEPS", "STEP mnogitel", 1, 100, 0 )
    //ultimate.ui.Slider( p, "DROP", "DROP mnogitel", 0.1, 10, 1 )
    //ultimate.ui.Slider( p, "Strafe", "Strafe mnogitel", 1, 20, 0)
    //ultimate.ui.Slider( p, "Bullet speed", "Bullet speed", 1, 10000, 0)
    //ultimate.ui.Slider( p, "GRav", "GRAVITY new", 1, 100, 0)
    ultimate.ui.CheckBox( p, "Projectile aimbot", "Projectile aimbot" )


    //ultimate.ui.CheckBox( p, "Prop aimbot", "Prop aimbot" )
    //ultimate.ui.CheckBox( p, "Auto throw", "PA thrower" )
    //ultimate.ui.Slider( p, "Throw distance", "PA thrower dist", 1, 640, 0 )

    local p = ultimate.itemPanel( "Target selection", 3, 360 ):GetItemPanel()

    ultimate.ui.ComboBox( p, "Target selection", "Target selection", { "Distance", "FOV" , "FOV for prediction" , "Distance for prediction", "None" } )
    //ultimate.ui.ComboBox( p, "Target selection v2", "target_selection", { "FOV" } )
    ultimate.ui.ComboBox( p, "Sync", "Sync mode", { "None", "Engine", "Engine Time" ,"Velocity", "Based", "LowTickrate", "For breaking interp", "Lag comp" }, "Synchronization position target" )
    ultimate.ui.MultiCombo( p, "Ignores", { "Friends", "Steam friends", "Teammates", "Driver", "Break LC", "Head unhitable", "God time", "Nocliping", "Nodraw", "Frozen", "Bots", "Admins" } )
    //ultimate.ui.MultiCombo( p, "aimbot", { "bgod", "nodraw", "admin", "bots", "steam", "noclip", "team", "fr" } )
    ultimate.ui.CheckBox( p, "Wallz", "Wallz" )
    ultimate.ui.Slider( p, "Max targets", "Max targets", 0, 10, 0 )
    local p = ultimate.itemPanel( "Hitbox selection", 3, 280 ):GetItemPanel()

    ultimate.ui.ComboBox( p, "Hitbox selection", "Hitbox selection", { "Head", "Chest", "Penis" } )
    //ultimate.ui.ComboBox( p, "Hitbox selection v2", "hitbox_selection serj version", { "Head | Голова", "Eyes | Глаза", "Penis | Пенис", "Spine | Спина", "Center | Центр", "Бошка", })
    //ultimate.ui.CheckBox( p, "eyes","eyes_e" )
    ultimate.ui.CheckBox( p, "Hitscan", "Hitscan" )
    //ultimate.ui.ComboBox( p, "Hitscan mode", "Hitscan Mode", { "Damage", "Safety", "Scale" } )
    ultimate.ui.MultiCombo( p, "Hitscan groups", { "Head", "Chest", "Stomach", "Arms", "Legs", "Generic" } )
    ultimate.ui.CheckBox( p, "Multipoint", "Multipoint" )
    ultimate.ui.MultiCombo( p, "Multipoint groups", { "Head", "Chest", "Stomach", "Arms", "Legs", "Generic" } )
    ultimate.ui.Slider( p, "Multipoint scale", "Multipoint scale", 0.5, 1, 1 )





    /*






    ultimate.ui.CheckBox( p, "", "Disable interpolation", false, false, false, ultimate.spfuncs[9])


    local p = ultimate.itemPanel("Prediction",2,200):GetItemPanel()


    ultimate.ui.CheckBox( p, "Crossbow prediction", "Crossbow prediction", false, false, false, ultimate.spfuncs[32] )


*/

    /*
    func = function()
        ultimate.settingspan:SetSize(250,64)

        ultimate.slider("Forwardtrack time","",0,200,0,ultimate.settingspan)
    end

    //ultimate.checkbox("Backshoot","Backshoot",p)
    ultimate.checkbox("Auto healthkit","Auto healthkit",p:GetItemPanel())
    ultimate.multiCombo("Healthkit",{"Self heal","Heal closest"},p:GetItemPanel())
    */
end



ultimate.spfuncs[22] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Lag limit","Lag limit",1,23,0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Random min","Lag randomisation",1,23,0 )
    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Lag mode", "Lag mode", {"Static","Adaptive","Hybrid","HybridTwo","HybridThree"})
    ultimate.ui.MultiCombo( ultimate.ui.SettingsPan, "Fake lag options", {"Disable on ladder","Disable in attack","Randomise","On peek","Only in AntiAim"} )
end

ultimate.spfuncs[24] = function( p )


    // "Runs act command to make your model dance for other clients"
    //"Forcing istyping for animation desync"
end

ultimate.spfuncs[36] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)
    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Antiaim material", ultimate.chamsMaterials)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Antiaim fullbright", "Antiaim fullbright" )
end

ultimate.spfuncs[254] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Backshoot", "Backshoot" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fakelag comp new", "Fakelag comp new" )

end

function ultimate.tabs.Rage()
    local p = ultimate.itemPanel( "Angles", 1, 245 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Enable Anti-Aim", "Anti aim", false, true )
    ultimate.ui.CheckBox( p, "Inverter", "Inverter", false, true )
    ultimate.ui.ComboBox( p, "Yaw base", "Yaw base" )
    ultimate.ui.ComboBox( p, "Yaw", "Yaw" )
    ultimate.ui.ComboBox( p, "Pitch", "Pitch" )
    ultimate.ui.ComboBox( p, "Edge", "Edge", { "Disabled", "Hide", "Show", "Jitter" } )

    local p = ultimate.itemPanel( "Tweaks", 1, 120 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "On shot aa", "On shot aa" )
    ultimate.ui.CheckBox( p, "Yaw randomisation", "Yaw randomisation" )
    ultimate.ui.CheckBox( p, "Freestanding", "Freestanding" )
    ultimate.ui.CheckBox( p, "Micromovement", "Micromovement" )

    local p = ultimate.itemPanel( "Custom angles", 1, 400 ):GetItemPanel()

    ultimate.ui.Slider( p, "Custom real","Custom real", -180, 180, 0 )
    ultimate.ui.Slider( p, "Custom fake","Custom fake", -180, 180, 0 )
    ultimate.ui.Slider( p, "Custom pitch","Custom pitch", -360, 360, 0 )
    ultimate.ui.Slider( p, "Spin speed","Spin speed", -50, 50, 0 )
    ultimate.ui.Slider( p, "Min Lby Delta","LBY min delta", 0, 360, 0 )
    ultimate.ui.Slider( p, "Break Lby Delta","LBY break delta", 0, 360, 0 )
    ultimate.ui.Slider( p, "Sin delta","Sin delta", -360, 360, 0 )
    ultimate.ui.Slider( p, "Sin add","Sin add", -180, 180, 0 )
    ultimate.ui.Slider( p, "Jitter delta","Jitter delta", -180, 180, 0 )

    local p = ultimate.itemPanel( "Fake lag",2,250 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Fake lag", "Fake lag", false, false, false, ultimate.spfuncs[22] )
    ultimate.ui.CheckBox( p, "Fake duck", "Fake duck", false, true )
    ultimate.ui.CheckBox( p, "Air Duck", "Air lag duck" )
    ultimate.ui.CheckBox( p, "Water level", "Jesus lag" )
    ultimate.ui.CheckBox( p, "Break lagcomp", "Break lagcomp" )
    ultimate.ui.CheckBox( p, "Michael Jackson exploit","Allah walk", false, true )

    local p = ultimate.itemPanel( "Visualisation", 2,75 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Fake angle chams", "Anti aim chams", false, false, false, ultimate.spfuncs[36], false, function( p ) ultimate.ui.ColorPicker( "Real chams", p ) end )
    ultimate.ui.CheckBox( p, "Angle arrows", "Angle arrows" )

    local p = ultimate.itemPanel( "Tickbase", 2, 265 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Enable shift", "Tickbase shift", false, true, false, false, function(b) ded.EnableTickbaseShifting(b) end )

    ultimate.ui.ComboBox( p, "Fakelag comp", "Fakelag comp", {"Disable","Compensate"} )
    ultimate.ui.CheckBox( p, "Warp on peek", "Warp on peek" )
    ultimate.ui.CheckBox( p, "Double tap", "Double tap" )
    //ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Passive recharge", "Passive recharge" )
    ultimate.ui.CheckBox( p, "Dodge projectiles", "Dodge projectiles" )
    //ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Wait for charge", "Wait for charge", false, false, false, false, function(b) ded.WaitForCharge(b) end )
    ultimate.ui.CheckBox( p, "Auto recharge", "Auto recharge", false, true )

    ultimate.ui.Slider( p, "Shift ticks", "Shift ticks", 1, 99, 0, function( val ) ded.SetMinShift(val) end )
    ultimate.ui.Slider( p, "Charge ticks", "Charge ticks", 1, 99, 0, function( val ) ded.SetMaxShift(val) end )

    local p = ultimate.itemPanel( "Sequence", 2, 265 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Lagger manip", "Sequence manip", false, true )
    ultimate.ui.Slider( p, "Out lagger", "OutSequence", 0.1, 100, 0 )
    ultimate.ui.CheckBox( p, "Randomise", "Sequence min random" )
    ultimate.ui.Slider( p, "Min lagger", "Sequence min", 0.1, 100, 0 )
    ultimate.ui.CheckBox( p, "Animation freezer", "Animation freezer", false, true )
    ultimate.ui.ComboBox( p, "Lagger manip mode", "Lagger manip mode", { "Mega", "Slippery", "TICKS", "desync"  } )



    local p = ultimate.itemPanel( "Player adjustments", 3, 300 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "fix inerpolation grust", "Disable interpolation", false, false, false, false, function( bval ) ded.SetInterpolation( bval ) end )
    ultimate.ui.CheckBox( p, "Sequence interpolation", "Disable Sequence interpolation", false, false, false, false, function( bval ) ded.SetSequenceInterpolation( bval ) end )
    ultimate.ui.CheckBox( p, "Fix bones", "Bone fix", false, false, false, false, function( bval ) ded.EnableBoneFix( bval ) end )
    ultimate.ui.CheckBox( p, "Fix animations", "Update Client Anim fix", false, false, false, false, function( bval ) ded.EnableAnimFix( bval ) end )
    ultimate.ui.CheckBox( p, "Legs Break", "leg_breaker" )
    ultimate.ui.CheckBox( p, "Extrapolation", "Extrapolation" )
    //ultimate.ui.CheckBox( p, "Extrapolation2", "Extrapolation2" )
    //ultimate.ui.CheckBox( p, "Extrapolation3", "Extrapolation3" )
    ultimate.ui.CheckBox( p, "Lag fix" , "Lag fix", false, false, false, ultimate.spfuncs[254] )
    ultimate.ui.CheckBox( p, "Forwardtrack" , "Forwardtrack" )
    ultimate.ui.Slider( p, "Forwardtrack time","Forwardtrack time",0,200,0 )


    local p = ultimate.itemPanel( "RESOLVER", 3, 140 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Resolver", "Resolver" )
    ultimate.ui.ComboBox( p, "Resolver mode", "Resolver mode", { "Defoult", "Adaptive", "Deltalove", "Custom AA", "Classic", "TEST" } )
    ultimate.ui.CheckBox( p, "Pitch resolver", "Pitch resolver" )
    ultimate.ui.CheckBox( p, "res test", "res test" )


    local p = ultimate.itemPanel( "Position adjustment", 3, 215 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Adjust tickcount", "Adjust tickcount" )
    ultimate.ui.CheckBox( p, "Backtrack", "Backtrack" )
    ultimate.ui.ComboBox( p, "Backtrack mode", "Backtrack mode", { "Last ticks", "Closest", "Scan" } ) // , "Backshoot"
    ultimate.ui.Slider( p, "Sampling interval", "Sampling interval", 0, 200, 0 )
    ultimate.ui.Slider( p, "Backtrack time", "Backtrack time", 0, 1000, 0 )
    ultimate.ui.CheckBox( p, "Always backtrack", "Always backtrack" )

    local p = ultimate.itemPanel( "Misc", 3, 115 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Auto detonator", "Auto detonator" )
    ultimate.ui.Slider( p, "Detonation distance", "AutoD distance", 16, 128, 0 )


    ultimate.ui.CheckBox( p, "Gun switch", "Gun switch" )
    /*
    local function func( p )
        ultimate.ui.MTButton( p, "Custom", ultimate.spfuncs[37] )
        ultimate.ui.MTButton( p, "Anim breakers", ultimate.spfuncs[24] )
        ultimate.ui.MTButton( p, "Angles", ultimate.spfuncs[23] )
    end

    ultimate.itemPanelB( "Anti aim",1,300, func )




    local p = ultimate.itemPanel("Fake lag",2,105):GetItemPanel()















*/

    //end


     /*
ultimate.cfg.vars["Resolver"] = false
ultimate.cfg.vars["Yaw mode"] = 1
ultimate.cfg.vars["Pitch resolver"] = false
ultimate.cfg.vars["Invert first shot"] = false
ultimate.cfg.vars["Resolver max misses"] = 2

    ultimate.combobox("Edge", {"None","Hide","Jitter"}, "Edge", p:GetItemPanel())

    ultimate.checkbox("Show AA","Anti aim chams",p:GetItemPanel())

    local p = ultimate.itemPanel("Animation breakers",1,200)




    local p = ultimate.itemPanel("Animfix",3,223)

    ultimate.cfg.vars["Interpolation-Disable interpolation"] = false
    ultimate.cfg.vars["Interpolation-Fast sequences"] = false


    ultimate.checkbox("Disable taunts","Disable taunts",p:GetItemPanel())
    ultimate.checkbox("Extrapolation","Extrapolation",p:GetItemPanel())
    ultimate.checkbox("test","last update",p:GetItemPanel())




    local p = ultimate.itemPanel("Fake lag",2,320)





    ultimate.checkbox("Fly hacks","Allah fly",p:GetItemPanel())

    //ultimate.checkbox("Fake lag","Fake lag",p:GetItemPanel())
    //ultimate.slider("Lag limit","Lag limit",0,23,0,p:GetItemPanel())
    //ultimate.slider("Lag randomisation","Lag randomisation",0,23,0,p:GetItemPanel())
    //ultimate.combobox("Lag mode", {"Static","Adaptive"}, "Lag mode", p:GetItemPanel())

    ultimate.checkbox("Michael Jackson exploit","Allah walk",p:GetItemPanel(),"allahwalk")
    ultimate.checkbox("","Fake duck",p:GetItemPanel(),"Fake duck")

    local p = ultimate.itemPanel("Tickbase",2,250)


    ultimate.multiCombo("Triggers",{"In Attack","On Peek","After peek"},p:GetItemPanel())

    // ultimate.checkbox("Skip fire tick","Skip fire tick",p:GetItemPanel())


    local p = ultimate.itemPanel( "Resolver", 3, 178 )

    ultimate.checkbox( "Enable resolver", "Resolver", p:GetItemPanel() )
    ultimate.combobox( "Yaw mode", { "Step", "Delta brute" }, "Yaw mode", p:GetItemPanel() )
    ultimate.slider( "Max misses", "Resolver max misses", 1, 6, 0, p:GetItemPanel() )
    ultimate.checkbox( "Pitch resolver", "Pitch resolver", p:GetItemPanel() )
    ultimate.checkbox( "Invert first shot", "Invert first shot", p:GetItemPanel() )
*/
end

/*local p = vgui_Create("UPanel",ultimate.scrollpanel)
    p:SetPos(5,y[1])
    p:SetSize(257,200)
    p.txt = "LBY Settings"

    ultimate.slider("LBY min delta","LBY min delta",0,360,0,p:GetItemPanel())
    ultimate.slider("LBY break delta","LBY break delta",0,360,0,p:GetItemPanel())
    */

ultimate.spfuncs[11] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Team color", "Box team color" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Gradient", "Box gradient" )
    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Style", "Box style", { "Default", "Corner", "Hex", "Poly", "test" })


end

ultimate.spfuncs[12] = function()
    ultimate.ui.SettingsPan:SetSize(250,48)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Health bar", "Health bar" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Gradient", "Health bar gradient" )
end

ultimate.spfuncs[53453453453453453] = function()
    ultimate.ui.SettingsPan:SetSize(250,48)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Health bar", "Health bar grust" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Gradient", "Health bar gradient grust" )
end

ultimate.spfuncs[14] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Visible material", "Visible mat", ultimate.chamsMaterials)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Weapon chams", "Visible chams w" )

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Invisible material", "inVisible mat", ultimate.chamsMaterials)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "inVisible chams", "inVisible chams" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Weapon chams", "inVisible chams w" )

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Supress lighting" )
end

ultimate.spfuncs[15] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Self mat", ultimate.chamsMaterials)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Weapon chams", "Self chams w" )

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Supress self lighting" )
end

ultimate.spfuncs[16] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Backtrack material", ultimate.chamsMaterials)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Backtrack fullbright" )
end

ultimate.spfuncs[17] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Entity material", ultimate.chamsMaterials)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Entity fullbright" )
end

ultimate.spfuncs[18] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Die time","Tracers die time",0.1,10,1 )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Bullet tracers muzzle", "Bullet tracers muzzle" )

end

ultimate.spfuncs[19] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Viewmodel chams type", ultimate.chamsMaterials)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Fullbright viewmodel" )
end

ultimate.spfuncs[20] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Smoothing", "Third person smoothing" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Collision", "Third person collision" )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Distance","Third person distance",50,220,0 )
end

ultimate.spfuncs[21] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Freecam speed","Free camera speed",5,100,0 )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Ghetto mode", "Ghetto free cam" )
end

ultimate.spfuncs[31] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "3D", "Ent box 3d" )
end


ultimate.spfuncs[35] = function( p )
    local mdl = vgui.Create( "DModelPanel", p )
    mdl:SetPos(85,125)
    mdl:SetSize(85,125)
    mdl:SetModel( "models/props_vehicles/truck001a.mdl" )

    mdl:SetCamPos(Vector(0,0,148))

    function mdl:LayoutEntity( Entity ) return end

    for i = 1,4 do
        local poses = ultimate.esppansposes

        ultimate.esppans[i].panel = vgui_Create( "UPaintedPanel", p )
        ultimate.esppans[i].panel:SetPos(poses[i].x,poses[i].y)
        ultimate.esppans[i].panel:SetSize(85,125)
        ultimate.esppans[i].panel:Receiver( "SwagCock$", ultimate.DoDrop )
        ultimate.esppans[i].panel.pos = i
    end

    for i = 1, #ultimate.espelements do
        local cfgstr = ultimate.espelements[i]
        local panel = ultimate.esppans[ultimate.cfg.vars[cfgstr]].panel

        local b = vgui_Create("UESPPButton")
        b:SetText( cfgstr )
		b:SetSize( 36, 24 )
		b:Dock( TOP )
        b:Droppable( "SwagCock$" )

        b:SetParent( panel )
    end
end

ultimate.spfuncs[33] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Show ammo", "Show ammo" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Print name", "Weapon printname" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Show reloading", "Show reloading" )

end

ultimate.spfuncs[34] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "chams_hand_mat", ultimate.chamsMaterials)

end

ultimate.spfuncs[124] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel X","Viewmodel x", -50, 50, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel Y","Viewmodel y", -50, 50, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel Z","Viewmodel z", -50, 50, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel Pitch","Viewmodel p", -90, 90, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel Yaw","Viewmodel ya", -90, 90, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel Roll","Viewmodel r", -90, 90, 0 )

end

ultimate.spfuncs[123] = function()
    ultimate.ui.SettingsPan:SetSize(250,370)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Red","pp_colour_addr", 0, 10, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Green","pp_colour_addg", 0, 10, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Blue","pp_colour_addb", 0, 10, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Brightness","pp_colour_brightness", 0, 3, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Contrast","pp_colour_contrast", 0, 5, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Saturation","pp_colour_colour", 0, 5, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Mul Red", "pp_colour_mulr", 0, 255, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Mul Green", "pp_colour_mulg", 0, 255, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Mul blue", "pp_colour_mulb", 0, 255, 4 )

end



ultimate.spfuncs[909] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Team color", "OOF team color" )

end

ultimate.spfuncs[909412421] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Team color", "Team colorSUCK" )

end

function ultimate.tabs.Visuals()

    local p = ultimate.itemPanel("Player",1,550):GetItemPanel()

    ultimate.ui.CheckBox( p, "Box", "Box esp", false, false, true, ultimate.spfuncs[11] )

    ultimate.ui.CheckBox( p, "Name", "Name", false, false, true, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Name pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Usergroup", "Usergroup", false, false, true, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Usergroup pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Health", "Health", false, false, true, ultimate.spfuncs[12], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Health pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(3,0,0,0) ultimate.ui.ColorPicker( "Health bar gradient", p ) end )
    //ultimate.ui.CheckBox( p, "Health grust", "Health grust", false, false, true, ultimate.spfuncs[], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Health pos grust", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(3,0,0,0) ultimate.ui.ColorPicker( "Health bar gradient grust", p ) end )
    ultimate.ui.CheckBox( p, "Armor", "Armor", false, false, true, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Armor pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Weapon", "Weapon", false, false, true, ultimate.spfuncs[33], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Weapon pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(3,0,0,0) end )
    ultimate.ui.CheckBox( p, "Team", "Team", false, false, true, ultimate.spfuncs[909412421], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Team pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Money", "DarkRP Money", false, false, true, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Money pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Lag compensation", "Break LC", false, false, true, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Break LC pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Packets ( Fake lag )", "Simtime updated", false, false, true, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Simtime pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Distance", "Print Distance", false, false, true, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Print Distance pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )

    ultimate.ui.Slider( p, "Max distance","ESP Distance",0,100000,0 )

    ultimate.ui.CheckBox( p, "Show records", "Show records" )
    ultimate.ui.CheckBox( p, "Skeleton", "Skeleton",false,false,true )
    ultimate.ui.CheckBox( p, "Hitbox", "Hitbox",false,false,true )
    ultimate.ui.CheckBox( p, "OOF Arrows", "OOF Arrows", false, false, false, ultimate.spfuncs[909], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "OOF Style", {"Arrow","UkroSwastika"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) ultimate.ui.ColorPicker( "OOF Arrows color", p ) end )
    ultimate.ui.CheckBox( p, "Sight lines", "Sight lines",false,false,true )
    ultimate.ui.CheckBox( p, "InFOV Indicator", "IFOV",false,false,true )

    ultimate.ui.ComboBox( p, "Font", "ESP Font", { "Outlined", "Shadow", "Thug", "Arial" } )












    local p = ultimate.itemPanel("Entity",1,135):GetItemPanel()

    ultimate.ui.CheckBox( p, "Box", "Ent box", false, false, false, ultimate.spfuncs[31] )
    ultimate.ui.CheckBox( p, "Class", "Ent class" )
    ultimate.ui.Slider( p, "Max distance","Ent ESP Distance",0,100000,0 )
    ultimate.ui.Label( p, "Add entity key", function( p ) ultimate.ui.Binder( "Ent add", p ) end )

    local p = ultimate.itemPanel( "Hitmarker", 1, 300 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Hitmarker", "Hitmarker", false, false, true )
    ultimate.ui.CheckBox( p, "Hitnumbers", "Hitnumbers", false, false, true, false, false, function(p) ultimate.ui.ColorPicker( "Hitnumbers krit", p ) end )
    ultimate.ui.CheckBox( p, "CrosshairSwastika", "crosshair", false, false, false, ultimate.spfuncs[23333] )

    //ultimate.ui.CheckBox( p, "Hit particles", "Hit particles", false, false, true, ultimate.spfuncs[31] )


    ultimate.ui.CheckBox( p, "Hitsound", "Hitsound" )
    ultimate.ui.TextEntry( "Sound path", "Hitsound str", p, 420 )
    ultimate.ui.CheckBox( p, "Killsound", "Killsound" )
    ultimate.ui.CheckBox( p, "Killstreak", "Killstreak" )
    ultimate.ui.TextEntry( "Sound path", "Killsound str", p, 420 )
    

    local p = ultimate.itemPanel("Colored models",2,200):GetItemPanel()

    ultimate.ui.CheckBox( p, "Player chams", "Visible chams", false, false, true, ultimate.spfuncs[14], false, function(p) ultimate.ui.ColorPicker( "inVisible chams", p ) end )
    ultimate.ui.CheckBox( p, "Self chams", "Self chams", false, false, true, ultimate.spfuncs[15] )
    ultimate.ui.CheckBox( p, "Backtrack chams", "Backtrack chams", false, false, true, ultimate.spfuncs[16] )
    ultimate.ui.CheckBox( p, "Entity chams", "Entity chams", false, false, true, ultimate.spfuncs[17], false )
    ultimate.ui.CheckBox( p, "Viewmodel chams", "Viewmodel chams", false, false, true, ultimate.spfuncs[19], false )
    ultimate.ui.CheckBox( p, "Hand chams", "chams_hand", false, false, true, ultimate.spfuncs[34], false )
    ultimate.ui.CheckBox( p, "Rainbow player", "rainbow player" )

    local p = ultimate.itemPanel("Material customisation",2,150):GetItemPanel()

    ultimate.ui.Slider( p, "Min illumination", "Fresnel minimum illum", 0, 1, 1, function( v )
        local v1, v2, v3, v4 = ultimate.chamMats.vis[3], ultimate.chamMats.vis[4], ultimate.chamMats.invis[3], ultimate.chamMats.invis[3]

        v1:SetVector( "$selfIllumFresnelMinMaxExp", Vector( v, ultimate.cfg.vars["Fresnel maximum illum"], ultimate.cfg.vars["Fresnel exponent"] ) )
        v2:SetVector( "$selfIllumFresnelMinMaxExp", Vector( v, ultimate.cfg.vars["Fresnel maximum illum"], ultimate.cfg.vars["Fresnel exponent"] ) )
        v3:SetVector( "$selfIllumFresnelMinMaxExp", Vector( v, ultimate.cfg.vars["Fresnel maximum illum"], ultimate.cfg.vars["Fresnel exponent"] ) )
        v4:SetVector( "$selfIllumFresnelMinMaxExp", Vector( v, ultimate.cfg.vars["Fresnel maximum illum"], ultimate.cfg.vars["Fresnel exponent"] ) )
    end )

    ultimate.ui.Slider( p, "Max illumination", "Fresnel maximum illum", 0, 1, 1, function( v )
        local v1, v2, v3, v4 = ultimate.chamMats.vis[3], ultimate.chamMats.vis[4], ultimate.chamMats.invis[3], ultimate.chamMats.invis[3]

        v1:SetVector( "$selfIllumFresnelMinMaxExp", Vector( ultimate.cfg.vars["Fresnel minimum illum"], v, ultimate.cfg.vars["Fresnel exponent"] ) )
        v2:SetVector( "$selfIllumFresnelMinMaxExp", Vector( ultimate.cfg.vars["Fresnel minimum illum"], v, ultimate.cfg.vars["Fresnel exponent"] ) )
        v3:SetVector( "$selfIllumFresnelMinMaxExp", Vector( ultimate.cfg.vars["Fresnel minimum illum"], v, ultimate.cfg.vars["Fresnel exponent"] ) )
        v4:SetVector( "$selfIllumFresnelMinMaxExp", Vector( ultimate.cfg.vars["Fresnel minimum illum"], v, ultimate.cfg.vars["Fresnel exponent"] ) )
    end )

    ultimate.ui.Slider( p, "Fresnel exponent", "Fresnel exponent", 0, 1, 1, function( v )
        local v1, v2, v3, v4 = ultimate.chamMats.vis[3], ultimate.chamMats.vis[4], ultimate.chamMats.invis[3], ultimate.chamMats.invis[3]

        v1:SetVector( "$selfIllumFresnelMinMaxExp", Vector( ultimate.cfg.vars["Fresnel minimum illum"], ultimate.cfg.vars["Fresnel maximum illum"], v ) )
        v2:SetVector( "$selfIllumFresnelMinMaxExp", Vector( ultimate.cfg.vars["Fresnel minimum illum"], ultimate.cfg.vars["Fresnel maximum illum"], v ) )
        v3:SetVector( "$selfIllumFresnelMinMaxExp", Vector( ultimate.cfg.vars["Fresnel minimum illum"], ultimate.cfg.vars["Fresnel maximum illum"], v ) )
        v4:SetVector( "$selfIllumFresnelMinMaxExp", Vector( ultimate.cfg.vars["Fresnel minimum illum"], ultimate.cfg.vars["Fresnel maximum illum"], v ) )
    end )

    local p = ultimate.itemPanel("Outlines",2,115):GetItemPanel()

    ultimate.ui.CheckBox( p, "Player outline", "Player outline", false, false, true )
    ultimate.ui.CheckBox( p, "Entity outline", "Entity outline", false, false, true )
    ultimate.ui.ComboBox( p, "Style", "Outline style", { "Default", "Subtractive", "Additive" } )

    local p = ultimate.itemPanel( "Indicators", 2, 145 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "On screen logs", "On screen logs", false, false, true, false, false, function(p) ultimate.ui.ColorPicker( "Miss lagcomp", p ) ultimate.ui.ColorPicker( "Miss spread", p ) ultimate.ui.ColorPicker( "Miss fail", p ) end )
    ultimate.ui.CheckBox( p, "Spectator list", "Spectator list" )
    ultimate.ui.CheckBox( p, "Tickbase indicator", "Tickbase indicator" )
    --ultimate.ui.CheckBox( p, "WaterMark", "WaterMark" )
    ultimate.ui.CheckBox( p, "Ultimate Indicators", "Indicators" )



    local p = ultimate.itemPanel("World",3,320):GetItemPanel()

    ultimate.ui.TextEntry( "Skybox texture", "Custom sky", p, 420 )
    ultimate.ui.CheckBox( p, "Sky color", "Sky color", false, false, true )
    ultimate.ui.CheckBox( p, "Wall color", "Wall color", false, false, true )
    ultimate.ui.CheckBox( p, "Render", "Color_Modify", false, false, false, ultimate.spfuncs[123] )
    ultimate.ui.CheckBox( p, "Bullet tracers", "Bullet tracers", false, false, true, ultimate.spfuncs[18] )
    ultimate.ui.TextEntry( "Material", "Bullet tracers material", p, 420 )
    ultimate.ui.CheckBox( p, "Fullbright", "Fullbright", false, true )
    ultimate.ui.ComboBox( p, "Mode", "Fullbright mode", { "Default", "Corvus extreme" } )
    ultimate.ui.CheckBox( p, "Disable shadows", "Disable shadows" )




    local p = ultimate.itemPanel("View",3,215):GetItemPanel()

    ultimate.ui.CheckBox( p, "Third person", "Third person", false, true, false, ultimate.spfuncs[20] )
    ultimate.ui.CheckBox( p, "Free camera", "Free camera", false, true, false, ultimate.spfuncs[21] )

    ultimate.ui.Slider( p, "Fov override","Fov override",70,160,0 )
    ultimate.ui.Slider( p, "Viewmodel fov","Viewmodel fov",50,180,0 )
    ultimate.ui.CheckBox( p, "Viewmodel manip","Viewmodel manip", false, false, false, ultimate.spfuncs[124] )
    ultimate.ui.Slider( p, "Aspect ratio","Aspect ratio",0,2,3,function(val) gRunCmd("r_aspectratio",val) end )

    local p = ultimate.itemPanel( "Misc", 3, 220 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Hide name", "Hide name" )
    ultimate.ui.TextEntry( "Custom name", "Custom name", p, 999 )
    ultimate.ui.CheckBox( p, "Disable sensivity adjustment", "Disable SADJ" )
    ultimate.ui.CheckBox( p, "Screengrab image", "Screengrab image" )


    /*





    ultimate.checkbox("Kill sound","Killsound",p:GetItemPanel())


    local p = ultimate.itemPanel("World",2,123)



    local p = ultimate.itemPanel("Effects",2,142)





    local p = ultimate.itemPanel("View",3,275)




    // ultimate.ESPPP:Show()
*/
end

ultimate.spfuncs[25] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Strafe mode", "Strafe mode", {"Legit","Rage","Multidir"})
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Ground strafer", "Ground strafer" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Sin ( snake ) strafe", "Z Hop", false, true )
end

ultimate.spfuncs[26] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Predict ticks", "CStrafe ticks", 16, 128, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Angle step", "CStrafe angle step", 1, 10, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Angle max step", "CStrafe angle max step", 5, 50, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Ground diff", "CStrafe ground diff", 1, 65, 0 )
end

ultimate.spfuncs[27] = function( p )
    ultimate.ui.TextEntry( "Name", "Name Convar", p, 250 )
    ultimate.ui.Button( "Change name", function() ded.NetSetConVar("name",ultimate.cfg.vars["Name Convar"]) end, p )
    ultimate.ui.CheckBox( p, "Name stealer", "Name stealer" )
    ultimate.ui.CheckBox( p, "Name generator", "Name generator" )

    ultimate.ui.TextEntry( "Disconnect reason", "Disconnect reason", p, 250 )
    ultimate.ui.Button( "Disconnect", function() ded.NetDisconnect(ultimate.cfg.vars["Disconnect reason"]) end, p )
end

function ultimate.CustomCvarVal( net )
    local m = net == 1 and "Net Convar mode" or "Cvar mode"
    local n = net == 1 and "Net Convar int" or "Cvar int"
    local s = net == 1 and "Net Convar str" or "Cvar str"

    local mode = ultimate.cfg.vars[m]
    local num = ultimate.cfg.vars[n]
    local set = mode == 2 and math_Round( num ) or num

    if mode == 1 then set = ultimate.cfg.vars[s] end

    return set
end

ultimate.spfuncs[28] = function( p )
    ultimate.ui.TextEntry( "Cvar name", "Net Convar", p, 250 )
    ultimate.ui.Slider( p, "Cvar int", "Net Convar int", 1, 100, 2 )
    ultimate.ui.TextEntry( "Cvar str", "Net Convar str", p, 250 )

    ultimate.ui.ComboBox( p, "Set mode", "Net Convar mode", {"String","Int","Float"})

    ultimate.ui.Button( "Send new val", function() ded.NetSetConVar( ultimate.cfg.vars["Net Convar"] ,ultimate.CustomCvarVal( 1 ) ) end, p )
end

ultimate.FCVAR = {
    str = {
        "Archive", "Archive XBOX", "Cheat", "Client can execute", "Client DLL", "Demo", "Dont record",
        "Game DLL", "Lua client", "Lua server", "Never as string", "None", "Notify", "Not connected",
        "Printable only", "Protected", "Replicated", "Server cannot query", "Server can execute",
        "Sponly", "Unlogged", "Unregistered", "Userinfo"
    },
    int = {
        128, 16777216, 16384, 1073741824, 8, 65536, 131072, 4, 262144, 524288, 4096, 0, 256, 4194304,
        1024, 32, 8192, 536870912, 268435456, 64, 2048, 1, 512
    }
}

ultimate.spfuncs[87] = function()
    ultimate.ui.SettingsPan:SetSize(180,200)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Bhop safe", "Bhop safe" )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Stop bhop in step", "Bhop safe duplex", 1, 10, 0 )
end

ultimate.spfuncs[23333] = function()
    ultimate.ui.SettingsPan:SetSize(280,180)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Type", "crosshair_type", ultimate.crosshairTypes)
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Scale", "uber_alles_scale", 1, 50, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Speed", "uber_alles_speed", 1, 500, 0 )
    ultimate.ui.Label( ultimate.ui.SettingsPan, "Crosshair Color", function( p ) ultimate.ui.ColorPicker( "crosshair_color", p ) end )
    ultimate.ui.Label( ultimate.ui.SettingsPan, "Crosshair Outline", function( p ) ultimate.ui.ColorPicker( "crosshair_outline", p ) end )
end



ultimate.spfuncs[29] = function( p )
    ultimate.ui.TextEntry( "Enter cvar name", "Cvar name", p, 500 )
    ultimate.ui.Slider( p, "Custom number", "Cvar int", 1, 1000, 2 )
    ultimate.ui.TextEntry( "Custom string", "Cvar str", p, 500 )

    ultimate.ui.ComboBox( p, "Cvar mode", "Cvar mode", {"String","Int","Float"})

    ultimate.ui.Button( "Change cvar", function()
        local s = ultimate.CustomCvarVal( 0 )
        local n = ultimate.cfg.vars["Cvar name"]

        local flag = GetConVar(n):GetFlags()

        ded.CVarSetFlags( n, 0 )

        gRunCmd( n, s )

        ded.CVarSetFlags( n, flag )
    end, p )

    ultimate.ui.ComboBox( p, "Cvar flag", "Cvar flag", ultimate.FCVAR.str)

    ultimate.ui.Button( "Change flag", function()
        ded.CVarSetFlags( ultimate.cfg.vars["Cvar name"], ultimate.FCVAR.int[ ultimate.cfg.vars["Cvar flag"] ] )
        print( ultimate.cfg.vars["Cvar name"], ultimate.FCVAR.int[ ultimate.cfg.vars["Cvar flag"] ] )
    end, p )

end

function ultimate.tabs.Misc()

    local function func( p )
        ultimate.ui.MTButton( p, "Cvar", ultimate.spfuncs[29] )
        ultimate.ui.MTButton( p, "Net cvar", ultimate.spfuncs[28] )
        ultimate.ui.MTButton( p, "Net", ultimate.spfuncs[27] )
    end

    local p = ultimate.itemPanel("Movement",1,350):GetItemPanel()

    ultimate.ui.CheckBox( p, "Bunny hop", "Bhop", false, false, false, ultimate.spfuncs[87] )
    ultimate.ui.CheckBox( p, "Air strafer", "Air strafer", false, false, false, ultimate.spfuncs[25] )
    ultimate.ui.CheckBox( p, "Circle strafe", "Circle strafe", false, true, false, ultimate.spfuncs[26] )
    ultimate.ui.CheckBox( p, "Keep sprint", "Sprint" )
    ultimate.ui.CheckBox( p, "Abuse sprint", "Bug Sprint" )
    ultimate.ui.CheckBox( p, "Fast stop", "Fast stop" )
    ultimate.ui.CheckBox( p, "Auto peak", "Auto peak", false, true )
    ultimate.ui.CheckBox( p, "Auto teleport back", "Auto peak tp" )
    ultimate.ui.CheckBox( p, "Water walk", "Water jump" )
    ultimate.ui.CheckBox( p, "FixMovement", "FixMovement" )
    ultimate.ui.CheckBox( p, "SlowWalk", "Slow Walk", false, true )
    ultimate.ui.Slider( p, "SlowWalk speed", "Slow Walk speed", 0,10,0 )

    local p = ultimate.itemPanel("Key spam",1,200):GetItemPanel()

    ultimate.ui.CheckBox( p, "Use spam", "Use spam" )
    ultimate.ui.CheckBox( p, "Flashlight spam", "Flashlight spam" )
    ultimate.ui.CheckBox( p, "Auto GTA", "Auto GTA" )
    ultimate.ui.CheckBox( p, "Camera spam", "Camera spam" )
    ultimate.ui.CheckBox( p, "Vape spam", "Vape spam" )
    //ultimate.ui.CheckBox( p, "Door ебалка", "DoorZaeba" )
    //ultimate.ui.CheckBox( p, "Anim bug", "AnimBug" )



    ultimate.ui.CheckBox( p, "ModelChanger player", "Modelchanger" )
    ultimate.ui.ComboBox( p, "ModelChanger model", "Modelchanger model", {"charple","Sigma","gman","Wolter", "Skadi", "Ment", "TT"} )
    //ultimate.ui.CheckBox( p, "ModelChanger me", "Player_modelchanger")
    //ultimate.ui.ComboBox( p, "ModelChanger model", "Player_modelchanger_agent", {"charple","male_03","Gman","zombie"} )

    local p = ultimate.itemPanel("Chat spam",2,250):GetItemPanel()

    ultimate.ui.CheckBox( p, "Killsay", "Killsay" )
    ultimate.ui.ComboBox( p, "Mode", "Killsay mode", { "Лучшее 22-23", "Унижалка English", "Школа хвх", "AI унижалка", "School HVH" })
    ultimate.ui.CheckBox( p, "ChatSpam", "Chatspam" )
    ultimate.ui.ComboBox( p, "ChatSpam Mode", "Chatspam mode", {"Пенис деда","Пенис деда 2","Arabic","Turkish","Cursed","Extra fucked","Brawls stars XXX"})
    ultimate.ui.Slider( p, "ChatSpam timer", "Chatspam timer", 0,10,0 )

    //ultimate.ui.ComboBox( p, "Spam mode", {"Русский сборник сказок","Rage","Multidir"}, "Spam mode")

    ultimate.itemPanelB( "Net / Cvar", 3, 345, func )

    local p = ultimate.itemPanel( "Animation breaker", 2, 235 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Taunt spam", "Taunt spam" )
    ultimate.ui.ComboBox( p, "Taunt", "Taunt", ultimate.actCommands )
    ultimate.ui.ComboBox( p, "Taunt", "Taunt", ultimate.actCommands )
    ultimate.ui.CheckBox( p, "Handjob", "Handjob" )
    ultimate.ui.ComboBox( p, "Handjob mode", "Handjob mode", {"Up","Parkinson","Ultra cum"} )

    local p = ultimate.itemPanel("Memes",3,300):GetItemPanel()

    ultimate.ui.CheckBox( p, "Admin Detect Grust", "admin_detect" )
    ultimate.ui.CheckBox( p, "Admin Detect Grust 2", "admin detect new" )
    ultimate.ui.CheckBox( p, "Ghost follower", "Ghost follower" )
    ultimate.ui.TextEntry( "Targets ID", "GFID", p, 500 )
    ultimate.ui.CheckBox( p, "Auto Затяг ( Vape )", "Auto Vape" )
    ultimate.ui.CheckBox( p, "Fast lockpick", "Fast lockpick" )

   /*
        ultimate.checkbox("Safe hop","Safe hop",p:GetItemPanel())
        ultimate.checkbox("Edge jump","Edge jump",p:GetItemPanel())
        ultimate.checkbox("Air duck","Air duck",p:GetItemPanel())
    */
end


function ultimate.updateMenuColor( col )
    local r, g, b = col.r, col.g, col.b

    for i = 1,255 do
        ultimate.Colors[i] = Color( i + r, i + g, i + b, 255 )
    end
end



function ultimate.tabs.Settings()
    local p = ultimate.itemPanel("Config",1,400):GetItemPanel()

    ultimate.ui.TextEntry( "Config name", "Config name", p, 64 )

    ultimate.ui.ComboBox( p, "Config", "Selected config", ultimate.configs)

    ultimate.ui.Button( "Save config", function() ultimate.SaveConfig() end, p )
    ultimate.ui.Button( "Load config", function() ultimate.LoadConfig() end, p )



    ultimate.ui.Label( p, "Menu color", function( p ) ultimate.ui.ColorPicker( "Menu color", p, ultimate.updateMenuColor ) end )
    ultimate.ui.Label( p, "Unhook cheat", function( p ) ultimate.ui.Binder( "Unhook cheat", p ) end )
end

function ultimate.tabs.Players()
    local playerlist = vgui.Create( "UListView", ultimate.scrollpanel )
    playerlist:SetPos( 5, 5 )
    playerlist:SetSize( 500, 775 )
    playerlist:SetMultiSelect( false )
    playerlist:AddColumn( "Name" )
    playerlist:AddColumn( "SID" )
    playerlist:AddColumn( "SID64" )
    playerlist:AddColumn( "Team" )
    playerlist:AddColumn( "Group" )
    playerlist:AddColumn( "Friend?" )

    local plys = player_GetAll()

    for i = 1, #plys do
        local item = playerlist:AddLine( plys[ i ]:Name(), plys[ i ]:SteamID(), plys[ i ]:SteamID64(), team_GetName( plys[ i ]:Team() ), plys[ i ]:GetUserGroup(), ultimate.cfg.friends[plys[ i ]:SteamID64()] and 'true' or 'false' )

        function item:OnRightClick()
            if ultimate.cfg.friends[plys[ i ]:SteamID64()] then
                ultimate.cfg.friends[plys[ i ]:SteamID64()] = nil
            else
                ultimate.cfg.friends[plys[ i ]:SteamID64()] = true
            end

            item:SetColumnText( 6, ultimate.cfg.friends[plys[ i ]:SteamID64()] and 'true' or 'false' )
        end
    end

end

ultimate.ttable = {}

ultimate.ttable["Aimbot"]   = ultimate.tabs.Aimbot
ultimate.ttable["Rage"]     = ultimate.tabs.Rage
ultimate.ttable["Visuals"]  = ultimate.tabs.Visuals
ultimate.ttable["Misc"]     = ultimate.tabs.Misc
ultimate.ttable["Settings"] = ultimate.tabs.Settings
ultimate.ttable["Players"]  = ultimate.tabs.Players

function ultimate.initTab(tab)
    if ultimate.scrollpanel != nil then ultimate.scrollpanel:Remove() end

    ultimate.scrollpanel = vgui_Create("UScroll",ultimate.frame)

    ultimate.pty = { 5, 5, 5 }
    // ultimate.ESPPP:Hide()
    ultimate.ttable[tostring(tab)]()
end

function ultimate.tabButton(tab,par)
    surface_SetFont("tbfont")
    local w, h = surface_GetTextSize(tab)

    local fw = w + 93

    local tx, ty = fw/2 - w/2, 25/2-h/2 - 1

    local b = par:Add("DButton")
    b:Dock(LEFT)
    b:DockMargin(2,0,2,1)
    b:SetWide(fw)
    b:SetText("")

    function b:DoClick()
        ultimate.activetab = tab
        ultimate.initTab(tab)
    end

    function b:Paint(width,height)
        if ultimate.activetab == tab or self:OnDepressed() then
            surface_SetDrawColor(ultimate.Colors[54])
            surface_SetTextColor(245,245,245,255)
        elseif self:IsHovered() then
            surface_SetDrawColor(ultimate.Colors[40])
            surface_SetTextColor(225,225,225,255)
        else
            surface_SetDrawColor(ultimate.Colors[30])
            surface_SetTextColor(200,200,200,255)
        end

        surface_DrawRect(0,0,width,height)

        surface_SetFont("tbfont")
        surface_SetTextPos(tx,ty)
        surface_DrawText(tab)
    end
end

ultimate.tabButton( "Aimbot",        ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Rage",          ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Visuals",       ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Misc",          ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Settings",      ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Players",       ultimate.frame:GetTopPanel() )

ultimate.ttable["Aimbot"]()

// Input

function ultimate.IsKeyDown( key )
    if key >= 107 then
        return input_IsMouseDown( key )
    end

    return input_IsKeyDown( key )
end

/*
    Create Move start
*/

// cm stuff

ultimate.target             = false
ultimate.aimingrn           = false

ultimate.targetVector       = Vector()
ultimate.predictedVector    = Vector()
ultimate.backtrackVector    = Vector()
ultimate.nullVec            = Vector() * -1

ultimate.SilentAngle        = me:EyeAngles()

ultimate.SkipCommand        = false
ultimate.SendPacket         = true

ultimate.traceStruct        = { mask = MASK_SHOT, filter = me }
ultimate.badSweps           = { ["gmod_camera"] = true, ["manhack_welder"] = true, ["weapon_medkit"] = true, ["gmod_tool"] = true, ["weapon_physgun"] = true, ["weapon_physcannon"] = true, ["weapon_bugbait"] = true, }
ultimate.badSeqs            = { [ACT_VM_RELOAD] = true, [ACT_VM_RELOAD_SILENCED] = true, [ACT_VM_RELOAD_DEPLOYED] = true, [ACT_VM_RELOAD_IDLE] = true, [ACT_VM_RELOAD_EMPTY] = true, [ACT_VM_RELOADEMPTY] = true, [ACT_VM_RELOAD_M203] = true, [ACT_VM_RELOAD_INSERT] = true, [ACT_VM_RELOAD_INSERT_PULL] = true, [ACT_VM_RELOAD_END] = true, [ACT_VM_RELOAD_END_EMPTY] = true, [ACT_VM_RELOAD_INSERT_EMPTY] = true, [ACT_VM_RELOAD2] = true }
ultimate.cones              = {}
ultimate.AimCone              = {}
ultimate.parsedbones        = {}

ultimate.swbNormal          = bor(CONTENTS_SOLID, CONTENTS_OPAQUE, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, 402653442, CONTENTS_WATER)
ultimate.swbWall            = bor(CONTENTS_TESTFOGVOLUME, CONTENTS_EMPTY, CONTENTS_MONSTER, CONTENTS_HITBOX)
ultimate.swbPen             = {[MAT_SAND] = 0.5, [MAT_DIRT] = 0.8, [MAT_METAL] = 1.1, [MAT_TILE] = 0.9, [MAT_WOOD] = 1.2}
ultimate.swbShit            = { ["swb_knife"] = true, ["swb_knife_m"] = true }

ultimate.m9kPenetration     = { ["SniperPenetratedRound"] = 20, ["pistol"] = 9, ["357"] = 12, ["smg1"] = 14, ["ar2"] = 16, ["buckshot"] = 5, ["slam"] = 5, ["AirboatGun"] = 17, }
ultimate.m9kMaxRicochet     = { ["SniperPenetratedRound"] = 10, ["pistol"] = 2, ["357"] = 5, ["smg1"] = 4, ["ar2"] = 5, ["buckshot"] = 0, ["slam"] = 0, ["AirboatGun"] = 9, }
ultimate.m9kCanRicochet     = { ["SniperPenetratedRound"] = true, ["pistol"] = true, ["buckshot"] = true, ["slam"] = true }
ultimate.m9kPenMaterial     = { [MAT_GLASS] = true, [MAT_PLASTIC] = true, [MAT_WOOD] = true, [MAT_FLESH] = true, [MAT_ALIENFLESH] = true }

ultimate.activeWeapon       = false
ultimate.activeWeaponClass  = false
ultimate.moveType           = me:GetMoveType()

ultimate.myaw               = GetConVar("m_yaw"):GetFloat()

ultimate.backtracktick      = 0

function ultimate.AutoWall( dir, plyTarget )
	if not ultimate.activeWeapon or ultimate.swbShit[ ultimate.activeWeaponClass ] then return false end

	local eyePos = me:EyePos()

	local function SWBAutowall()

        ultimate.traceStruct.start = eyePos
        ultimate.traceStruct.endpos = eyePos + dir * ultimate.activeWeapon.PenetrativeRange
        ultimate.traceStruct.filter = ultimate.Piercable
        ultimate.traceStruct.mask = ultimate.swbNormal

		local tr = TraceLine( ultimate.traceStruct )

		if tr.Hit and !tr.HitSky then
			local dot = -dir:Dot(tr.HitNormal)

			if ultimate.activeWeapon.CanPenetrate and dot > 0.26 then

                ultimate.traceStruct.start = tr.HitPos
                ultimate.traceStruct.endpos = tr.HitPos + dir * ultimate.activeWeapon.PenStr * ( ultimate.swbPen[tr.MatType] or 1 ) * ultimate.activeWeapon.PenMod
                ultimate.traceStruct.filter = ultimate.Piercable
                ultimate.traceStruct.mask = ultimate.swbWall

				tr = TraceLine( ultimate.traceStruct )

                ultimate.traceStruct.start = tr.HitPos
                ultimate.traceStruct.endpos = tr.HitPos + dir * 0.1
                ultimate.traceStruct.filter = ultimate.Piercable
                ultimate.traceStruct.mask = ultimate.swbNormal

				tr = TraceLine( ultimate.traceStruct)

				if tr.Hit then return false end

                ultimate.traceStruct.start = tr.HitPos
                ultimate.traceStruct.endpos = tr.HitPos + dir * 32768
                ultimate.traceStruct.filter = ultimate.Piercable
                ultimate.traceStruct.mask = MASK_SHOT

				tr = TraceLine( ultimate.traceStruct )

                if ultimate.cfg.vars["Ignores-Head unhitable"] then
                    return tr.Entity == plyTarget and tr.HitGroup == 1
                else
                    return tr.Entity == plyTarget
                end
			end
		end

		return false
	end




    local function TFAAutoWall()

        local sv_tfa_bullet_penetration = GetConVar("sv_tfa_bullet_penetration")
	    local sv_tfa_penetration_hardlimit = GetConVar("sv_tfa_penetration_hardlimit")
	    local sv_tfa_bullet_penetration_power_mul = GetConVar("sv_tfa_bullet_penetration_power_mul")
        local sv_airaccelerate = GetConVar( "sv_airaccelerate" )
        local sv_gravity = GetConVar( "sv_gravity" )
        local sv_sticktoground = GetConVar( "sv_sticktoground" )

        ultimate.AutoWall.Functions.tfa = ENV.RegisterFunctionfunction(self, TraceData)
        if not ultimate.AutoWall.TFA:GetBool() then
            return nil
        end

        if ultimate.cfg.vars["Ignores-Head unhitable"] then
            return tr.Entity == plyTarget and tr.HitGroup == 1
        else
            return tr.Entity == plyTarget
        end

        local ForceMultiplier = self:GetAmmoForceMultiplier()
        local PenetrationMultiplier = self:GetPenetrationMultiplier(TraceData.MatType)
        local ConVarMultiplier = ultimate.AutoWall.TFA_Multiplier:GetFloat()
        local DataTable = ultimate.AutoWall.Limits[GetWeaponAmmoName(self)]
        local MaxPen = math.Clamp(DataTable and DataTable[2] or 1, 0, ultimate.AutoWall.TFA_HardLimit:GetInt())

        return math_Truncate(((ForceMultiplier / PenetrationMultiplier) * ConVarMultiplier) * 0.9, 5), MaxPen

    end


	local function M9KAutowall()
		if !ultimate.activeWeapon.Penetration then
			return false
		end

		local function BulletPenetrate( tr, bounceNum, damage )
			if damage < 1 then
				return false
			end

			local maxPenetration    = 14
            local maxRicochet       = 0
            local isRicochet        = false

            if ultimate.m9kPenetration[ ultimate.activeWeapon.Primary.Ammo ] then
                maxPenetration = ultimate.m9kPenetration[ ultimate.activeWeapon.Primary.Ammo ]
            end

            if ultimate.m9kMaxRicochet[ ultimate.activeWeapon.Primary.Ammo ] then
                maxRicochet = ultimate.m9kMaxRicochet[ ultimate.activeWeapon.Primary.Ammo ]
            end

            if ultimate.m9kCanRicochet[ ultimate.activeWeapon.Primary.Ammo ] then
                isRicochet = ultimate.m9kMaxRicochet[ ultimate.activeWeapon.Primary.Ammo ]
            end

			if tr.MatType == MAT_METAL and isRicochet and ultimate.activeWeapon.Primary.Ammo != "SniperPenetratedRound" then
				return false
			end

			if bounceNum > maxRicochet then
				return false
			end

			local penetrationDir = tr.Normal * maxPenetration

			if ultimate.m9kPenMaterial[ tr.MatType ] then
				penetrationDir = tr.Normal * ( maxPenetration * 2 )
			end

			if tr.Fraction <= 0 then
				return false
			end

			ultimate.traceStruct.endpos    = tr.HitPos
			ultimate.traceStruct.start     = tr.HitPos + penetrationDir
			ultimate.traceStruct.mask      = MASK_SHOT
			ultimate.traceStruct.filter    = ultimate.Piercable

			local trace = TraceLine( ultimate.traceStruct )

			if trace.StartSolid or trace.Fraction >= 1 then
				return false
			end

			ultimate.traceStruct.endpos = trace.HitPos + tr.Normal * 32768
			ultimate.traceStruct.start  = trace.HitPos
			ultimate.traceStruct.mask   = MASK_SHOT
			ultimate.traceStruct.filter = ultimate.Piercable

			local penTrace = TraceLine( ultimate.traceStruct )

            if ultimate.cfg.vars["Ignores-Head unhitable"] then
                return penTrace.Entity == plyTarget and penTrace.HitGroup == 1
            else
                return penTrace.Entity == plyTarget
            end

			local damageMulti = 0.5
			if ultimate.activeWeapon.Primary.Ammo == "SniperPenetratedRound" then
				damageMulti = 1
			elseif tr.MatType == MAT_CONCRETE or tr.MatType == MAT_METAL then
				damageMulti = 0.3
			elseif tr.MatType == MAT_WOOD or tr.MatType == MAT_PLASTIC or tr.MatType == MAT_GLASS then
				damageMulti = 0.8
			elseif tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH then
				damageMulti = 0.9
			end

			if penTrace.MatType == MAT_GLASS then
				bounceNum = bounceNum - 1
			end

			return BulletPenetrate( penTrace, bounceNum + 1, damage * damageMulti )
		end

        ultimate.traceStruct.start = eyePos
        ultimate.traceStruct.endpos = eyePos + dir * 32768
        ultimate.traceStruct.filter = ultimate.Piercable
        ultimate.traceStruct.mask = MASK_SHOT

		local trace = TraceLine( ultimate.traceStruct )

		return BulletPenetrate( trace, 0, ultimate.activeWeapon.Primary.Damage )
	end

    if StartsWith( ultimate.activeWeaponClass, "m9k_" ) then
		return M9KAutowall()
	elseif StartsWith( ultimate.activeWeaponClass, "swb_" ) then
		return SWBAutowall()
	elseif StartsWith( ultimate.activeWeaponClass, "tfa_" ) then
		return TFAAutowall()

    end


	return false
end



function ultimate.SetEntAngles(ent,angles)
    ent:SetRenderAngles(angles)
    ent:SetNetworkAngles(angles)
    ent:InvalidateBoneCache()
end

ultimate.Piercable = ents.FindByClass( "func_breakable" )
table.insert( ultimate.Piercable, me )


function ultimate.VisibleCheck( who, where, predticks, awalldir )
    local start = me:EyePos()

    if predticks then start = start + ( me:GetVelocity() * TickInterval ) * predticks end

    ultimate.traceStruct.start = start
	ultimate.traceStruct.endpos = where
	ultimate.traceStruct.mask = MASK_SHOT
    ultimate.traceStruct.filter = ultimate.Piercable

    local tr = TraceLine( ultimate.traceStruct )

    if tr.Entity:IsValid() and tr.Entity:GetClass() == "func_breakable" and not table.HasValue( ultimate.Piercable, tr.Entity ) then
        table.insert( ultimate.Piercable, tr.Entity )
    end

    local canhit = tr.Entity == who or tr.Fraction == 1

    if !canhit and awalldir and ultimate.cfg.vars["Wallz"] then
        return ultimate.AutoWall( awalldir, who )
    end

    if ultimate.cfg.vars["Ignores-Head unhitable"] and tr.HitGroup != 1 then return false end

    return canhit
end

function ultimate.CanShoot( cmd )
	if not ultimate.activeWeapon then return false end
	local seq = ultimate.activeWeapon:GetSequence()

    if ultimate.cfg.binds["Aim on key"] != 0 and not ultimate.IsKeyDown( ultimate.cfg.binds["Aim on key"] ) then
        return false
    end

	if ultimate.badSweps[ ultimate.activeWeaponClass ] then
		return false
	end

    local delay = 0
	if ultimate.cfg.vars["ShootDelay"] then
		delay = ultimate.cfg.vars["ShootDelay time"] / 1000

        return ( ded.GetServerTime(cmd) - delay ) >= ultimate.activeWeapon:GetNextPrimaryFire()

    end

    if ultimate.moveType == MOVETYPE_NOCLIP then
        return false
    end

    if ultimate.cfg.vars["Auto fire"] and cmd:KeyDown(IN_ATTACK) then
        return false
    end

	if ultimate.cfg.vars["Bullet time"] and ultimate.activeWeapon:GetNextPrimaryFire() >= ded.GetServerTime(cmd) then
		return false
	end

    if ultimate.cfg.vars["Server time"] and ultimate.activeWeapon:GetNextPrimaryFire() >= ultimate.servertime then
		return false
	end

    // print(ded.GetRandomSeed( cmd ))
    if ultimate.cfg.vars["Wait for seed"] and ded.GetRandomSeed( cmd ) then
        return false
    end

	return ultimate.activeWeapon:Clip1() != 0 and !ultimate.badSeqs[ seq ]
end

function ultimate.Spread( cmd, ang, spread )
    if not ultimate.activeWeapon or not ultimate.cones[ ultimate.activeWeaponClass ] then return ang end

	local dir = ded.PredictSpread( cmd, ang, spread )

	local newangle = ang + dir:Angle()
	newangle:Normalize()


	return newangle
end

/*
    Nospread
*/

ultimate.CustomSpread = {}

function ultimate.CustomSpread.swb( cmd, ang )
    /*
    local vel = me:GetVelocity():Length()
    local dir = ang:Forward()

    if !me.LastView then
        me.LastView = dir
        me.ViewAff = 0
    else
        me.ViewAff = Lerp( 0.25, me.ViewAff, ( dir - me.LastView ):Length() * 0.5 )
    end

    if ultimate.activeWeapon.dt and ultimate.activeWeapon.meSpread and ultimate.activeWeapon.dt.State == SWB_AIMING then
        ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.meSpread

        if ultimate.activeWeapon.Owner.Expertise then
            ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * ( 1 - ultimate.activeWeapon.Owner.Expertise["steadyme"].val * 0.0015 )
        end
    else
        ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.HipSpread

        if ultimate.activeWeapon.Owner.Expertise then
            ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * ( 1 - ultimate.activeWeapon.Owner.Expertise["wepprof"].val * 0.0015 )
        end
    end

    if me:Crouching() then
        ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * ( ultimate.activeWeapon.dt.State == SWB_AIMING and 0.9 or 0.75 )
    end

    ultimate.activeWeapon.CurCone = math_Clamp( ultimate.activeWeapon.BaseCone + ultimate.activeWeapon.AddSpread + ( vel / 10000 * ultimate.activeWeapon.VelocitySensitivity ) * ( ultimate.activeWeapon.dt.State == SWB_AIMING and ultimate.activeWeapon.meMobilitySpreadMod or 1 ) + me.ViewAff, 0, 0.09 + ultimate.activeWeapon.MaxSpreadInc )

    if CurTime() > ultimate.activeWeapon.SpreadWait then
        ultimate.activeWeapon.AddSpread = math_Clamp( ultimate.activeWeapon.AddSpread - 0.005 * ultimate.activeWeapon.AddSpreadSpeed, 0, ultimate.activeWeapon.MaxSpreadInc )
        ultimate.activeWeapon.AddSpreadSpeed = math_Clamp( ultimate.activeWeapon.AddSpreadSpeed + 0.05, 0, 1 )
    end
    */

    local cone = ultimate.activeWeapon.CurCone
    if !cone then return ang end

    if me:Crouching() then
        cone = cone * 0.85
    end

    math_randomseed( cmd:CommandNumber() )
    return ang - Angle( math_Rand(-cone, cone), math_Rand(-cone, cone), 0 ) * 25
end

function ultimate.CustomSpread.cw( cmd, ang )
    local cone = ultimate.activeWeapon.CurCone
    if !cone then return ang end

    math_randomseed( cmd:CommandNumber() )
    return ang - Angle( math_Rand(-cone, cone), math_Rand(-cone, cone), 0 ) * 25
end

function ultimate.CustomSpread.fas2( cmd, ang )
    math_randomseed( CurTime() )

    local dir = Angle( math_Rand( -ultimate.activeWeapon.CurCone, ultimate.activeWeapon.CurCone ), math_Rand( -ultimate.activeWeapon.CurCone, ultimate.activeWeapon.CurCone ), 0 ) * 25
    local dir2 = dir

    if ultimate.activeWeapon.ClumpSpread and ultimate.activeWeapon.ClumpSpread > 0 then
        dir2 = dir + Vector( math_Rand(-1, 1), math_Rand(-1, 1), math_Rand(-1, 1)) * ultimate.activeWeapon.ClumpSpread
    end

    return ang - dir2
end

local lastRandomSeed = 0
local lastSpreadCompensation = Angle(0, 0, 0)

-- Клиентский ноуспред
function ultimate.CustomSpread.rust(cmd, ang)
    if not IsValid(ultimate.activeWeapon) then return ang end
    if ultimate.activeWeaponClass == "rust_huntingbow" then return ang end

    local weapon = ultimate.activeWeapon
    local cone = weapon.AimCone or 0.2

    -- Учёт прицеливания
    if weapon.IronSightsDelta > 0.1 then
        cone = Lerp(weapon.IronSightsDelta, cone, cone * 0.05)
    end

    -- Генерация предсказуемого разброса
    math.randomseed(cmd:CommandNumber())
    lastRandomSeed = cmd:CommandNumber()

    local spread = Vector(cone, cone, 0) * 16
    lastSpreadCompensation = Angle(
        math.Rand(-spread.x, spread.x),
        math.Rand(-spread.y, spread.y),
        0
    )

    return ang - lastSpreadCompensation
end


/*function ultimate.CustomSpread.CSS( cmd, ang )
    math_randomseed( CurTime() )

    local dir = Angle( math_Rand( -ultimate.activeWeapon.CurCone, ultimate.activeWeapon.CurCone ), math_Rand( -ultimate.activeWeapon.CurCone, ultimate.activeWeapon.CurCone ), 0 ) * 25
    local dir2 = dir

    if ultimate.activeWeapon.ClumpSpread and ultimate.activeWeapon.ClumpSpread > 0 then
        dir2 = dir + Vector( math_Rand(-1, 1), math_Rand(-1, 1), math_Rand(-1, 1)) * ultimate.activeWeapon.ClumpSpread
    end

    return ang - dir2

end*/

local cssweapon = { "weapon_ak47", "weapon_m4a1","weapon_awp","weapon_aug","weapon_deagle","weapon_elite","weapon_famas","weapon_fiveseven","weapon_g3sg1","weapon_galil","weapon_glock","weapon_m249","weapon_m3","weapon_mac10","weapon_mp5navy","weapon_p228","weapon_p90","weapon_scout","weapon_sg550","weapon_sg552","weapon_tmp","weapon_ump45","weapon_usp","weapon_xm1014" }

ultimate.SpreadComps = {noworking}

ultimate.SpreadComps["swb"]     = ultimate.CustomSpread.swb
ultimate.SpreadComps["cw"]      = ultimate.CustomSpread.cw
ultimate.SpreadComps["fas2"]    = ultimate.CustomSpread.fas2
ultimate.SpreadComps["rust"]     = ultimate.CustomSpread.rust
/*for i = 1, #cssweapon do
    ultimate.SpreadComps[cssweapon[ i ]]     = ultimate.CustomSpread.CSS
end*/



function ultimate.NoSpread(cmd, ang)
    if not ultimate.activeWeapon or ultimate.swbShit[ ultimate.activeWeaponClass ] then return ang end
    local base = string.Split( ultimate.activeWeaponClass, "_" )[ 1 ]

    if ultimate.SpreadComps[ base ] then
        ang = ultimate.SpreadComps[ base ]( cmd, ang )
    elseif ultimate.cones[ ultimate.activeWeaponClass ] then
        local spread = ultimate.cones[ ultimate.activeWeaponClass ]
        return ultimate.Spread( cmd, ang, spread )
    //elseif ultimate.SpreadComps[ basecss ] then
       //ang = ultimate.SpreadComps[ basecss ]( cmd, ang )
    end

    return ang
end

ultimate.notyui = {
    ["rust_assaultrifle"] = true,
    ["rust_hands"] = true,
    ["rust_huntingbow"] = true,
    ["rust_mp5"] = true,
    ["rust_sar"] = true,
    ["rust_nailgun"] = true,
    ["weapon_crossbow"] = true,
    ["rust_smg"] = true,
    ["rust_thompson"] = true,
    ["rust_sap"] = true,
    ["rust_python"] = true,
    ["rust_lr300"] = true,
    ["rust_m249"] = true,
    ["rust_m39"] = true,
    ["rust_m92"] = true,
    ["rust_revolver"] = true,
    ["rust_crossbow"] = true,
}

ultimate.yui = {
    ["rust_pumpshotgun"] = true,
    ["rust_dbarrel"] = true,
    ["rust_spas12"] = true,
    ["rust_waterpipe"] = true,
    ["rust_shotgun"] = true,
}

function ultimate.NoRecoil( ang )
    if StartsWith( ultimate.activeWeaponClass,"m9k_" ) or StartsWith( ultimate.activeWeaponClass,"bb_" ) or StartsWith( ultimate.activeWeaponClass,"unclen8_" ) or ultimate.activeWeaponClass == "weapon_pistol" then
        return ang
    else
        ang = ang - me:GetViewPunchAngles()
    end
    return ang
end

/*function ultimate.gRustNoRecoil( ang )
    ang = ang - me:GetViewPunchAngles()
    return ang
end*/


/*
ultimate.ui.ComboBox( p, "Hitscan mode", { "Damage", "Safety", "Scale" }, "Hitscan mode" )

*/

function ultimate.ParseBones( ply, bone )
    local mdl = ply:GetModel()

    if ultimate.parsedbones[ mdl ] and ultimate.parsedbones[ mdl ][ bone ] then
        return ultimate.parsedbones[ mdl ][ bone ]
    end

    if not ultimate.parsedbones[ mdl ] then
        ultimate.parsedbones[ mdl ] = {}
    end

    local set = ply:GetHitboxSet()
    local bonecount = ply:GetBoneCount()

    for i = 0, bonecount - 1 do
		local group = ply:GetHitBoxHitGroup( i, set )

        if group == nil then continue end

		if bone == group then
			ultimate.parsedbones[ mdl ][ bone ] = i

            return i
        end
	end

    for i = 0, bonecount - 1 do
        local group = ply:GetHitBoxHitGroup( i, set )

        if group == nil then continue end

        if bone > 1 and group == 0 then
            ultimate.parsedbones[ mdl ][ bone ] = i

            return i
        end
    end

    return 0
end

function ultimate.MultipointGroupCheck( group )
    if group == 1 and not ultimate.cfg.vars["Multipoint groups-Head"] then return false end
    if group == 2 and not ultimate.cfg.vars["Multipoint groups-Chest"] then return false end
    if group == 3 and not ultimate.cfg.vars["Multipoint groups-Stomach"] then return false end
    if group == 4 or group == 5 and not ultimate.cfg.vars["Multipoint groups-Arms"] then return false end
    if group == 6 or group == 7 and not ultimate.cfg.vars["Multipoint groups-Legs"] then return false end
    if group == 0 and not ultimate.cfg.vars["Multipoint groups-Generic"] then return false end

    return true
end

/*function GetBoneRanking( ply,tbl,bone )
    local boneName = ply:GetBoneName(bone)
	local rankingCache = boneRankingCache[tbl]


    if rankingCache[boneName] then
		return rankingCache[boneName]
	end

	for i = 1, #tbl do
		local name = tbl[i]
		if boneName:find(name, 1, true) then
			rankingCache[boneName] = i
			return i
		end
	end

	return 1000
end*/

local x = true
local y = true

function ultimate.GetBones( ply )
    local scale = ultimate.cfg.vars["Multipoint scale"]
    local pos = ply:LocalToWorld( ply:OBBCenter() )
    local set = ply:GetHitboxSet()

    if ultimate.cfg.vars["Hitscan"] then
        local set = ply:GetHitboxSet()
        local bonecount = ply:GetBoneCount()

        pos = {}

        for i = 0, bonecount - 1 do
            local group = ply:GetHitBoxHitGroup( i, set )

            if group == nil then continue end

            if group == 1 and not ultimate.cfg.vars["Hitscan groups-Head"] then continue end
            if group == 2 and not ultimate.cfg.vars["Hitscan groups-Chest"] then continue end
            if group == 3 and not ultimate.cfg.vars["Hitscan groups-Stomach"] then continue end
            if group == 4 or group == 5 and not ultimate.cfg.vars["Hitscan groups-Arms"] then continue end
            if group == 6 or group == 7 and not ultimate.cfg.vars["Hitscan groups-Legs"] then continue end
            if group == 0 and not ultimate.cfg.vars["Hitscan groups-Generic"] then continue end

            pos[ #pos + 1 ] = { bone = i, hitgroup = group }

            /*local hitScanMode = ultimate.cfg.vars["Hitscan Mode"]
            if hitScanMode == 1 then
                table_sort( bone, function(a, b)
                    local rankA = GetBoneRanking(ply, damageRanking, a[1])
                    local rankB = GetBoneRanking(ply, damageRanking, b[1])

                    return rankA < rankB
                end)
            elseif hitScanMode == 2 then
                table_sort( bone, function(a, b)
                    return a[3] > b[3]
                end)
            elseif hitScanMode == 3 then
                table_sort( bone, function(a, b)
                    local rankA = GetBoneRanking(ply, safetyRanking, a[1])
                    local rankB = GetBoneRanking(ply, safetyRanking, b[1])

                    return rankA < rankB
                end)
            end*/

        end



        if not pos or not istable( pos ) then return end

        local valid = {}

        for i = 1, #pos do
            local bone = pos[ i ].bone
            local hitboxbone = ply:GetHitBoxBone( bone, set )

            if hitboxbone == nil then
                continue
            end

            local mins, maxs = ply:GetHitBoxBounds( bone, set )

            if not mins or not maxs then
                continue
            end

            local bonepos, ang = ply:GetBonePosition( hitboxbone )

            if ultimate.cfg.vars["Multipoint"] and ultimate.MultipointGroupCheck( pos[ i ].hitgroup ) then
                local points = {
                    ( ( mins + maxs ) * 0.5 ),
                    Vector( mins.x, mins.y, mins.z ),
                    Vector( mins.x, maxs.y, mins.z ),
                    Vector( maxs.x, maxs.y, mins.z ),
                    Vector( maxs.x, mins.y, mins.z ),
                    Vector( maxs.x, maxs.y, maxs.z ),
                    Vector( mins.x, maxs.y, maxs.z ),
                    Vector( mins.x, mins.y, maxs.z ),
                    Vector( maxs.x, mins.y, maxs.z )
                }

                for i = 1, #points do
                    points[ i ]:Rotate( ang )
                    points[ i ] = points[ i ] + bonepos

                    if i == 1 then continue end

                    points[ i ] = ( ( points[ i ] - points[1] ) * scale ) + points[ 1 ]
                    valid[ #valid + 1 ] = points[ i ]
                end
            end

            mins:Rotate( ang )
            maxs:Rotate( ang )

            valid[ #valid + 1 ] = bonepos + ( ( mins + maxs ) * 0.5 )
        end

        return valid
    else

        local bone = ultimate.ParseBones( ply, ultimate.cfg.vars["Hitbox selection"] )

        local hitboxbone = ply:GetHitBoxBone( bone, set )

        if hitboxbone == nil then
            return { pos }
        end

        local mins, maxs = ply:GetHitBoxBounds( bone, set )

        if not mins or not maxs then
            return { pos }
        end

        local bonepos, ang = ply:GetBonePosition( hitboxbone )

        if ultimate.cfg.vars["Multipoint"] then
            local points = {
                ( ( mins + maxs ) * 0.5 ),
                Vector( mins.x, mins.y, mins.z ),
                Vector( mins.x, maxs.y, mins.z ),
                Vector( maxs.x, maxs.y, mins.z ),
                Vector( maxs.x, mins.y, mins.z ),
                Vector( maxs.x, maxs.y, maxs.z ),
                Vector( mins.x, maxs.y, maxs.z ),
                Vector( mins.x, mins.y, maxs.z ),
                Vector( maxs.x, mins.y, maxs.z )
            }

            for i = 1, #points do
                points[ i ]:Rotate( ang )
                points[ i ] = points[ i ] + bonepos

                if i == 1 then continue end

                points[ i ] = ( ( points[ i ] - points[1] ) * scale ) + points[ 1 ]
            end

            return points
        else
            mins:Rotate( ang )
            maxs:Rotate( ang )

            pos = bonepos + ( ( mins + maxs ) * 0.5 )
        end
    end

    return { pos }
end

function ultimate.GetSortedPlayers( mode, selfpred, plypred, vischeck )
    local players   = player_GetAll()
    local eyepos    = me:EyePos()
    local valid     = {}                // sorted lady and gentleman goes here ( niggers and faggots goes to hell )

	if selfpred then
		eyepos = eyepos + (me:GetVelocity() * TickInterval) * selfpred
	end

    for i = 1, #players do
        local v = players[i]

        if v == me then continue end
        if not v:Alive() or v:IsDormant() then continue end
        if ultimate.cfg.vars["Ignores-Bots"] and v:IsBot() then continue end
        if ultimate.cfg.vars["Ignores-Friends"] and ultimate.cfg.friends[v:SteamID64()] then continue end
        if ultimate.cfg.vars["Ignores-Steam friends"] and v:GetFriendStatus() == "friend" then continue end
        if ultimate.cfg.vars["Ignores-Admins"] and v:IsAdmin() then continue end
        if ultimate.cfg.vars["Ignores-Frozen"] and v:IsFlagSet( FL_FROZEN ) then continue end
        if ultimate.cfg.vars["Ignores-Nodraw"] and v:IsEffectActive( EF_NODRAW ) then continue end
        if ultimate.cfg.vars["Ignores-God time"] and v:GetColor().a < 255 then continue end
        if ultimate.cfg.vars["Ignores-Driver"] and v:InVehicle() then continue end
        if ultimate.cfg.vars["Ignores-Break LC"] and v.break_lc then continue end
        if st == TEAM_SPECTATOR or ultimate.cfg.vars["Ignores-Teammates"] and st == v:Team() then continue end
        if ultimate.cfg.vars["Ignores-Nocliping"] and v:IsEFlagSet(EFL_NOCLIP_ACTIVE) then continue end

        if ultimate.cfg.vars["admin_detect"] then
            if v:SteamID64() == "76561198293925967" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561199276141767" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: travka | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561198307391005" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561199101866406" and v:SteamID64() == "76561198827382515" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: pivo | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561199548703904" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: TuPiDAn | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561198966084690" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: USA | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561198124074227" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: ньюген какойта | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            /*if v:SteamID64() == "76561198135631170" then --на всякий случай
                //gRunCmd("disconnect")
                //print("Тебя кикнуло потому что включен админ обнаруживатель")
                //print("основной нейм: Smile | стим айди:",v:SteamID64())
                //print("псведоним админа:",v:Name())
            end*/
            if v:SteamID64() == "76561199305487923" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: george | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561199082487641" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: ВладикНН | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561199222590247" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: KareemYT | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561199419032817" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: Blank | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561198078979803" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: Drelay | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
            if v:SteamID64() == "76561198453470054" then
                gRunCmd("disconnect")
                print("Тебя кикнуло потому что включен админ обнаруживатель")
                print("основной нейм: Fox`si | стим айди:",v:SteamID64())
                print("псведоним админа:",v:Name())
            end
        end
        /*if ultimate.cfg.vars["admin detect new"] then
            if rank_GetName( v:Rank() ) and v:SteamID64() == (rank) then
                gRunCmd("disconnect")
            end
        end*/

        if vischeck then
			local bone = ultimate.GetBones( v )[1]
			local dir = me:GetShootPos() - bone
			dir:Normalize()

			if !ultimate.VisibleCheck( v, bone, selfpred, dir ) then
				continue
			end
		end

        local pos = v:GetPos()
        if plypred then
            pos = pos + (v:GetVelocity() * TickInterval) * plypred
        end

        valid[#valid+1] = { v, pos }
    end

    if mode == 1 then
        table_sort(valid, function( a, b )
           return ( a[2] - eyepos ):LengthSqr() < ( b[2] - eyepos ):LengthSqr()
        end)
    elseif mode == 2 then
        table_sort(valid, function( a, b )
            local aScr, bScr = a[2]:ToScreen(), b[2]:ToScreen()

            local aDist
            do
                local dx = scrwc - aScr.x
                local dy = scrhc - aScr.y
                aDist = dx * dx + dy * dy
            end

            local bDist
            do
                local dx = scrwc - bScr.x
                local dy = scrhc - bScr.y
                bDist = dx * dx + dy * dy
            end

            return aDist < bDist
        end)
    /*elseif mode == 3 then
        table_sort(valid, function( a, b )
            return ( a[2] + eyepos ):LengthSqr() > ( b[2] + eyepos ):LengthSqr()
        end)

    elseif mode == 4 then
        table_sort(valid, function( a, b )
            local aScr, bScr = a[2]:ToScreen(), b[2]:ToScreen()

            local aDist
            do
                local dx = scrwc - aScr.x
                local dy = scrhc - aScr.y
                aDist = dx * dx - dy * dy
            end

            local bDist
            do
                local dx = scrwc - bScr.x
                local dy = scrhc - bScr.y
                bDist = dx * dx - dy * dy
            end

            return aDist > bDist
        end)*/
    elseif mode == 5 then
     return

    end

    if #valid == 0 then return end

    return valid

end

function ultimate.IsTickHittable( ply, cmd, tick )
    if ded.GetLatency(0) > 1 then return false end

    local serverArriveTick = ded.GetServerTime(cmd) + ded.GetLatency(0) + ded.GetLatency(1)
    local diff = serverArriveTick - ultimate.btrecords[ ply ][ tick ].simulationtime

    if diff > ultimate.cfg.vars["Backtrack time"] / 1000 then return false end

    return true
end

function ultimate.FindBacktrack( cmd, ply )
    local ticks = #ultimate.btrecords[ ply ]
    local canhit = {}

    for i = 1, ticks do
        if ultimate.IsTickHittable( ply, cmd, i ) then
            canhit[ #canhit + 1 ] = i
        end
    end

    return canhit
end

function ultimate.FindFirstHittableTicks( ply, cmd )
    local tickcount = #ultimate.btrecords[ ply ]

    if !tickcount then return 1 end

    for i = 1, tickcount do
        if ultimate.IsTickHittable( ply, cmd, i ) then
            return i
        end
    end
end

do
    local lastdist, lasttick = 1337, 1

    function ultimate.FindClosestHittableTicks( ply, cmd )
        local mypos = me:EyePos()
        local records = ultimate.btrecords[ ply ]
        local firstticks = ultimate.FindFirstHittableTicks( ply, cmd )
        local tickcount = #records

        if !tickcount or !firstticks then return 1 end

        lastdist = math_huge

        for i = 1, tickcount - firstticks do
            local mt = i + firstticks

            if ( records[ mt ].aimpos ):DistToSqr( mypos ) < lastdist then
                lastdist = ( records[ mt ].aimpos ):DistToSqr( mypos )
                lasttick = mt
            end
        end

        return lasttick
    end
end

function ultimate.SelectTarget( cmd )
    local plys = ultimate.GetSortedPlayers( ultimate.cfg.vars["Target selection"] )
    ultimate.target     = false


    if !plys then return end

    local maxplys       = ultimate.cfg.vars["Max targets"]
    local curplys       = #plys

    if maxplys != 0 and curplys > maxplys then
        curplys = maxplys
    end

    local aimAngle
    for i = 1, curplys do
		local ply = plys[i][1]

        if not ultimate.cfg.vars["Always backtrack"] then
            local bones = ultimate.GetBones( ply )

            for o = 1, #bones do
                local bone = bones[o]
                aimAngle = ( bone - me:EyePos() ):Angle()

                if ultimate.VisibleCheck( ply, bone, nil, aimAngle:Forward() ) then
                    ultimate.target = ply
                    return ply, bone, aimAngle, false, 0
                end
            end
           /*elseif ultimate.cfg.vars["Extrapolation"] and ultimate.predicted[ ply ] then
            if not ultimate.predicted[ ply ].pos then return end

            aimAngle = ( ultimate.predicted[ ply ].pos - me:EyePos() ):Angle()

            ultimate.traceStruct.start = me:EyePos()
            ultimate.traceStruct.endpos = ultimate.predicted[ ply ].pos
            ultimate.traceStruct.filter = ultimate.Piercable
            ultimate.traceStruct.mask = MASK_SHOT

            local tr = TraceLine( ultimate.traceStruct )

            if !tr.Hit or tr.Entity == ply then
                ultimate.target = ply
                return ply, ultimate.predicted[ ply ].pos, aimAngle, false, 0
            end*/
        end

        if ultimate.cfg.vars["Backtrack"] then
            local ticks = ultimate.FindBacktrack( cmd, ply )

            if ultimate.btrecords[ ply ] and not ply.break_lc then
                local ts = 0

                if ultimate.cfg.vars["Backtrack mode"] == 3 then
                    for p = 1, #ticks do
                        if not ultimate.btrecords[ ply ][ p ] then continue end

                        aimAngle = ( ultimate.btrecords[ ply ][ p ].aimpos - me:EyePos() ):Angle()

                        ultimate.traceStruct.start = me:EyePos()
                        ultimate.traceStruct.endpos = ultimate.btrecords[ ply ][ p ].aimpos
                        ultimate.traceStruct.filter = ultimate.Piercable
                        ultimate.traceStruct.mask = MASK_SHOT

                        local tr = TraceLine( ultimate.traceStruct )

                        if !tr.Hit or tr.Entity == ply then
                            ultimate.target = ply
                            ultimate.backtracktick = p

                            return ply, ultimate.btrecords[ ply ][ p ].aimpos, aimAngle, true, p
                        end
                    end
                end

                if ultimate.cfg.vars["Backtrack mode"] == 3 then return end

                if ultimate.cfg.vars["Backtrack mode"] == 1 then
                    ts = ultimate.FindFirstHittableTicks( ply, cmd )
                elseif ultimate.cfg.vars["Backtrack mode"] == 2 then
                    ts = ultimate.FindClosestHittableTicks( ply, cmd )
                end

                if not ultimate.btrecords[ ply ][ ts ] then return end

                aimAngle = ( ultimate.btrecords[ ply ][ ts ].aimpos - me:EyePos() ):Angle()

                ultimate.traceStruct.start = me:EyePos()
                ultimate.traceStruct.endpos = ultimate.btrecords[ ply ][ ts ].aimpos
                ultimate.traceStruct.filter = ultimate.Piercable
                ultimate.traceStruct.mask = MASK_SHOT

                local tr = TraceLine( ultimate.traceStruct )

                if !tr.Hit or tr.Entity == ply then
                    ultimate.target = ply
                    ultimate.backtracktick = ts

                    return ply, ultimate.btrecords[ ply ][ ts ].aimpos, aimAngle, true, ts
                end
            end
        end
	end
end

function ultimate.IsMovementKeysDown( cmd )

    if cmd:KeyDown( IN_MOVERIGHT ) then
        return true
    end

    if cmd:KeyDown( IN_MOVELEFT ) then
        return true
    end

    if cmd:KeyDown( IN_FORWARD ) then
        return true
    end

    if cmd:KeyDown( IN_BACK ) then
        return true
    end

    return false
end

function ultimate.MovementFix( cmd, wish_yaw )

	local pitch = math_NormalizeAngle( cmd:GetViewAngles().x )
	local inverted = -1

	if ( pitch > 89 || pitch < -89 ) then
		inverted = 1
	end

	local ang_diff = math_rad( math_NormalizeAngle( ( cmd:GetViewAngles().y - wish_yaw ) * inverted ) )

	local forwardmove = cmd:GetForwardMove()
	local sidemove = cmd:GetSideMove()

	local new_forwardmove = forwardmove * -math_cos( ang_diff ) * inverted + sidemove * math_sin( ang_diff )
	local new_sidemove = forwardmove * math_sin( ang_diff ) * inverted + sidemove * math_cos( ang_diff )

	cmd:SetForwardMove( new_forwardmove )
	cmd:SetSideMove( new_sidemove )
end


function ultimate.SilentAngles(cmd)
	if !ultimate.SilentAngle then ultimate.SilentAngle = cmd:GetViewAngles() end

	ultimate.SilentAngle = ultimate.SilentAngle + Angle( cmd:GetMouseY() * ultimate.myaw, cmd:GetMouseX() * -ultimate.myaw, 0)
	ultimate.SilentAngle.p = math_Clamp( ultimate.SilentAngle.p, -89, 89 )
    ultimate.SilentAngle.r = 0

    ultimate.SilentAngle:Normalize()
end

// Knife bot ( Etot zaichik knifer )

ultimate.knifes = {}

ultimate.knifes[1] = {
    str = "csgo_",

    canbackstab = true,

    leftdmg = 25,
    leftdmgb = 90,
    leftdist = 64*64,

    rightdmg = 65,
    rightdmgb = 180,
    rightdist = 48*48,
}

ultimate.knifes[2] = {
    str = "swb_",

    canbackstab = false,

    leftdmg = 10,
    leftdmgb = 10,
    leftdist = 50*50,

    rightdmg = 40,
    rightdmgb = 40,
    rightdist = 50*50,
}

ultimate.knifes[3] = {
    str = "weapon_crowba",

    canbackstab = false,

    leftdmg = 10,
    leftdmgb = 10,
    leftdist = 75*75,

    rightdmg = 10,
    rightdmgb = 10,
    rightdist = 75*75,
}

ultimate.knifes[4] = {
    str = "weapon_knif",

    canbackstab = true,

    leftdmg = 25,
    leftdmgb = 90,
    leftdist = 64*64,

    rightdmg = 65,
    rightdmgb = 180,
    rightdist = 48*48,
}

function ultimate:EntityFaceBack( ent )
    local angle = me:GetAngles().y - ent:GetAngles().y

    if angle < -180 then angle = 360 + angle end

    if angle <= 90 and angle >= -90 then return true end

    return false
end

function ultimate.CanStab( ent, pos, health )
    local mypos = me:GetShootPos()
    local tbl = ultimate.knifes[1]
    local wc = me:GetActiveWeapon():GetClass()
    local canuse = false

    for i = 1, #ultimate.knifes do
        if StartsWith(wc,ultimate.knifes[i].str) then
            canuse = true
            tbl = ultimate.knifes[i]
            break
        end
    end

    if not canuse then return false, false end

    if ultimate.canBacktrack( ent ) and ultimate.btrecords[ent][ultimate.backtracktick] then
        pos = ultimate.btrecords[ ent ][ ultimate.backtracktick ].aimpos
    end

    local backstab = tbl.canbackstab and ultimate:EntityFaceBack( ent ) or false
    local dist = mypos:DistToSqr( pos )
    local mode = ultimate.cfg.vars["Knifebot mode"]

    if mode == 1 then // Damage mode - tries to inflict biggest possible damage
        if backstab and dist < tbl.rightdist then
            return true, true
        elseif dist < tbl.leftdist and ( ( backstab and health - tbl.leftdmgb <= 0 ) or ( health - tbl.leftdmg <= 0 ) ) then
            return true, false
        elseif dist < tbl.rightdist or  ( dist < tbl.rightdist and health - tbl.leftdmg > 0 )  then
            return true, true
        end
    elseif mode == 2 then // Fast - tries to hit fast as possible
        if dist < tbl.rightdist then
            return true, true
        elseif dist < tbl.leftdist then
            return true, false
        end
    elseif mode == 3 then // Fatal - deals only fatal damage
        if dist < tbl.leftdist and ( ( backstab and health - tbl.leftdmgb <= 0 ) or ( health - tbl.leftdmg <= 0 ) ) then
            return true, false
        elseif dist < tbl.rightdist and ( ( backstab and health - tbl.rightdmgb <= 0 ) or ( health - tbl.rightdmg <= 0 ) ) then
            return true, true
        end
    end

    return false, false
end

function GetServerTime(cmd)
    if cmd == "get" then
        return os.date("%c", os.time()) -- Возвращаю текущую дату и время в удобочитаемом формате
    else
        return "Invalid command"
    end
end

function ultimate.simtimeCheck( v )
    if not ultimate.cfg.vars["Wait for simtime update"] then return true end

    return v.simtime_updated
end

function GetServerTime()
    return CurTime()
end

ultimate.grabbingEnt = false

function ultimate.DrawPhysgunBeamFunc( ply, wep, e, tar, bone, hitpos )
    if ply != me then return end

    ultimate.grabbingEnt = IsValid( tar ) and tar or false
end

function ultimate.LagCompensation(cmd)
    local ply = ultimate.SelectTarget(cmd)
    local ping = ply:Ping()

    local compensationAmount = ping * 0.001


    local serverTime = GetServerTime()
    local compensatedTime = serverTime - compensationAmount
end

function ultimate.GetLerpTime()

    local lerpRatio = GetConVar("cl_interp_ratio"):GetFloat()
    if lerpRatio == 0 then
        lerpRatio = 1
    end

    local lerpAmount = GetConVar("cl_interp"):GetFloat()
    if lerpRatio == 0 then
        lerpAmount = 1
    end

    local updateRate = GetConVar("cl_updaterate"):GetFloat()

    -- Calculate the base lerp time
    local baseLerpTime = math_max(lerpAmount, lerpRatio / updateRate)

    -- Get the local player
    local player = LocalPlayer()

    -- Check if the player is valid
    if not IsValid(player) then return baseLerpTime end

    -- Get the player's ping and packet loss
    local ping = player:Ping()
    local packetLoss = player:PacketLoss()

    -- Adjust the lerp time based on the player's actual lag
    -- This is a simplified example; you might need to adjust the formula based on your specific requirements
    local adjustedLerpTime = baseLerpTime + (ping / 1000) + (packetLoss * 0.1)

    return adjustedLerpTime
end

ultimate.NotPredictileWep = { ["rust_dbarrel"] = true, ["rust_spas12"] = true,["rust_waterpipe"] = true,["rust_pumpshotgun"] = true,["rust_pickaxe"] = true,["rust_hatchet"] = true,["rust_boneclub"] = true,["rust_combatknife"] = true,["rust_woodenspear"] = true,["rust_stonespear"] = true,["rust_stonepickaxe"] = true,["rust_stonehatchet"] = true,["rust_salvagedsword"] = true,["rust_salvagedcleaver"] = true,["rust_rock"] = true}

function ultimate.Aim(cmd)
    ultimate.AntiAim(cmd)

    if ultimate.SendPacket then
        ultimate.fakeAngles.angle = cmd:GetViewAngles()
        ultimate.fakeAngles.movex = me:GetPoseParameter("move_x")
        ultimate.fakeAngles.movey = me:GetPoseParameter("move_y")

        local layers = {}

        for i = 0, 13 do
            if me:IsValidLayer(i) then
                layers[i] = {
                    cycle = me:GetLayerCycle(i),
                    sequence = me:GetLayerSequence(i),
                    weight = me:GetLayerWeight(i)
                }
            end
        end

        ultimate.fakeAngles.origin = me:GetNetworkOrigin()
        ultimate.fakeAngles.seq = me:GetSequence()
        ultimate.fakeAngles.cycle = me:GetCycle()
    else
        ultimate.realAngle = cmd:GetViewAngles()
    end

    local ply, bone, aimAngle, backtracking, bttick = ultimate.SelectTarget(cmd)

    local w = me:GetActiveWeapon()

    ultimate.targetVector = bone

    if not aimAngle then return end

    aimAngle:Normalize()

    if not ultimate.cfg.vars["Enable aimbot"] or not ply then return end

    local targetTime = ded.GetSimulationTime( ply:EntIndex() )
    local timeOffset = ded.GetServerTime(cmd) - targetTime

    local serverArriveTick = ded.GetServerTime(cmd) + ded.GetLatency(0) + ded.GetLatency(1)
    local diff = serverArriveTick - targetTime

    if ultimate.cfg.vars["LerpTime"] then
        if serverArriveTick - targetTime < 0.2 then
            ded.NetSetConVar("cl_interpolate","0")
            ded.NetSetConVar("cl_interp","0")
            ded.SetCommandTick(cmd, ultimate.TIME_TO_TICKS(targetTime + ultimate.GetLerpTime()))
        else
            ded.NetSetConVar("cl_interpolate","0")
            ded.NetSetConVar("cl_interp","0")
            ded.SetCommandTick(cmd, ultimate.TIME_TO_TICKS(targetTime + ultimate.GetLerpTime()))
        end
    end

    if diff > 1 and ultimate.cfg.vars["Adjust tickcount"] then return end

    local oldangs = Angle(aimAngle)

    if ultimate.cfg.vars["Always backtrack"] and not backtracking then return end

    if ultimate.cfg.vars["Fov limit"] then
        local fov = ultimate.cfg.vars["Aimbot FOV"]

		local view = ultimate.cfg.vars["Silent aim"] and ultimate.SilentAngle or cmd:GetViewAngles()
		local ang = aimAngle - view

		ang:Normalize()

		ang = math_sqrt(ang.x * ang.x + ang.y * ang.y)

        if fov < ang then
            ultimate.targetVector = false
		    return
        end
    end

    if not ultimate.CanShoot(cmd) or not ultimate.simtimeCheck( ply ) then return end
    if not ultimate.cfg.vars["Aimbot smoothing"] and ultimate.SkipCommand then return end

    ultimate.aimingrn = true

    // Knife bot
    local altfire = false
    local canstab, rightstab = ultimate.CanStab( ply, bone, ply:Health() )

    local oldAimAng = aimAngle
    local finalAngle = aimAngle

    if ultimate.cfg.vars["Knifebot"] and canstab then
        altfire = rightstab
    elseif ultimate.cfg.vars["Knifebot"] and not canstab then
        return
    end

    if ultimate.cfg.vars["gRust Shahid predict pizdech"] then
        local PredPos = bone
        local Distance      = me:GetShootPos():Distance( PredPos )
        if ultimate.NotPredictileWep[ w:GetClass() ] or Distance < 80 then
            PredPos =  bone
        else
            local Velocity = 5000
            local Distance      = me:GetShootPos():Distance( PredPos )
            if string.StartsWith(w:GetClass(), "rust_huntingbow") then
                Velocity = 4000 - (0.60 * Distance) -- $_$
            elseif string.StartsWith(w:GetClass(), "rust_assaultrifle")  or string.StartsWith(w:GetClass(), "rust_boltrifle") then
                Velocity = 10000
            elseif string.StartsWith(w:GetClass(), "rust_revolver") then
                Velocity = 4000
            elseif string.StartsWith(w:GetClass(), "rust_nailgun") then
                Velocity = 2500
            end

            if Distance < 80 then return end

            local TravelTime    = Distance / Velocity
            local PredTime      = ( ded.GetLatency( 0 ) + ded.GetLatency( 1 ) ) + TravelTime

            ded.StartSimulation( ply:EntIndex() )
                for i = 1, ultimate.TIME_TO_TICKS( PredTime ) do
                    ded.SimulateTick()
                end
                local ModuleData = ded.GetSimulationData()
                PredPos = ModuleData.m_vecAbsOrigin + (bone  - ply:GetPos())
            ded.FinishSimulation()

            Distance            = me:GetShootPos():Distance( PredPos )
            TravelTime          = Distance / Velocity

            local Gravity =  (9.81 * 51.4285714 ) * (TravelTime^2) / 2
            PredPos.z = PredPos.z + Gravity

            ultimate.traceStruct.start = me:GetShootPos()
            ultimate.traceStruct.endpos = PredPos
            ultimate.traceStruct.filter = me
            ultimate.traceStruct.mask = MASK_SHOT

            local Trace = TraceLine( ultimate.traceStruct )

            if Trace.Hit and not Trace.Entity:IsPlayer() then return end
        end

        debugoverlay.Cross( PredPos, 3, 0.1, color_white, true )

        finalAngle = ( Vector( PredPos )  - me:GetShootPos() ):Angle()
        if ultimate.cfg.vars["Norecoil"] then
            finalAngle = ultimate.NoRecoil(finalAngle)
        end
        if ultimate.cfg.vars["Nospread"] then
            finalAngle = ultimate.NoSpread(cmd,finalAngle)
        end
        if ultimate.cfg.vars["Auto fire"] then
           cmd:AddKey(IN_ATTACK)
        end
    end
    if ultimate.cfg.vars["Norecoil"] then
        finalAngle = ultimate.NoRecoil(finalAngle)
    end

    /*if ultimate.cfg.vars["gRust NR"] then
        finalAngle = ultimate.gRustNoRecoil(finalAngle)
    end*/

    if ultimate.cfg.vars[""] then
        ded.ForceSeed( cmd )
    end

    if ultimate.cfg.vars["Nospread"] then
        finalAngle = ultimate.NoSpread(cmd,finalAngle)
    end

    if ultimate.cfg.vars["On shot aa"] then
        finalAngle.p = -finalAngle.p - 180
        finalAngle.y = finalAngle.y + 180
    end

    if ultimate.cfg.vars["Facestab"] then
        local angles = ply:EyeAngles()

        finalAngle.y = angles.y
        finalAngle.p = angles.p

        altfire = true
    end

    if ultimate.cfg.vars["Aimbot smoothing"] then
        local va = cmd:GetViewAngles()
        va.r = 0

        local rat = ultimate.cfg.vars["Smoothing"] * 100
        local ret = LerpAngle( FrameTime()*rat, va, finalAngle )

        finalAngle = ret
    end


    if ultimate.cfg.vars["Projectile aimbot"] then
        local predTime = math.ceil( ( me:EyePos() ):DistToSqr( ply:GetPos() ) / 3600 )

        print( predTime )

        if predTime > 15 then return end

        ded.StartSimulation( ply:EntIndex() )

        for tick = 1, predTime do
            ded.SimulateTick()
        end

        local data = ded.GetSimulationData()
        local vec = data.m_vecAbsOrigin

        ded.FinishSimulation()

        local g = predTime * 1

        print( vec.z, g )

        vec.z = vec.z + g

        finalAngle = ( vec - me:EyePos() ):Angle()
        finalAngle:Normalize()
    end

    //ded.SetContextMenu( cmd, ultimate.cfg.vars["pSilent"] or ultimate.cfg.vars["Facestab"] )
    if ultimate.cfg.vars["Facestab"] then
        cmd:SetViewAngles( finalAngle )
        ded.SetContextVector( cmd, oldaimAngle, true )
    elseif ultimate.cfg.vars["pSilent"] then
        ded.SetContextVector( cmd, oldaimAngle, true )
    else
        cmd:SetViewAngles( finalAngle )
    end

    if backtracking then
        targetTime = ultimate.btrecords[ply][bttick].simulationtime
        timeOffset = ded.GetServerTime(cmd) - targetTime

        serverArriveTick = ded.GetServerTime(cmd) + ded.GetLatency(0) + ded.GetLatency(1)
        diff = serverArriveTick - ultimate.btrecords[ply][bttick].simulationtime

        if diff < 0.2 then
            ded.NetSetConVar("cl_interpolate","0")
            ded.NetSetConVar("cl_interp","0")
            local tick = ultimate.TIME_TO_TICKS(targetTime)
            ded.SetCommandTick(cmd, tick)
        else
            ded.NetSetConVar("cl_interpolate","1")
            ded.NetSetConVar("cl_interp",tostring(ded.GetServerTime(cmd) - targetTime))
            local tick = ultimate.TIME_TO_TICKS(ded.GetServerTime(cmd))
            ded.SetCommandTick(cmd, tick - 1)
        end
    elseif ultimate.cfg.vars["Adjust tickcount"] then
        if diff < 0.2 then
            ded.NetSetConVar("cl_interpolate","0")
            ded.NetSetConVar("cl_interp","0")

            ded.SetCommandTick(cmd, ultimate.TIME_TO_TICKS( ded.GetSimulationTime( ply:EntIndex() ) ) )
        else
            ded.NetSetConVar("cl_interpolate","1")
           ded.NetSetConVar("cl_interp",tostring(ded.GetServerTime(cmd) - targetTime))

            local tick = ultimate.TIME_TO_TICKS(ded.GetServerTime(cmd))
            ded.SetCommandTick(cmd, tick - 1)
        end
    end

    if ultimate.cfg.vars["Auto fire"] then

        if StartsWith( ultimate.activeWeaponClass, "m9k_" ) then
            cmd:RemoveKey( IN_SPEED )
        end

        ultimate.SendPacket = true
        me.simtime_updated = true
        //ded.UpdateClientAnimation( me:EntIndex() )

        cmd:AddKey( altfire and IN_ATTACK2 or IN_ATTACK )

        ultimate.SkipCommand = true
    end
end

function ultimate.autoReload(cmd)
    if !ultimate.cfg.vars["Auto reload"] then return end

    local wep = me:GetActiveWeapon()
    if !IsValid(wep) then return end

    if !wep.Primary or wep:GetMaxClip1() <= 0 then return end
    ultimate.autoReloadState = ultimate.autoReloadState or { reloading = false }
    local currentClip = wep:Clip1()
    if currentClip == 0 then
        if !ultimate.autoReloadState.reloading then
            cmd:AddKey(IN_RELOAD)
            ultimate.autoReloadState.reloading = true
        end
    else
        ultimate.autoReloadState.reloading = false
    end
end

// adaptive Cstrafe

ultimate.last_ground_pos = 0
ultimate.cstrafe_dir = 0

function ultimate.PredictVelocity( velocity, viewangles, dir, maxspeed, accel )

	local forward = viewangles:Forward()
	local right = viewangles:Right()

	local fmove = 0
	local smove = ( dir == 1 ) && -10000 || 10000

	forward.z = 0
	right.z = 0

	forward:Normalize()
	right:Normalize()

	local wishdir = Vector( forward.x*fmove + right.x*smove, forward.y*fmove + right.y*smove, 0 )
	local wishspeed = wishdir:Length()

	wishdir:Normalize()

	if ( wishspeed != 0 && wishspeed > maxspeed ) then
		wishspeed = maxspeed
	end

	local wishspd = wishspeed

	if ( wishspd > 30 ) then
		wishspd = 30
	end

	local currentspeed = velocity:Dot( wishdir )
	local addspeed = wishspd - currentspeed

	if ( addspeed <= 0 ) then
		return velocity
	end

	local accelspeed = accel * wishspeed * TickInterval

	if ( accelspeed > addspeed ) then
		accelspeed = addspeed
	end

	return velocity + ( wishdir * accelspeed )

end

function ultimate.PredictMovement( viewangles, dir, angle )

	local pm

	local sv_airaccelerate = GetConVarNumber( "sv_airaccelerate" )
	local sv_gravity = GetConVarNumber( "sv_gravity" )
	local maxspeed = me:GetMaxSpeed()
	local jump_power = me:GetJumpPower()

	local origin = me:GetNetworkOrigin()
	local velocity = me:GetAbsVelocity()

	local mins = me:OBBMins()
	local maxs = me:OBBMaxs()

    local pticks = math_Round(ultimate.cfg.vars["CStrafe ticks"])

	local on_ground = me:IsFlagSet( FL_ONGROUND )

	for i = 1, pticks do

		viewangles.y = math_NormalizeAngle( math_deg( math_atan2( velocity.y, velocity.x ) ) + angle )

		velocity.z = velocity.z - ( sv_gravity * TickInterval * 0.5 )

		if ( on_ground ) then

			velocity.z = jump_power
			velocity.z = velocity.z - ( sv_gravity * TickInterval * 0.5 )

		end

		velocity = ultimate.PredictVelocity( velocity, viewangles, dir, maxspeed, sv_airaccelerate )

		local endpos = origin + ( velocity * TickInterval )

		pm = TraceHull( {
			start = origin,
			endpos = endpos,
			filter = me,
			maxs = maxs,
			mins = mins,
			mask = MASK_PLAYERSOLID
		} )

		if ( ( pm.Fraction != 1 && pm.HitNormal.z <= 0.9 ) || pm.AllSolid || pm.StartSolid ) then
			return false
		end

		if ( pm.Fraction != 1 ) then

			local time_left = TickInterval

			for j = 1, 2 do

				time_left = time_left - ( time_left * pm.Fraction )

				local dot = velocity:Dot( pm.HitNormal )

				velocity = velocity - ( pm.HitNormal * dot )

				dot = velocity:Dot( pm.HitNormal )

				if ( dot < 0 ) then
					velocity = velocity - ( pm.HitNormal * dot )
				end

				endpos = pm.HitPos + ( velocity * time_left )

				pm = TraceHull( {
					start = pm.HitPos,
					endpos = endpos,
					filter = me,
					maxs = maxs,
					mins = mins,
					mask = MASK_PLAYERSOLID
				} )

				if ( pm.Fraction == 1 || pm.AllSolid || pm.StartSolid ) then
					break
				end

			end

		end

		origin = pm.HitPos

		if ( ( ultimate.last_ground_pos - origin.z ) > math_Round(ultimate.cfg.vars["CStrafe ground diff"]) ) then
			return false
		end

		pm = TraceHull( {
			start =  Vector( origin.x, origin.y, origin.z + 2 ),
			endpos = Vector( origin.x, origin.y, origin.z - 1 ),
			filter = me,
			maxs = Vector( maxs.x, maxs.y, maxs.z * 0.5 ),
			mins = mins,
			mask = MASK_PLAYERSOLID
		} )

		on_ground = ( ( pm.Fraction < 1 || pm.AllSolid || pm.StartSolid ) && pm.HitNormal.z >= 0.7 )

		velocity.z = velocity.z - ( sv_gravity * TickInterval * 0.5 )

		if ( on_ground ) then
			velocity.z = 0
		end


	end

	return true

end

function ultimate.CircleStrafe( cmd )

	local angle = 0

	while ( ultimate.cstrafe_dir < 2 ) do

		angle = 0
		local path_found = false
		local step = ( ultimate.cstrafe_dir == 1 ) && math_Round(ultimate.cfg.vars["CStrafe angle step"]) || -math_Round(ultimate.cfg.vars["CStrafe angle step"])

		while ( true ) do

			if ( ultimate.cstrafe_dir == 1 ) then

				if ( angle > math_Round(ultimate.cfg.vars["CStrafe angle max step"]) ) then
					break
				end

			else

				if ( angle < -math_Round(ultimate.cfg.vars["CStrafe angle max step"]) ) then
					break
				end

			end

			if ( ultimate.PredictMovement( cmd:GetViewAngles(), ultimate.cstrafe_dir, angle ) ) then

				path_found = true
				break

			end

			angle = angle + step

		end

		if ( path_found ) then
			break
		end

		ultimate.cstrafe_dir = ultimate.cstrafe_dir + 1

	end

	if ( ultimate.cstrafe_dir < 2 ) then

		local velocity = me:GetAbsVelocity()
		local viewangles = cmd:GetViewAngles()

		viewangles.y = math_NormalizeAngle( math_deg( math_atan2( velocity.y, velocity.x ) ) + angle )

		cmd:SetViewAngles( viewangles )
		cmd:SetSideMove( ( ultimate.cstrafe_dir == 1 ) && -10000 || 10000 )

	else

		ultimate.cstrafe_dir = 0

	end

end

do
    local ztick = 0
    local prev_yaw = 0
    local old_yaw = 0.0

    function ultimate.AutoStrafe( cmd )
        ztick = ztick + 1

        if ( ultimate.IsKeyDown(ultimate.cfg.binds["Circle strafe"]) and ultimate.cfg.vars["Circle strafe"] ) then

            ultimate.CircleStrafe( cmd )

        elseif ( ultimate.IsKeyDown(ultimate.cfg.binds["Z Hop"]) and ultimate.cfg.vars["Z Hop"] ) then
            local handler = ztick / 3.14

            cmd:SetSideMove( 5000 * math_sin(handler) )
        elseif ultimate.cfg.vars["Air strafer"] and ultimate.cfg.vars["Strafe mode"] == 3 then

            local get_velocity_degree = function(velocity)
                local tmp = math_deg(math_atan(30.0 / velocity))

                if (tmp > 90.0) then
                    return 90.0
                elseif (tmp < 0.0) then
                    return 0.0
                else
                    return tmp
                end
            end

            local M_RADPI = 57.295779513082
            local side_speed = 10000
            local velocity = me:GetVelocity()
            velocity.z = 0.0

            local forwardmove = cmd:GetForwardMove()
            local sidemove = cmd:GetSideMove()

            if (!forwardmove || !sidemove) then
                return
            end

            if(velocity:Length2D() <= 15.0 && !(forwardmove != 0 || sidemove != 0)) then
                return
            end

            local flip = cmd:TickCount() % 2 == 0

            local turn_direction_modifier = flip && 1.0 || -1.0
            local viewangles = Angle(ultimate.SilentAngle.x, ultimate.SilentAngle.y, ultimate.SilentAngle.z)

            if (forwardmove || sidemove) then
                cmd:SetForwardMove(0)
                cmd:SetSideMove(0)

                local turn_angle = math_atan2(-sidemove, forwardmove)
                viewangles.y = viewangles.y + (turn_angle * M_RADPI)
            elseif (forwardmove) then
                cmd:SetForwardMove(0)
            end

            local strafe_angle = math_deg(math_atan(15 / velocity:Length2D()))

            if (strafe_angle > 90) then
                strafe_angle = 90
            elseif (strafe_angle < 0) then
                strafe_angle = 0
            end

            local temp = Vector(0, viewangles.y - old_yaw, 0)
            temp.y = math_NormalizeAngle(temp.y)

            local yaw_delta = temp.y
            old_yaw = viewangles.y

            local abs_yaw_delta = math_abs(yaw_delta)

            if (abs_yaw_delta <= strafe_angle || abs_yaw_delta >= 30) then
                local velocity_angles = velocity:Angle()

                temp = Vector(0, viewangles.y - velocity_angles.y, 0)
                temp.y = math_NormalizeAngle(temp.y)

                local velocityangle_yawdelta = temp.y
                local velocity_degree = get_velocity_degree(velocity:Length2D() * 128)

                if (velocityangle_yawdelta <= velocity_degree || velocity:Length2D() <= 15) then
                    if (-velocity_degree <= velocityangle_yawdelta || velocity:Length2D() <= 15) then
                        viewangles.y = viewangles.y + (strafe_angle * turn_direction_modifier)
                        cmd:SetSideMove(side_speed * turn_direction_modifier)
                    else
                        viewangles.y = velocity_angles.y - velocity_degree
                        cmd:SetSideMove(side_speed)
                    end
                else
                    viewangles.y = velocity_angles.y + velocity_degree
                    cmd:SetSideMove(-side_speed)
                end
            elseif (yaw_delta > 0) then
                cmd:SetSideMove(-side_speed)
            elseif (yaw_delta < 0) then
                cmd:SetSideMove(side_speed)
            end

            local move = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), 0)
            local speed = move:Length()

            local angles_move = move:Angle()

            local normalized_x = math.modf(ultimate.SilentAngle.x + 180, 360) - 180
            local normalized_y = math.modf(ultimate.SilentAngle.y + 180, 360) - 180

            local yaw = math_rad(normalized_y - viewangles.y + angles_move.y)

            if (normalized_x >= 90 || normalized_x <= -90 || ultimate.SilentAngle.x >= 90 && ultimate.SilentAngle.x <= 200 || ultimate.SilentAngle.x <= -90 && ultimate.SilentAngle.x <= 200) then
                cmd:SetForwardMove(-math_cos(yaw) * speed)
            else
                cmd:SetForwardMove(math_cos(yaw) * speed)
            end

            cmd:SetSideMove(math_sin(yaw) * speed)

        elseif ultimate.cfg.vars["Air strafer"] and ultimate.cfg.vars["Strafe mode"] == 2 then
            cmd:SetForwardMove(0)

            if me:IsFlagSet( FL_ONGROUND ) then
                cmd:SetForwardMove(10000)
            else
                cmd:SetForwardMove(5850 / me:GetVelocity():Length2D())
                cmd:SetSideMove((cmd:CommandNumber() % 2 == 0) && -400 || 400)
            end

            /*

local ang_diff = math_NormalizeAngle( ultimate.SilentAngle.y - prev_yaw )

            if ( math_abs( ang_diff ) > 0 ) then

                if ( ang_diff > 0 ) then
                    cmd:SetSideMove( -10000 )
                else
                    cmd:SetSideMove( 10000 )
                end

            else

                local vel = me:GetAbsVelocity()
                local vel_yaw = math_NormalizeAngle( math_deg( math_atan2( vel.y, vel.x ) ) )
                local vel_yaw_diff = math_NormalizeAngle( ultimate.SilentAngle.y - vel_yaw )

                if ( vel_yaw_diff > 0 ) then
                    cmd:SetSideMove( -10000 )
                else
                    cmd:SetSideMove( 10000 )
                end

                local viewangles = cmd:GetViewAngles() //ultimate.SilentAngle //Angle( ultimate.SilentAngle.x, ultimate.SilentAngle.y, 0 )
                viewangles.y = vel_yaw
                cmd:SetViewAngles( viewangles )

            end

            prev_yaw = ultimate.SilentAngle.y
            */




        end
    end
end

/*
    Anti aim

*/

ultimate.aatarget = nil

function ultimate.PredictedPos(ply)
    return ply:GetPos() + ply:GetVelocity() * TickInterval
end

function ultimate.PredictedEyePos()
    return me:EyePos() + me:GetVelocity() * TickInterval
end

function ultimate.GetBaseYaw()
    if not IsValid( ultimate.aatarget ) or ultimate.cfg.vars["Yaw base"] != 2 then
        return ultimate.SilentAngle.y
    end

    return math_NormalizeAngle( (ultimate.PredictedPos(ultimate.aatarget) - ultimate.PredictedEyePos()):Angle().y )
end

function ultimate.Freestand(cmd)
	if !IsValid(ultimate.aatarget) then return false end

	local headpos = me:GetBonePosition(me:LookupBone("ValveBiped.Bip01_Head1"))
	if !headpos then return end

	local selfpos = me:GetPos()
	local headoffset = Vector(selfpos.x, selfpos.y, headpos.z):Distance(headpos) + 5

	local found = true

	local pos = ultimate.aatarget:WorldToLocal(selfpos)
	local bearing = math_deg(-math_atan2(pos.y, pos.x)) + 180 + 90
	local left, right = bearing - 180 - 90, bearing - 180 + 90

	local function CheckYaw(yaw)
		yaw = math_rad(yaw)
		local x, y = math_sin(yaw), math_cos(yaw)

		local headoffsetvec = Vector(x, y, 0) * headoffset
		headoffsetvec.z = headpos.z - selfpos.z

		local tr = TraceLine({
			start = ultimate.aatarget:EyePos() + ultimate.aatarget:GetVelocity() * TickInterval * 4,
			endpos = selfpos + headoffsetvec,
			filter = ultimate.aatarget
		})

		return tr.Fraction < 1 and tr.Entity != me
	end

	local function Normalize(ang) return 360 - ang + 90 end

	local leftcheck, rightcheck = CheckYaw(left), CheckYaw(right)

	left, right = Normalize(left), Normalize(right)

	do
		local headlocal = me:WorldToLocal(headpos)
		if headlocal.x > 0 then
			left, right = right, left
		end
	end

	if leftcheck and rightcheck then
		return false
	elseif leftcheck then
		return true, left , right
	elseif rightcheck then
		return true, right, left
	end

	return false
end

ultimate.realAngle = me:EyeAngles()
ultimate.inverted = false
ultimate.oldYaw = 0
ultimate.SwaySide = 1

local baseyaw = 0

ultimate.CalcYaw = {
    // Backward
    [1] = function( cmd )
        return baseyaw - 178
    end,
    // Fake forward
    [2] = function( cmd )
        return ultimate.SendPacket and baseyaw or baseyaw + 178
    end,
    // Legit Delta
    [3] = function( cmd )
        return ultimate.SendPacket and baseyaw or baseyaw + ( ultimate.inverted and 43 or - 43 )
    end,
    // Sideways
    [4] = function( cmd )
        local delta = ultimate.inverted and 89 or -89
        return baseyaw - ( ultimate.SendPacket and delta or -delta )
    end,
    // Half Sideways
    [5] = function( cmd )
        local delta = ultimate.inverted and 89 or -89
        return baseyaw - ( ultimate.SendPacket and delta or 178 )
    end,
    // Fake Spin
    [6] = function( cmd )
        local add = math_NormalizeAngle( CurTime() * ultimate.cfg.vars["Spin speed"] * 10 )
        return ultimate.SendPacket and ( ultimate.inverted and ( baseyaw - 178 ) or add ) or ( ultimate.inverted and add or ( baseyaw - 178 ) )
    end,
    // LBY Spin
    [7] = function( cmd )
        return ded.GetCurrentLowerBodyYaw( me:EntIndex() ) + ( ultimate.SendPacket and 180 or 0)
    end,
    // LBY Breaker
    [8] = function( cmd )
        local yaw = baseyaw - 178

        if me:GetVelocity():Length2D() > 1 then
            yaw = ded.GetCurrentLowerBodyYaw( me:EntIndex() ) + ( ultimate.SendPacket and 180 or 0)
        elseif not ultimate.SendPacket then
            local side = ultimate.inverted and -1 or 1
            local lbyTarget = ded.GetTargetLowerBodyYaw( me:EntIndex() )

            if math_abs( math_NormalizeAngle( lbyTarget - ultimate.oldYaw ) ) < ultimate.cfg.vars["LBY min delta"] then
                yaw = math_NormalizeAngle( ultimate.oldYaw + ultimate.cfg.vars["LBY break delta"] * side)
            else
                yaw = math_NormalizeAngle( ded.GetCurrentLowerBodyYaw( me:EntIndex() ) - 44 * side )
            end
        end

        return yaw
    end,
    // Sin Sway
    [9] = function( cmd )
        local add = ultimate.cfg.vars["Sin add"]
        local sin = math_sin( CurTime() ) * ultimate.cfg.vars["Sin delta"]
        return ultimate.SendPacket and baseyaw + sin + add or baseyaw - sin - add
    end,
    // Pendulum Sway
    [10] = function( cmd )
        local ct = CurTime()
        local delta = ultimate.cfg.vars["Sin delta"]
        local ct1 = ( ct % 0.9 )
        local ct2 = ( ct % 2 )

        local x1 = ct2 * math_sin(ct1)
        local y1 = ct2 * -1 * math_cos(ct1)

        local x2 = x1 + ct1 * math_sin(ct2)
        local y2 = y1 - ct1 * math_cos(ct2)

        local sin = ultimate.SendPacket and x2 * delta or y2 * delta
        return baseyaw + sin
    end,
    // Lag Sway
    [11] = function( cmd )
        local swaySpeed = (ultimate.fakeLagTicks + 1) / 12 * math.pi
        local swayAmount = math_sin(CurTime() * swaySpeed) * 45

        return ( baseyaw - 180 ) + 55 * ultimate.SwaySide + swayAmount * ultimate.SwaySide * -1
    end,
    // Fake Jitter
    [12] = function( cmd )
        local delta = ultimate.cfg.vars["Jitter delta"]

        local a = ultimate.SendPacket and baseyaw - 178 or baseyaw - 178 + math_random( -delta, delta )
        local b = ultimate.SendPacket and baseyaw - 178 + math_random( -delta, delta ) or baseyaw - 178

        return ultimate.inverted and a or b
    end,
    // Kappa Jitter
    [13] = function( cmd )
        local delta = ultimate.cfg.vars["Jitter delta"]

        local a = ultimate.SendPacket and baseyaw - 178 or baseyaw + ( delta * ultimate.SwaySide )
        local b = ultimate.SendPacket and baseyaw + ( delta * ultimate.SwaySide ) or baseyaw - 178

        return ultimate.inverted and a or b
    end,
    // Abu Jitter
    [14] = function( cmd )
        local ctjit = math_sin( CurTime() * 30 ) * 25

        return ctjit + ( ultimate.SendPacket and baseyaw - 160 * ultimate.SwaySide or baseyaw - 160 * -ultimate.SwaySide )
    end,
    // Satanic spinner
    [15] = function( cmd )
        local side = ultimate.inverted and 1 or -1
        local satanicvalue = math_sin( CurTime() * 666 ) * 666

        return math_NormalizeAngle( ultimate.SendPacket and satanicvalue * side or satanicvalue * -side )
    end,
    // Custom aa
    [16] = function( cmd )
        return ultimate.SendPacket and baseyaw + ultimate.cfg.vars["Custom real"] or baseyaw + ultimate.cfg.vars["Custom fake"]
    end,
    // Custom Abu
    [17] = function( cmd )
        local ctjit = math_sin( CurTime() * 30 ) * 25

        return ctjit + ( ultimate.SendPacket and baseyaw - ultimate.cfg.vars["Custom real"] * ultimate.SwaySide or baseyaw - ultimate.cfg.vars["Custom fake"] * -ultimate.SwaySide )







    end,
    // Legit AA
    [18] = function( cmd )
        local delta = ultimate.inverted and 89 or -89
        return baseyaw - ( ultimate.SendPacket and delta or -delta )
    end,
}







do
    local pitch, yaw = 0, 0

    local pitches = {
        [1] = 89,
        [2] = -89,
        [3] = 0,
        [4] = -180,
        [5] = 180,
    }














    local mm_side = false
    local side = false
    local pitchflip = false

    local side = 1

    local function CalcPitch()
        local cfg = ultimate.cfg.vars["Pitch"]
        local x = 0

        if cfg <= 5 then return pitches[cfg] end

        if ultimate.SendPacket then
            pitchflip = not pitchflip
        end

        if cfg == 6 then
            x = pitchflip and 180 or -180
        elseif cfg == 7 then
            x = pitchflip and -180 or 271
        elseif cfg == 7 then
            x = ultimate.SendPacket and 89 or -180
        elseif cfg == 8 then
            x = math_random(-180,95) and math_random(177,180)
        elseif cfg == 9 then
            x = math_random(-180,-55) and math_random(180,55)
        elseif cfg == 10 then
            x = math_random(180,95) and math_random(-180,-95)
        elseif cfg == 11 then
            x = math_random(-180,-95) and math_random(166,179+2)
        elseif cfg == 12 then
            x = math_random(-180,-115) and math_random(177,179+2)
        elseif cfg == 13 then
            x = ultimate.cfg.vars["Custom pitch"]
        end

        return x
    end

    /*




        elseif cfg == 7 then

        elseif cfg == 8 then

        elseif cfg == 9 then
            local sin = math_sin( CurTime() ) * 89
            y = ultimate.SendPacket and baseyaw + sin or baseyaw - sin
        elseif cfg == 10 then
            local side = ded.GetPreviousTick() % 2 == 1

            y = ultimate.SendPacket and baseyaw - 180 or baseyaw + ( side and -89 or 89 )
        elseif cfg == 11 then

        elseif cfg == 12 then
            y = baseyaw + ( ultimate.SendPacket && ultimate.cfg.vars["Custom fake"] || ultimate.cfg.vars["Custom real"] )
        end

        "Backward",
        "Fake forward",
        "Sideways",
        "Half sideways",
        "Fake spin",
        "LBY",
        "Kappa",
        "Sway",
        "VDiff",
        "القضيب الطويل",
        "Lisp",
        "Custom",

    if ultimate.cfg.vars["Jitter"] == 2 and ultimate.SendPacket then
            local r = math_random(-45,45)
            local lbydiff = ded.GetTargetLBY(me:EntIndex()) - ded.GetCurrentLBY(me:EntIndex())

            if y + r > ded.GetTargetLBY(me:EntIndex()) then
                y = y + math_random(-lbydiff,lbydiff)
            else
                y = y + r
            end

        elseif ultimate.cfg.vars["Jitter"] == 3 and ultimate.SendPacket then
            y = y + math_random(ded.GetCurrentLBY(me:EntIndex()),ded.GetTargetLBY(me:EntIndex()))
        end

        */

    local function micromovement(cmd)
        if !ultimate.cfg.vars["Micromovement"] then return end
        if !me:Alive() then return end
        if !me:IsFlagSet( FL_ONGROUND ) then return end
        if cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) then return end

        if cmd:GetForwardMove() == 0 and cmd:GetSideMove() == 0 then
            cmd:SetSideMove(mm_side and -15.0 or 15.0)
            mm_side = not mm_side
        end
    end

    local function aacheck(cmd)
        if !ultimate.cfg.vars["Anti aim"] then return false end
        if cmd:KeyDown(IN_ATTACK) then return false end
        if cmd:KeyDown(IN_USE) then return false end
        if ultimate.moveType == MOVETYPE_LADDER then return false end
        if ultimate.moveType == MOVETYPE_NOCLIP then return false end

        if ultimate.cfg.binds["Anti aim"] != 0 and not ultimate.IsKeyDown(ultimate.cfg.binds["Anti aim"]) then
            return false
        end

        return true
    end

    function ultimate.AntiAim(cmd)
        local freestandsucc, freestandsafe, freestandunsafe

        if ultimate.cfg.vars["Freestanding"] then
            freestandsucc, freestandsafe, freestandunsafe = ultimate.Freestand(cmd)
        end

        if ultimate.SendPacket then
            ultimate.SwaySide = ultimate.SwaySide * -1
        end

        baseyaw = ultimate.GetBaseYaw()
        pitch = CalcPitch()
        yaw = ultimate.CalcYaw[ultimate.cfg.vars["Yaw"] ](cmd)

        if ultimate.cfg.vars["Yaw randomisation"] then
            yaw = yaw + math_random( -0.9, 0.9 )
        end

        if freestandsucc then
            yaw = ultimate.SendPacket and freestandunsafe or freestandsafe
        end

        if aacheck(cmd) then
            local pyAngle = Angle(pitch,yaw,0)

            cmd:SetViewAngles(pyAngle)
            ultimate.oldYaw = pyAngle.y
        end
        micromovement(cmd)
    end
end

/*
    Fake lag
*/
ultimate.fakeLagTicks = 0
ultimate.fakeLagfactor = 0
ultimate.chokedTicks = 0

ultimate.peeked = false
ultimate.peeking = false

function ultimate.FakeLagOnPeek()
    ultimate.fakeLagTicks = 21 - ultimate.chokedTicks - 1

    if ultimate.chokedTicks >= 20 then
        ultimate.peeked = true
		ultimate.peeking = false
		ultimate.SendPacket = true
        me.simtime_updated = true
        //ded.UpdateClientAnimation( me:EntIndex() )
		return
    end
end

local FakeEblan

local fakeeblan_factor = 3
if (1 / TickInterval) >= 66  then
	fakeeblan_factor = 4
end

local nextm9k = 0
local prevack = 0
local numerrors = 0

if ultimate.cfg.vars["Lag fix"] then
    if ultimate.cfg.vars["Backshoot"] then
        local targetTime = ded.GetSimulationTime( ply:EntIndex() )
        local timeOffset = ded.GetServerTime(cmd) - targetTime

        -- Check if we can backtrack without cl_interp
        local serverArriveTick = ded.GetServerTime(cmd) + ded.GetLatency(0) + ded.GetLatency(1)
        local diff = serverArriveTick - ply.aimshots.sw_backshoot_data.simTime
        if diff < 0.2 then
            local tick = ultimate.TIME_TO_TICKS(targetTime + ultimate.GetLerpTime())
            ded.SetCommandTick(cmd, tick)
        else
            ded.SetTargetInterp(ded.GetServerTime(cmd) - targetTime)

            local tick = ultimate.TIME_TO_TICKS(ded.GetServerTime(cmd))
            ded.SetCommandTick(cmd, tick - 1)
        end
    else
        local simTime = ded.GetSimulationTime(ply:EntIndex())
        local tick = ultimate.TIME_TO_TICKS(simTime + ultimate.GetLerpTime())
        ded.SetCommandTick(cmd, tick)
    end
end

function ultimate.WarpOnPeek()
	ded.StartShifting( true )

	ultimate.peeked = true
	ultimate.peeking = false
end

function ultimate.CheckPeeking()
	local plys

	for extr = 1, 8 do
        plys = ultimate.GetSortedPlayers( 1, extr, 1, true )
		if plys then break end
	end

	if plys and !ultimate.peeking and !ultimate.peeked then
		ultimate.peeking = true
		ultimate.peeked = false
	elseif !plys then
		ultimate.peeking = false
		ultimate.peeked = false
	end

	if ultimate.peeking and !ultimate.peeked then
		if !ded.GetIsShifting() and ded.GetCurrentCharge() >= ultimate.cfg.vars["Shift ticks"] and ultimate.cfg.vars["Warp on peek"] then
			ultimate.WarpOnPeek()
        elseif ultimate.cfg.vars["Freeze on peek"] then
            ded.SetOutSequenceNr( ded.GetOutSequenceNr() + ultimate.maxFreezeTicks - 1 )
		//elseif ultimate.cfg.vars["Fake lag options-On peek"] then
		//	ultimate.FakeLagOnPeek()
		end
	end
end




do

    local function shouldlag(cmd)
        if not ultimate.cfg.vars["Fake lag"] then return false end
        if not me:Alive() then return false end
        if ultimate.cfg.vars["Fakelag comp"] == 1 and ded.GetCurrentCharge() > 0 then return false end
        if ultimate.cfg.vars["Fake lag options-Disable on ladder"] and ultimate.moveType == MOVETYPE_LADDER then return false end
        if ultimate.cfg.vars["Fake lag options-Disable in attack"] and cmd:KeyDown(IN_ATTACK) then return false end
        //if ultimate.cfg.vars["Fake lag options-Only in AntiAim"] and !ultimate.cfg.vars["Anti aim"] or not ultimate.IsKeyDown(ultimate.cfg.binds["Anti aim"]) then return false end

        if ultimate.cfg.vars["Allah fly"] and not me:IsFlagSet( FL_ONGROUND ) then
            return false
        end

        return true
    end

    function ultimate.FakeLag(cmd)
        local factor = math_Round(ultimate.cfg.vars["Lag limit"])

        if ultimate.cfg.vars["Fake lag options-Randomise"] then
            factor =  math_random(ultimate.cfg.vars["Lag randomisation"],factor)
        end

        local velocity = me:GetVelocity():Length2D()
        local pertick = velocity * TickInterval
        local adaptive_factor = math_Clamp(math_ceil(64 / pertick),1,factor)

        if ultimate.cfg.vars["Lag mode"] == 1 or ultimate.cfg.vars["Lag mode"] == 3 then
            ultimate.fakeLagfactor = factor
        elseif ultimate.cfg.vars["Lag mode"] == 2 then
            ultimate.fakeLagfactor = adaptive_factor
        elseif ultimate.cfg.vars["Lag mode"] == 3 then
            ultimate.fakeLagfactor = 21
        elseif ultimate.cfg.vars["Lag mode"] == 5 then
            ultimate.fakeLagfactor = 21 and ded.SetOutSequenceNr(ded.GetOutSequenceNr() + 13)
        end

        //if ultimate.cfg.vars["Fakelag comp"] == 2 and ded.GetCurrentCharge() > 0 then
        //   local nfactor = ultimate.fakeLagfactor - ded.GetMaxShiftTicks() - 1
        //    ultimate.fakeLagfactor = math_Clamp( nfactor, 0, 21 )
        //end

        if shouldlag(cmd) then
            ultimate.SendPacket = false

            if ultimate.fakeLagTicks <= 0 then
                ultimate.fakeLagTicks = ultimate.fakeLagfactor
                ultimate.SendPacket = true
                me.simtime_updated = true
                //ded.UpdateClientAnimation( me:EntIndex() )
            else
                ultimate.fakeLagTicks = ultimate.fakeLagTicks - 1
            end

        else
            if ultimate.fakeLagfactor > 0 then ultimate.fakeLagfactor = 0 end
            ultimate.SendPacket = true
            me.simtime_updated = true
            //ded.UpdateClientAnimation( me:EntIndex() )
        end
    end
end

function ultimate.ClampMovementSpeed(cmd, speed)
	local final_speed = speed;

	local squirt = math_sqrt((cmd:GetForwardMove() * cmd:GetForwardMove()) + (cmd:GetSideMove() * cmd:GetSideMove()));

	if (squirt > speed) then
		local squirt2 = math_sqrt((cmd:GetForwardMove() * cmd:GetForwardMove()) + (cmd:GetSideMove() * cmd:GetSideMove()));

		local cock1 = cmd:GetForwardMove() / squirt2;
		local cock2 = cmd:GetSideMove() / squirt2;

		local Velocity = me:GetVelocity():Length2D();

		if (final_speed + 1.0 <= Velocity) then
			cmd:SetForwardMove(0)
			cmd:SetSideMove(0)
		else
			cmd:SetForwardMove(cock1 * final_speed)
			cmd:SetSideMove(cock2 * final_speed)
        end
    end
end

function ultimate.FastWalk2( cmd )
    if not ultimate.cfg.vars["Ground strafer"] then return end
    if math_abs(cmd:GetSideMove()) < 1 or math_abs(cmd:GetForwardMove()) > 1 then return end
    if not me:IsFlagSet( FL_ONGROUND ) then return end

    if ultimate.moveType == MOVETYPE_NOCLIP or ultimate.moveType == MOVETYPE_LADDER then return end

    local waterLevel = me:WaterLevel()

    if waterLevel >= 2 then return end

	cmd:SetForwardMove(cmd:CommandNumber() % 2 == 0 and -5250 or 5250)
end

function ultimate.FastWalk( cmd )
    if not ultimate.cfg.vars["Ground strafer"] then return end
    if math_abs(cmd:GetSideMove()) > 1 or math_abs(cmd:GetForwardMove()) < 1 then return end
    if not me:IsFlagSet( FL_ONGROUND ) then return end

    if ultimate.moveType == MOVETYPE_NOCLIP or ultimate.moveType == MOVETYPE_LADDER then return end

    local waterLevel = me:WaterLevel()

    if waterLevel >= 2 then return end

	cmd:SetSideMove(cmd:CommandNumber() % 2 == 0 and -5250 or 5250)
end

local function FastWalkUltimatium( cmd )
    if math_abs(cmd:GetSideMove()) > 1 then
        ultimate.FastWalk(cmd)
    elseif math_abs(cmd:GetForwardMove()) < 1 then
        ultimate.FastWalk2(cmd)
    end
end

hook.Add( "CreateMove", "MovementFix", FastWalkUltimatium )

local directionalMove = { IN_BACK, IN_MOVERIGHT, IN_MOVELEFT }

local function FixMovement( cmd )
    if not ultimate.cfg.vars["FixMovement"] then return end
    for i = 1, #directionalMove do
        cmd:RemoveKey( directionalMove[ i ] )
    end
end

hook.Add( "CreateMove", "MovementFix", FixMovement )

function ultimate.validMoveType()
    return ultimate.moveType != MOVETYPE_LADDER and ultimate.moveType != MOVETYPE_NOCLIP and ultimate.moveType != MOVETYPE_OBSERVER
end

function ultimate.isMoving(cmd)
    if not cmd then
        return false
    end

    return ultimate.hoppin or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) or cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) and not cmd:KeyDown(IN_JUMP)
end

function ultimate.Stop(cmd)
    if ultimate.validMoveType() and me:IsFlagSet( FL_ONGROUND ) then

        local moving = ultimate.isMoving(cmd)

        if not moving then

            local vel = me:GetVelocity()
            local dir = vel:Angle()

            dir.yaw = ultimate.SilentAngle.y - dir.yaw

            local newmove = dir:Forward() * vel:Length2D()

            cmd:SetForwardMove(0 - newmove.x)
            cmd:SetSideMove(0 - newmove.y)

        end

    end
end

// Slidewalk

function ultimate.SlideWalk( cmd )
    local ticksToStop = ultimate.fakeLagfactor





end

--для сравнения вложил сюда

/*function HERMES:Autopistol( ucmd )
	if( HERMES.GetGamemode( "terror town", "terrortown" ) ) then return end
	local ply = LocalPlayer()

	local w = ply:GetActiveWeapon()
	if( ValidEntity( w ) && HERMES.item['autopistol'] && ( ( w.Primary && w.Primary.Automatic == false || w.Automatic == false ) || table.HasValue( hl2, w:GetClass() ) ) ) then
		if( input.IsMouseDown( MOUSE_LEFT ) ) then
			HERMES.hermes.RunCommand( "+attack" )
			timer.Simple( 0.05, function() HERMES.hermes.RunCommand( "-attack" ) end )
		end
	end
end*/





// Auto peak

ultimate.startedPeeking = false
ultimate.needToMoveBack = false
ultimate.startPeekPosition = Vector(0,0,0)

function ultimate.MoveTo( cmd, pos )
    local ang = ( pos - me:GetPos() ):Angle().y

    cmd:SetForwardMove(1000)
    cmd:SetSideMove(0)

    cmd:AddKey(IN_SPEED)

    ultimate.MovementFix( cmd, ang )
end

function ultimate.checkAutopeak( cmd )
    if ultimate.startedPeeking and cmd:KeyDown(IN_ATTACK) then
        ultimate.needToMoveBack = true
    elseif !ultimate.startedPeeking and !cmd:KeyDown(IN_ATTACK) then
        ultimate.needToMoveBack = false
    end
end

do
    local colorA = Color( 235, 75, 75 )
    local colorB = Color( 75, 235, 75 )

    local apmat = Material( "gui/npc.png" )

    local nullangle = Angle(0,0,0)

    function ultimate.drawAutopeak()
        local col = ultimate.needToMoveBack and colorA or colorB

        cam_Start3D2D( ultimate.startPeekPosition, nullangle, 0.5 )
            cam_IgnoreZ( true )

            surface_SetDrawColor( col )
            surface_SetMaterial( apmat )
            surface_DrawTexturedRect( -32, -32, 64, 64 )

            cam_IgnoreZ( false )
        cam_End3D2D()
    end
end

function ultimate.autopeakThink()
    if ultimate.IsKeyDown(ultimate.cfg.binds["Auto peak"]) then
        if not ultimate.startedPeeking then
            ultimate.startPeekPosition = me:GetPos()
        end

        ultimate.startedPeeking = true
    else
        ultimate.startedPeeking = false
    end
end







/*// Movement
ultimate.holdingOnGround = false
ultimate.badMoveTypes = {
    ["MOVETYPE_NOCLIP"] = true, ["MOVETYPE_LADDER"] = true, ["MOVETYPE_OBSERVER"] = true
}

function ultimate.BunnyHop(cmd)
    local moveType = me:GetMoveType()
    local waterLevel = me:WaterLevel()

    if ultimate.badMoveTypes[moveType] then return end

    if me:IsFlagSet( FL_ONGROUND ) then

        --[[if ultimate.holdingOnGround then
            ultimate.holdingOnGround = false

            cmd:RemoveKey(IN_JUMP)
        end

        if cmd:KeyDown(IN_JUMP) then
            ultimate.holdingOnGround = true
        end

        return ]]
    else
        cmd:RemoveKey(IN_JUMP)
        return
    end

    //if waterLevel >= 2 then return end
end
*/

// Sequence Manipulation




ultimate.seqshit = false
function ultimate.SequenceShit(cmd)
    if not ultimate.cfg.vars["Sequence manip"] or not ultimate.IsKeyDown(ultimate.cfg.binds["Sequence manip"]) then



        if ultimate.seqshit then
            ultimate.seqshit = false
        end

        if ultimate.SendPacket then
            ultimate.chokedTicks = 0
        else
            ultimate.chokedTicks = ultimate.chokedTicks + 1
        end

        return
    end

    local amt = ultimate.cfg.vars["Sequence min random"] and math_random(ultimate.cfg.vars["Sequence min"],ultimate.cfg.vars["OutSequence"]) or ultimate.cfg.vars["OutSequence"]

    ded.SetBSendPacket(ultimate.SendPacket)

    ded.SetOutSequenceNr(ded.GetOutSequenceNr() + amt)

    if ultimate.cfg.vars["Lagger manip mode"] == 1 then
        ded.SetOutSequenceNr(ded.GetOutSequenceNr() + math_random(0, amt))
    elseif ultimate.cfg.vars["Lagger manip mode"] == 2  then
        ded.SetOutSequenceNr(ded.GetOutSequenceNr() + fakeeblan_factor * amt )
    elseif ultimate.cfg.vars["Lagger manip mode"] == 3 then
        ded.SetOutSequenceNr(ded.GetOutSequenceNr() + 13 )
    elseif ultimate.cfg.vars["Lagger manip mode"] == 4 then
        if ultimate.SendPacket then
            if ultimate.chokedTicks > 0 then
                ded.SetOutSequenceNr(ded.GetOutSequenceNr() + amt)
                ultimate.chokedTicks = 0  -- Reset choked ticks after sending the packet
            else
                ded.SetNetChokedPackets(127)
            end
        else
            ultimate.chokedTicks = ultimate.chokedTicks + 1
        end
    end



end

// Handjob ( arm breaker )

function ultimate.PerformHandjob( cmd )
    local mode = ultimate.cfg.vars["Handjob mode"]
    local shouldjerk = true

    if mode == 2 then
        shouldjerk = (cmd:CommandNumber() % 12) >= 6
    elseif mode == 3 then
        shouldjerk = math_random(0, 1) == 0
    end

    ded.SetTyping(cmd, shouldjerk)
end

// create move hook

ultimate.norf = {
    ["laserjetpack"] = true,
    ["weapon_physgun"] = true,
    ["rust_assaultrifle"] = true,
    ["rust_thompson"] = true,
    ["rust_smg"] = true,
    ["rust_mp5"] = true,
    ["rust_buildingplan"] = true,
}

ultimate.vapecd = false
ultimate.tyaga = 0
ultimate.maxvape = ultimate.TIME_TO_TICKS(5)
ultimate.hoppin = false
local ic = false

ultimate.slams = {}

hook.Add( "OnEntityCreated", "Aawwawawawawawawaawawa", function( ent )
    if ent:GetClass() == "npc_satchel" and ent:GetOwner() == me then
        ultimate.slams[ #ultimate.slams + 1 ] = ent
    end
end )



function ultimate.ShootTime()
    if !IsFirstTimePredicted then return end
    ultimate.servertime = CurTime(1) + TickInterval
end


function ultimate.CreateMove(cmd, UserCmd, mv )
    ultimate.SilentAngles(cmd)

    ultimate.aimingrn = false

    //if ( ded.GetChokedPackets() > 14 ) then ded.SetChokedPackets( 14 ) end

    if cmd:CommandNumber() == 0 then return end

    //if ded.GetIsShifting() then ultimate.shiftedTicks = ultimate.shiftedTicks + 1 end

    local w = me:GetActiveWeapon()
    ultimate.activeWeapon       = IsValid( w ) and w or false
    ultimate.activeWeaponClass  = IsValid( w ) and w:GetClass() or false
    ultimate.moveType           = me:GetMoveType()

    //if ultimate.cfg.vars["Passive recharge"] and ded.GetCurrentCharge() < ded.GetMaxShiftTicks() and not me:Alive() then
    //    ded.SetReloadKeyPressed( true )
    //end


    if ultimate.cfg.vars["Silent aim"] then cmd:SetViewAngles(ultimate.SilentAngle) end

    //if ded.GetIsShifting() then
        //  ded.AdjustTickbase()
    //    print("shifting")
    //end

    if ultimate.cfg.vars["Flashlight spam"] and input_IsKeyDown( KEY_F ) then
        cmd:SetImpulse(100)
    end

    if ultimate.cfg.vars["Auto Vape"] then
        if cmd:KeyDown( IN_ATTACK ) then
            if ultimate.tyaga >= ultimate.maxvape then
                cmd:RemoveKey( IN_ATTACK )
                ultimate.tyaga = 0
            elseif ultimate.tyaga < ultimate.maxvape then
                ultimate.tyaga = ultimate.tyaga + 1
            end
        else
            ultimate.tyaga = 0
        end
    end


    if ultimate.vapecd then
        ultimate.vapecd = false
        cmd:RemoveKey( IN_ATTACK2 )
    elseif ultimate.cfg.vars["Vape spam"] and ultimate.activeWeapon and not ultimate.vapecd and StartsWith( ultimate.activeWeaponClass, "weapon_vape" ) then
        cmd:AddKey( IN_ATTACK2 )
        ultimate.vapecd = true
    end

    if ultimate.cfg.vars["Handjob"] then
        ultimate.PerformHandjob( cmd )
    end

    //if ultimate.cfg.vars["Fake latency"] then
    //    local amt = ultimate.cfg.vars["Max latency"]
    //    ded.SetInSequenceNr(ded.GetInSequenceNr() - amt)
    //end

    if ultimate.SkipCommand then
        cmd:RemoveKey( IN_ATTACK )

        ultimate.SkipCommand = !ultimate.SkipCommand
    end

    if ( me:IsFlagSet( FL_ONGROUND ) ) then
		ultimate.last_ground_pos = me:GetNetworkOrigin().z
	end

    if ultimate.cfg.vars["Animation freezer"] then ultimate.AnimationFreezer() end

	ultimate.SequenceShit(cmd)

    if not ultimate.seqshit then
        ultimate.FakeLag(cmd)

        if ultimate.cfg.vars["Allah walk"] and ultimate.IsKeyDown(ultimate.cfg.binds["Allah walk"]) then

            if (ded.SetBSendPacket( ultimate.SendPacket )) then

                if (seqshift > 0) then

                    if (!bRunning) then

                        ded.SetOutSequenceNr(ded.GetOutSequenceNr() + seqshift)

                        bRunning = true

                    else

                        ded.SetNetChokedPackets(127)

                    end

                else

                    bRunning = false

                end

            end

            --print(ultimate.fakeLagTicks,me:GetVelocity():Length2D())
        end
    end

    if ultimate.cfg.vars["Fake lag options-On peek"] or ultimate.cfg.vars["Warp on peek"] or ultimate.cfg.vars["Freeze on peek"] then
        ultimate.CheckPeeking()
    end

    // Movement

    ultimate.FastWalk( cmd )
    ultimate.FastWalk2( cmd )

    if ultimate.cfg.vars["Sprint"] then
        cmd:AddKey(IN_SPEED)
    end

    local commandNumber = cmd:CommandNumber()
    if ultimate.cfg.vars["Bug Sprint"] and ( cmd:KeyDown(IN_SPEED) and commandNumber % 2 == 0 ) then
        cmd:RemoveKey(IN_SPEED)
    end

    HasJumped = me:IsFlagSet( FL_ONGROUND )
    ultimate.hoppin = false
    if ( cmd:KeyDown( IN_JUMP ) ) then

		if ( !me:IsFlagSet( FL_ONGROUND ) ) and ultimate.cfg.vars["Bhop"] then
			cmd:RemoveKey( IN_JUMP )
            ultimate.hoppin = true
            HasJumped = 1
        elseif ultimate.cfg.vars["Bhop safe"] then
            if HasJumped > ultimate.cfg.vars["Bhop safe duplex"] then
                cmd:AddKey( IN_JUMP )
                ultimate.hoppin = false
                HasJumped = 0
            end
        end



		ultimate.AutoStrafe( cmd )
	end


    /*if ultimate.cfg.vars["Slow Walk"] then
        if ultimate.cfg.binds["Slow Walk"] then
            if(input_IsKeyDown(KEY_A)) then
                cmd:SetForwardMove(ultimate.cfg.vars["Slow Walk speed"])
            end
            if(input_IsKeyDown(KEY_D)) then
                cmd:SetForwardMove(ultimate.cfg.vars["Slow Walk speed"])
            end
            if(input_IsKeyDown(KEY_W)) then
                cmd:SetSideMove(ultimate.cfg.vars["Slow Walk speed"])
            end
            if(input_IsKeyDown(KEY_S)) then
                cmd:SetSideMove(ultimate.cfg.vars["Slow Walk speed"])
            end
        end
    end*/

	if ultimate.cfg.vars["Fast stop"] then
        ultimate.Stop(cmd)
    end

    if ultimate.cfg.vars["Water jump"] and me:WaterLevel() > 1 then
        cmd:AddKey( IN_JUMP )

    elseif ultimate.cfg.vars["Jesus lag"] and ultimate.SendPacket and me:WaterLevel() == 1 then
        cmd:AddKey( IN_DUCK )
    end

    if ultimate.cfg.vars["Fake duck"] and ultimate.IsKeyDown(ultimate.cfg.binds["Fake duck"]) then
        if ultimate.fakeLagTicks > (ultimate.fakeLagfactor / 2) then
            cmd:AddKey(IN_DUCK)
        else
            cmd:RemoveKey(IN_DUCK)
        end
    end

    ultimate.targetVector = false
    if ultimate.cfg.vars["engine pred need for grust"] then ded.StartPrediction(cmd) end

        local wish_yaw = ultimate.SilentAngle.y

        if ( ultimate.IsKeyDown(ultimate.cfg.binds["Circle strafe"]) and ultimate.cfg.vars["Circle strafe"] ) then
            wish_yaw = cmd:GetViewAngles().y
        end


        ultimate.Aim(cmd)
        ultimate.SelectTarget(cmd)


        if ultimate.cfg.vars["Silent aim"] then
            ultimate.MovementFix( cmd, wish_yaw )
        end

    if ultimate.cfg.vars["Engine pred"] then ded.FinishPrediction() end

    if ultimate.cfg.vars["Trigger bot"] and ultimate.IsKeyDown( ultimate.cfg.binds["Trigger bot"] ) then
        local tr = me:GetEyeTrace().Entity

        if tr and tr:IsPlayer() then
            cmd:AddKey( IN_ATTACK )
        end
    end

    if ultimate.cfg.vars["Double tap"] and ultimate.cfg.vars["Tickbase shift"] and cmd:KeyDown( IN_ATTACK ) then
        //ultimate.shiftedTicks = 0
        print( cmd:KeyDown( IN_ATTACK ) )
        ded.StartShifting( true )
    end

    if ultimate.cfg.vars["Rapid fire"] and me:Alive() and not ultimate.cfg.vars["Rapid fire glitch"] then
        local commandNumber = cmd:CommandNumber()
        local w = me:GetActiveWeapon()

        if IsValid(w) and not ultimate.norf[ w:GetClass() ] and (cmd:KeyDown(IN_ATTACK) and commandNumber % 2 == 0)  then
            cmd:RemoveKey(IN_ATTACK)
        end
    end

    if ultimate.cfg.vars["Alt Rapid fire"] and me:Alive() and not ultimate.cfg.vars["Rapid fire glitch"] then
        local commandNumber = cmd:CommandNumber()
        local w = me:GetActiveWeapon()

        if IsValid(w) and (cmd:KeyDown(IN_ATTACK2) and commandNumber % 2 == 0)  then
            cmd:RemoveKey(IN_ATTACK2)
        end
    end

    if ultimate.cfg.vars["Auto detonator"] and #ultimate.slams > 0 then
        local d = ultimate.cfg.vars["AutoD distance"]
        d = d * d

        local plys = player_GetAll()

        for jjj = 1, #plys do
            if plys[ jjj ] == me then continue end

            for k, v in pairs(ultimate.slams) do
                if not IsValid(v) then ultimate.slams[k] = nil continue end

                local pos = v:GetPos()

                if pos:DistToSqr( plys[ jjj ]:GetPos() + plys[ jjj ]:GetVelocity() * ( TickInterval * 4 ) ) < d then
                    cmd:AddKey( IN_ATTACK2 )
                    break
                end
            end
        end
    end

    if ultimate.cfg.vars["Auto peak"] then
        local ppos = ultimate.startPeekPosition
        local pposd = me:GetPos():DistToSqr(ppos)

        if ultimate.needToMoveBack and pposd < 1024 then //or ultimate.IsMovementKeysDown( cmd )
            ultimate.needToMoveBack = false
        end

        if ultimate.startedPeeking then
            //if not ultimate.IsMovementKeysDown( cmd ) then
            //    ultimate.needToMoveBack = true
            //end

            if ultimate.needToMoveBack then
                ultimate.MoveTo( cmd, ppos )

                if ultimate.cfg.vars["Auto peak tp"] and ultimate.cfg.vars["Tickbase shift"] then
                    //ultimate.shiftedTicks = 0
                    print("NIGGER")
                    ded.StartShifting( true )
                end
            end
        end

        ultimate.checkAutopeak( cmd )
    end

    ultimate.autoReload(cmd)

    if ultimate.cfg.vars["Use spam"] then
        local commandNumber = cmd:CommandNumber()

        if ( cmd:KeyDown( IN_USE ) and commandNumber % 2 == 0 ) then
            cmd:RemoveKey( IN_USE )
        end
    end

    if ultimate.cfg.vars["Auto GTA"] then
        local tr = me:GetEyeTrace().Entity

        if IsValid( tr ) and tr:IsVehicle() then
            cmd:AddKey(IN_USE)
        end
    end

    if ultimate.cfg.vars["Ghost follower"] then
        local tar = player.GetBySteamID( ultimate.cfg.vars["GFID"] )

        if IsValid( tar ) then
            local tang = ( tar:GetPos() - me:EyePos() ):Angle()

            cmd:ClearMovement()
            cmd:ClearButtons()

            cmd:SetForwardMove( 10000 )
            cmd:SetSideMove(0)

            cmd:AddKey(IN_SPEED)

            cmd:SetViewAngles( tang )
            ultimate.MovementFix( cmd, tang.y )
        end
    end

    if ultimate.cfg.vars["Air lag duck"] and ultimate.SendPacket then
        local startPosUnducked = me:GetPos()
        local isDucking = bit.band(me:GetFlags(), FL_DUCKING) != 0
        if isDucking then
            startPosUnducked.z = startPosUnducked.z - (72 - 36)
        end

        ded.StartSimulation( me:EntIndex() )

        local shouldduck = true

        for i = 1, 4 do
            ded.SimulateTick()

            local simData = ded.GetSimulationData()

            local maxs = me:OBBMaxs()
            maxs.z = 72

            if isDucking then
                simData.m_vecAbsOrigin.z = simData.m_vecAbsOrigin.z - (72 - 36)
            end

            local trace = TraceHull({
                start = startPosUnducked,
                endpos = simData.m_vecAbsOrigin,
                mins = me:OBBMins(),
                maxs = maxs,
                filter = me,
                mask = MASK_PLAYERSOLID
            })

            if me:IsOnGround() and trace.Hit then
                shouldduck = false
                break
            end
        end

        ded.FinishSimulation()

        if shouldduck and !me:IsFlagSet( FL_ONGROUND ) then
            cmd:AddKey( IN_DUCK )
        end
    end

    if ultimate.fcenabled then
        cmd:ClearMovement()
        cmd:ClearButtons()

        cmd:SetViewAngles(ultimate.fcangles)
    end

    /*if ultimate.cfg.vars["Dodge projectiles"] and ded.GetCurrentCharge() >= ded.GetMaxShiftTicks() and not ded.GetIsShifting() then
        local entitys = ents_GetAll()

        for i = 1, #entitys do
            local v = entitys[ i ]

            if v:GetClass() != "crossbow_bolt" then continue end

            local mypos = me:GetPos() + me:GetVelocity() * TickInterval
            local entpos = v:GetPos() + ( v:GetAngles():Forward() * 3500 ) * TickInterval

            if mypos:DistToSqr( entpos ) > 320 then
                cmd:ClearMovement()
                cmd:ClearButtons()

                cmd:AddKey( IN_SPEED )
                cmd:SetSideMove( 10000 )
                ded.StartShifting( true )
            end
        end
    end*/

    if ultimate.SendPacket then
        ultimate.chokedTicks = 0
    else
        ultimate.chokedTicks = ultimate.chokedTicks + 1
    end

    if not ultimate.cfg.vars["Silent aim"] then ultimate.SilentAngle = cmd:GetViewAngles() end

    ded.SetBSendPacket( ultimate.SendPacket )

    if ultimate.cfg.vars["Lag mode"] == 3 and ultimate.SendPacket then
        ded.SetOutSequenceNr(ded.GetOutSequenceNr() + 13)
    end
end


gandon = {
    ["rust_woodenspear"] = true,
    ["rust_stonespear"] = true,
    ["rust_salvagedsword"] = true,
    ["rust_salvagedcleaver"] = true,
    ["rust_pickaxe"] = true,
}

hook_Add( "CreateMove", "ultimate.CreateMove", ultimate.CreateMove ) // Post

/*sosuhui = ultimate.activeWeaponClass
local pidorok = 4
if sosuhui == "rust_woodenspear" or "rust_stonespear" then
    pidorok = 0.645
else
    pidorok = 1
end
local cli = 0

hook.Add("Think", "123", function()
    local w = me:GetActiveWeapon()
    if not IsValid(me) then return end
    if not IsValid(w) then return end

    if me:KeyDown(IN_ATTACK) and gandon[w:GetClass()] and me:Alive() then
        if CurTime() >= cli then
            cli = CurTime() + pidorok
            RunConsoleCommand("+attack2")
            timer.Simple(0.00001, function() RunConsoleCommand("-attack2") end)
        end
    end
end)*/

/*
    Render Scene / Anti screengrab
*/
ultimate.UnSafeFrame = false
ultimate.renderTarget = GetRenderTarget( "YaPidoras" .. os.time(), scrw, scrh )

do
    local oldsky, oldskycolor, oldwallcolor = ultimate.cfg.vars["Custom sky"], ultimate.cfg.vars["Sky color"], ultimate.cfg.vars["Wall color"]
    local oldskyclr, oldwallclr = ultimate.cfg.colors["Sky color"], ultimate.cfg.colors["Wall color"]

    local worldcollerp = string_ToColor( ultimate.cfg.colors["Wall color"] )
    local worldmats = Entity( 0 ):GetMaterials()

    local origsky = GetConVar("sv_skyname"):GetString()
    local tsides = {"lf", "ft", "rt", "bk", "dn", "up"}
    local skymat = {}

    for i = 1, 6 do
        skymat[i] = Material("skybox/" .. origsky .. tsides[i])
    end

    local function setSkyboxTexture( skyname )
        for i = 1, 6 do
            local t = Material("skybox/" .. skyname .. tsides[i]):GetTexture("$basetexture")
            skymat[i]:SetTexture("$basetexture", t)
        end
    end

    local function setSkyColor( setcolor )
        local cfg = string_ToColor( ultimate.cfg.colors["Sky color"] )
        local vector = setcolor and Vector( cfg.r/255, cfg.g/255, cfg.b/255 ) or Vector( 1, 1, 1 )

        for i = 1, 6 do
            skymat[i]:SetVector( "$color", vector )
        end
    end



    local function setWallColor( setcolor )
        local cfg = string_ToColor( ultimate.cfg.colors["Wall color"] )
        worldcollerp = ultimate.ColorLerp( worldcollerp, cfg )
        local vector = setcolor and Vector( worldcollerp.r/255, worldcollerp.g/255, worldcollerp.b/255 ) or Vector( 1, 1, 1 )

        for i = 1, #worldmats do
            local value = worldmats[i]

            Material( value ):SetVector( "$color", vector )
            Material( value ):SetFloat( "$alpha", setcolor and (cfg.a / 255) or 255 )
        end
    end

    function ultimate.hRenderScene()

        local newname, newcolor, newcolor2 = ultimate.cfg.vars["Custom sky"], ultimate.cfg.vars["Sky color"], ultimate.cfg.vars["Wall color"]
        local newskyclr, newwallclr = ultimate.cfg.colors["Sky color"],ultimate.cfg.colors["Wall color"]

        if newskyclr != oldskyclr or newcolor != oldskycolor then
            setSkyColor( newcolor )

            oldskyclr = newskyclr
            oldskycolor = newcolor
        end

        if newwallclr != tostring( worldcollerp ) or newcolor2 != oldwallcolor then
            setWallColor( newcolor2 )

            oldwallcolor = newcolor2
        end

        if newname != oldsky then
            setSkyboxTexture( newname )
            oldsky = newname
        end

        // Esp shit

        if ( !gui.IsConsoleVisible() && !gui.IsGameUIVisible() ) || ultimate.UnSafeFrame then
            local view = {
                x = 0,
                y = 0,
                w = scrw,
                h = scrh,
                dopostprocess = true,
                origin = vOrigin,
                angles = vAngle,
                fov = vFOV,
                drawhud = true,
                drawmonitors = true,
                drawviewmodel = true
            }

            render_RenderView( view )
            render.CopyTexture( nil, ultimate.renderTarget )

            cam_Start2D()
                hook_Run( "Ungrabbable2D" )
            cam_End2D()

            cam_Start3D()
                hook_Run( "Ungrabbable3D" )
            cam_End3D()

            render.SetRenderTarget( ultimate.renderTarget )

            return true
        end
    end

end

function render.Capture( data )
    ultimate.PreScreenGrab()

    if ultimate.cfg.vars["Screengrab image"] then
        cam.Start2D()
            render.DrawTextureToScreen( ultimate.prikol )
        cam.End2D()
    end

	return render_Capture( data )
end

function ultimate.Shutdown()
    render.SetRenderTarget()
end

function _G.render.Capture( data )
    ultimate.PreScreenGrab()

    if ultimate.cfg.vars["Screengrab image"] then
        cam.Start2D()
            render.DrawTextureToScreen( ultimate.prikol )
        cam.End2D()
    end

	return render_Capture( data )
end

function ultimate.PreScreenGrab()
    if ultimate.UnSafeFrame then return end
	ultimate.UnSafeFrame = true

	render_Clear( 0, 0, 0, 255, true, true )
	render_RenderView( {
		origin = me:EyePos(),
		angles = me:EyeAngles(),
		x = 0,
		y = 0,
		w = scrw,
		h = scrh,
		dopostprocess = true,
		drawhud = true,
		drawmonitors = true,
		drawviewmodel = true
	} )

	ultimate.UnSafeFrame = false
end


       





/*
    ESP, Chams
*/

function ultimate.IsValidPlayer(pl)
    if pl == me then return false end
    if not IsValid(pl) then return false end
    if not pl:Alive() then return false end


    return true
end

function ultimate.GetEntPos(ent)
    local min, max = ent:OBBMins(), ent:OBBMaxs()

    local points = {
        Vector( max.x, max.y, max.z ),
        Vector( max.x, max.y, min.z ),
        Vector( max.x, min.y, min.z ),
        Vector( max.x, min.y, max.z ),
        Vector( min.x, min.y, min.z ),
        Vector( min.x, min.y, max.z ),
        Vector( min.x, max.y, min.z ),
        Vector( min.x, max.y, max.z )
    }

    local MaxX, MinX, MaxY, MinY
    local isVisible = false

    for i = 1, #points do
        local v = points[i]
        local p = ent:LocalToWorld( v ):ToScreen()
        isVisible = p.visible

		if MaxX != nil then
            MaxX, MaxY, MinX, MinY = math_max( MaxX, p.x ), math_max( MaxY, p.y), math_min( MinX, p.x ), math_min( MinY, p.y)
        else
            MaxX, MaxY, MinX, MinY = p.x, p.y, p.x, p.y
        end

    end

    return MaxX, MaxY, MinX, MinY, isVisible
end

function ultimate.getTextX(tw,pos)
    if pos == 1 or pos == 2 then
        return tw/2
    elseif pos == 3 then
        return 0
    elseif pos == 4 then
        return tw
    end
end

function ultimate.getTextY(max,min,th,pos,tbpos)
    if pos == 1 then
        return min-th-th*tbpos
    elseif pos == 2 then
        return max+th*tbpos
    elseif pos == 3 then
        return min+th*tbpos
    elseif pos == 4 then
        return min+th*tbpos
    end
end

function ultimate.SortByDistance( f, s )
    return f[1]:GetPos():DistToSqr( EyePos() ) > s[1]:GetPos():DistToSqr( EyePos() )
end

function ultimate.GenerateArrowPoss(x, y, scale, ang)
    local ang1 = Angle(0, ang, 0):Forward() * scale
    local ang2 = Angle(0, ang + 120, 0):Forward() * (scale - 1)
    local ang3 = Angle(0, ang - 120, 0):Forward() * (scale - 1)

    local p0 = {x = x, y = y}
    local poly = {
        {x = p0.x + ang1.x, y = p0.y + ang1.y},
        {x = p0.x + ang2.x, y = p0.y + ang2.y},
        {x = p0.x + ang3.x, y = p0.y + ang3.y},
    }
    return poly
end

function ultimate.DrawOutlinedPoly( poly )
    local last = nil
    for i = 1, #poly do
        local v = poly[ i ]
        if last then
            surface_DrawLine(last.x, last.y, v.x, v.y)
            last = v
        else
            last = v
        end
    end
    surface_DrawLine(last.x, last.y, poly[1].x, poly[1].y)
end

ultimate.Fonts = {
    [1] = "veranda",
    [2] = "veranda_s",
    [3] = "thug",
    [4] = "arial",
}

/*local PLAYER = FindMetaTable("Player")
PLAYER.gRust = true
function PLAYER:HealthHUI(health)
    return self:Health("Health",1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100)
end

function PLAYER:GetHP(health)
    return self:Health(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100)
end

function PLAYER:GetMaxHP(health)
    return self:GetMaxHealth("Health",100)
end*/

function ultimate.DrawESP()
    local d = ultimate.cfg.vars["ESP Distance"]
    local ed = ultimate.cfg.vars["Ent ESP Distance"]
    local pos = me:GetPos()
    d = d * d
    ed = ed * ed

    surface_SetFont( ultimate.Fonts[ ultimate.cfg.vars["ESP Font"] ] )

    if ultimate.cfg.vars["Ent box 3d"] then
        cam_Start3D()
            for i = 1, #ultimate.entityCache do
                local v = ultimate.entityCache[ i ]

                if not IsValid( v.entity ) then return end

                if v.position:DistToSqr( pos ) > ed then continue end

                render_DrawWireframeBox( v.position, v.entity:GetAngles(), v.entity:OBBMins(), v.entity:OBBMaxs(), ultimate.Colors[255], true )
            end
        cam_End3D()
    end

    for i = 1, #ultimate.entityCache do
        local v = ultimate.entityCache[ i ]

        if not IsValid( v.entity ) then return end

        if v.position:DistToSqr( pos ) > ed then continue end

        local MaxX, MaxY, MinX, MinY, isVisible = ultimate.GetEntPos( v.entity )
        local XLen, YLen = MaxX - MinX, MaxY - MinY

        if not isVisible then continue end

        surface_SetAlphaMultiplier( v.entity:IsDormant() and 0.35 or 1 )

        surface_SetTextColor( ultimate.Colors[255] )

        if ultimate.cfg.vars["Ent box"] and not ultimate.cfg.vars["Ent box 3d"] then
            surface_SetDrawColor( 0, 0, 0 )
            surface_DrawOutlinedRect(MinX-1,MinY-1,XLen+2,YLen+2,3)

            surface_SetDrawColor( 255, 255, 255 )
            surface_DrawOutlinedRect(MinX,MinY,XLen,YLen,1)
        end

        if ultimate.cfg.vars["Ent class"] then
            local tw, th = surface_GetTextSize( v.class )

            surface_SetTextPos( ( MaxX + (MinX - MaxX) / 2 ) - tw / 2 , MinY - th )
            surface_DrawText( v.class )
        end
    end

    local plys = player_GetAll()

    local color_box     = string_ToColor( ultimate.cfg.colors["Box esp"] )
    local color_box_g   = string_ToColor( ultimate.cfg.colors["Box gradient"] )
    local color_arrow   = string_ToColor( ultimate.cfg.colors["OOF Arrows color"] )

    local myEyePos = me:EyePos()

    for i = 1, #plys do
        local v = plys[i]

        if not ultimate.IsValidPlayer(v) or not ultimate.playerCache[ v ] then continue end

        local vp = ultimate.playerCache[ v ].GetPos
        local distance = vp:DistToSqr(pos)
		if distance > d then continue end

        surface_SetAlphaMultiplier( v:IsDormant() and 0.35 or 1 )

        local MaxX, MaxY, MinX, MinY, isVisible = ultimate.GetEntPos( v )
        local XLen, YLen = MaxX - MinX, MaxY - MinY

        local teamcolor = ultimate.playerCache[ v ].TeamColor

        if ultimate.cfg.vars["OOF Arrows"] then
            local xScale, yScale = scrw / 250, scrh / 250
            local xScale, yScale = xScale * 50, yScale * 50

            local angle = ( v:EyePos() - myEyePos ):Angle()
            local addPos = Angle(0, (ultimate.SilentAngle.y - angle.y) - 90, 0):Forward()
            local pos = Vector(scrw / 2, scrh / 2, 0) + Vector(addPos.x * xScale, addPos.y * yScale, 0)

            if math.abs( math.NormalizeAngle(angle.y - ultimate.SilentAngle.y) ) >= 60 then
                local poly = ultimate.GenerateArrowPoss(pos.x, pos.y, 16, (ultimate.SilentAngle.y - angle.y) - 90)
                local poly1 = ultimate.GenerateArrowPoss(pos.x, pos.y, 17, (ultimate.SilentAngle.y - angle.y) - 90)
                local poly2 = ultimate.GenerateArrowPoss(pos.x, pos.y, 15, (ultimate.SilentAngle.y - angle.y) - 90)

                if ultimate.cfg.vars["OOF Style"] == 1 then
                    surface_SetDrawColor( ultimate.Colors[0] )
                    ultimate.DrawOutlinedPoly( poly1 )
                    ultimate.DrawOutlinedPoly( poly2 )

                    surface_SetDrawColor(  ultimate.cfg.vars["OOF team color"] and teamcolor or color_arrow )
                    ultimate.DrawOutlinedPoly( poly )
                else
                    local ang2 = Angle(0, (ultimate.SilentAngle.y - angle.y) - 90 + 120, 0):Forward() * (scale - 1)
                    surface_SetDrawColor( teamcolor )

                    surface_DrawLine( pos.x, pos.y, pos.x, pos.y + ang2.y )
                    surface_DrawLine(last.x, last.y, v.x, v.y)
                    surface_DrawLine(last.x, last.y, v.x, v.y)
                    surface_DrawLine(last.x, last.y, v.x, v.y)
                end

            end
        end






        if not isVisible then continue end

        if ultimate.cfg.vars["Box esp"] then
            if ultimate.cfg.vars["Box style"] == 1 then
                surface_SetDrawColor(ultimate.Colors[0])
                surface_DrawOutlinedRect(MinX-1,MinY-1,XLen+2,YLen+2,3)

                surface_SetDrawColor( ultimate.cfg.vars["Box team color"] and teamcolor or color_box )
                surface_DrawOutlinedRect(MinX,MinY,XLen,YLen,1)
            elseif ultimate.cfg.vars["Box style"] == 2 then
                local wlen, hlen = math_floor( XLen / 3 ), math_floor( YLen / 3 )

                surface_SetDrawColor(ultimate.Colors[0])

                // Left up
                surface_DrawRect( MinX - 1, MinY - 1, wlen, 3 )
                surface_DrawRect( MinX - 1, MinY - 1, 3, hlen )

                // Right up
                surface_DrawRect( MaxX - wlen + 2, MinY - 1, wlen, 3 )
                surface_DrawRect( MaxX - 1, MinY - 1, 3, hlen )

                // Left down
                surface_DrawRect( MinX - 1, MaxY - 2, wlen, 3 )
                surface_DrawRect( MinX - 1, MaxY - hlen, 3, hlen )

                // Right down
                surface_DrawRect( MaxX - wlen + 2, MaxY - 2, wlen, 3 )
                surface_DrawRect( MaxX - 1, MaxY - hlen, 3, hlen )

                surface_SetDrawColor( ultimate.cfg.vars["Box team color"] and teamcolor or color_box )

                wlen = wlen - 2
                hlen = hlen - 2

                // Left up
                surface_DrawRect( MinX, MinY, wlen, 1 )
                surface_DrawRect( MinX, MinY, 1, hlen )

                // Right up
                surface_DrawRect( MaxX - wlen + 1, MinY, wlen, 1 )
                surface_DrawRect( MaxX, MinY, 1, hlen )

                // Left down
                surface_DrawRect( MinX, MaxY - 1, wlen, 1 )
                surface_DrawRect( MinX, MaxY - hlen - 1, 1, hlen )

                // Right down
                surface_DrawRect( MaxX - wlen + 1, MaxY - 1, wlen, 1 )
                surface_DrawRect( MaxX, MaxY - hlen - 1, 1, hlen )
            elseif ultimate.cfg.vars["Box style"] == 3 then
                local wlen, hlen = math_floor( XLen / 3 ), math_floor( YLen / 3 )
                local xc = math_floor( XLen / 2 )

                surface_SetDrawColor(ultimate.Colors[0])

                // Left
                surface_DrawRect( MinX - 1, MinY - 1 + hlen, 3, hlen )

                surface_DrawLine( MinX - 1, MinY - 1 + hlen, MinX + xc, MinY - 1 )
                surface_DrawLine( MinX + 1, MinY - 1 + hlen, MinX + xc, MinY + 1 )

                surface_DrawLine( MinX - 1, MinY - 2 + hlen * 2, MinX + xc, MinY + 1 + YLen )
                surface_DrawLine( MinX + 1, MinY - 2 + hlen * 2, MinX + xc, MinY - 1 + YLen )

                // Right
                surface_DrawRect( MaxX - 1, MinY - 1 + hlen, 3, hlen )

                surface_DrawLine( MaxX - 1, MinY - 1 + hlen, MinX + xc, MinY + 1 )
                surface_DrawLine( MaxX + 1, MinY - 1 + hlen, MinX + xc, MinY - 1 )

                surface_DrawLine( MaxX - 1, MinY - 2 + hlen * 2, MinX + xc, MinY - 1 + YLen )
                surface_DrawLine( MaxX + 1, MinY - 2 + hlen * 2, MinX + xc, MinY + 1 + YLen )

                surface_SetDrawColor( ultimate.cfg.vars["Box team color"] and teamcolor or color_box )

                // Left
                surface_DrawRect( MinX, MinY + hlen - 1, 1, hlen )
                surface_DrawLine( MinX, MinY - 1 + hlen, MinX + xc, MinY )
                surface_DrawLine( MinX, MinY - 2 + hlen * 2, MinX + xc, MinY + YLen )

                // Right
                surface_DrawRect( MaxX, MinY + hlen - 1, 1, hlen )
                surface_DrawLine( MaxX, MinY - 1 + hlen, MinX + xc, MinY )
                surface_DrawLine( MaxX, MinY - 2 + hlen * 2, MinX + xc, MinY + YLen )
            elseif ultimate.cfg.vars["Box style"] == 4 then
                local wlen, hlen = math_floor( XLen / 3 ) + 3, math_floor( YLen / 3 ) + 3
                local x, y, xw, xh = MinX - 3, MinY - 3, MaxX + 3, MaxY + 3
                local polys = {}

                for i = 1, 3 do
                    polys = {
                        { x = x + wlen, y = y },
                        { x = xw - wlen, y = y },
                        { x = xw, y = y + hlen },
                        { x = xw, y = xh - hlen },
                        { x = xw - wlen, y = xh },
                        { x = x + wlen, y = xh },
                        { x = x, y = xh - hlen },
                        { x = x, y = y + hlen },
                    }

                    surface_SetDrawColor( i == 2 and teamcolor or ultimate.Colors[0] )
                    ultimate.DrawOutlinedPoly( polys )

                    wlen, hlen = wlen - i, hlen - i

                    y, x = y + i, x + i
                    xw, xh = xw - i, xh - i
                end
            elseif ultimate.cfg.vars["Box style"] == 5 then


                surface_DrawLine( MaxX, MaxY, MinX + XLen * 0.7, MaxY)
                surface_DrawLine( MinX, MaxY, MinX + XLen * 0.3, MaxY)
                surface_DrawLine( MaxX, MaxY, MaxX, MinY + YLen * 0.75)
                surface_DrawLine( MaxX, MinY, MaxX, MinY + YLen * 0.25)
                surface_DrawLine( MinX, MinY, MaxX - XLen * 0.7, MinY )
                surface_DrawLine( MaxX, MinY, MaxX - XLen * 0.3, MinY )
                surface_DrawLine( MinX, MinY, MinX, MaxY - YLen * 0.75)
                surface_DrawLine( MinX, MaxY, MinX, MaxY - YLen * 0.25)

                surface_SetDrawColor( ultimate.cfg.vars["Box team color"] and teamcolor or color_box )








            end
        end

        // Sight lines

        if ultimate.cfg.vars["Sight lines"] then
            local tr = v:GetEyeTrace()
            local startpos, hitpos = tr.StartPos:ToScreen(), tr.HitPos:ToScreen()

            surface_SetDrawColor( string_ToColor(ultimate.cfg.colors["Sight lines"]) )
            surface_DrawLine( startpos.x, startpos.y, hitpos.x, hitpos.y )
        end

        // text

        local ttbl = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 }
        local poses = { [1] = MaxX + (MinX - MaxX) / 2, [3] = MaxX+5, [4] = MinX-5 }
        poses[2] = poses[1]


        if ultimate.cfg.vars["Name"] then
            local name = ultimate.playerCache[ v ].Name
            local pos = ultimate.cfg.vars["Name pos"]
            local tw, th = surface_GetTextSize(name)

            surface_SetTextColor( string_ToColor(ultimate.cfg.colors["Name"]) )
            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Usergroup"] then
            local name = ultimate.playerCache[ v ].GetUserGroup
            local pos = ultimate.cfg.vars["Usergroup pos"]
            local tw, th = surface_GetTextSize(name)

            surface_SetTextColor( string_ToColor(ultimate.cfg.colors["Usergroup"]) )
            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Weapon"] then
            local name = ultimate.cfg.vars["Show ammo"] and ultimate.playerCache[ v ].WeaponClass .. " (" .. ultimate.playerCache[ v ].WeaponAmmo .. ")" or ultimate.playerCache[ v ].WeaponClass

            if ultimate.cfg.vars["Show reloading"] then
                for i = 0, 13 do
                    if v:IsValidLayer(i) then
                        if v:GetSequenceActivityName(v:GetLayerSequence(i)):find("RELOAD") then
                            name = "RELOADING"
                            break
                        end
                    end
                end
            end

            local pos = ultimate.cfg.vars["Weapon pos"]
            local tw, th = surface_GetTextSize(name)

            surface_SetTextColor( string_ToColor(ultimate.cfg.colors["Weapon"]) )
            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Armor"] then
            local name = ultimate.playerCache[ v ].Armor
            local pos = ultimate.cfg.vars["Armor pos"]
            local tw, th = surface_GetTextSize(name)

            surface_SetTextColor( string_ToColor(ultimate.cfg.colors["Armor"]) )
            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Team"] then
            local name = ultimate.playerCache[ v ].TeamName
            local pos = ultimate.cfg.vars["Team pos"]
            local tw, th = surface_GetTextSize(name)

            if ultimate.cfg.vars["Team colorSUCK"] then
                surface_SetTextColor( teamcolor )
            elseif not ultimate.cfg.vars["Team colorSUCK"] then
                surface_SetTextColor( string_ToColor(ultimate.cfg.colors["Team"]) )
            end


            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["DarkRP Money"] then
            local name = ultimate.playerCache[ v ].MoneyVar
            local pos = ultimate.cfg.vars["Money pos"]
            local tw, th = surface_GetTextSize(name)

            surface_SetTextColor( string_ToColor(ultimate.cfg.colors["DarkRP Money"]) )
            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        local health = ultimate.playerCache[ v ].Health

        if ultimate.cfg.vars["Health bar"] then
            local maxhealth = ultimate.playerCache[ v ].GetMaxHealth

			local healthfrac = math_min( health / maxhealth, 1 )
		    local height = math_floor( healthfrac * YLen )

            surface_SetDrawColor( 0, 0, 0 )
            surface_DrawRect( MinX-6, MinY-1, 4, YLen+2 )

			surface_SetDrawColor( string_ToColor( ultimate.cfg.colors["Health"] ) )
			surface_DrawRect(MinX - 5, MinY+YLen-height, 2, height)

            if ultimate.cfg.vars["Health bar gradient"] then
                surface_SimpleTexturedRect( MinX - 5, MinY+YLen-height, 2, height, string_ToColor( ultimate.cfg.colors["Health bar gradient"] ) , ultimate.Materials["Gradient"] )
            end
            if ultimate.cfg.vars["Health bar gradient grust"] then
                surface_SimpleTexturedRect( MinX - 5, MinY+YLen-height, 2, height, string_ToColor( ultimate.cfg.colors["Health bar gradient"] ) , ultimate.Materials["Gradient"] )
            end
        end

        if ultimate.cfg.vars["Print Distance"] then
            local distance_in_units = vp:DistToSqr(pos) -- расстояние в игровых единицах
            local rounded_distance = math.floor(math.sqrt(distance_in_units)) -- берем корень и округляем

            local pos = ultimate.cfg.vars["Print Distance pos"]
            local tw, th = surface_GetTextSize(tostring(rounded_distance)) -- преобразуем в строку
            surface_SetTextPos(poses[pos] - ultimate.getTextX(tw, pos), ultimate.getTextY(MaxY, MinY, th, pos, ttbl[pos]))

            -- Отображаем округленное расстояние в юнитах
            surface_DrawText(tostring(rounded_distance))

            ttbl[pos] = ttbl[pos] + 0.8
            surface_SetDrawColor(string_ToColor(ultimate.cfg.colors["Print Distance"]))
        end



        if ultimate.cfg.vars["Health"] then
            local pos = ultimate.cfg.vars["Health pos"]
            local tw, th = surface_GetTextSize(health)

            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(health)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Break LC"] and v.break_lc then
            local name = "Breaking LC"
            local pos = ultimate.cfg.vars["Break LC pos"]
            local tw, th = surface_GetTextSize(name)

            surface_SetTextColor( string_ToColor(ultimate.cfg.colors["Break LC"]) )
            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Simtime updated"] then
            local name = v.simtime_updated and "Updated" or "Same"
            local pos = ultimate.cfg.vars["Simtime pos"]
            local tw, th = surface_GetTextSize(name)

            surface_SetTextColor( string_ToColor(ultimate.cfg.colors["Simtime updated"]) )
            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["IFOV"] then
            local angle = ( v:EyePos() - myEyePos ):Angle()
            local infov = math_abs( math_NormalizeAngle( angle.y ) ) > 75
            local name = infov and "Я БЛЯТЬ В FOV!" or "Я СЬЕБАЛСЯ С FOV!"
            local pos = ultimate.cfg.vars["Simtime pos"]
            local tw, th = surface_GetTextSize(name)

            surface_SetTextColor( string_ToColor(ultimate.cfg.colors["IFOV"]) )
            surface_SetTextPos(poses[pos]-ultimate.getTextX(tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface_DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Skeleton"] then
            surface_SetDrawColor( string_ToColor( ultimate.cfg.colors["Skeleton"] ) )

		    for i = 0, v:GetBoneCount() - 1 do

			    local parent = v:GetBoneParent(i)

			    if(!parent) then continue end

			    local bonepos = v:GetBonePosition(i)

			    if(bonepos == v:GetPos() ) then continue end

			    local parentpos = v:GetBonePosition(parent)

			    if(!bonepos or !parentpos) then continue end

			    local screen1, screen2 = bonepos:ToScreen(),parentpos:ToScreen()

			    surface_DrawLine(screen1.x,screen1.y,screen2.x,screen2.y)
		    end
        end

        if ultimate.cfg.vars["Hitbox"] then

            if v:GetHitBoxGroupCount() != nil then
                for group = 0, v:GetHitBoxGroupCount() - 1 do
                    for hitbox = 0, v:GetHitBoxCount( group ) - 1 do
                        local pos, ang = v:GetBonePosition( v:GetHitBoxBone(hitbox, group) )
                        local mins, maxs = v:GetHitBoxBounds(hitbox, group)
                        cam_Start3D()
                        render_DrawWireframeBox( pos, ang, mins, maxs, string_ToColor(ultimate.cfg.colors["Hitbox"]), true)
                        cam_End3D()
                    end
                end

            end

        end

        if ultimate.cfg.vars["Show records"] and ultimate.canBacktrack(v) then
            local len = #ultimate.btrecords[ v ]

            for i = 1, len do
                local pos = ( ultimate.btrecords[v][i].aimpos ):ToScreen()
                surface_SetDrawColor( ultimate.backtracktick == i and ultimate.Colors["Red"] or ultimate.Colors[255] )
                surface_DrawRect(pos.x,pos.y,2,2)
            end
        end

        if ultimate.cfg.vars["Backtrack skeleton"] and ultimate.canBacktrack(v) then
            local len = #ultimate.btrecords[ v ]

            surface_SetDrawColor( ultimate.Colors[255] )

            for i = 1, len do
                local data = ultimate.btrecords[ v ][ i ].skeleton

                for nbone = 1, #data do
                    local screen1, screen2 = data[nbone][1]:ToScreen(), data[nbone][2]:ToScreen()

                    surface_DrawLine(screen1.x,screen1.y,screen2.x,screen2.y)
                end
            end
        end
    end

    surface_SetAlphaMultiplier(1)
end


surface.CreateFont("DTFont", { font = "Verdana", size = 15, antialias = false, outline = true } )

ultimate.fovColor = Color( 255, 255, 255 )
ultimate.gradFov = false

ultimate.antiboba = function(text, maxChars)
    local str = ""

    for i=1, maxChars do
        str = str .. (text[i] || "")
    end

    return str
end






//ultimate.bgmaterial = Material( "a/paws.png", "noclamp smooth" )



do
    local lc, blc = Color(125,255,64), Color(255,64,125)

    local indx, indy = scrw / 2 - 100, scrh/2 + 250
    local charge = 0

    local gradcolor, chargedcolor, unchargedcolor = Color(200,200,200,128), Color(0,255,128), Color(255,155,0)

    local chargestate, ccharge, chargecolor = "NOT CHARGED", 0, chargedcolor
    local watermarkx = scrw + 245
    local watermarkc = Color( 232, 232, 232, 235)

    function ultimate.DrawSomeShit()

        //if ultimate.frame:IsVisible() then
        //    surface_SetDrawColor( ultimate.accent )
        //    surface_SetMaterial( ultimate.bgmaterial )
        //    surface_DrawTexturedRect( 0, 0, scrw, scrh )
        //end

        surface_SetFont("DTFont")

        if ultimate.cfg.vars["Indicators"] then

            local latency = math_Round( ( ded.GetLatency(0) + ded.GetLatency(1) ) * 1000 )
            local currentlby = math_Round( ded.GetCurrentLowerBodyYaw( me:EntIndex() ) )
            local targetlby = math_Round( ded.GetTargetLowerBodyYaw( me:EntIndex() ) )

            surface_SimpleText(38,scrh-120,"LC",me.break_lc and blc or lc)
            surface_SimpleText(38,scrh-140,"FT: "..ultimate.fakeLagTicks,ultimate.SendPacket and blc or lc)
            surface_SimpleText(38,scrh-160,math_Round(me:GetVelocity():Length2D()),lc)
            surface_SimpleText(38,scrh-180,"AT: "..latency.." ms",latency > 50 and blc or lc)
            surface_SimpleText(38,scrh-200,"LBY: "..currentlby.." ("..targetlby..")",currentlby != targetlby and blc or lc)

        end
        if ultimate.cfg.vars["Auto Vape"] then
            surface_SimpleText(38,scrh-220,"Vape: ", ultimate.tyaga == 0 and blc or lc)

            surface_SetDrawColor( 0, 0, 0 )
            surface_DrawRect( 78, scrh-219, 60, 14 )

            surface_SetDrawColor( lc )
            surface_DrawRect( 79, scrh-218, ultimate.tyaga / ultimate.maxvape * 58, 12 )
        end




        if ultimate.cfg.vars["Tickbase shift"] and ultimate.cfg.vars["Tickbase indicator"] then
            /*local max, cur = ultimate.cfg.vars["Charge ticks"], ded.GetCurrentCharge()
            local dtw = cur / max * 30

            local x, y = scrwc - 7, scrhc + 10

            surface_SimpleText( x, y, "DT", blc ) //

            render.SetScissorRect( x, y, x + dtw, y + 30, true )
                surface_SimpleText( x, y, "DT", lc )
            render.SetScissorRect( 0, 0, 0, 0, false )*/

            if ded.GetCurrentCharge() <= ultimate.cfg.vars["Shift ticks"] then
                ccharge = ded.GetCurrentCharge() * 196 / ultimate.cfg.vars["Shift ticks"]
            end

            charge = math_Approach(charge,ccharge,FrameTime()*700)

            if ded.GetCurrentCharge() == 0 then
                chargestate = "NO CHARGE"
                chargecolor = unchargedcolor
            elseif ded.GetCurrentCharge() < ultimate.cfg.vars["Shift ticks"] and ultimate.IsKeyDown( ultimate.cfg.binds["Auto recharge"] ) then
                chargestate = "CHARGING"
                chargecolor = unchargedcolor
            else
                chargestate = "READY"
                chargecolor = chargedcolor
            end

            local tw, th = surface_GetTextSize(chargestate)

            surface_SetDrawColor(ultimate.Colors[12])
            surface_DrawRect(indx,indy,200,30)

            surface_SetDrawColor(chargecolor)
            surface_DrawRect(indx+2,indy+2,charge,26)

            surface_SimpleTexturedRect(indx+2,indy+2,charge,26,gradcolor,ultimate.Materials["Gradient right"])

            surface_SimpleText(indx+2,indy-20,"CHARGE "..ded.GetCurrentCharge(),ultimate.Colors[245])
            surface_SimpleText(indx+196-tw,indy-20,chargestate,ultimate.Colors[245])
        end


        local CT = CurTime()
        local FT = FrameTime() * 128

        if ultimate.cfg.vars["Hitmarker"] and #ultimate.hitmarkers > 0 then
            local hm = string_ToColor( ultimate.cfg.colors["Hitmarker"] )

            surface_SetDrawColor( hm )

            for i = #ultimate.hitmarkers, 1, -1  do
                local v = ultimate.hitmarkers[ i ]

                if v.time < CT - 1 then table_remove( ultimate.hitmarkers, i ) continue end

                v.add = math_Approach( v.add, v.add - (CT - 1) * 5, FT )

                surface_DrawLine( scrwc - v.add, scrhc - v.add, scrwc - 10 - v.add, scrhc - 10 - v.add )
                surface_DrawLine( scrwc + v.add, scrhc - v.add, scrwc + 10 + v.add, scrhc - 10 - v.add )
                surface_DrawLine( scrwc - v.add, scrhc + v.add, scrwc - 10 - v.add, scrhc + 10 + v.add )
                surface_DrawLine( scrwc + v.add, scrhc + v.add, scrwc + 10 + v.add, scrhc + 10 + v.add )
            end
        end

        if ultimate.cfg.vars["Hitnumbers"] and #ultimate.hitnums > 0 then
            local n, c = string_ToColor( ultimate.cfg.colors["Hitnumbers"] ), string_ToColor( ultimate.cfg.colors["Hitnumbers krit"] )

            surface_SetFont( "veranda_scr" )

            for i = #ultimate.hitnums, 1, -1 do
                local v = ultimate.hitnums[ i ]

                if v.time < CT - 1 then table_remove( ultimate.hitnums, i ) continue end

                surface_SetTextColor( v.crit and c or n )

                v.add = math_Approach( v.add, v.add - (CT - 1) * 5, FT / 2 )

                surface_SetTextPos( scrwc - v.add * v.xdir, scrhc - v.add * v.ydir )
                surface_DrawText( v.dmg )
            end
        end

        if ultimate.cfg.vars["Fov limit"] and ultimate.cfg.vars["Show FOV"] then
            local col = string_ToColor( ultimate.cfg.colors["Show FOV"] )

            local radius = ultimate.GetFovRadius()

            surface_SetDrawColor( 0, 0, 0, 128 )
            surface.DrawCircle( scrwc, scrhc, radius + 1 )

            surface_SetDrawColor( col.r, col.g, col.b )
            surface.DrawCircle( scrwc, scrhc, radius )

            surface_SetDrawColor( 0, 0, 0, 128 )
            surface.DrawCircle( scrwc, scrhc, radius - 1 )
        end

        if ultimate.target and ultimate.targetVector then
            if ultimate.cfg.vars["Aimbot snapline"] then
                local pos = ultimate.targetVector:ToScreen()
                surface_SetDrawColor( string_ToColor( ultimate.cfg.colors["Aimbot snapline"] ) )
                surface_DrawLine( pos.x, pos.y, scrwc, scrhc )
            end

            if ultimate.cfg.vars["Aimbot marker"] then
                local pos = ultimate.targetVector:ToScreen()

                surface_SetDrawColor( 0, 0, 0 )
                surface_DrawRect( pos.x - 6, pos.y - 6, 5, 3 )
                surface_DrawRect( pos.x + 2, pos.y - 6, 5, 3 )

                surface_DrawRect( pos.x - 6, pos.y + 4, 5, 3 )
                surface_DrawRect( pos.x + 2, pos.y + 4, 5, 3 )

                surface_DrawRect( pos.x - 6, pos.y - 6, 3, 5 )
                surface_DrawRect( pos.x + 4, pos.y - 6, 3, 5 )

                surface_DrawRect( pos.x - 6, pos.y + 2, 3, 5 )
                surface_DrawRect( pos.x + 4, pos.y + 2, 3, 5 )

                surface_SetDrawColor( string_ToColor( ultimate.cfg.colors["Aimbot marker"] ) )

                surface_DrawRect( pos.x - 5, pos.y - 5, 3, 1 )
                surface_DrawRect( pos.x + 3, pos.y - 5, 3, 1 )

                surface_DrawRect( pos.x - 5, pos.y + 5, 3, 1 )
                surface_DrawRect( pos.x + 3, pos.y + 5, 3, 1 )

                surface_DrawRect( pos.x - 5, pos.y - 5, 1, 3 )
                surface_DrawRect( pos.x + 5, pos.y - 5, 1, 3 )

                surface_DrawRect( pos.x - 5, pos.y + 3, 1, 3 )
                surface_DrawRect( pos.x + 5, pos.y + 3, 1, 3 )

            end



            /*local trgv = ultimate.targetVector:ToScreen()

            hook.Add("HUDPaint", "BOX", function()
                if ultimate.cfg.vars["ap_enable"] then
                    local avc = string.ToColor(ultimate.cfg.colors["ap_enable"])
                    if ultimate.target != nil and ultimate.targetVector != nil then
                        if ultimate.cfg.vars["ap_box"] then
                            surface.SetDrawColor(avc)
                            surface.DrawRect(trgv.x-2, trgv.y-2, 4,4)
                        else
                            ultimate.surfaceTexture(trgv.x-8, trgv.y-8, 15,15, "sprites/glow04_noz_gmod",avc)
                        end
                    end
                end
            end)*/

            /*hook.Add("HUDPaint", "kryjok", function()
                if ultimate.cfg.vars["Aimbot_krujok"] then
                    local pos = ultimate.targetVector:ToScreen()

                    local circleRadius = 5
                    local circleColor = string_ToColor(ultimate.cfg.colors["Aimbot_krujok"])

                    surface_SetDrawColor(circleColor)
                    surface.DrawCircle(pos.x, pos.y, circleRadius, circleColor)  -- Draw a circle at the target position
                end
            end)

            hook.Add("HUDPaint", "fillkryg", function()
                if ultimate.cfg.vars["Aimbot_fill"] then
                    local pos = ultimate.targetVector:ToScreen()

                    local circleRadius = 5
                    local circleColor = string_ToColor(ultimate.cfg.colors["Aimbot_fill"])

                    local segments = 360
                    local circle = {}

                    for i = 1, segments do
                        local segment = math.rad(i * 360 / segments)
                        table.insert(circle, {
                            x = pos.x + math.cos(segment) * circleRadius,
                            y = pos.y + math.sin(segment) * circleRadius
                        })
                    end

                    surface_SetDrawColor(circleColor)
                    draw.NoTexture()
                    surface.DrawPoly(circle)
                end
            end)

            hook.Add("HUDPaint", "petyh", function()
                if ultimate.cfg.vars["Aimbot_markers"] then
                    local pos = ultimate.targetVector:ToScreen()

                    --surface.SetDrawColor(0, 0, 0)
                    --surface.DrawRect(pos.x - 10, pos.y - 10, 20, 2) -- Top
                    --surface.DrawRect(pos.x - 10, pos.y + 8, 20, 2) -- Bottom
                    --surface.DrawRect(pos.x - 10, pos.y - 10, 2, 20) -- Left
                    --surface.DrawRect(pos.x + 8, pos.y - 10, 2, 20) -- Right

                    surface_SetDrawColor(string_ToColor(ultimate.cfg.colors["Aimbot_markers"]))
                    surface_DrawRect(pos.x - 5, pos.y - 5, 10, 2) -- Top
                    surface_DrawRect(pos.x - 5, pos.y + 3, 10, 2) -- Bottom
                    surface_DrawRect(pos.x - 5, pos.y - 5, 2, 10) -- Left
                    surface_DrawRect(pos.x + 3, pos.y - 5, 2, 10) -- Right
                end
            end)

            hook.Add("HUDPaint", "swastonch1k", function()
                if ultimate.cfg.vars["Aimbot_swaston"] then
                    local pos = ultimate.targetVector:ToScreen()

                    surface_DrawLine( pos.x - 8, pos.y - 8, pos.x - 2, pos.y - 2 )
                    surface_DrawLine( pos.x - 8, pos.y + 8, pos.x - 2, pos.y + 2 )
                    surface_DrawLine( pos.x + 8, pos.y - 8, pos.x + 2, pos.y - 2 )
                    surface_DrawLine( pos.x + 8, pos.y + 8, pos.x + 2, pos.y + 2 )

                    surface_SetDrawColor( string_ToColor( ultimate.cfg.colors["Aimbot_swaston"] ) )
                    --surface.DrawLine(pos.x - 6, pos.y, pos.x + 6, pos.y)  -- Horizontal line
                    --surface.DrawLine(pos.x, pos.y - 6, pos.x, pos.y + 7)  -- Vertical line
                end
            end)*/

        end

        surface_SetFont( "veranda" )

        if ultimate.cfg.vars[ "On screen logs" ] and table.Count( ultimate.onScreenLogs ) > 0 then
            local tick = engine.TickCount()
            local x, y = scrw / 2, scrh / 2 + 45

            for k, v in pairs( ultimate.onScreenLogs ) do

                if ultimate.TICKS_TO_TIME( tick - ultimate.onScreenLogs[ k ].tick ) > 8 then
                    ultimate.onScreenLogs[ k ] = nil
                    continue
                end

                local data = ultimate.onScreenLogs[ k ]
                local fstr = ""

                for o = 1, #data[ 1 ] do
                    fstr = fstr .. data[ 1 ][ o ]
                end

                local tw, th = surface.GetTextSize( fstr )

                x = x - tw / 2

                for p = 1, #data[ 1 ] do
                    local str = data[ 1 ][ p ]
                    tw, th = surface.GetTextSize( str )

                    surface.SetTextPos( x, y )
                    surface.SetTextColor( data[ 2 ][ p ] )
                    surface.DrawText( str )

                    x = x + tw
                end

                x, y = scrw / 2, y + th
            end
        end

if ultimate.cfg.vars["WaterMark"] then

            surface.SetFont("veranda")

            local txt = "ilyaware.waib.cc | Version: v4"

            local txtsizex, txtsizey = surface.GetTextSize(txt)
            draw.RoundedBox(3, 7, 4, txtsizex+10, txtsizey+3, Color(13, 13, 13,234))
            draw.RoundedBox(3, 7, 4,  txtsizex+10, 3, string.ToColor(ultimate.cfg.colors.WaterMarkColor))
            draw.SimpleText(txt, "veranda", 10, 6, Color(255,255,255))

            
        local plys = player.GetAll()

        if ultimate.cfg.vars[ "Spectator list" ] then
            local y = scrh / 2 

            for i = 1, #plys do
                local v = plys[ i ]

                if not ultimate.playerCache[ v ] then continue end
                if ultimate.playerCache[ v ].ObserverMode == 0 then continue end 

                surface.SetTextPos( 15, y )
                surface.SetTextColor( ultimate.Colors[255] )
                surface.DrawText( v:Name() .. " spectating " .. tostring( ultimate.playerCache[ v ].ObserverTarget ) )
            
                y = y + 15
            end
        end 

        



        
    end






    end



end


        if ultimate.cfg.vars["crosshair"] then
            local centerX = ScrW() / 2
            local centerY = ScrH() / 2
            local crosshairType = ultimate.cfg.vars["crosshair_type"]

            ultimate.RotationAngle = ultimate.RotationAngle or 0
            local scale = ultimate.cfg.vars["uber_alles_scale"]
            local speed = ultimate.cfg.vars["uber_alles_speed"]
            local crosshairColor = string_ToColor(ultimate.Colors["crosshair_color"])
            local outlineColor = string_ToColor(ultimate.Colors["crosshair_outline"])

            local frameTime = FrameTime()
            ultimate.RotationAngle = ultimate.RotationAngle - (frameTime * speed)

            if ultimate.RotationAngle <= -180 then
                ultimate.RotationAngle = ultimate.RotationAngle + 180
            elseif ultimate.RotationAngle >= 180 then
                ultimate.RotationAngle = ultimate.RotationAngle - 180
            end

            if crosshairType == 1 then
                local function DrawCrosshairLine(red, x, y)
                if red == 0 then
                    surface.SetDrawColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
                else
                    surface.SetDrawColor(crosshairColor.r, crosshairColor.g, crosshairColor.b, crosshairColor.a)
                end

                local points = {}
                local angle1_rad = math.rad(ultimate.RotationAngle - 90)
                points[1] = math.floor(scale * math.sin(angle1_rad))
                points[2] = math.floor(scale * math.cos(angle1_rad))
                points[3] = math.floor(scale * math.cos(angle1_rad + 1))

                local angle2_rad = math.rad(ultimate.RotationAngle)
                points[4] = math.floor(scale * math.sin(angle2_rad))
                points[5] = math.floor(scale * math.cos(angle2_rad))
                points[6] = math.floor(scale * math.sin(angle2_rad + 1))

                local angle3_rad = math.rad(ultimate.RotationAngle + 90)
                points[7] = math.floor(scale * math.sin(angle3_rad))
                points[8] = math.floor(scale * math.cos(angle3_rad))
                points[9] = math.floor(scale * math.cos(angle3_rad + 1))

                local angle4_rad = math.rad(ultimate.RotationAngle + 180)
                points[10] = math.floor(scale * math.sin(angle4_rad))
                points[11] = math.floor(scale * math.cos(angle4_rad))
                points[12] = math.floor(scale * math.sin(angle4_rad + 1))

                surface.DrawLine(x, y, x + points[1], y - points[2])
                surface.DrawLine(x + points[1], y - points[2], x + points[1], y - points[3])
                surface.DrawLine(x, y, x + points[4], y - points[5])
                surface.DrawLine(x + points[4], y - points[5], x + points[6], y - points[5])
                surface.DrawLine(x, y, x + points[7], y - points[8])
                surface.DrawLine(x + points[7], y - points[8], x + points[7], y - points[9])
                surface.DrawLine(x, y, x + points[10], y - points[11])
                surface.DrawLine(x + points[10], y - points[11], x + points[12], y - points[11])
                end

                local screenWidth = centerX
                local screenHeight = centerY
                DrawCrosshairLine(0, screenWidth - 1, screenHeight)
                DrawCrosshairLine(0, screenWidth, screenHeight - 1)
                DrawCrosshairLine(0, screenWidth + 1, screenHeight)
                DrawCrosshairLine(0, screenWidth, screenHeight + 1)
                DrawCrosshairLine(0, screenWidth - 1, screenHeight - 1)
                DrawCrosshairLine(0, screenWidth + 1, screenHeight - 1)
                DrawCrosshairLine(0, screenWidth - 1, screenHeight + 1)
                DrawCrosshairLine(0, screenWidth + 1, screenHeight + 1)
                DrawCrosshairLine(255, screenWidth, screenHeight)

            elseif crosshairType == 2 then
                local function DrawCircle(x, y, radius, segments, color)
                    surface.SetDrawColor(color.r, color.g, color.b, color.a)
                    for i = 0, segments - 1 do
                        local angle1 = (i / segments) * 2 * math.pi
                        local angle2 = ((i + 1) / segments) * 2 * math.pi
                        local x1 = x + radius * math.cos(angle1)
                        local y1 = y + radius * math.sin(angle1)
                        local x2 = x + radius * math.cos(angle2)
                        local y2 = y + radius * math.sin(angle2)
                        surface.DrawLine(x1, y1, x2, y2)
                    end
                end

                local circleRadius = math.max(3, scale / 4)
                local orbitRadius = scale
                local numCircles = 20

                for i = 0, numCircles - 1 do
                    local angle = ultimate.RotationAngle + (i * 360 / numCircles)
                    local angleRad = math.rad(angle)

                    local circleX = centerX + orbitRadius * math.cos(angleRad)
                    local circleY = centerY + orbitRadius * math.sin(angleRad)

                    DrawCircle(circleX, circleY, circleRadius + 1, 12, outlineColor)
                    DrawCircle(circleX, circleY, circleRadius, 12, crosshairColor)
                end
            end
        end





/*
hook.Add( "PostDrawTranslucentRenderables", "test", function()
    if ultimate.targetVector then
        render.DrawWireframeSphere( ultimate.targetVector, 0.5, 10, 10, Color( 255, 0, 64 ) )
    end
end)
*/


ultimate.kd = false
function ultimate.togglevisible()
    if ultimate.frame:IsVisible() then
        ultimate.frame:SetVisible(false)

        if ultimate.ui.MultiComboP then ultimate.ui.RemovePanel( ultimate.ui.MultiComboP ) end
        if ultimate.ui.ColorWindow then ultimate.ui.RemovePanel( ultimate.ui.ColorWindow ) end
        if ultimate.ui.SettingsPan then ultimate.ui.RemovePanel( ultimate.ui.SettingsPan ) end

        RememberCursorPosition()

        if ultimate.validsnd then ultimate.validsnd:Pause() end
    else
        ultimate.frame:SetVisible(true)

        RestoreCursorPosition()
        if ultimate.validsnd then ultimate.validsnd:Play() end
    end
end

// dormant esp

function ultimate.SetEntPos(ent,pos)
    if not IsValid(ent) or ent == me or not ent:IsDormant() then return end

    ent:SetNetworkOrigin(pos)
    ent:SetRenderOrigin(pos)
end



--[[]


function ultimate.SetEntPos(ent,pos)
    if not IsValid(ent) or ent == me or not ent:IsDormant() then return end

    ent:SetNetworkOrigin(pos)
    ent:SetRenderOrigin(pos)
end

hook.Add( "EntityEmitSound", "EntSounds", function( data )
    local ent = data.Entity
    local pos = data.Pos

    if ent:IsPlayer() and ent:Alive() and ent:IsDormant() then
        ultimate.SetEntPos(ent,pos)
        print(ent,pos)
    elseif ent:IsWeapon() then
        print(ent)
    end
end)

hook.Add( "PlayerStepSoundTime", "StepSounds", function( ent, type, walking )
    local pos = ent:GetPos()

    if ent:Alive() and ent:IsDormant() then
        ultimate.SetEntPos(ent,pos)
        print("steps ",ent,pos)
    end
end)
]]




hook.Add("PrePlayerDraw", "ultimate.PrePlayerDraw", function(ply, falgs)
	if ply != me then
        ply.ChatGestureWeight = 0
		for i = 0, 13 do
			if ply:IsValidLayer(i) then
				local seqname = ply:GetSequenceName(ply:GetLayerSequence(i))
				if seqname:StartWith("taunt_") or seqname:StartWith("act_") or seqname:StartWith("gesture_") then
                    ply:SetLayerDuration(i, 0.001)
					break
				end
			end
		end

    /*
	elseif ply == me then
        local ndata = ultimate.GetLocalNetworkData()
        //local ntang = Angle( 0, ndata.angles_y, 0 )

        //ply:SetPoseParameter("aim_yaw", ndata.angles_y)
        //ply:SetPoseParameter("head_yaw", ndata.angles_y)

        //ply:SetPoseParameter("aim_pitch", ndata.angles_x)
        //ply:SetPoseParameter("head_pitch", ndata.angles_x)

        //ply:InvalidateBoneCache()
        //ply:SetupBones()

        ply:SetNetworkOrigin( ndata.origin )
        ply:SetRenderOrigin( ndata.origin )




*/





    end

    if ultimate.cfg.vars["Visible chams"] then
        //ply:SetNoDraw( true )
    end
end)


// Chams

CreateMaterial("textured", "VertexLitGeneric")
CreateMaterial("flat", "UnLitGeneric")
CreateMaterial("flat_z", "UnLitGeneric",{["$ignorez"] = 1})
CreateMaterial("textured_z", "VertexLitGeneric",{["$ignorez"] = 1})

CreateMaterial( "selfillum", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "0",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0.0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
} )

CreateMaterial( "selfillum_z", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "0",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0.0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
    ["$ignorez"] = 1,
} )

CreateMaterial( "selfillum_a", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "1",
    ["$nodecal"] = "1",
    ["$additive"] = "1",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0.0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
} )

CreateMaterial( "selfillum_a_z", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "1",
    ["$nodecal"] = "1",
    ["$additive"] = "1",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0.0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
    ["$ignorez"] = 1,
} )

CreateMaterial("wireframe", "VertexLitGeneric", {
	["$wireframe"] = 1,
})
CreateMaterial("wireframe_z", "VertexLitGeneric", {
	["$wireframe"] = 1,
    ["$ignorez"] = 1,
})

CreateMaterial("metallic", "VertexLitGeneric", {
	["$envmap"] = "env_cubemap",
    ["$envmaptint"] = "[ 0 1 1 ]",
    ["$envmapfresnel"] = "1",
    ["$alpha"] = "0.5",
})

CreateMaterial("metallic_z", "VertexLitGeneric", {
    ["$envmap"] = "env_cubemap",
    ["$envmaptint"] = "[ 0 1 1 ]",
    ["$envmapfresnel"] = "1",
    ["$alpha"] = "0.5",
    ["$ignorez"] = 1,
})

ultimate.chamMats = {
    vis = {
        Material("!flat"), -- flat
        Material("!textured"), -- textured
        Material("!selfillum"), -- glow
        Material("!selfillum_a"), -- glow outline
        Material("!wireframe"), -- wireframe
        Material("!metallic"), -- metallic
        Material("effects/nightvision"), -- _rt_fullframefb
        Material("effects/flashbang"), -- _rt_fullframefb
        Material("models/props_combine/portalball001_sheet"),
    },
    invis = {
        Material("!flat_z"), -- flat
        Material("!textured_z"), -- textured
        Material("!selfillum_z"), -- glow
        Material("!selfillum_a_z"), -- glow outline
        Material("!wireframe_z"), -- wireframe
        Material("!metallic_z"), -- metallic
        Material("effects/nightvision"), -- _rt_fullframefb
        Material("effects/flashbang"), -- _rt_fullframefb
        Material("models/props_combine/portalball001_sheet_z"),
    }
}

do
    local f = (1/255)

    function ultimate.drawChams()
        if ultimate.UnSafeFrame then return end

        if ultimate.cfg.vars["Color_Modify"] then
            local rse = {
                [ "$pp_colour_addr" ] = ultimate.cfg.vars["pp_colour_addr"],
                [ "$pp_colour_addg" ] = ultimate.cfg.vars["pp_colour_addg"],
                [ "$pp_colour_addb" ] = ultimate.cfg.vars["pp_colour_addb"],
                [ "$pp_colour_brightness" ] = ultimate.cfg.vars["pp_colour_brightness"],
                [ "$pp_colour_contrast" ] = ultimate.cfg.vars["pp_colour_contrast"],
                [ "$pp_colour_colour" ] = ultimate.cfg.vars["pp_colour_colour"],
                [ "$pp_colour_mulr" ] = ultimate.cfg.vars["pp_colour_mulr"],
                [ "$pp_colour_mulg" ] = ultimate.cfg.vars["pp_colour_mulg"],
                [ "$pp_colour_mulb" ] = ultimate.cfg.vars["pp_colour_mulb"]
            }
            DrawColorModify( rse )
        end

        if ultimate.cfg.vars["motion_blur"] then
            DrawMotionBlur( ultimate.cfg.vars[ "mb_aa" ], ultimate.cfg.vars[ "mb_da" ],  ultimate.cfg.vars[ "mb_d" ])
        end


        local vm, invm = ultimate.cfg.vars["Visible mat"], ultimate.cfg.vars["inVisible mat"]
        local sin = math_floor( math_sin( CurTime() * 4 ) * 45 )

        local vc = string_ToColor(ultimate.cfg.colors["Visible chams"])
        local invc = string_ToColor(ultimate.cfg.colors["inVisible chams"])
        local sc = string_ToColor(ultimate.cfg.colors["Self chams"])

        cam_Start3D()
            for k, v in pairs(player_GetAll()) do
                if not IsValid(v) or v == me or not v:Alive() or v:IsDormant() then continue end

                if ultimate.cfg.vars["Supress lighting"] then
                    render_SuppressEngineLighting(true)
                end

                if ultimate.cfg.vars["inVisible chams"] then
                    ultimate.chamMats.invis[6]:SetVector( "$envmaptint", Vector( invc.r / 255, invc.g / 255, invc.b / 255 ) )
                    render_MaterialOverride(ultimate.chamMats.invis[invm])
                    render_SetColorModulation(invc.r/255,invc.g/255,invc.b/255)

                    if invm == 7 then
                        render_SetBlend( (sin + 100) / 255 )
                    end

                    v:SetRenderMode(1)
                    v:DrawModel()

                    if ultimate.cfg.vars["inVisible chams w"] then
                        local w = v:GetActiveWeapon()
                        if IsValid(w) then w:DrawModel() end
                    end
                end

                if ultimate.cfg.vars["Visible chams"] then
                    ultimate.chamMats.vis[6]:SetVector( "$envmaptint", Vector( vc.r / 255, vc.g / 255, vc.b / 255 ) )
                    render_MaterialOverride(ultimate.chamMats.vis[vm])
                    render_SetColorModulation(vc.r/255,vc.g/255,vc.b/255)

                    if vm == 7 then
                        render_SetBlend( (sin + 100) / 255 )
                    end

                    v:DrawModel()

                    if ultimate.cfg.vars["Visible chams w"] then
                        local w = v:GetActiveWeapon()
                        if IsValid(w) then w:DrawModel() end
                    end
                end

                if ultimate.cfg.vars["Supress lighting"] then
                    render_SuppressEngineLighting(false)
                end

            end

            if ultimate.cfg.vars["Self chams"] and IsValid(me) and me:Alive() then

                if ultimate.cfg.vars["Supress self lighting"] then
                    render_SuppressEngineLighting(true)
                end

                ultimate.chamMats.invis[6]:SetVector( "$envmaptint", Vector( sc.r / 255, sc.g / 255, sc.b / 255 ) )
                render_MaterialOverride(ultimate.chamMats.vis[ultimate.cfg.vars["Self mat"]])
                render_SetColorModulation(sc.r/255,sc.g/255,sc.b/255)

                if ultimate.cfg.vars["Self mat"] == 7 then
                    render_SetBlend( (sin + 100) / 255 )
                end

                me:SetRenderMode(1)
                me:DrawModel()

                if ultimate.cfg.vars["Self chams w"] then
                    local w = me:GetActiveWeapon()
                    if IsValid(w) then w:DrawModel() end
                end

                if ultimate.cfg.vars["Supress self lighting"] then
                    render_SuppressEngineLighting(false)
                end

            end




        cam_End3D()

        render_SetColorModulation(1, 1, 1)
        render_SetBlend(1)
        render_MaterialOverride()
    end
end

ultimate.rukient = me
hook.Add("PreDrawPlayerHands", "ChamsHand", function(hands,vm,ply,wep)

    local col = string_ToColor(ultimate.cfg.colors["chams_hand"])
    ultimate.chamMats.vis[6]:SetVector( "$envmaptint", Vector( col.r / 255, col.g / 255, col.b / 255 ) )
    local mat = ultimate.chamMats.vis[ultimate.cfg.vars["chams_hand_mat"]]
    if ultimate.cfg.vars["chams_hand"] then
        render_SetBlend(col.a/255)
        render_SetColorModulation(col.r/255,col.g/255,col.b/255)
        render_MaterialOverride(mat)
    end

end)
hook.Add("PostDrawPlayerHands", "ChamsHandBlend", function(hands,vm,ply,wep)
    --print(vm,hands)
    if ultimate.cfg.vars["chams_hand"] then
        render_SetBlend(1)
        render_SetColorModulation(1, 1, 1)
        render_MaterialOverride(Material(""))

    end
    ultimate.rukient = vm
end)

// Client side models

function ultimate.CS_Model(mdl)
    local model = ClientsideModel(mdl)
	model:SetNoDraw(true)

    return model
end

function ultimate.CS_Model_update(ply,model,tbl)
    if !tbl then return end

    local mdl = model
    local playerModel = ply:GetModel()
    local layers = tbl.layers

    for i = 0, 13 do
        if mdl:IsValidLayer(i) then
            local l = layers[i]
            mdl:SetLayerCycle(l.cycle)
            mdl:SetLayerSequence(l.sequence)
            mdl:SetLayerWeight(l.weight)
        end
    end

    mdl:SetSequence(tbl.sequence)
    mdl:SetCycle(tbl.cycle)

    mdl:SetPoseParameter("aim_pitch", tbl.angles.p)
	mdl:SetPoseParameter("head_pitch", 0)
	mdl:SetPoseParameter("body_yaw", tbl.angles.y)
	mdl:SetPoseParameter("aim_yaw", 0)

	mdl:SetPoseParameter("move_x", tbl.movex)
	mdl:SetPoseParameter("move_y", tbl.movey)

    mdl:SetAngles( Angle( 0, tbl.angles.y, 0 ) )
    mdl:SetModel( playerModel )
	mdl:SetPos( tbl.origin )
end

function ultimate.PostDrawTranslucentRenderables()
    if ultimate.UnSafeFrame then return end

    ultimate.drawCSModels_backtrack()
    ultimate.drawCSModels_real()

    render_SetBlend(1)
    render_MaterialOverride()
end


// Backtracking

ultimate.btrecords = {}
ultimate.predicted = {}

















function ultimate.canBacktrack(ply)
    if not ultimate.cfg.vars["Backtrack"] then return false end
    if not IsValid(ply) then return false end
    if not ultimate.btrecords[ply] then return false end
    if ply.break_lc then return false end

    return true
end

function ultimate.recordBacktrack(ply)
	local deadtime = CurTime() - ultimate.cfg.vars["Backtrack time"] / 1000

	local records = ultimate.btrecords[ply]

	if !records then
        records = {}
		ultimate.btrecords[ply] = records
	end

	local i = 1
	while i < #records do
		local record = records[i]

		if record.simulationtime < deadtime then
			table_remove(records, i)
			i = i - 1
		end

		i = i + 1
	end

	if !ply:Alive() then return end
    if ply.break_lc then return end

	local simulationtime = ded.GetSimulationTime(ply:EntIndex())
	local len = #records
	local simtimechanged = true

	if len > 0 then
		simtimechanged = records[len].simulationtime < simulationtime
	end

	if !simtimechanged then return end

	local layers = {}
	for i = 0, 13 do
		if ply:IsValidLayer(i) then
			layers[i] = {
				cycle = ply:GetLayerCycle(i),
				sequence = ply:GetLayerSequence(i),
				weight = ply:GetLayerWeight(i)
			}
		end
	end

    local eyeAngles = ply:EyeAngles()
    local x,y = eyeAngles.x, eyeAngles.y

    local bdata = {}
    for i = 0, ply:GetBoneCount() - 1 do
        local v, a = ply:GetBonePosition( i )
        bdata[i] = { vec = v, ang = a }
    end

    local hdata = {}
    local hset = ply:GetHitboxSet()
    local hnum = ply:GetHitBoxCount( hset )

    for hitbox = 0, hnum - 1 do
        local bone = ply:GetHitBoxBone( hitbox, hset )

        if bone == nil then continue end

        local mins, maxs = ply:GetHitBoxBounds( bone, hset )

        if not mins or not maxs then continue end

        local bonepos, ang = ply:GetBonePosition( bone )
        mins:Rotate( ang )
        maxs:Rotate( ang )

        hdata[ #hdata + 1 ] = { pos = bonepos, mins = mins, maxs = maxs }
    end

    local skeletondata = {}

    /*
    for i = 0, ply:GetBoneCount() - 1 do

        local parent = ply:GetBoneParent(i)

        if(!parent) then continue end

        local bonepos = ply:GetBonePosition(i)

        if(bonepos == ply:GetPos() ) then continue end

        local parentpos = ply:GetBonePosition(parent)

        if(!bonepos or !parentpos) then continue end

        skeletondata[ 1 ] = bonepos:ToScreen()
        skeletondata[ 2 ] = parentpos:ToScreen()
    end
    */

	records[len + 1] = {
		simulationtime =    ded.GetSimulationTime(ply:EntIndex()),
		angles =            Angle(x,y,0),
		origin =            ply:GetNetworkOrigin(),
		aimpos =            ultimate.GetBones( ply )[1],
		sequence =          ply:GetSequence(),
		cycle =             ply:GetCycle(),
		layers =            layers,
        movex =             ply:GetPoseParameter("move_x"),
        movey =             ply:GetPoseParameter("move_y"),
        bonedata =          bdata,
        //hitboxdata =        hdata,
        //skeleton =          skeletondata
    }
end

ultimate.btmodel = ultimate.CS_Model("models/player/kleiner.mdl")

function ultimate.drawCSModels_backtrack()
    if not ultimate.cfg.vars["Backtrack chams"] then return end
    if not ultimate.canBacktrack(ultimate.target) then return end

    local len = #ultimate.btrecords[ultimate.target]
    local tbl = ultimate.btrecords[ultimate.target][ultimate.backtracktick]
    local m = ultimate.btmodel

    ultimate.CS_Model_update(ultimate.target,m,tbl)

    if ultimate.cfg.vars["Backtrack fullbright"] then
        render_SuppressEngineLighting(true)
    end

    local col = string_ToColor(ultimate.cfg.colors["Backtrack chams"])
    ultimate.chamMats.invis[6]:SetVector( "$envmaptint", Vector( col.r / 255, col.g / 255, col.b / 255 ) )
    render_MaterialOverride(ultimate.chamMats.invis[ultimate.cfg.vars["Backtrack material"]])
    render_SetColorModulation(col.r/255,col.g/255,col.b/255)
    m:SetRenderMode(1)
    m:DrawModel()

    if ultimate.cfg.vars["Backtrack fullbright"] then
        render_SuppressEngineLighting(false)
    end
end

ultimate.hitmarkers = {}
ultimate.hitnums = {}

gameevent.Listen( "player_hurt" )
hook_Add("player_hurt", "penissss1337", function(data)
    local health = data.health
	local priority = SERVER and data.Priority or 5
	local hurted = Player( data.userid )
	local attackerid = data.attacker

	if attackerid == me:UserID() then

        if ultimate.cfg.vars[ "On screen logs" ] then
            local hlcolor = string_ToColor( ultimate.cfg.colors[ "On screen logs" ] )
            local data = {
                tick = engine.TickCount(),
                {
                    "Hit ",
                    hurted:Name(),
                    " for ",
                    hurted:Health() - health,
                    " damage"
                },
                {
                    ultimate.HitLogsWhite,
                    hlcolor,
                    ultimate.HitLogsWhite,
                    hlcolor,
                    ultimate.HitLogsWhite,
                }
            }

            ultimate.onScreenLogs[ engine.TickCount() ] = data
            print( "hurt", engine.TickCount() )
        end

        if ultimate.cfg.vars["Hitmarker"] then
            ultimate.hitmarkers[ #ultimate.hitmarkers + 1 ] = { time = CurTime(), add = 0 }
        end

        if ultimate.cfg.vars["Hitnumbers"] then
            local hp = hurted:Health() - health
            ultimate.hitnums[ #ultimate.hitnums + 1 ] = { time = CurTime(), add = 0, xdir = math_random(-1,1), ydir = math_random(-1,1), dmg = hp, crit = health <= 0 }
        end

        if ultimate.cfg.vars["Hitsound"] then
            surface_PlaySound( ultimate.cfg.vars["Hitsound str"] )
        end

        if ultimate.cfg.vars["Resolver"] then
            hurted.aimshots = (hurted.aimshots or 0) - 1
        end

    end
end)

/*
    Player vars
*/

function ultimate.initPlayerVars( v )
    v.ult_prev_pos = Vector()

    v.ult_prev_simtime = 0
    v.flticks = 0
    v.aimshots = 0
    v.missedanimticks = 0

    v.break_lc = false
    v.simtime_updated = false
    v.fakepitch = false

    ultimate.btrecords[ v ] = {}
    ultimate.predicted[ v ] = {}
end

for k, v in ipairs(player_GetAll()) do
	ultimate.initPlayerVars( v )
end

ultimate.chatmsg = {
    killsay = {
        { // Лучшие 22-23
        "чел у тебя каждый патрон в голову летит",
        "чел с аимом играет",
        "чел ты деб",
        "моя мама в больнице",
        "эхх",
        "жалко тебя",
        "Чел мне жаль но твоя мать еще жива",
        "ребята давайте друг другу помогать, давайте???",
        "(((((",
        "ураа победа",
        "я твой на могилу жидиньким насрал её аж затапило",
        "пасть захлопни результат порватово презека",
        "узбек",
        "а я девочка",
        "скин девкив",
        "что делать если парвалзя презек??",
        "ахахах",
        "ДА ТЫ ЗАДОЛБАЛ",
        "ТЕБЯ ЗАБАНЯТ НА ДОЛГО",
        "да пожалуй нек сахраню",
        "da bla che c pb",
        "если у них скрипт они не получал бан",
        "ахапхап",
        "Чел в бан летиш",
        "мои мозги меньше моеи груди",
        "не наступи мне на тяги",
        "гучи тяги",
        "Смешной Шрек2014",
        "Хуйв омне",
        "дегустатар",
        "сheting",
        "Откисай молодой!",
        "че твоя мама по дому голая бегает исправляй",
        "в школу собирайся сосунок",
        "ботинок ебаный чо слетел",
        "чё упал нищие",
        "не противник",
        "а ты че клоун???",
        "я обоссал тебя (",
        "ты че там отлетел то?",
        "XD",
        "упал хуета ебаная типа -  no resolver",
        "ливай с хвх (",
        "до связи башмак",
        "сынтупой дуры играть учись",
        "опущен сын твари",
        "нищий улетел",
        "пофикси нищ",
        "где же твой резольвер",
        "животное выйди с игры а то падаешь",
        "твой сиська бы вжик вжик дура",
        "сука не позорься и ливни",
        "улетел тапочек ебаный",
        "единицей свалился сын аборта",
        "Вот тебе паяльник , запаяй себе ебальник",
        "зачем ты играешь тут безмозглый", "иди в школу собирайся очередняра",
        "свежий кабанчик",
        "ты на подскоке пёсик гав",
        "скажи маме чтоб голая не бегала",
        "ахуеть ты красиво на бутылку присел)))",
        "Извини дорогая , не хотел на лицо",
        "прости что без смазки)",
        "алло это скорая? тут такая ситуация парню который упал нужна скорая)",
        "ало ты мапу лузаешь , дура очнись",
        "аниме ублюдок про тебя же?)?",
        "але , а противники то где???",
        "ты с цфф зашёл ?",
        "ХУЕПРЫГАЛО УНИЖЕНОЕ КУДА ПОЛЕТЕЛО",
        "ты куда жертва козьего аборта",
        "iq?", "x_x 3", "щас я тебя разьебу лошок ебаны",
        "ты то куда лезешь сын фантомного стационарного спец изолированого металлформовочного механизма",
        "а где противник одни боты",
        "Тебе в ротик или на животик ?",
        "Ушка, лапки, хвостик 03 Бурятия",
        "٠●•۩۞۩[̲̲̅И̲̅Д̲̅И̲̲̅(ٿ)̲̅H̲̅A̲̅X̲̅У̲̅Й̲̲̅]۩۞۩•●٠",
        },
        { // Унижалка English
        "man, every bullet goes to your head",
        "a man plays with aim",
        "man you Deb",
        "my mother is in the hospital",
        "ehh",
        "I feel sorry for you",
        "Man, I'm sorry, but your mother's still alive.",
        "guys, let's help each other, let's???",
        "(((((",
        "uraa Pobeda",
        "I took a shit on your Jewish grave and it was already flooded",
        "close your mouth and tear up the prezek",
        "Uzbek",
        "and I'm a girl",
        "skin of girls",
        "what should I do if parvalzya prezek??",
        "ahahah",
        "YOU'RE FUCKED UP.",
        "YOU WILL BE BANNED FOR A LONG TIME",
        "yes, apparently Nek sakhranyu",
        "da bla che c pb",
        "if they have a script they didn't get banned",
        "ahaphap",
        "People in the ban fly",
        "my brain is smaller than my chest",
        "don't step on my traction",
        "Gucci traction",
        "Funny Shrek2014",
        "Fuck Omne",
        "taster",
        "cheting",
        "Otkissay young!",
        "Che your mother runs around the house naked fix it",
        "get ready for school, sucker",
        "Cho's fucking shoe flew off",
        "Che fell beggars",
        "not the enemy",
        "are you a clown???",
        "I pissed you (",
        "why did you fly there?",
        "XD",
        "fallen fuck type- no resolver",
        "Levi with khvh",
        "to the connection of shoes",
        "sintupoy fools learn to play",
        "the fallen son of a creature",
        "the beggar flew away",
        "pofixi nishch",
        "where is your resolver",
        "animal get out of the game otherwise you fall",
        "your boob would whack whack Fool",
        "Bitch Don't shame and take a shower",
        "the fucking Slipper flew away",
        "the son of abortion collapsed as a unit",
        "Here's a soldering iron for you, solder your fucker",
        "why are you playing",
        },
        { // Школа хвх
            "хуевый ресолвер",
            "хуевые фейклаги",
            "хуевый антиаим",
            "хуевый спинбот",
            "хуевый бхоп",
            "хуевый аим",
            "найс паста аимвара",
            "найс паста мемевара",
            "неужели это идиотбокс???",
            "ого идиотбокс???",
            "неужели это аосхак???",
            "ого аосхак???",
            "неужели это ехек хак???",
            "ого ехек хак???",
            "что за ебанутый у тебя чит?",
            "ez",
            "ezz",
            "изи",
            "ииииииизи",
            "упал",
            "спи",
            "отдыхай",
            "отлетел дебил)",
            "упал пастер",
            "пастер лег",
            "изи даун",
            "ору отлетела дура",
            "найс ресолвер стен",
            "найс ресолвер деревьев",
            "бро имажин ресолвинг ин гмод",
            "улетел фанат артемкинга4",
            "упал фанат артемкинга4",
            "ты куда стреляешь)))",
            "упал ннчик без самоваре",
            "умер ннчик без самоваре",
            "отдыхай ннчик без самоваре",
            "упал подписчик урбанички",
            "умер подписчик урбанички",
            "отдыхай подписчик урбанички",
            "енжинпред где???",
            "антиаим где???",
            "фейклаги где???",
            "антиаим не спас",
            "фейклаги не спасли",
            "даун с пастой отлетел",
            "упал баимер ебаный",
            "отлетел ебаный баимер))",
            "охуеть даун с пастой аимвара",
            "упал дебил",
            "выйди не позорься",
            "найс брейн иссуе",
            "найс кфг иссуе",
            "сука не позорься и ливни лол",
            "*DEAD* пофикси нищ",
            "нищий улетел",
            "набутылирован лол",
            "ебать ты красиво на бутылку упал",
            "хуя тебя опустили))",
            "прости что без смазки)",
            "обоссан",
            "обоссал юзера пасты аимвара",
            "алло это скорая? тут такая ситуация нищ упал)))",
            "на завод иди",
            "ебать тебя унесло",
            "ой нищий упал щас скорую вызовем",
            "научи потом как так сосать на хвх",
            "нихуя ты там как самолет отлетел",

            -- Vovse ne sp1zd1l
            "Найс софт чел без читов ты 0",
            "Чел ты без читов 0",
            "Го 1 на 1 или зассал?Точно ты же до 1 считать не умееш...",
            "Мы в НОНРП Зоне как бы да чел отлетаеш",
            "Найс баг абуз чел папа жива?",
            "Ало скорая тут такой случай шкiла упала в месорубку",
            "Откисай молодой!",
            "говори буду плохо говорить буду сосать, буду плохо сосать буду пересасывать",
            "долбаеб иди башмачки в сундучок школьный собирай",
            "ботинок ебаный чо слетел",
            "братик маме привет передай",
            "не противник",
            "а ты че клоун???",
            "я обоссал тебя (",
            "ты че там отлетел то?",
            "Я твою маму дуже сильно поважаю , нехай береже її Степан Бендера",
            "упал хуета ебаная , но в боди забрал да похуй все равно упал",
            "ливай с хвх (",
            "до связи башмак",
            "нищета глупейшая играть учись",
            "опущен сын твари",
            "сразу видно кфг иссуе мб конфиг у меня прикупишь ?",
            "животное аддон скачай а то падаешь",
            "оттарабанен армянская королева",
            "сука не позорься и ливни",
            "улетел тапочек ебаный",
            "единицей свалился фуфлыжник",
            "Вот тебе паяльник , запаяй себе ебальник",
            "зачем ты играешь тут безмозглый", "иди кумыса попей очередняра",
            "Ты как кофе , 3 в одном - пидр , чмошник и гандон",
            "откисай сочняра",
            "АХАХА ЕБАТЬ У ТЕБЯ ЧЕРЕПНАЯ КОРОБКА ПРЯМ КАК [XML-RPC] No-Spread 24/7 | aim_ag_texture_2 ONLY!",
            "на мыло и веревку то деньги есть????",
            "ИЩИ СЕБЯ НА pornoeb.cc/so4niki",
            "свежий кабанчик",
            "до связи на подскоке кабанчик",
            "скажи маме сухарики купить долбаеб",
            "ебать ты красиво на бутылку присел , тебе дать альт ?",
            "Извини дорогая , не хотел на лицо",
            "прости что без смазки)",
            "алло это скорая? тут такая ситуация парню который упал нужна скорая)",
            "ало ты мапу лузаешь , дура очнись",
            "ЕБУЧЕСТЬ ВТОРОГО РАЗРЯДА ВЫДВИЖЕНЕЦ ОТКИС",
            "але , а противники то где???",
            "ты по легиту играешь ?",
            "ХУЕПРЫГАЛО ТУСОВОЧНОЕ КУДА ПОЛЕТЕЛО",
            "ты куда жертва козьего аборта",
            "iq?", "·٠●•۩۞۩ОтДыХаЙ (ٿ) НуБяРа۩۞۩•●٠·",
            "ты то куда лезешь сын фантомного стационарного спец изолированого металлформовочного механизма",
            "╭∩╮( ⚆ ʖ ⚆)╭∩╮ ДоПрыГался(ت)ДрУжоЧеК",
            "Тебе в ротик или на животик ?"
        },
        { // AI унижалка
        "чол у тебе кожен патрон в голову летить",
        "чол з аімом грає",
        "чол ти деб",
        "моя мама в лікарні",
        "ехх",
        "шкода тебе",
        "Чол мені шкода але твоя мати ще жива",
        "хлопці давайте один одному допомагати, давайте???",
        "(((((",
        "ураа перемога",
        "я Твій на могилу жидиньким насрав її аж затапило",
        "паща зачини результат порватово презека",
        "узбек",
        "а я дівчинка",
        "скін девків",
        "що робити якщо парвалзя презек??",
        "ахахах",
        "ТА ТИ ЗАДОВБАВ",
        "ТЕБЕ ЗАБАНЯТЬ НА ДОВГО",
        "та мабуть нек сахраню",
        "da bla che c pb",
        "якщо у них скрипт вони не отримував бан",
        "ахапхап",
        "Чол в бан летиш",
        "мої мізки менше моеі грудей",
        "не наступай мені на тяги",
        "гучі тяги",
        "Смішний Шрек2014",
        "Хуйв омне",
        "дегустатар",
        "сheting",
        "Откісай молодий!",
        "че твоя мама по дому Гола бігає виправляй",
        "в школу збирайся сосунок",
        "черевик йобаний чо злетів",
        "че впав жебраки",
        "не противник",
        "а ти че клоун???",
        "я обоссал тебе (",
        "ти че там відлетів то?",
        "XD",
        "впав хуета ебаная типу- no resolver",
        "Лівай з хвх (",
        "до зв'язку черевик",
        "синтупой дурепи грати вчися",
        "опущений син тварі",
        "жебрак полетів",
        "пофікси нищ",
        "де ж твій резольвер",
        "тварина вийди з гри а то падаєш",
        "твій сиська б вжик вжик дура",
        "сука не ганьбіть і зливи",
        "полетів тапочок йобаний",
        "одиницею звалився син аборту",
        "Ось тобі паяльник, запаяй собі ебальнік",
        "навіщо ти граєш",
        "Іди в школу збирайся очередняра",
        "свіжий кабанчик",
        "ти на підскоку песик гав",
        "скажи мамі щоб Гола не бігала",
        "ахуеть ти красиво на пляшку присів)))",
        "Вибач дорога, не хотів на обличчя",
        "прости що без мастила)",
        "алло це швидка? тут така ситуація хлопцю який впав потрібна швидка)",
        "ало ти мапу лузаєш, дура Прокинься",
        "Аніме ублюдок про тебе ж?)?",
        "але, а противники то де???",
        "ти з цфф зайшов ?",
        "ХУЕПРИГАЛО ПРИНИЖЕНЕ КУДИ ПОЛЕТІЛО",
        "ти куди жертва козячого аборту",
        "iq?", "x_x 3",
        "ти то куди лізеш син фантомного стаціонарного спец ізольованого металлформовочного механізму",
        "а де противник одні боти",
        "Тобі в ротик або на животик ?",
        },
        { // School HVH
            "sick resolver",
            "sick fakelag",
            "sick antiaim",
            "sick aimbot",
            "sick bhop",
            "sick spinbot",
            "nice aimware paste",
            "nice memeware paste",
            "what the fuck are you using lol",
            "sick cfg",
            "it must be a cfg issue, right?",
            "it must be a brain issue",
            "fix your *DEAD*",
            "BRUH",
            "ez",
            "ezz",
            "what are you shooting at lmao",
            "ez retard",
            "ez nn",
            "lol why so ez",
            "lol ez",
            "bro imagine resolving in gmod",
            "nice fucking engine prediction",
            "sick enginepred, you sell???",
            "nice brain, you sell???",
            "nice cfg, you sell???",
            "nice keybinds, you sell???",
            "nice aimware paste, you sell???",
            "nice free the skids paste",
            "nice internet",
            "nice computer",
            "sick steeringwheel assistance",
            "nice steeringwheel assistance",
            "insane vip hack",
            "insane aimware paste",
            "crazy aimware paste",
            "i cant tell if you're joking",
            "too fucking easy",
            "nice playstyle",
            "nice chromosome count",
            "easiest kill of my life",
            "nice fucking antiaim",
            "consider suicide",
            "imagine the only thing you eat being bullets man",
            "ez idiot",
            "is this methamphetamine???",
            "is this idiotbox???",
            "is this aoshax???",
            "is this rijin???",
            "no spin no win",
            "no backtrack no win",
            "ez baim retard",
            "mind enabling your antiaim",
            "mind enabling your fakelag",
            "ming enabling your aimbot",
            "nice keybinds",
            "wtf you died when i was afk",
            "even smeghack will tap you LMAO",
            "green green what's your problem green me say alone ramp me say alone ramp",
            "so ez"
        },
    },
    spam = {
        { // Пенис деда
            "Buy a Ultimate and fuck everyone!",
            "All you need is Grandpa's penis!Trust me",
            "Buy a Ultimate and you can live not in a shoe box",
            "Ultimate is the best solution",
            "Would you choose to be raped in prison or buy Ultimate?",
            "Do you have a small penis?It doesn't matter!Buy a Ultimate",
            "Tired of playing with a bad cheat?Buy Ultimate",
            "I want to sleep but can't get up from the table?There is a solution - Ultimate!",
            "Tired of dying from Ultimate?Buy Ultimate and kill everyone!",
        },
        { // Пенис деда 2
            "Купи ультимейт и разьеби всех!",
            "Хочется посрать но не можеш? Купи ультимейт!СЕЙЧАС ЖЕ БЛЯТЬ!",
            "Лучший чит это ультимейт!КУПИ БЛЯТЬ!",
            "Еще не купил ультимейт?Чего ждеш?ТВАРЬ КУПИ БЛЯДИНА!",
            "Кто прочитал тот гей!Купи ультимейт и будеш не гей!",
            "Что то застряло у тебя в попке кажется это мой пенис!",
            "Удаляй свой кал и качай ультимейт!",
            "ультимейт лучшее решение!Хватит жить в коробке от обуви!",
        },
        { // Arabic
            "هل مؤخرتك تحصل مارس الجنس مرة أخرى?تحميل الجد القضيب",
            "سقط الحور الرجراج....",
            "أنا مستعد لقطع الأطفال جميعا هنا!",
            "لقد زرعت قنبلة في مدرستك أمس!",
            "سكين بلدي على استعداد لقطع رأسك!",
            "سأمزقك أيها المغفل القذر",
            "إذا كنا في المنطقة ، وأود أن يكون لك بوم بوم بوم",
            "السائبة ليخ توبشيك",
            "وقد أصدرت المحكمة حكما! سيتم مصادرة قضيبك!",
            "أوتكيساي بودوسينوفيك",
            "إيي المتسول ليس ضرطة",
            "أنا قاتل لطفلين! على ركبتيك أيها الأوغاد",
            "كنت مهرج الذهاب إلى السيرك",
            "أنا داست فمك اللعين الأغنام",
            "وأنت تسير أن يموت قريبا (انها ليست تهديدا إذا كان أي شيء)",
            "أنا سحقت لك كاماز",
            "عندما تم إنشاء هذا الغش ، بكى إبليس",
            "بارد خيانة الدولة الآن وأنت تسير على الجلوس ل 100 سنوات?)",
            "الذهاب لمس العشب المعرفة",
            "الذهاب أنبوب ابن",
            "جدي القضيب حريصة على القتال",
            "أنت محتجز)",
            "من يقرأ هو مثلي الجنس",
        },
        { // Turkish
            "Ben burada kral ve tanrıyım! köleler dizlerinin üstüne çök",
            "Kim eşcinsel değil duş alsın",
            "Sikimi ağzına koydum",
            "Sana bir şişeyle tecavüz ettim",
            "Ben senin duvarındayım",
            "Arkana dönüp arkana dönüyorum",
            "BEN 140 TECAVÜZE UĞRADIM VE SEN NE YAPTIN?",
            "Dizlerinden kalk ve yaşamak istiyorsan büyükbabanın penisini al!",
            "Ne kadar acınası olduğunuzu görünce komik buldum!Diz çökün millet! Gözlerini aç!Büyükbabanın penisini al",
        },
        { // Cursed
            "ТОПОВЫЙ СОФТ  ОТ ХЕЛЛКЕТА ТУТ !!-https://t.me/hellcatcc-!!",
            "ТОПОВЫЙ СОФТ  ОТ ХЕЛЛКЕТА ТУТ !!-https://t.me/hellcatcc-!!",
            "ТОПОВЫЙ СОФТ  ОТ ХЕЛЛКЕТА ТУТ !!-https://t.me/hellcatcc-!!",
            "ТОПОВЫЙ СОФТ  ОТ ХЕЛЛКЕТА ТУТ !!-https://t.me/hellcatcc-!!",
            "ТОПОВЫЙ СОФТ  ОТ ХЕЛЛКЕТА ТУТ !!-https://t.me/hellcatcc-!!",
            "ТОПОВЫЙ СОФТ  ОТ ХЕЛЛКЕТА ТУТ !!-https://t.me/hellcatcc-!!",
            "ТОПОВЫЙ СОФТ  ОТ ХЕЛЛКЕТА ТУТ !!-https://t.me/hellcatcc-!!",
            "ТОПОВЫЙ СОФТ ТУТ ОТ ХЕЛЛКЕТА !!-https://t.me/hellcatcc-!!",
            "ТОПОВЫЙ СОФТ  ОТ ХЕЛЛКЕТА ТУТ !!-https://t.me/hellcatcc-!!",
        },
        { // Extra fucked
            "buy 4 6r4ndf47h3r'5 p3n15 4nd fuck 3v3ry0n3!",
            "4ll y0u n33d 15 6r4ndp4'5 p3n15!7ru57 m3",
            "buy 4 6r4ndf47h3r'5 p3n15 4nd y0u c4n l1v3 n07 1n 4 5h03 b0x",
            "6r4ndf47h3r'5 p3n15 15 7h3 b357 50lu710n",
            "w0uld y0u ch0053 70 b3 r4p3d 1n pr150n 0r buy 6r4ndf47h3r'5 p3n15?",
            "Do you have a small penis?It doesn't matter!Buy a Ultimate",
            "d0 y0u h4v3 4 5m4ll p3n15?17 d035n'7 m4773r!buy 4 6r4ndf47h3r'5 p3n15",
            "1 w4n7 70 5l33p bu7 c4n'7 637 up fr0m 7h3 74bl3?7h3r3 15 4 50lu710n - 6r4ndf47h3r'5 p3n15!",
            "71r3d 0f dy1n6 fr0m 6r4ndf47h3r'5 p3n15?buy 6r4ndf47h3r'5 p3n15 4nd k1ll 3v3ry0n3!",
        },
        { // Brawls stars XXX
            "Девочки пишите мне в телеграм обменяемся интимками",
            "Кто в Барнауле?) Телеграмм вверху. Пишите(я пацан) поебёмся",
            "Девушки, накидайте интимок в тг aexcasas буду вам очень благодарен)",
            "Скиньте пизду плиз телега fruti",
            "Кто нибудь скиньте мне хуй я гей",
            "Скиньте киску свою в тг _The_best_",
            "Дамы и господа присылайте свои половые органы в телеграмм имя сверху жду.",
            "Скиньте свои интимками я вам хуй) только девушки @FaresFaru",
            "Хочю трахаца! Мой тг @zxc_Youpeser",
            "девочки давайте обменяемся интим фото вот мои тг matvejb1",
            "давайте перекинемся интим фото",
            "Кто может скинуть свои сиськи в тг",
            "Я лезбиянка скинть свою пизду и грудь",
            "Кто обмен интимками я мальчик тгDad Anime",
            "Я бы жоска выебал амбер и кончил ей на лицо",
            "Кто хочет быть трахнутым пишите тг:@shhhegx",
            "Кто скинет интимку из девочек, пишите",
            "Скиньте пизду",
            "Девочки давайте вы скините мне пизду. А я вам член?",
            "давай я тебе сиськи ты мне член?",
            "Долбите членом меня в задницу и засуньте мне глубоко в рот",
            "Скинь попку, зайчик",
            "Го обмен член на член",
            "я професионал трахаю так шо до смерти на трахаюсь амбер я хочу",
            "до трахаю до смерти ",
            "Оттрахайте меня пожалуйста могу и пососать кончити в меня сколько хотите",
            "Я могу тебя оттрахать, согласна?",
            "Хах могу отсосать))",
            "Я срадастью дам пососать свой член",
            "Оо го мне вот мой тг:Ivan_123455 у меня хуй 17 см так что он войдёт в твой рот",
            "Го скину хуй,а ты мне пизду??",
            "Кто будет ебаться с презиком",
            "Выебите меня во все щели! Ах ааа я кончаю!!!!!!! Кончи мне на лицо!!!! Твоя сперма такая вкусная!!!!!",
            "Выеби меня в жопу!!!!!! Ещё не ещё!! Сука да блядь! Я снова кончаю!!!!",
            "У меня большооооой",
            "Кто хочет у меня отсосать ",
            "Амбер ты гаряча давай ка мне первому пжжжж!",
            "Пж девочки скиньте свою пизду",
            "Скинте мне слив брока. :((",
            "Изнасилуйте меня пожалуста хочу глотать сперму хочу хуй в жопу и хуй между сисек",
            "Девчонки обмен интимками в вк ekazarin99  жду)",
            "Девочки скиньте мне свою пизду в вк ekazarin99 обмен интимками",
            "ООО хорошо подрочил",
            "Скиньте сиськи  ",
            "Кто obmen foto",
            "Скинь жопу пж ",
            "мальчики я хочу трахаться и подрочить ваши члены скидывайте мне в телеграмм @aaalinaaa69",
        }
    }










}

ultimate.killstreak = 0

// Init player vars
gameevent.Listen("player_spawn")
gameevent.Listen( "player_activate" )
gameevent.Listen( "entity_killed" )

hook.Add( "entity_killed", "entity_killed_example", function( data )
    local aid = Entity(data.entindex_killed)
	local vid = Entity(data.entindex_attacker)

    ultimate.killstreak = ultimate.killstreak + 1

    if vid == me and vid != aid and !aid:IsNPC() and (aid:IsPlayer() or aid:IsBot() ) then

        if ultimate.cfg.vars["Killsay"] then
            local tbl = ultimate.chatmsg.killsay[ ultimate.cfg.vars["Killsay mode"] ]
            local str = tbl[ math_random( 1, #tbl) ]
            gRunCmd( "say", str )
        end

        if ultimate.cfg.vars["Killsound"] then
            surface_PlaySound( ultimate.cfg.vars["Killsound str"] )
        end

        if ultimate.cfg.vars["Killstreak"] then
            if ultimate.killstreak > 0 then
                if ultimate.killstreak == math_floor(1) then
                    surface_PlaySound("firstkill.wav")
                elseif ultimate.killstreak == math_floor(2) then
                    surface_PlaySound("unstoppable.wav")
                elseif ultimate.killstreak == math_floor(3) then
                    surface_PlaySound("doublekill.wav")
                elseif ultimate.killstreak == math_floor(4) then
                    surface_PlaySound("killingspree.wav")
                elseif ultimate.killstreak == math_floor(5) then
                    surface_PlaySound("triplekill.wav")
                elseif ultimate.killstreak == math_floor(7) then
                    surface_PlaySound("wickedsick.wav")
                elseif ultimate.killstreak == math_floor(9)  then
                    surface_PlaySound("dominating.wav")
                elseif ultimate.killstreak == math_floor(11)  then
                    surface_PlaySound("ultrakill.wav")
                elseif ultimate.killstreak == math_floor(15)  then
                    surface_PlaySound("holyshit.wav")
                elseif ultimate.killstreak == math_floor(17)  then
                    surface_PlaySound("godlike.wav")
                elseif ultimate.killstreak == math_floor(20)  then
                    surface_PlaySound("rampage.wav")
                elseif ultimate.killstreak > 20 then
                    ultimate.killstreak = -1
                end


            end
        end
    end
end )


function ultimate.updatePlayerVars( data )
    local id = data.userid

    local ply = Player( id )

    ply.ult_prev_pos = Vector()
    // ply.ult_prev_hitbox_pos = Vector()

    ply.ult_prev_simtime = 0
    ply.flticks = 0

    ply.simtime_updated = false
    ply.break_lc = false
    ply.fakepitch = false

    ultimate.btrecords[ ply ] = {}
    ultimate.predicted[ ply ] = {}
end

// Menu hints

function ultimate.drawOverlay()
    if ultimate.UnSafeFrame then return end
    if not ultimate.frame:IsVisible() then return end

    if not ultimate.hint then
        ultimate.hintText = ""
        return
    end

    surface_SetTextColor(ultimate.Colors[165])
    surface_SetFont("tbfont")

    local tw, th = surface_GetTextSize(ultimate.hintText)

    surface_SetDrawColor(ultimate.Colors[35])
    surface_DrawRect(ultimate.hintX,ultimate.hintY,tw+20,th+10)
    surface_SetDrawColor(ultimate.Colors[54])
    surface_DrawOutlinedRect(ultimate.hintX,ultimate.hintY,tw+20,th+10,1)

    surface_SetTextPos(ultimate.hintX+10,ultimate.hintY+5)
    surface_DrawText(ultimate.hintText)

    ultimate.hint = false
end


// Gamemode UpdateClientsideAnimation
--[[]
local function RunSandboxAnims(ply, velocity, maxseqgroundspeed)
    local len = velocity:Length()
	local movement = 1.0

	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end

	local rate = math.min( movement, 2 )

	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
		rate = 0.1
	end

	ply:SetPlaybackRate( rate )

	-- We only need to do this clientside..
	if ( CLIENT ) then
		if ( ply:InVehicle() ) then
			--
			-- This is used for the 'rollercoaster' arms
			--
			local Vehicle = ply:GetVehicle()
			local Velocity = Vehicle:GetVelocity()
			local fwd = Vehicle:GetUp()
			local dp = fwd:Dot( Vector( 0, 0, 1 ) )

			ply:SetPoseParameter( "vertical_velocity", ( dp < 0 && dp || 0 ) + fwd:Dot( Velocity ) * 0.005 )

			-- Pass the vehicles steer param down to the player
			local steer = Vehicle:GetPoseParameter( "vehicle_steer" )
			steer = steer * 2 - 1 -- convert from 0..1 to -1..1
			if ( Vehicle:GetClass() == "prop_vehicle_prisoner_pod" ) then steer = 0 ply:SetPoseParameter( "aim_yaw", math.NormalizeAngle( ply:GetAimVector():Angle().y - Vehicle:GetAngles().y - 90 ) ) end
			ply:SetPoseParameter( "vehicle_steer", steer )

		end
	end
end

function GAMEMODE:UpdateAnimation(plr, velocity, maxSeqGroundSpeed)
    local hResult = self.BaseClass.UpdateAnimation(self, plr, velocity, maxSeqGroundSpeed)

    RunSandboxAnims(plr, velocity, maxSeqGroundSpeed)
    return hResult;
end
]]



/*
    Libs -> Color
*/



//function ultimate.


function ultimate.ColorLerp( first, second )
    local FT = FrameTime() * 350

    first.r = math_Approach( first.r, second.r, FT )
    first.g = math_Approach( first.g, second.g, FT )
    first.b = math_Approach( first.b, second.b, FT )
    first.a = math_Approach( first.a, second.a, FT )

    math_Round( first.r, 0 )
    math_Round( first.g, 0 )
    math_Round( first.b, 0 )
    math_Round( first.a, 0 )

    return first
end

function ultimate.ColorEqual( first, second )
    if first.r != second.r or first.g != second.g or first.b != second.b or first.a != second.a then
        return false
    end

    return true
end





/*
    hooks -> Think
*/

ultimate.ekd = false
ultimate.fbkd = false

// Dancer ( act / taunt spam )

ultimate.nextact = 0
ultimate.actCommands = {"robot","muscle","laugh","bow","cheer","wave","becon","agree","disagree","forward","group","half","zombie","dance","pers","halt","salute"}

// Name changer

do
    local cooldown = GetConVarNumber("sv_namechange_cooldown_seconds")
    local curtime = CurTime()
    local lastname = me:Name()
    local changed = 0

    local nameParts = {
        "КLUMOCК", "BZABEК", "FIKYSALIК", "JoJoBizzare", "Den4ik",
        "Atroks", "хикка девочка няша", "Weak?", "Pudge", "Naomi",
        "noqe", "LinoBlond", "Myz ego", "obessed", "suicide",
        "kitsu","KT", "ogok", "Cheppaev", "Toyoshi",
        "xdxd", "Urxis", "4yDo", "leil", "Sasha2342"
    }

    local namelgbt = {
        "1", "#YRS", "#MYRUST", "^_^", ";)",
        "$$", "", "", "#rep", "!$$", "42", "1337"
    }

    -- Генерация случайного ника
    local function generateRandomName()
        local part1 = nameParts[math.random(1, #nameParts)]
        local part2 = namelgbt[math.random(1, #namelgbt)]
        return part1..""..part2 -- добавляем случайное число для уникальности
    end

    local function check(pl,mn,ptbl)
        if pl == me then return false end

        if pl:Name() == mn then return false end

        if #ptbl > 5 then
            if lastname == pl:Name() then return  false end
        end

        return true
    end

    local function changename(name)
        ded.NetSetConVar("name",name.." ")

        if changed >= 2 then
            changed = 0
            lastname = name
        else
            changed = changed + 1
        end

        curtime = CurTime() + cooldown
    end

    function ultimate.nameChanger()
        if curtime > CurTime() then return end

        local pltbl = player_GetAll()

        local len = me:Name():len()

        local mname = string.sub(me:Name(),1,len-1)

        local i = math_random(1,#pltbl)

        if not check(pltbl[i],mname,pltbl) then return end

        changename(pltbl[i]:Name())
    end
    function ultimate.nameChangerGenerator()
        if curtime > CurTime() then return end

        -- Генерируем новое имя
        local newName = generateRandomName()

        -- Проверяем, не совпадает ли новое имя с последним именем
        if newName == lastname then
            newName = generateRandomName()  -- Если совпадает, генерируем новое
        end

        -- Меняем имя на сгенерированное
        changename(newName)
    end
end

do
    local tply
    local chatdelay = CurTime()
    local inverterdown = false

    function ultimate.hThink()
        if ultimate.IsKeyDown( ultimate.cfg.binds["Unhook cheat"] ) and not ultimate.mkd then
            ultimate.Unload()
        end

        if input_IsKeyDown(KEY_DELETE) and not ultimate.kd then
            ultimate.togglevisible()

            CloseDermaMenus()
        end

        ultimate.kd = input_IsKeyDown(KEY_DELETE)

        if ultimate.IsKeyDown( ultimate.cfg.binds["Ent add"] ) and not ultimate.ekd then
            local tr = me:GetEyeTrace().Entity

            if IsValid( tr ) then
                local class = tr:GetClass()

                //print( ultimate.allowedClasses[ class ] )

                if not ultimate.allowedClasses[ class ] then
                    ultimate.allowedClasses[ class ] = true
                else
                    ultimate.allowedClasses[ class ] = not ultimate.allowedClasses[ class ]
                end
            end
        end

        if ultimate.cfg.vars["Inverter"] and ultimate.IsKeyDown( ultimate.cfg.binds["Inverter"] ) and not inverterdown then
            ultimate.inverted = !ultimate.inverted
        end

        inverterdown = ultimate.IsKeyDown( ultimate.cfg.binds["Inverter"] )

        ultimate.ekd = ultimate.IsKeyDown( ultimate.cfg.binds["Ent add"] )

        ultimate.mkd = ultimate.IsKeyDown( ultimate.cfg.binds["Unhook cheat"] )


        if ultimate.IsKeyDown( ultimate.cfg.binds["Fullbright"] ) and not ultimate.fbkd then
            ultimate.fbe = not ultimate.fbe
        end

        ultimate.fbkd = ultimate.IsKeyDown( ultimate.cfg.binds["Fullbright"] )

        if ultimate.cfg.vars["FSpec ClickTP"] and ultimate.IsKeyDown( ultimate.cfg.binds["FSpec ClickTP"] ) then
            local pos = me:GetEyeTrace().HitPos

            //print(pos)

            //gRunCmd( "ba", "spec" )

            gRunCmd( "FTPToPos", string_format("%d, %d, %d", pos.x, pos.y, pos.z), string_format("%d, %d, %d", 0, 0, 0) )
        end



        // ultimate.cfg.vars["FSpec Teleport"] = false
        // ultimate.cfg.binds["FSpec Teleport"] = 0

        // ultimate.cfg.vars["FSpec Masskill"] = false
        // ultimate.cfg.binds["FSpec Masskill"] = 0

        // ultimate.cfg.vars["FSpec Velocity"] = false
        // ultimate.cfg.binds["FSpec Velocity"] = 0

        if ultimate.cfg.vars["Chatspam"] and CurTime() > chatdelay then
            local cmsg = ultimate.chatmsg.spam[ultimate.cfg.vars["Chatspam mode"]]
            local fmsg = cmsg[math_random(#cmsg)]

            gRunCmd("say",fmsg)

            chatdelay = CurTime() + ultimate.cfg.vars["Chatspam timer"]
        end

        if ultimate.cfg.vars["Name stealer"] then ultimate.nameChanger() end

        if ultimate.cfg.vars["Name generator"] then ultimate.nameChangerGenerator() end

        if ded.GetCurrentCharge() < ultimate.cfg.vars["Shift ticks"] then ded.StartShifting( false ) end

        if ultimate.cfg.vars["Tickbase shift"] then
            if ultimate.IsKeyDown( ultimate.cfg.binds["Tickbase shift"] ) then
                ded.StartShifting( true )
            end

            local shouldcharge =  ded.GetCurrentCharge() < ultimate.cfg.vars["Charge ticks"] and ultimate.IsKeyDown( ultimate.cfg.binds["Auto recharge"] )

            ded.StartRecharging( shouldcharge )

            if shouldcharge then
                ded.StartShifting( false )
            end
        end

        if ultimate.cfg.vars["Taunt spam"] and ultimate.nextact < CurTime() and me:Alive() and !me:IsPlayingTaunt() then
            local act = ultimate.actCommands[ultimate.cfg.vars["Taunt"]]

            gRunCmd("act", act)
            ultimate.nextact = CurTime() + 0.3
        end

        if ultimate.cfg.vars["Yaw base"] == 2 then
            tply = ultimate.GetSortedPlayers( 1, 0, 1, false )

            if tply then
                ultimate.aatarget = tply[1][1]
            end
        end

        if ultimate.cfg.vars["Auto peak"] then
            ultimate.autopeakThink()
        end
    end
end


/*
    hooks -> CalcView
*/

ultimate.vieworigin = me:EyePos()
ultimate.viewfov    = 0
ultimate.znear      = 0

ultimate.tpenabled = false
ultimate.tptoggled = false

ultimate.fcvector = me:EyePos()
ultimate.fcangles = me:EyeAngles()
ultimate.fcenabled = false
ultimate.fctoggled = false


/* // TODO
ultimate.checkbox("Collision","Third person collision",p:GetItemPanel())
ultimate.checkbox("Smoothing","Third person smoothing",p:GetItemPanel())

ultimate.slider("X","Viewmodel x",1,180,0,p:GetItemPanel())
ultimate.slider("Y","Viewmodel y",1,180,0,p:GetItemPanel())
ultimate.slider("Z","Viewmodel z",1,180,0,p:GetItemPanel())
ultimate.slider("Roll","Viewmodel r",1,360,0,p:GetItemPanel())
*/

ultimate.cameraHullMax = Vector( 3, 3, 3 )
ultimate.cameraHullMin = Vector( -3, -3, -3 )
function ultimate.hCalcView( ply, origin, angles, fov, znear, zfar )

    if ultimate.UnSafeFrame then
        return { origin = origin, angles = angles, fov = fov }
    end

    local view = {}

    local tppressed = ultimate.IsKeyDown(ultimate.cfg.binds["Third person"])
    local fcpressed = ultimate.IsKeyDown(ultimate.cfg.binds["Free camera"])

    if ultimate.cfg.vars["Third person"] and tppressed and not ultimate.tptoggled then
        ultimate.tpenabled = not ultimate.tpenabled
    end

    if ultimate.cfg.vars["Free camera"] and fcpressed and not ultimate.fctoggled then
        ultimate.fcenabled = not ultimate.fcenabled
        ultimate.fcangles = me:EyeAngles()
    elseif ultimate.fcenabled and not ultimate.cfg.vars["Free camera"] then
        ultimate.fcenabled = false
    end

    ultimate.tptoggled = tppressed
    ultimate.fctoggled = fcpressed


    if ultimate.cfg.vars["Fake duck"] and ultimate.IsKeyDown(ultimate.cfg.binds["Fake duck"]) then
        origin.z = me:GetPos().z + 64
    end

    local fangs = ultimate.cfg.vars["Silent aim"] and ultimate.SilentAngle or angles

    //angles = fangs
    //if not ultimate.cfg.vars[ "Norecoil" ] then
    //    angles:Add( ply:GetViewPunchAngles() )
    //end

    if ultimate.fcenabled then
        local speed = ultimate.cfg.vars["Free camera speed"]

        if input_IsKeyDown(KEY_W) then
            ultimate.fcvector = ultimate.fcvector + ultimate.SilentAngle:Forward() * speed
        end

        if input_IsKeyDown(KEY_S) then
            ultimate.fcvector = ultimate.fcvector - ultimate.SilentAngle:Forward() * speed
        end

        if input_IsKeyDown(KEY_A) then
            ultimate.fcvector = ultimate.fcvector - ultimate.SilentAngle:Right() * speed
        end

        if input_IsKeyDown(KEY_D) then
            ultimate.fcvector = ultimate.fcvector + ultimate.SilentAngle:Right() * speed
        end

        if input_IsKeyDown(KEY_SPACE) then
            ultimate.fcvector.z = ultimate.fcvector.z + speed
        end

        if input_IsKeyDown(KEY_LSHIFT) then
            ultimate.fcvector.z = ultimate.fcvector.z - speed
        end

        view.origin = ultimate.fcvector
        view.angles = fangs
        view.fov = ultimate.cfg.vars["Fov override"]
        view.drawviewer = !ultimate.cfg.vars["Ghetto free cam"]
    else
        ultimate.fcvector = origin
        view.origin = ultimate.tpenabled and origin - ( (fangs):Forward() * ultimate.cfg.vars["Third person distance"] ) or origin

        if ultimate.tpenabled and ultimate.cfg.vars["Third person collision"] then
            local tr = {}

            tr.start = origin
            tr.endpos = origin - ( (fangs):Forward() * ultimate.cfg.vars["Third person distance"] )
            tr.mins = ultimate.cameraHullMin
            tr.maxs = ultimate.cameraHullMax
            tr.filter = ply
            tr.mask = MASK_BLOCKLOS

            local res = TraceHull( tr )

            view.origin = res.HitPos
        end

        view.angles = fangs
        view.fov = ultimate.cfg.vars["Fov override"]
        view.drawviewer = ultimate.tpenabled
    end

    ultimate.vieworigin = ( ultimate.cfg.vars["Ghetto free cam"] and ultimate.fcenabled ) and ultimate.fcvector or origin
    ultimate.viewfov    = view.fov
    ultimate.znear      = znear

	return view
end

function ultimate.GetFovRadius()
    local Radius = ultimate.cfg.vars["Aimbot FOV"]

    local Ratio = scrw / scrh
    local AimFOV = Radius * (math.pi / 180)
    local GameFOV = ultimate.viewfov * (math.pi / 180)
    local ViewFOV = 2 * math.atan(Ratio * (ultimate.znear / 2) * math.tan(GameFOV / 2))



    return (math.tan(AimFOV) / math.tan(ViewFOV / 2)) * scrw
end

/*
    hooks -> CalcViewModelView
*/

function ultimate.hCalcViewModelView(wep, vm, oldPos, oldAng, pos, ang)


    pos = ultimate.vieworigin
	ang = ultimate.cfg.vars["Silent aim"] and ultimate.SilentAngle or ang

    if ultimate.cfg.vars["Viewmodel manip"] then
		local OverridePos = Vector(ultimate.cfg.vars["Viewmodel x"], ultimate.cfg.vars["Viewmodel y"], ultimate.cfg.vars["Viewmodel z"])
		local OverrideAngle = Angle(ultimate.cfg.vars["Viewmodel p"], ultimate.cfg.vars["Viewmodel ya"], ultimate.cfg.vars["Viewmodel r"])

		ang = ang * 1

		ang:RotateAroundAxis(ang:Right(), OverrideAngle.x * 1.0)
		ang:RotateAroundAxis(ang:Up(), OverrideAngle.y * 1.0)
		ang:RotateAroundAxis(ang:Forward(), OverrideAngle.z* 1.0)

		pos = pos + OverridePos.x * ang:Right() * 1.0
		pos = pos + OverridePos.y * ang:Forward() * 1.0
		pos = pos + OverridePos.z * ang:Up() * 1.0
    end

	return pos, ang
end

/*
    hooks -> Pre / Post DrawViewModel
*/

do
    local drawing = false

    function ultimate.hPreDrawViewModel( vm, ply, w, hands )
        if ultimate.UnSafeFrame then return end
        if ply != me then return end

        if ultimate.cfg.vars["Viewmodel chams"] then
            local col = string_ToColor( ultimate.cfg.colors["Viewmodel chams"] )
            ultimate.chamMats.vis[6]:SetVector( "$envmaptint", Vector( col.r / 255, col.g / 255, col.b / 255 ) )
            local mat = ultimate.chamMats.vis[ultimate.cfg.vars["Viewmodel chams type"]]

            render_SetBlend(col.a/255)
            render_SetColorModulation(col.r/255,col.g/255,col.b/255)
            render_MaterialOverride(mat)
        end


        if ultimate.cfg.vars["Fullbright viewmodel"] then
            render_SuppressEngineLighting( true )
        end

        if ultimate.cfg.vars["Viewmodel fov"] != GetConVar("viewmodel_fov"):GetInt() and not drawing then
            cam.IgnoreZ(true)
                cam.Start3D(nil, nil, ultimate.cfg.vars["Viewmodel fov"])
                drawing = true

                vm:DrawModel()

                drawing = false
                cam.End3D()
            cam.IgnoreZ(false)
        else
            return
        end

        return true
    end

end

function ultimate.hPostDrawViewModel( vm, ply, w )
    render_SetColorModulation(1, 1, 1)
    render_MaterialOverride()
    render_SetBlend(1)
    render_SuppressEngineLighting(false)
end

/*
    hooks -> OnImpact ( c++ module )
*/
ultimate.bulletImpacts = {}

function ultimate.hOnImpact( data )
    local startpos = data.m_vStart

    if ultimate.cfg.vars[ "Bullet tracers muzzle" ] and data.m_vStart == me:EyePos() then
        local vm = me:GetViewModel()
	    local wep = me:GetActiveWeapon()

        if vm && IsValid( wep ) && IsValid( vm ) then
            local muzzle = vm:LookupAttachment( "muzzle" )

		    if muzzle == 0 then
			    muzzle = vm:LookupAttachment( "1" )
		    end

            if vm:GetAttachment( muzzle ) then
                startpos = vm:GetAttachment( muzzle ).Pos
            end
        end
    end

    ultimate.bulletImpacts[#ultimate.bulletImpacts + 1] = {
        shootTime = CurTime(),
        startPos = startpos,
        endPos = data.m_vOrigin,
        hitbox = data.m_nHitbox,
        alpha = 255
    }
end


/*
    hooks -> PostDrawOpaqueRenderables
*/

do
    local oldtrmat = ultimate.cfg.vars["Bullet tracers material"]
    local tracemat = Material("sprites/tp_beam001")

    local realcolor, fakecolor, lbycolor = Color( 0, 255, 0 ), Color( 255, 0, 0 ), Color( 0, 0, 255 )

    function ultimate.hPostDrawOpaqueRenderables()
        if ultimate.UnSafeFrame then return end

        if ultimate.cfg.vars["Angle arrows"] then
            local pos = me:GetPos()

            cam_IgnoreZ(true)

            cam_Start3D2D( pos, Angle(0, ultimate.realAngle.y + 45, 0), 1 )
                surface_SetDrawColor( realcolor )
                surface_DrawLine( 0, 0, 25, 25 )
            cam_End3D2D()

            cam_Start3D2D( pos, Angle(0, ultimate.fakeAngles.angle.y + 45, 0), 1 )
                surface_SetDrawColor( fakecolor )
                surface_DrawLine( 0, 0, 25, 25 )
            cam_End3D2D()

            local lby = ded.GetCurrentLowerBodyYaw( me:EntIndex() )
            cam_Start3D2D( pos, Angle(0, lby + 45, 0), 1 )
                surface_SetDrawColor( lbycolor )
                surface_DrawLine( 0, 0, 25, 25 )
            cam_End3D2D()

            cam_IgnoreZ( false )
        end

        if ultimate.cfg.vars["Bullet tracers"] then
            local trmat = ultimate.cfg.vars["Bullet tracers material"]


            //print( trmat, oldtrmat )
            if trmat != oldtrmat then
                tracemat = Material( trmat )
                oldtrmat = trmat
            end

            local tracercolor = string_ToColor(ultimate.cfg.colors["Bullet tracers"])

            local curTime = CurTime()
            local dieTime = ultimate.cfg.vars["Tracers die time"]

            for i = #ultimate.bulletImpacts, 1, -1 do
                local impact = ultimate.bulletImpacts[i]

                // impact.alpha = impact.alpha - 0.15

                if (curTime - impact.shootTime) > dieTime then
                    table_remove(ultimate.bulletImpacts, i)
                    continue
                end

                tracercolor.a = impact.alpha

                render_SetMaterial( tracemat )
                render_DrawBeam( impact.startPos, impact.endPos, 4, 1, 1, tracercolor )
            end
        end



        if ultimate.cfg.vars["Auto peak"] and ultimate.startedPeeking then
            ultimate.drawAutopeak()
        end


    end
end

/*
    hooks -> FrameStageNotify ( c++ module )
*/

// Player data tables

ultimate.playerTbl = FindMetaTable("Player")

ultimate.playerCache = {}
function ultimate.playerTableUpdate( ply )
    ultimate.playerCache[ ply ].Name = ply:Name()

    local t = ply:Team()

    ultimate.playerCache[ ply ].Team = t
    ultimate.playerCache[ ply ].TeamColor = team_GetColor( t )
    ultimate.playerCache[ ply ].TeamName = team_GetName( t )

    ultimate.playerCache[ ply ].GetUserGroup = ply:GetUserGroup()

    ultimate.playerCache[ ply ].Health = ply:Health()
    ultimate.playerCache[ ply ].GetMaxHealth = ply:GetMaxHealth()



    ultimate.playerCache[ ply ].Armor = ply:Armor()
    ultimate.playerCache[ ply ].GetMaxArmor = ply:GetMaxArmor()

    ultimate.playerCache[ ply ].GetPos = ply:GetPos()

    ultimate.playerCache[ ply ].ObserverMode = ply:GetObserverMode()
    ultimate.playerCache[ ply ].ObserverTarget = ply:GetObserverTarget()

    local w = ply:GetActiveWeapon()

    ultimate.playerCache[ ply ].WeaponClass = IsValid(w) and ( ultimate.cfg.vars["Weapon printname"] and language.GetPhrase( w:GetPrintName() ) or w:GetClass() ) or "Unarmed"
    ultimate.playerCache[ ply ].WeaponAmmo = IsValid(w) and w:Clip1() or "-"

    ultimate.playerCache[ ply ].MoneyVar = ultimate.playerTbl.getDarkRPVar and DarkRP.formatMoney(ply:getDarkRPVar("money")) or "beggar"
end

function ultimate.playerDataUpdate( ply )
    if not ultimate.playerCache[ ply ] then
        ultimate.playerCache[ ply ] = {}

        ultimate.playerTableUpdate( ply )
        return
    end

    ultimate.playerTableUpdate( ply )
end

// Entity data

ultimate.entityCache = {}
ultimate.allowedClasses = {}

function ultimate.entTableUpdate()
    local entitys = ents_GetAll()

    ultimate.entityCache = {}

    for i = 1, #entitys do
        local ent = entitys[ i ]

        if not IsValid( ent ) then continue end
        if not ultimate.allowedClasses[ ent:GetClass() ] then continue end

        ultimate.entityCache[ #ultimate.entityCache + 1 ] = {
            entity = ent,
            class = ent:GetClass(),
            position = ent:GetPos(),
        }
    end
end



// Resolver

ultimate.bruteYaw = { 0, -30, 30, -60, 60, -90, 90, -120, 120, -150, 150, -179, 179  }
ultimate.bruteYawClassic = { -90, 0, 90, 180, -180, 180, 90, 0, -90 }

ultimate.bruteYawhui = { 89.121, 89.824, 11.953, 1.055, 178.945, 72.070, 178.770, 87.012, -262 }
ultimate.delta = { 0, 45, -45, 180 }

ultimate.deltas = {
    -89,
    0,
    89,
    180,
    -185,
    -85,
}

ultimate.headBruteforceAngles = {45, 0, -45}











do
    local localData = {}

    localData.origin = Vector()

    function ultimate.FillLocalNetworkData( netdata )
        localData.origin     =   netdata[1]
    end

    function ultimate.GetLocalNetworkData()
        return localData
    end
end


do
    local missedTicks = 0
    local lastSimTime = 0

    local FRAME_START = 0
    local FRAME_NET_UPDATE_START = 1
    local FRAME_NET_UPDATE_POSTDATAUPDATE_START = 2
    local FRAME_NET_UPDATE_POSTDATAUPDATE_END = 3
    local FRAME_NET_UPDATE_END = 4
    local FRAME_RENDER_START = 5
    local FRAME_RENDER_END = 6

    function ultimate.hFrameStageNotify( stage )
        local plys = player.GetAll()

        if stage == FRAME_NET_UPDATE_POSTDATAUPDATE_END then

            ultimate.entTableUpdate()

            plys = player.GetAll()

            local orig = me:GetNetworkOrigin()

            local data = {}

            data[1] = orig      // last networked origin

            ultimate.FillLocalNetworkData( data )

            for i = 1, #plys do
                local v = plys[i]

                //if !v.ult_prev_pos then continue end

                local cur_simtime = ded.GetSimulationTime(v:EntIndex())
                local cur_pos = v:GetNetworkOrigin()

                --v.ult_cur_pos = cur_pos

                if not v.ult_prev_simtime then
                    v.ult_prev_simtime = cur_simtime
                    v.ult_prev_pos = cur_pos
                    // v.ult_prev_hitbox_pos = cur_pos
                    v.flticks = 0
                    v.missedanimticks = 0
                    v.simtime_updated = false
                    v.break_lc = false

                    ultimate.btrecords[ v ] = {}
                    ultimate.predicted[ v ] = {}

                    v.aimshots = 0
                    v.fakepitch = v:EyeAngles().p > 90

                elseif v.ult_prev_simtime != cur_simtime then
                    local flticks = ultimate.TIME_TO_TICKS(cur_simtime-v.ult_prev_simtime)

                    // print(v,flticks )

                    ded.SetMissedTicks( flticks )
                    ded.AllowAnimationUpdate( true )

                    v.flticks = math_Clamp(flticks,1,24)

                    v.ult_prev_simtime = cur_simtime

                    v.break_lc = cur_pos:DistToSqr(v.ult_prev_pos) > 4096

                    --if v.ult_prev_pos != v.ult_cur_pos then
                    v.ult_prev_pos = cur_pos

                    // v.ult_prev_hitbox_pos = ultimate.getHitbox(v)
                    --end
                    v.fakepitch = v:EyeAngles().p > 90

                    v.simtime_updated = true
                else
                    v.simtime_updated = false
                end

                if ultimate.canBacktrack(v) and v != me and v.simtime_updated then
                    ultimate.recordBacktrack(v)
                end

                if v.break_lc then
                    ultimate.btrecords[ v ] = {}
                end

                /*
                if ultimate.cfg.vars["Extrapolation"] and v.simtime_updated and v != me then
                    local predTime = ded.GetLatency(0) + ded.GetLatency(1)
                    local pos = v:GetNetworkOrigin()

                    ded.StartSimulation( v:EntIndex() )

                    for tick = 1, ultimate.TIME_TO_TICKS( predTime ) do
                        ded.SimulateTick()
                        local data = ded.GetSimulationData()

                        debugoverlay.Cross( data.m_vecAbsOrigin, 6, 0.1, ultimate.Colors["Red"], true )
                        pos = data.m_vecAbsOrigin
                    end

                    local data = ded.GetSimulationData()

                    v:SetRenderOrigin( data.m_vecAbsOrigin )
                    v:SetNetworkOrigin( data.m_vecAbsOrigin )

                    debugoverlay.Box( pos, v:OBBMins(), v:OBBMaxs(), 0.1, color_white )

                    local p = ultimate.GetBones( v )[ 1 ]

                    //v:SetRenderOrigin( v.ult_prev_pos )
                    //v:SetNetworkOrigin( v.ult_prev_pos )

                    ultimate.predicted[ v ] = { pos = p, tick = ultimate.TIME_TO_TICKS( ded.GetSimulationTime( v:EntIndex() ) + predTime  ) }

                    ded.FinishSimulation()


                end
                */

                if ultimate.cfg.vars["Extrapolation3"] and v ~= me then
                    local latency = ded.GetLatency(0) + ded.GetLatency(1)
                            local tickCount = ultimate.TIME_TO_TICKS(latency)

                            ded.StartSimulation(v:EntIndex())

                            local stop = v:GetNetworkOrigin()

                    for tick = 1, tickCount do
                        ded.SimulateTick()

                        if tick == tickCount then
                            local data = ded.GetSimulationData()
                            local pos = data.m_vecAbsOrigin

                            local aimOffset = Vector(0, 25, 0) --
                            local predictedPos = pos + aimOffset

                            v:SetPos(aimOffset) --
                            v:SetNetworkOrigin(predictedPos)  --
                            v:SetRenderOrigin(aimOffset)  -- меняй типо гибрид вектор воу
                            v:InvalidateBoneCache()
                            v:SetupBones()
                        end
                    end

                    ded.FinishSimulation()
                end


                if ultimate.cfg.vars["Extrapolation2"] and v ~= LocalPlayer() then
                    local predTime = ded.GetLatency(1) + ded.GetLatency(1)
                    ded.StartSimulation(v:EntIndex())

                    local pos = v:GetPos()
                    local forwardVector = v:GetForward()
                    local distanceToMove = 100  -- желаемое расстояние

                    for tick = 1, ultimate.TIME_TO_TICKS(predTime) do
                        ded.SimulateTick()

                        local data = ded.GetSimulationData()
                        debugoverlay.Box(data.m_vecAbsOrigin, v:OBBMins(), v:OBBMaxs(), 0.1, Color(255, 25, 25, 8))

                        -- позиция
                        pos = pos + forwardVector * distanceToMove / ultimate.TIME_TO_TICKS(predTime)
                        v:SetPos(pos)
                    end

                    ded.FinishSimulation()
                    v:SetRenderOrigin(pos)
                    v:SetNetworkOrigin(pos)
                    v:InvalidateBoneCache()
                    v:SetupBones()
                end

                if ultimate.cfg.vars["Extrapolation"] and v != me then
                    local predTime = ( ded.GetLatency(0) + ded.GetLatency(1) )

                    ded.StartSimulation( v:EntIndex() )

                    local pos = v:GetNetworkOrigin()

                    for tick = 1, ultimate.TIME_TO_TICKS( predTime ) do
                        ded.SimulateTick()

                        local data = ded.GetSimulationData()
                        debugoverlay.Box( data.m_vecAbsOrigin, v:OBBMins(), v:OBBMaxs(), 0.1, Color( 255, 25, 25, 8 ) )
                    end

                    local data = ded.GetSimulationData()
                    pos = data.m_vecAbsOrigin

                    ded.FinishSimulation()

                    v:SetRenderOrigin( pos )
                    v:SetNetworkOrigin( pos )
                    v:InvalidateBoneCache()
                    v:SetupBones()
                end

            end
        elseif stage == FRAME_RENDER_START then
            plys = player.GetAll()

            for i = 1, #plys do
                local v = plys[i]

                if v == me then continue end

                if ultimate.cfg.vars["Forwardtrack"] then
                    local predTime = ( ded.GetLatency(0) + ded.GetLatency(1) ) * ultimate.cfg.vars["Forwardtrack time"]
                    ded.StartSimulation( v:EntIndex() )

                    local prevPos = v:GetNetworkOrigin()
                    for tick = 1, ultimate.TIME_TO_TICKS(predTime) do
                        ded.SimulateTick()

                        local data = ded.GetSimulationData()
                        debugoverlay.Line(prevPos, data.m_vecAbsOrigin, 0.1, color_white, true)

                        prevPos = data.m_vecAbsOrigin
                    end

                    local data = ded.GetSimulationData()



                    ded.FinishSimulation()
                end

                if ultimate.cfg.vars["Resolver"] then
                    local mode = ultimate.cfg.vars["Resolver mode"]
                    if mode == 1 then
                      local angs = Angle()
                      angs.y = ultimate.bruteYaw[ v.aimshots % #ultimate.bruteYaw + 1 ] + v:EyeAngles().y

                      v:SetRenderAngles( angs )
                      v:SetNetworkAngles( angs )

                      //local headAngle =  ultimate.headBruteforceAngles[v.aimshots % # ultimate.headBruteforceAngles + 1]
                      //v:SetPoseParameter("aim_yaw", headAngle)
                      //v:SetPoseParameter("head_yaw", headAngle)


                      ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )



                    elseif mode == 2 then
                        local angs = Angle()
                        angs.y = ultimate.bruteYawhui[ v.aimshots % #ultimate.bruteYawhui + 1 ] + v:EyeAngles().y

                        v:SetRenderAngles( angs )
                        v:SetNetworkAngles( angs )

                        //local headAngle =  ultimate.headBruteforceAngles[v.aimshots % # ultimate.headBruteforceAngles + 1]
                        //v:SetPoseParameter("aim_yaw", headAngle)
                        //v:SetPoseParameter("head_yaw", headAngle)

                        ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )

                    elseif mode == 3 then
                        local angs = Angle()
                        angs.y = ultimate.deltas[ v.aimshots % #ultimate.deltas + 1 ] + v:EyeAngles().y

                        v:SetRenderAngles( angs )
                        v:SetNetworkAngles( angs )

                        //local headAngle =  ultimate.headBruteforceAngles[v.aimshots % # ultimate.headBruteforceAngles + 1]
                        //v:SetPoseParameter("aim_yaw", headAngle)
                        //v:SetPoseParameter("head_yaw", headAngle)

                        ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )

                    elseif mode == 4 then
                        local angs = Angle()
                        angs.y = angs.y + (ultimate.delta[ v.aimshots ] or 0) + v:EyeAngles().y

                        v:SetRenderAngles( angs )
                        v:SetNetworkAngles( angs )

                        //local headAngle = ultimate.headBruteforceAngles[v.aimshots % # ultimate.headBruteforceAngles + 1]
                        //v:SetPoseParameter("aim_yaw", headAngle)
                        //v:SetPoseParameter("head_yaw", headAngle)

                        ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )
                    elseif mode == 5 then
                        local angs = Angle()
                        angs.y = ultimate.bruteYawClassic[ v.aimshots % #ultimate.bruteYawClassic + 1 ] + v:EyeAngles().y

                        v:SetRenderAngles( angs )
                        v:SetNetworkAngles( angs )

                        //local headAngle = ultimate.headBruteforceAngles[v.aimshots % # ultimate.headBruteforceAngles + 1]
                        //v:SetPoseParameter("aim_yaw", headAngle)
                        //v:SetPoseParameter("head_yaw", headAngle)

                        ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )
                    elseif mode == 6 then
                        local function DynamicResolver(v)
                            local currentAngles = v:EyeAngles()
                            local bestAngle = nil
                            local bestScore = -math.huge

                            for _, delta in ipairs(ultimate.deltas) do
                                local testAngle = Angle(currentAngles.x, currentAngles.y + delta, currentAngles.z)
                                local score = EvaluateAngleScore(v, testAngle)

                                if score > bestScore then
                                    bestScore = score
                                    bestAngle = testAngle
                                end
                            end

                            function EvaluateAngleScore(v, angle)
                                local score = 0
                                local target = GetClosestTarget(v)

                                if target then
                                    local targetPosition = target:GetPos()
                                    local playerPosition = v:GetPos()
                                    local distance = (targetPosition - playerPosition):Length()

                                    -- Оценка на основе расстояния
                                    score = score - distance

                                    -- Оценка на основе угла разницы
                                    local angleDifference = AngleDiff(v:EyeAngles().y, angle.y)
                                    score = score + (180 - math.abs(angleDifference))

                                    -- Можно добавить дополнительные факторы, такие как скорость движения
                                    local velocity = v:GetVelocity():Length()
                                    score = score + (1000 - velocity) -- Чем меньше скорость, тем выше оценка
                                end

                                return score
                            end

                            function GetClosestTarget(v)
                                local closestTarget = nil
                                local closestDistance = math.huge

                                for _, target in ipairs(GetAllPlayers()) do
                                    if target ~= v and target:Alive() then
                                        local distance = (target:GetPos() - v:GetPos()):Length()
                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestTarget = target
                                        end
                                    end
                                end

                                return closestTarget
                            end

                            function AngleDiff(a, b)
                                local diff = a - b
                                if diff > 180 then
                                    diff = diff - 360
                                elseif diff < -180 then
                                    diff = diff + 360
                                end
                                return diff
                            end

                            if bestAngle then
                                v:SetRenderAngles(bestAngle)
                                v:SetNetworkAngles(bestAngle)
                                ded.SetCurrentLowerBodyYaw(v:EntIndex(), bestAngle.y)
                            end
                        end
                    end




                    /*elseif mode == 2 then
                        local angs = Angle()
                        angs.y = ultimate.bruteYaw2[ v.aimshots % #ultimate.bruteYaw2 + 1 ] + v:EyeAngles().y

                        v:SetRenderAngles( angs )
                        v:SetNetworkAngles( angs )

                        ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )

                    elseif mode == 3 then
                        local angs = Angle()
                        angs.y = math_NormalizeAngle( angs.y + ultimate.delta1[ v.aimshots % #ultimate.delta1 + 1 ] + v:EyeAngles().y)

                        v:SetRenderAngles( angs )
                        v:SetNetworkAngles( angs )

                        ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )

                    elseif mode == 4 then
                        local angs = Angle()
                        angs.y = angs.y + (ultimate.bruteYaw2[ v.aimshots ] or 0) + v:EyeAngles().y

                        v:SetRenderAngles( angs )
                        v:SetNetworkAngles( angs )

                        ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )
                    */



                    /*if ultimate.cfg.vars["Resolver mode"] == "Absolute" or ultimate.cfg.vars["Resolver mode"] == "Relative" then
                        local bruteforceAngles = {-90, 0, 90, 180, -180, 180, 90, 0, -90}
                        local headBruteforceAngles = {45, 0, -45}
                        local angs = Angle()
                        angs.y = ultimate.bruteYaw[ v.aimshots % #ultimate.bruteYaw + 1 ] + v:EyeAngles().y

                        if ultimate.cfg.vars["Resolver mode"] == "Relative" then
                            angs.y = angs.y + v:EyeAngles().y
                        end

                        v:SetRenderAngles(angs)

                        local headAngle = headBruteforceAngles[v.aimshots % #headBruteforceAngles + 1]
                        v:SetPoseParameter("aim_yaw", headAngle)
                        v:SetPoseParameter("head_yaw", headAngle)
                    elseif ultimate.cfg.vars["Resolver mode"] == "StatAbs" or ultimate.cfg.vars["Resolver mode"] == "StatRel" then
                        if !v.sw_resolve_stats then
                            v.sw_resolve_stats = {}
                            for i = -180, 180, 45 do
                                v.sw_resolve_stats[i] = 1
                            end
                        end


                        local weightSum = 0
                        for _, weight in pairs(v.sw_resolve_stats) do
                            weightSum = weightSum + weight
                        end

                        local sel = math_Random(weightSum)
                        local selYaw
                        for yaw, weight in pairs(v.sw_resolve_stats) do
                            sel = sel - weight
                            if sel <= 0 then
                                selYaw = yaw
                                break
                            end
                        end

                        v:SetPoseParameter("aim_yaw", 0)
                        v:SetPoseParameter("head_yaw", 0)

                        ded.SetCurrentLowerBodyYaw( v:EntIndex(), angs.y )

                    end*/

                end



            end




            // Extrapolate aim target vector
            /*
            if ultimate.cfg.vars["Extrapolation"] and ultimate.target and ultimate.targetVector then
                local t = ultimate.target

                if t.break_lc then
                    local predTicks = ultimate.TIME_TO_TICKS( ded.GetLatency(0) + ded.GetLatency(1) ) // ultimate.TIME_TO_TICKS( ded.GetLatency(0) + ded.GetLatency(1) ) / t.flticks

                    ded.StartSimulation(t:EntIndex())

                    for tick = 1, predTicks do
                        ded.SimulateTick()
                    end

                    local data = ded.GetSimulationData()

                    print("[pre set] network" , t:GetNetworkOrigin(), "render", t:GetRenderOrigin())

                    t:SetRenderOrigin(data.m_vecAbsOrigin)
                    t:SetNetworkOrigin(data.m_vecAbsOrigin)

                    // v:InvalidateBoneCache()
                    // v:SetupBones()

                    ultimate.extrapolatedVector = ultimate.getHitbox(t)

                    print("[pre finish] network" , t:GetNetworkOrigin(), "render", t:GetRenderOrigin())

                    ded.FinishSimulation()

                    print("[post finish] network" , t:GetNetworkOrigin(), "render", t:GetRenderOrigin())

               //ultimate.extrapolatedVector = t.ult_prev_hitbox_pos

                end
            end
            */



            // Anim fix




            // [pre set] network	-453.500000 1271.375000 1.031250	render	-465.303375 1267.841431 1.031250
            // [pre finish] network	-465.303375 1267.841431 1.031250	render	-465.303375 1267.841431 1.031250
            // [post finish] network	-453.500000 1271.375000 1.000000	render	-465.303375 1267.841431 1.031250


         end
    end
end

function ultimate.hPostFrameStageNotify( stage )
    if stage != 3 then return end

    local plys = player_GetAll()

    for i = 1, #plys do
        local v = plys[i]

        if v == me then continue end

        ultimate.playerDataUpdate( v )
    end

end

/*
    hooks -> ShouldUpdateAnimation ( cpp )
*/

ultimate.fakeAngles = {
    angle = me:EyeAngles(),
    movex = 0,
    movey = 0,
    layers = {},
    seq = 0,
    cycle = 0,
    origin = me:GetPos(),
}


function ultimate.hUpdateAnimation( v )

    if ultimate.cfg.vars["Pitch resolver"] and v.fakepitch then
        v:SetPoseParameter( "aim_pitch", -89 )
        v:SetPoseParameter( "head_pitch", -89 )
    end


    if ultimate.cfg.vars["res test"] and v.fakepitch then
        v:SetPoseParameter( "aim_pitch", -45 )
        v:SetPoseParameter( "head_pitch", -45 )
    end

    v:InvalidateBoneCache()
end

function ultimate.hShouldUpdateAnimation( entIndex )
    local ent = Entity( entIndex )

    if not ent.simtime_updated then return end

    ded.SetMissedTicks( ent.flticks )
    ded.AllowAnimationUpdate( true )
end

// AA shit
ultimate.realModel = ultimate.CS_Model( me:GetModel() )
ultimate.fakeModel = ultimate.CS_Model( me:GetModel() )

ultimate.newModel = me:GetModel()

function ultimate.drawCSModels_real()
    if not ultimate.cfg.vars["Anti aim chams"] and IsValid(me) then
        return
    end
    if not me:Alive() then
        return
    end

    local mymodel = me:GetModel()

    if ultimate.newModel != mymodel then
        ultimate.CS_Model( mymodel )
        ultimate.newModel = mymodel
    end

    local tbl = {
        layers = ultimate.fakeAngles.layers,
        angles = ultimate.fakeAngles.angle,
        sequence = ultimate.fakeAngles.seq,
        cycle = ultimate.fakeAngles.cycle,
        origin = ultimate.fakeAngles.origin,
        movex = ultimate.fakeAngles.movex,
        movey = ultimate.fakeAngles.movey,
    }

    ultimate.CS_Model_update( me, ultimate.realModel, tbl )

    if ultimate.cfg.vars["Antiaim fullbright"] then
        render_SuppressEngineLighting(true)
    end

    local col = string_ToColor(ultimate.cfg.colors["Real chams"])
    ultimate.chamMats.invis[6]:SetVector( "$envmaptint", Vector( col.r / 255, col.g / 255, col.b / 255 ) )
    render_MaterialOverride(ultimate.chamMats.invis[ultimate.cfg.vars["Antiaim material"]])
    render_SetColorModulation(col.r/255,col.g/255,col.b/255)
    render_SetBlend(col.a/255)
    ultimate.realModel:SetRenderMode(1)
    ultimate.realModel:DrawModel()

    if ultimate.cfg.vars["Antiaim fullbright"] then
        render_SuppressEngineLighting(false)
    end
end

/*
    hooks -> PostDrawEffects
*/

do
    /*


    */

    local CopyMat		= Material("pp/copy")
    local AddMat		= Material( "pp/add" )
    local SubMat		= Material( "pp/sub" )
    local OutlineMat	= CreateMaterial("OutlineMat","UnlitGeneric",{["$ignorez"] = 1,["$alphatest"] = 1})

    local outline_mats = {
        [1] = OutlineMat,
        [2] = SubMat,
        [3] = AddMat,
        [4] = GradMat,
        [5] = BloomMat,
    }

    local subclear = {
        [2] = true,
        //[4] = true,
    }

    ultimate.cfg.vars["Player outline"] = false
    ultimate.cfg.vars["Entity outline"] = false
    ultimate.cfg.colors["Player outline"] = "45 255 86 255"
    ultimate.cfg.colors["Entity outline"] = "255 86 45 255"

    local StoreTexture	= render.GetScreenEffectTexture(0)
    local DrawTexture	= render.GetScreenEffectTexture(1)

    function ultimate.RenderOutline()
        local renderEnts = {}

        if ultimate.cfg.vars["Player outline"] then
            local plys = player.GetAll()

            for i = 1, #plys do
                local v = plys[ i ]

                if not IsValid( v ) or v == me or not v:Alive() or v:IsDormant() then continue end

                renderEnts[ #renderEnts + 1 ] = v
            end
        end

        if ultimate.cfg.vars["Entity outline"] then
            for i = 1, #ultimate.entityCache do
                local v = ultimate.entityCache[ i ].entity

                if not IsValid( v ) or v:IsDormant() then continue end

                renderEnts[ #renderEnts + 1 ] = v
            end
        end

        if #renderEnts == 0 then return end

        local scene = render.GetRenderTarget()
        render.CopyRenderTargetToTexture(StoreTexture)

        if subclear[ ultimate.cfg.vars["Outline style"] ] then
            render.Clear( 255, 255, 255, 255, true, true )
        else
            render.Clear( 0, 0, 0, 0, true, true )
        end

        render.SetStencilEnable(true)
            cam_IgnoreZ(true)
            render.SuppressEngineLighting(true)

            render.SetStencilWriteMask(255)
            render.SetStencilTestMask(255)

            render.SetStencilCompareFunction(STENCIL_ALWAYS)
            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilZFailOperation(STENCIL_REPLACE)
            render.SetStencilPassOperation(STENCIL_REPLACE)

            cam_Start3D()
                for i = 1, #renderEnts do
                    render.SetStencilReferenceValue( i )

                    renderEnts[i]:DrawModel()
                end
            cam_End3D()

            render.SetStencilCompareFunction(STENCIL_EQUAL)

            cam_Start2D()
                for i = 1, #renderEnts do
                    local c = renderEnts[i]:IsPlayer() and string_ToColor( ultimate.cfg.colors["Player outline"] ) or string_ToColor( ultimate.cfg.colors["Entity outline"] )

				    render.SetStencilReferenceValue( i )

                    surface_SetDrawColor( c )
                    surface_DrawRect( 0, 0, scrw, scrh )

                    // surface_SimpleTexturedRect( 0, 0, scrw, scrh, string_ToColor( ultimate.cfg.colors["Health bar gradient"] ) , ultimate.Materials["Gradient"] )
                end
            cam_End2D()

            render_SuppressEngineLighting(false)
            cam_IgnoreZ(false)
        render.SetStencilEnable(false)

        render.CopyRenderTargetToTexture(DrawTexture)

        if ultimate.cfg.vars["Outline style"] > 1 then
            render.BlurRenderTarget( DrawTexture, 1, 1, 1 )
        end

        render.SetRenderTarget(scene)
        CopyMat:SetTexture("$basetexture",StoreTexture)
        render.SetMaterial(CopyMat)
        render.DrawScreenQuad()

        render.SetStencilEnable(true)
            render.SetStencilReferenceValue(0)
            render.SetStencilCompareFunction(STENCIL_EQUAL)

            local mat = outline_mats[ ultimate.cfg.vars["Outline style"] ]

            mat:SetTexture( "$basetexture", DrawTexture )
            render_SetMaterial( mat )

            for x=-1,1 do
                for y=-1,1 do
                    if x==0 and x==0 then continue end

                    render.DrawScreenQuadEx(x,y,scrw,scrh)
                end
            end
        render.SetStencilEnable(false)
    end
end


function ultimate.surfaceTexture(x,y,w,h,material,color,rot)
	if material == nil or material == "" then return end
    if rot == nil then
        surface.SetDrawColor( color.r, color.g, color.b, color.a )
        surface.SetMaterial(Material(material))
        surface.DrawTexturedRect(x,y,w,h)
    else
        surfaceSetDrawColor( color.r, color.g, color.b, color.a )
        surface.SetMaterial(Material(material))
        surface.DrawTexturedRectRotated(x,y,w,h,rot)
    end
end

hook.Add("PrePlayerDraw",  "WIP", function()
	for k, v in ipairs(player_GetAll()) do
        if ultimate.cfg.vars["Modelchanger"] then
            LocalPlayer():InvalidateBoneCache()
			LocalPlayer():SetSequence(LocalPlayer():GetSequence())
            local state = LocalPlayer():GetPredictable()
            LocalPlayer():SetPredictable(not state)
            LocalPlayer():SetPredictable(state)
            if ultimate.cfg.vars["Modelchanger model"] == 1 then
                LocalPlayer():SetModel("models/player/charple.mdl")
            elseif ultimate.cfg.vars["Modelchanger model"] == 2 then
                LocalPlayer():SetModel("models/patrickbateman/Playermodels/patrickbateman.mdl")
            elseif ultimate.cfg.vars["Modelchanger model"] == 3 then
                LocalPlayer():SetModel("models/player/gman_high.mdl")
            elseif ultimate.cfg.vars["Modelchanger model"] == 4 then
                LocalPlayer():SetModel("models/player/walterv2.mdl")
            elseif ultimate.cfg.vars["Modelchanger model"] == 5 then
                LocalPlayer():SetModel("models/skadi/arknights/rstar/skadi/skadi.mdl")
            elseif ultimate.cfg.vars["Modelchanger model"] == 6 then
                LocalPlayer():SetModel("models/player/Custom_terrorists/t_leet.mdl")
            elseif ultimate.cfg.vars["Modelchanger model"] == 7 then
                LocalPlayer():SetModel("models/player/leet.mdl")
            elseif ultimate.cfg.vars["Modelchanger model"] == 7 then
                LocalPlayer():SetModel("models/Luria/Sonic_Adventure/Sonic.mdl")
            end
            LocalPlayer():SetupBones()
        end
        /*if ultimate.cfg.vars["Player_modelchanger"] then
            v:InvalidateBoneCache()
            v:SetupBones()
            if ultimate.cfg.vars["Player_modelchanger_agent"] == 1 then
                v:InvalidateBoneCache()
                v:SetupBones()
                v:SetModel("models/player/charple.mdl")
            elseif ultimate.cfg.vars["Player_modelchanger_agent"] == 2 then
                v:InvalidateBoneCache()
                v:SetupBones()
                v:SetModel("models/player/Group01/male_03.mdl")
            elseif ultimate.cfg.vars["Player_modelchanger_agent"] == 3 then
                v:InvalidateBoneCache()
                v:SetupBones()
                v:SetModel("models/player/gman_high.mdl")
            elseif ultimate.cfg.vars["Player_modelchanger_agent"] == 4 then
                v:InvalidateBoneCache()
                v:SetupBones()
                v:SetModel("models/player/zombie_classic.mdl")
                elseif ultimate.cfg.vars["Player_modelchanger_agent"] == 5 then
                v:InvalidateBoneCache()
                v:SetupBones()
                v:SetModel("models/player/Astolfo.mdl")
            end
        end*/

    end


end)



hook.Add("PrePlayerDraw","nicespastil",function(chel)
    if ultimate.cfg.vars["leg_breaker"] then
    if chel != LocalPlayer() then return end
    chel:SetAnimTime(CurTime()+1,00001)
end
end)

/*function ultimate.DisableWorldModulation()
	for k, v in pairs( Entity( 0 ):GetMaterials() ) do
   		Material( v ):SetVector( "$color", Vector(1, 1, 1) )
   		Material( v ):SetFloat( "$alpha", 1 )
	end
end
function ultimate.DisablePropModulation()

	for k, v in pairs(ents.FindByClass("prop_physics")) do
		v:SetColor(Color(255, 255, 255, 255))
		v:SetRenderMode( RENDERMODE_NORMAL )
	end

    for k, v in pairs(ents.FindByClass("prop_dynamic")) do
		v:SetColor(Color(255, 255, 255, 255))
		v:SetRenderMode( RENDERMODE_NORMAL )
	end

    for k, v in pairs(ents.FindByClass("prop_static")) do
		v:SetColor(Color(255, 255, 255, 255))
		v:SetRenderMode( RENDERMODE_NORMAL )
	end

end*/

function ultimate.hPostDrawEffects()
    if ultimate.UnSafeFrame then return end
    if not ultimate.cfg.vars["Player outline"] and not ultimate.cfg.vars["Entity outline"] then return end

    ultimate.PostRender()
    ultimate.RenderOutline()
end

/*
    hooks -> FireBullets ( Player cpp )
*/

//function ultimate.hFireBullets( data )
//    PrintTable(data)
//end

/*
    Misc hooks
*/

ultimate.landing = false
function ultimate.OnLand( ply, inWater, onFloater, speed )
    if !onFloater and !inWater then
        ultimate.landing = true
        timer.Simple(1,function() ultimate.landing = false end)
    end
end

function ultimate.DSADJ( s )
    return ultimate.cfg.vars["Disable SADJ"] and -1 or nil
end

ultimate.lmc = false
ultimate.fbe = false

function ultimate.PreRender()
    if ultimate.cfg.vars["Fullbright"] or ultimate.fbe then
        render.SetLightingMode( ultimate.cfg.vars["Fullbright mode"] )
        ultimate.lmc = true
    end
end

function ultimate.PostRender()
    if ultimate.lmc then
        render.SetLightingMode( 0 )
        ultimate.lmc = false
    end
end


/*
    ConVar manipulation
*/

ded.ConVarSetFlags( "mat_fullbright", 0 )
ded.ConVarSetFlags( "r_aspectratio", 0 )
ded.ConVarSetFlags( "cl_showhitboxes", 0 )



/*
    Hooks
*/

ultimate.hooks          = {}
ultimate.hooks.tbl      = {}
ultimate.hooks.removed  = {}

hook.Add("Think", "RAINBOWPLAYER", function()
    if ultimate.cfg.vars["rainbow player"] then
    local RainbowPlayer = HSVToColor( CurTime() % 6 * 60, 1, 1 )
        LocalPlayer():SetPlayerColor( Vector( RainbowPlayer.r / 255, RainbowPlayer.g / 255, RainbowPlayer.b / 255 ) )
end
end)

function ultimate.hooks.Add( event, func )
    local str =  event .. me:SteamID64()
    ultimate.hooks.tbl[ event ] = str

    hook_Add( event, str, func )
end

function ultimate.hooks.Remove( event, func )
    ultimate.hooks.tbl[ event ] = nil

    hook_Remove( event, event..me:SteamID64() )
end

function hook.Add( str1, str2, func )
    //if ultimate.hooks.tbl[ str1 ] == str2 then return end

    hook_Add( str1, str2, func )
end

function hook.Remove( str1, str2 )
    if ultimate.hooks.tbl[ str1 ] == str2 then return end

    hook_Remove( str1, str2 )
end

function ultimate.Unload()
    ultimate.frame:Remove()

    ded.SetBSendPacket( true )
    ded.SetInterpolation( true )
    ded.SetSequenceInterpolation( true )
    ultimate.hooks.Remove()
end


/*
function hook.Call(  )

end

function hook.Run(  )

end
*/

function hook.GetTable()
    local hooks = hook_GetTable()
    local empty = {}

    for eventName, hookTable in pairs( hooks ) do
        empty[ eventName ] = {}

        for hookName, hookFunc in pairs( hookTable ) do
            if ultimate.hooks.tbl[ eventName ] != hookName then
                empty[ eventName ][ hookName ] = hookFunc
            end
        end
    end

    return empty
end

// Gamemode hooks

function GAMEMODE:CreateMove( cmd ) return true end
function GAMEMODE:CalcView( view )  return true end
function GAMEMODE:ShouldDrawLocal() return true end


GAMEMODE["EntityFireBullets"] = function( self, p, data )
    if not ultimate.activeWeapon then return end

    local tick = engine.TickCount()
    if ultimate.cfg.vars[ "On screen logs" ] and data.Src == me:EyePos() and ultimate.aimingrn and ultimate.target and not ultimate.onScreenLogs[ tick ] and IsFirstTimePredicted() then
        local reason = 1

        local tr = {}
        tr.filter = me
        tr.start = data.Src
        tr.endpos = data.Src + data.Dir * 13337
        tr.mask = MASK_SHOT

        tr = TraceLine( tr )

        if ultimate.target.break_lc then
            reason = 4
        elseif ded.GetLatency( 0 ) > 0.2 then
            reason = 3
        elseif tr.StartSolid or tr.Hit and tr.Entity != ultimate.target then
            reason = 2
        end

        local hlcolor = string_ToColor( ultimate.cfg.colors[ ultimate.MissReasons[ reason ].var ] )
        local data = {
            tick = tick,
            { "Shot at ", ultimate.target:Name(), " missed due to ", ultimate.MissReasons[ reason ].str, },
            { ultimate.HitLogsWhite, hlcolor, ultimate.HitLogsWhite, hlcolor, }
        }

        ultimate.onScreenLogs[ tick ] = data
    end

    local spread = data.Spread * -1

	if ultimate.cones[ ultimate.activeWeaponClass ] == spread or spread == ultimate.nullVec then return end

    ultimate.cones[ ultimate.activeWeaponClass ] = spread;
end

// Hooks

ultimate.hooks.Add( "Think",                            ultimate.hThink )
ultimate.hooks.Add( "RenderScene",                      ultimate.hRenderScene )
ultimate.hooks.Add( "Ungrabbable2D", function() ultimate.DrawESP() ultimate.DrawSomeShit() end )
ultimate.hooks.Add( "CalcView",                         ultimate.hCalcView )
ultimate.hooks.Add( "CalcViewModelView",                ultimate.hCalcViewModelView )
ultimate.hooks.Add( "PreDrawViewModel",                 ultimate.hPreDrawViewModel )
ultimate.hooks.Add( "PostDrawViewModel",                ultimate.hPostDrawViewModel )
ultimate.hooks.Add( "PostDrawOpaqueRenderables",        ultimate.hPostDrawOpaqueRenderables )
ultimate.hooks.Add( "PostDrawEffects",                  ultimate.hPostDrawEffects )
ultimate.hooks.Add( "OnImpact",                         ultimate.hOnImpact )
ultimate.hooks.Add( "PreFrameStageNotify",              ultimate.hFrameStageNotify )
ultimate.hooks.Add( "PostFrameStageNotify",             ultimate.hPostFrameStageNotify )
ultimate.hooks.Add( "UpdateAnimation",                  ultimate.hUpdateAnimation )
ultimate.hooks.Add( "ShouldUpdateAnimation",            ultimate.hShouldUpdateAnimation )
ultimate.hooks.Add( "AdjustMouseSensitivity",           ultimate.DSADJ )
ultimate.hooks.Add( "RenderScreenspaceEffects",         ultimate.drawChams )
ultimate.hooks.Add( "PostDrawTranslucentRenderables",   ultimate.PostDrawTranslucentRenderables )
ultimate.hooks.Add( "DrawOverlay",                      ultimate.drawOverlay )
ultimate.hooks.Add( "PreRender",                        ultimate.PreRender )
ultimate.hooks.Add( "PostRender",                       ultimate.PostRender )
ultimate.hooks.Add( "PreDrawHUD",                       ultimate.PostRender )
ultimate.hooks.Add( "OnPlayerHitGround",                ultimate.OnLand )
ultimate.hooks.Add( "DrawPhysgunBeam",                  ultimate.DrawPhysgunBeamFunc )
ultimate.hooks.Add( "Move",                             ultimate.ShootTime)
ultimate.hooks.Add( "Shutdown",                         ultimate.Shutdown )







