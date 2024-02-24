# Use a imagem Alpine Linux como base
FROM alpine:latest

# Instale o Go
RUN apk --no-cache add go

# Desative o suporte a módulos no Go
RUN go env -w GO111MODULE=off

# Crie um diretório de trabalho
WORKDIR /app

# Copie o código-fonte para o diretório de trabalho
COPY main.go .

# Compile o aplicativo Go
RUN go build -o app

# Limpar pacotes desnecessários
RUN apk del go && rm -rf /var/cache/apk/*

# Configure a imagem mínima do scratch como a imagem final
FROM scratch

# Copie apenas os arquivos necessários do estágio de compilação
COPY --from=0 /app/app /app/app

# Defina o comando padrão para executar o aplicativo
CMD ["/app/app"]
