include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
end

local function sineBetween( min, max, t )
    local halfRange = ( max - min ) / 2
    return min + halfRange + math.sin( t ) * halfRange
end

local function RayQuadIntersect( vOrigin, vDirection, vPlane, vX, vY )
	local vp = vDirection:Cross( vY )

	local d = vX:DotProduct( vp )

	if ( d <= 0.0 ) then return end

	local vt = vOrigin - vPlane
	local u = vt:DotProduct( vp )
	if ( u < 0.0 or u > d ) then return end

	local v = vDirection:DotProduct( vt:Cross( vX ) )
	if ( v < 0.0 or v > d ) then return end

	return Vector( u / d, v / d, 0 )
end

local function MouseRayInteresct( pos, ang )
	local plane = pos + ( ang:Forward() * ( 375 / 2 ) ) + ( ang:Right() * ( 92 / -2 ) )

	local x = ( ang:Forward() * -375 )
	local y = ( ang:Right() * 92 )

	return RayQuadIntersect( EyePos(), LocalPlayer():GetAimVector(), plane, x, y )
end

local function GetCursorPos( pos, ang, scale )
	local uv = MouseRayInteresct( pos, ang )
	if ( uv ) then
		local x, y = ( ( 0.5 - uv.x ) * 375 ), ( ( uv.y - 0.5 ) * 92 )
		return ( x / scale ), ( y / scale )
	end
end

local function IsMouseOver( pos, ang, scale, x, y, w, h )
	local mx, my = GetCursorPos( pos, ang, scale )

	if ( mx && my ) then
		return ( mx >= x && mx <= ( x + w ) ) && ( my >= y && my <= ( y + h ) )
	else
		return false
	end
end

surface.CreateFont( "GModRP_Printer_Small", { font = "Roboto", size = 92, weight = 500, extended = true } )
surface.CreateFont( "GModRP_Printer_Tiny", { font = "Roboto", size = 72, weight = 500, extended = true } )
surface.CreateFont( "GModRP_Printer_Tiniest", { font = "Roboto", size = 58, weight = 500, extended = true } )
surface.CreateFont( "GModRP_Printer_Big", { font = "Roboto", size = 256, weight = 500, extended = true } )
local fireMat = Material( "repix/animetown/printer/fire.png" )
local warningMat = Material( "repix/animetown/printer/warning.png" )
local moneyMat = Material( "repix/animetown/printer/money.png" )
local powerMat = Material( "repix/animetown/printer/btn_power.png" )
function ENT:DrawTranslucent()
    if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 512^2 ) then return end
    local pos, ang = self:LocalToWorld( Vector( 0, 0, 11 ) ), self:LocalToWorldAngles( Angle( 0, 90, 0 ) )
    cam.Start3D2D( pos, ang, 0.02 )
        draw.SimpleText( "Владелец:", "GModRP_Printer_Tiny", -600, -670, Color( 255, 255, 255 ), nil, TEXT_ALIGN_BOTTOM )
        local owner = self:GetPrinterOwner()
        local name = IsValid( owner ) and ( owner.RPNick and owner:RPNick() or owner:Nick() ) or "Отключившийся игрок"
        draw.SimpleText( tostring( name ), "GModRP_Printer_Small", -600, -650, Color( 255, 255, 255 ) )
        draw.SimpleText( "Статистика:", "GModRP_Printer_Tiny", -600, -525, Color( 255, 255, 255 ) )
        local y = -425
        draw.SimpleText( "Напечатано за всё время: " .. string.Comma( self:GetTotalPrint() or 0 ) .. "AT", "GModRP_Printer_Tiniest", -600, y, Color( 255, 255, 255 ) )
        y = y + 92
        draw.SimpleText( "Доступно для сбора: " .. string.Comma( self:GetCurrentPrint() or 0 ) .. "AT", "GModRP_Printer_Tiniest", -600, y, Color( 255, 255, 255 ) )
        y = y + 92
        local overheat = self:GetOverheat()
        if ( overheat ) then overheat = "да" else overheat = "нет" end
        draw.SimpleText( "Перегрев: " .. tostring( overheat ), "GModRP_Printer_Tiniest", -600, y, Color( 255, 255, 255 ) )

        if ( !self:GetOn() ) then
            draw.SimpleText( "Принтер выключен", "GModRP_Printer_Small", -600, 520, Color( 255, 75, 75 ) )
        end

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( moneyMat )
        surface.DrawTexturedRect( -512, 0, 240, 240 )

        local curPrintBig = self:GetCurrentPrint() or 0
        curPrintBig = math.Clamp( curPrintBig, 0, 999999 )
        draw.SimpleText( string.Comma( curPrintBig ) .. "AT", "GModRP_Printer_Big", -512 + 240 + 64, -8, Color( 255, 255, 255 ) )

        local health = self:GetPrinterHealth()
        if ( health < 20 && !self:GetOverheat() ) then
            surface.SetDrawColor( 255, 191, 36 )
            surface.SetMaterial( warningMat )
            surface.DrawTexturedRect( 400, 400, 240, 240 )
        end

        if ( self:GetOverheat() ) then
            surface.SetDrawColor( sineBetween( 200, 255, CurTime() * 2 ), 75, 75 )
            surface.SetMaterial( fireMat )
            surface.DrawTexturedRect( 400, 400, sineBetween( 240, 250, CurTime() * 8 ), sineBetween( 240, 250, CurTime() * 8 ) )
        end
    cam.End3D2D()

    pos, ang = self:LocalToWorld( Vector( 16.25, -15, 10 ) ), self:LocalToWorldAngles( Angle( 0, 90, 90 ) )
    cam.Start3D2D( pos, ang, 0.25 )
        surface.SetDrawColor( 51, 51, 51 )
        surface.DrawRect( 0, 0, 89, 20 )

        surface.SetDrawColor( 255, 220, 121 )
        surface.DrawRect( 0, 0, 89 * ( self:GetProgress() / 100 ), 20 )

        local color = Color( 255, 92, 66, 120 )
        if ( self:GetOn() ) then
            color = Color( 128, 255, 177, 120 )
        end
        if ( IsMouseOver( pos, ang, 0.25, 6, 24, 12, 12 ) ) then
            color = Color( color.r - 32, color.g - 32, color.b - 32, 120 )

            if ( LocalPlayer():KeyPressed( IN_USE ) ) then
                net.Start( "repix_AnimeTown_Printer_Power" )
                    net.WriteEntity( self )
                net.SendToServer()
            end
        end
        surface.SetDrawColor( color )
        surface.DrawRect( 6, 24, 12, 12 )

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( powerMat )
        surface.DrawTexturedRect( 8, 26, 8, 8 )
    cam.End3D2D()
end

local mat = Material( "phoenix_storms/metalset_1-2" )
function ENT:RenderOverride()
    self:DrawModel()

    render.MaterialOverride( mat )
    render.SetBlend( 0.8 )
        self:DrawModel()
    render.SetBlend( 1 )
    render.MaterialOverride()
end
