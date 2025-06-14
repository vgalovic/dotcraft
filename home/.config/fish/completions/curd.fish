# Completion script for the `curd` anime CLI tool

# Short flags
complete -c curd -s c -d "Continue the last episode"
complete -c curd -s e -d "Edit the configuration file"
complete -c curd -s u -d "Update the script"
complete -c curd -s v -d "Show curd version"

# Long flags
complete -c curd -l change-token -d "Change your authentication token"
complete -c curd -l dub -d "Watch the dubbed version of the anime"
complete -c curd -l sub -d "Watch the subbed version of the anime"
complete -c curd -l new -d "Add a new anime to your list"
complete -c curd -l skip-op -d "Automatically skip the opening section"
complete -c curd -l skip-ed -d "Automatically skip the ending section"
complete -c curd -l skip-filler -d "Automatically skip filler episodes"
complete -c curd -l skip-recap -d "Automatically skip recap sections"
complete -c curd -l discord-presence -d "Enable or disable Discord presence"
complete -c curd -l image-preview -d "Show an image preview of the anime"
complete -c curd -l no-image-preview -d "Disable image preview"
complete -c curd -l next-episode-prompt -d "Prompt for next episode after completing one"
complete -c curd -l rofi -d "Open anime selection in rofi interface"
complete -c curd -l no-rofi -d "Disable rofi interface"
complete -c curd -l percentage-to-mark-complete -d "Set % watched to mark complete" -x
complete -c curd -l player -d "Specify the player for playback" -x
complete -c curd -l save-mpv-speed -d "Save MPV speed setting"
complete -c curd -l score-on-completion -d "Prompt to score episode on completion"
complete -c curd -l storage-path -d "Path to storage directory" -r
complete -c curd -l subs-lang -d "Set subtitle language" -x
