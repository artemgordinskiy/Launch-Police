# You could target either one or all of the launched apps.
# To target all of them (examples 1 and 2), write the code in the "repeat with" loop (you'll see a comment there).
# To target any one particular app, use the "if" statements with its name (examples 2 and 3).
# Hint: when inside the "repeat with", the name of the current app is stored in the APP_NAME variable.

### Examples ###

# 1. Hide every launched app after the launch:
hideTheApp(APP_NAME)

# 2. Quit every launched app in a minute (dumb one, I agree):
delay 60
killTheApp(APP_NAME)

# 3. Focus on Google Chrome:
if (APP_NAME = "Google Chrome") then
    tell application "Google Chrome" to focus
end if

# 4. Go to your mailbox when Safari launches:
if (APP_NAME = "Safari") then
    tell application APP_NAME
        set winCount to (count windows)
        if (winCount > 0) then
            tell front window of application "Safari"
                set newTab to make new tab
                set the URL of newTab to "http://gmail.com"
                set the current tab to newTab
            end tell
        else if (winCount = 0) then
            make new document
            tell front window of application "Safari"
                set URL of current tab to "http://gmail.com"
            end tell
        end if
    end tell
end if

### Functions ###
on killTheApp(appName)
    try
        # Get an app's PID (process id)
        set pid to do shell script "ps -A | grep -m1 " & appName & " | awk '{print $1}'"

        # Kill the app at the process id that we found
        do shell script "kill " & pid
    on error
        return false
    end try
end killTheApp

on hideTheApp(appName)
    try
        tell application "System Events"
            tell process appName
                set visible to false
            end tell
        end tell
    on error
        return false
    end try
end hideTheApp