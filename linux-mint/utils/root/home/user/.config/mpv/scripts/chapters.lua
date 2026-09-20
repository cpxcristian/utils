local mp = require 'mp'
local utils = require 'mp.utils'

-- Función para añadir capítulos en la sesión actual
function add_chapter()
    local time = mp.get_property_number("time-pos")
    local chapters = mp.get_property_native("chapter-list")
    local title = "Marca_" .. os.date("%H%M%S")
    local titles = {
        "Summary",
        "Chapter",
        "ED"
    }

    if #chapters == 0 then
        table.insert(chapters, {title = "OP", time = tonumber("000000")})
    end
    print(utils.format_json(chapters))
    

    table.insert(chapters, {title = titles[#chapters], time = time})
    table.sort(chapters, function(a, b) return a.time < b.time end)
    print(utils.format_json(chapters))
    
    mp.set_property_native("chapter-list", chapters)
    mp.osd_message("Capítulo añadido: " .. mp.format_time(time))
end

-- Función para guardar los capítulos en un archivo físico (estilo PotPlayer)
function write_chapters()
    local path = mp.get_property("path")
    local working_dir = mp.get_property("working-directory")
    local directory, filename = utils.split_path(path)
    local f_final = filename:gsub("%.%w+$", "")
    local meta_path
    local chapters = mp.get_property_native("chapter-list")
    local duration = mp.get_property_number("duration")

    if directory == "./" or directory == "." then
        meta_path = utils.join_path(working_dir, f_final .. ".txt")
    else
        -- join_path es más seguro que ".." para manejar las barras /
        meta_path = utils.join_path(directory, f_final .. ".txt")
    end
    
    local file = io.open(meta_path, "w")
    if not file then 
        mp.osd_message("Error: No se puede escribir el archivo")
        return 
    end

    file:write(";FFMETADATA1\n\n")
    for i, chapter in ipairs(chapters) do
        file:write("[CHAPTER]\n")
        file:write("TIMEBASE=1/1000\n")
        file:write("START=" .. math.floor(chapter.time * 1000) .. "\n")
        if chapters[i+1] ~= nil then
            file:write("END=" .. math.floor(chapters[i+1].time * 1000) .. "\n")
        else
            file:write("END=" .. math.floor(duration * 1000) .. "\n")
        end
        file:write("title=" .. (chapter.title or "Capitulo") .. "\n\n")
    end
    file:close()
    mp.osd_message("Capítulos guardados en " .. f_final .. ".txt")
end

mp.add_key_binding("p", "add_chapter", add_chapter)
mp.add_key_binding("B", "write_chapters", write_chapters)

