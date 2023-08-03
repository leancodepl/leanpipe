FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS dotnet-build-env

RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

WORKDIR /build
COPY . .

WORKDIR /build/src/LeanPipe.Example
RUN npm i && npm run release

WORKDIR /build
RUN dotnet publish -o out -c Release

FROM mcr.microsoft.com/dotnet/aspnet:8.0-preview

ENV ASPNETCORE_URLS=http://*:8080
EXPOSE 8080

WORKDIR /app
COPY --from=dotnet-build-env /build/out/ .
ENTRYPOINT ["dotnet", "LeanPipe.Example.dll"]

