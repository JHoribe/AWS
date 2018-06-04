@echo off
rem jhoribe on 28-may-2018

set USERPROFILE=C:\Users\%USERNAME%
set AWS_PROFILE=default
set AWS_CONFIG_FILE=%USERPROFILE%\.aws\config

set Local_Path=%1
set S3_Bucket=%2

for /f "delims=" %%a in ('hostname') do set HostName=%%a

if not exist %Local_Path% (
	echo Local Path "%Local_Path%" does not exist!
	exit /b
)

set Path_String=%Local_Path:~3%
set Archive_Path=C:\Archive\%HostName%\%Path_String%
set S3_Path=s3://%S3_Bucket%/%HostName%/%Path_String:\=/%/
set S3_Cmd=aws s3 mv

if not exist %Archive_Path% (
	mkdir %Archive_Path%
)

forfiles /p "%Local_Path%" /m *.zip /d -30 /c "cmd /c move @path %Archive_Path%"
forfiles /p "%Archive_Path%" /m *.zip /d -180 /c "cmd /c %S3_Cmd% @path %S3_Path%"

rem EOF
