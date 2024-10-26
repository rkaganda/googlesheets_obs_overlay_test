obs = obslua
local replay_buffer_directory = "C:/path/to/replay/buffer" -- Change to your replay buffer directory path

-- Function to get current date and time in yymmddhhmm format
function get_formatted_datetime()
    return os.date("%y%m%d%H%M")
end

-- Function to create a new directory
function create_directory(path)
    os.execute('mkdir "' .. path .. '"')
end

-- Function to move files from replay buffer to the new directory
function move_files_to_directory(source, destination)
    for file in io.popen('dir "'..source..'" /b'):lines() do
        os.rename(source .. "\\" .. file, destination .. "\\" .. file)
    end
end

-- Main function to create the folder and move files
function save_replay_files()
    local datetime = get_formatted_datetime()
    local new_directory = replay_buffer_directory .. "\\" .. datetime

    create_directory(new_directory)
    move_files_to_directory(replay_buffer_directory, new_directory)

    obs.script_log(obs.LOG_INFO, "Files moved to directory: " .. new_directory)
end

-- Function called when the script is loaded
function script_load(settings)
    save_replay_files()
end
