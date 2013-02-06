# These are the days your apps are allowed to launch on:
property ACTIVE_DAYS : {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}

# These are the apps that shall be launched in the order from left to right:
# To avoid any issues, they should be located in the /Applications folder.
property APP_NAMES : {"", "", ""}

set TODAY to the weekday of (current date) as string
if (TODAY is in ACTIVE_DAYS) then
    repeat with APP_NAME in APP_NAMES
        launchTheApp(APP_NAME)
        # Wait for an app to launch, to spread out the load on the system
        waitUntilLaunched(APP_NAME)

        # You could run any custom code here.
        # Could be targeted any one, or all of the apps.
        # You could find examples in the Examples.applescript

    end repeat
end if

on launchTheApp(appName)
    # Quoting the name of an app, to accomodate for the names
    # with spaces in it. Otherwise causes issues with Shell
    set quotedAppName to quoted form of appName

    # Shell is used to open even non-scriptable apps
    do shell script "open -a " & appName
end launchTheApp

on waitUntilLaunched(appName)
    if (isRunning(appName) = true) then
        delay 0.5
        return
    else if (isRunning(appName) = false) then
        delay 0.5
        waitUntilLaunched(appName)
    end if
end waitUntilLaunched

on isRunning(appName)
    local concentrateProcesses
    try
        tell application "System Events"
            # Count all processes with a provided name. Returns an integer
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