@echo off

:: Checa se a janela já foi maximizada
if "%1" NEQ "max" (
    powershell -WindowStyle Maximized -Command "Start-Process -FilePath '%~f0' -ArgumentList 'max'"
    exit
)

:: Agora estamos na versão maximizada

:: Força o tamanho da tela manualmente para simular "tela cheia"
mode con: cols=160 lines=50

color 02
cls

:: Cria o script do aviso separado
> aviso_temp.bat (
    echo @echo off
    echo color 4F
    echo title AVISO IMPORTANTE
    echo cls
    echo echo *******************************************
    echo echo     NAO FECHE O PROGRAMA ENQUANTO RODA    
    echo echo Isso podera danificar o sistema operacional!
    echo echo *******************************************
    echo echo.
    echo echo Esta janela ficara aberta ate o final do processo.
    echo pause >nul
)

:: Abre o aviso em uma janela padrão
start "AVISO" cmd /k aviso_temp.bat

:: Barra de progresso fake
setlocal enabledelayedexpansion
set "progress="

echo Iniciando processo...
set /a total=20
for /l %%i in (1,1,%total%) do (
    set "progress=!progress!#"
    <nul set /p="Progresso: [!progress!]"
    timeout /nobreak /t 1 >nul
    cls
    echo *******************************************
    echo     NAO FECHE O PROGRAMA ENQUANTO RODA    
    echo Isso podera danificar o sistema operacional!
    echo *******************************************
    echo.
)
echo Progresso: [####################]
echo Processo iniciado com sucesso!
echo.

:: Verifica C:
if exist C:\ (
    echo Capturando estrutura de pastas do C:...
    cd /d C:\
    tree
    echo.
) else (
    echo Unidade C: nao encontrada. Pulando...
    echo.
)

:: Verifica D:
if exist D:\ (
    echo Capturando estrutura de pastas do D:...
    cd /d D:\
    tree
    echo.
) else (
    echo Unidade D: nao encontrada. Pulando...
    echo.
)

:: Finalização
echo.
echo ==================================
echo       DADOS CAPTURADOS           
echo ==================================
pause

:: Limpeza
del /f /q aviso_temp.bat
exit
