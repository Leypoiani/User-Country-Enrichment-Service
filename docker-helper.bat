@echo off
REM =====================================================
REM Script de Utilidade - Docker Compose Helper (Windows)
REM Projeto: User Country Service
REM =====================================================

setlocal enabledelayedexpansion

set DOCKER_COMPOSE_FILE=docker-compose.yml
set PROJECT_NAME=usuario

REM =====================================================
REM Funções
REM =====================================================

:check_docker
    docker --version >nul 2>&1
    if errorlevel 1 (
        echo.
        echo [X] Docker nao esta instalado
        echo.
        exit /b 1
    )
    
    docker-compose --version >nul 2>&1
    if errorlevel 1 (
        echo.
        echo [X] Docker Compose nao esta instalado
        echo.
        exit /b 1
    )
    
    echo.
    echo [OK] Docker e Docker Compose encontrados
    echo.
    exit /b 0

:start_containers
    echo.
    echo === Iniciando containers ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% up -d
    if errorlevel 1 (
        echo [X] Erro ao iniciar containers
        exit /b 1
    )
    
    echo [OK] Containers iniciados
    echo.
    echo === Aguardando inicializacao ===
    timeout /t 5 /nobreak
    
    echo.
    echo === Status dos containers ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% ps
    exit /b 0

:stop_containers
    echo.
    echo === Parando containers ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% stop
    echo [OK] Containers parados
    echo.
    exit /b 0

:down_containers
    echo.
    echo === Removendo containers ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% down
    echo [OK] Containers removidos
    echo.
    exit /b 0

:clean_volumes
    echo.
    echo [AVISO] Removendo volumes ^(dados serao perdidos^)
    call docker-compose -f %DOCKER_COMPOSE_FILE% down -v
    echo [OK] Volumes removidos
    echo.
    exit /b 0

:view_logs
    echo.
    echo === Logs da aplicacao ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% logs -f
    exit /b 0

:view_service_logs
    echo.
    echo === Logs de %~1 ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% logs -f %~1
    exit /b 0

:rebuild_app
    echo.
    echo === Fazendo rebuild da aplicacao ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% up --build -d
    echo [OK] Rebuild concluido
    echo.
    exit /b 0

:check_status
    echo.
    echo === Status dos containers ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% ps
    
    echo.
    echo === Testando conectividade ===
    
    REM Testar MySQL
    docker-compose -f %DOCKER_COMPOSE_FILE% exec -T mysql mysqladmin ping -h localhost -uroot -proot123 >nul 2>&1
    if errorlevel 1 (
        echo [X] MySQL nao esta respondendo
    ) else (
        echo [OK] MySQL esta respondendo
    )
    
    REM Testar aplicacao
    for /f %%A in ('powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/health' -Method GET -TimeoutSec 2 -ErrorAction Stop; exit 0 } catch { exit 1 }" 2^>nul') do set /a status=%%A
    
    if !status! equ 0 (
        echo [OK] Aplicacao esta respondendo
    ) else (
        echo [X] Aplicacao nao esta respondendo ^(pode estar inicializando^)
    )
    echo.
    exit /b 0

:access_mysql
    echo.
    echo === Acessando MySQL ===
    echo [AVISO] Senha: usuario_pass
    echo.
    call docker exec -it usuario-mysql mysql -u usuario_user -p usuario_db
    exit /b 0

:execute_sql
    echo.
    echo === Executando query ===
    call docker-compose -f %DOCKER_COMPOSE_FILE% exec -T mysql mysql -u usuario_user -pusuario_pass usuario_db -e "%~1"
    echo.
    exit /b 0

:show_menu
    echo.
    echo User Country Service - Docker Helper
    echo ======================================
    echo 1) Iniciar containers
    echo 2) Parar containers
    echo 3) Remover containers
    echo 4) Limpar volumes ^(CUIDADO: dados serao perdidos^)
    echo 5) Fazer rebuild
    echo 6) Ver logs
    echo 7) Ver logs do MySQL
    echo 8) Ver logs da aplicacao
    echo 9) Verificar status
    echo 10) Acessar MySQL
    echo 11) Listar usuarios
    echo 0) Sair
    echo ======================================
    echo.
    set /p option="Escolha uma opcao: "
    exit /b 0

REM =====================================================
REM Main
REM =====================================================

:main
    call :check_docker
    if errorlevel 1 exit /b 1
    
    if "%~1"=="" (
        REM Modo interativo
        :loop
        call :show_menu
        
        if "!option!"=="1" goto start
        if "!option!"=="2" goto stop
        if "!option!"=="3" goto down
        if "!option!"=="4" goto clean
        if "!option!"=="5" goto rebuild
        if "!option!"=="6" goto logs
        if "!option!"=="7" goto logs_mysql
        if "!option!"=="8" goto logs_app
        if "!option!"=="9" goto status
        if "!option!"=="10" goto mysql
        if "!option!"=="11" goto list_usuarios
        if "!option!"=="0" (
            echo.
            echo [OK] Saindo...
            echo.
            exit /b 0
        )
        
        echo [X] Opcao invalida
        goto loop
        
        :start
        call :start_containers
        goto loop
        
        :stop
        call :stop_containers
        goto loop
        
        :down
        call :down_containers
        goto loop
        
        :clean
        call :clean_volumes
        goto loop
        
        :rebuild
        call :rebuild_app
        goto loop
        
        :logs
        call :view_logs
        goto loop
        
        :logs_mysql
        call :view_service_logs mysql
        goto loop
        
        :logs_app
        call :view_service_logs app
        goto loop
        
        :status
        call :check_status
        goto loop
        
        :mysql
        call :access_mysql
        goto loop
        
        :list_usuarios
        call :execute_sql "SELECT * FROM usuarios;"
        goto loop
        
    ) else (
        REM Modo comando
        if "%~1"=="start" (
            call :start_containers
        ) else if "%~1"=="stop" (
            call :stop_containers
        ) else if "%~1"=="down" (
            call :down_containers
        ) else if "%~1"=="clean" (
            call :clean_volumes
        ) else if "%~1"=="rebuild" (
            call :rebuild_app
        ) else if "%~1"=="logs" (
            call :view_logs
        ) else if "%~1"=="logs-mysql" (
            call :view_service_logs mysql
        ) else if "%~1"=="logs-app" (
            call :view_service_logs app
        ) else if "%~1"=="status" (
            call :check_status
        ) else if "%~1"=="mysql" (
            call :access_mysql
        ) else if "%~1"=="list-usuarios" (
            call :execute_sql "SELECT * FROM usuarios;"
        ) else (
            echo.
            echo [X] Comando invalido: %~1
            echo Uso: %0 {start^|stop^|down^|clean^|rebuild^|logs^|logs-mysql^|logs-app^|status^|mysql^|list-usuarios}
            echo.
            exit /b 1
        )
    )
    
    exit /b 0

REM Execute main
call :main %*
