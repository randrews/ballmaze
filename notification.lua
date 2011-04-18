function LM.coroutine_wrap(fn, loop)
    local co = coroutine.create(fn)

    return function(userinfo)
        if loop and coroutine.status(co) == "dead" then
            co = coroutine.create(fn)
        end

        local success, name, userinfo = coroutine.resume(co, userinfo)

        if name then
            LM.post_notification(name, (userinfo or {}))
        end
    end
end

LM.observe_notification("buttonClicked", LM.coroutine_wrap(function(userinfo)
        local msg
        msg = coroutine.yield("setLabelText", {text = 1})
        print(msg)
        msg = coroutine.yield("setLabelText", {text = 2})
        print(msg)
        return "setLabelText", {text = 3}
    end, true))

map_tbl = {}
for i = 0,99 do map_tbl[i] = " " end

for i = 40,49 do map_tbl[i] = "#" end

map_tbl[45] = " "
map_tbl[30] = "\\"
map_tbl[39] = "/"

map_tbl[0] = "*"
map_tbl[9] = "*"
map_tbl[90] = "*"
map_tbl[99] = "*"

map_str = map_tbl[0] .. table.concat(map_tbl)

LM.post_notification("setMap", {map = map_str})

LM.observe_notification("hoverOverTile", function(tile)
    print("hover", tile.x, tile.y)

    LM.post_notification("addPiece", {name="preview", x=tile.x, y = -1})
end)

LM.observe_notification("clickTile", function(tile)
    print("click", tile.x, tile.y)

    if(tile.y ~= -1) then
        -- LM.post_notification("addPiece", {name="actual", x=tile.x, y=-1})
        LM.post_notification("movePiece", {name="preview", x=tile.x, y=tile.y})
    end
end)

-- LM.post_notification("addPiece",{name="foo", x=3, y=-1})