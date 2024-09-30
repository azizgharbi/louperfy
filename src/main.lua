local running = true
local last_size = 0

local function read_new_lines(file_path)
	local file = io.open(file_path, "r")
	if not file then
		return
	end

	-- Seek to the last known position
	file:seek("set", last_size)

	local new_lines = file:read("*a") -- Read all new content
	last_size = file:seek() -- Update last_size

	file:close()

	if new_lines and new_lines ~= "" then
		print("New lines: " .. new_lines)
	end
end

local file_path = "test.txt"

while running do
	read_new_lines(file_path)
	os.execute("sleep 1") -- Adjust sleep duration as necessary
end

-- Allow for graceful exit
while running do
	local input = io.read()
	if input == "exit" then
		running = false
	end
end
