file.WriteWithoutDirectories = file.WriteWithoutDirectories or file.Write
function file.Write( path, content )

    local chain = string.Split( path, "/" ) -- get them folders

    if #chain > 1 then
        local directory = table.concat( chain, "/", 1, #chain-1); -- just the directory

        if !file.IsDir( directory, "DATA" ) then -- create the directory if it doesn't exist
            file.CreateDir( directory ); -- luckily this accepts multiple folders
        end

        file.WriteWithoutDirectories( path, content );
    else
        file.WriteWithoutDirectories( path, content );
    end

end

file.UnsafeDelete = file.UnsafeDelete or file.Delete
file.Delete = function(name) -- safely delete, ie: the recycle bin for gmod
	local namewithextension = name
	name = string.StripExtension(name)
	
	local content = file.Read(namewithextension)
	if content then -- only run if file exists
		local i
		local nameWithPath = "deleted_files/"..name
		
        -- if it exists, get a new name; 1st deletion is just the name, 2nd is name_1, 3rd is name_2 ...
		while file.Exists(nameWithPath .. (i and ("_"..i) or "") .. ".txt", "DATA") do
			if i and i >= 1000 then -- loop limit that can theoretically be removed w/o much issue, I just wanted it
				print("Loop limit reached when trying to safely delete file, check your deleted items ; File was not deleted")
				return
			end
			i = (i or 0) + 1
		end
		
		local nametouse = nameWithPath .. (i and ("_"..i) or "") .. ".txt" -- I could've kept a variable of the string but it's not that bad
		
		file.Write(nametouse, content) -- write the backup
		if file.Exists(nametouse, "DATA") then -- only delete once we're confident the file at least exists, I could do a file.Read to compare but that would only make sense
			file.UnsafeDelete(namewithextension)
		else
			print("Failed to write backup file when deleting old file: "..tostring(namewithextension).." ; File was not deleted")
		end
	end
end