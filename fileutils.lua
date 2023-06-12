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