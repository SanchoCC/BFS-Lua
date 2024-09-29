local function readMaze(filename)
    local maze = {}
    local file = io.open(filename, "r")
    
    if not file then
        error("Could not open read file " .. filename)
    end
    
    for line in file:lines() do
        local row = {}
        for char in line:gmatch(".") do
            table.insert(row, char)
        end
        table.insert(maze, row)
    end
    
    file:close()
    return maze
end

local function writeMaze(filename, maze)
    local file = io.open(filename, "w")
    
    if not file then
        error("Could not open write file " .. filename)
    end
    
    for _, row in ipairs(maze) do
        file:write(table.concat(row) .. "\n")
    end
    
    file:close()
end

local function findSymbol(maze, symbol)
    local symbols = {}
    for i = 1, #maze do
        for j = 1, #maze[i] do
            if maze[i][j] == symbol then
                table.insert(symbols, {i,j})
            end
        end
    end
    if not symbols then
    return nil
    end
    return symbols
end

local function bfs(maze, start_i, start_j, end_i, end_j)
    local directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    local queue = {{start_i, start_j}}
    local visited = {}
    
    for i = 1, #maze do
        visited[i] = {}
    end

    while #queue > 0 do
        local current = table.remove(queue, 1)
        local i, j = current[1], current[2]
        
        if i == end_i and j == end_j then
            local path = {}
            visited[start_i][start_j] = nil 
            table.insert(path, {end_i, end_j})
            while visited[i][j] do
                local previous = visited[i][j]
                table.insert(path, {previous[1], previous[2]})
                i, j = previous[1], previous[2]
            end
            return path
        end
        
        for _, direction in ipairs(directions) do
            local ni, nj = i + direction[1], j + direction[2]
                       
            if ni > 0 and nj > 0 and ni <= #maze and nj <= #maze[i] 
            and maze[ni] and maze[ni][nj] ~= '0' and not visited[ni][nj] then
                visited[ni][nj] = {i, j}
                table.insert(queue, {ni, nj})
            end
        end
    end
    return nil
end

local function markPath(maze, path)
    for _, pos in ipairs(path) do
        local i, j = pos[1], pos[2]
        if maze[i][j] ~= 'E' and maze[i][j] ~= 'I' then
            maze[i][j] = '*'
        end
    end
end

local function solveMaze(inputFile, outputFile)
    local maze = readMaze(inputFile)
    local start_i, start_j = {},{}
    start_i, start_j = findSymbol(maze, 'I')[1], findSymbol(maze, 'I')[2]
    local end_i, end_j = {},{}
    end_i, end_j = findSymbol(maze, 'E')[1], findSymbol(maze, 'E')[2]
    
    if not (start_i and start_j and end_i and end_j) then
        print("Start or end symbol not found in maze")       
        return nil; 
    end
    
    local path = {}
    for i_start = 1, #start_i do
        for j_start = 1, #start_j do  
            for i_end = 1, #start_i do
                for j_end = 1, #start_j do  
    talbe.insert(path, bfs(maze, start_i[i_start], start_j[j_start], end_i[end_i], end_j[end_j])) 
    end
    end
    end
    end
    for i = 1, #path do
    if path[i] then
        markPath(maze, path)
        writeMaze(outputFile, maze)
        print("Path found and saved to " .. outputFile)
    else
        print("No path found from I to E")
    end
end
end

solveMaze("Maze.txt", "Output.txt")
