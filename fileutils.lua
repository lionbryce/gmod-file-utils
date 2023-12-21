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
function file.Delete(path)
    local fileContent = file.Read(path)
    if not fileContent then return end -- file doesn't exist
	
    local originalPath = path
	local ext = "." .. string.GetExtensionFromFilename(path)
    path = string.StripExtension(path)	
    path = "deleted_files/" .. path
	

	if file.Exists(path .. ext, "DATA") then
		path = path .. "_" .. os.time() -- unlikely that you deleted 2 files in the same second
		if file.Exists(path .. ext, "DATA") then -- if it does exist, add a number
			path = path .. "_" -- doing this here to avoid 1 extra concat per loop

			local i = 1
			while file.Exists(path .. i .. ext, "DATA") do
				i = i + 1
			end
			path = path .. i
		end
	end

	path = path .. ext
    file.Write(path, fileContent)
	
    if not file.Exists(path, "DATA") then return print("Failed to write backup file while deleting the old file: " .. tostring(originalPath) .. " ; file wasn't deleted") end
    -- Only deletes once we know the file exists, I could do a file.Read to compare but that would make sense
    file.UnsafeDelete(originalPath)
	return fileContent, path
end

-- do -- tests
-- 	print("Running filelib tests")
-- 	local paths = {}
-- 	local path = "filelibtest/test.txt"
-- 	for i=1,10 do -- create & delete 10 copies
-- 		file.Write(path, "TEST" .. i .. "TEST")
-- 		assert(file.Read(path) == "TEST" .. i .. "TEST", "Failed to write file")
-- 		paths[i] = {file.Delete(path)}
-- 		assert(not file.Exists(path, "DATA"), "Failed to delete file")
-- 	end
	
-- 	for k,v in ipairs(paths) do
-- 		print("Testing file " .. k, v[1], v[2])
-- 		assert(v[1] == file.Read(v[2]), "Deleted file doesn't match")
-- 	end
-- 	print("Filelib tests passed")
-- end