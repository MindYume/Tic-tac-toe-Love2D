draw = require("draw")


-- Объект field необходим для хранения состояния игрового поля, его отрисовки и проверки того, кто выиграл.

field = {}
field.size = 3 -- размер игрового поля

-- координаты последней ячейки, которая была нажата
field.block_last_x = 1 
field.block_last_y = 1

field.is_some_block_clicked = false -- была ли какая-то кнопка ячейки нажата

function field:load()

    -- координаты середины игрового поля
    field.x = conf.window_width/2
    field.y = conf.window_height/2

    field.width = 250              -- Ширина игрового поля
    field.block_width = field.width/field.size  -- Ширина одной ячейки
    field.block_width_part = field.width/field.size/2  -- Половина ширины одной ячейки
    
    -- Координаты от которых начинают отрисовываться ячейки. 
    field.first_block_x = field.x-field.width/2+field.block_width_part
    field.first_block_y = field.y-field.width/2+field.block_width_part


    --[[ 
        field.map - таблица, содержащая значения ячеек на игровом поле
        0 - пустая ячейка
        1 - крестик
        2 - нолик

        field.buttons - таблица, содержащая кнопки.
     ]]
    field.map = {}
    field.buttons = {}

    for i = 1, field.size do
        field.map[i] = {}
        field.buttons[i] = {}
        for j = 1, field.size do
            field.map[i][j] = 0
            field.buttons[i][j] = buttonCreate(

                field.first_block_x-field.block_width_part+(i-1)*field.block_width,
                field.first_block_y-field.block_width_part+(j-1)*field.block_width,
                field.block_width
            )
        end
    end
end
field:load()

-- Установить размер игрового поля
function field:setSize(size)
    field.size = size
    field:load()
end

-- Поставить крестик или нолик в ячейче, которая была нажата последней
function field:setLastBlock(block_type)
    if block_type == "cross" then
        field.map[field.block_last_x][field.block_last_y] = 1
    elseif "zero" then
        field.map[field.block_last_x][field.block_last_y] = 2
    end
end

-- Пуста ли последняя ячейка
function field:isLastBlockEmpty()
    if field.map[field.block_last_x][field.block_last_y] == 0 then
        return true
    else
        return false
    end
end

-- Все ли ячейки заполнены
function field:is_field_full()
    for i = 1, field.size do
        for j = 1, field.size do
            if field.map[i][j] == 0 then
                return false
            end
        end
    end

    return true
end


--[[ 
    Проверяет, заполнена ли линия крестиками или ноликами.
    0 - линия либо пуста, либо не все ячейки заполнены, либо на линии есть и крестики и нолики
    1 - линия заполнена крестиками
    2 - линия заполнена ноликами
 ]]
function field:checkLine(y)
    if field.map[1][y] ~= 0 then
        local frist_block = field.map[1][y]
        local is_line_full = true

        for i = 2, field.size do
            if field.map[i][y] ~= frist_block then
                is_line_full = false
                break
            end
        end

        if is_line_full then
            return frist_block 
        else
            return 0
        end
    else
        return 0
    end
end

--[[ 
    Проверяет, заполнен ли столбец крестиками или ноликами.
    0 - столбец либо пуст, либо не все ячейки заполнены, либо в столбце есть и крестики и нолики
    1 - столбец заполнен крестиками
    2 - столбец заполнен ноликами
 ]]
function field:checkColumn(x)
    if field.map[x][1] ~= 0 then
        local frist_block = field.map[x][1]
        local is_line_full = true

        for i = 2, field.size do
            if field.map[x][i] ~= frist_block then
                is_line_full = false
                break
            end
        end

        if is_line_full then
            return frist_block 
        else
            return 0
        end
    else
        return 0
    end
end

--[[ 
    Проверяет, заполнена ли первая диагональ крестиками или ноликами.
    0 - диагональ либо пуста, либо не все ячейки заполнены, либо на диагонали есть и крестики и нолики
    1 - диагональ заполнена крестиками
    2 - диагональ заполнена ноликами
 ]]
