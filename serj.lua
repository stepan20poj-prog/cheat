require("jopamodule")

jopa.Read = nil
jopa.Write = nil 

local serj = {}

local surface, draw = surface, draw
local math, player = math, player
local table, util = table, util

local scrw, scrh = ScrW(), ScrH()

local pairs, ipairs = pairs, ipairs
local Vector, Angle, Color = Vector, Angle, Color
local IsValid = IsValid
local TraceLine, TraceHull = util.TraceLine, util.TraceHull

local mtan = math.tan
local mabs, msin, mcos, mClamp, mrandom, mRand = math.abs, math.sin, math.cos, math.Clamp, math.random, math.Rand
local mceil, mfloor, msqrt, mrad, mdeg = math.ceil, math.floor, math.sqrt, math.rad, math.deg
local mmin, mmax = math.min, math.max
local mNormalizeAng = math.NormalizeAngle
local band, bor, bnot = bit.band, bit.bor, bit.bnot

serj.WeaponNames = {
    ["rust_ak47"] = "AK-47",
    ["rust_bolt"] = "Bolt Action",
    ["rust_m249"] = "M249",
    ["rust_lr300"] = "LR-300",
    ["rust_mp5"] = "MP5A4",
    ["rust_semi"] = "SAR",
    ["rust_thompson"] = "Thompson",
    ["rust_custom"] = "Custom SMG",
    ["rust_revolver"] = "Revolver",
    ["rust_python"] = "Python",
    ["rust_p250"] = "P250",
    ["rust_m92"] = "M92",
    ["rust_pump"] = "Pump Shotgun",
    ["rust_spas12"] = "SPAS-12",
    ["rust_waterpipe"] = "Waterpipe",
    ["rust_doublebarrel"] = "Double Barrel",
    ["rust_compound"] = "Compound Bow",
    ["rust_bow"] = "Hunting Bow",
    ["rust_crossbow"] = "Crossbow",
    ["rust_nailgun"] = "Nailgun",
    ["rust_eoka"] = "Eoka",
    ["rust_hatchet"] = "Hatchet",
    ["rust_pickaxe"] = "Pickaxe",
    ["rust_salvaged_axe"] = "Salvaged Axe",
    ["rust_salvaged_pickaxe"] = "Salvaged Pickaxe",
    ["rust_jackhammer"] = "Jackhammer",
    ["rust_chainsaw"] = "Chainsaw",
    ["rust_mace"] = "Mace",
    ["rust_longsword"] = "Longsword",
    ["rust_cleaver"] = "Cleaver",
    ["rust_combatknife"] = "Combat Knife",
    ["rust_buildingplan"] = "Building Plan",
    ["rust_toolcupboard"] = "Tool Cupboard",
    ["rust_hammer"] = "Hammer",
    ["weapon_physcannon"] = "Physgun",
    ["weapon_physgun"] = "Physgun",
    ["gmod_tool"] = "Toolgun",
    ["gmod_camera"] = "Camera",
}

function serj.GetWeaponPrintName(wep)
    if not IsValid(wep) then return "None" end
    local class = wep:GetClass()
    
    if serj.WeaponNames[class] then
        return serj.WeaponNames[class]
    end
    
    local name = wep:GetPrintName()
    if name == "Scripted Weapon" or name == "#GMod_ScriptedWeapon" or name == "" then
        return class
    end
    
    return name
end

local WeaponStats = {
    ["weapon_pistol"] = {bulletSpeed = 15000, dropScale = 1.0},
    ["weapon_semipistol"] = {bulletSpeed = 16000, dropScale = 1.0},
    ["weapon_revolver"] = {bulletSpeed = 14000, dropScale = 1.2},
    ["weapon_python"] = {bulletSpeed = 18000, dropScale = 1.1},
    ["weapon_mp5"] = {bulletSpeed = 20000, dropScale = 0.9},
    ["weapon_customsmg"] = {bulletSpeed = 19000, dropScale = 0.9},
    ["weapon_thompson"] = {bulletSpeed = 18000, dropScale = 0.9},
    ["weapon_semirifle"] = {bulletSpeed = 25000, dropScale = 0.8},
    ["weapon_assaultrifle"] = {bulletSpeed = 28000, dropScale = 0.7},
    ["weapon_lr300"] = {bulletSpeed = 27000, dropScale = 0.7},
    ["weapon_m39"] = {bulletSpeed = 26000, dropScale = 0.75},
    ["weapon_m92"] = {bulletSpeed = 24000, dropScale = 0.8},
    ["weapon_bolt"] = {bulletSpeed = 32000, dropScale = 0.5},
    ["weapon_l96"] = {bulletSpeed = 34000, dropScale = 0.5},
    ["weapon_m24"] = {bulletSpeed = 33000, dropScale = 0.5},
    ["weapon_pump"] = {bulletSpeed = 8000, dropScale = 2.5},
    ["weapon_doubleshotgun"] = {bulletSpeed = 8500, dropScale = 2.5},
    ["weapon_spas12"] = {bulletSpeed = 9000, dropScale = 2.5},
    ["weapon_m249"] = {bulletSpeed = 26000, dropScale = 0.8},
    ["weapon_nailgun"] = {bulletSpeed = 6000, dropScale = 3.0},
    ["weapon_neilgun"] = {bulletSpeed = 6000, dropScale = 3.0},
    ["rust_nailgun"] = {bulletSpeed = 6000, dropScale = 3.0},
}

local function GetBulletSpeed(weapon)
    if not IsValid(weapon) then return 20000 end
    local stats = WeaponStats[weapon:GetClass()]
    if stats then return stats.bulletSpeed end
    local nw = weapon:GetNWFloat("BulletSpeed", 0)
    if nw > 0 then return nw end
    return 20000
end

local function GetDropScale(weapon)
    if not IsValid(weapon) then return 1.0 end
    local stats = WeaponStats[weapon:GetClass()]
    if stats then return stats.dropScale end
    return 1.0
end

local predict_cache = {}

local TICK_INTERVAL = engine.TickInterval()
local me = LocalPlayer()

local surfaceSetDrawColor = surface.SetDrawColor
local surfaceDrawLine = surface.DrawLine
local surfaceDrawRect = surface.DrawRect
local surfaceSetTextColor = surface.SetTextColor
local surfaceSetTextPos = surface.SetTextPos
local surfaceSetFont = surface.SetFont
local surfaceDrawText = surface.DrawText
local surfaceGetTextSize = surface.GetTextSize
local surfaceDrawCircle = surface.DrawCircle
local surfaceDrawOutlinedRect = surface.DrawOutlinedRect

function serj.RainbowLine(x,y,w,h,speed)
	local hsv
	for i = 0,w do 
		hsv = HSVToColor( ( CurTime() * speed + i ) % 360, 1, 1 )
		surfaceSetDrawColor(hsv.r,hsv.g,hsv.b,255)
		surfaceDrawRect(x+i,y,1,h)
	end
end

function serj.inRect(x,y,w,h)
    local mousex, mousey = gui.MousePos();
    return(mousex < w && mousex > x && mousey < h && mousey > y);
end
    
local FindMetaTable = FindMetaTable;

local em = FindMetaTable"Entity";
local pm = FindMetaTable"Player";
local cm = FindMetaTable"CUserCmd";
local wm = FindMetaTable"Weapon";
local am = FindMetaTable"Angle";
local vm = FindMetaTable"Vector";

/*
	Other vars
*/

serj.garbage = false 
function serj.surfaceOutline(x,y,w,h,thikness,color)
	surfaceSetDrawColor(Color(color.r,color.g,color.b,color.a))
	surfaceDrawOutlinedRect(x,y,w,h,thikness)
end
serj.blur = Material 'pp/blurscreen'
function serj.blurPanel(pnl)
	local x, y = pnl:LocalToScreen(0, 0)
	surfaceSetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(serj.blur)
	for i = 1, 6 do
		serj.blur:SetFloat('$blur', (i / 3))
		serj.blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end
end
function serj.surfaceTexture(x,y,w,h,material,color,rot)
	if material == nil or material == "" then return end
    if rot == nil then
        surfaceSetDrawColor( color.r, color.g, color.b, color.a )
        surface.SetMaterial(Material(material))
        surface.DrawTexturedRect(x,y,w,h)
    else
        surfaceSetDrawColor( color.r, color.g, color.b, color.a )
        surface.SetMaterial(Material(material))
        surface.DrawTexturedRectRotated(x,y,w,h,rot)
    end
end

function draw.Circle( x, y, radius, seg , percent )
	local cir = {}
	if percent == nil then 	percent = 100 end
	percent = percent / 100.0
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ((( i / seg ) * -360) * percent ) + 180)
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	local a = math.rad( 0 )
	surface.DrawPoly( cir )
end

/*
	Console
*/

consoleLogs = {}
function serj.addLogs(text,color)
	table.insert(consoleLogs, {
        text,
        color.r,
        color.g,
        color.b,
		os.date("%X"),
    })
end

/*
    Fonts
*/
surface.CreateFont("hitlogs", {
    font = "Verdana",
    size = 15,
    antialias = true
})
surface.CreateFont( "font-02", {
	font = "Arial",
	extended = true,
	size = 16,
	weight = 800,
	antialias = true,
})
surface.CreateFont( "icon-font", {
	font = "menu_font",
	extended = true,
	size = 55,
	weight = 100,
	antialias = true,
})
surface.CreateFont( "font-01", {
	font = "Arial",
	extended = true,
	size = 14,
	weight = 650,
	antialias = true,
})
surface.CreateFont( "font-02", {
	font = "Arial",
	extended = true,
	size = 15,
	weight = 500,
	antialias = true,
    shadow = true,
})
surface.CreateFont( "font-03", {
	font = "Arial",
	extended = true,
	size = 13,
	weight = 1000,
	antialias = true,
    outline = true,
})
surface.CreateFont( "font-04", {
    size = 15,
    weight = 500,
    antialias = true,
    outline = true,
    font = "Arial",
})
surface.CreateFont( "THUDFONT", {
	font = "Arial",
	extended = true,
	size = 20,
	weight = 800,
	antialias = true,
    shadow = true,
})
surface.CreateFont( "IndicatorFont", {
	font = "Verdana",
	extended = true,
	size = 16,
	weight = 600,
	antialias = true,
    shadow = true,
})
surface.CreateFont( "KeybinderFont", {
	font = "Arial",
	extended = true,
	size = 14,
	weight = 1000,
	antialias = true,
})
    surface.CreateFont( "ESP Font", {
        font = "Verdana", 
        size = 12,
        weight = 500,
        antialias = false,
        outline = true,
    } )

/*
    Config
*/

serj.cfg = {
	["newcfg"] = "newcfg",
	Vars = {

		["aim_enable"] = false,
        ["eyes_e"] = false,
		["af_enable"] = false,
		["ar_enable"] = false,
		["aw_enable"] = false,
        ["sa_enable"] = true,
		["as_enable"] = false,
        ["ap_enable"] = false,
        ["ap_box"] = false,

		["res_enable"] = false,
		["res_step"] = 45,
        ["res_type"] = 1,
		["res_pitch"] = false,

        ["legit_trigger"] = false,
        ["legit_fov"] = false,
        ["legit_update"] = false,
        ["legit_fov_draw"] = false,
        ["legit_fov_val"] = 15,
        ["legit_smooth"] = false,
        ["legit_smooth_amount"] = 10,

        ["legit_spread_recoil"] = false,
        ["legit_rcs"] = 100,
        ["legit_scs"] = 100,


		["af_r"] = false,
		["servertime"] = false,

        ["aim_nospread"] = false,
        ["aim_norecoil"] = false,
        ["aim_nospread_alw"] = false,
        ["aim_norecoil_alw"] = false,

		["aimbot_ignore_bgod"] = false,
   		["aimbot_ignore_nodraw"] = false,
   		["aimbot_ignore_admin"] = false,
   		["aimbot_ignore_bots"] = false,
   		["aimbot_ignore_steam"] = false,
    	["aimbot_ignore_noclip"] = false,
    	["aimbot_ignore_team"] = false,
    	["aimbot_ignore_fr"] = false,

        ["backstab"] = false,

		["target_selection"] = 1,
		["hitbox_selection"] = 1,
		["baim_always"] = false,
		["baim_healthbased"] = false,
		["baim_healthbased_a"] = 65,
        ["bog_smerti_resolver_step"] = 666,
        --["samolet_tap"] = false,

		["hs_h"] = false,
		["hs_b"] = false,
		["hs_a"] = false,
		["hs_l"] = false,

		["aa_enable"] = false,
		["yaw_base"] = 1,
		["yaw_real"] = 1,
		["yaw_fake"] = 1,
		["yaw_invert"] = false,
		["pitch"] = 1,

		["c_pitch"] = 1,
		["c_ryaw"] = 1,
		["c_fyaw"] = 1,
		["antiaim_jitterrange"] = 15,
		["antiaim_spinspeed"] = 32,

        ["pitch_zero_land"] = false, 
        ["invert_on_shot"] = false, 

		["edge_enable"] = false,
        ["edge_side"] = 1,

		["lby"] = false,
		["fake_flick"] = false,
		["anti_brute"] = false,
		["avoid_overlap"] = false,
        ["avoid_overlap_add"] = 1,
		["extend_desync"] = false,
		["aa_autodir"] = false,

		["aa_off_ladder"] = false,
		["aa_off_use"] = false,

		["dancer"] = false,
		["dance"] = 1,

		["fl_enable"] = false,
        ["fl_peek"] = false,
		["fl_mode"] = 1,
		["fl_maxchoke"] = 14,
		["fl_ladder"] = false,
		["fl_use"] = false,

		["misc_hitsound"] = false,
		["misc_hitsound_sound"] = 1,

        ["misc_3rdp"] = false,
        ["misc_3rdp_d"] = 10,
        ["misc_3rdp_s"] = 25,
        ["misc_ofov"] = false,
        ["misc_ofov_v"] = 90,
        ["misc_3rdp_coll"] = false,
        ["misc_shakeoverride"] = false,
        ["misc_msa"] = false,

		["misc_hitsound"] = false,
        ["misc_hitsound_method"] = 1,
        ["misc_hitsound_sound"] = 1,
        ["misc_killsound"] = false,
        ["misc_killsound_ks"] = false,
        ["misc_killsound_sound"] = 1,

		["dance_spam_kt"] = false,

		["misc_chatspam"] = false,
        ["misc_killsay"] = false,
        ["misc_killsay_o"] = false,
        ["misc_killsay_lang"] = 1,
        ["misc_chatspam_ar"] = false,
        ["misc_chatspam_lang"] = 1,
        ["misc_chatspam_timer"] = 1,
        ["MAMBETIEBANIE"] = true,
        ["misc_chat_timer"] = 1,
        ["misc_chatbot"] = false,
        ["misc_avtoobsh"] = false,
        ["allah_damage_force"] = false,

		["move_bhop"] = false,
        ["move_fixmovement"] = false,
        ["move_keepsprint"] = false,
        ["move_ap"] = false,
        ["move_ap_ar"] = false,
        ["move_ap_s"] = 1,
        ["move_ap_sp"] = false,
        ["move_ap_apb"] = false,
        ["move_ap_anim"] = false,
        ["move_strafe"] = false,
        ["move_strafe_backward"] = false,
        --["move_ls"] = false,
        ["move_autodir"] = false,
        ["move_gstrafe"] = false,
        ["move_circle_strafe"] = false,
        --["move_auto_rasprig"] = false,
        ["move_add_speed"] = false,
        --["move_awalls"] = false,

        ["move_ad"] = false,

        ["move_fd"] = false,
        ["move_fd_m"] = 1,
        ["predict"] = true,
        ["predict_amount"] = 100,
        ["predict_smooth_val"] = 72,
        ["predict_iters"] = 5,
        ["predict_ping"] = true,
        ["predict_gravity"] = true,
        ["predict_debug"] = false,

        ["move_sw"] = false,
        ["move_sws"] = 10,
        ["move_ds"] = false,
        ["move_aw"] = false,
        ["move_aw_d"] = false,

        ["move_aw_len"] = 100,
        ["move_aw_speed"] = 2500,

		["oof_arrows"] = false,
        ["oof_arrows_d"] = false,
        ["oof_arrows_b"] = false,
        ["oof_arrows_bs"] = 2,
        ["oof_arrows_as"] = 10,
        ["oof_arrows_ad"] = 25,

        ["hit_effect"] = false,

        ["esp_box_r"] = false,
        ["esp_box_grad_r"] = false,
        ["esp_box_f_r"] = false,

        ["esp_box"] = false,
        ["esp_box_grad"] = false,
        ["esp_box_f"] = false,
        ["esp_box_type"] = 1,
        ["esp_box_fr"] = false,
        ["esp_box_trg"] = false,
        ["esp_box_team"] = false,
        ["esp_skeleton"] = false,
        ["esp_mambet"] = true,

        ["esp_name"] = false,
        ["esp_wep"] = false,
        ["esp_hp"] = false,
        ["esp_ap"] = false,
        ["esp_team"] = false,
        ["esp_group"] = false,
        ["esp_money"] = false,
        ["esp_active_weapon"] = false,
        ["esp_hotbar"] = false,
        ["esp_active_mode"] = 1, -- 1: Text, 2: PNG



        ["esp_hp_bar"] = false,
        ["esp_hp_bar_ac"] = false,
        ["esp_hp_bar_gradient"] = false,

        ["chams_visible"] = false,
        ["chams_visible_att"] = false,
        ["chams_invisible"] = false,
        ["chams_invisible_att"] = false,
        ["chams_hand"] = false,
        ["chams_ragdolls"] = false,

        ["chams_visible_mat"] = 1,
        ["chams_invisible_mat"] = 1,
        ["chams_hand_mat"] = 1,
        ["chams_ragdolls_mat"] = 1,
         

        ["fake_chams"] = false,
        ["real_chams"] = false,
        ["fakelag_chams"] = false,
        ["real_chams_real"] = false,

        ["paganie_strelochki"] = false,

        ["glow_esp"] = false,
        ["glow_esp_a"] = false,
        ["glow_esp_att"] = false,  
        
        ["fake_chams_m"] = 1,
        ["real_chams_m"] = 1,
        ["fakelag_chams_m"] = 1,

		["misc_hitmarker"] = false,
        ["misc_hitmarker_pos"] = 1,

        ["misc_inds"] = false,
        ["misc_inds_grad"] = false,
        ["misc_inds_r"] = 5,
        ["misc_inds_hsv"] = false,
        ["misc_inds_hsv_g"] = false,
        ["misc_inds_s"] = 1,

        ["misc_heartmarker"] = false,
        ["misc_heartmarker_color"] = 1,
        
        ["jumpcircle"] = false,
        ["LGBT"] = false,
        ["misc_bullettrace"] = false,
        ["misc_bullettrace_type"] = 1,
        ["misc_bullettrace_blinking"] = false,
        ["misc_bullettrace_time"] = 1,

        ["misc_bulletimpact"] = false,
        ["misc_bulletimpact_time"] = 3,
        ["misc_bulletimpact_glow"] = false,

        ["misc_bullettrace_e"] = false,
        ["misc_bullettrace_type_e"] = 1,
        ["misc_bullettrace_blinking_e"] = false,
        ["misc_bullettrace_time_e"] = 1,

        ["misc_bulletimpact_e"] = false,
        ["misc_bulletimpact_time_e"] = 3,
        ["misc_bulletimpact_glow_e"] = false,

        ["misc_bullettrace_onlyt"] = false,

        ["misc_so2_hands"] = false,
        ["cupboardesp"] = false,
        ["sleepingbagesp"] = false,
        ["turretesp"] = false,
        ["structureesp"] = false,
        ["dooresp"] = false,
        ["oreesp"] = false,
        ["stone"] = false,
        ["metal"] = false,
        ["showsulfur"] = false,
        ["entityinfo"] = false,
        ["hempesp"] = false,
        ["barrelesp"] = false,
        ["largewoodboxesp"] = false,
        ["landmineesp"] = false,

        ["cupboardcolor"] = "139 90 43 255",
        ["sleepingbagcolor"] = "100 200 100 255",
        ["turretcolor"] = "255 50 50 255",
        ["structurecolor"] = "255 255 255 255",
        ["doorcolor"] = "255 255 255 255",
        ["stonecolor"] = "128 128 128 255",
        ["metalcolor"] = "255 100 100 255",
        ["sulfurcolor"] = "255 255 0 255",
        ["hempcolor"] = "0 255 0 255",
        ["barrelcolor"] = "205 133 63 255",
        ["largewoodboxcolor"] = "222 184 135 255",

        ["wall_color"] = false,
        ["prop_color"] = false,

        ["sky_3d"] = false,
        ["sky_b"] = false,
        ["sky_f"] = false,
        ["sky_c"] = false,
        ["skyboxname"] = "sky_day01_09",
        ["sky_ch"] = false,

        ["fall_predict"] = false,
        ["csgo_bscope"] = false,
        ["csgo_bscope_dl"] = false,
        ["csgo_bscope_alt"] = false,
        ["viewmodel_wireframe"] = false,

        ["fog_e"] = false,
        ["fog_s"] = 0,
        ["fog_end"] = 1000,
        ["fog_d"] = 0.3,
        ["skininput"] = "models/wireframe",

        ["misc_viewmodel"] = false,
        ["viewmodel_flip"] = false,
        ["viewmodel_flip_e"] = false,
        ["misc_bob"] = false,
        ["misc_sway"] = false,
        ["misc_vm_x"] = 0,
        ["misc_vm_y"] = 0,
        ["misc_vm_z"] = 0,
        ["misc_vm_p"] = 0,
        ["misc_vm_ya"] = 0,
        ["misc_vm_r"] = 0,

        ["i_s"] = 1,
        ["i_f"] = 1,
        ["i_a"] = 1,

        ["i_static"] = false,
        ["i_mine_ast"] = false,

        ["i_watermark"] = false,
        ["estetika"] = false,
        ["estetika_num"] = 25,
        ["estetika_r"] = false,
        ["estetika_fill"] = false,
        ["i_indicators"] = false,
        ["i_indicators_fps"] = false,
        ["i_keybinds"] = false,
        ["i_keybinds_x"] = 5,
        ["i_keybinds_y"] = 255,
        ["i_targethud"] = false,
        ["i_targethud_x"] = scrw/2-150,
        ["i_targethud_y"] = scrh/2+150,

        ["i_ignore_ks"] = false,

        ["logs_enable"] = false,

        ["logs_connects"] = false,
        ["logs_hurt"] = false,
        ["logs_misses"] = false,
        ["logs_kills"] = false,

        ["logs_pos"] = 1,
        ["logs_autocolor"] = false,

        ["ch_e"] = false,
        ["ch_type"] = 1,
        ["ch_size"] = 1,

        ["color_modify"] = false,
        ["self_trail"] = false,
        ["hand_glow"] = false,
        ["hand_glow_a"] = false,
        ["hand_glow_r"] = false,

        [ "pp_colour_addr" ] = 0.02,
        [ "pp_colour_addg" ] = 0.02,
        [ "pp_colour_addb" ] = 0,
        [ "pp_colour_brightness" ] = 0,
        [ "pp_colour_contrast" ] = 1,
        [ "pp_colour_colour" ] = 3,
        [ "pp_colour_mulr" ] = 0,
        [ "pp_colour_mulg" ] = 0.02,
        [ "pp_colour_mulb" ] = 0,

        ["motion_blur"] = false,
        [ "mb_aa" ] = 0.4,
        [ "mb_da" ] = 0.8,
        [ "mb_d" ] = 0.01,

        ["motion_blur_e"] = false,
        [ "emb_h" ] = 1,
        [ "emb_v" ] = 2,
        [ "emb_f" ] = 3,
        [ "emb_r" ] = 4,

        ["skininput"] = "!glow_additive",
        ["modelinput"] = "models/weapons/v_toolgun.mdl",
        ["dprot_e"] = false,

        ["dprot_file_lyb"] = false,
        ["dprot_data_clear"] = false,
        ["dprot_data_clear_"] = 1,
        ["dprot_html"] = false,
        ["dprot_qmenu"] = false,
        ["dprot_http"] = false,
        ["dprot_dupes"] = false,
        ["dprot_sql"] = false,
        ["dprot_cg"] = false,
        ["dprot_sw"] = false,
        ["dprot_clcgameui"] = false,

        ["cpp_ruka"] = false,
        ["cpp_ebanina"] = false,
        ["cpp_ruka_prikol"] = 1,

        ["use_spam"] = false,

	},
	Colors = {
        ["hand_glow"] = "15 255 15 255",
        ["logs_hurt"] = "255 15 15 255",
        ["chams_ragdolls"] = "255 255 255 255",
        ["legit_fov_draw"] = "255 25 25 255",
        ["chams_hand"] = "255 255 255 255",
        ["estetika"] = "255 255 255 255",
        ["estetika_fill"] = "35 5 5 245",
        ["ch_e"] = "0 255 0 255",
        ["logs_enable"] = "255 25 128 255",
        ["i_watermark"] = "255 255 255 255",
        ["i_keybinds"] = "255 125 45 255",
		["as_enable"] = "255 255 255 255",
        ["ap_enable"] = "255 75 75 255",
		["viewmodel_wireframe"] = "255 0 0 255",
        ["move_ap"] = "255 25 128 255",
        ["csgo_bscope"] = "255 128 128 215",
        ["sky_f"] = "128 128 128 255",
        ["fog_e"] = "128 128 255 255",
        ["sky_c"] = "128 128 255 255",
        
        ["wall_color"] = "255 255 255 255",
        ["prop_color"] = "0 0 0 128",
        
        ["oof_arrows"] = "255 0 0 255",
        ["oof_arrows_d"] = "128 128 128 128",

        ["glow_esp"] = "255 0 0 255",

        ["misc_inds"] = "0 255 0 255",
        ["misc_inds_grad"] = "255 0 0 255",

        ["chams_visible"] = "0 255 0 255",
        ["chams_invisible"] = "255 0 0 255",

        ["esp_hp_bar"] = "0 255 0 255",
        ["esp_hp_bar_gradient"] = "255 0 0 255",
        ["esp_wep"] = "255 255 255 255",
        ["esp_name"] = "255 255 255 255",
        ["esp_hp"] = "25 255 25 255",
        ["esp_ap"] = "100 100 255 255",
        ["esp_box"] = "255 255 255 255",
        ["esp_box_grad"] = "255 25 25 85",
        ["esp_box_f"] = "255 255 255 55",
        ["esp_box_fr"] = "0 255 0 255",
        ["esp_box_trg"] = "255 0 200 255",
        ["esp_skeleton"] = "255 255 255 255",
        ["esp_group"] = "255 0 0 255",
        ["esp_money"] = "15 255 45 255",
        ["esp_active_weapon"] = "255 255 255 255",

        

        ["misc_hitmarker"] = "255 255 255 255",
        ["misc_heartmarker"] = "255 255 255 255",

        ["misc_bullettrace"] = "25 25 255 200",

        ["fake_chams"] = "255 45 45 200",
        ["real_chams"] = "45 255 45 200",
        ["fakelag_chams"] = "2 183 255 200",

        ["misc_bulletimpact"] = "25 25 255 200",
        ["misc_bullettrace_e"] = "255 25 25 200",
        ["misc_bulletimpact_e"] = "255 25 25 200",
        ["aimbot_snapline"] = "255 255 255 255",
	},
	Keybinds = {
        showInBinds = {
            ["baim_key"] = true,
            ["key_tp"] = true,
            ["key_cstrafe"] = true,
            ["key_fd"] = true,
            ["key_ap"] = true,      
            ["key_aw"] = true,
            ["key_sw"] = true,
            ["ebanina_exploit"] = true,
            ["backstab"] = true,
            ["aim_enable"] = true,
            ["yaw_invert"] = true,
        },
        mode = {
            ["baim_key"] = 1,
            ["yaw_invert"] = 2,
            ["key_tp"] = 1,
            ["key_cstrafe"] = 1,
            ["key_fd"] = 1,
            ["key_ap"] = 1,      
            ["key_aw"] = 1,
            ["key_sw"] = 1,
            ["ebanina_exploit"] = 1,
            ["backstab"] = 1,
            ["aim_enable"] = 1,
        },
		["baim_key"] = 0,
		["key_tp"] = 0,
        ["key_cstrafe"] = 0,
        ["key_fd"] = 0,
        ["key_ap"] = 0,      
        ["key_aw"] = 0,
        ["key_sw"] = 0,
        ["ebanina_exploit"] = 0,
        ["backstab"] = 0,
        ["aim_enable"] = 0,
        ["yaw_invert"] = 0,
	},
	Cvarmanager = {},
	Spoofedcvars = {},
	gunSkins = {},
    gunModels = {},
	["friends"] = {},
    ["forcedpitch"] = {},
    AdaptiveConfig = {},
}
serj.cfg.Colors["menu_color"] = "123 255 22 255"

serj.activebinds = {
    ["baim_key"] = false,
    ["key_tp"] = false,
    ["key_cstrafe"] = false,
    ["key_fd"] = false,
    ["key_ap"] = false,      
    ["key_aw"] = false,
    ["key_sw"] = false,  
    ["ebanina_exploit"] = false,  
    ["backstab"] = false,
    ["aim_enable"] = false,
    ["yaw_invert"] = false,
}
serj.translateKeybinds = {
    name = {
        ["baim_key"] = "Body aim",
        ["key_tp"] = "Thirdperson",
        ["key_cstrafe"] = "Circle strafe",
        ["key_fd"] = "Fake duck",
        ["key_ap"] = "Autopeak",      
        ["key_aw"] = "Avoid walls",
        ["key_sw"] = "Slowwalk", 
        ["ebanina_exploit"] = "Ebaninochka", 
        ["backstab"] = "Force Backstab",
        ["aim_enable"] = "Aimbot",
        ["yaw_invert"] = "Invert Yaw",
    },
    mode = {
        [1] = "Hold",
        [2] = "Toggle",
    }
}
///////////////////////////////////////
///////// ТЮРЬМА НАВАЛЬНАГО ///////////
///////////////////////////////////////
serj.screenShake = util.ScreenShake
serj.oldCreateDir = file.CreateDir
serj.oldFileDelete = file.Delete
serj.oldFileWrite = file.Write
serj.oldFileExists = file.Exists
serj.oldFileFind = file.Find
serj.oldFileOpen = file.Open

serj.oldSqlBegin = sql.Begin
serj.oldSqlCommit = sql.Commit
serj.oldSqlQuery = sql.Query
serj.oldSqlQueryRow = sql.QueryRow
serj.oldSqlQueryValue = sql.QueryValue

serj.oldSpawnMenu1 = spawnmenu.DoSaveToTextFiles
serj.oldSpawnMenu2 = spawnmenu.SaveToTextFiles

serj.oldOpenDupe = engine.OpenDupe
serj.oldWriteDupe = engine.WriteDupe

local fm = FindMetaTable"File"

serj.OldSeek = fm.Seek
serj.OldSize = fm.Size
serj.OldWriteBool = fm.WriteBool
serj.OldReadFloat = fm.ReadFloat

local pnl = FindMetaTable"Panel"

serj.OldHTML = pnl.SetHTML
serj.OldOpenURL = pnl.OpenURL
serj.OldGuiOpenUrl = gui.OpenURL
serj.OldJSOnetapCrack2022 = pnl.RunJavascript

serj.oldCG = collectgarbage

serj.oldSteamWorksDownload = steamworks.Download
serj.oldSteamWorksDownloadUGC = steamworks.DownloadUGC
serj.oldSteamWorksSub = steamworks.IsSubscribed
serj.oldSteamWorksOW = steamworks.OpenWorkshop
serj.oldSteamWorksReq = steamworks.RequestPlayerInfo
serj.oldSteamWorksSMA = steamworks.ShouldMountAddon

serj.OldHttpFetch = http.Fetch
serj.OldHttpPost = http.Post

serj.oldguiHide = gui.HideGameUI
serj.oldguiActivate = gui.ActivateGameUI
serj.oldClicker = gui.EnableScreenClicker

local ctdi = FindMetaTable"CTakeDamageInfo"

serj.oldDamageForce = ctdi.SetDamageForce 
serj.oldDamageType = ctdi.SetDamageType


///////////////////////////////////////


files, dir = serj.oldFileFind( "serj/*.json", "DATA" )
serj.cfgDropdown = nil
serj.loadedCfg = {}
serj.verifyconfig = serj.cfg
function serj.VerifyConfig() 
    for k, v in pairs(serj.verifyconfig) do
		if serj.cfg[k] == nil then
			serj.cfg[k] = serj.verifyconfig[k]
            serj.addLogs("cfg table differs from new!",Color(255,87,87))
        end
	end
    for k, v in pairs(serj.verifyconfig.Vars) do
		if serj.cfg.Vars[k] == nil then
			serj.cfg.Vars[k] = serj.verifyconfig.Vars[k]
            serj.addLogs("cfg var table differs from new!",Color(255,87,87))
        end
	end
	for k, v in pairs(serj.verifyconfig.Colors) do
		if serj.cfg.Colors[k] == nil then
			serj.cfg.Colors[k] = serj.verifyconfig.Colors[k]
            serj.addLogs("color table differs from new!",Color(255,87,87))
		end
	end
	for k, v in pairs(serj.verifyconfig.Keybinds) do
		if serj.cfg.Keybinds[k] == nil then
			serj.cfg.Keybinds[k] = serj.verifyconfig.Keybinds[k]
            serj.addLogs("keybind table differs from new!",Color(255,87,87))
		end
	end
    if serj.cfg.Keybinds["yaw_invert"] == nil then serj.cfg.Keybinds["yaw_invert"] = 0 end
    if serj.cfg.Keybinds.mode["yaw_invert"] == nil then serj.cfg.Keybinds.mode["yaw_invert"] = 2 end
    if serj.cfg.Keybinds.showInBinds["yaw_invert"] == nil then serj.cfg.Keybinds.showInBinds["yaw_invert"] = true end
end

function serj.SaveConfig()
	if serj.cfgDropdown:GetSelected() == nil then return end	
	local selected = serj.cfgDropdown:GetSelected()
	local JSONconfig = util.TableToJSON(serj.cfg, true)
	serj.oldFileWrite("serj/"..selected, JSONconfig) 
    serj.addLogs("Config saved!",Color(107,255,87))
end
function serj.CloseFrame()
	RememberCursorPosition()
	serj.Panels.framex, serj.Panels.framey = serj.Panels.frame:GetPos()
    serj.Panels.framew, serj.Panels.frameh = serj.Panels.frame:GetWide(), serj.Panels.frame:GetTall()
	serj.Panels.frame:Remove()
	serj.Panels.frame = false
    if IsValid(serj.Panels.topPanel) then serj.Panels.topPanel:Remove() end
    serj.Panels.topPanel = nil
end
function serj.LoadConfig()

	if serj.cfgDropdown:GetSelected() == nil then return end

	local selected = serj.cfgDropdown:GetSelected()
	local JSONconfig = file.Read("serj/"..selected, "DATA")
    if JSONconfig == "" then 
        serj.addLogs("CONFIG TABLE IS NIL!",Color(255,0,0))
    end
    if JSONconfig == "" then return end
	serj.cfg = util.JSONToTable(JSONconfig)

	serj.VerifyConfig()

	serj.loadedCfg[0] = selected
	for k, v in ipairs(files) do
		if v == selected then
			serj.loadedCfg[1] = k
		end
	end

	serj.CloseFrame()
	OpenGUI()

    serj.addLogs("Config loaded!",Color(87,255,255))
end

function serj.CreateConfig()
	if serj.cfg["newcfg"] == nil then return end
	if serj.oldFileExists("serj/"..serj.cfg["newcfg"]..".json", "DATA") then return end
	local JSONconfig = util.TableToJSON(serj.cfg, true)
	serj.oldCreateDir("serj")
	serj.oldFileWrite("serj/"..serj.cfg["newcfg"]..".json", JSONconfig)

	serj.CloseFrame()
	OpenGUI()

    serj.addLogs("Config created!",Color(93,255,87))
end

function serj.DeleteConfig()
	if serj.cfgDropdown:GetSelected() == nil then return end
	
	local selected = serj.cfgDropdown:GetSelected()
	serj.oldFileWrite("serj/"..selected)

	serj.loadedCfg = {}

	serj.CloseFrame()
	OpenGUI()

    serj.addLogs("Config deleted!",Color(255,87,87))
end
/*
	Materials
*/

CreateMaterial( "MovingWireframe", "VertexLitGeneric",
{
    ["$basetexture"] = "sprites/physbeam",
    ["$nodecal"] = 1,
    ["$model"] = 1,
    ["$additive"] = 1,
    ["$nocull"] = 1,
    ["$wireframe"] = 1,
        
    ["proxies"] = {
        ["texturescroll"] = {
            ["texturescrollvar"] = "$basetexturetransform",
            ["texturescrollrate"] = "0.4",
            ["texturescrollangle"] = "90",
        }
    }
})

CreateMaterial("textured", "VertexLitGeneric") 
CreateMaterial("flat", "UnLitGeneric")
CreateMaterial("flat_z", "UnLitGeneric",{["$ignorez"] = 1})
CreateMaterial("textured_z", "VertexLitGeneric",{["$ignorez"] = 1})
CreateMaterial( "glowcham2", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "0",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
} )
CreateMaterial( "glowcham2_z", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "0",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
    ["$ignorez"] = 1,
} )
CreateMaterial( "glow_additive", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "1",
    ["$nodecal"] = "1",
    ["$additive"] = "1",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
} )
CreateMaterial( "glow_additive_z", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "1",
    ["$nodecal"] = "1",
    ["$additive"] = "1",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0 0.3 0.6]",
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
CreateMaterial("glass", "VertexLitGeneric", {
	["$phong"] = 1,
	["$bumpmap"] = "sprites/physbeama",
	["$phongexponent"] = 5,			
	["$phongexponenttexture"] =	"sprites/physbeama",	
	["$phongboost"] = 1.0,
	["$phongfresnelranges"] = "[0 0.5 1]",
})
CreateMaterial("glass_z", "VertexLitGeneric", {
    ["$ignorez"] = 1,
	["$phong"] = 1,
	["$bumpmap"] = "sprites/physbeama",
	["$phongexponent"] = 5,			
	["$phongexponenttexture"] =	"sprites/physbeama",	
	["$phongboost"] = 1.0,
	["$phongfresnelranges"] = "[0 0.5 1]",
})
/*
    Panels
*/

serj.Panels = {
    frame = false,
	framex = 15,
	framey = 15,
	framew = 800,
	frameh = 725,
    colorPicker = false,
    adapCfg = false,
    binder = false,
	saved = "aim",
}
serj.Expanded = {}
serj.Expanded["aim"] = false
serj.Expanded["camera"] = false
serj.Expanded["hitmarker"] = false
serj.Expanded["bullettrace"] = false
serj.Expanded["bullettrace_e"] = false
serj.Expanded["visual_self"] = false
serj.Expanded["aimbottarget"] = false
serj.Expanded["aimbotfilter"] = false
serj.Expanded["airstrafe"] = false
serj.Expanded["player_box"] = false
serj.Expanded["esp_elements"] = false
serj.Expanded["esp_elements_bars"] = false
serj.Expanded["chams"] = false
serj.Expanded["aw"] = false
serj.Expanded["flaa"] = false
serj.Expanded["aa"] = false
serj.Expanded["aaaa"] = false
serj.Expanded["chat"] = false
serj.Expanded["visual_selfaa"] = false
serj.Expanded["oofarrows"] = false
serj.Expanded["world"] = false
serj.Expanded["world1"] = false
serj.Expanded["ap"] = false
serj.Expanded["vm"] = false
serj.Expanded["adapcfg"] = false
serj.Expanded["crosshair"] = false
serj.Expanded["color_mod"] = false
serj.Expanded["mblur"] = false
serj.Expanded["dprot"] = false
serj.Expanded["huevini"] = false
serj.Expanded[""] = false
serj.Expanded[""] = false
serj.Expanded[""] = false


function serj.PanelPaint(pan,name,w,h)
	-- Проверяем видимость панели
	if pan and not pan:IsVisible() then return end
	
	surfaceSetDrawColor(40,40,40,200)
	surfaceDrawRect(0,0,w,h)
	surfaceSetDrawColor(10,15,10,200)
	surfaceDrawRect(2,2,w-4,h-4)
	surfaceSetDrawColor(255,255,255)

	if name != nil then
		surfaceSetTextColor(255,255,255)
		surfaceSetTextPos(5,5)
		surfaceSetFont("font-02")
		surfaceDrawText(name)
	end
end

function serj.guiWebPlayer(name, url, pan)
    local p = pan:Add("DPanel")
    p:Dock(TOP)
    p:DockMargin(15, 5, 15, 0)
    p:SetTall(36)
    p.Paint = function() end

    local b = p:Add("DButton")
    b:Dock(FILL)
    b:DockMargin(4, 4, 4, 4)
    b:SetText("")

    b.Paint = function(s, w, h)
        local accent = string.ToColor(serj.cfg.Colors["menu_color"])
        surfaceSetDrawColor(35, 35, 35)
        surfaceDrawRect(0, 0, w, h)
        serj.surfaceTexture(0, 0, w, h, "gui/gradient_up", Color(0, 0, 0, 55))
        serj.surfaceOutline(0, 0, w, h, 1, Color(12, 12, 12))
        serj.surfaceOutline(1, 1, w - 2, h - 2, 1, Color(50, 50, 50))
        
        if s:IsHovered() then
            surfaceSetDrawColor(accent.r, accent.g, accent.b, 20)
            surfaceDrawRect(1, 1, w - 2, h - 2)
        end
        
        draw.SimpleText(name, "font-02", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    b.DoClick = function()
        local frame = vgui.Create("DFrame")
        frame:SetSize(800, 500)
        frame:Center()
        frame:SetTitle("Web Player - " .. name)
        frame:MakePopup()
        frame:SetSizable(true)
        frame:SetMinWidth(400)
        frame:SetMinHeight(300)
        
        frame.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25))
            surfaceSetDrawColor(45, 45, 45, 255)
            surfaceDrawRect(0, 0, w, 24)
            serj.surfaceOutline(0, 0, w, h, 1, Color(12, 12, 12))
        end

        local html = vgui.Create("DHTML", frame)
        html:Dock(FILL)
        html:SetAllowLua(true)
        -- Передаем фокус при создании
        html:RequestFocus()
        
        -- Универсальная обработка ссылок
        local final_url = url
        if string.find(url, "youtube.com/watch?v=") then
            final_url = string.gsub(url, "watch%?v=", "embed/")
        elseif string.find(url, "youtu.be/") then
            final_url = string.gsub(url, "youtu.be/", "youtube.com/embed/")
        end
        
        html:OpenURL(final_url)

        -- Кнопка для ручного ввода URL (внизу)
        local urlBar = vgui.Create("DTextEntry", frame)
        urlBar:SetTall(25)
        urlBar:Dock(BOTTOM)
        urlBar:SetPlaceholderText("Enter URL here...")
        urlBar:SetText(url)
        urlBar.OnEnter = function(self)
            local newUrl = self:GetValue()
            if not string.find(newUrl, "://") then newUrl = "http://" .. newUrl end
            html:OpenURL(newUrl)
        end

        -- Кнопки навигации (вверху)
        local navPanel = vgui.Create("DPanel", frame)
        navPanel:SetTall(24)
        navPanel:Dock(TOP)
        navPanel.Paint = function(s,w,h)
            surfaceSetDrawColor(35,35,35)
            surfaceDrawRect(0,0,w,h)
            surfaceSetDrawColor(60,60,60)
            surfaceDrawRect(0,h-1,w,1)
        end

        local function createNavBtn(txt, wide, press)
            local btn = vgui.Create("DButton", navPanel)
            btn:SetText(txt)
            btn:Dock(LEFT)
            btn:SetWide(wide)
            btn:SetTextColor(color_white)
            btn.DoClick = press
            btn.Paint = function(s,w,h)
                if s:IsHovered() then surfaceSetDrawColor(80,80,80) else surfaceSetDrawColor(50,50,50) end
                surfaceDrawRect(2,2,w-4,h-4)
                serj.surfaceOutline(2,2,w-4,h-4,1,color_black)
            end
        end

        createNavBtn("<", 30, function() html:GoBack() end)
        createNavBtn(">", 30, function() html:GoForward() end)
        createNavBtn("Reload", 60, function() html:Refresh() end)
        createNavBtn("Home", 60, function() html:OpenURL(url) end)
        createNavBtn("Google", 60, function() html:OpenURL("https://www.google.com") end)

        html:RequestFocus()
        function html:OnMousePressed()
            self:RequestFocus()
        end
    end
end

function serj.guiButton(name,func,pan,centered)
	local p = pan:Add("DPanel")
	p:Dock(TOP)
    if centered then
	    p:DockMargin(15,5,15,0)
    else
        p:DockMargin(32,5,0,0)
    end
	p:SetTall(36)
    p:SetWide(200)
	p.Paint = function() end

	local b = p:Add("DButton")
	b:Dock(FILL)
	b:DockMargin(4,4,4,4)
	b:SetText("")

	b.Paint = function(s,w,h)
        surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
		serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
		draw.SimpleText(name,"font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	b.DoClick = function()
		func()
	end
end

function serj.guiSelector(name,pan,show,savename)
    local b = vgui.Create("DButton",pan)
    b:Dock(TOP)
    b:SetTall(96)
    b:SetText("")
    b:DockMargin(0,3,0,0)

    b.Paint = function(s,w,h)
		if serj.Panels.saved == savename then
            surfaceSetDrawColor(0,0,0)
            surfaceDrawRect(0,0,w-1,h)
			surfaceSetDrawColor(40,40,40)
            surfaceDrawRect(0,1,w,h-2)
            -- serj.surfaceTexture(0,2,w,h-4,"tabbackground.png",color_white)
            surfaceSetDrawColor(35,35,35,255)
            surfaceDrawRect(0,2,w,h-4)
		end

		if serj.Panels.saved == savename then
        	draw.SimpleText(name,"icon-font",w/2,h/2,Color(210,210,210),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(name,"icon-font",w/2,h/2,Color(90,90,90),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
    end

    b.DoClick = function()
        hidePanels()
        serj.Panels.saved = savename
        show:Show()
    end
end

function serj.CreateTextInput(lbl, cfgg, config, chars, par, centered)
	local p = vgui.Create("DPanel",par)
	p:Dock(TOP)
    if centered then
	    p:DockMargin(18,5,15,0)
    else
        p:DockMargin(36,5,0,0)
    end
	p:SetTall(36)
	p.Paint = function(s,w,h)
		surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w-4,h)
        serj.surfaceTexture(0,0,w-4,h,"gui/gradient_up",Color(0,0,0,55))
		serj.surfaceOutline(0,0,w-4,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-4-2,h-2,1,Color(50,50,50))
	end

	local x, y = p:GetPos()
	local w, h = p:GetSize()
	
	local textInput = p:Add("DTextEntry")
	textInput:Dock(FILL)
	textInput:DockMargin(10,10,10,10)
	textInput:IsMultiline( false )
	textInput:SetMaximumCharCount(chars)
	textInput:SetPlaceholderText(lbl)
	textInput:SetFont( "font-02" )
    textInput:SetPaintBackground(false)
    textInput:SetTextColor(Color(255,255,2555))

	if cfgg[config] != nil and cfgg[config] != "" then
		textInput:SetValue(cfgg[config])
	end

	textInput.Think = function()
		if textInput:IsEditing() then
			editingText	= true
		else
			editingText = false
		end
		cfgg[config] = textInput:GetValue()
	end 

	textInput.OnValueChange = function()
		cfgg[config] = textInput:GetValue()
	end
end

function serj.drawRect(x,y,w,h,color)
    surfaceSetDrawColor(color) 
    surfaceDrawRect(x, y, w, h)
end

function serj.labelColor(name,config,panel)
	local p = panel:Add("DPanel")
	p:Dock(TOP)
	p:SetTall(22)
	p:DockMargin(5,5,5,0)

	p.Paint = function(sereja, krutoi, chuvak)
		draw.SimpleText(name,"font-02",30,chuvak/2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

    local b = p:Add("DButton")
    b:Dock(RIGHT)
    b:DockMargin(0,5,15,5)
    b:SetText("")
    b:SetWide(25)

    b.Paint = function(s,w,h)
        local mycolor = string.ToColor(serj.cfg.Colors[config])
        serj.surfaceTexture(0,0,w,h,"gui/alpha_grid.png",Color(128,128,128,255))
        draw.RoundedBox(0,0,0,w,h,Color(mycolor.r,mycolor.g,mycolor.b,mycolor.a))
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(mycolor.r-55,mycolor.g-55,mycolor.b-55,mycolor.a))
        serj.surfaceOutline(0,0,w,h,1,color_black)		
    end

    b.DoClick = function()
        local mousex, mousey = input.GetCursorPos()
        if IsValid(serj.Panels.colorPicker) then
            serj.Panels.colorPicker:Remove()
        end
        
        serj.Panels.colorPicker = vgui.Create("DFrame")
        serj.Panels.colorPicker:SetSize(300, 225)
        serj.Panels.colorPicker:SetTitle(" ")
        serj.Panels.colorPicker:ShowCloseButton(false)			
        serj.Panels.colorPicker.Paint = function(self, w, h) 
            serj.PanelPaint(self,name .. " color",w,h)
        end

        serj.Panels.colorPicker:SetPos(mousex+45,mousey-45)
        
        local colorWindowCloser = vgui.Create( "DButton", serj.Panels.colorPicker ) 
        colorWindowCloser:SetText( "" )					
        colorWindowCloser:SetPos( 250, 8 )					
        colorWindowCloser:SetSize( 40, 20 )					
        colorWindowCloser.DoClick = function() serj.Panels.colorPicker:Close() end
        colorWindowCloser.Paint = function(s,w,h) 
            draw.SimpleText("Close", "font-02", w/2, h/2-4, color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
        end
        serj.Panels.colorPicker:MakePopup()

        local colorSelector = vgui.Create("DColorMixer", serj.Panels.colorPicker)
        colorSelector:Dock(FILL)
        colorSelector:DockPadding(5, 5, 5, 5)
        colorSelector:SetPalette(false)
        colorSelector:SetWangs(false)
        colorSelector:SetColor(string.ToColor(serj.cfg.Colors[config]))
        function colorSelector:ValueChanged(val)
            local r = tostring(val.r)
            local g = tostring(val.g)
            local b = tostring(val.b)
            local a = tostring(val.a)
            local col = r.." "..g.." "..b.." "..a
            serj.cfg.Colors[config] = col
        end
    end

end

function serj.guiCheckBox(name,config,panel,colorable,bindable,bindkey)
	local p = panel:Add("DPanel")
	p:Dock(TOP)
	p:SetTall(22)
	p:DockMargin(5,5,5,0)

	p.Paint = function(sereja, krutoi, chuvak)
        --serj.surfaceOutline(0,0,krutoi,chuvak,1,Color(255,12,12))
		draw.SimpleText(name,"font-02",30,chuvak/2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

	local c = p:Add("DCheckBox")
	c:SetPos(5,5)
    c:SetSize(12,12)
	c:SetValue( tobool(serj.cfg.Vars[config]) )
	function c:OnChange( bVal )
		serj.cfg.Vars[config] = bVal
        if config == "tpose" and serj.ApplyTPoseHook then
            serj.ApplyTPoseHook()
        end
        --surface.PlaySound("garrysmod/ui_click.wav")
	end

	c.Paint = function(s, w, h)
        local checkcolor = string.ToColor(serj.cfg.Colors["menu_color"])
        if c:GetChecked() then   
            surfaceSetDrawColor(checkcolor)
        else
            surfaceSetDrawColor(66,66,66)
        end
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(12,12,12,155))
		serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
	end

	if colorable then
		local b = p:Add("DButton")
		b:Dock(RIGHT)
		b:DockMargin(0,5,15,5)
		b:SetText("")
        b:SetWide(25)

		b.Paint = function(s,w,h)
			local mycolor = string.ToColor(serj.cfg.Colors[config])
			serj.surfaceTexture(0,0,w,h,"gui/alpha_grid.png",Color(128,128,128,255))
			draw.RoundedBox(0,0,0,w,h,Color(mycolor.r,mycolor.g,mycolor.b,mycolor.a))
			serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(mycolor.r-55,mycolor.g-55,mycolor.b-55,mycolor.a))
			serj.surfaceOutline(0,0,w,h,1,color_black)		
		end

		b.DoClick = function()
			local mousex, mousey = input.GetCursorPos()
			if IsValid(serj.Panels.colorPicker) then
				serj.Panels.colorPicker:Remove()
			end
			
			serj.Panels.colorPicker = vgui.Create("DFrame")
			serj.Panels.colorPicker:SetSize(300, 225)
			serj.Panels.colorPicker:SetTitle(" ")
			serj.Panels.colorPicker:ShowCloseButton(false)			
			serj.Panels.colorPicker.Paint = function(self, w, h) 
				serj.PanelPaint(self,name .. " color",w,h)
			end

			serj.Panels.colorPicker:SetPos(mousex+45,mousey-45)
			
			local colorWindowCloser = vgui.Create( "DButton", serj.Panels.colorPicker ) 
            colorWindowCloser:SetText( "" )					
            colorWindowCloser:SetPos( 250, 8 )					
            colorWindowCloser:SetSize( 40, 20 )					
            colorWindowCloser.DoClick = function() serj.Panels.colorPicker:Close() end
            colorWindowCloser.Paint = function(s,w,h) 
				draw.SimpleText("Close", "font-02", w/2, h/2-4, color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
			end
			serj.Panels.colorPicker:MakePopup()

			local colorSelector = vgui.Create("DColorMixer", serj.Panels.colorPicker)
			colorSelector:Dock(FILL)
			colorSelector:DockPadding(5, 5, 5, 5)
			colorSelector:SetPalette(false)
			colorSelector:SetWangs(false)
			colorSelector:SetColor(string.ToColor(serj.cfg.Colors[config]))
			function colorSelector:ValueChanged(val)
				local r = tostring(val.r)
				local g = tostring(val.g)
				local b = tostring(val.b)
				local a = tostring(val.a)
				local col = r.." "..g.." "..b.." "..a
				serj.cfg.Colors[config] = col
			end
		end

	end

	if bindable then
        local bb = p:Add("DButton")
		bb:Dock(RIGHT)
		bb:DockMargin(5,5,5,5)
		bb:SetText("")

		bb.Paint = function(sosok,pizdenka,mne12)
			if serj.cfg.Keybinds[bindkey] != 0 then	
				draw.SimpleText("["..language.GetPhrase( input.GetKeyName( serj.cfg.Keybinds[bindkey] ) ) .. "]","font-03",pizdenka,mne12/2,Color(114,114,114),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("[-]","font-03",pizdenka,mne12/2,Color(114,114,114),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end
		end

        bb.DoClick = function()
            local mousex, mousey = input.GetCursorPos()
			if IsValid(serj.Panels.binder) then
				serj.Panels.binder:Remove()
			end
			
			serj.Panels.binder = vgui.Create("DFrame")
			serj.Panels.binder:SetSize(300, 150)
			serj.Panels.binder:SetTitle(" ")
			serj.Panels.binder:ShowCloseButton(false)			
			serj.Panels.binder.Paint = function(self, w, h) 
				serj.PanelPaint(self,"Binder",w,h)
                draw.SimpleText("Mode:", "font-02", 7, 70, color_white)
			end

			serj.Panels.binder:SetPos(mousex+45,mousey-45)
			
			local bindWindowCloser = vgui.Create( "DButton", serj.Panels.binder ) 
            bindWindowCloser:SetText( "" )					
            bindWindowCloser:SetPos( 250, 8 )					
            bindWindowCloser:SetSize( 40, 20 )					
            bindWindowCloser.DoClick = function() serj.Panels.binder:Close() end
            bindWindowCloser.Paint = function(s,w,h) 
				draw.SimpleText("Close", "font-02", w/2, h/2-4, color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
			end
			serj.Panels.binder:MakePopup()

            local k = vgui.Create("DBinder", serj.Panels.binder)
            k:SetValue(serj.cfg.Keybinds[bindkey])
            k:Dock(TOP)
            k:DockMargin(4,4,4,4)
            k.OnChange = function(self, val)
                serj.cfg.Keybinds[bindkey] = val
            end

            k.OldThink = k.Think

            function k:Think()			
                k:SetText("")			
                self:OldThink()
            end

            k:SetWide(95)

            k.Paint = function(sosok,pizdenka,mne12)
                sosok.move = sosok.move or 0
                if sosok:IsHovered() then
                    sosok.move = math.Approach(sosok.move,25,FrameTime()*300)
                else
                    sosok.move = math.Approach(sosok.move,0,FrameTime()*150)
                end

                draw.RoundedBox(0,0,0,pizdenka,mne12,Color(25+sosok.move,25+sosok.move,25+sosok.move))
                serj.surfaceOutline(0,0,pizdenka,mne12,1,color_black)	
                if k:GetValue() != 0 then	
                    draw.SimpleText(language.GetPhrase( input.GetKeyName( k:GetValue() ) ),"KeybinderFont",pizdenka/2,mne12/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText("[]","KeybinderFont",pizdenka/2,mne12/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
            end

            local dropdown = serj.Panels.binder:Add("DComboBox")
            dropdown:SetTall(30)
            dropdown:Dock(TOP)
            dropdown:DockMargin(0,25,0,0)
            dropdown:AddChoice("Hold")
            dropdown:AddChoice("Toggle")
            dropdown:SetSortItems(false)
            dropdown:ChooseOptionID(serj.cfg.Keybinds.mode[bindkey])
            function dropdown:OnSelect(index, value, data)
                serj.cfg.Keybinds.mode[bindkey] = index
            end
            dropdown.Paint = function(self,w,h)
                draw.RoundedBox(0,0,0,w,h,Color(32,32,32))
                serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(128,128,128,5))
                draw.SimpleText("▼","font-02",w-5,h/2,color_white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                serj.surfaceOutline(0,0,w,h,1,color_black)
            end
            dropdown.DropButton.Paint = function() end
            dropdown.PerformLayout = function(self)
                self:SetTextColor(Color(255,255,255))
                self:SetFont("font-02")
            end

            local p2 = serj.Panels.binder:Add("DPanel")
            p2:Dock(TOP)
            p2:SetTall(25)
            p2:DockMargin(5,2,5,0)
        
            p2.Paint = function(sereja, krutoi, chuvak)
                draw.SimpleText("Show in bindlist","font-02",30,chuvak/2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
        
            local c2 = p2:Add("DCheckBox")
            c2:SetPos(5,5)
            c2:SetSize(12,12)
            c2:SetValue( serj.cfg.Keybinds.showInBinds[bindkey] )
            function c2:OnChange( bVal )
                serj.cfg.Keybinds.showInBinds[bindkey] = bVal
                surface.PlaySound("garrysmod/ui_click.wav")
            end
        
            c2.Paint = function(s, w, h)
                local checkcolor = string.ToColor(serj.cfg.Colors["menu_color"])
                if c2:GetChecked() then   
                    surfaceSetDrawColor(checkcolor)
                else
                    surfaceSetDrawColor(66,66,66)
                end
                surfaceDrawRect(0,0,w,h)
                serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(12,12,12,155))
                serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
            end
        end

        bb.DoRightClick = function()
            serj.cfg.Keybinds[bindkey] = 0
        end
	end
end

function serj.Spacer(x,pan)
    local p = vgui.Create("DPanel",pan)
    p:Dock(LEFT)
    p:DockMargin(1,1,1,1)
    p:SetWide(x)

    p.Paint = function() end
end

function serj.TSpacer(y,pan)
    local p = vgui.Create("DPanel",pan)
    p:Dock(TOP)
    p:SetTall(y)

    p.Paint = function() end
end

function serj.panelPaint(s,w,h,name)
    -- Проверяем видимость родительской панели
    if not s:IsVisible() then return end
    
    surfaceSetFont("font-01")
    local namew, nameh = surfaceGetTextSize(name)
    surfaceSetDrawColor(23,23,23)
    surfaceDrawRect(2,8,w-4,h-4)
    serj.surfaceOutline(0,7,w,h-7,1,Color(12,12,12))
    serj.surfaceOutline(1,8,w-2,h-9,1,Color(40,40,40))
    surfaceSetDrawColor(23,23,23)
    surfaceDrawRect(17,7,namew+10,2)
    draw.SimpleText(name,"font-01",22,1,color_white)
end

function serj.SetupDscrollPanel(name,pan,watafuk)
    pan:Dock(FILL)
    pan:DockMargin(5,15,5,5)

	local panBar = pan:GetVBar()
	panBar:SetWide(8)

	function panBar:Paint(w,h)
        surfaceSetDrawColor(40,40,40)
        surfaceDrawRect(w-8,0,w,h)
    end

	function panBar.btnUp:Paint(w, h) end
	function panBar.btnDown:Paint(w, h) end
	function panBar.btnGrip:Paint(w, h)
        surfaceSetDrawColor(65,65,65)
        surfaceDrawRect(2,0,w-4,h)
    end

	pan.Paint = function() end
end

function serj.FunctionDropDown(name, pan, dpl, saveexpand)
    local dc = vgui.Create( "DCollapsibleCategory", pan )
    if serj.Expanded[saveexpand] != nil then
        dc:SetExpanded( serj.Expanded[saveexpand] )
    end	
    dc:SetLabel( "" )	
    dc:SetHeaderHeight( 35 )			
    dc:Dock(TOP)
	dc:DockMargin(5,5,5,0)

    dc.OnToggle = function()
        serj.Expanded[saveexpand] = dc:GetExpanded()
    end

    dc.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(15,15,15))
		serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(35,35,35))
		serj.surfaceOutline(0,0,w,h,1,color_black)

		draw.SimpleText(name,"font-02",10,s:GetHeaderHeight()/2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        if s:GetExpanded() then
			draw.RoundedBox(0,6,38,w-12,h-44,Color(15,15,15))
            draw.SimpleText("▼","font-02",w-25,s:GetHeaderHeight()/2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("►","font-02",w-25,s:GetHeaderHeight()/2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
    end
    
    dc:SetContents( dpl )	
end

function serj.DropDown(lbl, choices, config, par)

	local p = vgui.Create("DPanel",par)
	p:Dock(TOP)
	p:DockMargin(5,0,5,0)
	p:SetTall(55)
	p.Paint = function(s,w,h)
		--draw.RoundedBox(0,0,0,w,h,Color(255,30,30))
		draw.SimpleText(lbl,"font-02",30,12,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

	local dropdown = p:Add("DComboBox")
	dropdown:SetTall(30)
	dropdown:Dock(TOP)
    dropdown:DockMargin(30,25,0,0)
	for k, v in ipairs(choices) do
		dropdown:AddChoice(v)
	end
	dropdown:SetSortItems(false)
    if serj.cfg.Vars[config] <= #choices then
	    dropdown:ChooseOptionID(serj.cfg.Vars[config])
    else
        dropdown:ChooseOptionID(1)
    end

	function dropdown:OnSelect(index, value, data)
		serj.cfg.Vars[config] = index
	end
	dropdown.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(32,32,32))
		serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(128,128,128,5))
		draw.SimpleText("▼","font-02",w-5,h/2,color_white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		serj.surfaceOutline(0,0,w,h,1,color_black)
	end
	DMenuOption.Paint = function(self, w, h)
        draw.RoundedBox(0,0,0,w,h,Color(32,32,32))
    end
	dropdown.DropButton.Paint = function() end
	dropdown.PerformLayout = function(self)
        self:SetTextColor(Color(255,255,255))
        self:SetFont("font-02")
    end
end

 function serj.MultiCombo(lbl, items, par)
	local p = vgui.Create("DPanel",par)
	p:Dock(TOP)
	p:DockMargin(5,0,5,0)
	p:SetTall(55)
	p.Paint = function(s,w,h)
		draw.SimpleText(lbl,"font-02",30,12,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

	local dropdown = p:Add("DComboBox")
	dropdown:SetTall(30)
	dropdown:Dock(TOP)
    dropdown:DockMargin(30,25,0,0)
	dropdown:SetSortItems(false)

	local function updateText()
		local selectedNames = {}
		for _, it in ipairs(items) do
			if tobool(serj.cfg.Vars[it[2]]) then
				table.insert(selectedNames, it[1])
			end
		end

		if #selectedNames == 0 then
			dropdown:SetValue("None")
			return
		end

		local text = table.concat(selectedNames, ", ")
		if #text > 28 then
			text = string.sub(text, 1, 28) .. "..."
		end
		dropdown:SetValue(text)
	end

	function dropdown:DoClick()
		local menu = DermaMenu()
		for _, it in ipairs(items) do
			local opt = menu:AddOption(it[1], function()
				serj.cfg.Vars[it[2]] = not tobool(serj.cfg.Vars[it[2]])
				updateText()
			end)
			opt:SetIsCheckable(true)
			opt:SetChecked(tobool(serj.cfg.Vars[it[2]]))

			opt.DoClick = function(self)
				serj.cfg.Vars[it[2]] = not tobool(serj.cfg.Vars[it[2]])
				self:SetChecked(tobool(serj.cfg.Vars[it[2]]))
				updateText()
				return false
			end

			opt.Paint = function(self, w, h)
				local isChecked = tobool(serj.cfg.Vars[it[2]])
				local isHovered = self:IsHovered()
				local bg = Color(32, 32, 32, 255)
				local tx = Color(200, 200, 200, 255)

				if isChecked then
					bg = Color(55, 55, 55, 255)
					tx = Color(255, 255, 255, 255)
				elseif isHovered then
					bg = Color(45, 45, 45, 255)
					tx = Color(255, 255, 255, 255)
				end

				draw.RoundedBox(0, 0, 0, w, h, bg)
				self:SetTextColor(tx)
			end
		end
		menu:Open()
	end

	updateText()

	dropdown.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(32,32,32))
		serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(128,128,128,5))
		draw.SimpleText("▼","font-02",w-5,h/2,color_white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		serj.surfaceOutline(0,0,w,h,1,color_black)
	end
	DMenuOption.Paint = function(self, w, h)
        draw.RoundedBox(0,0,0,w,h,Color(32,32,32))
    end
	dropdown.DropButton.Paint = function() end
	dropdown.PerformLayout = function(self)
        self:SetTextColor(Color(255,255,255))
        self:SetFont("font-02")
    end
 end

function serj.CreateSlider(lbl, symbol, config, min, max, dec, par)

	local p = vgui.Create("DPanel",par)
	p:Dock(TOP)
	p:DockMargin(30,2,2,0)
	p:SetTall(45)

	local slider = p:Add("DNumSlider")
	slider:Dock(TOP)
	slider:SetHeight(10)
	slider:DockMargin(5,28,5,5)
	slider:SetMin(min)
	slider:SetMax(max)
	slider:SetTooltip(lbl)
	slider:SetDefaultValue(serj.cfg.Vars[config])
	slider:ResetToDefaultValue()
	slider:SetDecimals(dec)

	slider.Label:Hide()
	slider.TextArea:Hide()

	function slider:OnValueChanged()
		serj.cfg.Vars[config] = slider:GetValue()
	end

	p.Paint = function(s,w,h)
		--draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
		draw.SimpleText(lbl,"font-02",5,5,color_white)
		--draw.SimpleText(math.Round(slider:GetValue()) .. symbol,"font-02",w-5,5,color_white,TEXT_ALIGN_RIGHT)
	end

	slider.Slider.Paint = function(self,w,h)
		local getwidth, gettall = slider.Slider.Knob:GetPos()

		draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
        draw.RoundedBox(0,1,1,w-2,h-2,Color(52,52,52))
		draw.RoundedBox(0,1,1,getwidth-2+ 15,h-2,string.ToColor(serj.cfg.Colors["menu_color"]),true,false,true,false)
		serj.surfaceTexture(1,1,w-2,h-2,"gui/gradient_up",Color(200,200,200,5))
	end
	
	slider.Slider.Knob:SetSize(15,15)	
    slider.Slider.Knob.Paint = function(self,w,h)
        local getwidth, gettall = slider.Slider.Knob:GetPos()
		draw.SimpleText(math.Round(slider:GetValue()) .. symbol,"font-04",w/2,h/2+3,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        // FIXME ХУЙНЯ ВЫЕЗЖАЕТ ЗА ПАНЕЛЬ!
    end
    if !rp then
	    slider.Slider:SetNotches(0)
	    slider.Slider:SetNotchColor(Color(0,0,0,0))
    end
	slider.Scratch:SetVisible(false)
end

function serj.ESPPreview(pan,w,h)
    local modelPanel = pan:Add( "DModelPanel" )
	modelPanel:SetPos(0,0)
    modelPanel:SetSize(w,h)
	modelPanel:SetModel( "models/player/riot.mdl" )
	modelPanel:SetAnimated(true)

	local flex = modelPanel:GetEntity():LookupSequence("walk_fist")
	modelPanel:SetAnimSpeed(1)
	
	modelPanel:GetEntity():SetSequence(flex)
    --PrintTable( modelPanel:GetEntity():GetSequenceList() )
	function modelPanel:LayoutEntity(ent)

		-- Playback rate based on anim speed
		ent:SetPlaybackRate(self:GetAnimSpeed())
		if(ent:GetCycle() >= 0.95) then ent:SetCycle(0.05) end
		-- Advance frame
		ent:FrameAdvance()
	
	end

	function modelPanel:PostDrawModel(ent)	
        local chamMatVis = "!flat"
        if serj.cfg.Vars["chams_visible_mat"] == 1 then
            chamMatVis = "!flat"
        elseif serj.cfg.Vars["chams_visible_mat"] == 2 then
            chamMatVis = "!textured"
        elseif serj.cfg.Vars["chams_visible_mat"] == 3 then
            chamMatVis = "models/shiny"
        elseif serj.cfg.Vars["chams_visible_mat"] == 4 then
            chamMatVis = "models/props_combine/health_charger_glass"
        elseif serj.cfg.Vars["chams_visible_mat"] == 5 then
            chamMatVis = "models/wireframe"
        elseif serj.cfg.Vars["chams_visible_mat"] == 6 then
            chamMatVis = "!glowcham"
        elseif serj.cfg.Vars["chams_visible_mat"] == 7 then
            chamMatVis = "!glowcham2"
        elseif serj.cfg.Vars["chams_visible_mat"] == 8 then
            chamMatVis = "!glow_additive"
        end

		local colorFix = (1 / 255)
		local chamColVis = string.ToColor(serj.cfg.Colors["chams_visible"])

		if serj.cfg.Vars["chams_visible"] then
			render.SetColorModulation( chamColVis.r * colorFix, chamColVis.g * colorFix, chamColVis.b * colorFix )
			render.SetBlend( chamColVis.a * colorFix)
			render.MaterialOverride(Material(chamMatVis))
			ent:SetRenderMode(10)
			ent:SetColor(Color(0, 0, 0, 0))
			ent:DrawModel()
		end
	end

    local espOverlay = pan:Add( "DModelPanel" )
	espOverlay:SetPos(0,0)
    espOverlay:SetSize(w,h)

    espOverlay.Paint = function(s,w,h)
        
        --[[]
        ["esp_box_r"] = false,
        ["esp_box_grad_r"] = false,
        ["esp_box_f_r"] = false,

        ["esp_box"] = false,
        ["esp_box_grad"] = false,
        ["esp_box_f"] = false,
        ["esp_box_type"] = 1,
        ["esp_box_fr"] = false,
        ["esp_box_trg"] = false,
        ["esp_box_team"] = false,

        ["esp_name"] = false,
        ["esp_wep"] = false,
        ["esp_hp"] = false,
        ["esp_ap"] = false,

        ["esp_hp_bar"] = false,
        ["esp_hp_bar_ac"] = false,
        ["esp_hp_bar_gradient"] = false,
        ]]

        if serj.cfg.Vars["esp_name"] then
            draw.SimpleText("skeet-paste.tap","ESP Font",170,100,color_white)
        end
        if serj.cfg.Vars["esp_wep"] then
            draw.SimpleText("Weapon name","ESP Font",175,495,color_white)
        end
        if serj.cfg.Vars["esp_box"] then
            serj.surfaceOutline(125,115,175,380,1,color_white)
        end
        if serj.cfg.Vars["esp_hp"] then
            draw.SimpleText("100","ESP Font",100,120,color_white)
        end


    end
end

function serj.adapSlider(lbl, symbol, swep, cfgg, min, max, dec, par)

	local p = vgui.Create("DPanel",par)
	p:Dock(TOP)
	p:DockMargin(2,2,2,0)
	p:SetTall(45)

	local slider = p:Add("DNumSlider")
	slider:Dock(TOP)
	slider:SetHeight(10)
	slider:DockMargin(5,28,5,5)
	slider:SetMin(min)
	slider:SetMax(max)
	slider:SetTooltip(lbl)
	slider:SetDefaultValue(serj.cfg.AdaptiveConfig[swep][cfgg])
	slider:ResetToDefaultValue()
	slider:SetDecimals(dec)

	slider.Label:Hide()
	slider.TextArea:Hide()

	function slider:OnValueChanged()
		serj.cfg.AdaptiveConfig[swep][cfgg] = slider:GetValue()
	end

	p.Paint = function(s,w,h)
		draw.SimpleText(lbl,"font-02",5,5,color_white)
		draw.SimpleText(math.Round(slider:GetValue()) .. symbol,"font-02",w-5,5,color_white,TEXT_ALIGN_RIGHT)
	end

	slider.Slider.Paint = function(self,w,h)
		local getwidth = slider.Slider.Knob:GetPos()
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
        
		draw.RoundedBox(0,1,1,getwidth-2,h-2,string.ToColor(serj.cfg.Colors["menu_color"]),true,false,true,false)
	end
	
	slider.Slider.Knob:SetSize(6,10)	
    slider.Slider.Knob.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,color_white)
	end
    if !rp then
	    slider.Slider:SetNotches(0)
	    slider.Slider:SetNotchColor(Color(0,0,0,0))
    end
	slider.Scratch:SetVisible(false)
end

function serj.adapBox(name,cfgg,swep,panel)
	local p = panel:Add("DPanel")
	p:Dock(TOP)
	p:SetTall(25)
	p:DockMargin(5,2,5,0)

	p.Paint = function(sereja, krutoi, chuvak)
		draw.SimpleText(name,"font-02",30,chuvak/2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

	local c = p:Add("DCheckBox")
	c:Dock(LEFT)
	c:DockMargin(5,5,5,5)
	c:SetValue( serj.cfg.AdaptiveConfig[swep][cfgg] )
	function c:OnChange( bVal )
		serj.cfg.AdaptiveConfig[swep][cfgg] = bVal
		surface.PlaySound("garrysmod/ui_click.wav")
	end

	c.Paint = function(sereja, krutoi, chuvak)
        local checkcolor = string.ToColor(serj.cfg.Colors["menu_color"])
		sereja.move_alpha = sereja.move_alpha or 0
        sereja.checked = sereja.checked or 0

		if sereja:IsHovered() then
			sereja.move_alpha = math.Approach(sereja.move_alpha,128,FrameTime()*300)
		else
			sereja.move_alpha = math.Approach(sereja.move_alpha,55,FrameTime()*150)
		end

		draw.RoundedBox(0,0,0,krutoi,chuvak,Color(45,45,45))
		if c:GetChecked() then
            sereja.checked = math.Approach(sereja.checked,255,FrameTime()*350)
        else
            sereja.checked = math.Approach(sereja.checked,0,FrameTime()*350)
		end
		draw.RoundedBox(0,0,0,krutoi,chuvak,Color(checkcolor.r,checkcolor.g,checkcolor.b,sereja.checked))
		draw.RoundedBox(0,1,1,krutoi-2,chuvak-2,Color(0,0,0,255))
        draw.RoundedBox(0,2,2,krutoi-4,chuvak-4,Color(checkcolor.r,checkcolor.g,checkcolor.b,sereja.checked))
		serj.surfaceTexture(2,2,krutoi-4,chuvak-4,"gui/gradient_up",Color(15,15,15,sereja.checked))
	end
end

function serj.AddAdapWeapon(pan)
    local b = pan:Add("DButton")
    b:Dock(TOP)
    b:DockMargin(4,4,4,5)
    b:SetTall(25)
    b:SetText("")

    b.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(32,32,32))
		serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(15,15,15,10))
		serj.surfaceOutline(0,0,w,h,1,color_black)
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
        if IsValid(LocalPlayer()) and LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) then
		    draw.SimpleText("Add adaptive config for " .. LocalPlayer():GetActiveWeapon():GetClass(),"font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("You need to be alive or holding valid weapon.","font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    b.DoClick = function()
        if LocalPlayer():GetActiveWeapon() != nil then
            serj.cfg.AdaptiveConfig[LocalPlayer():GetActiveWeapon():GetClass()] = {
                LocalPlayer():GetActiveWeapon():GetPrintName(),
                false, -- baim
                50, -- bhp
                3, -- hitbox
                false, -- st
                45 -- rs
            }
        end
    end
end

function serj.AdapCFG(name,swep,pan)
    local b = pan:Add("DButton")
    b:Dock(TOP)
    b:DockMargin(4,4,4,0)
    b:SetText("")

    b.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(32,32,32))
		serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(15,15,15,10))
		serj.surfaceOutline(0,0,w,h,1,color_black)
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
		draw.SimpleText(name .. "(" .. swep .. ")","font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    b.DoClick = function()
        local mousex, mousey = input.GetCursorPos()
		if IsValid(serj.Panels.adapCfg) then
			serj.Panels.adapCfg:Remove()
		end
			
		serj.Panels.adapCfg = vgui.Create("DFrame")
		serj.Panels.adapCfg:SetSize(300, 250)
		serj.Panels.adapCfg:SetTitle(" ")
		serj.Panels.adapCfg:ShowCloseButton(false)			
		serj.Panels.adapCfg.Paint = function(self, w, h) 
			serj.PanelPaint(self,name .. " config",w,h)
		end
		serj.Panels.adapCfg:SetPos(mousex+45,mousey-45)
		serj.Panels.adapCfg:MakePopup()

        serj.adapBox("Only baim",2,swep,serj.Panels.adapCfg)
        serj.adapSlider("Baim health", "", swep, 3, 0, 99, 0, serj.Panels.adapCfg)
        serj.adapSlider("Resolver step", "", swep, 6, 2, 180, 0, serj.Panels.adapCfg)
    end
    b.DoRightClick = function()
        serj.cfg.AdaptiveConfig[swep] = nil
        b:Remove()
    end
end

function serj.addSkinPanel(name,model,material,weapon,panel) 
    
    local skp = panel:Add("DPanel")
    skp:Dock(TOP)
    skp:DockMargin(10,10,10,0)
    skp:SetTall(120)
    skp.Paint = function(s,w,h)
        surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
		serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
        --skin info
        draw.SimpleText(name,"font-02",125,12,color_white)
        draw.SimpleText("Model    " .. model,"font-02",125,40,color_white)
        draw.SimpleText("Skin    " .. material,"font-02",125,60,color_white)
        draw.SimpleText("Weapon    " .. weapon,"font-02",125,80,color_white)
    end

    local skp2 = skp:Add("DPanel")
    skp2:Dock(LEFT)
    skp2:DockMargin(6,6,6,6)
    skp2:SetWide(100)
    skp2.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
        serj.surfaceOutline(0,0,w,h,1,color_black)
    end
    skp2:SetWide(108)

    local m = skp2:Add( "DModelPanel" )
	m:Dock(FILL)
    m:DockMargin(5,5,5,5)
	m:SetModel(model)
    local PrevMins, PrevMaxs = m.Entity:GetRenderBounds()
    m:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5))
	m:SetLookAt((PrevMaxs + PrevMins) / 2)

    function m:LayoutEntity(ent) end
    local getskinweapon = serj.cfg.gunSkins[weapon]

	function m:PostDrawModel(ent)	
        render.SetColorModulation(getskinweapon[4]/255,getskinweapon[5]/255,getskinweapon[6]/255)
		render.MaterialOverride(Material(material))
		ent:SetRenderMode(10)
		ent:SetColor(Color(0, 0, 0, 0))
		ent:DrawModel()
        render.SetColorModulation(1,1,1)
        render.MaterialOverride()
	end

    local removeb = skp2:Add("DButton")
    removeb:SetText("")
    removeb:Dock(FILL)
    removeb:DockMargin(5,5,5,5)

    removeb.Paint = function(s,w,h)
        s.Alpha = s.Alpha or 0
        s.Move = s.Move or 0

        if removeb:IsHovered() then
            s.Alpha = math.Approach(s.Alpha,235,FrameTime()*100)  
            s.Move = math.Approach(s.Move,20,FrameTime()*150)  
        else
            s.Alpha = math.Approach(s.Alpha,0,FrameTime()*350)  
            s.Move = math.Approach(s.Move,0,FrameTime()*200)  
        end

        serj.surfaceTexture(0,h-s.Move,w,20,"gui/gradient_up",Color(255,0,0,s.Alpha))
        draw.SimpleText("Remove","font-02",w/2,h-s.Move,Color(255,255,255,s.Alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        draw.SimpleText(name,"font-02",w/2,-19+s.Move,Color(255,255,255,s.Alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
    end

    removeb.DoClick = function()
        serj.cfg.gunSkins[weapon] = nil
        skp:Remove()
    end

    local pp = panel:Add("DPanel")
    pp:Dock(TOP)
    pp:DockMargin(10,2,10,2)
    pp:SetTall(65)

    pp.Paint = function(s,w,h)
		surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
		serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
    end

    local colorSelector = pp:Add("DColorMixer")
	colorSelector:Dock(FILL)
	colorSelector:DockPadding(5, 5, 5, 5)
	colorSelector:SetPalette(false)
	colorSelector:SetWangs(false)
	colorSelector:SetColor(Color(getskinweapon[4],getskinweapon[5],getskinweapon[6],getskinweapon[7]))
	function colorSelector:ValueChanged(val)
		getskinweapon[4] = val.r
		getskinweapon[5] = val.g
		getskinweapon[6] = val.b
		getskinweapon[7] = val.a
	end

end

function serj.skinAdd(pan)
    local p = pan:Add("DPanel")
    p:Dock(TOP)
    p:SetTall(50)
    p:DockMargin(5,5,5,0)

    p.Paint = function(s,w,h)
    end

    local b = p:Add("DButton")
    b:Dock(FILL)
    b:SetText("")
    b:DockMargin(9,9,9,9)

    b.Paint = function(s,w,h)
        surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
		serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))

        if IsValid(LocalPlayer()) and LocalPlayer():Alive() then
            draw.SimpleText("Add skin for " .. LocalPlayer():GetActiveWeapon():GetPrintName(),"font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("You must be alive or with weapon in your hands!","font-02",w/2,h/2,Color(255,79,79),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

    end

    b.DoClick = function()
        --surface.PlaySound("garrysmod/ui_click.wav")
        if IsValid(LocalPlayer()) and LocalPlayer():Alive() then
            serj.cfg.gunSkins[LocalPlayer():GetActiveWeapon():GetClass()] = {
                serj.cfg.Vars["skininput"],
                LocalPlayer():GetActiveWeapon():GetModel(),
                LocalPlayer():GetActiveWeapon():GetPrintName(),
                255,
                255,
                255,
                255,
            }
            serj.CloseFrame()
	        OpenGUI()
        end     
    end
end

function serj.addModelPanel(name,model,weapon,panel) 
    
    local skp = panel:Add("DPanel")
    skp:Dock(TOP)
    skp:DockMargin(10,10,10,0)
    skp:SetTall(120)
    skp.Paint = function(s,w,h)
        surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
		serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
        --skin info
        draw.SimpleText(name,"font-02",125,12,color_white)
        draw.SimpleText("Model    " .. model,"font-02",125,40,color_white)
        draw.SimpleText("Weapon    " .. weapon,"font-02",125,60,color_white)
    end

    local skp2 = skp:Add("DPanel")
    skp2:Dock(LEFT)
    skp2:DockMargin(6,6,6,6)
    skp2:SetWide(100)
    skp2.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
        serj.surfaceOutline(0,0,w,h,1,color_black)
    end
    skp2:SetWide(108)

    local m = skp2:Add( "DModelPanel" )
	m:Dock(FILL)
    m:DockMargin(5,5,5,5)
	m:SetModel(model)
    local PrevMins, PrevMaxs = m.Entity:GetRenderBounds()
    m:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5))
	m:SetLookAt((PrevMaxs + PrevMins) / 2)

    function m:LayoutEntity(ent) end
    local getskinweapon = serj.cfg.gunModels[weapon]

    local removeb = skp2:Add("DButton")
    removeb:SetText("")
    removeb:Dock(FILL)
    removeb:DockMargin(5,5,5,5)

    removeb.Paint = function(s,w,h)
        s.Alpha = s.Alpha or 0
        s.Move = s.Move or 0

        if removeb:IsHovered() then
            s.Alpha = math.Approach(s.Alpha,235,FrameTime()*100)  
            s.Move = math.Approach(s.Move,20,FrameTime()*150)  
        else
            s.Alpha = math.Approach(s.Alpha,0,FrameTime()*350)  
            s.Move = math.Approach(s.Move,0,FrameTime()*200)  
        end

        serj.surfaceTexture(0,h-s.Move,w,20,"gui/gradient_up",Color(255,0,0,s.Alpha))
        draw.SimpleText("Remove","font-02",w/2,h-s.Move,Color(255,255,255,s.Alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        draw.SimpleText(name,"font-02",w/2,-19+s.Move,Color(255,255,255,s.Alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
    end

    removeb.DoClick = function()
        serj.cfg.gunModels[weapon] = nil
        skp:Remove()
    end
end

function serj.modelAdd(pan)
    local p = pan:Add("DPanel")
    p:Dock(TOP)
    p:SetTall(50)
    p:DockMargin(5,5,5,0)

    p.Paint = function(s,w,h)
    end

    local b = p:Add("DButton")
    b:Dock(FILL)
    b:SetText("")
    b:DockMargin(9,9,9,9)

    b.Paint = function(s,w,h)
        surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
		serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))

        if IsValid(LocalPlayer()) and LocalPlayer():Alive() then
            draw.SimpleText("Change model for " .. LocalPlayer():GetActiveWeapon():GetPrintName(),"font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("You must be alive or with weapon in your hands!","font-02",w/2,h/2,Color(255,79,79),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

    end

    b.DoClick = function()
        if IsValid(LocalPlayer()) and LocalPlayer():Alive() then
            serj.cfg.gunModels[LocalPlayer():GetActiveWeapon():GetClass()] = {
                serj.cfg.Vars["modelinput"],
                LocalPlayer():GetActiveWeapon():GetModel(),
                LocalPlayer():GetActiveWeapon():GetPrintName(),
            }
            serj.CloseFrame()
	        OpenGUI()
        end     
    end
end

serj.aayaws = {
    "Forward",
    "Backward",
    "Left",
    "Right",
    "Spin",
    "Reverse spin",
    "Jitter",
    "Center jitter",
    "Custom",
    "Aristocrat YAW",
    "Ferrari desync",
    "Sideways",
    "Half Sideways",
}

scriptfiles, sdir = serj.oldFileFind( "serj/*.lua", "DATA" )
unloadScript = true
function serj.RedactorPanel(name,panel)
    local trueName = file.Read( "serj/" .. name, "DATA" )
    local p = panel:Add("DPanel")
    p:Dock(TOP)
    p:DockMargin(3,3,3,3)
    p:SetTall(45)

    p.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(50,50,50))
        serj.surfaceOutline(0,0,w,h,1,color_black)
        draw.SimpleText(name,"font-02",8,h/2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end
       
	local b = p:Add("DButton")
	b:SetText("")
	b:SetWide(85)
	b:Dock(RIGHT)
	b:DockMargin(8,8,8,8)
	b.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(50,50,50))
        serj.surfaceOutline(0,0,w,h,1,color_black) 
		draw.SimpleText("RunString", "font-02", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	b.DoClick = function()
        local fileRun = RunString(trueName, "PenisRunString", false)

		if fileRun then
			chat.AddText(Color(255, 0, 0), "[PenisDeda] " , fileRun)
		else
			chat.AddText(Color(0, 255, 128), "[PenisDeda] ", color_white, "Script loaded - ", name)
		end
	end
    local b2 = p:Add("DButton")
	b2:SetText("")
	b2:SetWide(85)
	b2:Dock(RIGHT)
	b2:DockMargin(1,8,1,8)
	b2.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(50,50,50))
        serj.surfaceOutline(0,0,w,h,1,color_black) 
		draw.SimpleText("Unload", "font-02", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	b2.DoClick = function()
        local fileUnload = RunString([[if unloadScript then return end ]] .. file.Read( "serj/" .. name, "DATA" ), "PenisRunString", false)
		if fileUnload then
			chat.AddText(Color(255, 0, 0), "[PenisDeda] " , fileUnload)
		else
			chat.AddText(Color(0, 255, 128), "[PenisDeda] ", color_white, "Script unloaded - ", name)
		end
	end
end


serj.chamMats = {
    "Flat",
    "Textured",
    "Glow",
    "Wireframe",
    "Glow additive",
    "Glass",
}


function OpenGUI()
    serj.Panels.framew, serj.Panels.frameh = 800, 725
    serj.Panels.framex, serj.Panels.framey = (scrw / 2) - (serj.Panels.framew / 2), (scrh / 2) - (serj.Panels.frameh / 2)

    files, dir = serj.oldFileFind( "serj/*.json", "DATA" )
    scriptfiles, sdir = serj.oldFileFind( "serj/*.lua", "DATA" )

	serj.Panels.frame = vgui.Create("DFrame")
	serj.Panels.frame:SetPos(serj.Panels.framex,serj.Panels.framey)
	serj.Panels.frame:SetSize(serj.Panels.framew,serj.Panels.frameh)
	serj.Panels.frame:SetAlpha(0)
	serj.Panels.frame:AlphaTo(255,0.7,0,function()end)
	serj.Panels.frame:SetTitle("")
	serj.Panels.frame:MakePopup()
	serj.Panels.frame:ShowCloseButton(false)
    serj.Panels.frame:SetSizable(true)
    serj.Panels.frame:SetMinWidth( 800 )
    serj.Panels.frame:SetMinHeight( 725 )

    -- Создаем отдельную верхнюю панель
    if IsValid(serj.Panels.topPanel) then serj.Panels.topPanel:Remove() end
    serj.Panels.topPanel = vgui.Create("DPanel")
    serj.Panels.topPanel:SetSize(serj.Panels.framew, 35)
    serj.Panels.topPanel:SetPos(serj.Panels.framex, serj.Panels.framey - 45)
    
    serj.Panels.topPanel.Paint = function(s,w,h)
        if not IsValid(serj.Panels.frame) or not serj.Panels.frame:IsVisible() then 
            s:SetAlpha(0)
            return 
        end
        s:SetAlpha(serj.Panels.frame:GetAlpha())
        
        -- Синхронизация позиции и ширины с основным меню
        local fx, fy = serj.Panels.frame:GetPos()
        local fw = serj.Panels.frame:GetWide()
        s:SetSize(fw, 35)
        s:SetPos(fx, fy - 45)

        surfaceSetDrawColor(0,0,0,255)
        surfaceDrawRect(0,0,w,h)


        serj.surfaceOutline(0,0,w,h,6,color_black) 
        serj.surfaceOutline(1,1,w-2,h-2,5,Color(57,57,57)) 
        serj.surfaceOutline(2,2,w-4,h-4,3,Color(29,29,28))
        
        surfaceSetDrawColor(45,45,45,255)
        surfaceDrawRect(7,7,w-14,2)
        
        draw.SimpleText("MAMBET.BIZ | DEV | ПАСЛЕДНИЙ АБНОВЛЕНИЙ 07.05.26 | СМОТРТЬ ЗОМБЕТЫ 1 СЕЗОН 5 СЕРИЯ | Э ЧЕ НА НАШЕМ РАЙОНЕ ПОТЕРЯЛ", "font-02", w/2, h/2 + 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local yaycadedamoroza, penisdedamoroza = scrw/700, scrh/600

	serj.Panels.frame.Paint = function(s,w,h)
        if not s:IsVisible() then return end
        
        surfaceSetDrawColor(0,0,0,255)
        surfaceDrawRect(0,0,w,h)

        serj.surfaceOutline(0,0,w,h,6,color_black) 
        serj.surfaceOutline(1,1,w-2,h-2,5,Color(57,57,57)) 
        serj.surfaceOutline(2,2,w-4,h-4,3,Color(29,29,28))
        surfaceSetDrawColor(6,6,6)
        surfaceDrawRect(7,7,w-14,3)
        serj.surfaceOutline(6,6,w-12,4,1,color_black) 
        -- serj.surfaceTexture(7,7,w-14,2,"gradient.png",color_white)
        surfaceSetDrawColor(45,45,45,255)
        surfaceDrawRect(7,7,w-14,2)
	end

    local tabs = serj.Panels.frame:Add("DPanel")
    tabs:SetPos(6,9)
    tabs:SetSize(96,serj.Panels.frame:GetTall()-15)

    tabs.Paint = function(s,w,h)
        surfaceSetDrawColor(40,40,40)
        surfaceDrawRect(0,0,w,h)
        surfaceSetDrawColor(0,0,0)
        surfaceDrawRect(0,0,w-1,h)
        surfaceSetDrawColor(12,12,12)
        surfaceDrawRect(0,0,w-2,h)
    end

    /////////////////////////////////////////////////////////////
    /////////////////// Aimbot panel ////////////////////////////
    /////////////////////////////////////////////////////////////

    local panel = serj.Panels.frame:Add("DPanel")
	panel:SetPos(105,13)
    panel:SetSize(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23)
	panel.Paint = function() end

    local aimpan = panel:Add("DPanel")
    aimpan:SetPos(5,5)
    aimpan:SetSize(panel:GetWide()/2-7,panel:GetTall()-9)
    aimpan.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Aimbot")
    end
    local ascrol = aimpan:Add("DScrollPanel")
	serj.SetupDscrollPanel("Aimbot",ascrol,aimpan)

	serj.guiCheckBox("Enabled","aim_enable",ascrol,false,true,"aim_enable")
	serj.DropDown("Target selection", { "FOV", "Distance", "Health" }, "target_selection", ascrol)
    serj.guiCheckBox("Enable eyes hitbox","eyes_e",ascrol)
	serj.DropDown("Hitbox selection", { "Head", "Eyes", "Penis", "Spine", "Center", "Черепа", "gRust Head" }, "hitbox_selection", ascrol)
	serj.guiCheckBox("Auto fire","af_enable",ascrol)
	serj.guiCheckBox("Auto reload","ar_enable",ascrol)
	serj.guiCheckBox("Auto wallbang","aw_enable",ascrol)
    serj.guiCheckBox("Silent aim","sa_enable",ascrol)
    
    serj.guiCheckBox("Advanced Prediction","predict",ascrol)
    serj.guiCheckBox("Ping Compensation","predict_ping",ascrol)
    serj.guiCheckBox("Bullet Drop","predict_gravity",ascrol)
    serj.guiCheckBox("Predict Debug","predict_debug",ascrol)
    serj.CreateSlider("Predict Amount", "%", "predict_amount", 50, 200, 0, ascrol)
    serj.CreateSlider("Predict Smooth", "%", "predict_smooth_val", 70, 98, 0, ascrol)
    serj.CreateSlider("Predict Iterations", "", "predict_iters", 1, 8, 0, ascrol)


    local aimpan2 = panel:Add("DPanel")
    aimpan2:SetPos(panel:GetWide()/2-7+10,5)
    aimpan2:SetSize(panel:GetWide()/2-7,panel:GetTall()-9)
    aimpan2.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Other")
    end
    local ascrol2 = aimpan2:Add("DScrollPanel")
	serj.SetupDscrollPanel("Other",ascrol2,aimpan2)

	serj.guiCheckBox("Resolver","res_enable",ascrol2)
    serj.DropDown("Resolver type", { "Default", "Резольвер бога смерти", "math.random", "Nokos", "Grand Theft Auto: San Andreas" }, "res_type", ascrol2)
	serj.CreateSlider("Resolver step", "°", "res_step", 1, 180, 0, ascrol2)
	serj.guiCheckBox("Pitch resolver","res_pitch",ascrol2)
	serj.guiCheckBox("Aimbot snapline","as_enable",ascrol2,true)
    serj.guiCheckBox("Aimbot point","ap_enable",ascrol2,true)
    serj.guiCheckBox("Aimbot point box","ap_box",ascrol2)
    
	serj.guiCheckBox("Rapid fire","af_r",ascrol2)
	serj.guiCheckBox("Servertime","servertime",ascrol2)
	serj.guiCheckBox("Ignore god time","aimbot_ignore_bgod",ascrol2)
	serj.guiCheckBox("Ignore nodraw","aimbot_ignore_nodraw",ascrol2)
	serj.guiCheckBox("Ignore admin","aimbot_ignore_admin",ascrol2)
	serj.guiCheckBox("Ignore bots","aimbot_ignore_bots",ascrol2)
	serj.guiCheckBox("Ignore steam friend","aimbot_ignore_steam",ascrol2)
	serj.guiCheckBox("Ignore nocliping","aimbot_ignore_noclip",ascrol2)
	serj.guiCheckBox("Ignore teammates","aimbot_ignore_team",ascrol2)
	serj.guiCheckBox("Ignore friends","aimbot_ignore_fr",ascrol2)
	serj.CreateSlider("Скорость бога смерти", "", "bog_smerti_resolver_step", 666, 6666, 0, ascrol2)

    panel.OnSizeChanged = function()
        aimpan:SetSize(panel:GetWide()/2-7,panel:GetTall()-9)
        aimpan2:MoveTo(panel:GetWide()/2-7+10,5,0,0,0,function()end)
        aimpan2:SetSize(panel:GetWide()/2-7,panel:GetTall()-9)
    end
    
    /////////////////////////////////////////////////////////////
    /////////////////// Antiaim panel ///////////////////////////
    /////////////////////////////////////////////////////////////

    local panel2 = serj.Panels.frame:Add("DPanel")
	panel2:SetPos(105,13)
    panel2:SetSize(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23)
	panel2.Paint = function() end

    local antiaimpan = panel2:Add("DPanel")
    antiaimpan:SetPos(5,5)
    antiaimpan:SetSize(panel2:GetWide()/2-7,panel2:GetTall()-9)
    antiaimpan.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Anti-aim")
    end
    local aascrol = antiaimpan:Add("DScrollPanel")
	serj.SetupDscrollPanel("Anti-aim",aascrol,antiaimpan)

    serj.guiCheckBox("Enabled","aa_enable",aascrol)
	serj.DropDown("Yaw base", { "Viewangles", "Static", "At targets (Distance)", "At targets (FOV)" }, "yaw_base", aascrol)
	serj.DropDown("Real yaw", serj.aayaws, "yaw_real", aascrol)
	serj.DropDown("Fake yaw", serj.aayaws, "yaw_fake", aascrol)
    serj.guiCheckBox("Invert Yaw", "yaw_invert", aascrol, false, true, "yaw_invert")
	serj.DropDown("Pitch", { 
		"Viewangles",
		"Zero",
		"Down",
		"Up",
		"Fake down",
		"Jitter",
		"Random",
		"Custom",
        "Cadillac pitch",
        "Cadillac jitter",
        "Cadillac jitter up",
        "Dalbaeb pitch",
	}, "pitch", aascrol)

	serj.CreateSlider("Custom pitch", "°", "c_pitch", -190, 190, 2, aascrol)
	serj.CreateSlider("Custom real", "°", "c_ryaw", -180, 180, 1, aascrol)
	serj.CreateSlider("Custom fake", "°", "c_fyaw", -180, 180, 1, aascrol)
	serj.CreateSlider("Jitter range", "°", "antiaim_jitterrange", 1, 360, 1, aascrol)
	serj.CreateSlider("Spin speed", "°", "antiaim_spinspeed", 1, 100, 1, aascrol)

    serj.guiCheckBox("Zero pitch on land","pitch_zero_land",aascrol)

	serj.guiCheckBox("LBY breaker","lby",aascrol)
	serj.guiCheckBox("Dancer","dancer",aascrol)
	serj.DropDown("Act", {        
		"robot",
		"muscle",
		"laugh",
		"bow",
		"cheer",
		"wave",
		"becon",
		"agree",
		"disagree",
		"forward",
		"group",
		"half",
		"zombie",
		"dance",
		"pers",
		"halt",
		"salute",}
	, "dance", aascrol)
	serj.guiCheckBox("Off on ladder","aa_off_ladder",aascrol)
	serj.guiCheckBox("Off on use","aa_off_use",aascrol)

    local antiaimpan2 = panel2:Add("DPanel")
    antiaimpan2:SetPos(panel2:GetWide()/2-7+10,5)
    antiaimpan2:SetSize(panel2:GetWide()/2-7,panel2:GetTall()/2-9)
    antiaimpan2.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Fake Lag")
    end
    local aascrol2 = antiaimpan2:Add("DScrollPanel")
	serj.SetupDscrollPanel("Fake Lag",aascrol2,antiaimpan2)

	serj.guiCheckBox("Enable fakelag","fl_enable",aascrol2)
	serj.DropDown("Fakelag mode", { "Static","Adaptive" }, "fl_mode", aascrol2)
	serj.CreateSlider("Fakelag max", "", "fl_maxchoke", 1, 14, 0, aascrol2)
	serj.guiCheckBox("Off on ladder","fl_ladder",aascrol2)
	serj.guiCheckBox("Off on use","fl_use",aascrol2)
    serj.guiCheckBox("Fakelag on peek","fl_peek",aascrol2)

    local antiaimpan3 = panel2:Add("DPanel")
    antiaimpan3:SetPos(panel2:GetWide()/2-7+10,panel2:GetTall()/2+5)
    antiaimpan3:SetSize(panel2:GetWide()/2-7,panel2:GetTall()/2-9)
    antiaimpan3.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Other")
    end
    local aascrol3 = antiaimpan3:Add("DScrollPanel")
	serj.SetupDscrollPanel("Other",aascrol3,antiaimpan3)

	serj.guiCheckBox("Edge yaw","edge_enable",aascrol3)
    serj.DropDown("Edge side", { "Real","Fake" }, "edge_side", aascrol3)
    serj.guiCheckBox("Avoid overlap","avoid_overlap",aascrol3)
    serj.CreateSlider("Avoid overlap add", "°", "avoid_overlap_add", 1, 35, 0, aascrol3)
    serj.guiCheckBox("Auto direction","aa_autodir",aascrol3)
        serj.guiCheckBox("AA lines","paganie_strelochki",aascrol3)

    panel2.OnSizeChanged = function()
        antiaimpan:SetSize(panel2:GetWide()/2-7,panel2:GetTall()-9)
        antiaimpan2:MoveTo(panel2:GetWide()/2-7+10,5,0,0,0,function()end)
        antiaimpan2:SetSize(panel2:GetWide()/2-7,panel2:GetTall()/2-9)
        antiaimpan3:MoveTo(panel2:GetWide()/2-7+10,panel2:GetTall()/2+5,0,0,0,function()end)
        antiaimpan3:SetSize(panel2:GetWide()/2-7,panel2:GetTall()/2-9)
    end

    /////////////////////////////////////////////////////////////
    /////////////////// Legit panel /////////////////////////////
    /////////////////////////////////////////////////////////////

    local panel3 = serj.Panels.frame:Add("DPanel")
	panel3:SetPos(105,13)
    panel3:SetSize(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23)
	panel3.Paint = function() end

    local legitpan = panel3:Add("DPanel")
    legitpan:SetPos(5,5)
    legitpan:SetSize(panel3:GetWide()/2-7,panel3:GetTall()-9)
    legitpan.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Main")
    end
    local legpan = legitpan:Add("DScrollPanel")
	serj.SetupDscrollPanel("Main",legpan,legitpan)

    serj.guiCheckBox("FOV  limit","legit_fov",legpan)
    serj.CreateSlider("Max FOV", "°", "legit_fov_val", 1, 180, 0, legpan)
    serj.guiCheckBox("FOV  circle","legit_fov_draw",legpan,true)

    panel3.OnSizeChanged = function()
        legitpan:SetSize(panel3:GetWide()/2-7,panel3:GetTall()-9)
    end

    /////////////////////////////////////////////////////////////
    /////////////////// Visuals panel ///////////////////////////
    /////////////////////////////////////////////////////////////

    local panel4 = serj.Panels.frame:Add("DPanel")
	panel4:SetPos(105,13)
    panel4:SetSize(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23)
	panel4.Paint = function() end

    local playeresp = panel4:Add("DPanel")
    playeresp:SetPos(5,5)
    playeresp:SetSize(panel4:GetWide()/2-7,panel4:GetTall()-209)
    playeresp.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Player ESP")
    end
    local playerespan = playeresp:Add("DScrollPanel")
	serj.SetupDscrollPanel("Player ESP",playerespan,playeresp)

    serj.guiCheckBox("Player Box","esp_box",playerespan,true)
    serj.DropDown("Box Style", {"Default","Corners","3D","Outlined"}, "esp_box_type", playerespan)
    serj.guiCheckBox("Highlight Friends","esp_box_fr",playerespan,true)
    serj.guiCheckBox("Highlight Targets","esp_box_trg",playerespan,true)
    serj.guiCheckBox("Team Color","esp_box_team",playerespan)
    serj.guiCheckBox("Fill","esp_box_f",playerespan,true)
    serj.guiCheckBox("Gradient fill","esp_box_grad",playerespan,true)
    serj.guiCheckBox("Box Rainbow","esp_box_r",playerespan)
    serj.guiCheckBox("Fill Rainbow","esp_box_f_r",playerespan)
    serj.guiCheckBox("Gradient Rainbow","esp_box_grad_r",playerespan)
    serj.guiCheckBox("Mambet Tag","esp_mambet",playerespan)
    serj.guiCheckBox("Name","esp_name",playerespan,true)
    serj.guiCheckBox("Weapon","esp_wep",playerespan,true)
    serj.guiCheckBox("Health","esp_hp",playerespan,true)
    serj.guiCheckBox("Health Bar","esp_hp_bar",playerespan,true)
    serj.guiCheckBox("HP Auto color","esp_hp_bar_ac",playerespan)
    serj.guiCheckBox("HP Gradient","esp_hp_bar_gradient",playerespan,true)
    serj.guiCheckBox("Armor","esp_ap",playerespan,true)
    serj.guiCheckBox("Team","esp_team",playerespan)
    serj.guiCheckBox("Group","esp_group",playerespan,true)
    serj.guiCheckBox("Money","esp_money",playerespan,true)
    serj.guiCheckBox("Skeleton","esp_skeleton",playerespan,true)
    serj.guiCheckBox("Hotbar","esp_hotbar",playerespan)
    serj.guiCheckBox("Active weapon","esp_active_weapon",playerespan,true)
    serj.DropDown("Active item mode", {"Text", "PNG"}, "esp_active_mode", playerespan)
    serj.guiCheckBox("Glow ESP","glow_esp",playerespan,true)
    serj.guiCheckBox("Glow Additive","glow_esp_a",playerespan)
    serj.guiCheckBox("Attachment Glow","glow_esp_att",playerespan)
    serj.guiCheckBox("Enable arrows","oof_arrows",playerespan,true)
    serj.CreateSlider("Arrow size", "", "oof_arrows_as", 1, 25, 1,playerespan)
    serj.CreateSlider("Arrow distance", "", "oof_arrows_ad", 10, 100, 1,playerespan)

    local chamsesp = panel4:Add("DPanel")
    chamsesp:SetPos(5,10+panel4:GetTall()-209)
    chamsesp:SetSize(panel4:GetWide()/2-7,panel4:GetTall()-(panel4:GetTall()-195))
    chamsesp.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Colored models")
    end
    local chamsespan = chamsesp:Add("DScrollPanel")
	serj.SetupDscrollPanel("Colored models",chamsespan,chamsesp)

    --Visible chams
    serj.guiCheckBox("Visible Chams","chams_visible",chamsespan,true)
    serj.DropDown("Material", serj.chamMats, "chams_visible_mat", chamsespan)
    serj.guiCheckBox("Attachment Chams","chams_visible_att",chamsespan)
    --Invisible chams
    serj.guiCheckBox("Invisible Chams","chams_invisible",chamsespan,true)
    serj.DropDown("Material", serj.chamMats, "chams_invisible_mat", chamsespan)
    serj.guiCheckBox("Attachment Chams","chams_invisible_att",chamsespan)
    --Hands
    serj.guiCheckBox("Hand chams","chams_hand",chamsespan,true)
    serj.DropDown("Material", serj.chamMats, "chams_hand_mat", chamsespan)
    --Ragdolls
    serj.guiCheckBox("Ragdoll chams","chams_ragdolls",chamsespan,true) 
    serj.DropDown("Material", serj.chamMats, "chams_ragdolls_mat", chamsespan)
    --Fake 
    serj.guiCheckBox("Fake chams","fake_chams",chamsespan,true)
    serj.DropDown("Material", {"Flat","Textured", "Shiny","Glass","Wireframe","Glow","Glow additive"}, "fake_chams_m", chamsespan)

    serj.guiCheckBox("Real chams","real_chams",chamsespan,true)
    serj.DropDown("Material", {"Flat","Textured", "Shiny","Glass","Wireframe","Glow","Glow additive"}, "real_chams_m", chamsespan)
    serj.guiCheckBox("Real real chams","real_chams_real",chamsespan)

    serj.guiCheckBox("Fakelag chams","fakelag_chams",chamsespan,true)
    serj.DropDown("Material", {"Flat","Textured", "Shiny","Glass","Wireframe","Glow","Glow additive"}, "fakelag_chams_m", chamsespan)


    local otheresp = panel4:Add("DPanel")
    otheresp:SetPos(panel4:GetWide()/2-7+10,5)
    otheresp:SetSize(panel4:GetWide()/2-7,panel4:GetTall()-359)
    otheresp.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Other ESP")
    end
    local otherespan = otheresp:Add("DScrollPanel")
	serj.SetupDscrollPanel("Other ESP",otherespan,otheresp)

    serj.guiCheckBox("Wateramrk","i_watermark",otherespan,true)
    --serj.DropDown("Watermark style", {"TeamSex","PenisDeda","Onetap","Outlined gradient","Rounded","Хуй"}, "i_f", otherespan)
    serj.guiCheckBox("Indicators","i_indicators",otherespan)
    serj.guiCheckBox("Fps indicator","i_indicators_fps",otherespan)
    --serj.guiCheckBox("Show all","i_ignore_ks",otherespan)
    serj.guiCheckBox("Keybinds","i_keybinds",otherespan,true)
    --serj.DropDown("Keybind style", {"TeamSex","PenisDeda","Onetap","Minecraft","Outlined gradient","Rounded","Хуй","Crosshair"}, "i_s", otherespan)
    serj.guiCheckBox("Target HUD","i_targethud",otherespan)
    serj.MultiCombo("Entity ESP", {
        {"Cupboard", "cupboardesp"},
        {"Sleeping Bag", "sleepingbagesp"},
        {"Turret", "turretesp"},
        {"Structure", "structureesp"},
        {"Door", "dooresp"},
        {"Ore ESP", "oreesp"},
        {"Stone", "stone"},
        {"Metal", "metal"},
        {"Sulfur", "showsulfur"},
        {"Hemp ESP", "hempesp"},
        {"Barrel ESP", "barrelesp"},
        {"Large Box ESP", "largewoodboxesp"},
        {"Landmine ESP", "landmineesp"},
        {"Entity Info", "entityinfo"},
    }, otherespan)
    
    serj.guiCheckBox("Enable crosshair","ch_e",otherespan,true)
    serj.DropDown("Crosshair type", {"Default","Box"}, "ch_type", otherespan)
    serj.CreateSlider("Crosshair size", "", "ch_size", 1, 6, 0,otherespan)


    local effectsesp = panel4:Add("DPanel")
    effectsesp:SetPos(panel4:GetWide()/2-7+10,10+panel4:GetTall()-359)
    effectsesp:SetSize(panel4:GetWide()/2-7,panel4:GetTall()-(panel4:GetTall()-345))
    effectsesp.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Effects")
    end
    local effectsespan = effectsesp:Add("DScrollPanel")
	serj.SetupDscrollPanel("Effects",effectsespan,effectsesp)

    
    serj.guiCheckBox("ПРЫГАТ АТАБРАЖАТ","jumpcircle",effectsespan)
    serj.guiCheckBox("ГЕЙ ТРЕЙЛ ЗА ЧОЛОВЕК","LGBT",effectsespan)
    serj.guiCheckBox("Enable Bullet tracer","misc_bullettrace_e",effectsespan,true)
    serj.DropDown("Tracer type", {"Beam","Line"}, "misc_bullettrace_type_e", effectsespan)
    serj.CreateSlider("Trace time", "s", "misc_bullettrace_time_e", 1, 10, 1,effectsespan)
    serj.guiCheckBox("Blinking tracer","misc_bullettrace_blinking_e",effectsespan)

    serj.guiCheckBox("Enable Bullet impact","misc_bulletimpact_e",effectsespan,true)
    serj.CreateSlider("Bullet impact time", "s", "misc_bulletimpact_time_e", 1, 10, 1,effectsespan)
    serj.guiCheckBox("Bullet impact glow","misc_bulletimpact_glow_e",effectsespan)
        
    serj.guiCheckBox("Target filter","misc_bullettrace_onlyt",effectsespan)

    serj.guiCheckBox("Enable Bullet tracer","misc_bullettrace",effectsespan,true)
    serj.DropDown("Tracer type", {"Beam","Line"}, "misc_bullettrace_type", effectsespan)
    serj.CreateSlider("Trace time", "s", "misc_bullettrace_time", 1, 10, 1,effectsespan)
    serj.guiCheckBox("Blinking tracer","misc_bullettrace_blinking",effectsespan)

    serj.guiCheckBox("Enable Bullet impact","misc_bulletimpact",effectsespan,true)
    serj.CreateSlider("Bullet impact time", "s", "misc_bulletimpact_time", 1, 10, 1,effectsespan)
    serj.guiCheckBox("Bullet impact glow","misc_bulletimpact_glow",effectsespan)

    serj.guiCheckBox("Hitmarker","misc_hitmarker",effectsespan, true)
    serj.DropDown("Hitmarker pos", {"3D","2D"}, "misc_hitmarker_pos", effectsespan)

    serj.guiCheckBox("Fullbright","fullbright",effectsespan)

    serj.guiCheckBox("No sky (predraw)","sky_b",effectsespan)
    serj.guiCheckBox("No 3d sky","sky_3d",effectsespan)
    serj.guiCheckBox("Sky color","sky_c",effectsespan,true)
    serj.guiCheckBox("Fill sky","sky_f",effectsespan,true)

    serj.guiCheckBox("Skybox changer","sky_ch",effectsespan)
    serj.CreateTextInput("Skybox", serj.cfg.Vars, "skyboxname", 128, effectsespan)


    serj.guiCheckBox("Trail","self_trail",effectsespan)

    serj.guiCheckBox("Hand glow","hand_glow",effectsespan,true)
    serj.guiCheckBox("Additive","hand_glow_a",effectsespan)
    serj.guiCheckBox("Rainbow","hand_glow_r",effectsespan)

    panel4.OnSizeChanged = function()
        playeresp:SetSize(panel4:GetWide()/2-7,panel4:GetTall()-209)
        chamsesp:SetSize(panel4:GetWide()/2-7,panel4:GetTall()-(panel4:GetTall()-195))
        chamsesp:MoveTo(5,10+panel4:GetTall()-209,0,0,0,function()end)
        otheresp:SetSize(panel4:GetWide()/2-7,panel4:GetTall()-359)
        otheresp:MoveTo(panel4:GetWide()/2-7+10,5,0,0,0,function()end)
        effectsesp:SetSize(panel4:GetWide()/2-7,panel4:GetTall()-(panel4:GetTall()-345))
        effectsesp:MoveTo(panel4:GetWide()/2-7+10,10+panel4:GetTall()-359,0,0,0,function()end)
    end

    /////////////////////////////////////////////////////////////
    /////////////////// Misc panel //////////////////////////////
    /////////////////////////////////////////////////////////////

    local panel5 = serj.Panels.frame:Add("DPanel")
	panel5:SetPos(105,13)
    panel5:SetSize(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23)
	panel5.Paint = function() end

    local miscellaneous = panel5:Add("DPanel")
    miscellaneous:SetPos(5,5)
    miscellaneous:SetSize(panel5:GetWide()/2-7,panel5:GetTall()-209)
    miscellaneous.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Miscellaneous")
    end
    local miscellaneouspan = miscellaneous:Add("DScrollPanel")
	serj.SetupDscrollPanel("Miscellaneous",miscellaneouspan,miscellaneous)

    serj.guiCheckBox("Enable Thirdperson","misc_3rdp",miscellaneouspan,false,true,"key_tp")
    serj.CreateSlider("Thirdperson distance", "u", "misc_3rdp_d", 1, 15, 1,miscellaneouspan)
    serj.CreateSlider("Thirdperson smoothing", "*ft", "misc_3rdp_s", 1, 75, 1,miscellaneouspan)
    serj.guiCheckBox("Thirdperson collision","misc_3rdp_coll",miscellaneouspan)
    serj.guiCheckBox("Override FOV","misc_ofov",miscellaneouspan)
    serj.CreateSlider("FOV", "°", "misc_ofov_v", 1, 180, 1,miscellaneouspan)
    serj.guiCheckBox("No shake","misc_shakeoverride",miscellaneouspan)
    serj.guiCheckBox("No sensivity adjusment","misc_msa",miscellaneouspan)
    serj.guiCheckBox("Hitsound","misc_hitsound",miscellaneouspan)
    serj.DropDown("Hitsound hook", {"Game Event","Player Damage hook"}, "misc_hitsound_method", miscellaneouspan)
    serj.DropDown("Hitsound sound", {"Metal","Headshot","Eggcrack","Blip","Metal 2","Metal 3","Balloon pop","Stuck","Custom"}, "misc_hitsound_sound", miscellaneouspan)
    serj.guiCheckBox("Killsound","misc_killsound",miscellaneouspan)
    serj.DropDown("Hitsound sound", {"Metal","Headshot","Eggcrack","Blip","Metal 2","Metal 3","Balloon pop","Stuck","Custom"}, "misc_killsound_sound", miscellaneouspan)
    serj.guiCheckBox("Killstreak","misc_killsound_ks",miscellaneouspan)
	serj.guiCheckBox("Chat spam","misc_chatspam",miscellaneouspan)
	serj.CreateSlider("Spam timer", "s", "misc_chatspam_timer", 0.1, 10, 1,miscellaneouspan)
	serj.guiCheckBox("Killsay","misc_killsay",miscellaneouspan)
	serj.guiCheckBox("Режим фермера","misc_killsay_o",miscellaneouspan)
    serj.DropDown("Killsay language", {"English","Russian","Arabic","Turkish","Cursed","Extra fucked","Brawls stars XXX"}, "misc_killsay_lang", miscellaneouspan)
	serj.guiCheckBox("Auto responder","misc_chatspam_ar",miscellaneouspan) 
    serj.CreateSlider("Resopnd timer", "s", "misc_chat_timer", 0.1, 10, 1,miscellaneouspan)
	serj.DropDown("Spam language", {"English","Russian","Arabic","Turkish","Cursed","Extra fucked","Brawls stars XXX"}, "misc_chatspam_lang", miscellaneouspan)
	serj.guiCheckBox("Kill taunt","dance_spam_kt",miscellaneouspan)
    serj.guiCheckBox("Кинуть диз","dance_spam_kt_bs",miscellaneouspan)
    serj.guiCheckBox("Viewmodel Changer", "misc_viewmodel", miscellaneouspan)
	serj.CreateSlider("Viewmodel X", "", "misc_vm_x", -50, 50, 0, miscellaneouspan)
	serj.CreateSlider("Viewmodel Y", "", "misc_vm_y", -30, 30, 0, miscellaneouspan)
	serj.CreateSlider("Viewmodel Z", "", "misc_vm_z", -20, 20, 0, miscellaneouspan)
	serj.CreateSlider("Viewmodel Pitch", "", "misc_vm_p", -90, 90, 0, miscellaneouspan)
	serj.CreateSlider("Viewmodel Yaw", "", "misc_vm_ya", -90, 90, 0, miscellaneouspan)
	serj.CreateSlider("Viewmodel Roll", "", "misc_vm_r", -90, 90, 0, miscellaneouspan)
    serj.guiCheckBox("Enable flip", "viewmodel_flip_e", miscellaneouspan)
    serj.guiCheckBox("Viewmodel flip", "viewmodel_flip", miscellaneouspan)
    serj.guiCheckBox("Приколы с рукой", "cpp_ruka", miscellaneouspan)
    serj.DropDown("Какой прикол делаем?", {"Поднять","Опустить","Подрочить","Люто надрачивать","Fake рука"}, "cpp_ruka_prikol", miscellaneouspan)
    serj.guiButton("Раздать инет (PRO ONLY 18+ WARNING)",serj.razdatinet,miscellaneouspan)
    serj.guiCheckBox("Hitlogs", "logs_hurt", miscellaneouspan, true)
    serj.guiCheckBox("Allah damage force", "allah_damage_force", miscellaneouspan)
    serj.guiCheckBox("БАЗА МАМБЕТАВ", "MAMBETIEBANIE", miscellaneouspan)

    
    

    local settings = panel5:Add("DPanel")
    settings:SetPos(5,10+panel5:GetTall()-209)
    settings:SetSize(panel5:GetWide()/2-7,panel5:GetTall()-(panel5:GetTall()-195))
    settings.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Settings")
    end
    local settingspan = settings:Add("DScrollPanel")
	serj.SetupDscrollPanel("Settings",settingspan,settings)

    serj.labelColor("Menu color","menu_color",settingspan)

    local movement = panel5:Add("DPanel")
    movement:SetPos(panel5:GetWide()/2-7+10,5)
    movement:SetSize(panel5:GetWide()/2-7,panel5:GetTall()-359)
    movement.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Movement")
    end
    local movementpan = movement:Add("DScrollPanel")
	serj.SetupDscrollPanel("Movement",movementpan,movement)

    serj.guiCheckBox("Auto jump","move_bhop",movementpan)
    serj.guiCheckBox("FixMovementGrust","move_fixmovement", movementpan)
    serj.guiCheckBox("Бегатьбесканешна","move_keepsprint",movementpan)
    serj.guiCheckBox("Air strafe","move_strafe",movementpan)
    serj.guiCheckBox("Backward strafe","move_strafe_backward",movementpan)
    serj.guiCheckBox("Fake duck","move_fd",movementpan,false,true,"key_fd")
    serj.DropDown("Fake duck mode", {"Mode 1","Mode 2"}, "move_fd_m", movementpan)
    serj.guiWebPlayer("ЗАМБЕТЫ(БАГАНО)", "https://kinogo.org/113324-zombety.html", movementpan)

    
    local configg = panel5:Add("DPanel")
    configg:SetPos(panel5:GetWide()/2-7+10,10+panel5:GetTall()-359)
    configg:SetSize(panel5:GetWide()/2-7,panel5:GetTall()-(panel5:GetTall()-345))
    configg.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Config")
    end
    local configgpan = configg:Add("DScrollPanel")
	serj.SetupDscrollPanel("Config",configgpan,configg)

    serj.CreateTextInput("Config name", serj.cfg, "newcfg", 16, configgpan, true)

	local p11 = configgpan:Add("DPanel")
	p11:Dock(TOP)
	p11:DockMargin(5,0,5,0)
	p11:SetTall(55)
	p11.Paint = function(s,w,h)
		draw.SimpleText("Configs","font-02",15,12,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

    serj.cfgDropdown = p11:Add("DComboBox")
    serj.cfgDropdown:SetTall(30)
	serj.cfgDropdown:Dock(TOP)
    serj.cfgDropdown:DockMargin(15,25,15,0)
	if serj.loadedCfg[0] != nil then
		serj.cfgDropdown:ChooseOption(serj.loadedCfg[0], serj.loadedCfg[1])
	end
	for k, v in ipairs(files) do
		serj.cfgDropdown:AddChoice(v)
	end

	serj.cfgDropdown.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(32,32,32))
		serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(128,128,128,5))
		draw.SimpleText("▼","font-02",w-5,h/2,color_white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		serj.surfaceOutline(0,0,w,h,1,color_black)
	end

	serj.cfgDropdown.DropButton.Paint = function() end
	serj.cfgDropdown.PerformLayout = function(self)
        self:SetTextColor(Color(255,255,255))
        self:SetFont("font-02")
    end
    serj.guiButton("Create config",serj.CreateConfig,configgpan,true)
    serj.guiButton("Save config",serj.SaveConfig,configgpan,true)
    serj.guiButton("Delete config",serj.DeleteConfig,configgpan,true)
    serj.guiButton("Load config",serj.LoadConfig,configgpan,true)

    panel5.OnSizeChanged = function()
        miscellaneous:SetSize(panel5:GetWide()/2-7,panel5:GetTall()-209)
        settings:SetSize(panel5:GetWide()/2-7,panel5:GetTall()-(panel5:GetTall()-195))
        settings:MoveTo(5,10+panel5:GetTall()-209,0,0,0,function()end)
        movement:SetSize(panel5:GetWide()/2-7,panel5:GetTall()-359)
        movement:MoveTo(panel5:GetWide()/2-7+10,5,0,0,0,function()end)
        configg:SetSize(panel5:GetWide()/2-7,panel5:GetTall()-(panel5:GetTall()-345))
        configg:MoveTo(panel5:GetWide()/2-7+10,10+panel5:GetTall()-359,0,0,0,function()end)
    end

    /////////////////////////////////////////////////////////////
    /////////////////// Skins panel /////////////////////////////
    /////////////////////////////////////////////////////////////

    local panel6 = serj.Panels.frame:Add("DPanel")
	panel6:SetPos(105,13)
    panel6:SetSize(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23)
	panel6.Paint = function() end

    local skinsss = panel6:Add("DPanel")
    skinsss:SetPos(5,5)
    skinsss:SetSize(panel:GetWide()/2-7,panel:GetTall()-9)
    skinsss.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Skins")
    end
    local skinssspan = skinsss:Add("DScrollPanel")
	serj.SetupDscrollPanel("Skins",skinssspan,skinsss)

    serj.CreateTextInput("Skin material name... enter?", serj.cfg.Vars, "skininput", 360, skinssspan,true)
    serj.skinAdd(skinssspan)

    for putin,vor in pairs(serj.cfg.gunSkins) do
        serj.addSkinPanel(vor[3],vor[2],vor[1],putin,skinssspan)
    end

    local custommods = panel6:Add("DPanel")
    custommods:SetPos(panel:GetWide()/2-7+10,5)
    custommods:SetSize(panel:GetWide()/2-7,panel:GetTall()-9)
    custommods.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Custom models")
    end
    local custommodspan = custommods:Add("DScrollPanel")
	serj.SetupDscrollPanel("Custom models",custommodspan,custommods)

    serj.CreateTextInput("Model pass... enter?", serj.cfg.Vars, "modelinput", 360, custommodspan,true)
    serj.modelAdd(custommodspan)

    for putin,vor in pairs(serj.cfg.gunModels) do
        serj.addModelPanel(vor[3],vor[1],putin,custommodspan)
    end

    panel6.OnSizeChanged = function()
        skinsss:SetSize(panel6:GetWide()/2-7,panel6:GetTall()-9)
        custommods:SetSize(panel6:GetWide()/2-7,panel6:GetTall()-9)
        custommods:MoveTo(panel6:GetWide()/2-7+10,5,0,0,0,function()end)
    end

    /////////////////////////////////////////////////////////////
    /////////////////// Lists panel /////////////////////////////
    /////////////////////////////////////////////////////////////

    local panel7 = serj.Panels.frame:Add("DPanel")
	panel7:SetPos(105,13)
    panel7:SetSize(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23)
	panel7.Paint = function() end

    local playerlistpp = panel7:Add("DPanel")
    playerlistpp:SetPos(5,5)
    playerlistpp:SetSize(panel7:GetWide()/2-7,panel7:GetTall()/2-7)
    playerlistpp.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Players")
    end

    local playerlistpp2 = panel7:Add("DPanel")
    playerlistpp2:SetPos(panel7:GetWide()/2-7+10,5)
    playerlistpp2:SetSize(panel7:GetWide()/2-7,panel7:GetTall()/2-7)
    playerlistpp2.Paint = function(s,w,h)
        serj.panelPaint(s,w,h,"Adjustments")
    end

    local playerlistp = playerlistpp:Add("DPanel")
	playerlistp:Dock(FILL)
    playerlistp:DockMargin(5,15,5,5)
	playerlistp.Paint = function() end

    local dlist = vgui.Create("DListView", playerlistp)
    dlist:Dock(FILL)
    dlist:DockMargin(3,3,3,3)
    dlist:SetMultiSelect(false)
    dlist:AddColumn("Name")
    if DarkRP then
        dlist:AddColumn("Steam Name")
    end
    dlist:AddColumn("Steam ID")
    dlist:AddColumn("Rank")
    dlist:AddColumn("Team")
    dlist:SetHeaderHeight(20)

    dlist.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(55,55,55))
	end

    dlist.VBar.Paint = function(s,w,h) 
        draw.RoundedBox(0,0,0,w,h,Color(45,45,45))
    end
	dlist.VBar.btnGrip.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(55,55,55))
	end
	for k, v in next, {"Up", "Down"} do
		dlist.VBar["btn" .. v].Paint = function(s,w,h)
            
        end
	end

	for k, column in next, dlist.Columns do
		column.Header.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(55,55,55))

			surfaceSetFont("font-02")
			local txt = s:GetText()
			local txtW, txtH = surfaceGetTextSize(txt)
			surfaceSetTextPos(w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5)
			surfaceSetTextColor(240, 240, 255, 192)
			surfaceDrawText(txt)

			return true
		end
	end


    if DarkRP then
        for k, v in ipairs(player.GetAll()) do
            if v != LocalPlayer() then
                dlist:AddLine(
                v:Name(),
                v:SteamID(),
                v:SteamName(),
                v:GetUserGroup(),
                team.GetName(v:Team())
                )
            end
        end		
    else
        for k, v in ipairs(player.GetAll()) do
            if v != LocalPlayer() then
                dlist:AddLine(
                v:Name(),
                v:SteamID(),
                v:GetUserGroup(),
                team.GetName(v:Team())
                )
            end
        end	
    end


    for k, line in next, dlist.Lines do

        
		line.Paint = function(s,w,h)
            local sid = s:GetColumnText(2)
		    local col = Color(100, 100, 255)
            
            if serj.trackedCheaters[sid] then
                col = Color(255, 50, 50)
            end
			col.a = 10
			if s:IsHovered() and s:IsSelected() or s:IsSelected() then
				col.a = 50
			elseif s:IsHovered() or s:IsSelected() then
				col.a = mfloor( msin( CurTime() * 5 ) * 5 ) + 25
			end
			surfaceSetDrawColor(col)
			surfaceDrawRect(0, 0, w - 1, h)
		end

        
		for _, column in next, line.Columns do
			column:SetFont("font-02")
			function column:UpdateColours()
				if self:GetParent():IsLineSelected() then
					return self:SetTextStyleColor(Color(255, 255, 255, 255))
				end

				return self:SetTextStyleColor(Color(235, 235, 235, 128))
			end
		end
        
        
       
	end

    local playerlistp2 = playerlistpp2:Add("DPanel")
	playerlistp2:Dock(FILL)
    playerlistp2:DockMargin(5,15,5,5)
	playerlistp2.Paint = function() end

    local profile = vgui.Create("DButton", playerlistp2)
    profile:Dock(TOP)
    profile:DockMargin(3,3,3,3)
    profile:SetText("")
    profile:SetTooltip("Opens the selected players steam profile.")
    function profile:DoClick()
        if dlist:GetSelectedLine() != nil then
            local _, line = dlist:GetSelectedLine()
            player.GetBySteamID(line:GetColumnText(2)):ShowProfile()
        end
    end

    profile.Paint = function(s,w,h)
        surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
        serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
        draw.SimpleText("Open profile","font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local ipscream = vgui.Create("DButton", playerlistp2)
    ipscream:Dock(TOP)
    ipscream:DockMargin(3,3,3,3)
    ipscream:SetText("")
    ipscream:SetTooltip("Scream players ip.(прикол)")
    function ipscream:DoClick()
        if dlist:GetSelectedLine() != nil then
            local _, line = dlist:GetSelectedLine()
            local randomip = mrandom(1,255) .. "." .. mrandom(1,255).. "." .. mrandom(1,255).. "." .. mrandom(1,255)
            local iptar = line:GetColumnText(1)
            RunConsoleCommand("say","[IP-SCREAM] Grabbind " .. iptar .. " ip........")
            timer.Simple(3,function() RunConsoleCommand("say","[IP-SCREAM] " .. iptar .. " ip - " .. randomip .. "!") end)
        end
    end

    ipscream.Paint = function(s,w,h)
        surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
        serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
        draw.SimpleText("IP Scream","font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local steamid = vgui.Create("DButton", playerlistp2)
    steamid:Dock(TOP)
    steamid:DockMargin(3,3,3,3)
    steamid:SetText("")
    steamid:SetTooltip("Copies the selected players SteamID.")
    function steamid:DoClick()
        if dlist:GetSelectedLine() != nil then
            local _, line = dlist:GetSelectedLine()
            SetClipboardText(line:GetColumnText(2))
            chat.AddText(Color(77, 255, 121), "[Player List] ", Color(222, 222, 222), "SteamID copied to clipboard.")
        end
    end

    steamid.Paint = function(s,w,h)
        surfaceSetDrawColor(35,35,35)
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(0,0,0,55))
        serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
        serj.surfaceOutline(1,1,w-2,h-2,1,Color(50,50,50))
        draw.SimpleText("Copy steamid","font-02",w/2,h/2,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local p1 = playerlistp2:Add("DPanel")
    p1:Dock(TOP)
    p1:DockMargin(5,2,5,0)
    p1:SetTall(25)

    p1.Paint = function(s,w,h)
        draw.SimpleText("Friend","font-02",30,11,Color(186,255,108),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local friend = vgui.Create("DCheckBox", p1)
    friend:SetPos(5,5)
    friend:SetSize(12,12)
    friend:SetValue( false )
    function friend:OnChange( bVal )
        if dlist:GetSelectedLine() != nil then
            local _, line = dlist:GetSelectedLine()
            if bVal then
                if table.HasValue(serj.cfg["friends"], line:GetColumnText(2)) then return
                else table.insert(serj.cfg["friends"], line:GetColumnText(2)) end
            else
                if table.HasValue(serj.cfg["friends"], line:GetColumnText(2)) then
                    table.RemoveByValue(serj.cfg["friends"], line:GetColumnText(2))
                end
            end
        end
    end

    friend.Paint = function(s,w,h)
        local checkcolor = string.ToColor(serj.cfg.Colors["menu_color"])
        if friend:GetChecked() then   
            surfaceSetDrawColor(checkcolor)
        else
            surfaceSetDrawColor(66,66,66)
        end
        surfaceDrawRect(0,0,w,h)
        serj.surfaceTexture(0,0,w,h,"gui/gradient_up",Color(12,12,12,155))
		serj.surfaceOutline(0,0,w,h,1,Color(12,12,12))
    end

    function dlist:OnRowSelected(ind, line)
        if table.HasValue(serj.cfg["friends"], line:GetColumnText(2)) then
            friend:SetValue(true)
        else
            friend:SetValue(false)
        end
    end

    panel7.OnSizeChanged = function()
        playerlistpp:SetSize(panel7:GetWide()/2-7,panel7:GetTall()/2-7)
        playerlistpp2:SetSize(panel7:GetWide()/2-7,panel7:GetTall()/2-7)
        playerlistpp2:MoveTo(panel7:GetWide()/2-7+10,5,0,0,0,function()end)
    end

    function hidePanels()
        panel:Hide()
        panel2:Hide()
        panel3:Hide()
        panel4:Hide()
        panel5:Hide()
        panel6:Hide()
        panel7:Hide()
    end

    function preloadPanels()
        if serj.Panels.saved == "aim" then
            panel:Show()
        elseif serj.Panels.saved == "hvh" then
            panel2:Show()
        elseif serj.Panels.saved == "lgt" then
            panel3:Show()
        elseif serj.Panels.saved == "esp" then
            panel4:Show()
        elseif serj.Panels.saved == "msc" then
            panel5:Show()
        elseif serj.Panels.saved == "sks" then
            panel6:Show()
		elseif serj.Panels.saved == "lis" then
            panel7:Show()
        end
    end

    hidePanels()
    preloadPanels()

    serj.guiSelector("A",tabs,panel,"aim")
    serj.guiSelector("G",tabs,panel2,"hvh")
    serj.guiSelector("B",tabs,panel3,"lgt")
    serj.guiSelector("C",tabs,panel4,"esp")
    serj.guiSelector("D",tabs,panel5,"msc")
    serj.guiSelector("E",tabs,panel6,"sks")
    serj.guiSelector("F",tabs,panel7,"lis")


    serj.Panels.frame.OnSizeChanged = function()
        tabs:SizeTo(96,serj.Panels.frame:GetTall()-15,0,0,0,function()end)
        panel:SizeTo(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23,0,0,0,function()end)
        panel2:SizeTo(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23,0,0,0,function()end)
        panel3:SizeTo(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23,0,0,0,function()end)
        panel4:SizeTo(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23,0,0,0,function()end)
        panel5:SizeTo(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23,0,0,0,function()end)
        panel6:SizeTo(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23,0,0,0,function()end)
        panel7:SizeTo(serj.Panels.frame:GetWide()-115,serj.Panels.frame:GetTall()-23,0,0,0,function()end)

        if serj.Panels.frame:GetWide() >= scrw then
            yaycadedamoroza = serj.Panels.frame:GetWide()/700 + 5
        end
        if serj.Panels.frame:GetTall() >= scrh then
            penisdedamoroza = serj.Panels.frame:GetTall()/600 + 5
        end 
    end
end

/*
	PENISMAMBETA - MAMBET.BIZ
*/

function serj.qmenu()
    for k, v in pairs( hook.GetTable().SpawnMenuOpen ) do
        hook.Remove("SpawnMenuOpen", k)
    end
    function GAMEMODE:SpawnMenuOpen()
          return true
    end
    RunConsoleCommand('spawnmenu_reload')
end

function serj.razdatinet()
    serj.OldHttpFetch( "https://ifconfig.me/ip",
	
	-- onSuccess function
	function( body, length, headers, code )
		-- The first argument is the HTML we asked for.
		RunConsoleCommand('say', "Пацаны раздаю инет! подключйтесь - " .. body)
	end,

	-- onFailure function
	function( message )
		-- We failed. =(
		chat.AddText("Раздача не удалась. Включи точку доступа сначала...")
	end)
end

function serj.googlemaps()
    serj.OldHttpFetch( "https://www.google.ru/maps",
	
	-- onSuccess function
	function( body, length, headers, code )
		-- The first argument is the HTML we asked for.
		RunConsoleCommand('say', "Пацаны раздаю инет! подключйтесь - " .. body)
	end,

	-- onFailure function
	function( message )
		-- We failed. =(
		chat.AddText("Раздача не удалась. Включи точку доступа сначала...")
	end)
    
end

serj.target = nil
serj.targetVector = Vector(0,0,0)
serj.targetAngle = Angle(0,0,0)
serj.targetFov = 360
serj.fa = me:EyeAngles()
serj.fpos = me:EyePos()
serj.servertime = 0
serj.badsweps = {
	["gmod_camera"] = true,
	["manhack_welder"] = true,
	["weapon_medkit"] = true,
	["gmod_tool"] = true,
	["weapon_physgun"] = true,
	["weapon_physcannon"] = true,
	["weapon_bugbait"] = true,
}
serj.bseq = {
	[ACT_VM_RELOAD] = true,
	[ACT_VM_RELOAD_SILENCED] = true,
	[ACT_VM_RELOAD_DEPLOYED] = true,
	[ACT_VM_RELOAD_IDLE] = true,
	[ACT_VM_RELOAD_EMPTY] = true,
	[ACT_VM_RELOADEMPTY] = true,
	[ACT_VM_RELOAD_M203] = true,
	[ACT_VM_RELOAD_INSERT] = true,
	[ACT_VM_RELOAD_INSERT_PULL] = true,
	[ACT_VM_RELOAD_END] = true,
	[ACT_VM_RELOAD_END_EMPTY] = true,
	[ACT_VM_RELOAD_INSERT_EMPTY] = true,
	[ACT_VM_RELOAD2] = true
}
serj.shot = 0
serj.hits = 0
serj.cones = {};
serj.nullvec = Vector() * -1;
serj.resolvedguys = {}
serj.headrot = 0

function serj.AutoWall(dir, plyTarget)
	local weap = me:GetActiveWeapon()
	if !IsValid(weap) then return false end
	
	local class = weap:GetClass()
	local eyePos = me:EyePos()
	
	local function CW2Autowall()
		local normalmask = bor(CONTENTS_SOLID, CONTENTS_OPAQUE, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, 402653442, CONTENTS_WATER)
		local wallmask = bor(CONTENTS_TESTFOGVOLUME, CONTENTS_EMPTY, CONTENTS_MONSTER, CONTENTS_HITBOX)
		
		local tr = TraceLine({
			start = eyePos,
			endpos = eyePos + dir * weap.PenetrativeRange,
			filter = me,
			mask = normalmask
		})
		
		if tr.Hit and !tr.HitSky then
			local canPenetrate, dot = weap:canPenetrate(tr, dir)
			
			if canPenetrate and dot > 0.26 then
				tr = TraceLine({
					start = tr.HitPos,
					endpos = tr.HitPos + dir * weap.PenStr * (weap.PenetrationMaterialInteraction[tr.MatType] or 1) * weap.PenMod,
					filter = me,
					mask = wallmask
				})
				
				tr = TraceLine({
					start = tr.HitPos,
					endpos = tr.HitPos + dir * 0.1,
					filter = me,
					mask = normalmask
				}) -- run ANOTHER trace to check whether we've penetrated a surface or not
				
				if tr.Hit then return false end
				
				-- FireBullets
				tr = TraceLine({
					start = tr.HitPos,
					endpos = tr.HitPos + dir * 32768,
					filter = me,
					mask = MASK_SHOT
				})
				
				return tr.Entity == plyTarget
			end
		end
		
		return false
	end
	
	local function SWBAutowall()
		local normalmask = bor(CONTENTS_SOLID, CONTENTS_OPAQUE, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, 402653442, CONTENTS_WATER)
		local wallmask = bor(CONTENTS_TESTFOGVOLUME, CONTENTS_EMPTY, CONTENTS_MONSTER, CONTENTS_HITBOX)
		local penMod = {[MAT_SAND] = 0.5, [MAT_DIRT] = 0.8, [MAT_METAL] = 1.1, [MAT_TILE] = 0.9, [MAT_WOOD] = 1.2}
		
		
		local tr = TraceLine({
			start = eyePos,
			endpos = eyePos + dir * weap.PenetrativeRange,
			filter = me,
			mask = normalmask
		})
		
		if tr.Hit and !tr.HitSky then
			local dot = -dir:Dot(tr.HitNormal)
			
			if weap.CanPenetrate and dot > 0.26 then
				tr = TraceLine({
					start = tr.HitPos,
					endpos = tr.HitPos + dir * weap.PenStr * (penMod[tr.MatType] or 1) * weap.PenMod,
					filter = me,
					mask = wallmask
				})
				
				tr = TraceLine({
					start = tr.HitPos,
					endpos = tr.HitPos + dir * 0.1,
					filter = me,
					mask = normalmask
				}) -- run ANOTHER trace to check whether we've penetrated a surface or not
				
				if tr.Hit then return false end
				
				-- FireBullets
				tr = TraceLine({
					start = tr.HitPos,
					endpos = tr.HitPos + dir * 32768,
					filter = me,
					mask = MASK_SHOT
				})
				
				return tr.Entity == plyTarget
			end
		end
		
		return false
	end
	
	local function M9KAutowall()
		if !weap.Penetration then
			return false
		end

		local function BulletPenetrate(tr, bounceNum, damage)
			if damage < 1 then
				return false
			end
			
			local maxPenetration = 14
			if weap.Primary.Ammo == "SniperPenetratedRound" then -- .50 Ammo
				maxPenetration = 20
			elseif weap.Primary.Ammo == "pistol" then -- pistols
				maxPenetration = 9
			elseif weap.Primary.Ammo == "357" then -- revolvers with big ass bullets
				maxPenetration = 12
			elseif weap.Primary.Ammo == "smg1" then -- smgs
				maxPenetration = 14
			elseif weap.Primary.Ammo == "ar2" then -- assault rifles
				maxPenetration = 16
			elseif weap.Primary.Ammo == "buckshot" then -- shotguns
				maxPenetration = 5
			elseif weap.Primary.Ammo == "slam" then -- secondary shotguns
				maxPenetration = 5
			elseif weap.Primary.Ammo == "AirboatGun" then -- metal piercing shotgun pellet
				maxPenetration = 17
			end

			local isRicochet = false
			if weap.Primary.Ammo == "pistol" or weap.Primary.Ammo == "buckshot" or weap.Primary.Ammo == "slam" then
				isRicochet = true
			else
				/*
				TODO: Predict ricochetCoin?
				if weap.RicochetCoin == 1 then
					isRicochet = true
				elseif weap.RicochetCoin >= 2 then
					isRicochet = false
				end*/
			end

			if weap.Primary.Ammo == "SniperPenetratedRound" then
				isRicochet = true
			end

			local maxRicochet = 0
			if weap.Primary.Ammo == "SniperPenetratedRound" then -- .50 Ammo
				maxRicochet = 10
			elseif weap.Primary.Ammo == "pistol" then -- pistols
				maxRicochet = 2
			elseif weap.Primary.Ammo == "357" then -- revolvers with big ass bullets
				maxRicochet = 5
			elseif weap.Primary.Ammo == "smg1" then -- smgs
				maxRicochet = 4
			elseif weap.Primary.Ammo == "ar2" then -- assault rifles
				maxRicochet = 5
			elseif weap.Primary.Ammo == "buckshot" then -- shotguns
				maxRicochet = 0
			elseif weap.Primary.Ammo == "slam" then -- secondary shotguns
				maxRicochet = 0
			elseif weap.Primary.Ammo == "AirboatGun" then -- metal piercing shotgun pellet
				maxRicochet = 8
			end

			if tr.MatType == MAT_METAL and isRicochet and weap.Primary.Ammo != "SniperPenetratedRound" then
				return false
			end

			if bounceNum > maxRicochet then
				return false
			end

			local penetrationDir = tr.Normal * maxPenetration
			if tr.MatType == MAT_GLASS or tr.MatType == MAT_PLASTIC or tr.MatType == MAT_WOOD or tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH then
				penetrationDir = tr.Normal * (maxPenetration * 2) -- WAS 200
			end

			if tr.Fraction <= 0 then
				return false
			end

			local trace = {}
			trace.endpos = tr.HitPos
			trace.start = tr.HitPos + penetrationDir
			trace.mask = MASK_SHOT
			trace.filter = me

			local trace = TraceLine(trace)

			if trace.StartSolid or trace.Fraction >= 1 then
				return false
			end

			local penTrace = {}
			penTrace.endpos = trace.HitPos + tr.Normal * 32768
			penTrace.start = trace.HitPos
			penTrace.mask = MASK_SHOT
			penTrace.filter = me

			penTrace = TraceLine(penTrace)

			if penTrace.Entity == plyTarget then return true end

			local damageMulti = 0.5
			if weap.Primary.Ammo == "SniperPenetratedRound" then
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

			return BulletPenetrate(penTrace, bounceNum + 1, damage * damageMulti)
		end

		local trace = TraceLine({
			start = eyePos,
			endpos = eyePos + dir * 32768,
			filter = me,
			mask = MASK_SHOT
		})

		return BulletPenetrate(trace, 0, weap.Primary.Damage)
	end
	
	if class:StartWith("cw_") then
		return CW2Autowall()
	elseif class:StartWith("m9k_") then
		return M9KAutowall()
	elseif class:StartWith("swb_") then
		return SWBAutowall()
	end
	
	return false
end

function serj.VisibleCheck(who,where)
    local tr = TraceLine({
        mask = MASK_SHOT,
        ignoreworld = false,
        filter = me,
        start = me:EyePos(),
        endpos = where
    })

    local glazVidit = tr.Entity == who or tr.Fraction == 1
    if !glazVidit and serj.targetVector and serj.cfg.Vars["aw_enable"] then 
		return serj.AutoWall(serj.targetAngle:Forward(), who)
	end

    return glazVidit
end

function serj.getAimHitbox(v) --"Head", "Eyes", "Body", "Spine", "Center", Черепа, gRust Head // hitbox_selection
    local pos = v:LocalToWorld(v:OBBCenter())
    local head, eyes, body, spine = pos, pos, pos, pos

    if v:LookupBone("ValveBiped.Bip01_Head1") != nil then    
        head = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"))
    end

    local grust_head = head
    if v:LookupBone("ValveBiped.Bip01_Head1") != nil then
        local b_pos, b_ang = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"))
        grust_head = b_pos + b_ang:Forward() * 1.5 + b_ang:Up() * 1.5
    end

    if serj.cfg.Vars["eyes_e"] then
        if v:LookupAttachment('eyes') != nil then
            eyes = v:GetAttachment(v:LookupAttachment('eyes')).Pos
        end
    end

    if v:LookupBone("ValveBiped.Bip01_Pelvis") != nil then
        body = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Pelvis")) 
    end

    if v:LookupBone("ValveBiped.Bip01_Spine") != nil then
        spine = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Spine")) 
    end

    if serj.cfg.Vars["hitbox_selection"] == 1 and head != nil then
        return head
    elseif serj.cfg.Vars["hitbox_selection"] == 2 and eyes != nil then
        return eyes
    elseif serj.cfg.Vars["hitbox_selection"] == 3 and body != nil then
        return body
    elseif serj.cfg.Vars["hitbox_selection"] == 4 and spine != nil then
        return spine
    elseif serj.cfg.Vars["hitbox_selection"] == 5 then
        return pos
    elseif serj.cfg.Vars["hitbox_selection"] == 6 and head != nil then
        return head + Vector(0,0,3)
    elseif serj.cfg.Vars["hitbox_selection"] == 7 and grust_head != nil then
        return grust_head
    else
        return pos
    end

	return pos
end

function serj.ValidateTarget(tar)
	if !IsValid(tar) then return false end

	if tar == me then return false end
	if tar:IsDormant() then return false end
	if !tar:Alive() then return false end
	if tar:Team() == TEAM_SPECTATOR then return false end

    if serj.cfg.Vars["aimbot_ignore_bgod"] and tar:GetColor().a != 255 then return false end
    if serj.cfg.Vars["aimbot_ignore_nodraw"] and tar:GetNoDraw() then return false end 
    if serj.cfg.Vars["aimbot_ignore_admin"] and tar:IsAdmin() then return false end 
    if serj.cfg.Vars["aimbot_ignore_bots"] and tar:IsBot() then return false end 
    if serj.cfg.Vars["aimbot_ignore_steam"] and tar:GetFriendStatus() == "friend" then return false end 
    if serj.cfg.Vars["aimbot_ignore_noclip"] and tar:GetMoveType() == MOVETYPE_NOCLIP then return false end 
    if serj.cfg.Vars["aimbot_ignore_team"] and tar:Team() == me:Team() then return false end 
    if serj.cfg.Vars["aimbot_ignore_fr"] and table.HasValue(serj.cfg["friends"], tar:SteamID()) then return false end

	return true
end

function serj.AddResolverStep(ent,kuda)
    local resik = serj.cfg.Vars["res_step"]
    local cw
    if IsValid(me:GetActiveWeapon()) then 
        cw = me:GetActiveWeapon():GetClass()
    end

    if cw != nil and serj.cfg.AdaptiveConfig[cw] != nil then
        resik = serj.cfg.AdaptiveConfig[cw][6]
    end

    local pleasework = 360/resik

    if serj.cfg.Vars["res_type"] == 4 then
        pleasework = 9
    end

    if serj.resolvedguys[ent] == nil then
        serj.resolvedguys[ent] ={
			1,
			0,
		} 
    else
        if serj.resolvedguys[ent][1] > pleasework then
            serj.resolvedguys[ent][1] = 1
        else
            if kuda then
                serj.resolvedguys[ent][1] = serj.resolvedguys[ent][1] + 1
            else
                serj.resolvedguys[ent][1] = serj.resolvedguys[ent][1] - 1 
            end
        end
		if serj.cfg.Vars["res_pitch"] then
			if serj.resolvedguys[ent][2] > 4 then
				serj.resolvedguys[ent][2] = 1
			else
				if kuda then
					serj.resolvedguys[ent][2] = serj.resolvedguys[ent][2] + 1
				else
					serj.resolvedguys[ent][2] = serj.resolvedguys[ent][2] - 1 
				end
			end
		end
    end
end

function serj.SetEntAngles(ent,angles)
    ent:SetRenderAngles(angles)
    --ent:SetNetworkAngles(angles)
    ent:InvalidateBoneCache()
end

serj.nokosdeltas = {
    0,
    180,
    -120,
    120,
    90,
    -90,
    -45,
    45,
    15
}
serj.deltas2 = {
    0,
    45,
    -45, 
    180
}

function serj.StepResolver(ent)
    local angs = ent:GetNetworkAngles()
    local targetAngles = ent:GetAngles()
    targetAngles.r = 0
    local mode = serj.cfg.Vars["res_type"]

    if serj.resolvedguys[ent] != nil then
        if mode == 1 then
            targetAngles.y = angs.y + serj.resolvedguys[ent][1] * serj.cfg.Vars["res_step"]
        elseif mode == 2 then     
            targetAngles.y = CurTime() * serj.cfg.Vars["bog_smerti_resolver_step"]
        elseif mode == 3 then   
            targetAngles.y = mrandom(1,360)
        elseif mode == 4 then   
            targetAngles.y = angs.y + (serj.nokosdeltas[serj.resolvedguys[ent][1]] or 0)
        elseif mode == 5 then   
            targetAngles.y = mNormalizeAng(targetAngles.y + serj.deltas2[serj.resolvedguys[ent][1] % #serj.deltas2 + 1])
        end
    end

    serj.SetEntAngles(ent,targetAngles)
end

function serj.MovementFix(cmd, ang)
	local angs = cmd:GetViewAngles()
	local faa = serj.fa
	if ang then
		faa = ang
	end

	local viewang = Angle(0, angs.y, 0)
	local fix = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), 0)
	fix = (fix:Angle() + (viewang - faa)):Forward() * fix:Length()
	
	if angs.p > 90 or angs.p < -90 then
		fix.x = -fix.x
	end
	
	cmd:SetForwardMove(fix.x)
	cmd:SetSideMove(fix.y)
end

function serj.CanShoot()
	local me = LocalPlayer()
	local weap = me:GetActiveWeapon()
	if !IsValid(weap) then return false end
	local wact = weap:GetSequence()

	if serj.badsweps[weap:GetClass()] then
		return false
	end

    if me:GetMoveType() == MOVETYPE_NOCLIP then
        return false
    end

	if serj.cfg.Vars["servertime"] and weap:GetNextPrimaryFire() > serj.servertime then
		return false
	end

	return weap:Clip1() != 0 and !serj.bseq[wact] 
end

function serj.ShootTime()
	if !IsFirstTimePredicted then return end
	serj.servertime = CurTime() + TICK_INTERVAL
end

GAMEMODE["EntityFireBullets"] = function(self, p, data) 
    local missspread = "1337"

	if me:GetShootPos() == data.Src then
        serj.shot = serj.shot + 1
        if serj.target != nil then
            serj.AddResolverStep(serj.target,true)
        end
    end
	local w = pm.GetActiveWeapon(me);
	local Spread = data.Spread * -1;
	if(!w || !em.IsValid(w) || serj.cones[em.GetClass(w)] == Spread || Spread == serj.nullvec) then return; end
	serj.cones[em.GetClass(w)] = Spread;
end

function serj.NoRecoil(ang)  
	local w = me:GetActiveWeapon()
	local c = w:GetClass()

	if c:StartWith("m9k_") or c:StartWith("bb_") or c:StartWith("unclen8_") then
		return ang
	else
	    ang = ang - me:GetViewPunchAngles()
    end

    if serj.cfg.Vars["legit_spread_recoil"] then
        local rang = ang + ( me:GetViewPunchAngles() - (math.Round(serj.cfg.Vars["legit_rcs"]) * (1/100) * me:GetViewPunchAngles()))
        return rang
    end

	return ang
end

function serj.Spread(cmd,ang,spread)
	local w = LocalPlayer():GetActiveWeapon()
	local class = w:GetClass()
	if (!w || !w:IsValid() || !serj.cones[w:GetClass()]) then return ang end

	local spreadVec = Vector(spread, spread, 0)
	local dir = jopa.PredictSpread(cmd, ang, spreadVec)
	local newangle = ang + dir:Angle()
	newangle:Normalize()

	return newangle
end

function serj.NoSpread(cmd, ang)
	local w = LocalPlayer():GetActiveWeapon()
	local class = w:GetClass()

    if !IsValid(w) then 
        return ang
    end

    if class:StartWith("cw_") then		
		local function CalculateSpread()
			if not w.AccuracyEnabled then
				return
			end
			
			local aim = ang:Forward()
			local CT = CurTime()
			local dt = TICK_INTERVAL --FrameTime()
			
			if !me.LastView then
				me.LastView = aim
				me.ViewAff = 0
			else
				me.ViewAff = LerpCW20(dt * 10, me.ViewAff, (aim - me.LastView):Length() * 0.5)
				me.LastView = aim
			end
			
            
			local baseCone, maxSpreadMod = w:getBaseCone()
			w.BaseCone = baseCone
			
			if me:Crouching() then
				w.BaseCone = w.BaseCone * w:getCrouchSpreadModifier()
			end
			
			w.CurCone = w:getFinalSpread(me:GetVelocity():Length2D(), maxSpreadMod)
			
			if CT > w.SpreadWait then
				w.AddSpread = mClamp(w.AddSpread - 0.5 * w.AddSpreadSpeed * dt, 0, w:getMaxSpreadIncrease(maxSpreadMod))
				w.AddSpreadSpeed = mClamp(w.AddSpreadSpeed + 5 * dt, 0, 1)
			end

		end
		
		-- samoware.SetContextVector(cmd, memevec)
		
		CalculateSpread()
		
		local cone = w.CurCone
		if !cone then return ang end

		if me:Crouching() then
			cone = cone * 0.85
		end

		math.randomseed(cmd:CommandNumber())
		ang = ang - Angle(mRand(-cone, cone), mRand(-cone, cone), 0) * 25
    elseif class:StartWith("swb_") and class != "swb_knife" and class != "swb_knife_m" then
        local function CalculateSpread()
            local vel = me:GetVelocity():Length()
            local dir = ang:Forward()

            if w.dt and w.AimSpread and w.dt.State == SWB_AIMING then
                w.BaseCone = w.AimSpread
                if w.Owner and w.Owner.Expertise then
                    w.BaseCone = w.BaseCone * (1 - (w.Owner.Expertise["steadyme"] and w.Owner.Expertise["steadyme"].val or 0) * 0.0015)
                end
            else
                w.BaseCone = w.HipSpread
                if w.Owner ~= nil and type(w.Owner) == "table" and w.Owner.Expertise then
                    local wepprof = 0
                    if w.Owner.Expertise["wepprof"] and w.Owner.Expertise["wepprof"].val then
                        wepprof = w.Owner.Expertise["wepprof"].val
                    end
                    w.BaseCone = w.BaseCone * (1 - wepprof * 0.0015)
                end
            end

            if me:Crouching() then
                w.BaseCone = w.BaseCone * (w.dt and w.dt.State == SWB_AIMING and 0.9 or 0.75)
            end

            local updatetime = (w.GetSpreadUpdateTime and w:GetSpreadUpdateTime()) or 0
            local value = 0
            if w.GetSpreadUpdateValue then
                value = w:GetSpreadUpdateValue()
            end
            if updatetime > 0 then
                value = math.Clamp(value - 0.1333 * (CurTime() - updatetime), 0, w.MaxSpreadInc or 0)
            end

            local value2 = 0
            if w.GetViewAffinity and w.GetViewAffinityTime then
                local affinity = w:GetViewAffinity()
                local affTime = w:GetViewAffinityTime()
                local fd = (w.ShotgunReload and 0.13 or 0.18)
                local fireDelay = w.FireDelay or 0.18
                value2 = math.Clamp(affinity - (fd * (CurTime() - affTime) / fireDelay), 0, 2)
            end

            local velSens = w.VelocitySensitivity or 0
            local mobilityMod = (w.dt and w.dt.State == SWB_AIMING and (w.meMobilitySpreadMod or w.AimMobilitySpreadMod) or 1)
            w.CurCone = math.Clamp((w.BaseCone or 0) + value + ((vel / 10000) * velSens) * mobilityMod + value2, 0, 0.09 + (w.MaxSpreadInc or 0))
        end

        CalculateSpread()

        local cone = w.CurCone
        if not cone then return ang end

        math.randomseed(cmd:CommandNumber())
        local dir1 = Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0) * 25
        local dir2 = dir1
        if w.ClumpSpread and w.ClumpSpread > 0 then
            dir2 = dir1 + Angle(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)) * w.ClumpSpread
        end
        ang = ang - dir2
	elseif serj.cones[class] then
		local spread = serj.cones[class]
		local spreadVec = Vector(spread, spread, 0)
		local dir = jopa.PredictSpread(cmd, ang, spreadVec)
		local newangle = ang + dir:Angle()
		newangle:Normalize()
		return newangle
	end


	return ang
end

function serj.SilentAngles(cmd)
	if !serj.fa then serj.fa = cmd:GetViewAngles() end
	serj.fa = serj.fa + Angle(cmd:GetMouseY() * GetConVarNumber("m_yaw"), cmd:GetMouseX() * -GetConVarNumber("m_yaw"), 0)
	serj.fa.p = mClamp(serj.fa.p, -89, 89)
	serj.fa.y = mNormalizeAng(serj.fa.y)
end

function serj.Smoothing( ang )
	if ( serj.cfg.Vars["legit_smooth_amount"] == 0 ) then return ang end
	local speed = RealFrameTime() / ( serj.cfg.Vars["legit_smooth_amount"] / 10 )
	local angl = LerpAngle( speed, me:EyeAngles(), ang )
	return Angle( angl.p, angl.y, 0 )
end

function serj.GetClosestAimTarget()
    dists = {};
		
	for k,v in next, player.GetAll() do
        if(!serj.ValidateTarget(v)) then continue; end
        dists[#dists + 1] = { vm.Distance( em.GetPos(v), em.GetPos(me) ), v };
	end
		
	table.sort(dists, function(a, b)
		return(a[1] < b[1]);
	end);
		
	closest = dists[1] && dists[1][2] || nil;
    return closest
end

function serj.GetLowestHealth()
    dists = {};
		
    for k,v in next, player.GetAll() do
        if(!serj.ValidateTarget(v)) then continue; end
        dists[#dists + 1] = { em.Health(v), v };
    end
    
    table.sort(dists, function(a, b)
        return(a[1] < b[1]);
    end);
    
    closest = dists[1] && dists[1][2] || nil;

    return closest
end

serj.c_sv_noclipspeed = GetConVar("sv_noclipspeed")
serj.c_sv_specspeed = GetConVar("sv_specspeed")
function serj.pMovementFix(cmd, aWishDir)
    local factor = 1
    if me:GetObserverMode() == OBS_MODE_ROAMING then
        factor = serj.c_sv_specspeed:GetFloat()
    else
        factor = serj.c_sv_noclipspeed:GetFloat()
    end

    if cmd:KeyDown(IN_SPEED) then
        factor = factor * 0.5
    end

    local aRealDir = serj.fa
    aRealDir:Normalize()

    local vRealF = aRealDir:Forward()
    local vRealR = aRealDir:Right()
    vRealF.z = 0
    vRealR.z = 0

    vRealF:Normalize()
    vRealR:Normalize()

    aWishDir:Normalize()

    local vWishF = aWishDir:Forward()
    local vWishR = aWishDir:Right()
    vWishF.z = 0
    vWishR.z = 0

    vWishF:Normalize()
    vWishR:Normalize()

    local forwardmove = cmd:GetForwardMove() * factor
    local sidemove = cmd:GetSideMove() * factor
    local upmove = cmd:GetUpMove() * factor

    local vWishVel = vWishF * forwardmove + vWishR * sidemove
    vWishVel.z = vWishVel.z + upmove

    local a, b, c, d, e, f = vRealF.x, vRealR.x, vRealF.y, vRealR.y, vRealF.z, vRealR.z
    local u, v, w = vWishVel.x, vWishVel.y, vWishVel.z
    local flDivide = (b * c - a * d) * factor

    local x = -(d * u - b * v) / flDivide
    local y = (c * u - a * v) / flDivide
    local z = (a * (f * v - d * w) + b * (c * w - e * v) + u * (d * e - c * f)) / flDivide

    x = mClamp(x, -10000, 10000)
    y = mClamp(y, -10000, 10000)
    z = mClamp(z, -10000, 10000)

    cmd:SetForwardMove(x)
    cmd:SetSideMove(y)
    cmd:SetUpMove(z)
end

serj.bsendpacket = true
serj.switchside = true
serj.yawadd = 0
serj.fyawadd = 0

function serj.GetClosest()
	local ddists = {};
	
	local closest;
		
	for k,v in next, player.GetAll() do
	if(!serj.ValidateTarget(v)) then continue; end
		ddists[#ddists + 1] = { vm.Distance( em.GetPos(v), em.GetPos(me) ), v };
	end
		
	table.sort(ddists, function(a, b)
		return(a[1] < b[1]);
	end);
		
	closest = ddists[1] && ddists[1][2] || nil;
	
	if(!closest) then return serj.fa.y; end
	
	local pos = em.GetPos(closest);
	
	local pos = vm.Angle(pos - em.EyePos(me));
	
	return( pos.y );
end
serj.brawlstars_unizil = false
function serj.YawBase()
    if serj.cfg.Vars["yaw_base"] == 1 then
        yawbase = serj.fa.y
    elseif serj.cfg.Vars["yaw_base"] == 2 then 
        yawbase = 0
    elseif serj.cfg.Vars["yaw_base"] == 3 then 
        yawbase = serj.GetClosest()
	elseif serj.cfg.Vars["yaw_base"] == 4 then 
        yawbase = serj.GetClosest()
    end

	return yawbase
end
serj.landing = false
function serj.OnLand( ply, inWater, onFloater, speed )
    if !onFloater and !inWater then
        serj.landing = true
        timer.Simple(1,function() serj.landing = false end)
    end
end

serj.cadillac = false
function serj.GetAAPitch()

    if serj.bsendpacket then
        serj.cadillac = !serj.cadillac
	end

    if serj.cfg.Vars["pitch_zero_land"] and serj.landing then
        realPitch = 0
    elseif serj.cfg.Vars["pitch"] == 1 then
        realPitch = serj.fa.x
    elseif serj.cfg.Vars["pitch"] == 2 then
        realPitch = 0
    elseif serj.cfg.Vars["pitch"] == 3 then
        realPitch = 89
    elseif serj.cfg.Vars["pitch"] == 4 then
        realPitch = -89
    elseif serj.cfg.Vars["pitch"] == 5 then
        realPitch = -180
    elseif serj.cfg.Vars["pitch"] == 6 then
        realPitch = mrandom(-89,89)
	elseif serj.cfg.Vars["pitch"] == 7 then
        realPitch = mrandom(-360,360)
	elseif serj.cfg.Vars["pitch"] == 8 then
        realPitch = serj.cfg.Vars["c_pitch"]
    elseif serj.cfg.Vars["pitch"] == 9 then
		realPitch = serj.cadillac && 179.9 || 89
    elseif serj.cfg.Vars["pitch"] == 10 then
		realPitch = serj.cadillac && -89 || 89
    elseif serj.cfg.Vars["pitch"] == 11 then
		realPitch = serj.cadillac and -180 or 271
    elseif serj.cfg.Vars["pitch"] == 12 then
		realPitch = serj.bsendpacket && 45 || -45
    end

    return realPitch
end

local function WallDetect()
    local eye = me:GetShootPos()
    local head = me:GetBonePosition(me:LookupBone("ValveBiped.Bip01_Head1"))
    eye.z = head.z

    local lowestFraction = 1
    local lowestFractionAngle = nil
    for i=0, 360, 360 / 45 do
        local ang = Angle(0, i, 0)
        local trc = TraceLine({
            start = eye,
            endpos = eye + ang:Forward() * 24,
            mask = MASK_SHOT,
            collisiongroup = COLLISION_GROUP_DEBRIS,
        })

        if(trc.Fraction < lowestFraction) then
            lowestFraction = trc.Fraction
            lowestFractionAngle = ang.y
        end
    end

    return lowestFractionAngle
end

local function Freestanding()
    local eye = me:GetShootPos()
    local head = me:GetBonePosition(me:LookupBone("ValveBiped.Bip01_Head1"))
    eye.z = head.z



end

function serj.GetAAY()

    if serj.cfg.Vars["yaw_real"] == 1 then
        realYaw = serj.YawBase()
    elseif serj.cfg.Vars["yaw_real"] == 2 then
        realYaw = serj.YawBase() - 180
    elseif serj.cfg.Vars["yaw_real"] == 3 then
        realYaw = serj.YawBase() + 89
    elseif serj.cfg.Vars["yaw_real"] == 4 then
        realYaw = serj.YawBase() - 89
    elseif serj.cfg.Vars["yaw_real"] == 5 then 
        realYaw = serj.YawBase() - mNormalizeAng(CurTime() * (serj.cfg.Vars["antiaim_spinspeed"]*10))
    elseif serj.cfg.Vars["yaw_real"] == 6 then
        realYaw = serj.YawBase() + mNormalizeAng(CurTime() * (serj.cfg.Vars["antiaim_spinspeed"]*10))
    elseif serj.cfg.Vars["yaw_real"] == 7 then
        srealYaw = serj.YawBase() - mrandom(-serj.cfg.Vars["antiaim_jitterrange"],serj.cfg.Vars["antiaim_jitterrange"])
    elseif serj.cfg.Vars["yaw_real"] == 8 then
        realYaw = serj.YawBase() - 180 - mrandom(-serj.cfg.Vars["antiaim_jitterrange"],serj.cfg.Vars["antiaim_jitterrange"])
    elseif serj.cfg.Vars["yaw_real"] == 9 then
		realYaw = serj.YawBase() + serj.cfg.Vars["c_ryaw"]
    elseif serj.cfg.Vars["yaw_real"] == 10 then
		realYaw = serj.YawBase() + mNormalizeAng(CurTime() * 35) + mrandom(-25,25) + 45
    elseif serj.cfg.Vars["yaw_real"] == 11 then
		realYaw = serj.YawBase() - 15 - (me:GetVelocity():Length2D() / 15)
    elseif serj.cfg.Vars["yaw_real"] == 12 then -- Sideways
        realYaw = serj.YawBase() + (serj.activebinds["yaw_invert"] and -90 or 90)
    elseif serj.cfg.Vars["yaw_real"] == 13 then -- Half Sideways
        realYaw = serj.YawBase() + (serj.activebinds["yaw_invert"] and -45 or 45)
    end

    if serj.cfg.Vars["edge_enable"] and WallDetect() != nil and serj.cfg.Vars["edge_side"] == 1 then
        realYaw = WallDetect()  
    elseif serj.cfg.Vars["aa_autodir"] and Freestanding() != nil then
        realYaw = Freestanding()  
    end

    return realYaw
end
serj.vFakeAngles = Angle(0,0,0)
serj.vRealAngles = Angle(0,0,0)
serj.FakeLagAngles = Angle(0,0,0)
function serj.GetFAAY()
    if serj.brawlstars_unizil then
        fakeYaw = serj.YawBase() - mNormalizeAng(CurTime() * 450)
    elseif serj.cfg.Vars["yaw_fake"] == 1 then
        fakeYaw = serj.YawBase()
    elseif serj.cfg.Vars["yaw_fake"] == 2 then
        fakeYaw = serj.YawBase() - 180
    elseif serj.cfg.Vars["yaw_fake"] == 3 then
        fakeYaw = serj.YawBase() + 89
    elseif serj.cfg.Vars["yaw_fake"] == 4 then
        fakeYaw = serj.YawBase() - 89
    elseif serj.cfg.Vars["yaw_fake"] == 5 then
        fakeYaw = serj.YawBase() - mNormalizeAng(CurTime() * (serj.cfg.Vars["antiaim_spinspeed"]*10))
    elseif serj.cfg.Vars["yaw_fake"] == 6 then
        fakeYaw = serj.YawBase() + mNormalizeAng(CurTime() * (serj.cfg.Vars["antiaim_spinspeed"]*10))
    elseif serj.cfg.Vars["yaw_fake"] == 7 then
        fakeYaw = serj.YawBase() - mrandom(-serj.cfg.Vars["antiaim_jitterrange"],serj.cfg.Vars["antiaim_jitterrange"])
    elseif serj.cfg.Vars["yaw_fake"] == 8 then
        fakeYaw = serj.YawBase() - 180 - mrandom(-serj.cfg.Vars["antiaim_jitterrange"],serj.cfg.Vars["antiaim_jitterrange"])
    elseif serj.cfg.Vars["yaw_fake"] == 9 then
		fakeYaw = serj.YawBase() + serj.cfg.Vars["c_fyaw"]
    elseif serj.cfg.Vars["yaw_fake"] == 10 then
		fakeYaw = serj.YawBase() + mNormalizeAng(CurTime() * 35)
    elseif serj.cfg.Vars["yaw_fake"] == 11 then
		fakeYaw = serj.YawBase() + 15 + (me:GetVelocity():Length2D() / 15)
    elseif serj.cfg.Vars["yaw_fake"] == 12 then -- Sideways
        fakeYaw = serj.YawBase() + (serj.activebinds["yaw_invert"] and 90 or -90)
    elseif serj.cfg.Vars["yaw_fake"] == 13 then -- Half Sideways
        fakeYaw = serj.YawBase() + (serj.activebinds["yaw_invert"] and 45 or -45)
    end

    if serj.cfg.Vars["edge_enable"] and WallDetect() != nil and serj.cfg.Vars["edge_side"] == 2 then
        fakeYaw = WallDetect()  
    end

    return fakeYaw
end

function serj.Antihit(cmd)
    local angDiff = mabs(math.Round(math.AngleDifference(serj.vFakeAngles.y,serj.vRealAngles.y)))
    local angAdd = serj.cfg.Vars["avoid_overlap_add"] + 25

    if !serj.cfg.Vars["avoid_overlap"] or angDiff > 30 then
        angAdd = 0
    end

	if serj.cfg.Vars["aa_enable"] and ( !cmd:KeyDown(IN_ATTACK) and !cmd:KeyDown(IN_USE)  ) and me:GetMoveType() != MOVETYPE_NOCLIP and me:GetMoveType() != MOVETYPE_LADDER and me:Alive() then
        if serj.bsendpacket then
            cmd:SetViewAngles(Angle(serj.GetAAPitch(),serj.GetFAAY()-angAdd,0))
            serj.vFakeAngles = cmd:GetViewAngles()
            serj.FakeLagAngles = cmd:GetViewAngles()
        else
            cmd:SetViewAngles(Angle(serj.GetAAPitch(),serj.GetAAY()+(serj.headrot*30),0))
            serj.vRealAngles = cmd:GetViewAngles()
        end
    else
        if IsValid(me) and me:Alive() and IsValid(me:GetActiveWeapon()) then
            local faa = serj.cfg.Vars["sa_enable"] and serj.fa or cmd:GetViewAngles()

            if serj.cfg.Vars["aim_norecoil"] and serj.cfg.Vars["aim_norecoil_alw"] then
                faa = serj.NoRecoil(faa)
            end

            if serj.cfg.Vars["aim_nospread"] and serj.cfg.Vars["aim_nospread_alw"] then
                faa = serj.NoSpread(cmd,faa)
            end

            cmd:SetViewAngles(faa)
        else
            if serj.cfg.Vars["sa_enable"] then
                cmd:SetViewAngles(serj.fa)
            end
        end

        serj.vFakeAngles = cmd:GetViewAngles()
        serj.vRealAngles = cmd:GetViewAngles()
        serj.FakeLagAngles = cmd:GetViewAngles()
    end

    --print(angDiff)
    --print(angAdd)
    if serj.cfg.Vars["sa_enable"] or serj.cfg.Vars["aa_enable"] then
	    serj.MovementFix(cmd)
    end
end

function serj.predictPos(pos)
    pos = pos - (me:GetVelocity() * TICK_INTERVAL)
    return(pos)
end

function serj.isPeeking()
    if !serj.target then return end

    local mypos = serj.predictPos(me:GetPos())

    local tr = TraceLine({
        mask = MASK_SHOT,
        ignoreworld = false,
        filter = me,
        start = me:EyePos(),
        endpos = serj.targetVector
    })
    
    return tr.Entity == serj.target or tr.Fraction == 1
end

serj.fakeLagTicks = 0
serj.fakeLagfactor = 0
function serj.FakeLag(cmd)
    local peeked = false
    local curvel = me:GetVelocity():Length2D()
    local dst_per_tick = curvel * TICK_INTERVAL
    local chokes = mceil(64 / dst_per_tick)
	chokes = mClamp(chokes, 1, 14)

    if serj.cfg.Vars["fl_mode"] == 1 then
        serj.fakeLagfactor = math.Round(serj.cfg.Vars["fl_maxchoke"])
    elseif serj.cfg.Vars["fl_mode"] == 2 then
        serj.fakeLagfactor = chokes
    end

    if serj.cfg.Vars["move_fd"] and serj.activebinds["key_fd"] then 
        serj.fakeLagfactor = 14 
    end

    if serj.cfg.Vars["fl_peek"] then
        if serj.isPeeking() and !peeked then
            peeked = true
            serj.bsendpacket = false
            peeked = false
        else
            serj.bsendpacket = true
        end
    end
     
    if !serj.cfg.Vars["fl_enable"] or (serj.cfg.Vars["fl_ladder"] and me:GetMoveType() == MOVETYPE_LADDER) or (serj.cfg.Vars["fl_use"] and cmd:KeyDown(IN_USE)) then
        serj.bsendpacket = true
    else
        serj.bsendpacket = false
        if serj.fakeLagTicks <= 0 then
            serj.fakeLagTicks = serj.fakeLagfactor
            serj.bsendpacket = true
        else
            serj.fakeLagTicks = serj.fakeLagTicks - 1
        end
    end
end

serj.predictedWeapons = {["weapon_crossbow"] = 3110}
function serj.Prediction(target,pos)
    local lpos = me:GetPos()
    local v0 = 3500
    if target:IsValid() then
        local G = GetConVar("sv_gravity"):GetFloat()
        local lerp = GetConVar("cl_interp"):GetFloat()
        local tvel = target:GetAbsVelocity()
        local onGround = target:IsOnGround()
        local gravperTick = G * engine.TickInterval()
        tvel.z = not onGround and tvel.z - (gravperTick) or tvel.z
        local dist = pos:Distance( lpos )
        local comptime = (dist/v0) + lerp
        local final = pos + (tvel * comptime)
        return final
    end
    return pos
end

function serj.AimTarget(cmd)
	local newTarget = nil
	local newTargetPos = Vector(0, 0, 0)
	local newTargetAng = Angle(0, 0, 0)
	local newTargetFov = 360

	for k, v in pairs(player.GetAll()) do
		if serj.ValidateTarget(v) then
            local pos = serj.getAimHitbox(v)          
            
            if serj.cfg.Vars["predict"] then
                local weapon = me:GetActiveWeapon()
                local bulletSpeed = GetBulletSpeed(weapon)
                local dropScale = GetDropScale(weapon)
                local velocity = v:GetVelocity()
                local mult = serj.cfg.Vars["predict_amount"] / 100
                local startPos = me:GetShootPos()
                local distance = startPos:Distance(pos)
                local travelTime = distance / bulletSpeed

                if serj.cfg.Vars["predict_ping"] then
                    travelTime = travelTime + (v:Ping() / 1000)
                end
                travelTime = travelTime + engine.TickInterval() * 2

                local iters = math.Round(serj.cfg.Vars["predict_iters"])
                local predictedPos = pos + velocity * travelTime * mult
                for i = 1, iters do
                    distance = startPos:Distance(predictedPos)
                    travelTime = distance / bulletSpeed
                    if serj.cfg.Vars["predict_ping"] then
                        travelTime = travelTime + (v:Ping() / 1000)
                    end
                    travelTime = travelTime + engine.TickInterval() * 2
                    predictedPos = pos + velocity * travelTime * mult

                    if serj.cfg.Vars["predict_gravity"] and not v:IsOnGround() then
                        local grav = GetConVar("sv_gravity") and GetConVar("sv_gravity"):GetFloat() or 600
                        predictedPos.z = predictedPos.z - 0.5 * grav * travelTime * travelTime * dropScale * mult
                    end
                end

                local sid = v:SteamID64() or ""
                if not predict_cache[sid] then predict_cache[sid] = predictedPos end
                local smooth = serj.cfg.Vars["predict_smooth_val"] / 100
                predictedPos = predict_cache[sid] * smooth + predictedPos * (1 - smooth)
                predict_cache[sid] = predictedPos

                pos = predictedPos
            end

            local aimAngle = (pos - me:EyePos()):Angle()
            aimAngle:Normalize()         
			
            if serj.cfg.Vars["target_selection"] == 1 then
                local aimFov = mabs(mNormalizeAng(serj.fa.y - aimAngle.y)) + mabs(mNormalizeAng(serj.fa.p - aimAngle.p))

                if aimFov < newTargetFov then
                    newTarget = v
                    newTargetPos = pos
                    newTargetAng = aimAngle
                    newTargetFov = aimFov
                end
            elseif serj.cfg.Vars["target_selection"] == 2 then
                -- logic remains the same but uses pos
                newTarget = serj.GetClosestAimTarget()
                newTargetPos = pos -- simplified, original logic was slightly different but this integrates predict
                newTargetAng = aimAngle
            elseif serj.cfg.Vars["target_selection"] == 3 then
                newTarget = serj.GetLowestHealth()
                newTargetPos = pos -- simplified
                newTargetAng = aimAngle
            end       

		end
	end

	serj.target = newTarget
	serj.targetVector = newTargetPos
	serj.targetAngle = newTargetAng
	serj.targetFov = newTargetFov

	local aimEnabled = false
    if serj.cfg.Keybinds["aim_enable"] != 0 then
        aimEnabled = serj.activebinds["aim_enable"]
    else
        aimEnabled = serj.cfg.Vars["aim_enable"]
    end
	
    if IsValid(me:GetActiveWeapon()) && me:GetActiveWeapon():GetClass() == "weapon_crossbow" and aimEnabled and serj.CanShoot() and serj.ValidateTarget(serj.target) and serj.VisibleCheck(serj.target,serj.targetVector) then
        serj.targetVector = serj.Prediction(serj.target, serj.targetVector)
    end 
end


function serj.Aim(cmd)
	if cmd:CommandNumber() == 0 then return end

	local aimEnabled = false
    if serj.cfg.Keybinds["aim_enable"] != 0 then
        aimEnabled = serj.activebinds["aim_enable"]
    else
        aimEnabled = serj.cfg.Vars["aim_enable"]
    end
	
	if aimEnabled and serj.CanShoot() and serj.ValidateTarget(serj.target) and serj.VisibleCheck(serj.target,serj.targetVector) then 
        local finalAngle = serj.targetAngle

        if serj.cfg.Vars["aim_norecoil"] then
            finalAngle = serj.NoRecoil(finalAngle)
        end

        if serj.cfg.Vars["aim_nospread"] then
            finalAngle = serj.NoSpread(cmd,finalAngle)
        end

        if serj.cfg.Vars["legit_smooth"] then
            finalAngle = serj.Smoothing(finalAngle)
        end
        //serj.guiCheckBox("FOV  limit","legit_fov",legpan)
        //serj.CreateSlider("Max FOV", "°", "legit_fov_val", 1, 180, 0, legpan)


        if serj.cfg.Vars["legit_fov"] then
            local fov = serj.cfg.Vars["legit_fov_val"]
            
            local view = serj.cfg.Vars["sa_enable"] and serj.fa or cmd:GetViewAngles()
            local ang = serj.targetAngle - view
            
            ang:Normalize()
            
            ang = msqrt(ang.x * ang.x + ang.y * ang.y)
            
            if ang > fov then
                return
            end
        end


        cmd:SetViewAngles(finalAngle)

        if serj.cfg.Vars["af_enable"] then
            serj.bsendpacket = true
            cmd:AddKey(IN_ATTACK)
        end
        if serj.cfg.Vars["sa_enable"] or serj.cfg.Vars["aa_enable"] then
    	    serj.MovementFix(cmd)
        end
	else
        serj.Antihit(cmd)
    end
end
serj.tperson = false
serj.tperson_cd = false 
serj.tp_smooth = 0
serj.tpsmooth = 0

serj.vieworigin = me:GetShootPos()

function serj.SilentViewAngles(ply, originn, angles, fov, znear, zfar, pos)
	local view = {}

    if serj.cfg.Vars["move_fd"] and serj.activebinds["key_fd"] then 
        originn.z = me:GetPos().z + 64 
    end


    serj.tpsmooth = serj.tpsmooth or 0

    if serj.cfg.Vars["misc_3rdp"] and serj.tperson then
        serj.tpsmooth = math.Approach(serj.tpsmooth,serj.cfg.Vars["misc_3rdp_d"]* 10,FrameTime()*math.Round(serj.cfg.Vars["misc_3rdp_s"]*10))
    else
        serj.tpsmooth = math.Approach(serj.tpsmooth,0,FrameTime()*math.Round(serj.cfg.Vars["misc_3rdp_s"]*10))
    end 

    if serj.tpsmooth != 0 then
        if serj.cfg.Vars["misc_3rdp_coll"] then
	        view.origin = TraceLine({
                start = originn,
                endpos = originn - ( serj.fa:Forward() * serj.tpsmooth ),
                filter = me,
                    
            }).HitPos
        else
            view.origin = originn - ( serj.fa:Forward() * serj.tpsmooth ) 
        end
        

        if ( serj.cfg.Vars["antiaim_enable"] and (serj.cfg.Vars["real_chams"] or serj.cfg.Vars["fake_chams"]) )  then
            view.drawviewer = false
        else
            view.drawviewer = true
        end
    else  
        view.origin = originn
    end

	view.angles = ( serj.cfg.Vars["sa_enable"] or serj.cfg.Vars["aa_enable"] ) and serj.fa or view.angles

    if serj.cfg.Vars["misc_ofov"] then
	    view.fov = serj.cfg.Vars["misc_ofov_v"]
    end

    serj.vieworigin = view.origin
	return view
end

function serj.CalcViewModelView(wep, vm, oldPos, oldAng, pos, ang)

    pos = serj.vieworigin 
	ang = ( serj.cfg.Vars["sa_enable"] or serj.cfg.Vars["aa_enable"] ) and serj.fa or ang

	if serj.cfg.Vars["misc_viewmodel"] then
		local OverridePos = Vector(serj.cfg.Vars["misc_vm_x"], serj.cfg.Vars["misc_vm_y"], serj.cfg.Vars["misc_vm_z"])
		local OverrideAngle = Angle(serj.cfg.Vars["misc_vm_p"], serj.cfg.Vars["misc_vm_ya"], serj.cfg.Vars["misc_vm_r"])

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



function serj.AutoReload(cmd)
	if !serj.cfg.Vars["ar_enable"] then return end

	local wep = me:GetActiveWeapon()

	if IsValid(wep) then
		if wep.Primary then
			if wep:Clip1() == 0 and wep:GetMaxClip1() > 0 and me:GetAmmoCount(wep:GetPrimaryAmmoType()) > 0 then
				cmd:AddKey(IN_RELOAD)
			end
		end
	end
end

serj.hl2guns = {
    ["weapon_357"] = true,
    ["weapon_pistol"] = true,
    ["weapon_bugbait"] = true,
    ["weapon_crossbow"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_frag"] = true,
    ["weapon_physcannon"] = true,
    ["weapon_ar2"] = true,
    ["weapon_rpg"] = true,
    ["weapon_slam"] = true,
    ["weapon_shotgun"] = true,
    ["weapon_smg1"] = true,
    ["weapon_stunstick"] = true,
    ["weapon_fists"] = true,
    ["gmod_camera"] = true,
    ["manhack_welder"] = true,
    ["weapon_medkit"] = true,
    ["gmod_tool"] = true,
    ["weapon_physgun"] = true,
}
serj.side = false
serj.GLPTEST = false
serj.MOVEING = false
serj.lastpos = me:GetPos()
serj.ap_alpha = 0
serj.GLP = me:GetPos()

function serj.moveToPos(cmd, pos)
    local world_forward = (pos - me:GetPos())
    local ang_LocalPlayer = serj.fa.y
    local govno = (pos - me:GetPos()):Angle()
    govno.r = 0

    cmd:SetForwardMove(10000)
    cmd:SetSideMove(0)
    if serj.cfg.Vars["move_ap_sp"] then
        cmd:AddKey(IN_SPEED)
    end

    serj.pMovementFix(cmd,Angle(0, govno.y, 0))
end

function serj.fart(cmd)
    if serj.GLPTEST and cmd:KeyDown(IN_ATTACK) then 
        serj.MOVEING = true
    elseif !serj.GLPTEST and !cmd:KeyDown(IN_ATTACK) then
        serj.MOVEING = false
    end  
end

function serj.ass(ent)
    local col = string.ToColor(serj.cfg.Colors["move_ap"])
    local pos = serj.GLP
    local offset = Vector(pos)

    cam.Start3D2D(pos, Angle(0,0,0), 0.5 )
        cam.IgnoreZ(true)
        if serj.cfg.Vars["move_ap_s"] == 1 then
            surfaceDrawCircle(0,0,serj.ap_alpha/5-5,col.r,col.g,col.b,col.a)
        elseif serj.cfg.Vars["move_ap_s"] == 2 then
            surfaceSetDrawColor( col.r,col.g,col.b,serj.ap_alpha ) 
	        surface.SetMaterial( Material("gui/npc.png") )
	        surface.DrawTexturedRect( -serj.ap_alpha/4, -serj.ap_alpha/4, serj.ap_alpha/2, serj.ap_alpha/2 )
        end
        cam.IgnoreZ(false)
    cam.End3D2D()
end

hook.Add("Think", "serj.AutopeakThink", function()
    if !serj.cfg.Vars["move_ap"] then return end
    if serj.activebinds["key_ap"] then
        if not serj.GLPTEST then
            serj.GLP = me:GetPos()
            serj.lastpos = me:GetPos()         
        end
        serj.GLPTEST = true
    else
        serj.GLPTEST = false
    end
    if serj.cfg.Vars["move_ap_anim"] then
        if serj.GLPTEST then
            serj.ap_alpha = math.Approach(serj.ap_alpha,255,FrameTime()*750)
        else
            serj.ap_alpha = math.Approach(serj.ap_alpha,0,FrameTime()*750)
        end
    else
        if serj.GLPTEST then
            serj.ap_alpha = 255
        else
            serj.ap_alpha = 0
        end
    end
end)

serj.move_right = 0
serj.move_left = 0
serj.move_backwards = 0
serj.move_forward = 0
tx,tx2,ty,ty2 = Color(255,0,0), Color(235,219,0),Color(100,250,0),Color(50,25,250)
function serj.Postdraweffects()

    local ent = me
	
	local mins = Vector(-2, -5, -2)
	local maxs = Vector(10, 6, 10)
	local startpos = ent:GetPos() + Vector(0,0,35)

    local yaw = serj.fa.y

	local dir_left = Angle(0,yaw+90,0):Forward()
    local dir_right = Angle(0,yaw-90,0):Forward()
    local dir_forward = Angle(0,yaw,0):Forward()
    local dir_back = Angle(0,yaw-180,0):Forward()

	local tr_l = TraceHull( {
		start = startpos,
		endpos = startpos + dir_left * serj.cfg.Vars["move_aw_len"] ,
		maxs = maxs,
		mins = mins,
		filter = ent
	} )
    local tr_r = TraceHull( {
		start = startpos,
		endpos = startpos + dir_right * serj.cfg.Vars["move_aw_len"] ,
		maxs = maxs,
		mins = mins,
		filter = ent
	} )
    local tr_f = TraceHull( {
		start = startpos,
		endpos = startpos + dir_forward * serj.cfg.Vars["move_aw_len"] ,
		maxs = maxs,
		mins = mins,
		filter = ent
	} )
    local tr_b = TraceHull( {
		start = startpos,
		endpos = startpos + dir_back * serj.cfg.Vars["move_aw_len"] ,
		maxs = maxs,
		mins = mins,
		filter = ent
	} )
	
    local clr = color_white
    if ( tr_l.Hit ) then
        clr = Color( 255, 0, 0 )
        serj.move_left = startpos:Distance(tr_l.HitPos)
    else
        serj.move_left = 0
    end
    local clr2 = color_white
    if ( tr_r.Hit ) then
        clr2 = Color( 255, 0, 0 )
        serj.move_right = startpos:Distance(tr_r.HitPos)
    else
        serj.move_right = 0
    end
    local clr3 = color_white
    if ( tr_f.Hit ) then
        clr3 = Color( 255, 0, 0 )
        serj.move_forward = startpos:Distance(tr_f.HitPos)
    else
        serj.move_forward = 0
    end
    local clr4 = color_white
    if ( tr_b.Hit ) then
        clr4 = Color( 255, 0, 0 )
        serj.move_backwards = startpos:Distance(tr_b.HitPos)
    else
        serj.move_backwards = 0
    end

    if serj.cfg.Vars["move_aw_d"] then
        render.DrawLine( tr_l.HitPos, startpos + dir_left * serj.cfg.Vars["move_aw_len"] , color_white, true )
        render.DrawLine( startpos, tr_l.HitPos, Color( 106, 255, 113), true )

        render.DrawLine( tr_r.HitPos, startpos + dir_right * serj.cfg.Vars["move_aw_len"] , color_white, true )
        render.DrawLine( startpos, tr_r.HitPos, Color( 106, 255, 113 ), true )

        render.DrawLine( tr_f.HitPos, startpos + dir_forward * serj.cfg.Vars["move_aw_len"] , color_white, true )
        render.DrawLine( startpos, tr_f.HitPos, Color( 106, 255, 113 ), true )

        render.DrawLine( tr_b.HitPos, startpos + dir_back * serj.cfg.Vars["move_aw_len"] , color_white, true )
        render.DrawLine( startpos, tr_b.HitPos, Color( 106, 255, 113 ), true )
        
    

        render.DrawWireframeBox( startpos, Angle( 0, 0, 0 ), mins, maxs, Color( 255, 255, 255 ), true )
        render.DrawWireframeBox( tr_l.HitPos, Angle( 0, 0, 0 ), mins, maxs, clr, true )

        render.DrawWireframeBox( startpos, Angle( 0, 0, 0 ), mins, maxs, Color( 255, 255, 255 ), true )
        render.DrawWireframeBox( tr_r.HitPos, Angle( 0, 0, 0 ), mins, maxs, clr2, true )
        
        render.DrawWireframeBox( startpos, Angle( 0, 0, 0 ), mins, maxs, Color( 255, 255, 255 ), true )
        render.DrawWireframeBox( tr_f.HitPos, Angle( 0, 0, 0 ), mins, maxs, clr3, true )

        render.DrawWireframeBox( startpos, Angle( 0, 0, 0 ), mins, maxs, Color( 255, 255, 255 ), true )
        render.DrawWireframeBox( tr_b.HitPos, Angle( 0, 0, 0 ), mins, maxs, clr4, true )
    end
end

hook.Add( "RenderScreenspaceEffects", "RenderSE", function()
    if serj.cfg.Vars["color_modify"] then 
        local rse = {
            [ "$pp_colour_addr" ] = serj.cfg.Vars["pp_colour_addr"],
            [ "$pp_colour_addg" ] = serj.cfg.Vars["pp_colour_addg"],
            [ "$pp_colour_addb" ] = serj.cfg.Vars["pp_colour_addb"],
            [ "$pp_colour_brightness" ] = serj.cfg.Vars["pp_colour_brightness"],
            [ "$pp_colour_contrast" ] = serj.cfg.Vars["pp_colour_contrast"],
            [ "$pp_colour_colour" ] = serj.cfg.Vars["pp_colour_colour"],
            [ "$pp_colour_mulr" ] = serj.cfg.Vars["pp_colour_mulr"],
            [ "$pp_colour_mulg" ] = serj.cfg.Vars["pp_colour_mulg"],
            [ "$pp_colour_mulb" ] = serj.cfg.Vars["pp_colour_mulb"]
        }
        DrawColorModify( rse )
    end

    if serj.cfg.Vars["motion_blur"] then
        DrawMotionBlur( serj.cfg.Vars[ "mb_aa" ], serj.cfg.Vars[ "mb_da" ],  serj.cfg.Vars[ "mb_d" ])
    end
end )

hook.Add( "GetMotionBlurValues", "NewMoBlur", function( horizontal, vertical, forward, rotational )
    if !serj.cfg.Vars["motion_blur_e"] then return end
    horizontal = serj.cfg.Vars["emb_h"]
    vertical = serj.cfg.Vars["emb_v"]
    forward = serj.cfg.Vars["emb_f"]
    rotational = serj.cfg.Vars["emb_r"]

    return horizontal, vertical, forward, rotational
end )

function serj.Movement(cmd)
	if !me:Alive() then return end
    local pos = me:GetPos()

	if serj.cfg.Vars["move_ds"] then
		if me:KeyDown(IN_DUCK) then
            cmd:RemoveKey(IN_DUCK)
        end
    end

    
    if serj.cfg.Vars["move_ad"] then
        local trace = TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 1337),
            mask = MASK_SOLID
        })
        local len = (pos - trace.HitPos).z
        if len > 25 and 50 > len then
            cmd:SetButtons(cmd:GetButtons() + IN_DUCK)
        end
    end

    -- Bunny hop
    if serj.cfg.Vars["move_bhop"] then
        if cmd:KeyDown(IN_JUMP) then
            if !me:OnGround() then
                cmd:RemoveKey(IN_JUMP)
            else
                cmd:AddKey(IN_JUMP)
            end
        end
    end

local directionalMove = { IN_BACK, IN_MOVERIGHT, IN_MOVELEFT }
 
local function FixMovement( cmd )
    if not serj.cfg.Vars["move_fixmovement"] then return end
    for i = 1, #directionalMove do
        cmd:RemoveKey( directionalMove[ i ] )
    end
end
 
hook.Add( "CreateMove", "MovementFix", FixMovement )

    if serj.cfg.Vars["move_keepsprint"] then 
        cmd:AddKey(IN_SPEED) 
    end


    -- slowwalk
    if serj.cfg.Vars["move_sw"] then 
        if serj.activebinds["key_sw"] then
            if(input.IsKeyDown(KEY_A)) then
                cmd:SetSideMove(-serj.cfg.Vars["move_sws"]) 
            end
            if(input.IsKeyDown(KEY_D)) then
                cmd:SetSideMove(serj.cfg.Vars["move_sws"])
            end
            if(input.IsKeyDown(KEY_W)) then
                cmd:SetForwardMove(serj.cfg.Vars["move_sws"])
            end
            if(input.IsKeyDown(KEY_S)) then
                cmd:SetForwardMove(-serj.cfg.Vars["move_sws"])
            end
        end
    end 


    -- Air strafe
    local forawrd = serj.fa:Forward()

    if !serj.cfg.Vars["move_strafe_backward"] then
        speedAddition = 1
    else
        if(input.IsKeyDown(KEY_S)) then
			speedAddition = -1
		elseif(input.IsKeyDown(KEY_W)) then
            speedAddition = 1
        end
    end

    if serj.cfg.Vars["move_strafe"] then
        if me:GetMoveType() == MOVETYPE_NOCLIP or me:GetMoveType() == MOVETYPE_LADDER then return end
        if cmd:KeyDown( IN_JUMP ) and !me:IsOnGround() then
            if(cmd:GetMouseX() > 1 || cmd:GetMouseX() < - 1) then
                cmd:SetSideMove(cmd:GetMouseX() > 1 && 10000 || - 10000)
            else
                cmd:SetForwardMove((5850 / me:GetVelocity():Length2D())*speedAddition)

                cmd:SetSideMove((cmd:CommandNumber() % 2 == 0) && -10000 || 10000)
            end
        elseif cmd:KeyDown( IN_JUMP ) then

			if IsValid(me:GetActiveWeapon()) and serj.hl2guns[me:GetActiveWeapon():GetClass()] then
				cmd:AddKey(IN_SPEED)
			end
            cmd:SetForwardMove(10000*speedAddition)  
        end
    end

          

    -- fake duck
    if serj.cfg.Vars["move_fd"] and serj.activebinds["key_fd"] then
        if(serj.cfg.Vars["move_fd_m"] == 1) then
            if(serj.fakeLagTicks >= 7) then
                cmd:SetButtons(bor(cmd:GetButtons(), IN_DUCK))
            else
                cmd:RemoveKey(IN_DUCK)
            end
        elseif(serj.cfg.Vars["move_fd_m"] == 2) then
            if(serj.bsendpacket) then
                cmd:RemoveKey(IN_DUCK)
            else
                cmd:SetButtons(bor(cmd:GetButtons(), IN_DUCK))
            end
        end
    end

    -- Avoid walls
    if serj.cfg.Vars["move_aw"] then
        if serj.activebinds["key_aw"] then
            if serj.move_left != 0 then
                cmd:SetSideMove(serj.cfg.Vars["move_aw_speed"])
            end
            if serj.move_right != 0 then
                cmd:SetSideMove(-serj.cfg.Vars["move_aw_speed"])
            end
            if serj.move_forward != 0 then
                cmd:SetForwardMove(-serj.cfg.Vars["move_aw_speed"])
            end
            if serj.move_backwards != 0 then
                cmd:SetForwardMove(serj.cfg.Vars["move_aw_speed"])
            end
        end
    end

    --Extended dy$ync
    if serj.cfg.Vars["extend_desync"] then 
        --cmd:SetSideMove(cmd:TickCount() % 2 == 0 and -1.1 or 1.1)
        --print(cmd:TickCount() % 2 == 0 and -1.1 or 1.1)

        if !cmd:KeyDown(IN_BACK) and !cmd:KeyDown(IN_FORWARD) and !cmd:KeyDown(IN_MOVELEFT) and !cmd:KeyDown(IN_MOVERIGHT) then
            cmd:SetSideMove(serj.side and -15.0 or 15.0)
            serj.side = !serj.side
        end

    end
end

function serj.CircleMove(cmd, rotation)
	local rot_cos = mcos(rotation)
	local rot_sin = msin(rotation)
	local cur_forwardmove = cmd:GetForwardMove()
	local cur_sidemove = cmd:GetSideMove()
	cmd:SetForwardMove(((rot_cos * cur_forwardmove) - (rot_sin * cur_sidemove)))
	cmd:SetSideMove(((rot_sin * cur_forwardmove) + (rot_cos * cur_sidemove)))
end

serj.CircleStrafeVal = 0
serj.CircleStrafeSpeed = 3
function serj.CircleStrafe(cmd) 
    if !IsValid(me) or !me:Alive() or !IsValid(me:GetActiveWeapon()) then return end
	if serj.cfg.Vars["move_circle_strafe"] then
        if serj.activebinds["key_cstrafe"] then
            if serj.hl2guns[me:GetActiveWeapon():GetClass()] then
                cmd:AddKey(IN_SPEED)
            elseif serj.cfg.Vars["move_add_speed"] and target == nil then
                cmd:AddKey(IN_SPEED)
            end

            serj.CircleStrafeVal = serj.CircleStrafeVal + serj.CircleStrafeSpeed
            if ((serj.CircleStrafeVal > 0) and ((serj.CircleStrafeVal / serj.CircleStrafeSpeed) > 361)) then
                serj.CircleStrafeVal = 0
            end
            cmd:SetSideMove(10000)
            serj.CircleMove(cmd, mrad((serj.CircleStrafeVal - TICK_INTERVAL)))
            return false
        else
            serj.CircleStrafeVal = 0
        end
        return true
    end
end

hook.Add("PostDrawOpaqueRenderables", "serj.PosDrawAP", function()
    if LocalPlayer() and serj.ap_alpha > 0 then
        serj.ass(v)
    end
end)

serj.garbage = 0

serj.hochuDrochit = 0
function serj.RukaLico(cmd) 
    if !serj.cfg.Vars["cpp_ruka"] then return end
    local mode = serj.cfg.Vars["cpp_ruka_prikol"]
    local budemDrochit = false

    if mode == 3 then  
        serj.hochuDrochit = (serj.hochuDrochit + 1)%32
    elseif mode == 4 then  
        serj.hochuDrochit = (serj.hochuDrochit + 1)%12
    end

    if mode == 1 then
        budemDrochit = true
    elseif mode == 2 then
        budemDrochit = false
    elseif mode == 3 then  
        if serj.hochuDrochit > 16 then
            budemDrochit = true
        end
    elseif mode == 4 then
        if serj.hochuDrochit > 6 then
            budemDrochit = true
        end
    elseif mode == 5 then
        if serj.bsendpacket then
            budemDrochit = true
        end
    end

    jopa.DrochitPravayaRuka(cmd,budemDrochit)
end

serj.bstime = 0
function serj.Backstab(cmd)
    --[[]
    local ent = me:GetEyeTrace().Entity
    local pos = me:GetEyeTrace().HitPos
    local wep = me:GetActiveWeapon()
    local class = me:GetActiveWeapon():GetClass()

    if serj.bstime < CurTime() and IsValid(wep) and IsValid(ent) and pos:Distance(me:GetPos()) < 65 and ent:IsPlayer() and class:find("csgo") then
        cmd:SetViewAngles(cmd:GetViewAngles() + Angle(45, 90 , 0))
        cmd:AddKey(IN_ATTACK2)
        serj.bstime = CurTime() + 0.12
    end
    ]]


    --[[]
        --RMB
        local ent = LocalPlayer():GetEyeTrace().Entity
        local wep = LocalPlayer():GetActiveWeapon()
        target = ent
        local pose = LocalPlayer():GetEyeTrace().HitPos
        plyangle = cmd:GetViewAngles()
            if target:IsPlayer() and pose:Distance(LocalPlayer():GetPos()) < 65 then
                bd = true
            end
        if(bd == true) then
            if wep:IsValid() and string.find(wep:GetClass(),"csgo") and ent:IsPlayer() then		    
                target = ent
                cmd:SetViewAngles(plyangle + Angle(45, 90 , 0))
                RunConsoleCommand("+attack2")
                timer.Simple(0.07, function() RunConsoleCommand("-attack2") end)
                timer.Simple(0.05, function() bd = false end)			
            end
     end]]
     
end

function serj.CreateMove(cmd)

	RunConsoleCommand("cl_interp","0")	
    RunConsoleCommand("cl_interp_ratio","0")	

	serj.garbage = (serj.oldCG("count") / 1000)

    for key, keyState in pairs(serj.activebinds) do
        if istable(key) then continue end
        local bind = serj.cfg.Keybinds[key]
        if bind == nil or bind == 0 then continue end

        if serj.cfg.Keybinds.mode[key] == 1 then -- Hold
            serj.activebinds[key] = input.IsButtonDown(bind)
        elseif serj.cfg.Keybinds.mode[key] == 2 then -- Toggle
            if input.WasKeyPressed(bind) then
                serj.activebinds[key] = !serj.activebinds[key]    
            end 
        end
    end

    if serj.activebinds["ebanina_exploit"] then
        jopa.Ebanina(cmd)
    end

	serj.SilentAngles(cmd)
	if cmd:CommandNumber() == 0 then return end

	serj.FakeLag(cmd)
	serj.Movement(cmd)
	serj.CircleStrafe(cmd) 

    if serj.GLPTEST and serj.MOVEING then
        serj.moveToPos(cmd, serj.GLP)
    end

    if serj.cfg.Vars["move_ap_ar"] then
        if serj.MOVEING then
            if serj.lastpos:Distance(me:GetPos()) < 25 then  
                serj.MOVEING = false
            end
        end
    end

    if serj.cfg.Vars["move_ap_apb"] then
        if serj.GLPTEST and !serj.MOVEING and serj.lastpos:Distance(me:GetPos()) > 1 then
            if !cmd:KeyDown(IN_MOVERIGHT) and !cmd:KeyDown(IN_MOVELEFT) and !cmd:KeyDown(IN_FORWARD) and !cmd:KeyDown(IN_BACK) then
                serj.moveToPos(cmd, serj.GLP)
            end
        end
    end

	jopa.StartPrediction(cmd)
		serj.AimTarget(cmd)
		serj.Aim(cmd)
	jopa.FinishPrediction()
	serj.AutoReload(cmd)

    if serj.activebinds["backstab"] then
        serj.Backstab(cmd)
    end

    if serj.cfg.Vars["af_r"] then
        local wep = IsValid(me) and IsValid(me:GetActiveWeapon()) and me:GetActiveWeapon() or nil
        local wep_class = IsValid(wep) and (wep.GetClass and wep:GetClass() or tostring(wep)) or ""

        if wep_class ~= "rust_buildingplan" then
            if me:KeyDown( IN_ATTACK ) then
                cmd:RemoveKey(IN_ATTACK)
            end
        end
    end

    if serj.cfg.Vars["legit_trigger"] then
        local traceget = me:GetEyeTrace().Entity

        if traceget:IsPlayer() and !traceget:IsNPC() and traceget != nil and traceget:Alive() then
            if serj.CanShoot() and serj.ValidateTarget(traceget) then
                cmd:AddKey(IN_ATTACK)
            end
        end
    end

	serj.fart(cmd)
	
    serj.RukaLico(cmd) 

    if serj.cfg.Vars["use_spam"] then
        if me:KeyDown( IN_USE ) then
            cmd:RemoveKey(IN_USE)
        end
    end

    --serj.MichaelJacksonExploit(cmd) 

	jopa.SetBSendPacket(serj.bsendpacket)
end

serj.chatSpam = {
    spam = {
        [1] = {
            "ТОП СОФТ ДС - danilkochnevolegovich",
            "ТОП СОФТ ДС - danilkochnevolegovich",
            "ТОП СОФТ ДС - danilkochnevolegovich",
            "ТОП СОФТ ДС - danilkochnevolegovich",
            "ТОП СОФТ ДС - danilkochnevolegovich",
            "ТОП СОФТ ДС - danilkochnevolegovich",
            "ТОП СОФТ ДС - danilkochnevolegovich",
            "ТОП СОФТ ДС - danilkochnevolegovich",
            "ТОП СОФТ ДС - danilkochnevolegovich",
        },
        [2] = {
            "Купи MAMBET.BIZ и разьеби всех!",
            "Хочется посрать но не можеш? Купи MAMBET.BIZ!СЕЙЧАС ЖЕ БЛЯТЬ!",
            "Лучший пенис это MAMBET.BIZ!КУПИ БЛЯТЬ!",
            "Еще не купил MAMBET.BIZ?Чего ждеш?ТВАРЬ КУПИ БЛЯДИНА!",
            "Кто прочитал тот гей!Купи MAMBET.BIZ и будеш не гей!",
            "Что то застряло у тебя в попке кажется это мой пенис!",
            "Удаляй свой кал и качай MAMBET.BIZ!",
            "MAMBET.BIZ лучшее решение!Хватит жить в коробке от обуви!",
        },
        [3] = {
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
        [4] = {
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
        [5] = {
            "p̵͕͑ě̶̥n̸̙̈ȋ̶̝s̶̪̅",
            "d̴̞̂ē̵̦d̵̟̊a̶͍̽",
            "b̶̲́a̴̳͊ṉ̸̐ḑ̶̆é̴͜r̴̫̐a̷̞͐",
            "i̶̘̕l̶̙̓n̵̗̋a̴͓̿ẓ̷͘ ̶͇̀b̶̞̍o̶͉͗ǧ̷͓",
            "ị̷͊m̵̢̏ ̴̜͗g̸͆͜a̸̰̓y̸̺͘",
            "c̴̡̝̙̞̱͉̊́̊̓͒̈́̉͋̃͗̒͐o̷̯̣̯̦̦͙͖̬͈̻͙̓̇͂̍̂̑́͐͗͛͒͗͋͗̾͘c̴̡̺̻̹̖̠̦͇̣̯̞̻̄̈́̇͝ͅk̴̡̢̨̨͉̬̘̜̞͙̟̱̺͓͛̇͋̂̈́̓̒̉́͛͌͜͠͠͝͝͝͠",
            "g̵͚̑ā̵͓ÿ̸̟́ ̸̖̂c̵̫͛ŏ̸̻c̶̖̐k̵͕̂",
            "п̸̭͝у̸͇͝т̶̥̃и̴̱͗н̵̢͌ ̷̺̅б̷̛̰ӧ̷͇г̸̯̍",
            "я̶͙̫͍͕̗̥͛̏́ ̸̯̗͍̫̥̇п̶̟͕̹̹͌͂̈́̚͘о̴͚͇̘͍̎̉̔̔͛с̷̮̙͂̀р̶̩̱̔̓͑̈́̑а̶̺́̆̆͐͆͘л̸̧͇̟͑̚",
        },
        [6] = {
            "КУПИ MAMBET.BIZ ИБИ ВСЕХ",
        }, 
        [7] = {
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
        },   
    },
    ar = {
        [1] = {
            "shut up dog",
            "everyone really doesn't care",
            "shut up already",
        },
        [2] = {
            "Всем похуй чел алооооо",
            "Всем похуй",
            "Как же всем похуй",
            "Не пиши",
            "Боже изичка не пиши забеала",
            "Всем похуй чел алооооо",
            "Пук раскажеш в садеке",
            "Ты в школи не учелся штоле? откуда стоко ошибак",
            "бля поправь граматику пото м пиши глупый",
            "чел тебе не стыдно такой бред писать?",
            "иди уроки учи",
            "клоун",
            "помолчи уже нолайфер блять боже",
            "ливни уже нолайфер в гможде",
            "плак плак",
            "Чел ты хотябы писать то науичсиь тебе лет 6 чтоли",
            "ты бы хтябы песать научислся",
            "ребенок иди поплач мамочке",
            "ахахахахаха ебать ты лох цонешно",
            "чел ты кринж",
            "кринж",
            "Как же тебя уни жают лилвини",
            "навалил кринге",
            "что ты блять несеш чел",
            "ааххахахах ебать ты даун",
            "иди поплач эх",
            "Ты глупый чтоли? сын фермера",
            "придумай что то новое",
            "ты даун?",
            "чел хуйню несеш",
            "да помолчси уже всем похуй",
        },
        [3] = {
            "الجميع لا يهتم بما تكتبه",
            "إنهاء اللعبة بالفعل",
            "اخرس بالفعل",
        },
        [4] = {
            "herkes buraya yazdığın şeyi umursamıyor",
            "zaten oyundan çıkın",
            "bunu yazmayı bırak zaten",
        },
        [5] = {
            "s̴̛͓̈́h̵̭̉u̴̻̱͆t̴̹̅ ̶̲̉͜ǔ̶͇̭̅p̶͙̻̎",
            "s̵̪͙̒̍h̵͓̰͂̌ú̵̩̪́t̵̲͂͝ ̵̳̒̓ụ̸̼͑p̵̢̗̏ ̷͎̌d̵̪͇̐o̶̮͖͑͘g̷̪̫̉",
            "d̸̹̓̒ỏ̴͔̕n̷̥̞̊'̸̲͚͒̍t̴̩͕̆ ̶̦̒c̸͚̖̓a̴͒̓͜r̷̲̚̚e̷̝̕",
        },
        [6] = {
            "5hu7 up",
            "5hu7 up d06",
            "d0n7 c4r3",
        },    
    },
    ks = {
        [1] = {
            "ez",
            "1",
            "ez kill",
        },
        [2] = {
            "Lucky Shot - Arab shot",
            "Lucky Shot!!",
            "Omg WTF Man Im so luckyyyy!!!",
            "Omg Nice aim!",
            "Чел забей",
            "Чел ты не шарищ",
            "Чел мне жаль но твоя мать еще жива",
            "И камнем вниииииииззззззззз!",
            "Я прямо как Ильназ Галяиев",
            "Найс софт чел без читов ты 0",
            "Чел ты без читов 0",
            "Держи зонтик тебя абасали",
            "Го 1 на 1 или зассал?Точно ты же до 1 считать не умееш...",
            "Отправляйся в детдом!!!1",
            "Я псрал а ты все сьел",
            "Рукоблуд санина очко блядун вагина",
            "Мне похуй на закон!Я буду грабить и ебать",
            "Я муслим мне похуй на кризис мой пенис вырос",
            "Чел в бан летиш",
            "Чел это бабабуз как бы",
            "Мы в НОНРП Зоне как бы да чел отлетаеш",
            "Найс баг абуз чел папа жива?",
            "Loading… ██████████ Lifehack.cfg Activated",
            "Tapt by Anti-Hack",
            "Kys 1yo autist",
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
            "нищий улетел",
            "пофикси нищ",
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
        [3] = {
            "أنت لست خصمي ، أنت روبوت!",
            "أنت ضعيف لدرجة أن والدتك المتوفاة أقوى.",
            "أصلح حياتك يا حبيبي",
            "سخيف boletus",
            "إذا كنت تقرأ هذا فأنت شاذ",
            "قاذورات, نفاية, قمامة, رعاع, هراء, زبالة, سقط",
            "إلى سلة المهملات",
            "إنص نص نصي غير مرغوب فيه",
            "قاذورات, نفاية, قمامة, رعاع, هراء, زبالة, سقط",
            "انا عربي وانت سقطت",
            "أنت لست خصمي ، أنت روبوتأنت لست خصمي ، أنت روبوت!",
            "أنت لست خصمي ، أنت روبوتأنت ضعيف لدرجة أن والدتك المتوفاة أقوى.",
            "أنت لست خصمي ، أنت روبوتأصلح حياتك يا حبيبي",
            "أنت لست خصمي ، أنت روبوتأنت لست خصمي ، أنت روبوتسخيف boletus",
            "أنت لست خصمي ، أنت روبوتإذا كنت تقرأ هذا فأنت شاذ",
            "أنت لست خصمي ، أنت روبوتقاذورات, نفاية, قمامة, رعاع, هراء, زبالة, سقط",
            "أنت لست خصمي ، أنت روبوتإلى سلة المهملات",
            "إنص نص نصي غير مرغوب فيأنت لست خصمي ، أنت روبوته",
            "أنت لست خصمي ، أنت روبوتقاذورات, نفاية, قمامة, رعاع, هراء, زبالة, سقط",
            "أنت لست خصمي ، أنت روبوتانا عربي وانت سقطت",
            "هذا هو البريد الإلكتروني العشوائي باللغة العربية"
        },
        [4] = {
            "kolay cinayet",
            "sen zayıf bir köpeksin",
            "kurşunu al zayıf köpek",
            "her zamankinden daha kolay",
            "sorun değil",
        },
        [5] = {
            "e̸̡̩͇̬̮͖͈͔̻̞̯͓̮͋͛̾̒̇̌̂̌̈́́̇̍̎͛̈́ż̵̧̨̢̰̝͙̤͚͈̫̗͓̓̋̄͒͛̏́̎̈́̕͠ ̴͈̿̾̅1̷̪̭̤͒̎̈́̽̿͂ͅ",
            "e̷̢̝̠̣̯̪̦̙̺̖̐̾͜z̵̩̓̅̋̀̃͗̆͒͒͘̚̕͝͝͝ ̵̡̼̠̗͚̬͚͋̌̿́̽̓̄͐͊̾͊̃͝ḵ̵̡̠͓͚̖̎̿̓͆͠ĭ̷̝̙͙̀̈̾͂́̒̀͊̆͂͊̄̓͆͜l̵̼̯̲̾̀̂͆̑̈͂̂̿̐͋ͅl̴̨̨̛͇̬̺̭̳̪̺̟̗̱̱̠͐̆̕̚̕͝͝",
            "ơ̸̙͉̲̗̩̗̩͓͖͙̳̏̅̂w̵͖̝̩͖̣̜̜̤̽̋̈́̋̀̂n̵͎͚̬̥̻̤̟͔̞̯̔̾͗̔͠ȩ̸̧̢̧̢͔̻̭̪̳̊̌̀̋̐͑̈́̄̎̑͝ͅd̵̞̟̮̮͔̣͆̄̉̑́̾̈́͒",
            "ę̶̝̿̾̋͊͗̔͌͝z̴̲̝͐͒̀̏̓ ̴͉̹̠͚͖͌͒̅̃̇̐̄d̵̛̲͖̂̑͒̔̊̈́̏͘ỏ̴̢̢̡͈̭̮̲̎̑̇̃͌̾̊̔́̕͜ģ̵̪̼͈̻͉̥͉̭͖̼̗̃̐́̋͛͐̕͠",
            "1̵̥̼̈́ ̴̪̦̍n̷̞̋̕ṋ̶̬̓̚ ̶͍͗͜d̸̩̫́o̷̩̓g̸͉̮͌ ̷̮̪͊͊õ̸͉̟̆w̷͕̕͜n̵̦͑e̷̜̞͌d̷̬̚͜͝",
        },
        [6] = {
            "3z k1ll",
            "3z k1ll 3z k1ll 11111",
            "3z 0wn3d",
            "3z d06",
            "3z k1ll d06 0nw3d by p 53r3j464 h4ck",
        },    
        [7] = {
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
        },

    },
}

serj.antidalbaeb = function(text, maxChars)
    local str = ""

    for i=1, maxChars do
        str = str .. (text[i] || "")
    end

    return str
end

serj.hitlogs = {data = {}}
serj.add = {x = 0, y = 0}
serj.helpers = {
    lerp = function(self, start, end_pos, time, delta)
        if (math.abs(start - end_pos) < (delta or 0.01)) then return end_pos end

        time = FrameTime() * (time * 175) 
        if time < 0 then
          time = 0.01
        elseif time > 1 then
          time = 1
        end
        return ((end_pos - start) * time + start)
    end,
}
serj.MultiColorText = function(data, x, y)
    local total_width = 0
    local width = 0
    surface.SetFont( "hitlogs" )
    for _, v in pairs(data) do
        local text = v[1]
        local text_width, text_height = surface.GetTextSize( text )
        total_width = total_width + text_width
    end

    for _, v in ipairs(data) do
        local text = v[1]
        local text_width, text_height = surface.GetTextSize( text )
        local x2 = (x - total_width / 2 + width)
	    draw.SimpleText( v[1], "hitlogs", x2+1, y+1, Color( 0, 0, 0, v[2].a) )
	    draw.SimpleText( v[1], "hitlogs", x2, y, v[2] )

        width = width + text_width
    end
end

serj.hitlogs.on_draw = function()
    local sc = {x = scrw, y = scrh}
    local x, y = sc.x/2, sc.y/1.1
    serj.add.y = 0
    for k, v in ipairs(serj.hitlogs.data) do
        local text = v[1]
        local r, g, b = v.color.r, v.color.g, v.color.b
        local realtime = RealTime()
        if v.time + 1 > realtime then
            v.alpha = serj.helpers:lerp(v.alpha, 1, 0.095)
            v.alpha1 = serj.helpers:lerp(v.alpha, 1, 0.05)
        end

        serj.add.y = serj.add.y + 15*v.alpha
        local wh = Color(255, 255, 255, v.alpha*255)
        local ch = Color(r, g, b, v.alpha*255)
        serj.MultiColorText({
            {
                text[1],
                wh
            },
            {
                text[2],
                ch
            },
            {
                text[3],
                wh
            },
            {
                text[4],
                ch
            },
            {
                text[5],
                wh
            },
            {
                text[6],
                ch
            },
            {
                text[7],
                wh
            },
            {
                text[8],
                ch
            },
            {
                text[9],
                wh
            }
        }, x + v.alpha1*100 - 100, y - serj.add.y)
        
        if v.time + 5 < realtime then
            v.alpha = serj.helpers:lerp(v.alpha, 0, 0.05)
            v.alpha1 = serj.helpers:lerp(v.alpha1, 2, 0.04)
        end
        if v.alpha < 0.01 and (v.time + 6 < realtime) or #serj.hitlogs.data > 50 then
            table.remove(serj.hitlogs.data, k)
        end
    end
end
serj.hitlog_hitboxes = {
    ["ValveBiped.Bip01_R_Hand"] = "Right Hand",
    ["ValveBiped.Bip01_R_Forearm"] = "Right Hand",
    ["ValveBiped.Bip01_R_UpperArm"] = "Right Hand",

    ["ValveBiped.Bip01_L_Hand"] = "Left Hand",
    ["ValveBiped.Bip01_L_Forearm"] = "Left Hand",
    ["ValveBiped.Bip01_L_UpperArm"] = "Left Hand",

    ["ValveBiped.Bip01_Spine2"] = "Chest",

    ["ValveBiped.Bip01_Pelvis"] = "Pelvis",
    
    ["ValveBiped.Bip01_R_Thigh"] = "Right Leg",
    ["ValveBiped.Bip01_R_Calf"] = "Right Leg",
    ["ValveBiped.Bip01_R_Toe0"] = "Right Leg",
    ["ValveBiped.Bip01_R_Foot"] = "Right Leg",

    ["ValveBiped.Bip01_L_Thigh"] = "Left Leg",
    ["ValveBiped.Bip01_L_Calf"] = "Left Leg",
    ["ValveBiped.Bip01_L_Toe0"] = "Left Leg",
    ["ValveBiped.Bip01_L_Foot"] = "Left Leg",

    ["ValveBiped.Bip01_Head1"] = "Head",

    ["generic"] = "generic"
}

gameevent.Listen("player_hurt")
hook.Add( "player_hurt", "player_hurt_example", function( data )
	local health = data.health
	local priority = SERVER and data.Priority or 5
	local hurted = Player( data.userid )
	local attackerid = data.attacker

	if attackerid == me:UserID() then
		serj.hits = serj.hits + 1
        if serj.target != nil then
            serj.AddResolverStep(serj.target,false)
        end
        if serj.cfg.Vars["misc_hitsound"] then
            if serj.cfg.Vars["misc_hitsound_sound"] == 1 then
                surface.PlaySound("phx/hmetal1.wav")
            elseif serj.cfg.Vars["misc_hitsound_sound"] == 2 then
                surface.PlaySound("player/headshot1.wav")
            elseif serj.cfg.Vars["misc_hitsound_sound"] == 3 then
                surface.PlaySound("phx/eggcrack.wav")
            elseif serj.cfg.Vars["misc_hitsound_sound"] == 4 then
                surface.PlaySound("buttons/blip2.wav")
            elseif serj.cfg.Vars["misc_hitsound_sound"] == 5 then
                surface.PlaySound("phx/hmetal2.wav")
            elseif serj.cfg.Vars["misc_hitsound_sound"] == 6 then
                surface.PlaySound("phx/hmetal3.wav")
            elseif serj.cfg.Vars["misc_hitsound_sound"] == 7 then
                surface.PlaySound("garrysmod/balloon_pop_cute.wav")
            elseif serj.cfg.Vars["misc_hitsound_sound"] == 8 then
                surface.PlaySound("common/stuck1.wav")
            elseif serj.cfg.Vars["misc_hitsound_sound"] == 9 then
                surface.PlaySound("custom.wav")
            end
        end
        if serj.cfg.Vars["logs_hurt"] then
            local attackerply = Player( attackerid )
            local hitlogc = string.ToColor(serj.cfg.Colors["logs_hurt"])

            local bone = "generic"

            if attackerply:GetEyeTrace().HitBoxBone != nil then
                bone = serj.hitlog_hitboxes[hurted:GetBoneName(attackerply:GetEyeTrace().HitBoxBone)]
            end

            table.insert(serj.hitlogs.data, {
                {
                    "Hit ",
                    hurted:Nick(),
                    " in the ",
                    bone,            
                    " for ",
                    tostring(string.gsub(data.health-hurted:Health(), "-", "")),
                    " damage (",
                    tostring(data.health),
                    " health remaining)",
                },
                alpha = 0,
                alpha1 = 0,
                time = RealTime(),
                color = hitlogc,
            })
            
        end
	end
end )

serj.ovoshi = 0
serj.killstreak = 0
serj.nextact = 0

gameevent.Listen("entity_killed")
hook.Add( "entity_killed", "entity_killed_example", function( data ) 
    local victim = Entity(data.entindex_killed)
    local attacker = Entity(data.entindex_attacker)
    
    if attacker == me and attacker != victim then

        serj.ovoshi = (serj.ovoshi or 0) + 1
        serj.killstreak = (serj.killstreak or 0) + 1
        if serj.cfg.Vars["dance_spam_kt"] and me:Alive() and !me:IsPlayingTaunt() and CurTime() > serj.nextact then   
            if !serj.cfg.Vars["dance_spam_kt_bs"] then
                RunConsoleCommand("act", "laugh")
            else
                RunConsoleCommand("act", "disagree")
                RunConsoleCommand("say", "* Закрутился с дизлайком унизив бота *")
                serj.brawlstars_unizil = true 
                timer.Simple(3,function() serj.brawlstars_unizil = false end)
            end

            serj.nextact = CurTime() + 0.3
        end

        if serj.cfg.Vars["misc_killsound"] then
            if serj.cfg.Vars["misc_killsound_sound"] == 1 then
                surface.PlaySound("phx/hmetal1.wav")
            elseif serj.cfg.Vars["misc_killsound_sound"] == 2 then
                surface.PlaySound("player/headshot1.wav")
            elseif serj.cfg.Vars["misc_killsound_sound"] == 3 then
                surface.PlaySound("phx/eggcrack.wav")
            elseif serj.cfg.Vars["misc_killsound_sound"] == 4 then
                surface.PlaySound("buttons/blip2.wav")
            elseif serj.cfg.Vars["misc_killsound_sound"] == 5 then
                surface.PlaySound("phx/hmetal2.wav")
            elseif serj.cfg.Vars["misc_killsound_sound"] == 6 then
                surface.PlaySound("phx/hmetal3.wav")
            elseif serj.cfg.Vars["misc_killsound_sound"] == 7 then
                surface.PlaySound("garrysmod/balloon_pop_cute.wav")
            elseif serj.cfg.Vars["misc_killsound_sound"] == 8 then
                surface.PlaySound("common/stuck1.wav")
            elseif serj.cfg.Vars["misc_killsound_sound"] == 9 then
                surface.PlaySound("custom.wav")
            end
        end
        
        if serj.cfg.Vars["misc_killsay"] then
            local lang = serj.cfg.Vars["misc_killsay_lang"] or 1
            local cmsg = serj.chatSpam.ks[lang] or serj.chatSpam.ks[1]
            local fmsg = cmsg[mrandom(#cmsg)]
            if serj.cfg.Vars["misc_killsay_o"] then
                if serj.ovoshi <= 1 then
                    RunConsoleCommand("say","Сбор урожая начат!")
                elseif serj.ovoshi > 1 then
                    RunConsoleCommand("say","Сбор урожая продолжается! Собран новый овощ - " .. victim:Nick() .. " !" )
                end
            else
                RunConsoleCommand("say",fmsg)
            end
        end

        if serj.cfg.Vars["misc_killsound_ks"] then
            if serj.killstreak > 0 then
                if serj.killstreak == 4 then
                    surface.PlaySound("multikill.wav")
                elseif serj.killstreak == 6 then
                    surface.PlaySound("ultrakill.wav")
                elseif serj.killstreak == 8 then
                    surface.PlaySound("killingspree.wav")
                elseif serj.killstreak == 10 then
                    surface.PlaySound("holyshit.wav")
                elseif serj.killstreak == 12 then
                    surface.PlaySound("rampage.wav")
                elseif serj.killstreak == 14 then
                    surface.PlaySound("monsterkill.wav")
                elseif serj.killstreak == 16 then
                    surface.PlaySound("godlike.wav")
                end
            end
        end

    end
    
    if attacker != me and me == victim then   
        if serj.cfg.Vars["misc_killsay"] and serj.cfg.Vars["misc_killsay_o"] then
            if serj.ovoshi > 0 then
                RunConsoleCommand("say","Сбор урожая окончен!Собрано овощей : " .. serj.ovoshi .. " !")
            end
        end
        serj.killstreak = 0
        serj.ovoshi = 0
    end

    if me == victim then 
        if serj.cfg.Vars["antiaim_sr"] then
            serj.headrot = serj.headrot + 1
            if headrot > 4 then
                serj.headrot = -4
            elseif serj.headrot <= 0 then            
            end
        else
            serj.headrot = 0
        end
    end

end )   

serj.Otvetki = {
    [1] = {
        "про мать было лишнее",
        "я твою маму ебал",
        "а может твоя",
        "твоя мать щлюха",
        "я твою маму камазом давил",
        "я твою матку ногами топтал",
        "твоя мать сдохла",
        "а может твоя?",
        "а твояяяяяяя",
        "у тебя хоть самого мать есть?",
        "да да твоя то сдохла",
        "твою в гробу видал",
        "твоя на помойке гниет",
        "твою маму негры ебали",
        "моя жива твоя мертва ауф",
        "я твою матку ебал кирпичом",
        "я твоей маме голову бил камнем блять",
        "твоя мама на кладбище живет моя в доме ауф",
        "я твою маму в мусорке видал ее бомжы ебали",
    },
    [2] = {
        "молчи сын бляди",
        "от сына хуйни слышу",
        "я твою маму ебал родился ты",
        "сын суки пасть офф",
        "молчи сын бляди тупой",
        "ауу дебилчик сын твари молчиии",
        "от сыня шлюхи слышу",
        "сыночек я твою мать ебал",
        "сынок говна сказал...",
        "сын говна офай рот",
        "рот на 0 сын твари",
        "сын падали ебучей молчи",
        "тебя шлюха родила как бы",
        "помалкивай там сынок бляди",
        "сынок шлюхи ротик на зомочек",
    },
    [3] = {
        "твой отец пидор",
        "твой батя алкаш ебаный",
        "отец твой спился эх..",
        "я твоего отца ногами пиздил",
        "я твоему отцу пальцы ломал",
        "у тебя нет отца только отчимы",
        "у тебя не отца не матери одни собаки эххх.",
    },
    [4] = {
        "я твою семью уродов в цирке видал",
        "твою семью нищюю на помйоке видел",
        "твоих родственников таптал",
        "твоя семья на помойке живет",
        "как там твоя семья хачей поживает?",
        "как тоам твои родные хачики?",
        "я твою семью сжигал в печке",
        "твоя семья в могиле покоится",
        "твоя семья помои жрет",
        "семья твоя в печке живет",
        "я твоих сестер и братьев ебал",
        "дедов и бабушек твоих в землю закапывал",
        "земля металом твоим родным",
        "тебя собаки воспитали",
    },
    [5] = {
        "мать твоя шлюха", "мать твоя сучка", 
        "молчи сука", "молчи шлюха", 
        "сука твоя мать", "пасть закрой щлюха мать твоя", 
        "я мать твою ебал шлюху", "сука твоя бабушка я ее пожилую пизду трахал", 
        "сучку мать твою трахал и на костре жарил", "я твою мать за 5 рублей снимал", 
        "твою мать трахать любой может (она шлюха) ахахха", "мать твоя шлюшка хахахаха", 
        "бабуля твоя сука хахах", "ты сам то шлюха маленькая хахаха", 
    }, 
    [6] = {
        "без мата пж", "чел ты ток матом умееш ругатся",
        "без мата умееш говорить?", "как много мата эх",
    },
}

function serj.findInText(text,slovo)
    for k, v in pairs(slovo) do
        if text:find(v) then
            return true
        end
    end
    return false
end

serj.slova = {}
serj.slova.matka = {}
-- Слова про мать
serj.slova.matka = {
    "мать",
    "матер",
    "мам",
    "матух",
    "матб",
    "мамк",
    "ммат",
    "ммамк",
    "matb", -- пиздец
    "мамаш",
    "матуш",
    "мамашк",
    "свиноматк",
}
-- слова про сына (типо "ты сын говна" или тп)
serj.slova.sinishka = {
    "сын",
}
-- слова про отца
serj.slova.otec = {
    "отец",
    "отца",
    "отцу",
    "пап",
    "батя",
    "батю",
    "бате",
    "отчи",
    "отче",
    "папа",
}
-- брат, сестра, бабуля, дед
serj.slova.semya = {
    "сестр",    
    "систр",
    "сестре",    
    "бабушка",
    "бабуш",
    "бабк",
    "бабул",
    "семь",    
    "дед",
    "брат",     
}
-- щлюха, сучка
serj.slova.shluha = { 
    "шлю",    
    "шлюх",    
    "суч",
    "сук",
    "проститу",
    "простет",
    "шма",
}
-- хуесос, чмо, говноед
serj.slova.huesosi = {
    "хуес",
    "чмо",
    "далба",
    "говное",
    "крип",
    "диби",
    "деби",
    "доди",
    "даун",
    "аути",
    "тупо",
    "тупа",
    "куколд",
    "блядь",
    "бляд",
    "очкош",
    "хохол",
    "хохл",
    "ебан",
    "хуйл",
    "mq",
}
-- матюки
serj.slova.mati = {
    "бл",
    "ху",
    "сос",
    "еб",
    "гей",
    "залуп",
}

function serj.Chatter(gadosti)
    local text = gadosti:lower()
    local pro_matku = serj.Otvetki[1]
    local pro_sina = serj.Otvetki[2]
    local pro_papku = serj.Otvetki[3]
    local pro_srmyu = serj.Otvetki[4]
    local pro_shluhu = serj.Otvetki[5]
    local pro_mati = serj.Otvetki[6]

    if serj.findInText(text,serj.slova.matka) then
        return pro_matku[mrandom(#pro_matku)]
    elseif serj.findInText(text,serj.slova.sinishka) then
        return pro_sina[mrandom(#pro_sina)]
    elseif serj.findInText(text,serj.slova.otec) then
        return pro_papku[mrandom(#pro_papku)]   
    elseif serj.findInText(text,serj.slova.semya) then
        return pro_srmyu[mrandom(#pro_srmyu)]         
    elseif serj.findInText(text,serj.slova.shluha) then
        return pro_shluhu[mrandom(#pro_shluhu)]       
    elseif serj.findInText(text,serj.slova.mati) then
        return pro_mati[mrandom(#pro_mati)]  
    else
        return false
    end

end

serj.govorittime = 1 
serj.resptimer = 1
gameevent.Listen("player_say")
hook.Add( "player_say", "player_say_example", function( data ) 
	local priority = SERVER and data.Priority or 1 	
	local id = data.userid				
	local text = data.text				


    if serj.cfg.Vars["misc_chatspam_ar"] then
        local cmsg = serj.chatSpam.ar[serj.cfg.Vars["misc_chatspam_lang"]]
        local fmsg = cmsg[mrandom(#cmsg)]
        local otvetka = serj.Chatter(text)

        if id != me:UserID() then
            if serj.cfg.Vars["misc_chatbot"] and otvetka != false then
                RunConsoleCommand("say",otvetka) 
            else   
                RunConsoleCommand("say",fmsg)
            end
        end
    end

end )

serj.aspectratio = scrw / scrh
serj.verticalfov = mrad(74)
serj.realfov = 2 * mtan(mtan(serj.verticalfov * 0.5) * serj.aspectratio) * 0.5
serj.trailpos = {}
serj.trackedCheaters = {}
serj.githubSyncLoaded = false

function serj.SyncCheaters()
    if not serj.cfg.Vars["MAMBETIEBANIE"] then return end
    
    http.Fetch("https://raw.githubusercontent.com/fidsh52-svg/chacha/refs/heads/main/mambeti", function(body, len, headers, code)
        if code == 200 and body and body ~= "" then
            serj.trackedCheaters = {}
            for _, line in ipairs(string.Split(body, "\n")) do
                local trimmed = string.Trim(line)
                if trimmed == "" then continue end
                
                local sid, tag = trimmed:match("^(STEAM_%d:%d:%d+)[%s\t]*(.*)$")
                if sid then
                    serj.trackedCheaters[sid] = (tag ~= "" and tag) or "Cheater"
                end
            end
            serj.githubSyncLoaded = true
        end
    end)
end

function serj.HUDPaint()
    if serj.cfg.Vars["self_trail"] then
		local hsv = HSVToColor( ( CurTime() * 50 ) % 360, 1, 1 )
		surfaceSetDrawColor(hsv.r,hsv.g,hsv.b)
		for i = 1, #serj.trailpos-1 do
			local pos = serj.trailpos[i]:ToScreen()
			local prevpos = serj.trailpos[i+1]:ToScreen()
			surfaceDrawLine(pos.x,pos.y,prevpos.x,prevpos.y)
		end
	end	
	serj.trailpos[#serj.trailpos+1] = LocalPlayer():GetPos()

	if #serj.trailpos > 100 then
		table.remove(serj.trailpos,1)
	end

    local trgv = serj.targetVector:ToScreen()

	if serj.cfg.Vars["as_enable"] then
        local aimbot_snapline_color = string.ToColor(serj.cfg.Colors["as_enable"])
        if serj.target != nil and serj.targetVector != nil then
            surfaceSetDrawColor(aimbot_snapline_color.r,aimbot_snapline_color.g,aimbot_snapline_color.b,aimbot_snapline_color.a)
            surfaceDrawLine( scrw/2, scrh/2, trgv.x, trgv.y)
        end
    end
    if serj.cfg.Vars["ap_enable"] then
        local avc = string.ToColor(serj.cfg.Colors["ap_enable"])
        if serj.target != nil and serj.targetVector != nil then
            if serj.cfg.Vars["ap_box"] then
                surfaceSetDrawColor(avc)
                surfaceDrawRect(trgv.x-2, trgv.y-2, 4,4)
            else
                serj.surfaceTexture(trgv.x-8, trgv.y-8, 15,15, "sprites/glow04_noz_gmod",avc)
            end
        end
    end
    

    

    if serj.cfg.Vars["legit_fov_draw"] then
        local rad = (mtan(mrad(serj.cfg.Vars["legit_fov_val"]) * 0.5) / mtan(serj.realfov)) * scrw

		surfaceDrawCircle(scrw * 0.5, scrh * 0.5, rad, string.ToColor(serj.cfg.Colors["legit_fov_draw"]))
    end

    serj.hitlogs.on_draw()
end

serj.act = "robot"
serj.acts = {
    "robot",
    "muscle",
    "laugh",
    "bow",
    "cheer",
    "wave",
    "becon",
    "agree",
    "disagree",
    "forward",
    "group",
    "half",
    "zombie",
    "dance",
    "pers",
    "halt",
    "salute",
}
serj.chatspamcd = 0

serj.oldFile = serj.cfg.Vars["dprot_file_lyb"]
serj.oldSql = serj.cfg.Vars["dprot_sql"]
serj.oldSM = serj.cfg.Vars["dprot_qmenu"]
serj.oldDupes = serj.cfg.Vars["dprot_dupes"]
serj.oldHTMLorDHTML = serj.cfg.Vars["dprot_html"]
serj.oldCGF = serj.cfg.Vars["dprot_cg"]
serj.oldSteamWorksss = serj.cfg.Vars["dprot_sw"]
serj.oldHttpDed = serj.cfg.Vars["dprot_http"]
serj.oldGameGui = serj.cfg.Vars["dprot_clcgameui"]
serj.olddmgforcee = serj.cfg.Vars["allah_damage_force"]


serj.kakishi = {
    "с какими софтами?",
    "че за софты?",
    "какие читы у вас?",
    "норм читы у вас какие скажите ?",
    "че за читы у ввас ткие мощные?",
    "пацаны дайте кфг на екзек пжпжпжпж",
}

function serj.Think()
    if serj.cfg.Vars["MAMBETIEBANIE"] and not serj.githubSyncLoaded then
        serj.SyncCheaters()
    end

    if serj.cfg.Vars["dprot_e"] then
        
        if serj.oldFile != serj.cfg.Vars["dprot_file_lyb"] && serj.cfg.Vars["dprot_file_lyb"] then
            file.CreateDir = function()end
            file.Delete = function()end
            file.Write = function()end
            file.Exists = function()end
            file.Find = function()end
            file.Open = function()end

            function fm:Seek( pos )
                return false    
            end
            function fm:Size()
                return nil    
            end
            function fm:WriteBool( bool )
                return false    
            end
            function fm:ReadFloat()
                return nil    
            end

            serj.oldFile = serj.cfg.Vars["dprot_file_lyb"]
        elseif serj.oldFile != serj.cfg.Vars["dprot_file_lyb"] && !serj.cfg.Vars["dprot_file_lyb"] then
            file.CreateDir = function(name)
                local oldfunc = serj.oldCreateDir(name)
                return oldfunc
            end
            file.Delete = function(name)
                local oldfunc = serj.oldFileDelete(name)
                return oldfunc
            end
            file.Write = function(f,c)
                local oldfunc = serj.oldFileWrite(f,c)
                return oldfunc
            end
            file.Exists = function(n,g)
                local oldfunc = serj.oldFileExists(n,g)
                return oldfunc
            end
            file.Find = function(n,p,s)
                local oldfunc = serj.oldFileFind(n,p,s)
                return oldfunc
            end
            file.Open = function(fn,fm,gp)
                local oldfunc = serj.oldFileOpen(fn,fm,gp)
                return oldfunc
            end

            function fm:Seek( pos )
                return serj.OldSeek( pos ) 
            end
            function fm:Size()
                return serj.OldSize()    
            end
            function fm:WriteBool( bool )
                return serj.OldWriteBool(bool)    
            end
            function fm:ReadFloat()
                return serj.OldReadFloat()    
            end

            serj.oldFile = serj.cfg.Vars["dprot_file_lyb"]
        end

        if serj.oldSql != serj.cfg.Vars["dprot_sql"] && serj.cfg.Vars["dprot_sql"] then
            sql.Begin = function()end
            sql.Commit = function()end
            sql.Query = function()end
            sql.QueryRow = function()end
            sql.QueryValue = function()end

            serj.oldSql = serj.cfg.Vars["dprot_sql"]
        elseif serj.oldSql != serj.cfg.Vars["dprot_sql"] && !serj.cfg.Vars["dprot_sql"] then
            sql.Begin = function()
                local oldfunc = serj.oldSqlBegin()
                return oldfunc
            end
            sql.Commit = function()
                local oldfunc = serj.oldSqlCommit()
                return oldfunc
            end
            sql.Query = function(textik)
                local oldfunc = serj.oldSqlQuery(textik)
                return oldfunc
            end
            sql.QueryRow = function(s,n)
                local oldfunc = serj.oldSqlQueryRow(s,n)
                return oldfunc
            end
            sql.QueryValue = function(q)
                local oldfunc = serj.oldSqlQueryValue(q)
                return oldfunc
            end

            serj.oldSql = serj.cfg.Vars["dprot_sql"]
        end

        if serj.oldSM != serj.cfg.Vars["dprot_qmenu"] && serj.cfg.Vars["dprot_qmenu"] then
            spawnmenu.DoSaveToTextFiles = function()end
            spawnmenu.SaveToTextFiles = function()end

            serj.oldSM = serj.cfg.Vars["dprot_qmenu"]
        elseif serj.oldSM != serj.cfg.Vars["dprot_qmenu"] && !serj.cfg.Vars["dprot_qmenu"] then
            spawnmenu.DoSaveToTextFiles = function(s)
                local oldfunc = serj.oldSpawnMenu1(s)
                return oldfunc
            end
            spawnmenu.SaveToTextFiles = function(s)
                local oldfunc = serj.oldSpawnMenu2(s)
                return oldfunc
            end

            serj.oldSM = serj.cfg.Vars["dprot_qmenu"]
        end

        if serj.oldDupes != serj.cfg.Vars["dprot_dupes"] && serj.cfg.Vars["dprot_dupes"] then
            engine.OpenDupe = function()end
            engine.WriteDupe = function()end

            serj.oldDupes = serj.cfg.Vars["dprot_dupes"]
        elseif serj.oldDupes != serj.cfg.Vars["dprot_dupes"] && !serj.cfg.Vars["dprot_dupes"] then
            engine.OpenDupe = function(dName)
                local oldfunc = serj.oldOpenDupe(dName)
                return oldfunc
            end
            engine.WriteDupe = function(d,j)
                local oldfunc = serj.oldWriteDupe(d,j)
                return oldfunc
            end

            serj.oldDupes = serj.cfg.Vars["dprot_dupes"]
        end

        if serj.oldHTMLorDHTML != serj.cfg.Vars["dprot_html"] && serj.cfg.Vars["dprot_html"] then
            gui.OpenURL = function()end
            function pnl:SetHTML()
            end
            function pnl:OpenURL()  
            end
            function pnl:RunJavascript()  
            end

            serj.oldHTMLorDHTML = serj.cfg.Vars["dprot_html"]
        elseif serj.oldHTMLorDHTML != serj.cfg.Vars["dprot_html"] && !serj.cfg.Vars["dprot_html"] then
            gui.OpenURL = function(url)
                return serj.OldGuiOpenUrl(url)
            end
            function pnl:SetHTML( code )
                return serj.OldHTML(code)
            end
            function pnl:OpenURL( url )  
                return serj.OldOpenURL(url)
            end
            function pnl:RunJavascript(js)  
                return serj.OldJSOnetapCrack2022(js)
            end

            serj.oldHTMLorDHTML = serj.cfg.Vars["dprot_html"]
        end

        if serj.oldCGF != serj.cfg.Vars["dprot_cg"] && serj.cfg.Vars["dprot_cg"] then
            collectgarbage = function()
                return 0
            end

            serj.oldCGF = serj.cfg.Vars["dprot_cg"]
        elseif serj.oldCGF != serj.cfg.Vars["dprot_cg"] && !serj.cfg.Vars["dprot_cg"] then
            collectgarbage = function(puk)
                local oldfunc = serj.oldCG(puk)
                return oldfunc
            end

            serj.oldCGF = serj.cfg.Vars["dprot_cg"]
        end

        if serj.oldSteamWorksss != serj.cfg.Vars["dprot_sw"] && serj.cfg.Vars["dprot_sw"] then
            steamworks.Download = function()end
            steamworks.DownloadUGC = function()end
            steamworks.IsSubscribed = function()end
            steamworks.OpenWorkshop = function()end
            steamworks.RequestPlayerInfo = function()end
            steamworks.ShouldMountAddon = function()end

            serj.oldSteamWorksss = serj.cfg.Vars["dprot_sw"]
        elseif serj.oldSteamWorksss != serj.cfg.Vars["dprot_sw"] && !serj.cfg.Vars["dprot_sw"] then
            steamworks.Download = function(s,b,f)
                return serj.oldSteamWorksDownload(s,b,f)
            end
            steamworks.DownloadUGC = function(s,f)
                return serj.oldSteamWorksDownloadUGC(s,f)
            end
            steamworks.IsSubscribed = function(s)
                return serj.oldSteamWorksSub(s)
            end
            steamworks.OpenWorkshop = function()
                return serj.oldSteamWorksOW()
            end
            steamworks.RequestPlayerInfo = function(s,c)
                return serj.oldSteamWorksReq(s,c)
            end
            steamworks.ShouldMountAddon = function(item)
                return serj.oldSteamWorksSMA(item)
            end

            serj.oldSteamWorksss = serj.cfg.Vars["dprot_sw"]
        end

        if serj.oldHttpDed != serj.cfg.Vars["dprot_http"] && serj.cfg.Vars["dprot_http"] then
            http.Fetch = function()end
            http.Post = function()end

            serj.oldHttpDed = serj.cfg.Vars["dprot_http"]
        elseif serj.oldHttpDed != serj.cfg.Vars["dprot_http"] && !serj.cfg.Vars["dprot_http"] then
            http.Fetch = function(s,f,ff,t)
                return serj.OldHttpFetch(s,f,ff,t)
            end
            http.Post = function(s,t,f,ff,fff,tt)
                return serj.OldHttpPost(s,t,f,ff,fff,tt)
            end

            serj.oldHttpDed = serj.cfg.Vars["dprot_http"]
        end

        if serj.oldGameGui != serj.cfg.Vars["dprot_clcgameui"] && serj.cfg.Vars["dprot_clcgameui"] then
            gui.HideGameUI = function()end
            gui.ActivateGameUI = function()end
            gui.EnableScreenClicker = function()end

            serj.oldGameGui = serj.cfg.Vars["dprot_clcgameui"]
        elseif serj.oldGameGui != serj.cfg.Vars["dprot_clcgameui"] && !serj.cfg.Vars["dprot_clcgameui"] then
            gui.HideGameUI = function()
                return serj.oldguiHide()
            end
            gui.ActivateGameUI = function()
                return serj.oldguiActivate()
            end

            gui.EnableScreenClicker = function(b)
                return serj.oldClicker(b)
            end

            serj.oldGameGui = serj.cfg.Vars["dprot_clcgameui"]
        end

        if serj.olddmgforcee != serj.cfg.Vars["allah_damage_force"] && serj.cfg.Vars["allah_damage_force"] then
            gui.HideGameUI = function()end
            function ctdi:SetDamageForce( vec )  
                print("1")
                return serj.oldDamageForce(vec*78600)
            end
            function ctdi:SetDamageType( num )  
                print("2")
                return serj.oldDamageType(67108864)
            end
            

            serj.olddmgforcee = serj.cfg.Vars["allah_damage_force"]
        elseif serj.olddmgforcee != serj.cfg.Vars["allah_damage_force"] && !serj.cfg.Vars["allah_damage_force"] then
            function ctdi:SetDamageForce( vec )  
                return serj.oldDamageForce(vec)
            end
            function ctdi:SetDamageType( num )  
                return serj.oldDamageType(num)
            end

            serj.olddmgforcee = serj.cfg.Vars["allah_damage_force"]
        end


        if serj.cfg.Vars["dprot_data_clear"] then
            local penises, directories = serj.oldFileFind( "*", "DATA" )
            for k,z in pairs(directories) do
                if z != "serj" then
                    local fffiles, adddirs = serj.oldFileFind( z.."/*", "DATA" )
                   -- print(z)
                    --PrintTable(fffiles)
                    if fffiles != nil then 
                        for i = 1,#fffiles do
                            --print(z.."/"..fffiles[i])
                            if file.Size(z.."/"..fffiles[i], "DATA") > serj.cfg.Vars["dprot_data_clear_"] * 1024 then
                                print( "Found and deleted file in dir " .. z .. " . file name " .. fffiles[i] .. " .File size " .. file.Size(z.."/"..fffiles[i], "DATA") )
                                serj.oldFileDelete(z.."/"..fffiles[i])
                            end
                        end
                    end
                end
            end
            for k,z in pairs(penises) do
                --print(k)
                --PrintTable(penises)
                if file.Size(penises[k], "DATA") > serj.cfg.Vars["dprot_data_clear_"] * 1024 then
                    print( "Found and deleted. file name " .. penises[k] .. " .File size " .. file.Size(penises[k], "DATA") )
                    serj.oldFileDelete(penises[k])
                end
                
            end
        end
    end

    if serj.cfg.Vars["misc_avtoobsh"] and CurTime() > serj.govorittime then  
        local whattosay = serj.kakishi[mrandom(#serj.kakishi)]
        RunConsoleCommand("say",whattosay)
        serj.govorittime = CurTime() + mrandom(5,55)
    end

    -- keybinds
    for key, keyState in pairs(serj.activebinds) do
        if istable(key) then return end
        if serj.cfg.Keybinds.mode[key] == 1 then 
            if input.IsKeyDown(serj.cfg.Keybinds[key]) or input.IsMouseDown(serj.cfg.Keybinds[key]) then
                serj.activebinds[key] = true
            else
                serj.activebinds[key] = false
            end
        end       
    end
    -- hueta
	if serj.cfg.Vars["misc_chatspam"] and CurTime() > serj.chatspamcd then 
        local cmsg = serj.chatSpam.spam[ serj.cfg.Vars["misc_chatspam_lang"]]
        local fmsg = cmsg[mrandom(#cmsg)]

        RunConsoleCommand("say",fmsg)
        serj.chatspamcd = CurTime() + serj.cfg.Vars["misc_chatspam_timer"] 
    end
	if serj.cfg.Vars["dancer"] and me:Alive() and !me:IsPlayingTaunt() and CurTime() > serj.nextact then
        serj.act = serj.acts[serj.cfg.Vars["dance"]]

		RunConsoleCommand("act", serj.act)
		serj.nextact = CurTime() + 0.3
	end
	if input.IsKeyDown(KEY_DELETE) and !menukey then
        if serj.Panels.frame then
            serj.CloseFrame()
            if serj.Panels.colorPicker != false then
                serj.Panels.colorPicker:Remove()
                serj.Panels.colorPicker = false
            end 
            if serj.Panels.adapCfg != false then
                serj.Panels.adapCfg:Remove()
                serj.Panels.adapCfg = false
            end 
            if serj.Panels.binder != false then
                serj.Panels.binder:Remove()
                serj.Panels.binder = false
            end
        else
            OpenGUI()
            RestoreCursorPosition()
        end
    end
	if serj.cfg.Vars["misc_3rdp"] then
		if serj.cfg.Keybinds["key_tp"] == 0 then 
			serj.tperson = true
		elseif ( ( ( serj.cfg.Keybinds["key_tp"] >= 107 && serj.cfg.Keybinds["key_tp"] <= 113 ) && input.IsMouseDown(serj.cfg.Keybinds["key_tp"] ) && !serj.tperson_cd || input.IsKeyDown(serj.cfg.Keybinds["key_tp"]) && !serj.tperson_cd ) ) then
			serj.tperson = !serj.tperson
			serj.tperson_cd = true
			timer.Simple(0.3, function() serj.tperson_cd = false end)
		end
	end

	menukey = input.IsKeyDown(KEY_DELETE)
end

serj.hitmarkerTable = {}
function serj.TraceAttack(ent, dmg, dir, trace)
	if(!IsFirstTimePredicted()) then return; end
    local vHitPos, vSrc;
    vHitPos = trace.HitPos;
    vSrc = trace.StartPos;
	table.insert(serj.hitmarkerTable, {vHitPos, 1})
end
serj.chamsVisible = "!flat"
serj.chamsInVisible = "!flat"


serj.chamsMaterials = {
    "!flat",
    "!textured",
    "!glowcham2",
    "!wireframe",
    "!glow_additive",
    "models/dog/eyeglass",
} 
function serj.RenderChams()
	local realanglecolor = string.ToColor(serj.cfg.Colors["real_chams"])
    local chamsVisible = serj.chamsMaterials[serj.cfg.Vars["chams_visible_mat"]] or "!flat"
    local chamsInVisible = serj.chamsMaterials[serj.cfg.Vars["chams_invisible_mat"]] or "!flat"
    local chamsRagdoll = serj.chamsMaterials[serj.cfg.Vars["chams_ragdolls_mat"]] or "!flat"

    if serj.cfg.Vars["real_chams_m"] == 1 then
        serj.rlchams = "!flat"
    elseif serj.cfg.Vars["real_chams_m"] == 2 then
        serj.rlchams = "!textured"
    elseif serj.cfg.Vars["real_chams_m"] == 3 then
        serj.rlchams = "models/shiny"
    elseif serj.cfg.Vars["real_chams_m"] == 4 then
        serj.rlchams = "models/props_combine/health_charger_glass"
    elseif serj.cfg.Vars["real_chams_m"] == 5 then
        serj.rlchams = "models/wireframe"
    end

    if chamsInVisible:StartWith("!") then
        chamsInVisible = chamsInVisible .. "_z"
    end

    

    local cf = (1/255)
    local visivleCol = string.ToColor(serj.cfg.Colors["chams_visible"])
    local invisibleCol = string.ToColor(serj.cfg.Colors["chams_invisible"])
    local ragdollCol = string.ToColor(serj.cfg.Colors["chams_ragdolls"])

    cam.Start3D()
        for k, v in ipairs(player.GetAll()) do	
            if IsValid(v) and v:Alive() and v != me then
                if serj.cfg.Vars["chams_invisible"] then
                    if !chamsInVisible:StartWith("!") then
                        cam.IgnoreZ(true)
                    end
                    render.MaterialOverride(Material(chamsInVisible))
                    render.SetColorModulation(invisibleCol.r * cf, invisibleCol.g * cf, invisibleCol.b * cf)
                    v:SetRenderMode(1)
                    --v:SetColor(Color(0,0,0,0))
                    v:DrawModel()

                    if serj.cfg.Vars["chams_invisible_att"] then
                        if IsValid(v:GetActiveWeapon()) then
                            local vv = v:GetActiveWeapon()
                            --vv:SetRenderMode(1)
                            vv:DrawModel()
                        end
                    end
                    if !chamsInVisible:StartWith("!") then
                        cam.IgnoreZ(false)
                    end
                end
                if serj.cfg.Vars["chams_visible"] then
                    render.MaterialOverride(Material(chamsVisible))
                    render.SetColorModulation( visivleCol.r * cf, visivleCol.g * cf, visivleCol.b * cf )
                    v:DrawModel()

                    if serj.cfg.Vars["chams_visible_att"] then
                        if IsValid(v:GetActiveWeapon()) then
                            local vv = v:GetActiveWeapon()
                            vv:DrawModel()
                        end
                    end
                end
            end 
            if serj.cfg.Vars["chams_ragdolls"] then 
                local ragdoll = v:GetRagdollEntity()
                if IsValid(ragdoll) then
                    render.MaterialOverride(Material(chamsRagdoll))
                    render.SetColorModulation( ragdollCol.r * cf, ragdollCol.g * cf, ragdollCol.b * cf )
                    v:SetRenderMode(1)
                    --v:SetColor(Color(0,0,0,0))
                    ragdoll:DrawModel()
                    --ragdoll:ManipulateBoneScale( 0, Vector(CurTime()*35,CurTime()*35,CurTime()*35) )
                end
            end
        end
    cam.End3D()

--[[]
	 --TODO
    cam.Start3D()
    for k, v in ipairs(player.GetAll()) do	
        if IsValid(v) and v:Alive() and v == me then
            if IsValid(v:GetActiveWeapon()) then
                local gun = v:GetActiveWeapon():GetClass()

                if serj.cfg.gunSkins[gun] then
                    render.SetColorModulation(serj.cfg.gunSkins[gun][4]/255,serj.cfg.gunSkins[gun][5]/255,serj.cfg.gunSkins[gun][6]/255)
                    render.SetBlend(serj.cfg.gunSkins[gun][7]/255)
                    render.MaterialOverride(Material(serj.cfg.gunSkins[gun][1]))
                else
                    render.SetColorModulation(1,1,1)
                    render.MaterialOverride(Material(""))
                end

                v:GetActiveWeapon():SetRenderMode(1)
                v:GetActiveWeapon():SetColor(Color(255, 255, 255, 0))
                v:GetActiveWeapon():DrawModel()
            end
        end
    end
    cam.End3D()
	

    if serj.cfg.Vars["real_chams_real"] then
        cam.Start3D()
            for k, v in ipairs(player.GetAll()) do	
                if IsValid(v) and v:Alive() and v == me then
                    render.MaterialOverride(Material(rlchams))
                    render.SetBlend(realanglecolor.a/255)
                    render.SetColorModulation(realanglecolor.r/255, realanglecolor.g/255, realanglecolor.b/255)
                    v:SetRenderMode(1)
                    v:SetColor(Color(255, 255, 255, 0))
                    v:DrawModel()
                end
            end
        cam.End3D()
    end

    if serj.cfg.Vars["chams_invisible"] then
        cam.Start3D()
            for k, v in ipairs(player.GetAll()) do	
                if IsValid(v) and v:Alive() and v != me then
                    cam.IgnoreZ(true)
                    render.SetColorModulation( invisibleCol.r * cf, invisibleCol.g * cf, invisibleCol.b * cf )
                    render.SetBlend( invisibleCol.a * cf)
                    render.MaterialOverride(Material(serj.))
                    v:SetRenderMode(1)
                    v:DrawModel()
                    if serj.cfg.Vars["chams_invisible_att"] then
                        if IsValid(v:GetActiveWeapon()) then
                            local vGun = v:GetActiveWeapon()
                            vGun:SetRenderMode(1)
                            vGun:DrawModel()
                        end
                    end
                    cam.IgnoreZ(false)
                    render.SetColorModulation(1, 1, 1)
                    render.SetBlend(1)
                    render.MaterialOverride()
                    v:DrawModel()
                    if serj.cfg.Vars["chams_invisible_att"] then
                        if IsValid(v:GetActiveWeapon()) then
                            local vGun = v:GetActiveWeapon()
                            vGun:DrawModel()
                        end
                    end
                end
            end
        cam.End3D()
    end
    if serj.cfg.Vars["chams_visible"] then
        cam.Start3D()
            for k, v in ipairs(player.GetAll()) do
                if IsValid(v) and v:Alive() and v != me then
                    render.SetColorModulation( visivleCol.r * cf, visivleCol.g * cf, visivleCol.b * cf )
                    render.SetBlend( visivleCol.a * cf)
                    render.MaterialOverride(Material(serj.chamsVisible))
                    v:SetRenderMode(1)
                    v:SetColor(Color(255, 255, 255, 0))
                    v:DrawModel()
                    
                end
            end
        cam.End3D()
    end


    ]]


    render.SetColorModulation(1, 1, 1)
    render.SetBlend(1)
    render.MaterialOverride()

    if !serj.cfg.Vars["chams_invisible"] && !serj.cfg.Vars["chams_visible"] then
		for k, v in pairs(player.GetAll()) do
			v:SetRenderMode(0)
            if !serj.cfg.Vars["chams_invisible_att"] and !serj.cfg.Vars["chams_visible_att"] then
                if IsValid(v:GetActiveWeapon()) then
                    local vGun = v:GetActiveWeapon()
                    vGun:SetRenderMode(0)
                end
            end

		end
	end
end

serj.rukient = me
hook.Add("PreDrawPlayerHands", "serj.handpre", function(hands,vm,ply,wep)
    
    local col = string.ToColor(serj.cfg.Colors["chams_hand"])
    local mat = serj.chamsMaterials[serj.cfg.Vars["chams_hand_mat"]]
    if serj.cfg.Vars["chams_hand"] then
        render.SetColorModulation(col.r/255,col.g/255,col.b/255)
        render.MaterialOverride(Material(mat))
        render.SetBlend(col.a/255)
    end	
    
end)
hook.Add("PostDrawPlayerHands", "serj.handpost", function(hands,vm,ply,wep)
    --print(vm,hands)
    if serj.cfg.Vars["chams_hand"] then
        render.SetColorModulation(1, 1, 1)
        render.MaterialOverride(Material(""))
        render.SetBlend(1)
    end
    serj.rukient = vm
end)

serj.addBulletBeam = {}
serj.addBulletImpact = {}
serj.addBulletBeamEnemy = {}
serj.addBulletImpactEnemy = {}
serj.numBulletImpacts = 0
serj.numPlayerHurts = 0
function serj.OnImpact(data)
	local bestPlayer = nil
    local bestDistance = math.huge
    for _, ply in ipairs(player.GetAll()) do
        local distance = ply:EyePos():DistToSqr(data.m_vStart)
        if distance < bestDistance then
            bestPlayer = ply
            bestDistance = distance
        end
    end

    if bestPlayer == me then
        
        serj.numBulletImpacts = serj.numBulletImpacts + 1

        table.insert(serj.addBulletBeam, {
            data.m_vStart,
            data.m_vOrigin,
            serj.cfg.Vars["misc_bullettrace_time"],
            
        })
        table.insert(serj.addBulletImpact, {
            data.m_vOrigin,
            serj.cfg.Vars["misc_bulletimpact_time"],
        })    

    end

    if bestPlayer != me then
        if serj.cfg.Vars["misc_bullettrace_onlyt"] then 
            if bestPlayer != serj.target then return end
        end
        table.insert(serj.addBulletBeamEnemy, {
            data.m_vStart,
            data.m_vOrigin,
            serj.cfg.Vars["misc_bullettrace_time_e"],     
        })
        table.insert(serj.addBulletImpactEnemy, {
            data.m_vOrigin,
            serj.cfg.Vars["misc_bulletimpact_time_e"],
        })    
    end
end
function serj.BulletBeams()
	if serj.cfg.Vars["misc_bullettrace_e"] then
        for k,v in next, serj.addBulletBeamEnemy do
            if(v[3] <= 0) then
                table.remove(serj.addBulletBeamEnemy, k);
                continue;
            end
            serj.addBulletBeamEnemy[k][3] = serj.addBulletBeamEnemy[k][3] - FrameTime();
            local pos1, pos2 = v[1], v[2]; 
            cam.Start3D();
                if serj.cfg.Vars["misc_bullettrace_blinking_e"] then
                    render.SetMaterial(Material("sprites/tp_beam001"))
                else
                    render.SetMaterial(Material("sprites/physbeama"))
                end
                if serj.cfg.Vars["misc_bullettrace_type_e"] == 1 then
                    render.DrawBeam(v[1], v[2], 4, 1, 1, string.ToColor(serj.cfg.Colors["misc_bullettrace_e"]))
                else
                    render.DrawLine( v[1], v[2] , string.ToColor(serj.cfg.Colors["misc_bullettrace_e"]) )
                end
            cam.End3D();
        end
    end
    if serj.cfg.Vars["misc_bulletimpact_e"] then
        for k,v in next, serj.addBulletImpactEnemy do
            if(v[2] <= 0) then
                table.remove(serj.addBulletImpactEnemy, k);
                continue;
            end
            serj.addBulletImpactEnemy[k][2] = serj.addBulletImpactEnemy[k][2] - FrameTime();
            local posImpact = v[1];
            cam.Start3D();
                render.SetColorMaterial()

                cam.IgnoreZ( true ) 
                    render.DrawBox( posImpact, Angle(0,0,0), Vector( 2, 2, 2 ), -Vector( 2, 2, 2 ), string.ToColor(serj.cfg.Colors["misc_bulletimpact_e"]) )
                cam.IgnoreZ( false )

                render.DrawWireframeBox( posImpact, Angle(0,0,0), Vector( 2, 2, 2 ), -Vector( 2, 2, 2 ), string.ToColor(serj.cfg.Colors["misc_bulletimpact_e"]), true )
                
                if serj.cfg.Vars["misc_bulletimpact_glow_e"] then
                    render.SetMaterial( Material("sprites/light_ignorez") )
                    render.DrawSprite( posImpact, 32, 32, string.ToColor(serj.cfg.Colors["misc_bulletimpact_e"]))
                end

            cam.End3D();
        end
    end
    -- My bullets
    if serj.cfg.Vars["misc_bullettrace"] then
        for k,v in next, serj.addBulletBeam do
            if(v[3] <= 0) then
                table.remove(serj.addBulletBeam, k);
                continue;
            end
            serj.addBulletBeam[k][3] = serj.addBulletBeam[k][3] - FrameTime();
            local pos1, pos2 = v[1], v[2]; 
            cam.Start3D();
                if serj.cfg.Vars["misc_bullettrace_blinking"] then
                    render.SetMaterial(Material("sprites/tp_beam001"))
                else
                    render.SetMaterial(Material("sprites/physbeama"))
                end
                if serj.cfg.Vars["misc_bullettrace_type"] == 1 then
                    render.DrawBeam(v[1], v[2], 4, 1, 1, string.ToColor(serj.cfg.Colors["misc_bullettrace"]))
                else
                    render.DrawLine( v[1], v[2] , string.ToColor(serj.cfg.Colors["misc_bullettrace"]) )
                end
            cam.End3D();
        end
    end
    if serj.cfg.Vars["misc_bulletimpact"] then
        for k,v in next, serj.addBulletImpact do
            if(v[2] <= 0) then
                table.remove(serj.addBulletImpact, k);
                continue;
            end
            serj.addBulletImpact[k][2] = serj.addBulletImpact[k][2] - FrameTime();
            local posImpact = v[1];
            cam.Start3D();
                render.SetColorMaterial()

                cam.IgnoreZ( true ) 
                    render.DrawBox( posImpact, Angle(0,0,0), Vector( 2, 2, 2 ), -Vector( 2, 2, 2 ), string.ToColor(serj.cfg.Colors["misc_bulletimpact"]) )
                cam.IgnoreZ( false )

                render.DrawWireframeBox( posImpact, Angle(0,0,0), Vector( 2, 2, 2 ), -Vector( 2, 2, 2 ), string.ToColor(serj.cfg.Colors["misc_bulletimpact"]), true )
                
                if serj.cfg.Vars["misc_bulletimpact_glow"] then
                    render.SetMaterial( Material("sprites/light_ignorez") )
                    render.DrawSprite( posImpact, 32, 32, string.ToColor(serj.cfg.Colors["misc_bulletimpact"]))
                end

            cam.End3D();
        end
    end
end
function serj.DisableWorldModulation()
	for k, v in pairs( Entity( 0 ):GetMaterials() ) do
   		Material( v ):SetVector( "$color", Vector(1, 1, 1) )
   		Material( v ):SetFloat( "$alpha", 1 )
	end
end
function serj.DisablePropModulation()

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

end
serj.OldWorldModState = serj.cfg.Vars["wall_color"]
serj.OldWorldModColor = serj.cfg.Colors["wall_color"]
serj.OldPropModState = serj.cfg.Vars["prop_color"]
serj.OldPropModColor = serj.cfg.Colors["prop_color"]

serj.OldShakeFunc = serj.cfg.Vars["misc_shakeoverride"]

function serj.UpdateWorldModulation()

	local col = string.ToColor(serj.cfg.Colors["wall_color"])

	for k, v in pairs( Entity( 0 ):GetMaterials() ) do
   		Material( v ):SetVector( "$color", Vector(col.r * (1 / 255), col.g * (1 / 255), col.b * (1 / 255)) )
   		Material( v ):SetFloat( "$alpha", col.a * (1 / 255) )
	end

end

function serj.UpdatePropModulation()

	local col = string.ToColor(serj.cfg.Colors["prop_color"])

	for k, v in pairs(ents.FindByClass("prop_physics")) do
		v:SetRenderMode( RENDERMODE_TRANSCOLOR )
		v:SetColor(col)
	end

    for k, v in pairs(ents.FindByClass("prop_dynamic")) do
		v:SetRenderMode( RENDERMODE_TRANSCOLOR )
		v:SetColor(col)
	end

    for k, v in pairs(ents.FindByClass("prop_static")) do
		v:SetRenderMode( RENDERMODE_TRANSCOLOR )
		v:SetColor(col)
	end

end

serj.scropeAlpha = 0
hook.Add("Think", "updater", function()
    local sckycvar = GetConVar("r_3dsky")

	if serj.OldWorldModState != serj.cfg.Vars["wall_color"] && serj.cfg.Vars["wall_color"] then
		serj.UpdateWorldModulation()
		serj.OldWorldModState = serj.cfg.Vars["wall_color"]
		serj.OldWorldModColor = serj.cfg.Colors["wall_color"]
	elseif serj.OldWorldModState != serj.cfg.Vars["wall_color"] && !serj.cfg.Vars["wall_color"] then
		serj.DisableWorldModulation()
		serj.OldWorldModState = serj.cfg.Vars["wall_color"]
		serj.OldWorldModColor = serj.cfg.Colors["wall_color"]
	end
	if serj.OldWorldModColor != serj.cfg.Colors["wall_color"] && serj.cfg.Vars["wall_color"] then
		serj.UpdateWorldModulation()
		serj.OldWorldModState = serj.cfg.Vars["wall_color"]
		serj.OldWorldModColor = serj.cfg.Colors["wall_color"]
	end
    if serj.OldShakeFunc != serj.cfg.Vars["misc_shakeoverride"] && serj.cfg.Vars["misc_shakeoverride"] then
        util.ScreenShake = function(pos,amplitude,frequency,duration,radius)
            return false
        end

		serj.OldShakeFunc = serj.cfg.Vars["misc_shakeoverride"]
	elseif serj.OldShakeFunc != serj.cfg.Vars["misc_shakeoverride"] && !serj.cfg.Vars["misc_shakeoverride"] then
        util.ScreenShake = function(pos,amplitude,frequency,duration,radius)
            local scsh = serj.screenShake( pos,amplitude,frequency,duration,radius )
            return scsh
        end

		serj.OldShakeFunc = serj.cfg.Vars["misc_shakeoverride"]
	end
    
	if serj.OldPropModState != serj.cfg.Vars["prop_color"] && serj.cfg.Vars["prop_color"] then
		serj.UpdatePropModulation()
		serj.OldPropModState = serj.cfg.Vars["prop_color"]
		serj.OldPropModColor = serj.cfg.Colors["prop_color"]
	elseif serj.OldPropModState != serj.cfg.Vars["prop_color"] && !serj.cfg.Vars["prop_color"] then
		serj.DisablePropModulation()
		serj.OldPropModState = serj.cfg.Vars["prop_color"]
		serj.OldPropModColor = serj.cfg.Colors["prop_color"]
	end
	if serj.OldPropModColor != serj.cfg.Colors["prop_color"] && serj.cfg.Vars["prop_color"] then
		serj.UpdatePropModulation()
		serj.OldPropModState = serj.cfg.Vars["prop_color"]
		serj.OldPropModColor = serj.cfg.Colors["prop_color"]
	end
	
    if (serj.cfg.Vars["sky_3d"] and sckycvar:GetBool() == true) then
        RunConsoleCommand("r_3dsky", "0")
    elseif (!serj.cfg.Vars["sky_3d"] and sckycvar:GetBool() == false) then
        RunConsoleCommand("r_3dsky", "1")
    end
    
end)
function serj.SetupWorldFog()
	if serj.cfg.Vars["fog_e"] then
		local col = string.ToColor(serj.cfg.Colors["fog_e"])

		render.FogMode( MATERIAL_FOG_LINEAR )
		render.FogStart(serj.cfg.Vars["fog_s"])
		render.FogEnd(serj.cfg.Vars["fog_end"])
		render.FogMaxDensity(serj.cfg.Vars["fog_d"])
		render.FogColor(col.r, col.g, col.b)

		return true
	end
end
function serj.SetupSkyboxFog(skyboxscale)
	if serj.cfg.Vars["fog_e"] then

		local col = string.ToColor(serj.cfg.Colors["fog_e"])

		render.FogMode( MATERIAL_FOG_LINEAR )
		render.FogStart(serj.cfg.Vars["fog_s"] * skyboxscale)
		render.FogEnd(serj.cfg.Vars["fog_end"] * skyboxscale)
		render.FogMaxDensity(serj.cfg.Vars["fog_d"])
		render.FogColor(col.r, col.g, col.b)

		return true
	end
end
serj.SourceSkyname = GetConVar("sv_skyname"):GetString()
serj.origsky = serj.SourceSkyname
serj.SourceSkyPre = {"lf", "ft", "rt", "bk", "dn", "up"}
serj.SourceSkyMat = {
    Material("skybox/".. serj.SourceSkyname.. "lf"),
    Material("skybox/".. serj.SourceSkyname.. "ft"),
    Material("skybox/".. serj.SourceSkyname.. "rt"),
    Material("skybox/".. serj.SourceSkyname.. "bk"),
    Material("skybox/".. serj.SourceSkyname.. "dn"),
    Material("skybox/".. serj.SourceSkyname.. "up")
}
function serj.ChangeSkybox(skyboxname)
    for i = 1, 6 do
        D = Material("skybox/".. skyboxname.. serj.SourceSkyPre[i]):GetTexture("$basetexture")
        serj.SourceSkyMat[i]:SetTexture("$basetexture", D)
    end
end
function serj.ChangeSkyColor(reset)
    local col = string.ToColor(serj.cfg.Colors["sky_c"])
    for i = 1, 6 do
        if !reset then
            serj.SourceSkyMat[i]:SetVector( "$color", Vector(col.r * (1 / 255), col.g * (1 / 255), col.b * (1 / 255)) )
        else
            serj.SourceSkyMat[i]:SetVector( "$color", Vector(1,1,1) )
        end
    end
end
function serj.RenderScene()
	if serj.cfg.Vars["sky_ch"] then
        if serj.cfg.Vars["skyboxname"] != nil then
            serj.ChangeSkybox(serj.cfg.Vars["skyboxname"])
        else
            serj.ChangeSkybox(serj.origsky)
        end
    end
    if serj.cfg.Vars["sky_c"] then
        serj.ChangeSkyColor()
    else
        serj.ChangeSkyColor(true)
    end
    if serj.cfg.Vars["orange"] then
        for k, v in pairs( Entity( 0 ):GetMaterials() ) do
            Material( v ):SetTexture("$basetexture", "pivokvasovo/obeme")
        end
    end
end
serj.LightingModeChanged = false
function serj.penisRender()
	if serj.cfg.Vars["fullbright"] then
		render.SetLightingMode( 1 )
		serj.LightingModeChanged = true
	end
end
function serj.EndOfLightingMod()
	if serj.LightingModeChanged then
		render.SetLightingMode( 0 )
		serj.LightingModeChanged = false
	end
end



function serj.GetENTPos ( Ent )
	if Ent:IsValid() then 
		local Points = {
			Vector( Ent:OBBMaxs().x, Ent:OBBMaxs().y, Ent:OBBMaxs().z ),
			Vector( Ent:OBBMaxs().x, Ent:OBBMaxs().y, Ent:OBBMins().z ),
			Vector( Ent:OBBMaxs().x, Ent:OBBMins().y, Ent:OBBMins().z ),
			Vector( Ent:OBBMaxs().x, Ent:OBBMins().y, Ent:OBBMaxs().z ),
			Vector( Ent:OBBMins().x, Ent:OBBMins().y, Ent:OBBMins().z ),
			Vector( Ent:OBBMins().x, Ent:OBBMins().y, Ent:OBBMaxs().z ),
			Vector( Ent:OBBMins().x, Ent:OBBMaxs().y, Ent:OBBMins().z ),
			Vector( Ent:OBBMins().x, Ent:OBBMaxs().y, Ent:OBBMaxs().z )
		}
		local MaxX, MaxY, MinX, MinY
		local V1, V2, V3, V4, V5, V6, V7, V8
		local isVis
		for k, v in pairs( Points ) do
			local ScreenPos = Ent:LocalToWorld( v ):ToScreen()
			isVis = ScreenPos.visible
			if MaxX != nil then
				MaxX, MaxY, MinX, MinY = mmax( MaxX, ScreenPos.x ), mmax( MaxY, ScreenPos.y), mmin( MinX, ScreenPos.x ), mmin( MinY, ScreenPos.y)
			else
				MaxX, MaxY, MinX, MinY = ScreenPos.x, ScreenPos.y, ScreenPos.x, ScreenPos.y
			end

			if V1 == nil then
				V1 = ScreenPos
			elseif V2 == nil then
				V2 = ScreenPos
			elseif V3 == nil then
				V3 = ScreenPos
			elseif V4 == nil then
				V4 = ScreenPos
			elseif V5 == nil then
				V5 = ScreenPos
			elseif V6 == nil then
				V6 = ScreenPos
			elseif V7 == nil then
				V7 = ScreenPos
			elseif V8 == nil then
				V8 = ScreenPos
			end
		end
		return MaxX, MaxY, MinX, MinY, V1, V2, V3, V4, V5, V6, V7, V8, isVis
	end
end
function serj.drawPlayerBox(ply)

    local hsvtocolor = HSVToColor( ( CurTime() * 50 ) % 360, 1, 1 )
    local teamcol = team.GetColor( ply:Team() )
    local boxcolor = string.ToColor(serj.cfg.Colors["esp_box"])
    local frcol = string.ToColor(serj.cfg.Colors["esp_box_fr"])
    local gradcolor, fillcolor = string.ToColor(serj.cfg.Colors["esp_box_grad"]), string.ToColor(serj.cfg.Colors["esp_box_f"])
    if serj.cfg.Vars["esp_box_team"] then
        boxcolor = teamcol
        gradcolor = Color(teamcol.r,teamcol.g,teamcol.b,gradcolor.a)
        fillcolor = Color(teamcol.r,teamcol.g,teamcol.b,fillcolor.a)
    else
        boxcolor = string.ToColor(serj.cfg.Colors["esp_box"])
        gradcolor = string.ToColor(serj.cfg.Colors["esp_box_grad"])
        fillcolor = string.ToColor(serj.cfg.Colors["esp_box_f"])
    end

    if serj.cfg.Vars["esp_box_grad_r"] then 
        gradcolor = Color(hsvtocolor.r,hsvtocolor.g,hsvtocolor.b,gradcolor.a)
    end
    if serj.cfg.Vars["esp_box_f_r"] then 
        fillcolor = Color(hsvtocolor.r,hsvtocolor.g,hsvtocolor.b,fillcolor.a)
    end


    local boxcolortar = string.ToColor(serj.cfg.Colors["esp_box_trg"])
    
    local MaxX, MaxY, MinX, MinY, V1, V2, V3, V4, V5, V6, V7, V8, isVis = serj.GetENTPos( ply )

    local XLen, YLen = MaxX - MinX, MaxY - MinY
    
    if serj.cfg.Vars["esp_box_f"] then
        draw.RoundedBox(0,MinX,MinY,XLen,YLen,Color(fillcolor.r,fillcolor.g,fillcolor.b,fillcolor.a))
    end

    if serj.cfg.Vars["esp_box_grad"] then
        serj.surfaceTexture(MinX,MinY,XLen,YLen,"gui/gradient_up",gradcolor)
    end

    if serj.cfg.Vars["esp_box_trg"] and serj.target != nil and ply == serj.target then
        surfaceSetDrawColor(boxcolortar.r,boxcolortar.g,boxcolortar.b)  
    elseif serj.cfg.Vars["esp_box_r"] then
        surfaceSetDrawColor(hsvtocolor.r,hsvtocolor.g,hsvtocolor.b)
    else
        surfaceSetDrawColor(boxcolor.r,boxcolor.g,boxcolor.b)
    end

    if serj.cfg.Vars["esp_box_type"] == 1 then
        surfaceDrawOutlinedRect(MinX,MinY,XLen,YLen,1)
    elseif serj.cfg.Vars["esp_box_type"] == 2 then    
        surfaceDrawLine( MaxX, MaxY, MinX + XLen * 0.7, MaxY)
        surfaceDrawLine( MinX, MaxY, MinX + XLen * 0.3, MaxY)
        surfaceDrawLine( MaxX, MaxY, MaxX, MinY + YLen * 0.75)
        surfaceDrawLine( MaxX, MinY, MaxX, MinY + YLen * 0.25)
        surfaceDrawLine( MinX, MinY, MaxX - XLen * 0.7, MinY )
        surfaceDrawLine( MaxX, MinY, MaxX - XLen * 0.3, MinY )
        surfaceDrawLine( MinX, MinY, MinX, MaxY - YLen * 0.75)
        surfaceDrawLine( MinX, MaxY, MinX, MaxY - YLen * 0.25)
    elseif serj.cfg.Vars["esp_box_type"] == 4 then 
        surfaceSetDrawColor(0,0,0)
        surfaceDrawOutlinedRect(MinX,MinY,XLen,YLen,3)

        if serj.cfg.Vars["esp_box_fr"] and table.HasValue(serj.cfg["friends"], ply:SteamID()) then
            surfaceSetDrawColor(frcol.r,frcol.g,frcol.b,frcol.a)  
        elseif serj.cfg.Vars["esp_box_trg"] and serj.target != nil and ply == serj.target then
            surfaceSetDrawColor(boxcolortar.r,boxcolortar.g,boxcolortar.b)  
        elseif serj.cfg.Vars["esp_box_r"] then
            surfaceSetDrawColor(hsvtocolor.r,hsvtocolor.g,hsvtocolor.b)
        else
            surfaceSetDrawColor(boxcolor.r,boxcolor.g,boxcolor.b)
        end
        surfaceDrawOutlinedRect(MinX+1,MinY+1,XLen-2,YLen-2,1)
    end

end
function serj.drawESPText(text,color,x,y)
    surfaceSetTextColor( color.r, color.g, color.b, color.a or 255 )
	surfaceSetTextPos( x, y ) 
	surfaceSetFont( "ESP Font" )
	surfaceDrawText( text ) 
end
serj.bones = {
	{ S = "ValveBiped.Bip01_Head1", E = "ValveBiped.Bip01_Neck1" },
	{ S = "ValveBiped.Bip01_Neck1", E = "ValveBiped.Bip01_Spine4" },
	{ S = "ValveBiped.Bip01_Spine4", E = "ValveBiped.Bip01_Spine2" },
	{ S = "ValveBiped.Bip01_Spine2", E = "ValveBiped.Bip01_Spine1" },
	{ S = "ValveBiped.Bip01_Spine1", E = "ValveBiped.Bip01_Spine" },
	{ S = "ValveBiped.Bip01_Spine", E = "ValveBiped.Bip01_Pelvis" },
	{ S = "ValveBiped.Bip01_Spine2", E = "ValveBiped.Bip01_L_UpperArm" },
	{ S = "ValveBiped.Bip01_L_UpperArm", E = "ValveBiped.Bip01_L_Forearm" },
	{ S = "ValveBiped.Bip01_L_Forearm", E = "ValveBiped.Bip01_L_Hand" },
	{ S = "ValveBiped.Bip01_Spine2", E = "ValveBiped.Bip01_R_UpperArm" },
	{ S = "ValveBiped.Bip01_R_UpperArm", E = "ValveBiped.Bip01_R_Forearm" },
	{ S = "ValveBiped.Bip01_R_Forearm", E = "ValveBiped.Bip01_R_Hand" },
	{ S = "ValveBiped.Bip01_Pelvis", E = "ValveBiped.Bip01_L_Thigh" },
	{ S = "ValveBiped.Bip01_L_Thigh", E = "ValveBiped.Bip01_L_Calf" },
	{ S = "ValveBiped.Bip01_L_Calf", E = "ValveBiped.Bip01_L_Foot" },
	{ S = "ValveBiped.Bip01_L_Foot", E = "ValveBiped.Bip01_L_Toe0" },
	{ S = "ValveBiped.Bip01_Pelvis", E = "ValveBiped.Bip01_R_Thigh" },
	{ S = "ValveBiped.Bip01_R_Thigh", E = "ValveBiped.Bip01_R_Calf" },
	{ S = "ValveBiped.Bip01_R_Calf", E = "ValveBiped.Bip01_R_Foot" },
	{ S = "ValveBiped.Bip01_R_Foot", E = "ValveBiped.Bip01_R_Toe0" },
}
function serj.PlayerESP()
    local nameColor = string.ToColor(serj.cfg.Colors["esp_name"])
    local weaponColor = string.ToColor(serj.cfg.Colors["esp_wep"])
    local healthColor = string.ToColor(serj.cfg.Colors["esp_hp"])
    local armorColor = string.ToColor(serj.cfg.Colors["esp_ap"])
    local groupcol = string.ToColor(serj.cfg.Colors["esp_group"])
    local mcol = string.ToColor(serj.cfg.Colors["esp_money"])
    local healthbarColor = string.ToColor(serj.cfg.Colors["esp_hp_bar"])
    local healthbarColor2 = string.ToColor(serj.cfg.Colors["esp_hp_bar_gradient"])

    for balls, gamer in pairs(player.GetAll()) do
        if IsValid(gamer) then       
            local MaxX, MaxY, MinX, MinY, V1, V2, V3, V4, V5, V6, V7, V8, isVis = serj.GetENTPos( gamer )
            local XLen, YLen = MaxX - MinX, MaxY - MinY
            surfaceSetFont("ESP Font")
            
            gamer.DormantAlpha = gamer.DormantAlpha or 255
            if gamer:IsDormant() then
                gamer.DormantAlpha = math.Approach(gamer.DormantAlpha,85,FrameTime()*200)
            else
                gamer.DormantAlpha = math.Approach(gamer.DormantAlpha,255,FrameTime()*200)
            end

            if gamer != me and gamer:Alive() then
                surface.SetAlphaMultiplier(gamer.DormantAlpha/255)

                -- esp elements
                if serj.cfg.Vars["esp_box"] then
                    if serj.cfg.Vars["esp_box_type"] != 3 then
                        serj.drawPlayerBox(gamer)
                    else
                        cam.Start3D()
                            render.DrawWireframeBox( gamer:GetPos(), Angle(0, 0, 0), gamer:OBBMins(), gamer:OBBMaxs(), string.ToColor(serj.cfg.Colors["esp_box"]), true )
                        cam.End3D()
                    end
                end

                

                if serj.cfg.Vars["esp_skeleton"] then
                    surfaceSetDrawColor( string.ToColor(serj.cfg.Colors["esp_skeleton"]) )
                    for _, b in pairs( serj.bones ) do
                        if gamer:LookupBone(b.S) != nil && gamer:LookupBone(b.E) != nil then
                            local spos, epos = gamer:GetBonePosition(gamer:LookupBone(b.S)):ToScreen(), gamer:GetBonePosition(gamer:LookupBone(b.E)):ToScreen()
                            if spos.visible && epos.visible then
                                surfaceDrawLine( spos.x, spos.y, epos.x, epos.y )
                            end
                        end
                    end
                end
                if serj.cfg.Vars["esp_name"] then
                    local namelenx,nameleny = surfaceGetTextSize(serj.antidalbaeb(gamer:Name(), 32))
                    serj.drawESPText(serj.antidalbaeb(gamer:Name(), 32),nameColor,MinX+XLen/2-namelenx/2,MinY-nameleny)
                    
                    if serj.cfg.Vars["esp_mambet"] then
                        local sid = gamer:SteamID()
                        local cheaterTag = sid and sid != "" and serj.trackedCheaters[sid]
                        if cheaterTag then
                            local tagW, tagH = surfaceGetTextSize(cheaterTag)
                            serj.drawESPText(cheaterTag, Color(255, 50, 50), MinX + XLen/2 - tagW/2, MinY - nameleny - tagH + 2)
                        end
                    end
                end
                /*
                -- TODO
                serj.guiCheckBox("Money","esp_money",playerespan,true)

                */
                if serj.cfg.Vars["esp_team"] then
                    local col = team.GetColor(gamer:Team())
                    local teamx,teamy = surfaceGetTextSize(team.GetName(gamer:Team()))
                    serj.drawESPText(team.GetName(gamer:Team()),col,MinX+XLen/2-teamx/2,MinY-teamy*2+4)
                end


                if serj.cfg.Vars["esp_wep"] and serj.cfg.Vars["esp_active_weapon"] then
                    if IsValid(gamer:GetActiveWeapon()) then
                        local activeWep = gamer:GetActiveWeapon()
                        local wepName = serj.GetWeaponPrintName(activeWep)
                        local wepClass = activeWep:GetClass()
                        local activeColor = string.ToColor(serj.cfg.Colors["esp_active_weapon"])
                        
                        -- Перенесенный функционал из 1tick.lua
                        local name = wepName
                        if IsValid(activeWep) then
                            local ammo = activeWep:Clip1()
                            if ammo != -1 then
                                name = name .. " (" .. ammo .. ")"
                            end

                            -- Проверка на перезарядку
                            for i = 0, 13 do
                                if gamer:IsValidLayer(i) then
                                    local seq = gamer:GetLayerSequence(i)
                                    if seq != -1 then
                                        local seqName = gamer:GetSequenceActivityName(seq)
                                        if seqName:find("RELOAD") then
                                            name = "RELOADING"
                                            break
                                        end
                                    end
                                end
                            end
                        end

                        if serj.cfg.Vars["esp_active_mode"] == 2 then
                            local icon = "entities/" .. wepClass .. ".png"
                            surface.SetDrawColor(255, 255, 255, 255)
                            surface.SetMaterial(Material(icon))
                            surface.DrawTexturedRect(MinX + XLen/2 - 16, MaxY, 32, 32)
                        else
                            local weplenx, wepleny = surfaceGetTextSize(name)
                            serj.drawESPText(name, activeColor, MinX + XLen/2 - weplenx/2, MaxY)
                        end
                    end
                end

                if serj.cfg.Vars["esp_hotbar"] then
                    local beltY = MaxY + (serj.cfg.Vars["esp_active_mode"] == 2 and 35 or 15)
                    local weps = gamer:GetWeapons()
                    local activeWep = gamer:GetActiveWeapon()

                    for k, wep in pairs(weps) do
                        if IsValid(wep) then
                            local wepName = wep:GetPrintName()
                            local isSelected = (wep == activeWep)
                            
                            local textColor = isSelected and Color(0, 255, 0, 255) or color_white
                            local tw, th = surfaceGetTextSize(wepName)
                            serj.drawESPText(wepName, textColor, MinX + XLen/2 - tw/2, beltY + (k * th))
                        end
                    end
                end

                if serj.cfg.Vars["esp_group"] then
                    local w,h = surfaceGetTextSize(gamer:GetUserGroup())
                    serj.drawESPText(gamer:GetUserGroup(),groupcol,MinX+XLen/2-w/2,MaxY+h-4)
                end

                if serj.cfg.Vars["esp_hp"] then   
                    local hplenx,hpleny = surfaceGetTextSize(gamer:Health())

                    serj.drawESPText(gamer:Health(),healthColor,MinX-hplenx-6,MinY)

                end
                if serj.cfg.Vars["esp_ap"] then
                    local aplenx,apleny = surfaceGetTextSize(gamer:Armor())
                    serj.drawESPText(gamer:Armor(),armorColor,MaxX+2,MinY)
                end

                -- bars
                if serj.cfg.Vars["esp_hp_bar"] then
                    local hp = gamer:Health() * YLen / 100;
                    if(hp > YLen) then hp = YLen; end
                    local diff = YLen - hp

                    surfaceSetDrawColor(0, 0, 0, 255);
                    surfaceDrawRect(MinX - 5, MinY, 4, YLen);
                    if serj.cfg.Vars["esp_hp_bar_ac"] then
                        surfaceSetDrawColor( ( 100 - gamer:Health() ) * 2.55, gamer:Health() * 2.55, 0, 255)
                    else
                        surfaceSetDrawColor(healthbarColor.r,healthbarColor.g,healthbarColor.b)
                    end
                    surfaceDrawRect(MinX - 4, MinY + diff+1, 2, hp-2);
                    if serj.cfg.Vars["esp_hp_bar_gradient"] then
                        serj.surfaceTexture(MinX - 4, MinY + diff+1, 2, hp-2,"gui/gradient_up",healthbarColor2)
                    end
                end

            end
        end
    end
    surface.SetAlphaMultiplier(255)
    
    local function DrawEntity2DBox(ent, color)
        local MaxX, MaxY, MinX, MinY, V1, V2, V3, V4, V5, V6, V7, V8, isVis = serj.GetENTPos(ent)
        if not isVis then return false end
        local XLen, YLen = MaxX - MinX, MaxY - MinY

        surfaceSetDrawColor(0, 0, 0, 255)
        surfaceDrawOutlinedRect(MinX - 1, MinY - 1, XLen + 2, YLen + 2)
        surfaceDrawOutlinedRect(MinX + 1, MinY + 1, XLen - 2, YLen - 2)

        surfaceSetDrawColor(color.r, color.g, color.b, 255)
        surfaceDrawOutlinedRect(MinX, MinY, XLen, YLen)
        
        return true, MinX, MinY, XLen, YLen
    end

    local function GetEntHP(ent)
        if not IsValid(ent) then return nil, nil end

        local hp
        if ent.Health then
            local ok, v = pcall(ent.Health, ent)
            if ok and isnumber(v) and v > 0 then
                hp = v
            end
        end

        if hp == nil then
            local keys = {"Health", "health", "HP", "hp"}
            for _, k in ipairs(keys) do
                local v = ent:GetNWFloat(k, ent:GetNWInt(k, -1))
                if isnumber(v) and v >= 0 then
                    hp = v
                    break
                end
            end
        end

        local maxHp
        local maxKeys = {"MaxHealth", "maxhealth", "MaxHP", "maxhp"}
        for _, k in ipairs(maxKeys) do
            local v = ent:GetNWFloat(k, ent:GetNWInt(k, -1))
            if isnumber(v) and v > 0 then
                maxHp = v
                break
            end
        end

        return hp, maxHp
    end

    if serj.cfg.Vars["oreesp"] then
        for k, v in pairs(ents.FindByClass("rust_ore")) do
            if not IsValid(v) then continue end
            
            local skin = v:GetSkin()
            local oreName = ""
            local oreColor = Color(255, 255, 255, 255)
            local shouldDraw = false
            
            if skin == 0 and serj.cfg.Vars["stone"] then
                oreName = "Stone"
                oreColor = string.ToColor(serj.cfg.Vars["stonecolor"])
                shouldDraw = true
            elseif skin == 1 and serj.cfg.Vars["metal"] then
                oreName = "Metal"
                oreColor = string.ToColor(serj.cfg.Vars["metalcolor"])
                shouldDraw = true
            elseif skin == 2 and serj.cfg.Vars["showsulfur"] then
                oreName = "Sulfur"
                oreColor = string.ToColor(serj.cfg.Vars["sulfurcolor"])
                shouldDraw = true
            end
            
            if shouldDraw then
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, oreColor)
                if drawn then
                    local textx, texty = surfaceGetTextSize(oreName)
                    draw.SimpleText(oreName, "ESP Font", EX + EW/2 - textx/2, EY - texty, oreColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end
    
    if serj.cfg.Vars["cupboardesp"] then
        for k, v in pairs(ents.FindByClass("rust_toolcupboard")) do
            if IsValid(v) then
                local color = string.ToColor(serj.cfg.Vars["cupboardcolor"])
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local textx, texty = surfaceGetTextSize("Шкаф")
                    draw.SimpleText(("Шкаф"), "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end
    
    if serj.cfg.Vars["sleepingbagesp"] then
        for k, v in pairs(ents.FindByClass("rust_sleepingbag")) do
            if IsValid(v) then
                local bagName = "Unknown"
                if v.GetBagName then bagName = v:GetBagName() end
                local color = string.ToColor(serj.cfg.Vars["sleepingbagcolor"])
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local textx, texty = surfaceGetTextSize(tostring(bagName) .. " - Спалка")
                    draw.SimpleText(tostring(bagName) .. " - Спалка", "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end
    
    if serj.cfg.Vars["turretesp"] then
        for k, v in pairs(ents.FindByClass("rust_turret")) do
            if IsValid(v) then
                local color = string.ToColor(serj.cfg.Vars["turretcolor"])
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local textx, texty = surfaceGetTextSize("Турель")
                    draw.SimpleText("Турель", "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end

                local pos = v:GetPos() + Vector(0, 0, 30)
                local ang = v:GetAngles()
                if v.Rotation then
                    ang = ang + v.Rotation
                end
                
                local forward = ang:Forward()
                local endPos = pos + forward * 300

                cam.Start3D()
                    cam.IgnoreZ(true)
                    render.SetColorMaterial()
                    
                    render.DrawLine(pos + Vector(0.1, 0.1, 0.1), endPos + Vector(0.1, 0.1, 0.1), Color(0,0,0,color.a), false)
                    render.DrawLine(pos - Vector(0.1, 0.1, 0.1), endPos - Vector(0.1, 0.1, 0.1), Color(0,0,0,color.a), false)
                    
                    render.DrawLine(pos, endPos, color, false)
                    cam.IgnoreZ(false)
                cam.End3D()
            end
        end
    end

    if serj.cfg.Vars["structureesp"] then
        for k, v in pairs(ents.FindByClass("rust_structure")) do
            if IsValid(v) then
                local color = string.ToColor(serj.cfg.Vars["structurecolor"])
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local hp, maxHp = GetEntHP(v)
                    local text = "Structure"
                    if isnumber(hp) then
                        if isnumber(maxHp) then
                            text = text .. " [" .. math.floor(hp) .. "/" .. math.floor(maxHp) .. "]"
                        else
                            text = text .. " [" .. math.floor(hp) .. "]"
                        end
                    end
                    local textx, texty = surfaceGetTextSize(text)
                    draw.SimpleText(text, "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end

    if serj.cfg.Vars["dooresp"] then
        for k, v in pairs(ents.FindByClass("rust_door")) do
            if IsValid(v) then
                local color = string.ToColor(serj.cfg.Vars["doorcolor"])
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local hp, maxHp = GetEntHP(v)
                    local text = "Door"
                    if isnumber(hp) then
                        if isnumber(maxHp) then
                            text = text .. " [" .. math.floor(hp) .. "/" .. math.floor(maxHp) .. "]"
                        else
                            text = text .. " [" .. math.floor(hp) .. "]"
                        end
                    end
                    local textx, texty = surfaceGetTextSize(text)
                    draw.SimpleText(text, "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end

    if serj.cfg.Vars["hempesp"] then
        for k, v in pairs(ents.FindByClass("rust_hemp")) do
            if IsValid(v) then
                local color = string.ToColor(serj.cfg.Vars["hempcolor"])
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local textx, texty = surfaceGetTextSize("Конопля")
                    draw.SimpleText("Конопля", "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end

    if serj.cfg.Vars["barrelesp"] then
        for k, v in pairs(ents.FindByClass("rust_barrel")) do
            if IsValid(v) then
                local color = string.ToColor(serj.cfg.Vars["barrelcolor"])
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local textx, texty = surfaceGetTextSize("Бочка")
                    draw.SimpleText("Бочка", "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end

    if serj.cfg.Vars["largewoodboxesp"] then
        for k, v in pairs(ents.FindByClass("rust_largewoodbox")) do
            if IsValid(v) then
                local color = string.ToColor(serj.cfg.Vars["largewoodboxcolor"])
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local textx, texty = surfaceGetTextSize("Сундук")
                    draw.SimpleText("Сундук", "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end

    if serj.cfg.Vars["landmineesp"] then
        for k, v in pairs(ents.FindByClass("rust_landmine")) do
            if IsValid(v) then
                local color = Color(255, 0, 0, 255)
                local drawn, EX, EY, EW, EH = DrawEntity2DBox(v, color)
                if drawn then
                    local text = "МИНА НАХУЙ!!!"
                    local textx, texty = surfaceGetTextSize(text)
                    draw.SimpleText(text, "ESP Font", EX + EW/2 - textx/2, EY - texty, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
            end
        end
    end

    if serj.cfg.Vars["entityinfo"] then
        local trace = me:GetEyeTrace()
        local ent = trace.Entity
        if IsValid(ent) and me:GetPos():Distance(ent:GetPos()) < 1000 then
            draw.SimpleText("" .. ent:GetClass(), "ESP Font", scrw / 2, scrh / 2 + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    end
end


function serj.OOfarrows()
	RotatedArrow = function(x, y, ang)
		local ang1 = Angle(0, ang, 0):Forward() * serj.cfg.Vars["oof_arrows_as"]
		local ang2 = Angle(0, ang + 120, 0):Forward() * (serj.cfg.Vars["oof_arrows_as"] - 1)
		local ang3 = Angle(0, ang - 120, 0):Forward() * (serj.cfg.Vars["oof_arrows_as"] - 1)
	
		local p0 = {x = x, y = y}
		local poly = {
			{x = p0.x + ang1.x, y = p0.y + ang1.y},
			{x = p0.x + ang2.x, y = p0.y + ang2.y},
			{x = p0.x + ang3.x, y = p0.y + ang3.y},
		}
		return poly
	end

	if serj.cfg.Vars["oof_arrows"] then
		
		local myTeam = me:Team()
		local eye = me:EyePos()
	
		local lcolor = string.ToColor(serj.cfg.Colors["oof_arrows"])
		local clr0, dormClr = Color(lcolor.r,lcolor.g,lcolor.b,lcolor.a/2), string.ToColor(serj.cfg.Colors["oof_arrows_d"])
		local clr1 = lcolor, string.ToColor(serj.cfg.Colors["oof_arrows_d"])  

		local xScale, yScale = ScrW() / 250, ScrH() / 250
		local xScale, yScale = xScale * serj.cfg.Vars["oof_arrows_ad"], yScale * serj.cfg.Vars["oof_arrows_ad"]
	
		for k,plr in ipairs(player.GetAll()) do
			if(!plr || plr == me || !plr:Alive()) then continue end

			local angle = (plr:EyePos() - eye):Angle()
			local addPos = Angle(0, (serj.fa.y - angle.y) - 90, 0):Forward()
			
			local pos = Vector(ScrW() / 2, ScrH() / 2, 0) + Vector(addPos.x * xScale, addPos.y * yScale, 0)
	
			if(mabs(mNormalizeAng(angle.y - serj.fa.y)) < 60) then return end

			// ARROW
	
			local arrow = RotatedArrow(pos.x, pos.y, (serj.fa.y - angle.y) - 90)
			
            if serj.cfg.Vars["oof_arrows_d"] then
                if plr:IsDormant() then
			        surfaceSetDrawColor(dormClr)
                else
                    if serj.cfg.Vars["oof_arrows_b"] then
                        surfaceSetDrawColor(clr0.r,clr0.g,mfloor( msin( CurTime() * serj.cfg.Vars["oof_arrows_bs"] + plr:EntIndex() ) * 20 ) + 65)
                    else
                        surfaceSetDrawColor(clr0)
                    end
                end
            else
                if serj.cfg.Vars["oof_arrows_b"] then
                    surfaceSetDrawColor(clr0.r,clr0.g,clr0.b,mfloor( msin( CurTime() * serj.cfg.Vars["oof_arrows_bs"] + plr:EntIndex() ) * 20 ) + 65)
                else
                    surfaceSetDrawColor(clr0)
                end
            end

			draw.NoTexture()
			surface.DrawPoly(arrow)
	
            if serj.cfg.Vars["oof_arrows_d"] then
                if plr:IsDormant() then
			        surfaceSetDrawColor(dormClr)
                else
                    if serj.cfg.Vars["oof_arrows_b"] then
                        surfaceSetDrawColor(clr1.r,clr1.g,clr1.b,mfloor( msin( CurTime() * serj.cfg.Vars["oof_arrows_bs"] + plr:EntIndex() ) * 20 ) + 65)
                    else
                        surfaceSetDrawColor(clr1)
                    end
                end
            else
                if serj.cfg.Vars["oof_arrows_b"] then
                    surfaceSetDrawColor(clr1.r,clr1.g,clr1.b,mfloor( msin( CurTime() * serj.cfg.Vars["oof_arrows_bs"] + plr:EntIndex() ) * 20 ) + 65)
                else
                    surfaceSetDrawColor(clr1)
                end
            end
		end
	end
end
serj.estscope = {
    ["weapon_csgo_snip_ssg08"] = true,
    ["weapon_csgo_snip_awp"] = true,
    ["weapon_csgo_snip_g3sg1"] = true,
    ["weapon_csgo_snip_scar20"] = true,
}

function serj.KColors(bb)
    if bb == 1 then
        fcolor = Color(255,255,255)
    elseif bb == 2 then
        fcolor = Color(110,255,231)
    elseif bb == 3 then
        fcolor = Color(255,162,75)
    elseif bb == 4 then
        fcolor = Color(255,77,77)
    elseif bb == 5 then
        fcolor = Color(162,104,255)
    elseif bb == 6 then
        fcolor = Color(255,88,180)
    end
    return fcolor
end

serj.targethudy = 0
serj.targethudx = 0
serj.targeta = 0
serj.targethp = 0
serj.targetap = 0
function serj.drawKeybinds() 
    local bindx, bindy =  serj.cfg.Vars["i_keybinds_x"], serj.cfg.Vars["i_keybinds_y"]
    local thx, thy =  serj.cfg.Vars["i_targethud_x"], serj.cfg.Vars["i_targethud_y"]
    local hsv = HSVToColor( ( CurTime() * 50 ) % 360, 1, 1 )
    local hsv2 = HSVToColor( ( CurTime() * 50 ) % 360, 1, 1 )
    local keybindcolor = string.ToColor(serj.cfg.Colors["i_keybinds"]) 
    local wmarkcolor = string.ToColor(serj.cfg.Colors["i_watermark"]) 

    local wmstring = "ПОШЕЛ НАХУЙ ЗОМБЕТЫ 5 СЕРИЯ 1 СЕЗОН СИБАЛСЯ Э НА | " .. serj.antidalbaeb(me:Name(), 32) .. " | delay: " .. me:Ping() .. "ms | " .. os.date( "%X")
    surfaceSetFont("IndicatorFont")
    local wamrkw, wmarkh = surfaceGetTextSize(wmstring)
    
    local wmarkpos = scrw - wamrkw - 20

    if serj.cfg.Vars["i_watermark"] then
        if serj.cfg.Vars["i_f"] == 1 then   
            draw.RoundedBox(0,wmarkpos+5,5,wamrkw+10,25,Color(25, 25, 25))
            -- serj.surfaceTexture(wmarkpos+5,5,wamrkw+10,4,"gradient.png",color_white)
            surfaceSetDrawColor(0, 0, 0, 255)
            surfaceDrawOutlinedRect(wmarkpos+5, 5, wamrkw+10, 25, 1)
            surfaceSetDrawColor(255, 165, 0)
            surfaceDrawRect(wmarkpos+5, 5, wamrkw+10, 2)
            draw.SimpleText(wmstring,"IndicatorFont",wmarkpos+10,9,color_white)
        elseif serj.cfg.Vars["i_f"] == 2 then
            draw.RoundedBox(3,wmarkpos+5,5,wamrkw+10,25,Color(25, 25, 25))
            draw.RoundedBox(10,wmarkpos+7,6,wamrkw+6,2,hsv)
            serj.surfaceTexture(wmarkpos+7,6,wamrkw+6,2,"gui/center_gradient",Color(255,255,255,66))
            draw.SimpleText(wmstring,"IndicatorFont",wmarkpos+10,9,color_white)
        elseif serj.cfg.Vars["i_f"] == 3 then
            draw.RoundedBox(0,wmarkpos+5,5,wamrkw+10,25,Color(25, 25, 25, 200))
            draw.RoundedBox(0,wmarkpos+5,5,wamrkw+10,2,wmarkcolor)
            serj.surfaceTexture(wmarkpos+5,5,wamrkw+10,2,"gui/center_gradient",Color(255,255,255,66))
            draw.SimpleText(wmstring,"IndicatorFont",wmarkpos+10,9,color_white)
        elseif serj.cfg.Vars["i_f"] == 4 then
            draw.RoundedBox(0,wmarkpos+5,5,wamrkw+10,25,Color(25, 25, 25))
            surfaceSetDrawColor(wmarkcolor)
            surfaceDrawRect(wmarkpos+6,6,wamrkw+8,1)
            serj.surfaceTexture(wmarkpos+6,7,1,21,"gui/gradient_down",wmarkcolor)
            serj.surfaceTexture(wmarkpos+wamrkw+13,7,1,21,"gui/gradient_down",wmarkcolor)
            draw.SimpleText(wmstring,"IndicatorFont",wmarkpos+10,9,color_white)
        elseif serj.cfg.Vars["i_f"] == 5 then
            draw.RoundedBoxEx(8,wmarkpos+5,5,wamrkw+10,13,wmarkcolor,true,true,false,false)
            draw.RoundedBoxEx(8,wmarkpos+5,17,wamrkw+10,12,Color(wmarkcolor.r-45,wmarkcolor.g-45,wmarkcolor.b-45),false,false,true,true)
            draw.RoundedBox(6,wmarkpos+7,7,wamrkw+6,20,Color(25, 25, 25))
            draw.SimpleText(wmstring,"IndicatorFont",wmarkpos+10,9,color_white)
        elseif serj.cfg.Vars["i_f"] == 6 then
            draw.RoundedBox(0,wmarkpos+5,5,wamrkw+10,25,Color(25, 25, 25,150))
            serj.RainbowLine(wmarkpos+5,5,wamrkw+9,2,50)
            draw.SimpleText(wmstring,"IndicatorFont",wmarkpos+10,9,color_white)   
        end 
    end

    if serj.cfg.Vars["i_keybinds"] then
        local keybind_count = {}

        for key, keyState in pairs(serj.activebinds) do
            if (serj.cfg.Vars["i_ignore_ks"] or keyState) and serj.cfg.Keybinds.showInBinds[key] then 
                keybind_count[#keybind_count + 1] = {
                    serj.translateKeybinds.name[key],
                    serj.translateKeybinds.mode[serj.cfg.Keybinds.mode[key]],
                }
            end
        end

        local bind_h = 25

        if serj.cfg.Vars["i_s"] == 1 then   
            draw.RoundedBox(0,bindx,bindy,200,25,Color(25, 25, 25))
            -- serj.surfaceTexture(bindx,bindy,200,4,"gradient.png",color_white)
            surfaceSetDrawColor(0, 0, 0, 255)
            surfaceDrawOutlinedRect(bindx, bindy, 200, 25, 1)
            surfaceSetDrawColor(255, 165, 0)
            surfaceDrawRect(bindx, bindy, 200, 2)
            draw.SimpleText("Keybinds","IndicatorFont",bindx+100,bindy+13,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        elseif serj.cfg.Vars["i_s"] == 2 then
            draw.RoundedBox(3,bindx,bindy,200,25,Color(25,25,25))
		    draw.RoundedBox(10,bindx+2,bindy+1,196,2,hsv)
            serj.surfaceTexture(bindx+2,bindy+1,196,2,"gui/center_gradient",Color(255,255,255,66))
            draw.SimpleText("Keybinds","IndicatorFont",bindx+100,bindy+13,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        elseif serj.cfg.Vars["i_s"] == 3 then
            draw.RoundedBox(0,bindx,bindy,200,25,Color(25,25,25,200))
		    draw.RoundedBox(0,bindx,bindy,200,2,keybindcolor)
            serj.surfaceTexture(bindx,bindy,196,2,"gui/center_gradient",Color(255,255,255,66))
            draw.SimpleText("Keybinds","IndicatorFont",bindx+100,bindy+13,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        elseif serj.cfg.Vars["i_s"] == 5 then
            draw.RoundedBox(0,bindx,bindy,200,25,Color(25, 25, 25))
            surfaceSetDrawColor(keybindcolor)
            surfaceDrawRect(bindx+1,bindy+1,198,1)
            serj.surfaceTexture(bindx+1,bindy+2,1,21,"gui/gradient_down",keybindcolor)
            serj.surfaceTexture(bindx+198,bindy+2,1,21,"gui/gradient_down",keybindcolor)
            draw.SimpleText("Keybinds","IndicatorFont",bindx+100,bindy+13,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        elseif serj.cfg.Vars["i_s"] == 6 then
            draw.RoundedBoxEx(8,bindx,bindy,200,15,keybindcolor,true,true,false,false)
            draw.RoundedBoxEx(8,bindx,bindy+15,200,10,Color(keybindcolor.r-45,keybindcolor.g-45,keybindcolor.b-45),false,false,true,true)
            draw.RoundedBox(6,bindx+2,bindy+2,196,21,Color(25, 25, 25))
            draw.SimpleText("Keybinds","IndicatorFont",bindx+100,bindy+11,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        elseif serj.cfg.Vars["i_s"] == 7 then
            draw.RoundedBox(0,bindx,bindy,200,25,Color(25, 25, 25,200))
            serj.RainbowLine(bindx,bindy,199,2,50)
            draw.RoundedBox(0,bindx,bindy+23,200,2,Color(25, 25, 25,160))
            draw.SimpleText("Keybinds","IndicatorFont",bindx+100,bindy+13,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)      
        end

        for i = 1, #keybind_count do
            local kb_str2 = keybind_count[i][2]
            local kb_str = keybind_count[i][1]
            local stringw, stringh = surfaceGetTextSize(kb_str .. " - " .. kb_str2)


            if serj.cfg.Vars["i_s"] == 1 then   
                draw.RoundedBox(0,bindx,bindy+i*(bind_h),200,bind_h,Color(30,30,30))
                draw.SimpleText(kb_str,"IndicatorFont",bindx+4,bindy+i*(bind_h)+3,Color(185,250,255))
                draw.SimpleText(kb_str2,"IndicatorFont",bindx+195,bindy+i*(bind_h)+3,Color(181,255,96),TEXT_ALIGN_RIGHT)
            elseif serj.cfg.Vars["i_s"] == 2 then
                serj.surfaceTexture(bindx,bindy+i*(bind_h)+1,200,bind_h-2,"gui/gradient",Color(11,11,11,235))
                draw.SimpleText(kb_str,"IndicatorFont",bindx+4,bindy+i*(bind_h)+3,color_white)
                draw.SimpleText(kb_str2,"IndicatorFont",bindx+195,bindy+i*(bind_h)+3,color_white,TEXT_ALIGN_RIGHT)
            elseif serj.cfg.Vars["i_s"] == 3 then
                draw.SimpleText(kb_str,"IndicatorFont",bindx+4,bindy+i*(bind_h),color_white)
                draw.SimpleText(kb_str2,"IndicatorFont",bindx+195,bindy+i*(bind_h),color_white,TEXT_ALIGN_RIGHT)
            elseif serj.cfg.Vars["i_s"] == 4 then
                hsv2 = HSVToColor( ( CurTime() * 50 + i ) % 360, 1, 1 )
                draw.RoundedBox(0,scrw-stringw-18,5+i*(bind_h),stringw+18,bind_h,Color(25,25,25,200))
                draw.RoundedBox(0,scrw-4,5+i*(bind_h),4,bind_h,hsv2)
                draw.SimpleText(kb_str .. " - " .. kb_str2,"IndicatorFont",scrw-10-stringw,5+i*(bind_h)+4,color_white)
            elseif serj.cfg.Vars["i_s"] == 5 then
                serj.surfaceTexture(bindx,bindy+i*(bind_h)+1,200,bind_h-2,"gui/gradient",Color(11,11,11,235))
                draw.SimpleText(kb_str,"IndicatorFont",bindx+4,bindy+i*(bind_h)+3,color_white)
                draw.SimpleText(kb_str2,"IndicatorFont",bindx+195,bindy+i*(bind_h)+3,color_white,TEXT_ALIGN_RIGHT)
            elseif serj.cfg.Vars["i_s"] == 6 then
                draw.SimpleText(kb_str,"IndicatorFont",bindx+4,bindy+i*(bind_h),color_white)
                draw.SimpleText(kb_str2,"IndicatorFont",bindx+195,bindy+i*(bind_h),color_white,TEXT_ALIGN_RIGHT)
            elseif serj.cfg.Vars["i_s"] == 7 then
                draw.RoundedBox(0,bindx,bindy+i*(bind_h),200,bind_h,Color(30,30,30,150))
                draw.SimpleText(kb_str,"IndicatorFont",bindx+4,bindy+i*(bind_h)+3,Color(255,255,255))
                draw.SimpleText(kb_str2,"IndicatorFont",bindx+195,bindy+i*(bind_h)+3,Color(96,255,14403),TEXT_ALIGN_RIGHT)
            elseif serj.cfg.Vars["i_s"] == 8 then
                draw.SimpleText(kb_str .. " [" .. kb_str2 .. "]","IndicatorFont",scrw/2,scrh/2+i*(bind_h),serj.KColors(i),TEXT_ALIGN_CENTER)
            end
        end


        
        if serj.Panels.frame then
            local framepos_x, framepos_y = serj.Panels.frame:GetPos()
            if serj.inRect(bindx,bindy,bindx+200,bindy+25) and input.IsMouseDown(107) and !serj.inRect(framepos_x,framepos_y,900,700) then
                serj.cfg.Vars["i_keybinds_x"], serj.cfg.Vars["i_keybinds_y"] = gui.MouseX()-100, gui.MouseY()-12
            end
        end
    end

    if serj.cfg.Vars["i_targethud"] then
        local winchance = "by danilkochnev"
        local ping = "ping pong anal"

        local maxlen = serj.targethudy-20
        if IsValid(serj.target) then
            serj.targethp = Lerp(FrameTime()*5,serj.targethp,mClamp(serj.target:Health(),0,100))

            if IsValid(me:GetActiveWeapon()) and me:GetActiveWeapon():Clip1() <= 0 then
                winchance = "No ammo SYKA BLYAT!"
            elseif !IsValid(serj.target:GetActiveWeapon()) and IsValid(me:GetActiveWeapon()) then
                winchance = "Ez win"
            elseif serj.target:Health() < 10 and serj.target:Health() < me:Health() then
                winchance = "Ezz Owning"
            elseif me:Health() < 10 and serj.target:Health() > me:Health() then
                winchance = "*DEAD*"
            elseif serj.target:Health() > me:Health() then
                winchance = "Loosing"
            elseif serj.target:Health() == me:Health() then
                winchance = "Same chance"
            elseif serj.target:Health() < me:Health() then
                winchance = "Winning"
            end

            if serj.target:Ping() > me:Ping() then
                ping = " (bigger)"
            elseif serj.target:Ping() < me:Ping() then
                ping = " (advantage)"
            elseif serj.target:Ping() == me:Ping() then
                ping = " (same)"
            else
                ping = ""
            end


            --targethp = math.Clamp(serj.target:Health(),0,100)
            --targetap = math.Clamp(serj.target:Armor(),0,100)
            serj.targethudy = math.Approach(serj.targethudy,340,FrameTime()*500)
            serj.targethudx = math.Approach(serj.targethudx,120,FrameTime()*500)
            serj.targeta =  math.Approach( serj.targeta,255,FrameTime()*500)
        else
            serj.targethudy = math.Approach(serj.targethudy,0,FrameTime()*350)
            serj.targethudx = math.Approach(serj.targethudx,0,FrameTime()*350)
            serj.targeta =  math.Approach( serj.targeta,0,FrameTime()*350)
        end

        draw.RoundedBox(0,thx+150-serj.targethudy/2,thy,serj.targethudy,serj.targethudx,Color(22, 22, 22, serj.targeta))
        -- serj.surfaceTexture(thx+150-serj.targethudy/2,thy,serj.targethudy,4,"gradient.png",Color(255,255,255,serj.targeta))
        surfaceSetDrawColor(45,45,45,serj.targeta)
        surfaceDrawRect(thx+150-serj.targethudy/2,thy,serj.targethudy,4)
        
        if IsValid(serj.target) then
            --local lw = string.len(serj.target:Name())
            --print(lw)
            draw.SimpleText(serj.antidalbaeb(serj.target:Name(), 32),"THUDFONT",thx+150-serj.targethudy/2+120,thy+12,Color(255,255,255,serj.targeta))
            if IsValid(serj.target:GetActiveWeapon()) then 
                draw.SimpleText(serj.target:GetActiveWeapon():GetPrintName(),"THUDFONT",thx+150-serj.targethudy/2+120,thy+45,Color(255,255,255,serj.targeta))
            else
                draw.SimpleText("No valid weapon","THUDFONT",thx+150-serj.targethudy/2+120,thy+45,Color(255,255,255,serj.targeta))
            end
            draw.SimpleText(winchance,"THUDFONT",thx+150-serj.targethudy/2+120,thy+65,Color(255,255,255,serj.targeta))
            draw.SimpleText("Ping: " .. serj.target:Ping() .. ping,"THUDFONT",thx+150-serj.targethudy/2+120,thy+85,Color(255,255,255,serj.targeta))

            local hpRatio = math.Clamp(serj.target:Health() / serj.target:GetMaxHealth(), 0, 1)
            local hpColor = Color(255 * (1 - hpRatio), 180 * hpRatio, 0, serj.targeta)

            draw.NoTexture()
            surfaceSetDrawColor(9, 9, 9, serj.targeta)
            draw.Circle( thx+150-serj.targethudy/2+60, thy+62, 48, 64 , 100 )
            
            surfaceSetDrawColor(hpColor.r, hpColor.g, hpColor.b, serj.targeta)
            draw.Circle( thx+150-serj.targethudy/2+60, thy+62, 48, 64 , serj.targethp )
            draw.NoTexture()
            surfaceSetDrawColor(22, 22, 22, serj.targeta)
            draw.Circle( thx+150-serj.targethudy/2+60, thy+62, 36, 64 , 100 )

            draw.SimpleText(math.floor(hpRatio * 100) .. "%", "THUDFONT", thx+150-serj.targethudy/2+60, thy+serj.targethudx/2+4, Color(255, 255, 255, serj.targeta), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        if serj.Panels.frame then
            local framepos_x, framepos_y = serj.Panels.frame:GetPos()
            if serj.inRect(thx,thy,thx+300,thy+150) and input.IsMouseDown(107) and !serj.inRect(framepos_x,framepos_y,900,700) then
                serj.cfg.Vars["i_targethud_x"], serj.cfg.Vars["i_targethud_y"] = gui.MouseX()-100, gui.MouseY()-12
            end
        end
    end
end

local spotstable = {}
for i = 1, 100 do
	spotstable[ i ] = { x = mRand( 1, scrw ), y = mRand( 1, scrh ), x2 = mRand( -2, 2 ), y2 = mRand( -2, 2 ) }
end
--[[]
local randomimage = {
    "pauk.png",
    "cortez.png",
    "deagle.png",
    "ferrari.png",
    "npc_truckach.png",
    "rolex2.png",
    "swag1.png",
    "strelka.png",
    "urba.png",
    "putlir.png",
    "islam.png",
    "hitman.png",
    "krolex.png",
    "drip.png",
    "billy.png",
    "dlore.png",
    "csgo.png",
    "skinci.png",
    "hvher.png",
    "chains.png",
}
bebriki = {}
for bebr = 1, 100 do
    bebriki[#bebriki+1] = table.Random(randomimage)
end
]]
serj.bgalpha = 0
function serj.basedGigaSerejaga()
    if serj.cfg.Vars["estetika_fill"] then
        if serj.Panels.frame != false then
			serj.bgalpha = math.Approach(serj.bgalpha,245,FrameTime()*150)
		else
			serj.bgalpha = math.Approach(serj.bgalpha,0,FrameTime()*250)
		end
        if serj.bgalpha > 245 then serj.bgalpha = 245 end
        local bgcolor = string.ToColor(serj.cfg.Colors["estetika_fill"])
        surfaceSetDrawColor(bgcolor.r,bgcolor.g,bgcolor.b,serj.bgalpha)
        surfaceDrawRect(0,0,scrw,scrh)
	end
    if serj.cfg.Vars["estetika"] and serj.Panels.frame != false then
        local estetikacolor = string.ToColor(serj.cfg.Colors["estetika"])

        if serj.cfg.Vars["estetika_r"] then
            estetikacolor = HSVToColor( ( CurTime() * 50 ) % 360, 1, 1 )
        end

        for a = 1, serj.cfg.Vars["estetika_num"] do
            local spot = spotstable[ a ]
            if spot.x >= scrw or spot.x <= 0 then
                spot.x2 = -spot.x2
            end
                if spot.y >= scrh or spot.y <= 0 then
                spot.y2 = -spot.y2
            end
            spotstable[ a ].x = spot.x + spot.x2
            spotstable[ a ].y = spot.y + spot.y2
        end

        for a = 1, serj.cfg.Vars["estetika_num"] do
            local spot = spotstable[ a ]
            for b = 1, serj.cfg.Vars["estetika_num"] do
				local spot2 = spotstable[ b ]
				if a ~= b and mabs( spot2.x - spot.x ) <= 100 and mabs( spot2.y - spot.y ) <= 100 then
					surfaceSetDrawColor(estetikacolor)
                    surfaceDrawLine( spot.x, spot.y, spot2.x, spot2.y )
				end
			end
            --serj.surfaceTexture(spot.x, spot.y,65,65,bebriki[a],estetikacolor)      
        end
    end

	


	--[[]
    if serj.bsendpacket then
        draw.SimpleText("BSENDPACKET","font-02",5,ScrH()/2+50,Color(0,255,0))
        --draw.SimpleText("FL: " .. fakeLagTicks .. " / " .. fakeLagfactor,"font-02",5,ScrH()/2+20,Color(0,255,0))  
    else
        draw.SimpleText("BSENDPACKET","font-02",5,ScrH()/2+50,Color(255,0,0))
        --draw.SimpleText("FL: " .. fakeLagTicks .. " / " .. fakeLagfactor,"font-02",5,ScrH()/2+20,Color(255,0,0))
    end

    --draw.SimpleText("SPEED: " .. math.Round(me:GetVelocity():Length()),"font-02",5,ScrH()/2+45,Color(255,255,255))

    draw.SimpleText("HITS: " .. serj.hits,"font-02",5,ScrH()/2+70,Color(255,161,85))
    draw.SimpleText("SHOTS: " .. serj.shot,"font-02",5,ScrH()/2+90,Color(183,255,100))
    draw.SimpleText("MISSES: " .. serj.shot - serj.hits .. " ( " .. math.Round(((serj.shot - serj.hits)/serj.shot)*100) .. "% )","font-02",5,ScrH()/2+110,Color(255,100,100))


    if serj.target != nil then
        draw.SimpleText("Target: " .. serj.target:Name(),"font-02",ScrW()/2,ScrH()/2+25,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText("HP: " .. serj.target:Health(),"font-02",ScrW()/2,ScrH()/2+45,Color(255,166,83),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
	]]


    if serj.cfg.Vars["misc_hitmarker"] then
        local hitmarkercolor = string.ToColor(serj.cfg.Colors["misc_hitmarker"])
        for k, v in next, serj.hitmarkerTable do
            local pos = v[1]:ToScreen()
            local sposx, sposy = ScrW()/2, ScrH()/2
    
            if(v[2] <= 0) then
                table.remove(serj.hitmarkerTable, k);
                continue;
            end
            v[2] = v[2] - FrameTime()

            surfaceSetDrawColor(hitmarkercolor.r,hitmarkercolor.g,hitmarkercolor.b,hitmarkercolor.a)
            if serj.cfg.Vars["misc_hitmarker_pos"] == 1 then
                surfaceDrawLine( pos.x - 8, pos.y - 8, pos.x - 2, pos.y - 2 )
                surfaceDrawLine( pos.x - 8, pos.y + 8, pos.x - 2, pos.y + 2 )
                surfaceDrawLine( pos.x + 8, pos.y - 8, pos.x + 2, pos.y - 2 )
                surfaceDrawLine( pos.x + 8, pos.y + 8, pos.x + 2, pos.y + 2 )
            else
                surfaceDrawLine( sposx - 8, sposy - 8, sposx - 2, sposy - 2 )
                surfaceDrawLine( sposx - 8, sposy + 8, sposx - 2, sposy + 2 )
                surfaceDrawLine( sposx + 8, sposy - 8, sposx + 2, sposy - 2 )
                surfaceDrawLine( sposx + 8, sposy + 8, sposx + 2, sposy + 2 ) 
            end

        end
    end
    if serj.cfg.Vars["csgo_bscope"] then
        local col = string.ToColor(serj.cfg.Colors["csgo_bscope"])
        local fcolor = Color(col.r,col.g,col.b,col.a)
        local curw = me:GetActiveWeapon()
        if IsValid(me) and IsValid(curw) then
            if !serj.cfg.Vars["csgo_bscope_alt"] then
                if curw.Scope != nil then
                    if curw:GetClass():StartWith("weapon_csgo_") then
                        curw:SetNWString( "ScopeAlpha", 0 )
                        --if curw.Scope != 0 then
							serj.scropeAlpha = math.Approach(serj.scropeAlpha,85+(curw.Scope*10),FrameTime()*250)
                        --else
							serj.scropeAlpha = math.Approach(serj.scropeAlpha,0,FrameTime()*250)
                        --end
                        --if scropeAlpha > 1 then
                            --surfaceTexture(scrw/2+5,scrh/2,scropeAlpha,2,"gui/gradient_up",fcolor)
                            --surfaceTexture(scrw/2-5-scropeAlpha,scrh/2,scropeAlpha,2,"gui/gradient_up",fcolor)
                            --surfaceTexture(scrw/2,scrh/2+5,2,scropeAlpha,"gui/gradient_up",fcolor)
                            --surfaceTexture(scrw/2,scrh/2-5-scropeAlpha,2,scropeAlpha,"gui/gradient_up",fcolor)

                        --end
                        --print(curw.Scope)
                        if serj.cfg.Vars["csgo_bscope_dl"] then
                            if curw.Scope != 0 then
                                surfaceSetDrawColor(0,0,0,245)
                                surfaceDrawLine(0,scrh/2,scrw,scrh/2)
                                surfaceDrawLine(scrw/2,0,scrw/2,scrh)
                            end
                        end
                    end
                end
            else
                if serj.estscope[curw:GetClass()] then
                    if curw:GetZoomLevel() == 0 then
                        serj.scropeAlpha = math.Approach(serj.scropeAlpha,128,FrameTime()*250)
                    end 
                    if curw:GetZoomLevel() == 2 then 
                        serj.scropeAlpha = math.Approach(serj.scropeAlpha,85,FrameTime()*250)
                    end
                    if curw:GetZoomLevel() == 1 then
                        serj.scropeAlpha = math.Approach(serj.scropeAlpha,0,FrameTime()*650)
                    end 
        
                    curw:SetZoomLevel( 1 )
                    curw:SetZoom( 0 )
        
                    serj.surfaceTexture(scrw/2+5,scrh/2,serj.scropeAlpha,2,"gui/gradient",fcolor)
                    serj.surfaceTexture(scrw/2-5-serj.scropeAlpha/2,scrh/2+1,serj.scropeAlpha,2,"gui/gradient",fcolor,180)
                    serj.surfaceTexture(scrw/2,scrh/2+5,2,serj.scropeAlpha,"gui/gradient_down",fcolor)
                    serj.surfaceTexture(scrw/2,scrh/2-5-serj.scropeAlpha,2,serj.scropeAlpha,"gui/gradient_up",fcolor)
                elseif curw:GetClass():StartWith("m9k_")  then
                    if me:KeyDown(IN_ATTACK2) and (!me:KeyDown(IN_SPEED) and !me:KeyDown(IN_USE)) then
                        serj.scropeAlpha = math.Approach(serj.scropeAlpha,128,FrameTime()*250)
                    else
                        serj.scropeAlpha = math.Approach(serj.scropeAlpha,0,FrameTime()*650)
                    end

                    curw:SetIronsights(false)

                    serj.surfaceTexture(scrw/2+5,scrh/2,serj.scropeAlpha,2,"gui/gradient",fcolor)
                    serj.surfaceTexture(scrw/2-5-serj.scropeAlpha/2,scrh/2+1,serj.scropeAlpha,2,"gui/gradient",fcolor,180)
                    serj.surfaceTexture(scrw/2,scrh/2+5,2,serj.scropeAlpha,"gui/gradient_down",fcolor)
                    serj.surfaceTexture(scrw/2,scrh/2-5-serj.scropeAlpha,2,serj.scropeAlpha,"gui/gradient_up",fcolor)
                end
            end
        end
    end 


    
    if serj.cfg.Vars["i_indicators"] then
        local ind_count = {}

        if serj.cfg.Vars["fl_enable"] then
            ind_count[#ind_count + 1] = {"FL:",serj.fakeLagTicks,4,6}
        end

        if serj.cfg.Vars["aa_enable"] then
            ind_count[#ind_count + 1] = {"AA:",mabs(math.Round(math.AngleDifference(serj.vRealAngles.y,serj.vFakeAngles.y))),45,65} 
        end

        if serj.cfg.Vars["baim_always"] or serj.activebinds["baim_key"] then
            ind_count[#ind_count + 1] = {"BAIM","",1,1}
        end

        if serj.cfg.Vars["move_fd"] and serj.activebinds["key_fd"] then
            ind_count[#ind_count + 1] = {"DUCK","",1,1}
        end



        for i = 1, #ind_count do
            local str, str2 = ind_count[i][1], ind_count[i][2]
            local tw, th = surfaceGetTextSize(str)

            if !isnumber(ind_count[i][2]) then
                surfaceSetTextColor(25,255,25)
            else
                if ind_count[i][4] < ind_count[i][2] then
                    surfaceSetTextColor(0,255,0)
                elseif ind_count[i][3] < ind_count[i][2] then
                    surfaceSetTextColor(255,200,0)
                else
                    surfaceSetTextColor(255,0,0)
                end
            end
            




            surfaceSetTextPos(5,scrh/2 - th + th * i)
            surfaceSetFont("IndicatorFont")
            surfaceDrawText(str .. str2)
            surfaceSetTextColor(255,255,255)
        end

    end

    -- keybinds
    serj.drawKeybinds()

    -- Crosshair
    if serj.cfg.Vars["ch_e"] then
        local csizew = serj.cfg.Vars["ch_size"]
        local crosshair_color = string.ToColor(serj.cfg.Colors["ch_e"])
        if serj.cfg.Vars["ch_type"] == 1 then
            draw.RoundedBox(0,scrw/2-csizew/2-1,scrh/2-csizew/2-1,csizew+2,csizew+2,color_black)
            draw.RoundedBox(0,scrw/2-csizew/2,scrh/2-csizew/2,csizew,csizew,crosshair_color)

            --left
            draw.RoundedBox(0,scrw/2-csizew-16,scrh/2-csizew/2-1,csizew+2+10,csizew+2,color_black)
            draw.RoundedBox(0,scrw/2-csizew-15,scrh/2-csizew/2,csizew+10,csizew,crosshair_color)
            --right
            draw.RoundedBox(0,scrw/2+3,scrh/2-csizew/2-1,csizew+12,csizew+2,color_black)
            draw.RoundedBox(0,scrw/2+4,scrh/2-csizew/2,csizew+10,csizew,crosshair_color)
            --top
            draw.RoundedBox(0,scrw/2-csizew/2-1,scrh/2-csizew/2-16,csizew+2,csizew+12,color_black)
            draw.RoundedBox(0,scrw/2-csizew/2,scrh/2-csizew/2-15,csizew,csizew+10,crosshair_color)
            --down
            draw.RoundedBox(0,scrw/2-csizew/2-1,scrh/2+3,csizew+2,csizew+12,color_black)
            draw.RoundedBox(0,scrw/2-csizew/2,scrh/2+4,csizew,csizew+10,crosshair_color)

        elseif serj.cfg.Vars["ch_type"] == 2 then
            draw.RoundedBox(0,scrw/2-csizew/2-1,scrh/2-csizew/2-1,csizew+2,csizew+2,color_black)
            draw.RoundedBox(0,scrw/2-csizew/2,scrh/2-csizew/2,csizew,csizew,crosshair_color)
        elseif serj.cfg.Vars["ch_type"] == 3 then
            draw.SimpleText("Z","font-02",scrw/2,scrh/2,crosshair_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        elseif serj.cfg.Vars["ch_type"] == 4 then

        end
    end




    --serj.guiCheckBox("Enable crosshair","ch_e",crosshairsp,true)
    --serj.DropDown("Crosshair type", {"Default","Box","Zвастика","Nazi"}, "ch_type", crosshairsp)
    --serj.CreateSlider("Crosshair size", "", "ch_size", 1, 15, 0,crosshairsp)

end
local hide = {
	["CHudCrosshair"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if serj.cfg.Vars["ch_e"] and ( hide[ name ] ) then
		return false
	end
end )
serj.drawoverlay = false
hook.Add("PreDrawViewModel", "predraw", function(vm,ply,wep)
    local overlayCol = string.ToColor(serj.cfg.Colors["viewmodel_wireframe"])
	if !me:Alive() or !IsValid(me:GetActiveWeapon()) then return end

	local gun = me:GetActiveWeapon():GetClass()
    if gun:StartWith("cw_") then return end

	if me:Alive() and me:GetActiveWeapon():GetClass() != nil then	
        
        if serj.cfg.gunModels[gun] then
            vm:SetModel(serj.cfg.gunModels[gun][1])
        end

        if serj.cfg.Vars["viewmodel_flip_e"] then 
            if serj.cfg.Vars["viewmodel_flip"] then 
                me:GetActiveWeapon().ViewModelFlip = true
            else
                me:GetActiveWeapon().ViewModelFlip = false
            end
        end

		if serj.cfg.gunSkins[gun] then
            render.SetColorModulation(serj.cfg.gunSkins[gun][4]/255,serj.cfg.gunSkins[gun][5]/255,serj.cfg.gunSkins[gun][6]/255)
			render.SetBlend(serj.cfg.gunSkins[gun][7]/255)
            render.MaterialOverride(Material(serj.cfg.gunSkins[gun][1]))
		else
            render.SetColorModulation(1,1,1)
			render.MaterialOverride(Material(""))
		end
		render.SetBlend(1)
	end
    if serj.cfg.Vars["viewmodel_wireframe"] then
        --render.SuppressEngineLighting(true)
        if serj.drawoverlay then
            render.SetColorModulation(overlayCol.r, overlayCol.g, overlayCol.b)
            render.MaterialOverride(Material("!MovingWireframe"))
        else
            render.SetColorModulation(1, 1, 1)
        end
        render.SetBlend(1)
    end
    --print(vm:GetModel())
    return vm
end)
	
hook.Add("PostDrawViewModel", "Postdraw", function()
    local gun = me:GetActiveWeapon():GetClass()
	render.SetColorModulation(1, 1, 1)
    render.MaterialOverride()
    render.SetBlend(1)
    render.SuppressEngineLighting(false)

    if serj.drawoverlay then return end

    if serj.cfg.Vars["viewmodel_wireframe"] and !gun:StartWith("cw_") then
        serj.drawoverlay = true
        LocalPlayer():GetViewModel():DrawModel()
        serj.drawoverlay = false
    end
end)








serj.isCanTrace = true
function serj.Trace()
	if (not serj.isCanTrace) then
		return
	end
	serj.isCanTrace = false
	index = 1
	indexF = index * .1
	trace = util.TraceEntity({
		start = LocalPlayer():GetPos(),
		endpos = physenv.GetGravity() * (0.5 * indexF * indexF) + LocalPlayer():GetVelocity() * indexF + LocalPlayer():GetPos(),
		filter = LocalPlayer()
	}, LocalPlayer())
	while (not trace.Hit) do
		render.DrawLine(trace.StartPos, trace.HitPos, Color(250, 250, 250), true)
		index = index + 1
		indexF = index * .1
		indexFN = index * .1 - .1
		trace = util.TraceEntity({
			start = physenv.GetGravity() * (0.5 * indexFN * indexFN) + LocalPlayer():GetVelocity() * indexFN + LocalPlayer():GetPos(),
			endpos = physenv.GetGravity() * (0.5 * indexF * indexF) + LocalPlayer():GetVelocity() * indexF + LocalPlayer():GetPos(),
			filter = LocalPlayer()
		}, LocalPlayer())
		if (index > 256) then
			break
		end
	end
	render.DrawLine(trace.StartPos, trace.HitPos, Color(255, 250, 250), true)
	serj.isCanTrace = true
	return trace.HitPos
end
hook.Add("PostDrawTranslucentRenderables"or"TranslucentRenderables", "3434", function(bD, bS)
    if !serj.cfg.Vars["fall_predict"] then return end
	if not LocalPlayer():IsOnGround() then 
		local pw = serj.Trace()
		render.DrawWireframeBox(pw, Angle(), LocalPlayer():OBBMins(), LocalPlayer():OBBMaxs(), Color(250, 250, 250), true)
	end
end)
hook.Add("PreDrawPlayerHands", "RandomString()", function(hands, vm, ply, weapon)
	local hsv = HSVToColor( ( CurTime() * 50 ) % 360, 1, 1 )
    if serj.cfg.Vars["misc_so2_hands"] then
        render.SetColorModulation(hsv.r/ 255,hsv.g/ 255,hsv.b/ 255)
        render.MaterialOverride(Material(""))
        render.SetBlend(0.9)
    end	
end)

serj.fakemodels = {}
serj.NewFakeModel = NULL
serj.UpdateFakeModel = NULL

function serj.NewFakeModel(ply, group)
	local model = ClientsideModel(ply:GetModel(), group)
	model:SetNoDraw(true)
	
	local data = {
		model = model,
		ply = ply
	}
	
	serj.fakemodels[#serj.fakemodels + 1] = data
	
	return data
end

serj.fakelagmodel = serj.NewFakeModel(me, RENDERGROUP_TRANSLUCENT)
serj.realmodel = serj.NewFakeModel(me, RENDERGROUP_OPAQUE)
serj.fakemodel = serj.NewFakeModel(me, RENDERGROUP_OPAQUE)

function serj.CopyPoseParam(name, from, to)
	local min, max = to:GetPoseParameterRange(from:LookupPoseParameter(name))
	if min then
		to:SetPoseParameter(name, min + (max - min) * from:GetPoseParameter(name))
	end
end

function serj.UpdateFakeModel(model, angles)
	local mdl = model.model
	local ply = model.ply
	
	local ang
	if angles then
		ang = angles
		
		mdl:SetPoseParameter("aim_pitch", ang.p)
		mdl:SetPoseParameter("head_pitch", ang.p)
		mdl:SetPoseParameter("body_yaw", ang.y)
		mdl:SetPoseParameter("aim_yaw", 0)
		
       
		-- Fix legs
		local velocity = ply:GetVelocity()
		local velocityYaw = mNormalizeAng(ang.y - mdeg(math.atan2(velocity.y, velocity.x)))
		local playbackRate = ply:GetPlaybackRate()
		local moveX = mcos(mrad(velocityYaw)) * playbackRate
		local moveY = -msin(mrad(velocityYaw)) * playbackRate
		
		mdl:SetPoseParameter("move_x", moveX)
		mdl:SetPoseParameter("move_y", moveY)
        
    else
        ang = Angle(0, 0, 0)

        for i = 0, ply:GetNumPoseParameters() - 1 do
			local name = ply:GetPoseParameterName(i)
			serj.CopyPoseParam(name, ply, mdl)
		end
    end
	
    mdl:SetModel(me:GetModel())

	mdl:SetPos(ply:GetPos())
	
	mdl:SetAngles(Angle(0, ang.y, 0))
	
	mdl:SetCycle(ply:GetCycle())
	mdl:SetSequence(ply:GetSequence())
	
	mdl:InvalidateBoneCache()

end

serj.chamsmat = CreateMaterial("SWBaseChams", "VertexLitGeneric", {
	["$basetexture"] = "color/white",
	["$model"] = 1
})

serj.chamsmat_transparent = CreateMaterial("SWBaseChams_transparent", "VertexLitGeneric", {
	["$basetexture"] = "color/white",
	["$model"] = 1,
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
})

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "serj.PlayerDisconnectCheater", function(data)
    if not serj.cfg.Vars["MAMBETIEBANIE"] then return end
    
    local name = data.name
    local networkid = data.networkid
    
    if serj.trackedCheaters[networkid] then
        chat.AddText(Color(255, 50, 50), "[mambet.biz] ", Color(255, 255, 255), "Мамбет ", Color(255, 50, 50), name, Color(255, 255, 255), " (" .. networkid .. ") вышел с сервера.")
    end
end)

serj.announcedMambets = {}
serj.initialScanDone = false

hook.Add("Think", "serj.MambetAnnouncer", function()
    if not serj.cfg.Vars["MAMBETIEBANIE"] then return end
    if not serj.githubSyncLoaded then return end

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or ply == me then continue end
        
        local sid = ply:SteamID()
        if sid == "" or sid == "NULL" then continue end

        if serj.trackedCheaters[sid] and not serj.announcedMambets[sid] then
            local status = "зашел на сервер."
            if not serj.initialScanDone then status = "уже на сервере." end
            
            serj.announcedMambets[sid] = true
            chat.AddText(Color(255, 50, 50), "[mambet.biz] ", Color(255, 255, 255), "Мамбет ", Color(255, 50, 50), ply:Name(), Color(255, 255, 255), " (" .. sid .. ") " .. status)
        end
    end
    serj.initialScanDone = true

    for sid, _ in pairs(serj.announcedMambets) do
        local found = false
        for _, ply in ipairs(player.GetAll()) do
            if ply:SteamID() == sid then
                found = true
                break
            end
        end
        if not found then
            serj.announcedMambets[sid] = nil
        end
    end
end)

gameevent.Listen("player_spawn")
hook.Add( "player_spawn", "player_spawn_example", function( data ) 
	local id = data.userid	
    if id == me:UserID() then
        serj.fakelagmodel = serj.NewFakeModel(me, RENDERGROUP_TRANSLUCENT)
        serj.realmodel = serj.NewFakeModel(me, RENDERGROUP_OPAQUE)
        serj.fakemodel = serj.NewFakeModel(me, RENDERGROUP_OPAQUE)
    end
end )

serj.fchams = NULL 
serj.fkchams = NULL 
serj.rlchams = NULL 

hook.Add("PostDrawOpaqueRenderables", "fakeAngleChams", function() 
    if !IsValid(me) or !me:Alive() then return end

    local fakeanglecolor = string.ToColor(serj.cfg.Colors["fake_chams"])
    local realanglecolor = string.ToColor(serj.cfg.Colors["real_chams"])

    if serj.cfg.Vars["paganie_strelochki"] then
		local mypos = me:GetPos()
		cam.IgnoreZ(true)
		cam.Start3D2D(mypos, Angle(0, serj.vRealAngles.y + 45, 0), 1)
			surfaceSetDrawColor(Color(120, 53, 196))
			surfaceDrawLine(0, 0, 28, 28)
		cam.End3D2D()
		
		cam.Start3D2D(mypos, Angle(0, serj.vFakeAngles.y + 45, 0), 1)
			surfaceSetDrawColor(Color(255, 255, 255))
			surfaceDrawLine(0, 0, 28, 28)
		cam.End3D2D()

		cam.IgnoreZ(false)
	end

    if serj.cfg.Vars["fake_chams_m"] == 1 then
        serj.fchams = "!flat"
    elseif serj.cfg.Vars["fake_chams_m"] == 2 then
        serj.fchams = "!textured"
    elseif serj.cfg.Vars["fake_chams_m"] == 3 then
        serj.fchams = "models/shiny"
    elseif serj.cfg.Vars["fake_chams_m"] == 4 then
        serj.fchams = "models/props_combine/health_charger_glass"
    elseif serj.cfg.Vars["fake_chams_m"] == 5 then
        serj.fchams = "models/wireframe"
    elseif serj.cfg.Vars["fake_chams_m"] == 6 then
        serj.fchams = "!glowcham2"
    elseif serj.cfg.Vars["fake_chams_m"] == 7 then
        serj.fchams = "!glow_additive"
    end

    if serj.cfg.Vars["real_chams_m"] == 1 then
        serj.rlchams = "!flat"
    elseif serj.cfg.Vars["real_chams_m"] == 2 then
        serj.rlchams = "!textured"
    elseif serj.cfg.Vars["real_chams_m"] == 3 then
        serj.rlchams = "models/shiny"
    elseif serj.cfg.Vars["real_chams_m"] == 4 then
        serj.rlchams = "models/props_combine/health_charger_glass"
    elseif serj.cfg.Vars["real_chams_m"] == 5 then
        serj.rlchams = "models/wireframe"
    elseif serj.cfg.Vars["real_chams_m"] == 6 then
        serj.rlchams = "!glowcham2"
    elseif serj.cfg.Vars["real_chams_m"] == 7 then
        serj.rlchams = "!glow_additive"
    end

    if serj.cfg.Vars["fakelag_chams_m"] == 1 then
        serj.fkchams = "!flat"
    elseif serj.cfg.Vars["fakelag_chams_m"] == 2 then
        serj.fkchams = "!textured"
    elseif serj.cfg.Vars["fakelag_chams_m"] == 3 then
        serj.fkchams = "models/shiny"
    elseif serj.cfg.Vars["fakelag_chams_m"] == 4 then
        serj.fkchams = "models/props_combine/health_charger_glass"
    elseif serj.cfg.Vars["fakelag_chams_m"] == 5 then
        serj.fkchams = "models/wireframe"
    elseif serj.cfg.Vars["fakelag_chams_m"] == 6 then
        serj.fkchams = "!glowcham2"
    elseif serj.cfg.Vars["fakelag_chams_m"] == 7 then
        serj.fkchams = "!glow_additive"
    end

	if serj.tpsmooth > 0 then
        if serj.cfg.Vars["aa_enable"] then
            serj.UpdateFakeModel(serj.fakemodel, serj.vFakeAngles)
            serj.UpdateFakeModel(serj.realmodel, serj.vRealAngles)

            local rl = serj.realmodel.model
            local fk = serj.fakemodel.model

            if serj.cfg.Vars["real_chams"] then
                render.MaterialOverride(Material(serj.rlchams))
                render.SetBlend(realanglecolor.a/255)
                render.SetColorModulation(realanglecolor.r/255, realanglecolor.g/255, realanglecolor.b/255)
                rl:DrawModel()
            end
            if serj.cfg.Vars["fake_chams"] then
                render.MaterialOverride(Material(serj.fchams))
                render.SetBlend(fakeanglecolor.a/255)
                render.SetColorModulation(fakeanglecolor.r/255, fakeanglecolor.g/255, fakeanglecolor.b/255)
                fk:DrawModel()
            end
            
            render.MaterialOverride()
            me:DrawViewModel( false )
        end
    else
        me:DrawViewModel( true )
    end
end)

hook.Add("PostDrawTranslucentRenderables", "fakeLagChams", function()
    if !IsValid(me) or !me:Alive() then return end
    local fakelahchamscolor = string.ToColor(serj.cfg.Colors["fakelag_chams"])

	if serj.bsendpacket then
		serj.UpdateFakeModel(serj.fakelagmodel,serj.FakeLagAngles)
	end

	if serj.tpsmooth > 0 then
        if serj.cfg.Vars["fl_enable"] and serj.cfg.Vars["fakelag_chams"] and LocalPlayer():GetVelocity():Length() > 50 then
		    render.MaterialOverride(Material(serj.fkchams))
            render.SetBlend(fakelahchamscolor.a/255)
		    render.SetColorModulation(fakelahchamscolor.r/255, fakelahchamscolor.g/255, fakelahchamscolor.b/255)
		    serj.fakelagmodel.model:DrawModel()
        end
	end
	
	render.MaterialOverride()
end)
serj.playerTable = {}

hook.Add("Think", "serj.playertable", function()
	for k, v in pairs(player.GetAll()) do
		if v != nil and v != me and v:Alive() and !v:IsDormant() and v:IsPlayer() or v:IsBot() && !table.HasValue(serj.playerTable, v) then
			serj.playerTable[v] = v
		elseif v == nil or v == me or !v:Alive() or v:IsDormant() or !v:IsPlayer() or !v:IsBot() && table.HasValue(serj.playerTable, v) then
			table.RemoveByValue(serj.playerTable, v)
		end
	end
end)

hook.Add("PreDrawHalos", "serj.GlowESP", function()
    if serj.cfg.Vars["hand_glow"] and serj.rukient != nil then
        local handcolorrr = string.ToColor(serj.cfg.Colors["hand_glow"])

        if serj.cfg.Vars["hand_glow_r"] then
            handcolorrr = HSVToColor( ( CurTime() * 55 ) % 360, 1, 1 )
        end

        halo.Add({serj.rukient},handcolorrr,2,2,2,serj.cfg.Vars["hand_glow_a"],true)
    end
	if serj.cfg.Vars["glow_esp"] then
		halo.Add(serj.playerTable,string.ToColor(serj.cfg.Colors["glow_esp"]),2,2,2,serj.cfg.Vars["glow_esp_a"],true)
	end
    if serj.cfg.Vars["glow_esp_att"] then
        for k,v in next, player.GetAll() do
            if v != nil and v != me and v:Alive() and !v:IsDormant() and v:IsPlayer() or v:IsBot() and v:GetActiveWeapon() != nil then
                local hisGun = v:GetActiveWeapon()
                halo.Add({hisGun},string.ToColor(serj.cfg.Colors["glow_esp"]),2,2,2,serj.cfg.Vars["glow_esp_a"],true)
            end
        end
    end
end)

hook.Add("AdjustMouseSensitivity", "serj.MSA", function()
    if serj.cfg.Vars["misc_msa"] then 
        return 1
    end
end)

hook.Add("PostDrawTranslucentRenderables", "jopa_effects", function()
    if not serj.cfg.Vars["LGBT"] then return end
    
    local pl = LocalPlayer()
    if not IsValid(pl) or not pl:Alive() then return end
    
    local footPos = pl:GetPos() + Vector(0, 0, 5)
    
    local velocity = pl:GetVelocity():LengthSqr()
    if velocity < 100 then return end
    
    if not serj.Emitter then serj.Emitter = ParticleEmitter(pl:GetPos()) end
    serj.Emitter:SetPos(footPos)
    
    local particle = serj.Emitter:Add("sprites/glow04_noz", footPos)
    
    if particle then
        local color = HSVToColor((CurTime() * 50) % 360, 1, 1)
        
        particle:SetVelocity(pl:GetVelocity() * 0.1 + Vector(math.random(-5, 5), math.random(-5, 5), math.random(1, 3)))
        particle:SetDieTime(0.8)
        particle:SetStartAlpha(200)
        particle:SetEndAlpha(0)
        particle:SetStartSize(3)
        particle:SetEndSize(8)
        particle:SetColor(color.r, color.g, color.b)
        particle:SetGravity(Vector(0, 0, -50))
    end
end)

local landingAuras = {}

local lastOnGround = false
hook.Add("Think", "LandingAuraTracker", function()
    if not serj.cfg.Vars["jumpcircle"] then return end
    
    local player = LocalPlayer()
    if not IsValid(player) then return end
    
    local isOnGround = player:IsOnGround()
    
    if isOnGround and not lastOnGround then
        local landPos = player:GetPos() + Vector(0, 0, 5)
        if landingAuras == nil then landingAuras = {} end
        table.insert(landingAuras, {
            pos = landPos,
            startTime = CurTime(),
            duration = 0.7
        })
    end
    
    lastOnGround = isOnGround
end)

hook.Add("PostDrawTranslucentRenderables", "0677766_effects", function()
    if not serj.cfg.Vars["jumpcircle"] then return end

    local currentTime = CurTime()
    if landingAuras == nil then return end
    
    for i = #landingAuras, 1, -1 do
        local aura = landingAuras[i]
        local elapsed = currentTime - aura.startTime
        
        if elapsed >= aura.duration then
            table.remove(landingAuras, i)
        else
            local progress = elapsed / aura.duration
            local alpha = 255 * (1 - progress)
            
            local time = currentTime
            local pulse = math.sin(time * 3) * 0.5 + 1
            
            local hue = (time * 50) % 360
            local baseColor = HSVToColor(hue, 1, 1)
            local circle_color = Color(baseColor.r, baseColor.g, baseColor.b, alpha)
            
            local circle_radius = 25 * pulse
            local rotation_angle = time * 150

            render.SetMaterial(Material("effects/select_ring"))
            render.DrawQuadEasy(aura.pos, Vector(0, 0, 1), circle_radius, circle_radius, circle_color, rotation_angle)

            render.SetMaterial(Material("effects/select_ring"))
            local secondary_color = Color(baseColor.r, baseColor.g, baseColor.b, alpha * 0.4)
            render.DrawQuadEasy(aura.pos, Vector(0, 0, 1), circle_radius * 1.5, circle_radius * 1.5, secondary_color, -rotation_angle * 0.7)

            local ang = Angle(90, 0, 0)
            render.SetMaterial(Material("effects/select_ring"))
            render.DrawQuadEasy(aura.pos, ang:Forward(), circle_radius * 0.8, circle_radius * 0.8, circle_color, rotation_angle)
        end
    end
end)

hook.Add("PrePlayerDraw", "serj.preplayerdraw", function(ply)
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
	end

    if serj.cfg.Vars["aa_enable"] and ply == me then
        if serj.cfg.Vars["real_chams"] or serj.cfg.Vars["fake_chams"] then
		    return true
        elseif me:IsPlayingTaunt() and serj.tpsmooth == 0 then
            return true
        end
	end

    if serj.cfg.Vars["res_enable"] then 
        serj.StepResolver(ply)
    end

    if serj.cfg.Vars["predict_debug"] and serj.cfg.Vars["predict"] then
        local wep = me:GetActiveWeapon()
        if IsValid(wep) then
            local wc = wep:GetClass()
            local bs = GetBulletSpeed(wep)
            draw.SimpleText("Weapon: "..wc, "Default", 10, ScrH()-120, Color(255,200,100))
            draw.SimpleText("Bullet Speed: "..math.Round(bs).." u/s", "Default", 10, ScrH()-105, Color(200,200,255))
            draw.SimpleText("PREDICT ACTIVE", "Default", 10, ScrH()-75, Color(0,255,0))
        end
    end

    ply:ManipulateBoneAngles(0,Angle(0,0,0))
end)

function serj.PostDraw2DSkyBox()
    local col = string.ToColor(serj.cfg.Colors["sky_f"])
    if serj.cfg.Vars["sky_f"] then
        render.OverrideDepthEnable( true, false )
        cam.Start2D()
            surfaceSetDrawColor(col.r, col.g, col.b, col.a)
            surfaceDrawRect(0,0,ScrW(), ScrH())
        cam.End2D()
        render.OverrideDepthEnable( false, false )
    end  
end

function serj.blackSky()
    if serj.cfg.Vars["sky_b"] then
        return true
    else
        return false
    end
end


/*
	Hooks
*/

hook.Add("PlayerTraceAttack","serj.TraceHook",serj.TraceAttack)
hook.Add("RenderScreenspaceEffects", "serj.Chams", serj.RenderChams)
hook.Add("OnImpact", "serj.OnImpact", serj.OnImpact)
hook.Add("PreDrawOpaqueRenderables", "serj.PreDrawOpaqueRenderables", serj.BulletBeams)
hook.Add("SetupWorldFog", "serj.SetupWorldFog", serj.SetupWorldFog)
hook.Add("SetupSkyboxFog", "serj.SetupSkyboxFog", serj.SetupSkyboxFog)
hook.Add("RenderScene", "serj.RenderScene", serj.RenderScene)
hook.Add("PreRender", "serj.penisRender", serj.penisRender)
hook.Add("PostRender", "serj.post", serj.EndOfLightingMod)
hook.Add("PreDrawHUD", "serj.predrawcock", serj.EndOfLightingMod)
hook.Add("HUDPaint","serj.playerESP",serj.PlayerESP)
hook.Add("HUDPaint","serj.OOfarrows",serj.OOfarrows)
hook.Add("HUDPaint","serj.indicators",serj.basedGigaSerejaga)
hook.Add("PostDraw2DSkyBox", "serj.PostDraw2DSkyBox",serj.PostDraw2DSkyBox)
hook.Add("PreDrawSkyBox", "serj.blackSky",serj.blackSky)

serj.DisableWorldModulation()
serj.DisablePropModulation()

function GAMEMODE:CreateMove( cmd )
    return true 
end

function GAMEMODE:CalcView( view )
    return true 
end


hook.Add("OnPlayerHitGround","serj.Landing",serj.OnLand)
hook.Add("PreDrawEffects","serj.Effects",serj.Postdraweffects)
hook.Add("CreateMove","serj.CreateMove",serj.CreateMove)
hook.Add("CalcView","serj.SilentAngles",serj.SilentViewAngles)
hook.Add("CalcViewModelView", "serj.CalcViewmodel", serj.CalcViewModelView)
hook.Add("Move","serj.Move",serj.ShootTime)
hook.Add("Think","serj.Think",serj.Think)
hook.Add("HUDPaint","serj.HUDPaint",serj.HUDPaint)