@echo off
rem Preserve exclamation marks in paths by disabling delayed expansion.
setlocal DisableDelayedExpansion
rem Copy the bundled plug-in into the current user's Sibelius plug-in folder.
set "plugin_name=SplitAtBeatBoundaries.plg"
set "source_file=%~dp0%plugin_name%"
if not defined APPDATA goto no_appdata
set "destination_dir=%APPDATA%\Avid\Sibelius\Plugins\Custom"
if not exist "%source_file%" goto missing_source
if not exist "%destination_dir%\" mkdir "%destination_dir%"
if not exist "%destination_dir%\" goto copy_failed
rem Binary copy preserves the UTF-16 byte order mark; /y replaces an old copy.
copy /b /y "%source_file%" "%destination_dir%\%plugin_name%" >nul
if errorlevel 1 goto copy_failed
rem Keep a legacy installation as a non-loadable backup; never overwrite a backup.
set "legacy_file=%destination_dir%\SplitAtBeatBoundaries050.plg"
if not exist "%legacy_file%" goto installed
set "backup_index=1"
:find_backup
set "backup_file=%legacy_file%.%backup_index%.disabled"
if not exist "%backup_file%" goto retire_legacy
set /a backup_index+=1 >nul
goto find_backup
:retire_legacy
move /y "%legacy_file%" "%backup_file%" >nul
if errorlevel 1 goto legacy_failed
echo Previous version saved as: "%backup_file%"
:installed
echo Installed: "%destination_dir%\%plugin_name%"
echo Restart Sibelius, then run: Split at Beat Boundaries
exit /b 0

:missing_source
echo Installation failed: keep the .plg file next to this installer.
goto failed
:no_appdata
echo Installation failed: APPDATA is unavailable.
goto failed
:legacy_failed
echo New plug-in copied, but the legacy file could not be retired.
echo Move SplitAtBeatBoundaries050.plg out of the plug-in folder before restarting Sibelius.
goto failed
:copy_failed
echo Installation failed: could not create the folder or copy the plug-in.
:failed
pause
exit /b 1
