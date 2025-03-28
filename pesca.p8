pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- ユかいへ barco de pesca con direcciれはn y generaciれはn continua de objetos

-- ユか⧗😐 variables principales
px = 40 -- posiciれはn del barco
py = 20 -- posiciれはn en el agua
water_level = 28 -- nivel del agua
flip_dir = false -- controla la direcciれはn del barco

-- ユか⧗😐 configuraciれはn del anzuelo
hook = {
    x = px+12, -- posiciれはn inicial alineada con la caれねa
    y = water_level,
    speed = 1,
    hooked = false,
    hooked_obj = nil -- guarda el objeto atrapado
}

-- ユか⧗😐 puntuaciれはn, animaciれはn y generaciれはn
score = 0
game_mode = 0 -- 0 = menれむ, 1 = juego
anim_time = 0 -- control de animaciれはn de peces
spawn_time = 0 -- control de generaciれはn de nuevos objetos
game_timer = 400

-- ユか⧗😐 lista de peces y basura
objects = {}

function _init()
    start_game()
end

function start_game()
    objects = {}
    score = 0
    hook.y = water_level
    hook.hooked = false
    hook.hooked_obj = nil -- reseteamos el objeto atrapado
    game_timer = 400
end

function add_object(x, y, tpe)
    local obj = {
        x = x,
        y = y,
        tpe = tpe, -- 0 = pez, 1 = basura
        caught = false,
        dir = rnd({-1,1}), -- direcciれはn inicial del pez o basura (-1 izquierda, 1 derecha)
        speed = rnd({0.5, 1}) -- velocidad aleatoria
    }
    -- si es un pez, inicializamos la animaciれはn con el sprite 48
    if tpe == 0 then
        obj.anim_frame = 48
        obj.caught_sprite = 50 -- pez atrapado cambia a sprite 50
    else
        -- si es basura, elegimos un sprite al azar de 51, 52 o 53
        obj.anim_frame = rnd({51,52,53})
        obj.caught_sprite = obj.anim_frame -- la basura mantiene su sprite al atraparse
    end
    add(objects, obj)
end

function spawn_objects()
    -- aparece un nuevo objeto cada 3 segundos aproximadamente
    spawn_time += 1
    if spawn_time > 20 then
        spawn_time = 0
        local tpe = rnd({0,1}) -- 0 = pez, 1 = basura
        local y = water_level + 10 + rnd(60) -- aparecen dentro del agua
        local x, dir

        -- aparecen a la izquierda o derecha y van en direcciれはn opuesta
        if rnd() > 0.5 then
            x = -8
            dir = 1
        else
            x = 128
            dir = -1
        end

        local obj = {
            x = x,
            y = y,
            tpe = tpe,
            caught = false,
            dir = dir,
            speed = rnd({0.5, 1})
        }

        if tpe == 0 then
            obj.anim_frame = 48
            obj.caught_sprite = 50
        else
            obj.anim_frame = rnd({51,52,53})
            obj.caught_sprite = obj.anim_frame
        end

        add(objects, obj)
    end
end

