--  Main.lua - основной файл, который исполняется первым

--[[
    lg, lw, lm, le, la - это сокращения для модулей из фреймворка Love2D.
    Модули нужны для выполнения методов из Love2D, которые позволяют,
    например, отрисовывать графику, обрабатывать нажатия мыши, проигрывать звуки и т.д. 
    Докумментация по Love2D https://love2d.org/wiki/Main_Page
]]
lg = love.graphics
lw = love.window
lm = love.mouse
le = love.event
la = love.audio

require("config")
require("image")
require("sound")
require("button")
require("ai")
require("game")
require("menu")
require("field")
draw = require("draw")

math.randomseed(os.clock())

-- love.load() выполняется один раз при запуске программы
function love.load()
    
    -- Размер окна
    lw.setMode(conf.window_width, conf.window_height)

    -- Цвет заднего фона
    lg.setBackgroundColor(58/255, 151/255, 28/255)

    -- Загрузка шрифта, позволяющего отображать кириллицу
    lg.setFont(lg.newFont("fonts/Leto Text Sans Defect.otf", 20))
    

end

-- love.load() выполняется постоянно
function love.update()
    menu:update() -- menu.lua
    game:update() -- game.lua
end

-- love.draw() выполняется постоянно и отрисовывает элементы
function love.draw()
    
    menu:draw() -- menu.lua
    game:draw() -- game.lua
end