--[[ 
    В объекте "draw" есть функции, которые позволяют отрисовывать крестики, нолики и игровую сетку.
    Внутри функций используются методы объектра "lg". 
    "lg" - это сокращение от love.graphics, которое записано в файле "main.lua"
    love.graphics - это модуль фреймфорка "Love2D", позволяющий отрисовывать графику.
    Докумментация по love.graphics https://love2d.org/wiki/love.graphics 
 ]]

draw = {}

--[[ 
    draw:cross - отрисовывает крестик
    x, y - координаты центра крестика
    width - ширина крестика
    color - цвет {r,g,b}
        r, g, b - дробные чиста от 0 до 1
]]
function draw:cross(x, y, width, color)
    width_half = width/2 

    lg.setLineStyle( "smooth" )
    lg.setLineWidth( width/5 )
    lg.setColor(color)
    lg.line(x-width_half, y-width_half, x+width_half, y+width_half)
    lg.line(x+width_half, y-width_half, x-width_half, y+width_half)
end


--[[ 
    Отрисовывает нолик
    x, y - координаты центра нолика
    width - ширина нолика
    color - цвет {r,g,b}
        r, g, b - дробные чиста от 0 до 1
]]
function draw:zero(x, y, width, color)
    lg.setLineWidth( width/5 )
    lg.setColor(color)
    lg.circle("line", x, y, width/2)
end

--[[ 
    Отрисовывает сетку игрового поля
    x, y - координаты центра сетки
    width - ширина сетки
    color - цвет {r,g,b}
        r, g, b - дробные чиста от 0 до 1
]]
function draw:fied_grid(x,y, width, color)
    lg.setColor(color)

    line_width = width/field.size/10
    line_height = width

    for i = 1, field.size-1 do
        -- Отрисовывание линий
        lg.rectangle(
            "fill",
            x-width*0.5+i*width/field.size-line_width/2,
            y-line_height/2,
            line_width,
            line_height
        )

        -- Отрисовывание столбцов
        lg.rectangle(
            "fill",
            x-line_height/2,
            y-width*0.5+i*width/field.size-line_width/2,
            line_height,
            line_width
        )
    end
end

return draw