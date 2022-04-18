
-- ai отвечает за логику ИИ

ai = {}
ai.is_ready_to_go = false -- Готов ли ИИ сделать ход в данный момент
ai.wait_time = 0.5 -- Время ожидания перед тем, как сделать ход в секундах
ai.time = os.clock() -- Время, когда ИИ начал делать ход

-- Вспомогательная функция, которая возвращает, кто в данный момент является противником
function ai:getEnemy(player_now)
    if player_now == "cross" then
        return "zero"
    else
        return "cross"
    end
end

-- Вспомогательная функция, которая возвращает число, соответствующее крестику или нолику
function ai:nameToNum(player_name)
    if player_name == "cross" then
        return 1
    elseif player_name == "zero" then
        return 2
    end
end

--[[ 
    Если ИИ может сделать ход, который приведёт к победе, он его делает.
    Если такого хода нет, то ИИ проверяет, есть ли ход, в которм противник
    может выиграть, и если есть, то он ходит на это место, чтобы перекрыть
    этот ход противнку.
 ]]
function ai:makeWinStep()
    local map_check = field:make_map_copy()
    local win_blocks = {}
    local lose_blocks = {}

    for i = 1, field.size do
        for j = 1, field.size do
            if map_check[i][j] == 0 then
                local winner_check = ""


                map_check[i][j] = ai:nameToNum(game.step)
                winner_check = field:checkWin(map_check)
                if winner_check ~= "No winner" then
                    win_blocks[#win_blocks+1] = {}
                    win_blocks[#win_blocks].x = i
                    win_blocks[#win_blocks].y = j
                end

                map_check[i][j] = ai:nameToNum(ai:getEnemy(game.step))
                winner_check = field:checkWin(map_check)
                if winner_check ~= "No winner" then
                    lose_blocks[#lose_blocks+1] = {}
                    lose_blocks[#lose_blocks].x = i
                    lose_blocks[#lose_blocks].y = j
                end

                map_check[i][j] = 0
            end
        end
    end

    math.randomseed(os.clock())
    if #win_blocks > 0 then
        local block_choose = win_blocks[math.random(1, #win_blocks)]
        field:setBlock(block_choose.x, block_choose.y, game.step)
        return 1
    elseif #lose_blocks > 0 then
        local block_choose = lose_blocks[math.random(1, #lose_blocks)]
        field:setBlock(block_choose.x, block_choose.y, game.step)
        return 1
    else
        return 0
    end
    
end


--[[ 
    ИИ проверяет, наколько выгоден данный ход
 ]]
function ai:checkWinStep(map_in, player_win, player_now)
    local map_check = field:make_map_copy_general(map_in)
    local score = 0

    for i = 1, field.size do
        for j = 1, field.size do
            if map_check[i][j] == 0 then
                local winner_check = ""


                map_check[i][j] = ai:nameToNum(player_now)
                winner_check = field:checkWin(map_check)
                if winner_check ~= "No winner" then
                    if winner_check == player_win then
                        score = 1
                    else
                        score = -1
                    end
                end

                map_check[i][j] = 0
            end
        end
    end

    return score
    
end


--[[ 
    Рекурсивная функция, которая прощитывает несколько шагов наперёд и оценивает качество хода
 ]]
function ai:getScore(map_in, x, y, player_win, player_now, score_steps)
    local score = 0
    local map = field:make_map_copy_general(map_in)

    map[x][y] = ai:nameToNum(player_now)
    
    score = ai:checkWinStep(map, player_win, ai:getEnemy(player_now))

    if score_steps == 0 then
        return score
    else
        for i = 1, field.size do
            for j = 1, field.size do
                if map[i][j] == 0 then
                    score = score + ai:getScore(map, i, j, player_win, ai:getEnemy(player_now), score_steps-1)
                end
            end
        end
        
        return score
    end

end

--[[ 
    Продумать несколько ходов наперёд и сделать самый выгодный ход
 ]]
function ai:chooseBestStep(score_steps)
    local best_score = 0
    local best_steps = {}
    local possible_steps = {}

    for i = 1, field.size do
        for j = 1, field.size do
            if field.map[i][j] == 0 then
                possible_steps[#possible_steps+1] = {}
                possible_steps[#possible_steps].x = i
                possible_steps[#possible_steps].y = j
                possible_steps[#possible_steps].score = ai:getScore(field.map, i, j, game.step, game.step, score_steps)
            end
        end
    end

    best_score = possible_steps[1].score
    for i = 2, #possible_steps do
        if possible_steps[i].score > best_score then
            best_score = possible_steps[i].score
        end
    end

    for i = 1, #possible_steps do
        if possible_steps[i].score == best_score then
            best_steps[#best_steps+1] = {}
            best_steps[#best_steps].x = possible_steps[i].x
            best_steps[#best_steps].y = possible_steps[i].y
        end
    end

    local best_step = best_steps[math.random(1,#best_steps)]
    field:setBlock(best_step.x, best_step.y, game.step)
end

-- ИИ делает умный ход
function ai:stepSmart()

    --[[ 
        Если есть ходы, которые позволяют сразу победить, то
            Выбрать один из этих ходов
        Иначе если есть ходы, которые могут привести противника к победе, то
            Выбрать один из этих ходов, и тем самым перекрыть этот ход противнику
        Иначе
            Продумать несколько ходов на перёд и сделать самый выгодный ход
     ]]

    if ai:makeWinStep() == 0 then
        if field.size == 3 then
            ai:chooseBestStep(5)
        elseif field.size == 4 then
            ai:chooseBestStep(3)
        elseif field.size == 5 then
            ai:chooseBestStep(2)
        end
    end
    

end

function ai:startStep()
    ai.time = os.clock()
    ai.is_ready_to_go = false
end

function ai:wait()
    if os.clock() >= ai.time+ai.wait_time then
        ai.is_ready_to_go = true
    end
end