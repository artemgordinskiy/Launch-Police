# These are the days your apps are allowed to launch on
property ACTIVE_DAYS : {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}

# These are the apps that will be launched in an order from left to right (delimited by a coma).
# To avoid any issues, they should be located in the /Applications/ folder.
property APP_NAMES : {"Google Chrome", "Spotify", "Things"}

# This property is made for internal use. On change, be prepared for a Doomsday.
property APP_NAME : ""

if (isActiveDay(ACTIVE_DAYS)) then
    # Go through the list of apps in the APP_NAMES list
    repeat with APP_NAME in APP_NAMES
        # Converting the name of an app to a string
        set APP_NAME to APP_NAME as string
        launchTheApp(quoted form of APP_NAME)
        waitUntilLaunched(APP_NAME)

        # You could run any custom code here. Could be
        # targeted at any one (use if(APP_NAME = "App name")), or every app.
    end repeat
end if

on launchTheApp(appName)
    # Launch an app with a provided name
    do shell script "open -a " & appName
end launchTheApp

on waitUntilLaunched(appName)
    # Check if provided app running
    if (isRunning(appName) = true) then
        return
        # If it's not running, call itself recursively
    else if (isRunning(appName) = false) then
        delay 0.5
        waitUntilLaunched(appName)
    end if
end waitUntilLaunched

on isRunning(appName)
    local concentrateProcesses
    try
        tell application "System Events"
            # Count all processes with a provided name. Returns int.
            set processCount to (count of (every process whose name is appName))
        end tell
    on error
        return false
    end try
    if processCount > 0 then
        return true
    else
        return false
    end if
end isRunning

on isActiveDay(activeDays)
    try
        # Get today's day of the week
        set today to weekday of (current date) as string
    on error
        return false
    end try
    # Search for today in the ACTIVE_DAYS list
    if (today is in activeDays) then
        return true
    else
        return false
    end if
end isActiveDay

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