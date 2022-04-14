function buttonCreate(mode, x, y, width, img)
    local obj = {}

    obj.x = x
    obj.y = y
    obj.width = width
    obj.is_mouse_hover = false
    obj.is_mouse_down = false
    obj.is_mouse_up = false

    if mode == "image" then
        obj.img = img
        obj.img_width = obj.img:getWidth()
        obj.height = obj.img:getHeight()*(obj.width/obj.img_width)
    elseif mode == "empty" then
         obj.height = width
    end

    function obj:update()
        obj.is_mouse_up = false

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

    function obj:draw()
        

        if mode == "image" then
            if obj.is_mouse_hover then
                lg.setColor(0.9, 0.9, 0.9)
            else
                lg.setColor(1, 1, 1)
            end

            lg.draw(obj.img, x, y, 0, obj.width/obj.img_width)
        elseif mode == "empty" then

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