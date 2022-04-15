--[[
    Объект menu необходим для работы меню.
    Он позволяет насторить режим игры, размер поля и выбрать, кто игрет первым.
    В меню есть разные страницы, и на каждой странице есть кнопки, которые позволяют
    переключаться на другие страницы, настраивать и запускать игру.
]]
menu = {}
menu.page_now = "main" -- текущая страница

--[[ 
    Данная кнопка позволяет вернуться на страницу "main". 
    Она есть на любых страницах, кроме самой страницы "main".
]]
menu.btn_back = buttonCreate(10, 10, 50,image.btn_back)


--menu.pages - таблица, которая содержит все страницы
menu.pages = {}

--[[ 
    "main" - основная страница.
    На ней расположена кнопка выхода из игры и кнопка, позволяющая начать игру.
 ]]
menu.pages["main"] = {}
menu.pages["main"].buttons = {}
menu.pages["main"].buttons.play = buttonCreate(conf.window_width/2-125, 100, 250, image.btn_play)
menu.pages["main"].buttons.exit = buttonCreate(conf.window_width/2-125, 250, 250, image.btn_exit)
menu.pages["main"].update = function()
    if menu.pages["main"].buttons.play.is_mouse_up then -- Если нажата кнопка "Играть"
        menu.page_now = "gamemode" -- Перейти на страницу "gamemode"
    end

    if menu.pages["main"].buttons.exit.is_mouse_up then -- Если нажата кнопка "Выйти"
        le.quit() -- Выйти из игры
    end
end

--[[ 
    "gamemode" - страница, на которой выбирается режим игры
 ]]
menu.pages["gamemode"] = {}
menu.pages["gamemode"].buttons = {}
menu.pages["gamemode"].buttons.player_vs_ai     = buttonCreate(conf.window_width/2-200, 100, 400, image.btn_player_vs_ai)
menu.pages["gamemode"].buttons.player_vs_player = buttonCreate(conf.window_width/2-200, 200, 400, image.btn_player_vs_player)
menu.pages["gamemode"].buttons.ai_vs_ai         = buttonCreate(conf.window_width/2-200, 300, 400, image.btn_ai_vs_ai)
menu.pages["gamemode"].update = function()
    if menu.pages["gamemode"].buttons.player_vs_ai.is_mouse_up then 
        game.gamemode = "player_vs_ai" -- Установить режим игры "Игрок против ИИ"
    end

    if menu.pages["gamemode"].buttons.player_vs_player.is_mouse_up then 
        game.gamemode = "player_vs_player" -- Установить режим игры "Игрок против игрока"
        menu.page_now = "first_step" -- Перейти на страницу "first_step"
    end

    if menu.pages["gamemode"].buttons.ai_vs_ai.is_mouse_up then
        game.gamemode = "ai_vs_ai" -- Установить режим игры "ИИ против ИИ"
    end
end

--[[ 
    "first_step" - страница, на которой выбирается, кто будет играть первым
 ]]
menu.pages["first_step"] = {}
menu.pages["first_step"].buttons = {}
menu.pages["first_step"].buttons.cross = buttonCreate(conf.window_width/2-125, 100, 250, image.btn_cross)
menu.pages["first_step"].buttons.zero  = buttonCreate(conf.window_width/2-125, 200, 250, image.btn_zero)
menu.pages["first_step"].update = function()
    if menu.pages["first_step"].buttons.cross.is_mouse_up then
        game.first_step = "cross"     -- Первыми играют крестики
        menu.page_now = "field_size"  -- Перейти на страницу "field_size"
    end

    if menu.pages["first_step"].buttons.zero.is_mouse_up then
        game.first_step = "zero"      -- Первыми играют нолики
        menu.page_now = "field_size"  -- Перейти на страницу "field_size"
    end
end


--[[ 
    "field_size" - страница, на которой выбирается размер игрового поля
 ]]
menu.pages["field_size"] = {}
menu.pages["field_size"].buttons = {}
menu.pages["field_size"].buttons.field_3 = buttonCreate(conf.window_width/2-75, 100, 150, image.btn_3)
menu.pages["field_size"].buttons.field_4 = buttonCreate(conf.window_width/2-75, 200, 150, image.btn_4)
menu.pages["field_size"].buttons.field_5 = buttonCreate(conf.window_width/2-75, 300, 150, image.btn_5)
menu.pages["field_size"].update = function()
    if menu.pages["field_size"].buttons.field_3.is_mouse_up then
        field:setSize(3)        -- Установить размер поля 3x3
        menu.page_now = "game"  -- Перейти на страницу "game"
        game:start()
    end

    if menu.pages["field_size"].buttons.field_4.is_mouse_up then
        field:setSize(4)        -- Установить размер поля 4x4
        menu.page_now = "game"  -- Перейти на страницу "game"
        game:start()            -- Начать игру
    end

    if menu.pages["field_size"].buttons.field_5.is_mouse_up then
        field:setSize(5)        -- Установить размер поля 5x5
        menu.page_now = "game"  -- Перейти на страницу "game"
        game:start()            -- Начать игру
    end
end

--[[ 
    На странице "game" ничего нет. За логику и отрисовку игры отвечают файлы game.lua и field.lua
 ]]
menu.pages["game"] = {}
menu.pages["game"].update = function()
    --
end


-- menu:update() выполняется постоянно в файле main.lua
function menu:update()
    if menu.pages[menu.page_now] ~= nil then -- Если данная страница существует
        if menu.pages[menu.page_now].buttons ~= nil then -- Если на данной странице есть кнопки
            for _, button in pairs(menu.pages[menu.page_now].buttons) do
                button:update() -- Обновить состояние каждой кнопки на странице
            end
        end

        menu.pages[menu.page_now].update() -- выполнить функцию update у текущей страницы
    end


    if menu.page_now ~= "main" then -- Если текущая страница не равна "main"
        menu.btn_back:update()

        if menu.btn_back.is_mouse_up then
            menu.page_now = "main"  -- Перейти на страницу "main"
            game:stop() -- Остановить игру
        end
    end
end


-- menu:draw() выполняется постоянно в файле main.lua
function menu:draw()
    if menu.pages[menu.page_now] ~= nil then -- Если данная страница существует
        if menu.pages[menu.page_now].buttons ~= nil then -- Если на данной странице есть кнопки
            for _, button in pairs(menu.pages[menu.page_now].buttons) do
                button:draw() -- Отрисовать каждую кнопку на странице
            end
        end
    end

    -- Надписи для страниц, на которых настраивается игра
    lg.setColor(0, 0.9, 0)
    if menu.page_now == "gamemode" then
        lg.print("Выберите режим игры", 130, 50, 0, 1.25)
    elseif menu.page_now == "first_step" then
        lg.print("Кто ходит первым?", 145, 50, 0, 1.25)
    elseif menu.page_now == "field_size" then
        lg.print("Выберите размер игровго поля", 85, 50, 0, 1.25)
    end

    if menu.page_now ~= "main" then
        menu.btn_back:draw()
    end
end