-- This is not exactly where it should be, but it has something to do with adminning
-- so let it be there, alright?

DemoteProcess = DemoteProcess or {
    Caller = "", Victim = "", VictimJob = "", Reason = "", Show = false, HideIn = 0
}

net.Receive( "repix_AnimeTown_Demote", function()
    local caller = net.ReadString()
    local victim = net.ReadString()
    local job = net.ReadString()
    local reason = net.ReadString()

    DemoteProcess = {
        Caller = caller, Victim = victim, VictimJob = job, Reason = reason, Show = true, HideIn = CurTime() + 15
    }

    surface.PlaySound( "common/warning.wav" )
end )

surface.CreateFont( "AT_DemoteProcess", { font = "Rubik Medium", size = 15, weight = 500, extended = true } )

local baseMat = Material( "repix/animetown/hud/demote.png" )
hook.Add( "HUDPaint", "repix_AnimeTown_Demote", function()
    if ( DemoteProcess.Show ) then
        if ( DemoteProcess.HideIn < CurTime() ) then
            DemoteProcess.Show = false
        end

        local x, y  = ScrW() - baseMat:Width() + 2, 391
        surface.SetMaterial( baseMat )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawTexturedRect( x, y, baseMat:Width(), baseMat:Height() )

        local text = "%s хочет уволить %s (%s)\nПричина: %s"
        text = string.format( text, DemoteProcess.Caller, DemoteProcess.Victim, DemoteProcess.VictimJob, DemoteProcess.Reason )
        draw.DrawText( text, "AT_DemoteProcess", x + 30, y + 10, Color( 255, 255, 255 ) )

        if ( input.IsKeyDown( KEY_F6 ) || input.IsKeyDown( KEY_F7 ) ) then
            DemoteProcess.Show = false
        end
    end
end )
