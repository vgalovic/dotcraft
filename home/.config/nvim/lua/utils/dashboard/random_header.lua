---@class utils.dashboard.headers

local M = {}

---@return string headers random header from the table
M.get_random_header = function()
	local headers = {

		header1 = [[
                               __                
  ___     ___    ___   __  __ /\_\    ___ ___    
 / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  
/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ 
\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
 \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],

		header2 = [[
 _______             ____   ____.__         
 \      \   ____  ___\   \ /   /|__| _____  
 /   |   \_/ __ \/  _ \   Y   / |  |/     \ 
/    |    \  ___(  <_> )     /  |  |  Y Y  \
\____|__  /\___  >____/ \___/   |__|__|_|  /
        \/     \/                        \/ ]],

		header3 = [[
 ██████   █████                   █████   █████  ███                  
░░██████ ░░███                   ░░███   ░░███  ░░░                   
 ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   
 ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  
 ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  
 ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  
 █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ 
░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],

		header4 = [[
     __                _            
  /\ \ \___  ___/\   /(_)_ __ ___   
 /  \/ / _ \/ _ \ \ / | | '_ ` _ \  
/ /\  |  __| (_) \ V /| | | | | | | 
\_\ \/ \___|\___/ \_/ |_|_| |_| |_| ]],

		header5 = [[
/\\\\\_____/\\\_______________________________/\\\________/\\\___________________________         
\/\\\\\\___\/\\\______________________________\/\\\_______\/\\\__________________________         
_\/\\\/\\\__\/\\\______________________________\//\\\______/\\\___/\\\_____________________       
 _\/\\\//\\\_\/\\\_____/\\\\\\\\______/\\\\\_____\//\\\____/\\\___\///_____/\\\\\__/\\\\\__       
  _\/\\\\//\\\\/\\\___/\\\/////\\\___/\\\///\\\____\//\\\__/\\\_____/\\\__/\\\///\\\\\///\\\_     
   _\/\\\_\//\\\/\\\__/\\\\\\\\\\\___/\\\__\//\\\____\//\\\/\\\_____\/\\\_\/\\\_\//\\\__\/\\\     
    _\/\\\__\//\\\\\\_\//\\///////___\//\\\__/\\\______\//\\\\\______\/\\\_\/\\\__\/\\\__\/\\\_   
     _\/\\\___\//\\\\\__\//\\\\\\\\\\__\///\\\\\/________\//\\\_______\/\\\_\/\\\__\/\\\__\/\\\   
      _\///_____\/////____\//////////_____\/////___________\///________\///__\///___\///___\///__ ]],

		header6 = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ 
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ 
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ 
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],

		header7 = [[
  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓ 
  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒ 
 ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░ 
 ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██  
 ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒ 
 ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░ 
 ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░ 
    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░    
          ░    ░  ░    ░ ░        ░   ░         ░    
                                 ░                   ]],

		header8 = [[
         ,--.              ,----..                                 ____   
       ,--.'|    ,---,.   /   /   \                 ,---,        ,'  , `. 
   ,--,:  : |  ,'  .' |  /   .     :        ,---.,`--.' |     ,-+-,.' _ | 
,`--.'`|  ' :,---.'   | .   /   ;.  \      /__./||   :  :  ,-+-. ;   , || 
|   :  :  | ||   |   .'.   ;   /  ` ; ,---.;  ; |:   |  ' ,--.'|'   |  ;| 
:   |   \ | ::   :  |-,;   |  ; \ ; |/___/ \  | ||   :  ||   |  ,', |  ': 
|   : '  '; |:   |  ;/||   :  | ; | '\   ;  \ ' |'   '  ;|   | /  | |  || 
'   ' ;.    ;|   :   .'.   |  ' ' ' : \   \  \: ||   |  |'   | :  | :  |, 
|   | | \   ||   |  |-,'   ;  \; /  |  ;   \  ' .'   :  ;;   . |  ; |--'  
'   : |  ; .''   :  ;/| \   \  ',  /    \   \   '|   |  '|   : |  | ,     
|   | '`--'  |   |    \  ;   :    /      \   `  ;'   :  ||   : '  |/      
'   : |      |   :   .'   \   \ .'        :   \ |;   |.' ;   | |`-'       
;   |.'      |   | ,'      `---`           '---" '---'   |   ;/           
'---'        `----'                                      '---'            ]],

		header10 = [[
  /$$   /$$ /$$$$$$$$  /$$$$$$  /$$    /$$ /$$$$$$ /$$      /$$
| $$$ | $$| $$_____/ /$$__  $$| $$   | $$|_  $$_/| $$$    /$$$
| $$$$| $$| $$      | $$  \ $$| $$   | $$  | $$  | $$$$  /$$$$
| $$ $$ $$| $$$$$   | $$  | $$|  $$ / $$/  | $$  | $$ $$/$$ $$
| $$  $$$$| $$__/   | $$  | $$ \  $$ $$/   | $$  | $$  $$$| $$
| $$\  $$$| $$      | $$  | $$  \  $$$/    | $$  | $$\  $ | $$
| $$ \  $$| $$$$$$$$|  $$$$$$/   \  $/    /$$$$$$| $$ \/  | $$
|__/  \__/|________/ \______/     \_/    |______/|__/     |__/]],

		header11 = [[
 .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| | ____  _____  | || |  _________   | || |     ____     | || | ____   ____  | || |     _____    | || | ____    ____ | |
| ||_   \|_   _| | || | |_   ___  |  | || |   .'    `.   | || ||_  _| |_  _| | || |    |_   _|   | || ||_   \  /   _|| |
| |  |   \ | |   | || |   | |_  \_|  | || |  /  .--.  \  | || |  \ \   / /   | || |      | |     | || |  |   \/   |  | |
| |  | |\ \| |   | || |   |  _|  _   | || |  | |    | |  | || |   \ \ / /    | || |      | |     | || |  | |\  /| |  | |
| | _| |_\   |_  | || |  _| |___/ |  | || |  \  `--'  /  | || |    \ ' /     | || |     _| |_    | || | _| |_\/_| |_ | |
| ||_____|\____| | || | |_________|  | || |   `.____.'   | || |     \_/      | || |    |_____|   | || ||_____||_____|| |
| |              | || |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' ]],

		header12 = [[
░▒▓███████▓▒░░▒▓████████▓▒░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓██████████████▓▒░  
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓██████▓▒░   ░▒▓██▓▒░  ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ]],

		header13 = [[
      ___           ___           ___                                    ___     
     /__/\         /  /\         /  /\          ___        ___          /__/\    
     \  \:\       /  /:/_       /  /::\        /__/\      /  /\        |  |::\   
      \  \:\     /  /:/ /\     /  /:/\:\       \  \:\    /  /:/        |  |:|:\  
  _____\__\:\   /  /:/ /:/_   /  /:/  \:\       \  \:\  /__/::\      __|__|:|\:\ 
 /__/::::::::\ /__/:/ /:/ /\ /__/:/ \__\:\  ___  \__\:\ \__\/\:\__  /__/::::| \:\
 \  \:\~~\~~\/ \  \:\/:/ /:/ \  \:\ /  /:/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/
  \  \:\  ~~~   \  \::/ /:/   \  \:\  /:/  \  \:\|  |:|     \__\::/  \  \:\      
   \  \:\        \  \:\/:/     \  \:\/:/    \  \:\__|:|     /__/:/    \  \:\     
    \  \:\        \  \::/       \  \::/      \__\::::/      \__\/      \  \:\    
     \__\/         \__\/         \__\/           ~~~~                   \__\/    ]],

		header14 = [[

                                                                                              
 _____   ______        ______           _____     ____      ____  ____      ______  _______   
|\    \ |\     \   ___|\     \     ____|\    \   |    |    |    ||    |    |      \/       \  
 \\    \| \     \ |     \     \   /     /\    \  |    |    |    ||    |   /          /\     \ 
  \|    \  \     ||     ,_____/| /     /  \    \ |    |    |    ||    |  /     /\   / /\     |
   |     \  |    ||     \--'\_|/|     |    |    ||    |    |    ||    | /     /\ \_/ / /    /|
   |      \ |    ||     /___/|  |     |    |    ||    |    |    ||    ||     |  \|_|/ /    / |
   |    |\ \|    ||     \____|\ |\     \  /    /||\    \  /    /||    ||     |       |    |  |
   |____||\_____/||____ '     /|| \_____\/____/ || \ ___\/___ / ||____||\____\       |____|  /
   |    |/ \|   |||    /_____/ | \ |    ||    | / \ |   ||   | / |    || |    |      |    | / 
   |____|   |___|/|____|     | /  \|____||____|/   \|___||___|/  |____| \|____|      |____|/  
     \(       )/    \( |_____|/      \(    )/        \(    )/      \(      \(          )/     
      '       '      '    )/          '    '          '    '        '       '          '      
                          '                                                                   ]],

		header15 = [[
 ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄               ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄ 
▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌             ▐░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▐░▌           ▐░▌  ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌   ▐░▐░▌
▐░▌▐░▌    ▐░▌▐░▌          ▐░▌       ▐░▌  ▐░▌         ▐░▌       ▐░▌     ▐░▌▐░▌ ▐░▌▐░▌
▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌   ▐░▌       ▐░▌        ▐░▌     ▐░▌ ▐░▐░▌ ▐░▌
▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌    ▐░▌     ▐░▌         ▐░▌     ▐░▌  ▐░▌  ▐░▌
▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌     ▐░▌   ▐░▌          ▐░▌     ▐░▌   ▀   ▐░▌
▐░▌    ▐░▌▐░▌▐░▌          ▐░▌       ▐░▌      ▐░▌ ▐░▌           ▐░▌     ▐░▌       ▐░▌
▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌       ▐░▐░▌        ▄▄▄▄█░█▄▄▄▄ ▐░▌       ▐░▌
▐░▌      ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌        ▐░▌        ▐░░░░░░░░░░░▌▐░▌       ▐░▌
 ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀          ▀          ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀ ]],

		header16 = [[
███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   
███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ 
███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ 
███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ 
███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ 
███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ 
███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ 
 ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ]],

		header17 = [[

::::    ::: :::::::::: ::::::::  :::     ::: ::::::::::: ::::    ::::  
:+:+:   :+: :+:       :+:    :+: :+:     :+:     :+:     +:+:+: :+:+:+ 
:+:+:+  +:+ +:+       +:+    +:+ +:+     +:+     +:+     +:+ +:+:+ +:+ 
+#+ +:+ +#+ +#++:++#  +#+    +:+ +#+     +:+     +#+     +#+  +:+  +#+ 
+#+  +#+#+# +#+       +#+    +#+  +#+   +#+      +#+     +#+       +#+ 
#+#   #+#+# #+#       #+#    #+#   #+#+#+#       #+#     #+#       #+# 
###    #### ########## ########      ###     ########### ###       ### ]],

		header18 = [[

Y88b Y88                             ,e,             
 Y88b Y8  ,e e,   e88 88e  Y8b Y888P  "  888 888 8e  
b Y88b Y d88 88b d888 888b  Y8b Y8P  888 888 888 88b 
8b Y88b  888   , Y888 888P   Y8b "   888 888 888 888 
88b Y88b  "YeeP"  "88 88"     Y8P    888 888 888 888 ]],

		header19 = [[
 ##    ## ########  #######  ##     ## #### ##     ## 
 ###   ## ##       ##     ## ##     ##  ##  ###   ### 
 ####  ## ##       ##     ## ##     ##  ##  #### #### 
 ## ## ## ######   ##     ## ##     ##  ##  ## ### ## 
 ##  #### ##       ##     ##  ##   ##   ##  ##     ## 
 ##   ### ##       ##     ##   ## ##    ##  ##     ## 
 ##    ## ########  #######     ###    #### ##     ## ]],

		header20 = [[
 888b    888                  888     888 d8b               
 8888b   888                  888     888 Y8P               
 88888b  888                  888     888                   
 888Y88b 888  .d88b.   .d88b. Y88b   d88P 888 88888b.d88b.  
 888 Y88b888 d8P  Y8b d88""88b Y88b d88P  888 888 "888 "88b 
 888  Y88888 88888888 888  888  Y88o88P   888 888  888  888 
 888   Y8888 Y8b.     Y88..88P   Y888P    888 888  888  888 
 888    Y888  "Y8888   "Y88P"     Y8P     888 888  888  888 ]],

		header21 = [[
    _           _                                                     _                      
   (_) _       (_)                                                   (_)                     
   (_)(_)_     (_)  _  _  _  _       _  _  _    _               _  _  _      _  _   _  _     
   (_)  (_)_   (_) (_)(_)(_)(_)_  _ (_)(_)(_) _(_)_           _(_)(_)(_)    (_)(_)_(_)(_)    
   (_)    (_)_ (_)(_) _  _  _ (_)(_)         (_) (_)_       _(_)     (_)   (_)   (_)   (_)   
   (_)      (_)(_)(_)(_)(_)(_)(_)(_)         (_)   (_)_   _(_)       (_)   (_)   (_)   (_)   
   (_)         (_)(_)_  _  _  _  (_) _  _  _ (_)     (_)_(_)       _ (_) _ (_)   (_)   (_)   
   (_)         (_)  (_)(_)(_)(_)    (_)(_)(_)          (_)        (_)(_)(_)(_)   (_)   (_)   ]],

		header22 = [[
  __  __                 __  __                      
 /\ \/\ \               /\ \/\ \  __                 
 \ \ `\\ \     __    ___\ \ \ \ \/\_\    ___ ___     
  \ \ , ` \  /'__`\ / __`\ \ \ \ \/\ \ /' __` __`\   
   \ \ \`\ \/\  __//\ \L\ \ \ \_/ \ \ \/\ \/\ \/\ \  
    \ \_\ \_\ \____\ \____/\ `\___/\ \_\ \_\ \_\ \_\ 
     \/_/\/_/\/____/\/___/  `\/__/  \/_/\/_/\/_/\/_/ ]],

		header23 = [[
     _/      _/                      _/      _/  _/               
    _/_/    _/    _/_/      _/_/    _/      _/      _/_/_/  _/_/  
   _/  _/  _/  _/_/_/_/  _/    _/  _/      _/  _/  _/    _/    _/ 
  _/    _/_/  _/        _/    _/    _/  _/    _/  _/    _/    _/  
 _/      _/    _/_/_/    _/_/        _/      _/  _/    _/    _/   ]],

		header24 = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
	}

	-- Pick a random header from the table
	local keys = vim.tbl_keys(headers)
	local random_key = keys[math.random(#keys)]
	return headers[random_key]
end

return M
