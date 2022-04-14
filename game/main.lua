lg = love.graphics
lw = love.window
lm = love.mouse
le = love.event

require("config")
require("image")
require("button")
require("game")
require("menu")
require("field")
draw = require("draw")




-- love.load() выполняется один раз при запуске программы
function love.load()
    
    lw.setMode(conf.window_width, conf.window_height)
    lg.setBackgroundColor(58/255, 151/255, 28/255)
    lg.setFont(lg.newFont("fonts/Leto Text Sans Defect.otf", 20))
    

end

function love.update()
    menu:update()
    game:update()
end

-- love.draw() выполняется постоянно и отрисовывает элементы
function love.draw()
    --lg.print("Hello World")
    --draw:cross(150, 150, 100, {23/255, 198/255, 28/255})
    --draw:zero(150, 150, 100, {97/255 ,206/255, 15/255})
    --lg.print("test");
    --field:draw(150,150,200)
    menu:draw()
    game:draw()
    --lg.draw(image.btn_exit)
end