local log_path = "test.txt" -- Change this to your log file path
local running = true -- Flag to control the loop

-- Function to read the log file and print its contents
local function read_log()
	local file = io.open(log_path, "r")
	if not file then
		print("Error opening log file.")
		return
	end

	-- Read all lines in the log file
	for line in file:lines() do
		print(line)
	end

	file:close()
end

-- Function to monitor the log file for new lines
local function monitor_log()
	local file = io.open(log_path, "r")
	if not file then
		print("Error opening log file.")
		return
	end

	-- Seek to the end of the file
	file:seek("end")

	while running do
		local line = file:read("*all")
		if line then
			print(line)
		else
			-- Sleep for a short duration to avoid busy waiting
			os.execute("sleep 2") -- Adjust sleep duration as necessary
		end
	end

	file:close()
end

-- Read existing log lines
read_log()

-- Start monitoring the log file for new lines
local monitor_thread = coroutine.create(monitor_log)

-- Allow for graceful exit
while running do
	local input = io.read()
	if input == "exit" then
		running = false
	end
end

-- Resume the monitor thread to clean up
coroutine.resume(monitor_thread)
