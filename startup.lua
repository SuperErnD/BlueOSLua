term.clear()
term.setCursorPos(1,1)
print("Welcome to BootS")

while true do 
	print([[
		Select os
		1. - CraftOS
		2. - BlueOS
		]])
	write('>')
	local choice = read()
	
	if (choice == "1") then
		break
	elseif(choice=="2") then
		term.clear()
		term.setCursorPos(1,1)
		shell.execute('/boot/kernel/kernel.lua')
		break
	else
		print('Unkown choice')
	end
end
