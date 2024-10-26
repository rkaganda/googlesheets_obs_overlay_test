obs = obslua

-- Define the replay buffer directory path and the subdirectory for current replays
replay_dir = "C:/Users/rkaganda/Videos/obs_vods"  -- Replace this with the actual path
current_replays_dir = replay_dir .. "/current_replays"  -- Subdirectory for current replays

-- Function to get the current timestamp in "YYYYMMDD_HHMMSS" format
function get_timestamp()
    local t = os.date("*t")
    return string.format("%04d%02d%02d_%02d%02d%02d", t.year, t.month, t.day, t.hour, t.min, t.sec)
end

-- Function to move files from one directory to another
function move_files(source_dir, destination_dir)
    -- Create the destination directory if it doesn't exist
    os.execute('mkdir "' .. destination_dir .. '"')  -- Windows command to create a directory

    -- Move files (using the Windows "dir" command to list files)
    for file in io.popen('dir "' .. source_dir .. '" /b'):lines() do
        local source_file = source_dir .. "\\" .. file  -- Use backslashes for Windows paths
        local destination_file = destination_dir .. "\\" .. file
        os.rename(source_file, destination_file)
        print("Moved " .. file .. " to " .. destination_dir)
    end
end

-- Callback function for the button press
function on_button_pressed(props, p)
    -- Check if current_replays exists and has files to move
    local current_replays_exists = os.execute('cd "' .. current_replays_dir .. '"') == 0
    if not current_replays_exists then
        print("The "..current_replays_dir.." directory does not exist or is inaccessible.")
        return
    end

    -- Create a new directory with the current timestamp
    local timestamp = get_timestamp()
    local new_directory = replay_dir .. "\\" .. timestamp  -- Use backslashes for Windows paths
    print("Creating new directory: " .. new_directory)

    -- Move the files from current_replays to the new directory
    move_files(current_replays_dir, new_directory)
end

-- Add the button to the OBS UI
function script_properties()
    local props = obs.obs_properties_create()

    -- Add button that will trigger the file move
    obs.obs_properties_add_button(props, "move_files_button", "Move Replay Files", on_button_pressed)

    return props
end

-- Script description for OBS
function script_description()
    return "This script moves replay buffer files from 'current_replays' to a new directory named with the current timestamp."
end

-- Function to print the current working directory (Windows compatible)
function print_working_directory()
    local f = io.popen("cd")  -- Use "cd" for Windows
    local current_dir = f:read("*a")
    f:close()
    print("Current working directory: " .. current_dir)
end
