"%JAR_HOME%\bin\jar" ¨Ccvf node_modules2.zip node_modules
if exist "node_modules2.zip"
del node_modules.zip
rename  node_modules2.zip node_modules.zip
pause