-- 以词定字
-- 原脚本 https://github.com/BlindingDark/rime-lua-select-character
-- 20230526195910 不再错误地获取commit_text，而是直接获取get_selected_candidate().text。
-- 20240128141207 重写：将读取设置移动到 init 方法中；简化中文取字方法；预先判断候选存在与否，无候选取 input；

local select = {}

function select.init(env)
    local config = env.engine.schema.config
    select.first_key = "bracketleft"
    select.last_key = "bracketright"
end

function select.func(key, env)
    local engine = env.engine
    local context = env.engine.context

    if
        not key:release()
        and (context:is_composing() or context:has_menu())
        and (select.first_key or select.last_key)
    then
        local text = context.input
        if context:get_selected_candidate() then
            text = context:get_selected_candidate().text
        end
        if utf8.len(text) > 1 then
            if (key:repr() == select.first_key) then
                engine:commit_text(text:sub(1, utf8.offset(text, 2) - 1))
                context:clear()
                return 1
            elseif (key:repr() == select.last_key) then
                engine:commit_text(text:sub(utf8.offset(text, -1)))
                context:clear()
                return 1
            end
        end
    end
    return 2
end

return select
