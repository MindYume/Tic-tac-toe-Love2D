menu = {}
menu.page = "main"
menu.btns_height = 30

menu.buttons = {}
menu.buttons.play             = buttonCreate("image", conf.window_width/2-125, 100, 250, image.btn_play)
menu.buttons.exit             = buttonCreate("image", conf.window_width/2-125, 250, 250, image.btn_exit)

menu.buttons.player_vs_ai     = buttonCreate("image", conf.window_width/2-200, 100, 400, image.btn_player_vs_ai)
menu.buttons.player_vs_player = buttonCreate("image", conf.window_width/2-200, 200, 400, image.btn_player_vs_player)
menu.buttons.ai_vs_ai         = buttonCreate("image", conf.window_width/2-200, 300, 400, image.btn_ai_vs_ai)

menu.buttons.cross            = buttonCreate("image", conf.window_width/2-125, 100, 250, image.btn_cross)
menu.buttons.zero             = buttonCreate("image", conf.window_width/2-125, 200, 250, image.btn_zero)

menu.buttons.field_3            = buttonCreate("image", conf.window_width/2-75, 100, 150, image.btn_3)
menu.buttons.field_4             = buttonCreate("image", conf.window_width/2-75, 200, 150, image.btn_4)
menu.buttons.field_5            = buttonCreate("image", conf.window_width/2-75, 300, 150, image.btn_5)

menu.buttons.back             = buttonCreate("image", 10, 10, 50,image.btn_back)



function menu:update()


    if menu.page == "main" then
        menu.buttons.play:update()
        menu.buttons.exit:update()

        if menu.buttons.play.is_mouse_up then
            menu.page = "gamemode"
        end

        if menu.buttons.exit.is_mouse_up then
            le.quit()
        end
    elseif menu.page == "gamemode" then

        menu.buttons.player_vs_ai:update()
        menu.buttons.player_vs_player:update()
        menu.buttons.ai_vs_ai:update()


        if menu.buttons.player_vs_ai.is_mouse_up then
            game.settings.gamemode = "player_vs_ai"
        end

        if menu.buttons.player_vs_player.is_mouse_up then
            game.settings.gamemode = "player_vs_player"
            menu.page = "first_step"
        end

        if menu.buttons.ai_vs_ai.is_mouse_up then
            game.settings.gamemode = "ai_vs_ai"
        end

    elseif menu.page == "first_step" then
        
        menu.buttons.cross:update()
        menu.buttons.zero:update()

        if menu.buttons.cross.is_mouse_up then
            game.settings.first_step = "cross"
            menu.page = "field_size"
        end

        if menu.buttons.zero.is_mouse_up then
            game.settings.first_step = "zero"
            menu.page = "field_size"
        end

    elseif menu.page == "field_size" then
        
        menu.buttons.field_3:update()
        menu.buttons.field_4:update()
        menu.buttons.field_5:update()

        if menu.buttons.field_3.is_mouse_up then
            field:setSize(3)
            menu.page = "game"
            game:start()
        end

        if menu.buttons.field_4.is_mouse_up then
            field:setSize(4)
            menu.page = "game"
            game:start()
        end

        if menu.buttons.field_5.is_mouse_up then
            field:setSize(5)
            menu.page = "game"
            game:start()
        end

    end

    if menu.page ~= "main" then
        menu.buttons.back:update()
        
        if menu.buttons.back.is_mouse_up then
            menu.page = "main"
            game:stop()
        end
    end
end

function menu:draw()
    if menu.page == "main" then

        menu.buttons.play:draw()
        menu.buttons.exit:draw()

    elseif menu.page == "gamemode" then

        lg.setColor(0,0.9, 0)
        lg.print("Выберите режим игры", 150, 50)

        menu.buttons.player_vs_ai:draw()
        menu.buttons.player_vs_player:draw()
        menu.buttons.ai_vs_ai:draw()

    elseif menu.page == "first_step" then

        lg.setColor(0,0.9, 0)
        lg.print("Кто ходит первым?", 165, 50)
        
        menu.buttons.cross:draw()
        menu.buttons.zero:draw()

        draw:cross(
            conf.window_width/2+160,
            130,
            40,
            {0.9, 0.1, 0}
        )

        draw:zero(
            conf.window_width/2+160,
            230,
            40,
            {0, 0.1, 0.9}
        )
    elseif menu.page == "field_size" then

        lg.setColor(0,0.9,0)
        lg.print("Выберите размер карты", 150, 50)
        
        menu.buttons.field_3:draw()
        menu.buttons.field_4:draw()
        menu.buttons.field_5:draw()

    end

    if menu.page ~= "main" then
        menu.buttons.back:draw()
    end
end