function _update()
    if game_mode == 0 then
        -- ユか⧗う si estamos en el menれむ, esperar a que el jugador presione 🅾️
        if btnp(4) then
            start_game()
            game_mode = 1
        end
    elseif game_mode == 2 then
        -- si el juego terminれは, presionar 🅾️ para volver al menれむ
        if btnp(4) then
            game_mode = 0
        end 
    else
        game_timer -= 1
        if game_timer <= 0 then
            game_mode = 2 -- cambiar a pantalla de game over
        end
        -- movimiento del barco con flip
        if btn(0) then 
            px = max(0, px - 1.5)
            flip_dir = true -- mirando a la izquierda
        end
        if btn(1) then 
            px = min(120, px + 1.5)
            flip_dir = false -- mirando a la derecha
        end
        
        -- ajustar el anzuelo a la posiciれはn de la caれねa
        hook.x = px + 14

        -- movimiento del anzuelo
        if not hook.hooked then
            if btn(2) then hook.y = max(water_level, hook.y - hook.speed) end
            if btn(3) then hook.y = min(120, hook.y + hook.speed) end
        else
            -- si el anzuelo estれく atrapando algo, hacer que suba
            hook.y = max(water_level, hook.y - 2) 
            
            -- hacer que el objeto atrapado suba con el anzuelo
            if hook.hooked_obj then
                hook.hooked_obj.y = hook.y
            end

            -- cuando el objeto llega al nivel del agua, desaparece
            if hook.y == water_level then
                if hook.hooked_obj then
                    del(objects, hook.hooked_obj) -- eliminamos el objeto
                    hook.hooked_obj = nil -- limpiamos la referencia
                end
                hook.hooked = false
            end
        end

        -- animaciれはn de los peces (cambia cada 15 frames)
        anim_time += 1
        if anim_time > 15 then
            anim_time = 0
            for obj in all(objects) do
                if obj.tpe == 0 and not obj.caught then
                    obj.anim_frame = (obj.anim_frame == 48) and 49 or 48
                end
            end
        end

        -- movimiento de los peces y la basura
        for obj in all(objects) do
            if not obj.caught then
                obj.x += obj.speed * obj.dir
                -- cambiar direcciれはn si toca los bordes
                if obj.x < -10 or obj.x > 130 then
                    del(objects, obj) -- eliminar objetos que salgan de la pantalla
                end
            end
        end

        -- generaciれはn continua de peces y basura
        spawn_objects()

        -- detecciれはn de colisiones con peces o basura
        for obj in all(objects) do
            if not obj.caught and collide(hook, obj) then
                obj.caught = true
                hook.hooked = true
                hook.hooked_obj = obj -- guardamos el objeto atrapado
                
                -- cambiar sprite segれむn si es un pez o basura
                obj.anim_frame = obj.caught_sprite 

                if obj.tpe == 0 then
                    score += 10
                else
                    score -= 5
                end
            end
        end
    end
end

function collide(a, b)
    return abs(a.x - b.x) < 4 and abs(a.y - b.y) < 4
end

function _draw()
    cls()
    
    -- dibuja el agua
    rectfill(0, water_level, 128, 128, 12)

    -- ユかいへ dibuja el barco con direcciれはn correcta
    spr(1, px, water_level - 8, 1, 1)
    spr(2, px+8, water_level - 8, 1, 1)
    spr(3, px+4, water_level - 12, 1, 1)
    spr(4, px+10, water_level - 10, 1, 1)

    -- ユか🅾️こ dibuja la punta de la caれねa
    spr(5, px+14, water_level - 10)

    -- ユかちけ dibuja la lれとnea de la caれねa hasta el anzuelo
    line(px+16, water_level-8, hook.x+4, hook.y, 6)

    -- ユか🅾️こ dibuja el anzuelo
    spr(33, hook.x, hook.y)

    -- ユか…か dibujar peces y basura con animaciれはn correcta
    for obj in all(objects) do
        spr(obj.anim_frame, obj.x, obj.y, 1, 1, obj.dir == -1)
    end
    
    local segundos = flr((game_timer % 1800) / 30) -- cada 30 frames = 1 segundo
    print("tiempo: "..segundos.."s", 2, 8, 7)
    
    -- ユか◆● puntuaciれはn
    print("puntos: "..score, 2, 2, 7)
    
    if game_mode == 0 then
        -- mensaje centrado en la pantalla
        print("⬅️➡️ mover   ⬆️⬇️ cana", 20, 55, 7)
        print("🅾️ para pescar", 40, 70, 7)
    end

    if game_mode == 2 then
        print("tiempo terminado!", 20, 40, 8)
        print("puntuacion final: " .. score, 30, 60, 7)
        print("🅾️ para volver al menu", 20, 80, 6)
        return
    end
end

__gfx__
0000000000000000000000000110000000000000770000000c000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000001100000000004470000000c0c00000000000000000000000000000000000000000000000000000000000000000000000000000
0070070001010010000000000012210000000400707000000c000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000091901010000000000211111000040000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700001110100000000000111ffe0000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700991110000000009911efff00004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000004999999999999400ee110f0040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004444444444440000111100400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001100000011000088000044400000662266003000000007700000000000000000000000000000000000000000000000000000000000000000000000000000
88088880080888800818810024400000662260003333000067700000000000000000000000000000000000000000000000000000000000000000000000000000
88888818088888181888800059600000662260003033330066770000000000000000000000000000000000000000000000000000000000000000000000000000
08888888088888881888100044444000662266003300330000677700000000000000000000000000000000000000000000000000000000000000000000000000
88081880080818800888810020224000000000600333030000066700000000000000000000000000000000000000000000000000000000000000000000000000
00001010000100010088000000000000000000060033300000066000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000880800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
