local proned = false 
proneKey = 0x4CC0E2FE -- B (The button for switching to the lying position and back)
standKey = 0x26E9DC00 -- Z (This button is needed by those who have a hotkey to cancel all animations)

local LBM = 0x07CE1E61 
local RBM = 0xF84FA74F 
local moveDir = {fwd = false, bwd = false, lft = false, rht = false}

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local ped = PlayerPedId()
		if (DoesEntityExist(ped) and not IsPedDeadOrDying(ped)) then 
			ProneMovement()
			DisableControlAction(0, proneKey, true) 
			if (not IsPauseMenuActive()) then 
				if (IsDisabledControlJustPressed(0, proneKey) and not IsPedInAnyVehicle(ped, true) and not IsPedFalling(ped) and not IsPedDiving(ped) and not IsPedInCover(ped, false) and not IsEntityInWater(ped) and not Citizen.InvokeNative(0xA911EE21EDF69DAF, ped)) then -- Various kinds of checks
                    if proned then
						TaskPlayAnimAdvanced(PlayerPedId(), "mech_crawl@base", "stealth2idle", GetEntityCoords(PlayerPedId()), 0.0, 0.0, GetEntityHeading(PlayerPedId()), 1.0, -1.0, 1500, 0, 0, 0, 0)
						proned = false
					elseif not proned then
						RequestAnimDict("mech_crawl@base")
						while not HasAnimDictLoaded("mech_crawl@base") do
							Citizen.Wait(100)
						end
                        if (not IsControlPressed(2, LBM) and not IsControlPressed(2, RBM)) then
						ClearPedTasks(ped)
						proned = true
                        SwitchToUnarmed()
						SetProned()
                        end
					end
				end
                if (IsDisabledControlJustPressed(0, standKey) and proned) then
                    TaskPlayAnimAdvanced(PlayerPedId(), "mech_crawl@base", "stealth2idle", GetEntityCoords(PlayerPedId()), 0.0, 0.0, GetEntityHeading(PlayerPedId()), 1.0, -1.0, 1500, 0, 0, 0, 0)
                    proned = false 
                end                
			end
            if (IsPlayerFreeAiming(PlayerPedId()) or proned) then
                DisablePlayerFiring(PlayerPedId(), true)
            end
		else
			proned = false
		end
	end
end)

function SetProned()
	ped = PlayerPedId()
	ClearPedTasks(ped)
	TaskPlayAnimAdvanced(PlayerPedId(), "mech_crawl@base", "idle2stealth", GetEntityCoords(PlayerPedId()), 0.0, 0.0, GetEntityHeading(PlayerPedId()), 1.0, -1.0, -1, 2, 0 , 0 , 0 )
end

function SwitchToUnarmed()
	GiveWeaponToPed_2(PlayerPedId(), `WEAPON_UNARMED`, 0, true, false, 0, false, 0.5, 1.0, 0, false, 0.0, false)
end

function ProneMovement()
    if proned then
        local ped = PlayerPedId()
        DisableControlAction(0, 0xB2F377E8)
        DisableControlAction(0, 0x8FFC75D6)
        DisableControlAction(0, 0xF3830D8E)
        if IsEntityInWater(ped) then
            ClearPedTasks(ped)
            proned = false
        end
        if IsControlPressed(0, 0x8FD015D8) or IsControlPressed(0, 0xD27782E3) then
            DisablePlayerFiring(ped, true)
        elseif IsControlJustReleased(0, 0x8FD015D8) or IsControlJustReleased(0, 0xD27782E3) then
            DisablePlayerFiring(ped, false)
        end

        if IsControlJustPressed(0, 0xB4E465B4) or IsControlJustPressed(0, 0x7065027D) then
            moveDir.fwd = false
            moveDir.bwd = false
        end
        --Control keys--
        if IsControlJustPressed(0, 0x8FD015D8) and not moveDir.fwd then -- W
            moveDir.fwd = true
            TaskPlayAnimAdvanced(ped, "mech_crawl@base", "run", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 1, 1.0, 0, 0)

        elseif IsControlJustReleased(0, 0x8FD015D8) and moveDir.fwd then
            TaskPlayAnimAdvanced(ped, "mech_crawl@base", "run", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 2, 1.0, 0, 0)
            moveDir.fwd = false
        end

        if IsControlJustPressed(0, 0xD27782E3) and not moveDir.bwd then -- S
            moveDir.bwd = true
            TaskPlayAnimAdvanced(ped, "mech_crawl@base", "idle_turn_r_180", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 1, 1.0, 0, 0)

        elseif IsControlJustReleased(0, 0xD27782E3) and moveDir.bwd then
            TaskPlayAnimAdvanced(ped, "mech_crawl@base", "idle_turn_r_180", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 2, 1.0, 0, 0)
            moveDir.bwd = false
        end

        if IsControlJustPressed(0, 0x7065027D) and not moveDir.lft then -- A
            moveDir.lft = true
            TaskPlayAnimAdvanced(ped, "mech_crawl@base", "run_turn_l3", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 1, 1.0, 0, 0)

        elseif IsControlJustReleased(0, 0x7065027D) and moveDir.lft then
            TaskPlayAnimAdvanced(ped, "mech_crawl@base", "run_turn_l3", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 2, 1.0, 0, 0)
            moveDir.lft = false
        end

        if IsControlJustPressed(0, 0xB4E465B4) and not moveDir.rht then -- D
            moveDir.rht = true
            TaskPlayAnimAdvanced(ped, "mech_crawl@base", "run_turn_r3", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 1, 1.0, 0, 0)

        elseif IsControlJustReleased(0, 0xB4E465B4) and moveDir.rht then
            TaskPlayAnimAdvanced(ped, "mech_crawl@base", "run_turn_r3", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 2, 1.0, 0, 0)
            moveDir.rht = false
        end
    end
end
