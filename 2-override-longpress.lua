--local Device = require("device")
local InfoMessage = require("ui/widget/infomessage")
local UIManager = require("ui/uimanager")
local ReaderDictionary = require("apps/reader/modules/readerdictionary")

local old_show_dict = ReaderDictionary.showDict

ReaderDictionary.showDict = function(self, word, ...)
    if not word or word == "" then return end

    -- Remove any quotes from the word to prevent shell errors
    local clean_word = word:gsub("'", "")

    -- THE BYPASS:
    -- 1. Use --host to break out.
    -- 2. Use -- to separate flatpak-spawn flags from our command.
    -- 3. Force 'cd /tmp' so the portal doesn't look for /app/koreader.
    local cmd = string.format(
	--"cd /tmp && flatpak-spawn --host sh -c 'echo -n %s | xclip -selection primary'",
	--"cd /tmp && flatpak-spawn --host sh -c 'aplay -f cd /dev/zero & sleep 0.1 && espeak-ng -v en-us+f2 '%s'' &",
	"cd /tmp && flatpak-spawn --host piper-speak-wayland.sh '%s' &",
        clean_word
    )
    
    os.execute(cmd)

    return old_show_dict(self, word, ...)
end
