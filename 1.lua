local CVar = CreateClientConVar("cl_enable_global_chat", 1, true, false, "Включить глобальный чат?", 0, 1)
hook.Add("OnPlayerChat", "global_chat.Disable", function(a, b, c, d, e)
    if not CVar:GetBool()
        and not c
        and not d
        and not e then
        return true
    end
end)
concommand.Add("discord_join", function()
	gui.OpenURL("https://discord.gg/wtJjAeRdWx")
end)
concommand.Add("wiki", function()
	local ip = game.GetIPAddress()
	gui.OpenURL("http://" .. ip:sub(1, #ip - 6) .. "/wiki")
end)
concommand.Add("rules", function()
	local ip = game.GetIPAddress()
	gui.OpenURL("http://" .. ip:sub(1, #ip - 6) .. "/rules")
end)
local activated = false
concommand.Add("super_secret_command", function()
    if activated then
        return
    end
    activated = true
	surface.PlaySound("sbox_sounds/win_gameshow.mp3")
	timer.Simple(4.5, function() -- 3.9941818714142
		RunConsoleCommand("gamemenucommand", "quit")
	end)
end)
hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
hook.Remove("Think", "DOFThink")
hook.Remove("PostDrawEffects", "RenderWidgets")
RunConsoleCommand("mat_bloomscale", "0")
RunConsoleCommand("cl_resend", "3.5")
RunConsoleCommand("ragdoll_sleepaftertime", "12.0f")
RunConsoleCommand("cl_timeout", "99999")
RunConsoleCommand("cl_showhints", "0")
RunConsoleCommand("r_decals", "750")
RunConsoleCommand("cl_interp", "0.04")
RunConsoleCommand("mp_decals", "750")
RunConsoleCommand("r_radiosity", "4")
RunConsoleCommand("r_flashlightdepthres", "512")
RunConsoleCommand("tanktracktool_autotracks_detail_max", "2")
RunConsoleCommand("advdupe2_limit_ghost", "24")
RunConsoleCommand("rate", "1048576")
RunConsoleCommand("net_compresspackets", "0")
RunConsoleCommand("net_maxcleartime", "0.001")
RunConsoleCommand("vfire_light_brightness", "0.1")
RunConsoleCommand("mod_load_anims_async", "0")
RunConsoleCommand("mod_load_mesh_async", "0")
RunConsoleCommand("mod_load_vcollide_async", "0")
RunConsoleCommand("gmod_mcore_test", "1") -- :troll:
RunConsoleCommand("r_PhysPropStaticLighting", "0") -- fuck off
RunConsoleCommand("effects_unfreeze", "0") -- fuck off x2
hook.Add("StartCommand", "gmodworldtip", function()
	hook.Remove("StartCommand", "gmodworldtip")
	surface.CreateFont("GModWorldtip", {font = "Roboto Bold", size = 22, antialias = true, extended = true})
end)
hook.Add("SpawnMenuOpen", "spawnmenu_tabs_hide", function()
	if game.MaxPlayers() == 2
		or not g_SpawnMenu then
		return
	end
	for k, v in ipairs( g_SpawnMenu.CreateMenu.Items ) do
		local text = v.Tab:GetText()
		if text == language.GetPhrase("spawnmenu.category.saves")
			or (not LocalPlayer():IsAdmin() and text == language.GetPhrase("spawnmenu.category.dupes"))
		then
			g_SpawnMenu.CreateMenu:CloseTab( v.Tab, true )
		end
	end
end)
local clean = {}
hook.Add("CreateClientsideRagdoll", "clear_ragdoll", function(_, this)
	timer.Simple(5, function()
		if not IsValid(this) then return end
		if this:GetClass() == "class C_ClientRagdoll" then
			this:SetRenderMode(RENDERMODE_TRANSALPHA)
            table.insert(clean, this)
			SafeRemoveEntityDelayed(this, 1)
		end
	end)
end)
hook.Add("Think", "clear_ragdoll", function()
    for i = 1, #clean do
        local ent = clean[i]
        if IsValid(ent) then
            ent.alpha = ent.alpha or 255
            ent.alpha = Lerp(FrameTime() * 5, ent.alpha, 0)
            ent:SetColor(Color(255, 255, 255, ent.alpha))
        else
            table.remove(clean, i)
        end
    end
end)
local color_red, color_white = Color(230, 0, 0), color_white
local ConVar = CreateClientConVar("cl_chat_adverts", 1, true, false, "Включить оповещения в чате?", 0, 1)
local advert = function()
    chat.AddText(color_red, "Поддержи сервер своим донатом! Вкладка \"Пожертвовать\" в F2.")
    chat.AddText(color_white, "F2 - меню сервера, /discord - Discord сервер, /wiki - вики сервера.")
end
timer.Create("adverts", 90, 0, function()
	if not ConVar:GetBool() then return end
    advert()
	timer.Adjust("adverts", player.GetCount() > 24 and 60 or 90)
end)
language.Add("trigger_hurt", "Триггер карты")
language.Add("worldspawn", "Суровый мир")
language.Add("prop_physics", "Предмет")
language.Add("entityflame", "Огонёк")
local SysTime = SysTime
local FrameTime = FrameTime
local Vector = Vector
local Matrix = Matrix
function draw.TextRotated(text, x, y, color, font, ang)
	surface.SetFont(font)
	surface.SetTextColor(color)
	local m = Matrix()
	m:SetAngles(Angle(0, ang, 0))
	m:SetTranslation(Vector(x, y, 0))
	cam.PushModelMatrix(m)
		surface.SetTextPos(0, 0)
		surface.DrawText(text)
	cam.PopModelMatrix()
end
hook.Add("pac_OnPartCreated", "PlayerSizeFix", function(part)
	local lp = LocalPlayer()
    if part.owner_id == lp:UniqueID() then
		if part:GetRootPart():GetOwnerName() == "self" then
			if (part.ClassName == "entity" or part.ClassName == "entity2") then
				lp.pac_player_size = part.Size
			end
		end
    end
end)
hook.Add("pac_OnPartRemove", "PlayerSizeFix", function(part)
	local lp = LocalPlayer()
    if part.owner_id == lp:UniqueID() then
		if part:GetRootPart():GetOwnerName() == "self" then
			if (part.ClassName == "entity" or part.ClassName == "entity2") then
				lp.pac3_Scale = 1
				lp.pac_player_size = 1
			end
		end
	end
end)
cacher__W, cacher__H = cacher__W or ScrW, cacher__H or ScrH
do
	local valW, valH = cacher__W(), cacher__H()
	function ScrW()
		return valW
	end
	function ScrH()
		return valH
	end
	hook.Add("OnScreenSizeChanged","onscreensizechange",function(w,h)
		valW, valH = w, h
	end)
end
function system.GetOS()
    if system.IsWindows() then
        return "Windows"
    elseif system.IsLinux() then
        return "Linux"
    elseif system.IsOSX() then
        return "Mac OS"
    else
        return "Unknown OS"
    end
end
function gmod.Is64Bit()
    return jit.version_num == 20100 and true or false
end
local pl
local _LocalPlayer = LocalPlayer
function LocalPlayer()
	pl = _LocalPlayer()
	if pl:IsValid() then
		LocalPlayer = function()
			return pl
		end
		hook.Run("LocalPlayer_Validated", pl)
	end
	return pl
end
local t = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
hook.Add("RenderScreenspaceEffects", "render_summer", function()
	DrawColorModify(t)
end)
hook.Add("PostPlayerDraw", "nonsteam_css_content_fix", function(v)
	local wep = v:GetActiveWeapon()
	if not wep:IsValid() then
        return
    end
	local hand = v:LookupBone("ValveBiped.Bip01_R_Hand")
    if not hand then
        return
    end
	local mat = v:GetBoneMatrix(hand)
	if not mat then
		return
	end
	local pos, ang = mat:GetTranslation(), mat:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 180)
	wep:SetRenderOrigin(pos)
	wep:SetRenderAngles(ang)
end)
function cmd(cmd)
	LocalPlayer():ConCommand(cmd)
end
function Say(...)
	local first = true
	local msg = ""
	for _, v in pairs({...}) do
		if first then
			first = false
		else
			msg = msg .. " "
		end
		msg = msg .. tostring(v)
	end
	msg = msg:gsub("\n", ""):gsub(";", ":"):gsub("\"", "'")
	cmd("say " .. msg)
end
say = Say
spawnmenu_AddToolMenuOption = spawnmenu_AddToolMenuOption or spawnmenu.AddToolMenuOption
function spawnmenu.AddToolMenuOption(tab, category, itemname, text, command, controls, cpanelfunction, TheTable)
	if tab == "Options" then
		tab = "Utilities"
	end
	return spawnmenu_AddToolMenuOption(tab, category, itemname, text, command, controls, cpanelfunction, TheTable)
end
local alpha, queue, last_queue = 0, 0, 0
local table_count, Lerp, format = table.Count, Lerp, string.format
local setalpha, outlinedtext = surface.SetAlphaMultiplier, draw.SimpleTextOutlined
local color_white, color_black = Color(255, 255, 255), Color(0, 0, 0)
local is_wardrobe, is_pac3, is_pvs = false, false, false
local str, text = "", ""
local pac3_parts_loading = 0
local pvs_loading = 0
timer.Create("loading.Think", 0.5, 0, function()
    local wardrobe_size = workshop.currentQueueSize
    local pac3_size = pac.IsEnabled() and table_count(pac.urltex.Queue) + table_count(pac.urlobj.Queue) + pac3_parts_loading or 0
    is_wardrobe, is_pac3, is_pvs = wardrobe_size > 0, pac3_size > 0, pvs_loading > 0
	queue = wardrobe_size + pac3_size + pvs_loading
    if queue == 0 then
		str = format("%s: %s", text, queue)
        return
    end
    if is_wardrobe
        and is_pac3 then
        text = "PAC3 + Wardrobe" .. (is_pvs and " + PVS" or "")
    elseif is_wardrobe then
        text = "Wardrobe" .. (is_pvs and " + PVS" or "")
    elseif is_pac3 then
        text = "PAC3" .. (is_pvs and " + PVS" or "")
    elseif is_pvs then
		text = "PVS"
	end
    str = format("%s: %s", text, queue < 0 and 0 or queue)
end)
local cog = Material("icon16/cog.png")
local CVar = CreateClientConVar("cl_show_pac3_and_wardrobe_queue", 1, true, false)
local systime, lagAlpha = SysTime(), 0
hook.Add("Think", "loading.Think", function()
    systime = SysTime()
end)
local loading_white = Color(255, 255, 255)
hook.Add("HUDPaint", "loading.HUDPaint", function()
    if not CVar:GetBool() then
        return
    end
	local FT = RealFrameTime()
	if queue > 0 then
		alpha, last_queue = Lerp(FT * 20, alpha, 1), SysTime() + 3
	else
		alpha = math.Clamp(last_queue - SysTime(), 0, 1)
	end
	if alpha < 0.0001 then
		return
	end
    if SysTime() - systime > 0.1 then
		lagAlpha = SysTime() + ((SysTime() - systime) * 4)
	end
	local lagAlpha_ = math.Clamp(lagAlpha - SysTime(), 0, 2)
    loading_white.g = 255 - (lagAlpha_ * 75)
    loading_white.b = 255 - (lagAlpha_ * 75)
	setalpha(alpha)
		outlinedtext(str, "CAP.DonateMenuFont", ScrW() - 42, 380, loading_white, 2, 1, 1, color_black)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(cog)
		surface.DrawTexturedRectRotated(ScrW() - 30, 380, 16, 16, -SysTime() * 36 % 360)
	setalpha(1)
end)
hook.Add("LocalPlayer_Validated", "HUDShouldDraw_rewrite", function(ply)
	hook.Remove("LocalPlayer_Validated", "HUDShouldDraw_rewrite")
	local ENTITY = FindMetaTable("Entity")
	local IsValid = ENTITY.IsValid
	function GAMEMODE:HUDShouldDraw(name)
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep.HUDShouldDraw then
			return wep.HUDShouldDraw(wep, name)
		end
		return true
	end
	local META = FindMetaTable("Player")
	Old_GetActiveWeapon = Old_GetActiveWeapon or META.GetActiveWeapon
	local Old_GetActiveWeapon = Old_GetActiveWeapon
	local getactiveweapon_detour = function(lp)
		local current_weapon = NULL
		function META:GetActiveWeapon()
			if self == lp then
				return current_weapon
			end
			return Old_GetActiveWeapon(self)
		end
		hook.Add("AdjustMouseSensitivity", "lp.GetActiveWeapon_Cache", function() -- OK
			current_weapon = Old_GetActiveWeapon(lp)
		end)
	end
	getactiveweapon_detour(ply)
	timer.Create("pac_fix_cursor", 1, 0, function()
		local in_pac3_editor = ply:GetNW2Bool("in pac3 editor")
		if in_pac3_editor then
			return
		end
		local worldpanel = vgui.GetWorldPanel()
		if not worldpanel:IsValid() then
			return
		end
		worldpanel:SetCursor("arrow")
	end)
    local ENTITY = scripted_ents.GetStored("base_gmodentity")
	local ENT = ENTITY.t
    local eyepos, ent = Vector(), NULL
    hook.Add("RenderScene", "base_gmodentity.Look", function(vec)
        eyepos, ent = vec, ply:GetEyeTrace().Entity
    end)
	function ENT:BeingLookedAtByLocalPlayer()
		local dist = self.MaxWorldTipDistance ^ 2
		return ent == self and eyepos:DistToSqr(self:GetPos()) <= dist
	end
	if tanktracktool then
		local eyePos = Vector()
		hook.Add("RenderScene", "tanktrack_shit.Optimize", function(vec)
			eyePos = vec
		end)
		local limit = 3200000
		for _, key in ipairs({"sent_tanktracks_legacy", "sent_tanktracks_auto", "sent_suspension_shock", "sent_suspension_spring", "sent_point_beam"}) do
			local ENT = scripted_ents.GetStored(key)
			if ENT then
				ENT = ENT["t"]
				ENT._Think, ENT._Draw = ENT._Think or ENT.Think, ENT._Draw or ENT.Draw
				ENT.Distance, ENT.GetNextThink = 0, 0
				ENT.Think = function(self)
					local is_faggot = self.GetNextThink > CurTime()
					if is_faggot then
						return
					else
						self.Distance = eyePos:DistToSqr(self:GetPos())
						if self.Distance > limit then
							self.GetNextThink = CurTime() + 1
							return
						end
					end
					return ENT._Think(self)
				end
				ENT.Draw = function(self)
					if self.Distance > limit then
						return
					end
					return ENT._Draw(self)
				end
				scripted_ents.Register(ENT, key)
				print("Registered:", key)
			end
		end
		local key = "gmod_thruster"
        local ENT = scripted_ents.GetStored(key)
		if ENT then
			ENT = ENT["t"]
			ENT._Think = ENT._Think or ENT.Think
            local listGet
			ENT.Think = function(self)
                local text = self:GetOverlayText() -- Baseclass
                if text ~= "" and self:BeingLookedAtByLocalPlayer() and not self:GetNoDraw() then
                    AddWorldTip( self:EntIndex(), text, 0.5, self:GetPos(), self )
                    halo.Add( { self }, color_white, 1, 1, 1, true, true )
                end
                self.ShouldDraw = GetConVarNumber( "cl_drawthrusterseffects" ) ~= 0
                if ( not self:IsOn() ) then self.OnStart = nil return end
                self.OnStart = self.OnStart or CurTime()
                if ( self.ShouldDraw == false ) then return end
                if ( self:GetEffect() == "" or self:GetEffect() == "none" ) then return end
                if not listGet then
                    listGet = list.GetForEdit( "ThrusterEffects" )
                end
                for id, t in pairs( listGet ) do
                    if ( t.thruster_effect ~= self:GetEffect() or not t.effectThink ) then continue end
                    t.effectThink( self )
                    break
                end
			end
			scripted_ents.Register(ENT, key)
		end
		local key = "gmod_emitter"
        local ENT = scripted_ents.GetStored(key)
		if ENT then
			ENT = ENT["t"]
			ENT._Think = ENT._Think or ENT.Think
            local listGet
			ENT.Think = function(self)
                local text = self:GetOverlayText() -- Baseclass
                if text ~= "" and self:BeingLookedAtByLocalPlayer() and not self:GetNoDraw() then
                    AddWorldTip( self:EntIndex(), text, 0.5, self:GetPos(), self )
                    halo.Add( { self }, color_white, 1, 1, 1, true, true )
                end
				if ( !self:GetOn() ) then return end
				self.Delay = self.Delay or 0
				if ( self.Delay > CurTime() ) then return end
				self.Delay = CurTime() + math.max(self:GetDelay(), 0.3)
				--
				-- Find our effect table
				--
				local Effect = self:GetEffect()
                if not listGet then
                    listGet = list.GetForEdit( "EffectType" )
                end
				local EffectTable = listGet[ Effect ]
				if ( !EffectTable ) then return end
				local Angle = self:GetAngles()
				EffectTable.func( self, self:GetPos() + Angle:Forward() * 12, Angle, self:GetScale() )
			end
			scripted_ents.Register(ENT, key)
		end
	end
end)
hook.Add("InitPostEntity", "light_optimize", function()
	hook.Remove("InitPostEntity", "light_optimize")
	local SWEP = weapons.GetStored("weapon_base")
	function SWEP:PrintWeaponInfo( x, y, alpha )
		if ( self.DrawWeaponInfoBox == false ) then return end
		if (self.InfoMarkup == nil ) then
			local str
			local title_color = "<color=230,230,230,255>"
			local text_color = "<color=150,150,150,255>"
			str = "<font=HudSelectionText>"
			if ( self.Author != "" ) then str = str .. title_color .. "Автор:</color>\t" .. text_color .. self.Author .. "</color>\n" end
			if ( self.Contact != "" ) then str = str .. title_color .. "Контакты:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
			if ( self.Purpose != "" ) then str = str .. title_color .. "Предназначение:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
			if ( self.Instructions != "" ) then str = str .. title_color .. "Инструкция:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
			str = str .. "</font>"
			self.InfoMarkup = markup.Parse( str, 250 )
		end
		surface.SetDrawColor( 60, 60, 60, alpha )
		surface.SetTexture( self.SpeechBubbleLid )
		surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 )
		draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )
		self.InfoMarkup:Draw( x + 5, y + 5, nil, nil, alpha )
	end
end)
local last_focus = 0
hook.Add("CreateMove", "not_focus_shoot", function(cmd)
	local CT = CurTime()
    if not system.HasFocus() then
        last_focus = CT
    end
    if CT - last_focus < 0.3 then
        cmd:RemoveKey(IN_ATTACK)
        cmd:RemoveKey(IN_ATTACK2)
    end
end)
local limit = (2 ^ 16) + (2 ^ 12) -- 65535 + 4096
local badtime = 0
net.Receive("pvs.Data", function()
	pvs_loading = pvs_loading + 1
	timer.Simple(1, function()
		pvs_loading = pvs_loading - 1
	end)
end)
hook.Add("pace_WearPartFromServer", "WearPartFromServer", function(ply, data_part, data)
	local lp = LocalPlayer()
	if lp ~= ply then
		pac3_parts_loading = pac3_parts_loading + 1
		timer.Simple(1, function()
			pac3_parts_loading = pac3_parts_loading - 1
		end)
	end
    local txt = util.TableToJSON(data)
    local len = string.len(txt)
    if len > limit then
        local text = string.format("%s отправил слишком большой пакет данных. Отменяю его одёжку PAC3... (%i > %i)", tostring(ply), len, limit)
        pac.Message(text)
        if ply == lp and badtime < CurTime() then
            notification.AddLegacy("Ваша часть одёжки PAC3 не была отправлена игрокам,\nтак как он превышает допустимый лимит размера отправки PAC3.", 1, 6)
            surface.PlaySound("buttons/button10.wav")
            badtime = CurTime() + 1
        end
        return false
    end
end)
local ConVar = CreateClientConVar("cl_fps_boost_enabled", 0, true, false)
CreateClientConVar("cl_draw_distance", 2500, true, false)
hook.Add("StartCommand", "Load_FPS_Boost", function()
	hook.Remove("StartCommand", "Load_FPS_Boost")
	cvars.AddChangeCallback("cl_fps_boost_enabled", function(_, _, new)
		FPSBoostActivate(tobool(new))
	end, "cl_fps_boost_enabled")
	FPSBOOSTACTIVATED = FPSBOOSTACTIVATED or false
	function FPSBoostActivate(onoff)
		if onoff then
			FPSBOOSTACTIVATED = true
			RunConsoleCommand("cl_threaded_bone_setup", "1")
			RunConsoleCommand("r_threaded_client_shadow_manager", "1")
			RunConsoleCommand("r_threaded_renderables", "1")
			RunConsoleCommand("r_threaded_particles", "1")
			RunConsoleCommand("cl_threaded_client_leaf_system", "1")
			RunConsoleCommand("mat_reduceparticles", "1")
			RunConsoleCommand("r_fastzreject", "1")
			RunConsoleCommand("snd_mix_async", "1")
			local _GetConVar, _ents_GetAll_ = GetConVar, ents.GetAll
			local meta, metavec = FindMetaTable("Entity"), FindMetaTable("Vector")
			local EyePos, disttosqr, getpos, nodraw = EyePos, metavec.DistToSqr, meta.GetPos, meta.SetNoDraw
			local getnodraw = meta.GetNoDraw
			local getclass, string_find = meta.GetClass, string.find
			local ConVar = _GetConVar("cl_draw_distance")
			local init = false
			timer.Create("fps_dist", .7, 0, function()
				local a = ConVar:GetFloat()
				local cl_fps_distance = a * a
				if cl_fps_distance == 0 then
					if not init then 
						for _, v in ipairs(ents.GetAll()) do
							local class = getclass(v)
							if string_find(class, "C_", 1, true) then goto skip end
							v:SetNoDraw(false)
							v.IsOptimizeThing = false
							::skip::
						end
						init = true
					end
					return
				else
					init = false
				end
				local _ents_GetAll = _ents_GetAll_()
				local lPos = EyePos()
				for i = 1, #_ents_GetAll do
					local v = _ents_GetAll[i]
					if string_find(getclass(v), "C_", 1, true) then goto skip end
					local dist = disttosqr(lPos, getpos(v))
					local tbl = v:GetTable()
					if getnodraw(v) and not tbl.IsOptimizeThing then
						goto skip
					end
					if (dist > cl_fps_distance) then
						nodraw(v, true)
						tbl.IsOptimizeThing = true
					else
						nodraw(v, false)
					end
					::skip::
				end
			end)
		else
			RunConsoleCommand("cl_threaded_bone_setup", "0")
			RunConsoleCommand("r_threaded_client_shadow_manager", "0")
			RunConsoleCommand("r_threaded_renderables", "0")
			RunConsoleCommand("r_threaded_particles", "0")
			RunConsoleCommand("cl_threaded_client_leaf_system", "0")
			RunConsoleCommand("mat_reduceparticles", "0")
			RunConsoleCommand("r_fastzreject", "0")
			RunConsoleCommand("snd_mix_async", "0")
			for _, v in ipairs(ents.GetAll()) do
				if tostring(v):find("C_", 1, true) then
					goto skip
				end
		
				v:SetNoDraw(false)
				v.IsOptimizeThing = false
				::skip::
			end
			timer.Remove("fps_dist")
			FPSBOOSTACTIVATED = false
		end
	end
	if ConVar:GetBool() then
		FPSBoostActivate(true)
	end
end)
net.Receive("Average_FPS", function()
    net.Start("Average_FPS")
        net.WriteFloat(1 / FrameTime())
    net.SendToServer()
end)
net.Receive("lua_manualload", function()
    RunString(net.ReadString(), "LuaManualLoad")
end)
hook.Add("PP.HudShow", "mp_HudShow", function()
	local ply = LocalPlayer()
	local ent_trace = ply:GetEyeTrace().Entity
	if not ent_trace:IsValid() then
		return
	end
	local class = ent_trace:GetClass()
	if (ent_trace.IsMediaPlayerEntity and ent_trace:GetMediaPlayer())
		or (class == "arcade_cabinet" and ent_trace:GetPlayer() == ply)
		or class == "sent_melon"
		or ent_trace:GetNWBool("clans_IsDecor")
		or ent_trace.IsFlag then
		return false
	end 
end)
hook.Add("OnAchievementAchieved", "OnAchievementAchieved", function(ply, achid)
	chat.AddText(ply, color_white, " выполнил достижение: ", Color(255, 200, 0), achievements.GetName(achid))
	return true
end)
cvars.AddChangeCallback("cl_playermodel", function()
    net.Start("cl_playermodel")
        net.WriteUInt(0, 2)
    net.SendToServer()
end, "cl_playermodel")
cvars.AddChangeCallback("cl_playercolor", function()
    net.Start("cl_playermodel", true)
        net.WriteUInt(1, 2)
    net.SendToServer()
end, "cl_playercolor")
cvars.AddChangeCallback("cl_weaponcolor", function()
    net.Start("cl_playermodel", true)
        net.WriteUInt(1, 2)
    net.SendToServer()
end, "cl_weaponcolor")
cvars.AddChangeCallback("cl_playerskin", function()
    net.Start("cl_playermodel")
        net.WriteUInt(2, 2)
    net.SendToServer()
end, "cl_playerskin")
cvars.AddChangeCallback("cl_playerbodygroups", function()
    net.Start("cl_playermodel")
        net.WriteUInt(2, 2)
    net.SendToServer()
end, "cl_playerbodygroups")
hook.Add("OnPlayerChat", "misc.OnPlayerChat", function(ply, text)
	if ply:IsValid()
		and ply.IsMuted
		and ply:IsMuted() then
		return true
	end
end)
local fuckywucky = 2 ^ 15
hook.Add("PrePlayerDraw", "player_eyes.Fix", function(ply)
    local attachment = ply:LookupAttachment("eyes")
    if not attachment then
        return
    end
	local eyes = ply:GetAttachment(attachment)
	if not eyes then
		return
	end
	local pos, ang = eyes.Pos, eyes.Ang
	ply:SetEyeTarget(pos + ang:Forward() * fuckywucky)
end)
local block = {
	"GModMouseInput",
	"SpawnMenu",
	"DMenu",
	"ContextMenu",
	"ControlPanel",
	"MediaPlayer"
}
concommand.Add("vgui_cleanup", function()
	local worldpanel = vgui.GetWorldPanel()
	for key, panel in ipairs(worldpanel:GetChildren()) do
		local name = panel:GetName()
		local founded
		for index, word in ipairs(block) do
			if string.find(name, word, 1, true) then
				founded = true
				break
			end
		end
		if not founded
			and panel:IsVisible() then
			panel:Remove()
		end
	end
end)
concommand.Add("jit", function()
	if jit.status() then
		jit.off()
	else
		jit.on()
	end
	jit.flush()
	print("LuaJIT: ".. (jit.status() and "enabled" or "disabled"))
end)
hook.Add("PlayerBindPress", "test", function(ply, cmd)
	if cmd ~= "+reload" then
		return
	end
    local wep = ply:GetActiveWeapon()
    if not wep:IsValid() then
		return
	end
	local cl = wep:GetClass()
	if cl == "weapon_ninjastars" then
		local wep = ply:GetWeapon("blink")
		if IsValid(wep) then
			input.SelectWeapon(ply:GetWeapon("blink"))
		end
	elseif cl == "blink" then
		local wep = ply:GetWeapon("weapon_ninjastars")
		if IsValid(wep) then
			input.SelectWeapon(ply:GetWeapon("weapon_ninjastars"))
		end
	end
end)
local ok = false
chat.PlaySound = function()
    if not ok then
        surface.PlaySound("sbox_sounds/chat1.wav")
    else
        surface.PlaySound("sbox_sounds/chat2.wav")
    end
    ok = not ok
end
hook.Add("LocalPlayer_Validated", "pace_fullupdate_fix_protect_on_join", function(lp)
	hook.Remove("LocalPlayer_Validated", "pace_fullupdate_fix_protect_on_join")
	timer.Simple(1, function()
		local world = game.GetWorld()
		for key, mat in ipairs(world:GetMaterials()) do
			local material = Material(mat)
			local getValues = material:GetKeyValues()
			local recompute = false
			if getValues["$nodiffusebumplighting"] then
				material:SetInt("$nodiffusebumplighting", 1)
				recompute = true
			end
			if recompute then
				material:Recompute()
			end
		end
	end)
end)
hook.Add("AddToolMenuCategories", "gmod_tool.Duplicator", function()
	hook.Remove("AddToolMenuCategories", "gmod_tool.Duplicator")
	local weapon = weapons.GetStored("gmod_tool")
	weapon["Tool"]["duplicator"]["AddToMenu"] = false
	weapon["Tool"]["lamp"]["AddToMenu"] = false
end)
local orange, black = Color(255, 100, 0), Color(0, 0, 0)
local scale, w = 35, 6
local ok = false
local setDrawColor, setDrawRect = surface.SetDrawColor, surface.DrawTexturedRectRotated
hook.Add("PostRenderVGUI", "victory_day.HUDPaint", function()
	if not ok
        or gui.IsGameUIVisible() then
		return
	end
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()
    if wep:IsValid()
        and string.find(wep:GetClass(), "camera", 1, true) then
        return
    end
	local scrw, scrh = ScrW() - scale, ScrH() - scale
	draw.NoTexture()
	for i = 0, 4 do
		local plus = i * (w - 2)
		setDrawColor(i % 2 == 0 and black or orange)
		setDrawRect(scrw + plus, scrh + plus, scale * 3, w, 45)
	end
end)
local check = function()
	local time = os.time()
	if tonumber(os.date("%m", time)) == 5 then
		local day = tonumber(os.date("%d", time))
		if day >= 1
			and day <= 12 then
			ok = true
		else
			ok = false
		end
	else
		ok = false
	end
end
timer.Create("victory_day.Check", 60, 0, check)
hook.Add("Think", "victory_day.Check", function()
	hook.Remove("Think", "victory_day.Check")
	check()
end)
local CVar = GetConVar("physgun_wheelspeed")
timer.Create("physgun_wheelspeed: " .. tostring(CVar:GetFloat()), 0.5, 0, function()
	local getSpeed = CVar:GetFloat()
	if getSpeed > 100 then
		RunConsoleCommand("physgun_wheelspeed", "10")
	elseif getSpeed < -100 then
		RunConsoleCommand("physgun_wheelspeed", "-10")
	end
end)
local spawn_effect_init = function()
	local CVar = CreateConVar("cl_drawspawneffect", "1", FCVAR_ARCHIVE)
	local entities = {}
	function GAMEMODE:NetworkEntityCreated() end
    hook.Add("OnEntityCreated", "spawn_effect", function(ent)
		if not CVar:GetBool() then
			return
		end
		if not (ent:GetSpawnEffect() and ent:GetCreationTime() > CurTime() - 1.0) then
			return
		end
        entities[ent] = {
			["scale"] = ent.GetModelScale and ent:GetModelScale() or 1,
            ["mult"] = 0,
            ["cached_vector"] = Vector(0, 0, 0)
		}
    end)
	hook.Add("RenderScene", "spawn_effect", function()
		if not CVar:GetBool() then
			return
		end
        local FT = FrameTime()
		for ent, array in pairs(entities) do
			array["mult"] = math.Clamp(array["mult"] + (FT * 6), 0, 1)
			if ent:IsValid() then
                local mult = array["mult"]
                array["cached_vector"].x = mult
                array["cached_vector"].y = mult
                array["cached_vector"].z = mult
                local mat = Matrix()
                mat:Scale(array["cached_vector"])
                ent:EnableMatrix("RenderMultiply", mat)
				if array["mult"] >= 1 then
					entities[ent] = nil
					ent:DisableMatrix("RenderMultiply")
				end
			else
				entities[ent] = nil
			end
		end
	end)
end
hook.Add("Think", "spawn_effect", function()
	hook.Remove("Think", "spawn_effect")
	spawn_effect_init()
end)
local lower = string.lower
local Copy = table.Copy
local isInvalidSound = {
    ["error"] = true,
    ["nil"] = true,
    ["0"] = true,
    [""] = true,
    ["common/null.wav"] = true,
    ["(null)"] = true
}
_CreateSound = _CreateSound or CreateSound
local isfunction = isfunction
local function noop() return nil end
local function ret( r ) return function() return r end end
CSoundPatchMock = {
    GetDSP = ret( 0 ),
    GetPitch = ret( 0 ),
    GetSoundLevel = ret( 0 ),
    GetVolume = ret( 0 ),
    IsPlaying = ret( false ),
    _IsMock = true
}
local soundPatch = FindMetaTable( "CSoundPatch" )
for k, v in pairs( soundPatch ) do
    if not CSoundPatchMock[k] then
        CSoundPatchMock[k] = isfunction( v ) and noop or v
    end
end
CreateSound = function(targetEnt, soundName, filter, ...)
    local lowerName = lower(soundName)
    if isInvalidSound[lowerName] then
        return Copy(CSoundPatchMock)
    end
    return _CreateSound(targetEnt, soundName, filter, ...)
end
local limit = 2048 ^ 2
hook.Add("prop2mesh_hook_meshdone", "123", function(crc, uniqueID, array)
	timer.Simple(0, function()
		local mins, maxs = array["vmaxs"], array["vmins"]
		if mins and maxs and mins:DistToSqr(maxs) > limit then
            local recycleArray = prop2mesh.recycle[crc]
            if recycleArray then
                local meshes = recycleArray.meshes
                if meshes then
                    local meshesUID = meshes[uniqueID]
                    if meshesUID then
                        local basic = meshesUID["basic"]
                        if basic then
                            local mesh = basic["Mesh"]
                            if IsValid(mesh) then
                                mesh:Destroy()
                            end
                        else
							local complex = meshesUID["complex"]
							if complex then
								for key, mesh in pairs(complex) do
									if IsValid(mesh) then
										mesh:Destroy()
									end
								end
							end
						end
                    end
                end
            end
		end
	end)
end)
hook.Add("LocalPlayer_Validated", "toolgun_fix.EyeTrace", function(ply)
	hook.Remove("LocalPlayer_Validated", "toolgun_fix.EyeTrace")
	local PLAYER = FindMetaTable("Player")
	PLAYER._GetEyeTrace = PLAYER._GetEyeTrace or PLAYER.GetEyeTrace
	local _GetEyeTrace = PLAYER._GetEyeTrace
	local eyeTrace = ply:GetEyeTrace()
	function PLAYER:GetEyeTrace(...)
		if self == ply then
			return eyeTrace
		end
		return _GetEyeTrace(self, ...)
	end
	hook.Add("AdjustMouseSensitivity", "toolgun_fix.EyeTrace", function()
		eyeTrace = util.TraceLine(util.GetPlayerTrace(ply))
		local wep = ply:GetActiveWeapon()
		if wep:IsValid()
			and wep:GetClass() == "gmod_tool"
			and wep.Think then
			wep:Think()
		end
	end)
end)
surface.CreateFont("spawnMenu_Font1", {size = 13, weight = 800, font = "Tahoma"})
hook.Add("PopulateContent", "Example", function(pnlContent, tree)
    local viewPanel = vgui.Create("ContentContainer", pnlContent)
    viewPanel:SetVisible(false)
	local models = tree:AddNode("Сторонние модели", "icon16/ruby.png")
    models.Label:SetFont("spawnMenu_Font1")
	models.DoClick = function()
		viewPanel:Clear(true)
		local cp = spawnmenu.GetContentType("model")
		if cp then
			for k, v in ipairs(file.Find("models/andruha/*.mdl", "GAME")) do
				cp(viewPanel, {model = "models/andruha/" .. v})
			end
			for k, v in ipairs(file.Find("models/props_foliage/*.mdl", "WORKSHOP")) do
			--	cp(viewPanel, {model = "models/props_foliage/" .. v})
			end
            pnlContent:SwitchPanel(viewPanel)
		end
	end
end)
local _CompileString, _assert, insert, format, concat = CompileString, assert, table.insert, string.format, table.concat
local fast_unpack = {}
local unpack_mt = {}
function unpack_mt.__call(u, tbl, i, j)
    i = i or 1
    j = j or #tbl
    if not (u[i] and u[i][j]) then
        if not u[i] then
            u[i] = {}
        end
        local values = {}
        for ind = i, j do
            insert(values, format("t[%d]", ind))
        end
        u[i][j] = _assert(_CompileString(format("return function(t) return %s end", concat(values, ","))))()
    end
    return u[i][j](tbl)
end
setmetatable(fast_unpack, unpack_mt)
unpack_orig = unpack_orig or unpack
unpack = fast_unpack
local META = FindMetaTable("Entity")
META._SetOwner = META._SetOwner or META.SetOwner
META._GetOwner = META._GetOwner or META.GetOwner
function META:SetOwner(ent)
	local tbl = self:GetTable()
    tbl.OwnerCached = ent
    return tbl.OwnerCached
end
function META:GetOwner()
	local tbl = self:GetTable()
    return tbl.OwnerCached or (function()
        tbl.OwnerCached = META._GetOwner(self)
        return tbl.OwnerCached
    end)() or META._GetOwner(self)
end
hook.Add("PlayerSwitchWeapon", "okGetOwner", function(player, odlWeapon, newWeapon)
	odlWeapon.OwnerCached = nil
	newWeapon.OwnerCached = nil
end)
local cooldown = 0
hook.Add( "InitPostEntity", "RequestFullPlayerUpdate", function()
	gameevent.Listen( "OnRequestFullUpdate" )
	hook.Add( "OnRequestFullUpdate", "RequestFullPlayerUpdate", function( data )
		if data.userid != LocalPlayer():UserID() then return end
		if cooldown > CurTime() then return end
		net.Start( "RequestFullPlayerUpdate" )
		net.SendToServer()
		cooldown = CurTime() + 5
	end)
	net.Start( "RequestFullPlayerUpdate" )
	net.SendToServer()
end)
