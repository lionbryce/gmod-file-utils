file.WriteWithoutDirectories = file.WriteWithoutDirectories or file.Write

function file.Write(path, content)
    local chain = string.Split(path, "/") -- get them folders

    if #chain > 1 then
        local directory = table.concat(chain, "/", 1, #chain - 1) -- just the directory

        -- create the directory if it doesn't exist
        if not file.IsDir(directory, "DATA") then
            file.CreateDir(directory) -- luckily this accepts multiple folders
        end

        file.WriteWithoutDirectories(path, content)
    else
        file.WriteWithoutDirectories(path, content)
    end
end

file.UnsafeDelete = file.UnsafeDelete or file.Delete

-- Safely delete. IE: Gmod recycle bin
function file.Delete(name)
    local nameWithExtension = name
    name = string.StripExtension(name)
    local nameWithPath = "deleted_files/" .. name
    local fileContent = file.Read(nameWithExtension)
    if not fileContent then return end
    local i

    -- If it exists, get new name; name, name_1, name_2, etc
    while file.Exists(nameWithPath .. (i and ("_" .. i) or "") .. ".txt", "DATA") do
        if i and i >= 1000 then return end -- Loop limit; Can be removed, but it's staying 
        i = (i or 0) + 1
    end

    local useName = nameWithPath .. (i and ("_" .. i) or "") .. ".txt" -- I could've kept the variable of the string but it's not that bad
    file.Write(useName, fileContent) -- Write the backup
    if not file.Exists(useName, "DATA") then return print("Failed to write backup file while deleting the old file: " .. tostring(nameWithExtension) .. " ; file wasn't deleted") end
    -- Only deletes once we know the file exists, I could do a file.Read to compare but that would make sense
    file.UnsafeDelete(nameWithExtension)
end
