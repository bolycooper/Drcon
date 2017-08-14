@echo off &title Drcon_v13
mode con cols=38 lines=22
color 2F
set path=%APPDATA%\Drcon;%path%

:EnvCheck
ipconfig | find /i "172.16" >nul
if %errorlevel% equ 0 (
	goto Initialize
) else (
	echo 请确认你的电脑直接连接到校园局域网！
	echo Error：IP address does not match!
	pause >nul
	exit
)

:Initialize
if not exist "%APPDATA%\Drcon\" md "%APPDATA%\Drcon" >nul
if not exist "%APPDATA%\Drcon\curl.exe" goto FirstCurl
if exist "%~dp0\curl.exe" del "%~dp0\curl.exe"
if not exist "%APPDATA%\Drcon\info.dat"  goto FirstEdit
for /f "tokens=1* delims=:" %%i in ('type %APPDATA%\Drcon\info.dat^|findstr /n ".*"') do (
if "%%i"=="1" set account=%%j
set password=%%j) >nul

:KillDrcom
taskkill /f /im "DrClient.exe" >nul 2>nul 
taskkill /f /im "DrMain.exe" >nul 2>nul 
taskkill /f /im "DrUpdate.exe" >nul 2>nul 

:Menu
cls
@ echo            【西安邮电大学】
@ echo.
@ echo            连接 →  请输入1
@ echo.
@ echo            注销 →  请输入2
@ echo.
@ echo            换号 →  请输入3
@ echo.
@ echo            改密 →  请输入4
@ echo.
@ echo            自启 →  请输入5
@ echo.
@ echo            自检 →  请输入6
@ echo.
@ echo            帮助 →  请输入7
@ echo.

set /p choose=请选择：
if /i "%choose%" == "1" goto Connect
if /i "%choose%" == "2" goto Logout
if /i "%choose%" == "3" goto Edit1
if /i "%choose%" == "4" goto Edit2
if /i "%choose%" == "5" goto StartUp
if /i "%choose%" == "6" goto SelfCheck
if /i "%choose%" == "7" goto Help
echo              【输入无效】
pause >nul
goto Menu

:Connect
echo 正在连接DHCP Server……
curl  -sd "DDDDD=%account%&upass=%password%&0MKKey=%B5%C7%C2%BC+Login&v6ip=" http://222.24.63.10/>"%APPDATA%\Drcon\Connect.log"
findstr "成功窗" "%APPDATA%\Drcon\Connect.log"  >nul
if %errorlevel% equ 0 (
	echo 连接成功！按任意键返回
	pause  >nul
) else (
	echo 连接失败！即将进行问题检查
	pause >nul
	goto SelfCheck
)
goto :Initialize

:Logout
curl http://222.24.63.10/F.htm >nul
echo 注销成功！按任意键继续
pause >nul
goto :Initialize

:Edit1
cls
echo 已保存的帐号和密码：
type "%APPDATA%\Drcon\info.dat"
echo 更改程序保存的帐号和密码
echo 终止更改密请关闭程序
set /p account1=请输入帐号：
set /p password1=请输入密码：
echo %account1%>%APPDATA%\Drcon\info.dat
echo %password1%>>%APPDATA%\Drcon\info.dat
echo 成功更新了已保存的帐号/密码！
pause >nul
goto Initialize

:Edit2
cls
echo 为避免滥用
echo 修改宽带密码的功能已于此版本被禁用
REM echo 【做素质西邮人，勿修改他人密码】
REM echo 此选项用于修改宽带的密码
REM echo 终止更改密码请关闭程序
REM @ echo.
REM set /p account2=请输入帐号：
REM set /p password21=请输入原密码：
REM set /p password22=请输入新密码：
REM set /p password23=请再次确认新密码：
REM if %password22% equ %password23% (
	REM curl  -sd "DDDDD=%account2%&upass=%password21%&npass=%password22%&Npass=%password23%&3MKKey=%D0%DE%B8%C4%C3%DC%C2%EB+Edit+" http://222.24.63.10/>"%APPDATA%\Drcon\Edit.log"
REM ) else (
	REM echo 两次新密码不一致
REM )
REM @echo.
REM echo 密码已更改，新密码立即生效
REM echo %account2%>%APPDATA%\Drcon\info.dat
REM echo %password22%>>%APPDATA%\Drcon\info.dat
REM echo 同时更新了已保存的密码，请重启程序
REM echo 密码已更改，请重新运行一次自启模块
REM @echo.
REM pause >nul
REM exit
pause >nul
goto Initialize

