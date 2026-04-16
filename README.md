# 📱 User Country Service

API REST em Spring Boot que consome dados da [Random User Generator API](https://randomuser.me/api/) e os transforma em um modelo de domínio bem estruturado.

**Status**: ✅ Projeto finalizado e estável

## 🎯 Objetivo

Este projeto é um **estudo de caso completo** de uma aplicação Spring Boot que demonstra:

- Consumo de APIs externas via `RestTemplate`
- Transformação de dados (DTO → Domínio)
- Estrutura MVC limpa (Controller → Service → Client)
- Tratamento de exceções
- Separação de responsabilidades
- Configuração eficiente

## 🛠️ Tecnologias

| Tecnologia | Versão | Propósito |
|-----------|--------|----------|
| Java | 17 | Linguagem |
| Spring Boot | 3.5.1 | Framework |
| Maven | 3.8+ | Build |
| RestTemplate | 3.5.1 | HTTP Client |
| Lombok | - | Menos boilerplate |
| Docker | 20.10+ | Containerização (opcional) |

## 🚀 Quick Start

### Opção 1: Executar Localmente (Recomendado)

```bash
# Compilar
mvn clean package

# Executar
mvn spring-boot:run

# Ou executar diretamente o JAR
java -jar target/user-country-service-1.0.0.jar
```

A aplicação estará disponível em: `http://localhost:8080`

### Opção 2: Executar com Docker

```bash
# Build
docker build -t user-country-service .

# Run
docker run -p 8080:8080 user-country-service
```

Ou usando Docker Compose:
```bash
docker-compose up -d
```

## 📡 Endpoints

### 1. Health Check
```bash
GET /health
```

**Resposta (200 OK):**
```json
{
  "status": "UP",
  "timestamp": "2024-01-15T10:30:45.000Z"
}
```

Usado para monitoramento e verificação da aplicação.

### 2. Buscar Usuários
```bash
GET /usuarios?quantidade=5
```

**Parâmetros:**
- `quantidade` (int, optional, default=1): Número de usuários a retornar (1-5000)

**Resposta (200 OK):**
```json
[
  {
    "nome": "Mr. João Silva",
    "email": "joao.silva@example.com",
    "genero": "M",
    "idade": 28,
    "telefone": "+55 11 98765-4321",
    "nacionalidade": "Brasileira",
    "cidade": "São Paulo",
    "estado": "SP",
    "pais": "Brasil",
    "fotoUrl": "https://randomuser.me/api/portraits/men/1.jpg"
  },
  ...
]
```

**Tratamento de Erros:**

```bash
# Quantidade inválida (0 ou negativa)
GET /usuarios?quantidade=0
# Resposta: 400 Bad Request
# {"mensagem": "A quantidade deve ser maior que zero..."}

# Quantidade acima do limite
GET /usuarios?quantidade=6000
# Resposta: 400 Bad Request
# {"mensagem": "A quantidade máxima permitida é 5000..."}

# Erro na API externa
# Resposta: 503 Service Unavailable
# {"mensagem": "Erro ao chamar API externa..."}
```

## 📁 Estrutura do Projeto

```
src/main/java/com/project/user_country_service/
├── UserCountryServiceApplication.java  # Classe main
├── controller/
│   ├── HealthController.java           # GET /health
│   └── UsuarioController.java          # GET /usuarios
├── service/
│   └── UsuarioService.java             # Lógica de negócio
├── client/
│   └── RandomUserClient.java           # Integração com API externa
├── domain/
│   └── Usuario.java                    # Modelo de domínio
├── dto/
│   └── randomuser/
│       ├── RandomUserApiResponse.java  # Resposta da API
│       ├── RandomUserResult.java       # Resultado individual
│       ├── RandomUserName.java         # Nome
│       ├── RandomUserLocation.java     # Localização
│       ├── RandomUserDob.java          # Data de nascimento
│       └── RandomUserPicture.java      # Foto
├── exception/
│   ├── ParametroInvalidoException.java # Exceção customizada
│   ├── ApiExternaException.java        # Erro da API
│   └── GlobalExceptionHandler.java     # Handler global
└── config/
    └── RestTemplateConfig.java         # Configuração de HTTP

src/main/resources/
├── application.properties               # Configurações
└── application-docker.properties        # Config para Docker (opcional)

docker/
└── init.sql                            # Script SQL para inicialização (opcional)
```

## 🔧 Configuração

### application.properties

```properties
# Aplicação
spring.application.name=user-country-service

# API Externa
randomuser.api.url=https://randomuser.me/api/
randomuser.api.timeout.connect=5000  # 5 segundos
randomuser.api.timeout.read=5000     # 5 segundos
```

## 🏗️ Arquitetura

### Fluxo de Dados

```
Requisição HTTP GET /usuarios
    ↓
UsuarioController (recebe parâmetro)
    ↓
UsuarioService (valida, orquestra)
    ↓
RandomUserClient (chama API externa)
    ↓
API RandomUser (randomuser.me/api/)
    ↓
RandomUserApiResponse (DTO)
    ↓
Conversão: DTO → Domínio Usuario
    ↓
List<Usuario>
    ↓
Resposta JSON
```

### Componentes

**Controller:**
- Recebe requisições HTTP
- Valida parâmetros básicos
- Delega ao Service

**Service:**
- Orquestra a lógica de negócio
- Valida regras de negócio (ex: quantidade máxima)
- Chama o Client
- Converte DTO em Domínio

**Client:**
- Responsável por chamar API externa
- Mapeia resposta em DTO
- Gerencia timeouts e conexões

**Domain:**
- Modelo de negócio puro
- Sem dependências de framework
- Pronto para persistência futura

## ✨ Transformação de Dados

A aplicação transforma dados da [Random User API](https://randomuser.me/docs) para um modelo simplificado:

**Entrada (Random User API):**
```json
{
  "results": [{
    "name": { "title": "Mr", "first": "João", "last": "Silva" },
    "email": "joao.silva@example.com",
    "gender": "male",
    "dob": { "date": "1996-05-15T12:30:00.000Z", "age": 28 },
    "phone": "+55 11 98765-4321",
    "location": {
      "street": "...",
      "city": "São Paulo",
      "state": "SP",
      "country": "Brazil"
    },
    "picture": { "large": "https://..." }
  }]
}
```

**Saída (Domínio Usuario):**
```json
{
  "nome": "Mr. João Silva",
  "email": "joao.silva@example.com",
  "genero": "M",
  "idade": 28,
  "telefone": "+55 11 98765-4321",
  "nacionalidade": "Brasileira",
  "cidade": "São Paulo",
  "estado": "SP",
  "pais": "Brasil",
  "fotoUrl": "https://..."
}
```

## ❌ Tratamento de Erros

A aplicação possui tratamento centralizado de exceções via `GlobalExceptionHandler`:

```
ParametroInvalidoException (400) → Parâmetro inválido
ApiExternaException (503)        → Erro na API externa
RuntimeException (500)            → Erro geral
```

**Exemplo de erro:**
```bash
curl http://localhost:8080/usuarios?quantidade=abc

# Resposta: 400 Bad Request
{
  "mensagem": "A quantidade deve ser maior que zero. Valor informado: -1"
}
```

## 🧪 Testes

Execute os testes com:
```bash
mvn test
```

Testes estão em: `src/test/java/com/project/user_country_service/`

## 🐳 Docker (Opcional)

Se desejar containerizar:

```bash
# Build
docker build -t user-country-service:1.0.0 .

# Run
docker run -p 8080:8080 user-country-service:1.0.0

# Ou com Docker Compose
docker-compose up -d
```

**Dockerfile:**
- Multi-stage build para otimização
- Imagem base: Eclipse Temurin 17 JRE
- Tamanho final: ~150MB

## ⚙️ Melhorias Futuras (Não Implementadas Intencionalmente)

Este projeto foi finalizado intencionalmente neste estado. Possíveis extensões incluem:

- [ ] Persistência em banco de dados (JPA)
- [ ] Autenticação/Autorização
- [ ] Cache de requisições
- [ ] Documentação OpenAPI/Swagger
- [ ] Testes mais robustos
- [ ] Monitoramento com Prometheus
- [ ] Logging estruturado
- [ ] CI/CD com GitHub Actions

## 📋 Limitações Conhecidas

1. **Sem Persistência**: Dados não são salvos, apenas transformados na memória
2. **Sem Autenticação**: Endpoints abertos para todos
3. **Sem Cache**: Cada requisição chama a API externa
4. **Sem Paginação**: Retorna todos os resultados
5. **Sem Rate Limiting**: Sem proteção contra abuso
6. **API Externa**: Dependente da disponibilidade do randomuser.me

## 🔗 Dependências Externas

- **Random User Generator API**: https://randomuser.me/api/
  - Limite: 5000 requisições por requisição
  - Sem autenticação necessária
  - Resposta JSON

## 📚 Referências

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [RestTemplate Guide](https://spring.io/guides/gs/consuming-rest/)
- [Random User API Docs](https://randomuser.me/documentation)
- [Maven Documentation](https://maven.apache.org/)

## 📄 Licença

Este é um projeto de estudo. Use livremente para fins educacionais.

## ✅ Checklist Entrega

- [x] Aplicação sobe sem erros
- [x] Endpoints funcionam corretamente
- [x] Código organizado e legível
- [x]estrutura limpa (sem arquivos soltos)
- [x] Documentação clara e completa
- [x] Projeto compila e roda primeiro tempo
- [x] Tratamento de erros implementado
- [x] Separação de responsabilidades

## 🎓 Conclusão

Este é um exemplo prático completo de uma aplicação Spring Boot moderna e bem estruturada, ideal para:

- Aprendizado de Spring Boot
- Exemplo de boas práticas
- Base para projetos maiores
- Portfolio/GitHub

**Projeto finalizado intencionalmente neste estado.**

---

**Versão**: 1.0.0  
**Data**: 2024  
**Status**: ✅ Pronto para Produção de Estudo  
**Java**: 17  
**Spring Boot**: 3.5.1  
