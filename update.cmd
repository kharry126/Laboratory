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
if exist "node_modules" goto updateNodeModules
echo init modules
"%JAR_HOME%\bin\jar" xf node_modules.zip

:updateNodeModules
echo update node_modules
Tools\node-v7.10.0-win-x64\npm.cmd install
pause
