game = {}

game.settings = {}
game.settings.gamemode = "player_vs_player"
game.settings.first_step = "cross"
game.is_started = false
game.is_game_over = false
game.step = "cross"
game.winner = "No winner"
game.btn_again = buttonCreate("image", conf.window_width/2-125, 400, 250, image.btn_again)

function game:start()
    game.is_game_over = false
    game.winner = "No winner"
    game.is_started = true
    game.step = game.settings.first_step
end

function game:stop()
    game.is_started = false
end

function game:update()
    if game.is_started then
        if game.is_game_over then
            game.btn_again:update()

            if game.btn_again.is_mouse_up then
                field:load()
                game:start()
            end
        else
            field:update()

            if field.is_some_block_clicked and field:isLastBlockEmpty() then
                field:setLastBlock(game.step)

                if game.step == "cross" then
                    game.step = "zero"
                elseif game.step == "zero" then
                    game.step = "cross"
                end

                game.winner = field:checkWin()
                if game.winner ~= "No winner" or field:is_field_full() then
                    game.is_game_over = true
                    field:clearButtonsHovers()
                end
            end
        end
        
    end
    
end

function game:draw()
    if game.is_started then

        field:draw()
        if game.is_game_over then
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
        else
            if game.step == "cross" then
                lg.setColor(0.9, 0, 0)
                lg.print("Ходят крестики", 75, 20)
            elseif game.step == "zero" then
                lg.setColor(0, 0, 0.9)
                lg.print("Ходят нолики", 75, 20)
            end
        end

    end


    --lg.setColor(1, 1, 1)
   -- lg.print(game.winner, 150, 0, 0, 1.25)
end