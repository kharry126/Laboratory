@echo off
set JAR_HOME=%~1
if not "%JAR_HOME%" == "" goto checkNodeModules
set JAR_HOME=%JAVA_HOME%
if not "%JAR_HOME%" == "" goto checkNodeModules
echo NO JAR_HOME
goto end

:checkNodeModules
if exist "node_modules" goto runDev
echo init modules
npm install

:runDev
npm run dev
:end
