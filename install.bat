@echo off
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
if '%errorlevel%' neq '0' (
  echo Requesting administrative privileges ���������ԱȨ�ޣ�...
  goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
  echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
  set params= %*
  echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
  "%temp%\getadmin.vbs"
  del "%temp%\getadmin.vbs"
  exit /B
:gotAdmin
  pushd "%CD%"
  cd /d "%~dp0"
:check_dir
echo ���ڲ��ұ�Ŀ¼�Ƿ����weasel�ļ���
set WEASEL=%~dp0weasel
if exist "%~dp0weasel" (goto main_menu)
echo ���ڼ�鱾Ŀ¼�Ƿ�Ϊweasel�ļ���
set WEASEL=%~dp0
set WEASEL=%WEASEL:~0,-1%
if "%WEASEL:~-6%"=="weasel" (goto main_menu) else (
  echo δ�ҵ���װĿ¼������3�������
  timeout /t 3 /nobreak >nul
  goto check_dir
)
:main_menu
cls
echo �ɹ��ҵ���װĿ¼��
echo WeaselĿ¼Ϊ%WEASEL%
echo ===================
echo ��ѡ��һ����ģʽ��
echo ��1����װģʽ���״�ʹ�ã�
echo ��2��ж��ģʽ
echo ===================
:main_menu_retry
set /p main_choice=
if "%main_choice%"=="1" (
  goto :install_mode
) else if "%main_choice%"=="2" (
  goto :uninstall_mode
) else (
  echo ��Ч��ѡ��������ѡ��.
  pause >nul
  goto main_menu_retry
)
:install_mode
cls
echo ����ѡ��װģʽ��
echo ===================
echo ��ѡ��һ����ģʽ��
echo ��1��Σ�հ�װ��ɾ��Weasel�û����ݣ�
echo ��2����ȫ��װ������Weasel�û����ݣ�
echo ��M����ת����Ŀ¼
echo ===================
:install_mode_retry
set /p install_choice=
if "%install_choice%"=="1" (
  echo ����ѡ��Σ�հ�װ������ɾ���û����ݡ�
  echo ������ʼΣ�հ�װ��
  timeout /t 1 /nobreak >nul
  goto :uninstall
) else if "%install_choice%"=="2" (
  echo ����ѡ��ȫ��װ�����ᱣ���û����ݡ�
  echo ������ʼ��ȫ��װ��
  timeout /t 1 /nobreak >nul
  goto :uninstall
) else if /i "%install_choice%"=="m" (
  goto main_menu
) else (
  echo ��Ч��ѡ��������ѡ��.
  pause >nul
  goto install_mode_retry
)
pause >nul
goto main_menu
:uninstall_mode
cls
echo ===================
echo ����ѡ��ж��ģʽ��
echo ��ѡ��һ����ģʽ��
echo ��1��Σ��ж�أ�ɾ��Weasel�û����ݣ�
echo ��2����ȫж�أ�����Weasel�û����ݣ�
echo ��M����ת����Ŀ¼
echo ===================
:uninstall_mode_retry
set /p uninstall_choice=
if "%uninstall_choice%"=="1" (
  echo ����ѡ��Σ��ж�أ�����ɾ���û����ݡ�
  echo ������ʼΣ��ж�ء�
  timeout /t 1 /nobreak >nul
  goto :uninstall
) else if "%uninstall_choice%"=="2" (
  echo ����ѡ��ȫж�أ����ᱣ���û����ݡ�
  echo ������ʼ��ȫж�ء�
  timeout /t 1 /nobreak >nul
  goto :uninstall
) else if /i "%install_choice%"=="m" (
  goto main_menu
) else (
  echo ��Ч��ѡ��������ѡ��.
  pause >nul
  goto uninstall_mode_retry
)
pause >nul
goto main_menu
:uninstall
cls
echo ===================
echo ����ж��
"%WEASEL%\WeaselServer.exe" /quit
"%WEASEL%\WeaselSetup.exe" /u
reg DELETE HKEY_CURRENT_USER\Software\Rime /f >nul 2>nul
reg DELETE HKLM\Software\Microsoft\Windows\CurrentVersion\Run\ /v WeaselServer /f >nul 2>nul
del /q "%WEASEL%\user\installation.yaml" >nul 2>nul
del /q "%WEASEL%\user\user.yaml" >nul 2>nul
if "%uninstall_choice%"=="1" (
  goto :dangerous
) else if "%install_choice%"=="1" (
  goto :dangerous
) else (
  goto :safe
)
:safe
echo ��ȫж����ɣ�
if "%main_choice%"=="1" (
  goto :install
) else (
  goto :goback
)
:dangerous
"%WEASEL%\WeaselServer.exe" /quit
"%WEASEL%\WeaselSetup.exe" /u
reg DELETE HKEY_CURRENT_USER\Software\Rime /f >nul 2>nul
reg DELETE HKLM\Software\Microsoft\Windows\CurrentVersion\Run\ /v WeaselServer /f >nul 2>nul
rmdir  /s/q  "%WEASEL%\user"
md "%WEASEL%\user"
type nul > "%WEASEL%\user\default.custom.yaml"
type nul > "%WEASEL%\user\weasel.custom.yaml"
echo F|xcopy "%WEASEL%\data\weasel.yaml" "%WEASEL%\user\build\weasel.yaml" >NUL
echo F|xcopy "%WEASEL%\data\default.yaml" "%WEASEL%\user\build\default.yaml" >NUL
echo Σ��ж����ɣ�
if "%main_choice%"=="1" (
  goto :install
) else (
  goto :goback
)
:install
echo ===================
echo ���ڰ�װ
"%WEASEL%\WeaselServer.exe" /quit
"%WEASEL%\WeaselSetup.exe" /u
reg DELETE HKEY_CURRENT_USER\Software\Rime /f >nul 2>nul
reg DELETE HKLM\Software\Microsoft\Windows\CurrentVersion\Run\ /v WeaselServer /f >nul 2>nul
del /q "%WEASEL%\user\installation.yaml" >nul 2>nul
del /q "%WEASEL%\user\user.yaml" >nul 2>nul
reg ADD HKEY_CURRENT_USER\Software\Rime\Weasel /v RimeUserDir /d "%WEASEL%\user" >nul 2>nul
reg ADD HKEY_CURRENT_USER\Software\Rime\Weasel /v Hant /t REG_DWORD /d 0 >nul 2>nul
reg ADD HKEY_CURRENT_USER\Software\Rime\Weasel\Updates /v CheckForUpdates /d 0 >nul 2>nul
"%WEASEL%\WeaselSetup.exe" /i
"%WEASEL%\WeaselDeployer.exe" /install
reg ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v WeaselServer /d "%WEASEL%\WeaselServer.exe" /f >nul 2>nul
echo n|xcopy /i "%WEASEL%\data\weasel.yaml" "%WEASEL%\user\build\weasel.yaml" >nul
echo n|xcopy /i "%WEASEL%\data\default.yaml" "%WEASEL%\user\build\default.yaml" >nul
start "" "%WEASEL%\WeaselServer.exe"
echo ��װ���
goto :goback
:goback
echo ===================
echo ��������ص���Ŀ¼��
pause >nul
goto :main_menu