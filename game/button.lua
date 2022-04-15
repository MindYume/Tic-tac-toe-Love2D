
--[[ 
    buttonCreate - позволяет создать кнопку
    x, y - координаты левого верхнего угла кнопки
    width - ширина кнопки
    img - изображение, которе будет отображаться внутри кнопки.
        Высота кнопки будет зависеть от высоты изображение.
        Высота кнопки = высота изображения * (ширина кнопки / ширина изображения)
        Если изображение не указано, то кнопка будет прозрачной, и её высота будет равна ей ширине

 ]]
function buttonCreate(x, y, width, img)
    local obj = {}

    obj.x = x
    obj.y = y
    obj.width = width
    obj.is_mouse_hover = false -- Наведён ли курсор на кнопку
    obj.is_mouse_down = false -- Нажата ли кнопка
    obj.is_mouse_up = false -- Была ли кнопка нажата и отпущена


    if type(img) ~= type(a) then
        obj.mode = "image"
        obj.img = img
        obj.img_width = obj.img:getWidth()
        obj.height = obj.img:getHeight()*(obj.width/obj.img_width)
    else
        obj.mode = "empty"
         obj.height = width
    end

    -- Обновляет состояние кнопки
    function obj:update()
        obj.is_mouse_up = false

        --[[ 
            lm.getX() - координата курсора по горизонтали
            lm.getY() - координата курсора по вертикали
            lm.isDown(1) - нажата ли левая кнопка мыши
        ]]
        if lm.getX() >= obj.x and 
            lm.getX() <= obj.x+obj.width and
            lm.getY() >= obj.y and 
            lm.getY() <= obj.y+obj.height
        then
            obj.is_mouse_hover = true
            if lm.isDown(1) then
                obj.is_mouse_down = true
            elseif obj.is_mouse_down then
                obj.is_mouse_up = true
                obj.is_mouse_down = false
            end
        else
            obj.is_mouse_hover = false
            obj.is_mouse_down = false
            obj.is_mouse_up = false
        end

    end

    -- Отрисовывает кнопку
    function obj:draw()

        if obj.mode == "image" then
            if obj.is_mouse_hover then
                lg.setColor(0.9, 0.9, 0.9)
            else
                lg.setColor(1, 1, 1)
            end

            lg.draw(obj.img, x, y, 0, obj.width/obj.img_width)
        elseif obj.mode == "empty" then

            if obj.is_mouse_hover then
                lg.setColor(0, 0, 0, 0.05)
            else
                lg.setColor(0, 0, 0, 0)
            end

            lg.rectangle("fill", x, y, obj.width, obj.height)
        end
    end

    return obj
end