function field:checkDiagonal1()
    if field.map[1][1] ~= 0 then
        local frist_block = field.map[1][1]
        local is_line_full = true

        for i = 2, field.size do
            if field.map[i][i] ~= frist_block then
                is_line_full = false
                break
            end
        end

        if is_line_full then
            return frist_block 
        else
            return 0
        end
    else
        return 0
    end
end

--[[ 
    Проверяет, заполнена ли вторая диагональ крестиками или ноликами.
    0 - диагональ либо пуста, либо не все ячейки заполнены, либо на диагонали есть и крестики и нолики
    1 - диагональ заполнена крестиками
    2 - диагональ заполнена ноликами
 ]]
function field:checkDiagonal2()
    if field.map[field.size][1] ~= 0 then
        local frist_block = field.map[field.size][1]
        local is_line_full = true

        for i = 2, field.size do
            if field.map[field.size-i+1][i] ~= frist_block then
                is_line_full = false
                break
            end
        end

        if is_line_full then
            return frist_block 
        else
            return 0
        end
    else
        return 0
    end
end

--[[ 
    Проверяет выиграл ли какой-то игрок.
    "cross" - выиграли крестики
    "zero"  - выиграли нолики
    "No winner" - нет победителя
]]
function field:checkWin()
    local win_player = 0
    local is_some_player_win = false

    for i = 1, field.size do
        line_check = field:checkLine(i)
        if is_some_player_win == false and line_check ~= 0 then
            win_player = line_check
            is_some_player_win = true
        end

        column_check = field:checkColumn(i)
        if is_some_player_win == false and column_check ~= 0 then
            win_player = column_check
            is_some_player_win = true
        end
    end

    diagonal1_check = field:checkDiagonal1()
    if is_some_player_win == false and diagonal1_check ~= 0 then
        win_player = diagonal1_check
        is_some_player_win = true
    end

    diagonal2_check = field:checkDiagonal2()
    if is_some_player_win == false and diagonal2_check ~= 0 then
        win_player = diagonal2_check
        is_some_player_win = true
    end

    if is_some_player_win then
        if win_player == 1 then
            return "cross"
        elseif win_player == 2 then
            return "zero"
        end
    else
        return "No winner"
    end
end

-- Убирает со всех кнопок подстветку при наведении
function field:clearButtonsHovers()
    for i = 1, field.size do
        for j = 1, field.size do
            field.buttons[i][j].is_mouse_hover = false
        end
    end
end



function field:update()
    field.is_some_block_clicked = false

  
    for i = 1, field.size do
        for j = 1, field.size do
            field.buttons[i][j]:update() -- обновить состояние кнопки

            if field.buttons[i][j].is_mouse_up then -- Если кнопка была нажата, то
                field.is_some_block_clicked = true -- запонить то, что она была нажата
                field.block_last_x = i -- запонить её кооодинату x
                field.block_last_y = j -- запоинть её координату y
            end
        end
    end

end

function field:draw()

    -- Отрисовать все крестики и нолики, если они есть, а также кнопки.
    for i = 1, field.size do
        for j = 1, field.size do
            if field.map[i][j] == 1 then
                draw:cross(
                    field.first_block_x+(i-1)*field.block_width,
                    field.first_block_y+(j-1)*field.block_width,
                    field.block_width_part,
                    {0.9, 0.1, 0}
                )
            elseif field.map[i][j] == 2 then
                draw:zero(
                    field.first_block_x+(i-1)*field.block_width,
                    field.first_block_y+(j-1)*field.block_width,
                    field.block_width_part,
                    {0, 0.1, 0.9}
                )
            end

            field.buttons[i][j]:draw()
        end 
    end

    -- Отрисовать сетку игрового поля
    draw:fied_grid(field.x, field.y, field.width, {46/255, 119/255, 21/255})
end