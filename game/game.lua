-- game отвечает за основную логику игры

game = {}

--[[ 
    game.gamemode - режим игры
        "player_vs_ai"     - игрок против ИИ
        "player_vs_player" - игрок против игрока
        "ai_vs_ai"         - ИИ против ИИ
 ]]
game.gamemode = "player_vs_player"

--[[ 
    game.first_step - игрок, который ходит первым
        "cross"     - первыми ходят крестики
        "zero"      - первыми ходят нолики
 ]]
game.first_step = "cross" 
game.is_ai_frist_step = false

game.is_aiStep = false -- ходит ли в данный момент ИИ
game.is_started = false   -- запущена ли игра
game.is_game_over = false -- Закончилась ли игра
game.step = "cross"       -- Игрок, который ходит в данный момент 

--[[ 
    game.winner - победитель
        "cross"     - победили крестики
        "zero"      - победили нолики
        "No winner" - ничья
 ]]
game.winner = "No winner" 

--[[ 
    game.btn_again - кнопка, которая позволяет начать игру заного.
    Появляется только после того, как игра окончена
 ]]
game.btn_again = buttonCreate(conf.window_width/2-125, 400, 250, image.btn_again)

-- Начать игру
function game:start()
    game.is_game_over = false
    game.winner = "No winner"
    game.is_started = true
    game.is_aiStep = game.is_ai_frist_step
    game.step = game.first_step

    if game.is_aiStep then
        ai:startStep()
    end
end

-- Закончить игру
function game:stop()
    game.is_started = false
end

-- Сделать ход за игрока
function game:player_step()
    if field.is_some_block_clicked and field:isLastBlockEmpty() then -- Если нажата какая-то кнопка на игровом поле, и ячейка на месте этой кнопки пустая
        field:setLastBlock(game.step) -- Поставить на месте этой ячейки крестик или нолик. Зависит от того, кто ходит

        -- Передать ход другому игроку
        if game.step == "cross" then
            game.step = "zero"
        elseif game.step == "zero" then
            game.step = "cross"
        end

        if game.gamemode == "player_vs_ai" then
            game.is_aiStep = true
            ai:startStep()
        end


        game.winner = field:checkWin(field.map) -- Есть ли победитель
        if game.winner ~= "No winner" or field:is_field_full() then -- Если есть победитель или если поле уже заполнено
            game.is_game_over = true
            field:clearButtonsHovers() -- Убрать подсветку при наведении мыши с кнопок на игровом поле
        end
    end
end

-- Сделать ход за ИИ
function game:aiStep()

    if ai.is_ready_to_go then -- Если ИИ готов сделать ход

        ai:stepSmart()

        -- Передать ход другому игроку
        if game.step == "cross" then
            game.step = "zero"
        elseif game.step == "zero" then
            game.step = "cross"
        end

        if game.gamemode == "player_vs_ai" then
            game.is_aiStep = false
        end

        if game.gamemode == "ai_vs_ai" then
            ai:startStep()
        end

        game.winner = field:checkWin(field.map) -- Есть ли победитель
        if game.winner ~= "No winner" or field:is_field_full() then -- Если есть победитель или если поле уже заполнено
            game.is_game_over = true
            field:clearButtonsHovers() -- Убрать подсветку при наведении мыши с кнопок на игровом поле
        end
        
    else
        ai:wait() -- Ждать пока ИИ не будет готов сделать ход
    end
end

-- game:update() выполняется постоянно в файле main.lua
function game:update()
    if game.is_started then -- Если игра началась
        if game.is_game_over then -- Если игра окончена
            game.btn_again:update()

            if game.btn_again.is_mouse_up then -- Если нажата кнопка "Играть ещё раз"
                field:load() -- Обнулить ячейки на игровом поле
                game:start() -- Начать новую игру
            end
        else -- Если игра идёт
            field:update() -- Обновить состояние поля и его кнопок

            if game.gamemode == "player_vs_player" then

                game:player_step()

            elseif game.gamemode == "player_vs_ai" then

                if game.is_aiStep then
                    game:aiStep()
                else
                    game:player_step()
                end

            elseif game.gamemode == "ai_vs_ai" then
                game:aiStep()
            end
        end
        
    end
    
end


-- game:draw() выполняется постоянно в файле main.lua
function game:draw()
    if game.is_started then -- Если игра началась

        field:draw() -- Отрисовать игровое поле
        if game.is_game_over then -- Если игра окончена
            if game.winner == "cross" then
                lg.setColor(0.9, 0, 0)
                lg.print("Крестики победили!", 140, 50, 0, 1.25)
            elseif game.winner == "zero" then
                lg.setColor(0, 0, 0.9)
                lg.print("Нолики победили!", 145, 50, 0, 1.25)
            elseif game.winner == "No winner" then
                lg.setColor(0, 0.9, 0)
                lg.print("Ничья!", 215, 50, 0, 1.25)
            end

            game.btn_again:draw()
        else -- Если игра идет
            if game.step == "cross" then
                lg.setColor(0.9, 0, 0)
                lg.print("Ходят крестики", 75, 20)
            elseif game.step == "zero" then
                lg.setColor(0, 0, 0.9)
                lg.print("Ходят нолики", 75, 20)
            end
        end

    end

end