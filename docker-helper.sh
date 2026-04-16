#!/bin/bash

# =====================================================
# Script de Utilidade - Docker Compose Helper
# Projeto: User Country Service
# =====================================================

set -e

DOCKER_COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="usuario"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções
print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Verificar Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose não está instalado"
        exit 1
    fi
    
    print_success "Docker e Docker Compose encontrados"
}

# Iniciar containers
start_containers() {
    print_header "Iniciando containers"
    docker-compose -f $DOCKER_COMPOSE_FILE up -d
    print_success "Containers iniciados"
    
    print_header "Aguardando inicialização..."
    sleep 5
    
    print_header "Status dos containers"
    docker-compose -f $DOCKER_COMPOSE_FILE ps
}

# Parar containers
stop_containers() {
    print_header "Parando containers"
    docker-compose -f $DOCKER_COMPOSE_FILE stop
    print_success "Containers parados"
}

# Parar e remover
down_containers() {
    print_header "Removendo containers"
    docker-compose -f $DOCKER_COMPOSE_FILE down
    print_success "Containers removidos"
}

# Limpar volumes
clean_volumes() {
    print_warning "Removendo volumes (dados serão perdidos)"
    docker-compose -f $DOCKER_COMPOSE_FILE down -v
    print_success "Volumes removidos"
}

# Ver logs
view_logs() {
    print_header "Logs da aplicação"
    docker-compose -f $DOCKER_COMPOSE_FILE logs -f
}

# Ver logs de um serviço específico
view_service_logs() {
    local service=$1
    print_header "Logs de $service"
    docker-compose -f $DOCKER_COMPOSE_FILE logs -f $service
}

# Rebuild
rebuild_app() {
    print_header "Fazendo rebuild da aplicação"
    docker-compose -f $DOCKER_COMPOSE_FILE up --build -d
    print_success "Rebuild concluído"
}

# Status
check_status() {
    print_header "Status dos containers"
    docker-compose -f $DOCKER_COMPOSE_FILE ps
    
    print_header "Testando conectividade"
    
    # Testar MySQL
    if docker-compose -f $DOCKER_COMPOSE_FILE exec -T mysql mysqladmin ping -h localhost -uroot -proot123 &> /dev/null; then
        print_success "MySQL está respondendo"
    else
        print_error "MySQL não está respondendo"
    fi
    
    # Testar aplicação
    if curl -s http://localhost:8080/health &> /dev/null; then
        print_success "Aplicação está respondendo"
    else
        print_error "Aplicação não está respondendo (ainda pode estar iniciando)"
    fi
}

# Acessar MySQL
access_mysql() {
    print_header "Acessando MySQL"
    print_warning "Senha: usuario_pass"
    docker exec -it usuario-mysql mysql -u usuario_user -p usuario_db
}

# Executar query SQL
execute_sql() {
    local query=$1
    print_header "Executando query"
    docker-compose -f $DOCKER_COMPOSE_FILE exec -T mysql mysql -u usuario_user -pusuario_pass usuario_db -e "$query"
}

# Menu
show_menu() {
    echo ""
    echo -e "${BLUE}User Country Service - Docker Helper${NC}"
    echo "======================================"
    echo "1) Iniciar containers"
    echo "2) Parar containers"
    echo "3) Remover containers"
    echo "4) Limpar volumes (CUIDADO: dados serão perdidos)"
    echo "5) Fazer rebuild"
    echo "6) Ver logs"
    echo "7) Ver logs do MySQL"
    echo "8) Ver logs da aplicação"
    echo "9) Verificar status"
    echo "10) Acessar MySQL"
    echo "11) Listar usuários"
    echo "0) Sair"
    echo "======================================"
    echo -n "Escolha uma opção: "
}

# Main
main() {
    check_docker
    
    if [ $# -eq 0 ]; then
        # Modo interativo
        while true; do
            show_menu
            read -r option
            
            case $option in
                1) start_containers ;;
                2) stop_containers ;;
                3) down_containers ;;
                4) clean_volumes ;;
                5) rebuild_app ;;
                6) view_logs ;;
                7) view_service_logs "mysql" ;;
                8) view_service_logs "app" ;;
                9) check_status ;;
                10) access_mysql ;;
                11) execute_sql "SELECT * FROM usuarios;" ;;
                0) print_success "Saindo..."; exit 0 ;;
                *) print_error "Opção inválida" ;;
            esac
        done
    else
        # Modo comando
        case $1 in
            start) start_containers ;;
            stop) stop_containers ;;
            down) down_containers ;;
            clean) clean_volumes ;;
            rebuild) rebuild_app ;;
            logs) view_logs ;;
            logs-mysql) view_service_logs "mysql" ;;
            logs-app) view_service_logs "app" ;;
            status) check_status ;;
            mysql) access_mysql ;;
            list-usuarios) execute_sql "SELECT * FROM usuarios;" ;;
            *) 
                print_error "Comando inválido: $1"
                echo "Uso: $0 {start|stop|down|clean|rebuild|logs|logs-mysql|logs-app|status|mysql|list-usuarios}"
                exit 1
                ;;
        esac
    fi
}

main "$@"
