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
set PATH=tools\node-v7.10.0-win-x64;%PATH%
if exist "node_modules" goto runDev
echo init modules
Tools\node-v7.10.0-win-x64\npm.cmd install

:runDev
Tools\node-v7.10.0-win-x64\npm.cmd run dev
:end
pause
