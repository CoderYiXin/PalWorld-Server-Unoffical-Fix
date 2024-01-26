@echo off
setlocal enabledelayedexpansion

REM �������������в���
if "%1"=="" (
    echo δ�ṩ�ļ�·����Ϊ���� �뽫PalServer-Win64-Test-Cmd.exe�ļ��ϵ����bat�ļ���
    pause
    exit /b 1
)

REM �ж��ļ��Ƿ����
if not exist "%1" (
    echo �����ļ�������
    pause
    exit /b 1
)

REM �ж��ļ����Ƿ�ΪPalServer-Win64-Test-Cmd.exe
set "filename=%~n1"
if /i not "!filename!"=="PalServer-Win64-Test-Cmd" (
    echo �����ļ������� PalServer-Win64-Test-Cmd.exe �뽫PalServer-Win64-Test-Cmd.exe�ļ��ϵ����bat�ļ���
    pause
    exit /b 1
)

REM ʹ�ù���У���ļ�sha1
set "file_path=%~1"
set "expected_sha1=A4E7A2B173D64376410DA78E7982B7F3800E1320"  REM 

echo У���ļ�SHA1...
set "computed_sha1="
for /f "tokens=*" %%a in ('certutil -hashfile "!file_path!" SHA1 ^| find /i /v "SHA1"') do set "computed_sha1=%%a" & goto :CheckOk
:CheckOk
if /i "%computed_sha1%"=="%expected_sha1%" (
    echo SHA1 У��ͨ������������...
) else (
    echo computed_sha1:%computed_sha1%  expected_sha1:%expected_sha1%
    echo ����SHA1 У��δͨ�� ��ȷ��������Ƿ�ΪΪ0.1.3.0�汾 �ļ�δ���۸� �Ƿ��Ѿ����ϲ���
    pause
    exit /b 1
)

REM �������ļ�ΪPalServer-Win64-Test-Cmd.exe.bak
move "!file_path!" "!file_path!.bak"

REM ʹ�� hpatchz ���в���
echo ִ�в�������...
set "patch_command=hpatchz.exe "%~1.bak" patch.bin "%~1""
%patch_command%

REM �ٴ�У���ļ�sha1
echo ����У���ļ�SHA1...
set "computed_sha1="
for /f "tokens=*" %%a in ('certutil -hashfile "!file_path!" SHA1 ^| find /i /v "SHA1"') do set "computed_sha1=%%a" & goto :CheckOk2
:CheckOk2
set "expected_sha1=6FA366DA9F8B35D7DB456CEEEA84DFCA88F8C616"
if /i "%computed_sha1%"=="%expected_sha1%" (
    echo �����ɹ�!!
    pause
    exit /b 0
) else (
    echo ����SHA1 У��δͨ�� ����ʧ��  �����ļ���PalServer-Win64-Test-Cmd.exe.bak �����ֶ��ָ�
    pause
    exit /b 1
)
