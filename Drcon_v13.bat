@echo off &title Drcon_v13
mode con cols=38 lines=22
color 2F
set path=%APPDATA%\Drcon;%path%

:EnvCheck
ipconfig | find /i "172.16" >nul
if %errorlevel% equ 0 (
	goto Initialize
) else (
	echo ��ȷ����ĵ���ֱ�����ӵ�У԰��������
	echo Error��IP address does not match!
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
@ echo            �������ʵ��ѧ��
@ echo.
@ echo            ���� ��  ������1
@ echo.
@ echo            ע�� ��  ������2
@ echo.
@ echo            ���� ��  ������3
@ echo.
@ echo            ���� ��  ������4
@ echo.
@ echo            ���� ��  ������5
@ echo.
@ echo            �Լ� ��  ������6
@ echo.
@ echo            ���� ��  ������7
@ echo.

set /p choose=��ѡ��
if /i "%choose%" == "1" goto Connect
if /i "%choose%" == "2" goto Logout
if /i "%choose%" == "3" goto Edit1
if /i "%choose%" == "4" goto Edit2
if /i "%choose%" == "5" goto StartUp
if /i "%choose%" == "6" goto SelfCheck
if /i "%choose%" == "7" goto Help
echo              ��������Ч��
pause >nul
goto Menu

:Connect
echo ��������DHCP Server����
curl  -sd "DDDDD=%account%&upass=%password%&0MKKey=%B5%C7%C2%BC+Login&v6ip=" http://222.24.63.10/>"%APPDATA%\Drcon\Connect.log"
findstr "�ɹ���" "%APPDATA%\Drcon\Connect.log"  >nul
if %errorlevel% equ 0 (
	echo ���ӳɹ��������������
	pause  >nul
) else (
	echo ����ʧ�ܣ���������������
	pause >nul
	goto SelfCheck
)
goto :Initialize

:Logout
curl http://222.24.63.10/F.htm >nul
echo ע���ɹ��������������
pause >nul
goto :Initialize

:Edit1
cls
echo �ѱ�����ʺź����룺
type "%APPDATA%\Drcon\info.dat"
echo ���ĳ��򱣴���ʺź�����
echo ��ֹ��������رճ���
set /p account1=�������ʺţ�
set /p password1=���������룺
echo %account1%>%APPDATA%\Drcon\info.dat
echo %password1%>>%APPDATA%\Drcon\info.dat
echo �ɹ��������ѱ�����ʺ�/���룡
pause >nul
goto Initialize

:Edit2
cls
echo Ϊ��������
echo �޸Ŀ������Ĺ������ڴ˰汾������
REM echo �������������ˣ����޸��������롿
REM echo ��ѡ�������޸Ŀ��������
REM echo ��ֹ����������رճ���
REM @ echo.
REM set /p account2=�������ʺţ�
REM set /p password21=������ԭ���룺
REM set /p password22=�����������룺
REM set /p password23=���ٴ�ȷ�������룺
REM if %password22% equ %password23% (
	REM curl  -sd "DDDDD=%account2%&upass=%password21%&npass=%password22%&Npass=%password23%&3MKKey=%D0%DE%B8%C4%C3%DC%C2%EB+Edit+" http://222.24.63.10/>"%APPDATA%\Drcon\Edit.log"
REM ) else (
	REM echo ���������벻һ��
REM )
REM @echo.
REM echo �����Ѹ��ģ�������������Ч
REM echo %account2%>%APPDATA%\Drcon\info.dat
REM echo %password22%>>%APPDATA%\Drcon\info.dat
REM echo ͬʱ�������ѱ�������룬����������
REM echo �����Ѹ��ģ�����������һ������ģ��
REM @echo.
REM pause >nul
REM exit
pause >nul
goto Initialize

:Startup
echo ��������ʾ��������
@ echo.
echo @echo off > "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
echo set path=%APPDATA%\Drcon;%%path%% >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
echo curl http://222.24.63.10/F.htm >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
echo ping localhost -n 3 >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
echo curl -sd "DDDDD=%account%&upass=%password%&0MKKey=%%B5%%C7%%C2%%BC+Login&v6ip=" http://222.24.63.10/ >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"
REM mshta VBScript:Execute(Set a=Wscript.CreateObject(""WScript.Shell""):set strStartUp = a.SpecialFolders("Startup"):Set b=a.CreateShortcut(strStartUp & ""\Drcon.lnk""):b.TargetPath=""%APPDATA%\Drcon\StartUp.bat"":b.Save:close)
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DrStartUp.bat"  (
	echo ���������ɹ����������Զ�����
) else (
	echo ���������ʧ�ܣ�����Ȩ��
)
echo �����������
pause >nul
goto Initialize

:Help
cls
echo �����ɹ������˳��������Զ�������
@ echo.
echo ���κ�WiFi���ƣ�WiFi��㿪
@ echo.
echo bat�ű���С���ֺ���
@ echo.
echo ֧����������ȫ�Զ������������ֶ�����
@ echo.
REM echo �����벻��ȥӪҵ��������Ҫ���֤
REM @ echo.
echo ��֧�������ʵ��ѧ��ͨ��Windows�ͻ���
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

ipconfig | find /i "172.16"  >nul && echo ��IP��ַ��ȡ�ɹ��� || echo ���޷���ȡIP��ַ��
ping 222.24.63.10 /n 2  >nul && echo ��DHCP Server���������� || echo ��DHCP Server����ʧ�ܡ�
if %errorlevel% equ 0 (
	findstr "�ʺŻ����벻��" "%APPDATA%\Drcon\Connect.log"  >nul && echo ��δ֪����� 
	echo �ѱ�����ʺź����룺
	type "%APPDATA%\Drcon\info.dat"
	echo -----------------------
) else (
	echo -----------------------
	echo �����쳣����鱾������
	echo.
	echo ����������־,����رգ��˹�����ҪԼ20s
	ipconfig | find /i "172.16" > "%APPDATA%\Drcon\Check.log"
	ping 222.24.63.10 >>"%APPDATA%\Drcon\Check.log"
	ping 119.29.29.29 >>"%APPDATA%\Drcon\Check.log"
)
echo �Լ���ɣ������������
pause >nul
goto Initialize


:FirstCurl
copy %~dp0\curl.exe %APPDATA%\Drcon >nul
if %errorlevel% equ 0 (
	del %~dp0\curl.exe
) else (
	echo ���������ʧ�����������ر�����
	echo ��������˳�
	pause >nul
	exit
)
goto Initialize


:FirstEdit
echo �״�ʹ����Ҫ�����ʺ�����
set /p account3=�������ʺţ�
set /p password3=���������룺
echo %account3%>%APPDATA%\Drcon\info.dat
echo %password3%>>%APPDATA%\Drcon\info.dat
echo ����ɹ��������������
pause >nul
goto Initialize
