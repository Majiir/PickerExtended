--- Data module
-- @module Data

Data = setmetatable({}, {__index = require 'stdlib/data/core'}) --luacheck: allow defined top

function Data.subgroup_order(data_type, name, subgroup, order)
    local data = data.raw[data_type] and data.raw[data_type][name]
    if data then
        data.subgroup = subgroup or data.subgroup
        data.order = order or data.order
    end
end

function Data.replace_icon(data_type, name, icon, size)
    local data = data.raw[data_type] and data.raw[data_type][name]
    if data then
        if type(icon) == "table" then
            data.icons = icon
            data.icon = nil
        else
            data.icon = icon
            data.icon_size = size or data.icon_size
        end
    end
end

function Data.get_icons(data_type, name, copy)
    local data = data.raw[data_type] and data.raw[data_type][name]
    return data and copy and table.deepcopy(data.icons) or data and data.icons
end

function Data.get_icon(data_type, name)
    local data = data.raw[data_type] and data.raw[data_type][name]
    return data and data.icon
end

--Quickly duplicate an existing prototype into a new one.
function Data.duplicate(data_type, orig_name, new_name, mining_result)
    mining_result = type(mining_result) == "boolean" and new_name or mining_result
    if data.raw[data_type][orig_name] then
        local proto = table.deepcopy(data.raw[data_type][orig_name])
        proto.name = new_name
        if mining_result then
            if proto.minable and proto.minable.result then
                proto.minable.result = mining_result
            end
        end
        if proto.place_result then
            proto.place_result = new_name
        end
        if proto.result then
            proto.result = new_name
        end
        return(proto)
    else
        error("Unknown Prototype "..data_type.."/".. orig_name )
    end
end

--Prettier monolith extracting
function Data.extract_monolith(filename, x, y, w, h)
    return {
        type = "monolith",

        top_monolith_border = 0,
        right_monolith_border = 0,
        bottom_monolith_border = 0,
        left_monolith_border = 0,

        monolith_image = {
            filename = filename,
            priority = "extra-high-no-scale",
            width = w,
            height = h,
            x = x,
            y = y,
        },
    }
end

function Data.create_sound(name, file_or_sound_table, volume)
    Data.fail_if_missing(name)
    Data.fail_if_missing(file_or_sound_table)
    local sound = {
        type = "explosion",
        name = name,
        animations = Data.empty_animations()
    }

    if type(file_or_sound_table) == "table" then
        sound.sound = file_or_sound_table
    else
        sound.sound = {
            filename = file_or_sound_table,
            volume = volume or 1
        }
    end
    data:extend{sound}
end

Data.select = require 'stdlib/data/modules/select'['select']

Data.Pipes = require 'stdlib/data/modules/pipes'
Data.Technology = require 'stdlib/data/modules/technology'
Data.Item = require 'stdlib/data/modules/item'
Data.Category = require 'stdlib/data/modules/category'
Data.Entity = require 'stdlib/data/modules/entity'
Data.Recipe = require 'stdlib/data/modules/recipe'

return Data