:Startup
echo 若弹出提示，请允许
@ echo.
echo @echo off > "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
echo set path=%APPDATA%\Drcon;%%path%% >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
echo curl http://222.24.63.10/F.htm >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
echo ping localhost -n 3 >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
echo curl -sd "DDDDD=%account%&upass=%password%&0MKKey=%%B5%%C7%%C2%%BC+Login&v6ip=" http://222.24.63.10/ >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
REM mshta VBScript:Execute(Set a=Wscript.CreateObject(""WScript.Shell""):set strStartUp = a.SpecialFolders("Startup"):Set b=a.CreateShortcut(strStartUp & ""\Drcon.lnk""):b.TargetPath=""%APPDATA%\Drcon\StartUp.bat"":b.Save:close)
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"  (
	echo 添加启动项成功！开机后自动联网
) else (
	echo 添加启动项失败！请检查权限
)
echo 按任意键继续
pause >nul
goto Initialize

:Help
cls
echo 联网成功即可退出，断网自动重连。
@ echo.
echo 无任何WiFi限制，WiFi随便开
@ echo.
echo bat脚本，小巧又好用
@ echo.
echo 支持自启动，全自动联网，无需手动操作
@ echo.
REM echo 改密码不用去营业厅，不需要身份证
REM @ echo.
echo 仅支持西安邮电大学联通网Windows客户端
@ echo.
pause >nul
cls
REM start http://www.joshuacooper.cn
echo Any feedback will be appreciated
@ echo.
echo Applications for shell,python are under test
@ echo.
echo Email:root@joshuacooper.cn
@ echo.
echo Copyright (c) 2016-2017
@ echo.
echo All Rights Reserved 
pause >nul
goto Initialize

:SelfCheck
cls
curl  -sd "DDDDD=%account%&upass=%password%&0MKKey=%B5%C7%C2%BC+Login&v6ip=" http://222.24.63.10/>"%APPDATA%\Drcon\Connect.log"
echo -----------------------

ipconfig | find /i "172.16"  >nul && echo ①IP地址获取成功√ || echo ①无法获取IP地址×
ping 222.24.63.10 /n 2  >nul && echo ②DHCP Server连接正常√ || echo ②DHCP Server连接失败×
if %errorlevel% equ 0 (
	findstr "帐号或密码不对" "%APPDATA%\Drcon\Connect.log"  >nul && echo ③未知错误× 
	echo 已保存的帐号和密码：
	type "%APPDATA%\Drcon\info.dat"
	echo -----------------------
) else (
	echo -----------------------
	echo 网络异常，检查本地连接
	echo.
	echo 正在生成日志,请勿关闭，此过程需要约20s
	ipconfig | find /i "172.16" > "%APPDATA%\Drcon\Check.log"
	ping 222.24.63.10 >>"%APPDATA%\Drcon\Check.log"
	ping 119.29.29.29 >>"%APPDATA%\Drcon\Check.log"
)
echo 自检完成，按任意键返回
pause >nul
goto Initialize


:FirstCurl
copy %~dp0\curl.exe %APPDATA%\Drcon >nul
if %errorlevel% equ 0 (
	del %~dp0\curl.exe
) else (
	echo 基本组件丢失，请重新下载本程序
	echo 按任意键退出
	pause >nul
	exit
)
goto Initialize


:FirstEdit
echo 首次使用需要输入帐号密码
set /p account3=请输入帐号：
set /p password3=请输入密码：
echo %account3%>%APPDATA%\Drcon\info.dat
echo %password3%>>%APPDATA%\Drcon\info.dat
echo 保存成功！按任意键继续
pause >nul
goto Initialize
