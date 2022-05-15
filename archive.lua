tArgs = {...}
local FFormat = ".arch"
local nFile, nDir, size = 0, 0
if #tArgs < 3 then
print("Usage:"
.."\nTo zip folder and its files and subfolders use"
.."\narchive zip... "
.."\nIn you able to set folders that will be skipped, for example \"rom\" "
.."\n\nTo unzip zipped archive to selected folder use"
.."\narchive unzip"
.."\n\nThis app is useful with pastebin.\nProgrammed by 1Ridav")
end

local function fopen(path, mode)
local f = fs.open(path, mode)
if not f then
print("ERROR: Could not open "..path.." with mode \""..mode.."\"")
exit()
end
return f
end

local function skip(df)
for i = 3, #tArgs do
if tArgs[i] == fs.getName(df) then
return true
end
end
return false
end

local function zip(file)
print("zipping: ".. file)
local f = fopen(file, "r")
local z = textutils.serialize(f.readAll())
f.close()
return z
end

local function ZIP(path)
local list = fs.list(path)
local array = {}
local t, name, d = 0, "", 0

for i = 2, #list * 2, 2 do
t = i/2
local tpath = path.."/"..list[t]
if fs.isDir(tpath) then
if not skip(tpath) then
name = "D:"..list[t]
array[i] = ZIP(tpath)
nDir = nDir + 1
end
else
name = "F:"..list[t]
array[i] = zip(tpath)
nFile = nFile + 1
end
array[i - 1] = name
end

return textutils.serialize(array)
end

local function unzip(text, path)
print("unzipping: "..path)
local f = fopen(path, "w")
f.write(textutils.unserialize(text))
f.close()
end

local function UNZIP(text, path)
local array = textutils.unserialize(text)
local unz, dp
local d = 0
for i = 2, #array, 2 do
if string.sub(array[i-1], 1, 1) == "D" then
dp = string.sub(array[i-1], 3, #array[i-1])
fs.makeDir(path.."/"..dp)
UNZIP(array[i], path.."/"..dp)
nDir = nDir + 1
elseif string.sub(array[i-1], 1, 1) == "F" then
local p = string.sub(array[i-1], 3, #array[i-1])
unzip(array[i], path.."/"..p)
nFile = nFile + 1
end
end
end

local function result()
print("\nDone"
,"\n   size: "
,size, " B   "
,math.floor(size/1024), " KB"
,"\n   Files:   ", nFile
,"\n   Folders: ", nDir
)
end

if tArgs[1] == "zip" then
if fs.exists(tArgs[2]) and fs.isDir(tArgs[2]) then
local zipped = ZIP(shell.resolve(tArgs[2]))
local f = fs.open(tArgs[3]..FFormat, "w")
f.write(zipped)
f.close()
zipped = nil
size = fs.getSize(tArgs[3]..FFormat)
result()
end

elseif tArgs[1] == "unzip" then
local f = fopen(tArgs[2], "r")
if not fs.exists(tArgs[3]) then
fs.makeDir(tArgs[3])
end
UNZIP(f.readAll(), tArgs[3])
size = fs.getSize(tArgs[2])
result()
end