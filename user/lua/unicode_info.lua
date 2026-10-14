--[[ 说明:
unicode_info 字符转Unicode码滤镜
2022年11月9日 Shitlime
2023年2月13日 飞梧 合并字集lua，显示单字字集及Unicode码
修改：UNICODE_RANGES 改为从同目录下的 Blocks_cn.txt 读取

使用步骤：
0. 将unicode_info.lua,Blocks_cn.txt文件放到lua文件夹下
1. 在方案 filters: 中添加: - lua_filter@*unicode_info
2. 在方案 switches: 中添加 uninfo 开关:
   - name: uninfo
     reset: 1
     states: [ ⓤ, Ⓤ ]

3. 将 Blocks_cn.txt 与本 lua 文件放在同一目录，
   格式: 起始码位..结束码位; 英文名 | 中文名
   示例: 0000..007F; Basic Latin | 基本拉丁文
]]

local config = {
    debug = false,
    format = "[{block} U+{hex}]",
    block_file = "Blocks_cn.txt",  -- 与本脚本同目录的数据文件名
}

-- 获取本脚本所在目录
local function get_script_dir()
    -- debug.getinfo(1, "S").source 形如 "@.../lua/unicode_info.lua"
    local src = debug.getinfo(1, "S").source
    if src:sub(1, 1) == "@" then
        src = src:sub(2)
    end
    -- 处理 Windows 路径中的反斜杠
    src = src:gsub("\\", "/")
    -- 取最后一个 / 之前的部分作为目录
    return src:match("^(.*)/") or "."
end

-- 从脚本同目录加载 Unicode 区块表
local function load_unicode_ranges(filename)
    local ranges = {}

    local path = get_script_dir() .. "/" .. filename
    local f = io.open(path, "r")
    if not f then
        if config.debug then
            log.error("unicode_info: 无法打开区块文件: " .. path)
        end
        return ranges
    end

    for line in f:lines() do
        -- 提取:  ^(\w+)\.\.(\w+);.+\| (.+)$
        --          起始hex   结束hex        中文名
        local s, e, name = line:match("^(%w+)%.%.(%w+);.+| (.+)$")
        if s and e and name then
            name = name:gsub("%s+$", "")  -- 去掉行尾空白
            ranges[#ranges + 1] = { tonumber(s, 16), tonumber(e, 16), name }
        end
    end
    f:close()

    -- 按起始码位排序，保证二分查找有效
    table.sort(ranges, function(a, b) return a[1] < b[1] end)

    if config.debug then
        log.info(string.format("unicode_info: 已从 %s 加载 %d 个区块", path, #ranges))
    end
    return ranges
end

local UNICODE_RANGES = load_unicode_ranges(config.block_file)

local function get_unicode_block(codepoint)
    local ranges = UNICODE_RANGES
    local low, high = 1, #ranges
    while low <= high do
        local mid = math.floor((low + high) / 2)
        local range = ranges[mid]
        if codepoint >= range[1] and codepoint <= range[2] then
            return range[3]
        elseif codepoint < range[1] then
            high = mid - 1
        else
            low = mid + 1
        end
    end
    return "未知"
end

local function unicode_info(input, env)
    local context = env.engine.context
    if not context then return end

    local uninfo = context:get_option("uninfo")
    if not uninfo then
        for cand in input:iter() do yield(cand) end
        return
    end

    for cand in input:iter() do
        local text = cand.text
        if utf8.len(text) == 1 then
            local codepoint = utf8.codepoint(text)
            local hex = string.format("%04X", codepoint)
            local block = get_unicode_block(codepoint)
            local comment = config.format
                :gsub("{block}", block)
                :gsub("{hex}", hex)
            yield(Candidate(
                cand.type, cand.start, cand._end, cand.text,
                cand.comment .. comment
            ))
        else
            yield(cand)
        end
    end
end

return unicode_info
