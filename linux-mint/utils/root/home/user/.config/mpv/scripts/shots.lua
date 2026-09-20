local is_chain = false

local function shot_and_next()
    if not is_chain then return end
    mp.command("screenshot video")
    mp.command("frame_step")
end

local function toggle_chain_shot()
    is_chain = not is_chain
    if is_chain then
        mp.osd_message("Ráfaga: INICIADA")
        mp.set_property_bool("pause", true)
        mp.register_event("tick", shot_and_next)
    else
        mp.osd_message("Ráfaga: DETENIDA")
        mp.unregister_event("tick", shot_and_next)
    end
end

mp.add_key_bind("k", "toggle_chain_shot", toggle_chain_shot)