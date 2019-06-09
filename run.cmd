@echo off
set JAR_HOME=%~1
if not "%JAR_HOME%" == "" goto checkNpm
set JAR_HOME=%JAVA_HOME%
if not "%JAR_HOME%" == "" goto checkNpm
echo NO JAR_HOME
goto end

:checkNpm
if exist "tools\node-v7.10.0-win-x64" goto checkNodeModules

cd tools
echo Unpack Node...
"%JAR_HOME%\bin\jar" xf node-v7.10.0-win-x64.zip
cd ..

:checkNodeModules
if exist "node_modules" goto runDev
echo init modules
"%JAR_HOME%\bin\jar" xf node_modules.zip
 goto runDev

:runDev
set PATH=tools\node-v7.10.0-win-x64;%PATH%
Tools\node-v7.10.0-win-x64\npm.cmd run dev
:end
pause
