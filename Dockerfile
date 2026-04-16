# Etapa 1: Build
FROM maven:3.8.1-eclipse-temurin-17 AS builder

WORKDIR /build

# Copiar arquivos de configuração do Maven
COPY pom.xml .

# Copiar código fonte (antes do build)
COPY src ./src

# Build do projeto - tenta com opções relaxadas para Maven
RUN mvn clean package -DskipTests -o || mvn clean package -DskipTests

# Etapa 2: Runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copiar JAR da etapa de build
COPY --from=builder /build/target/*.jar app.jar

# Expor porta
EXPOSE 8080

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
