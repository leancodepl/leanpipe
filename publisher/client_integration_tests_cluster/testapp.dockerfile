FROM mcr.microsoft.com/dotnet/aspnet:9.0

USER $APP_UID

ENV ASPNETCORE_ENVIRONMENT=Development
ARG EnableFunnel

COPY --chown=$APP_UID out/testapp /home/app/bin
ENTRYPOINT ["dotnet", "/home/app/bin/LeanCode.Pipe.ClientIntegrationTestsApp.dll"]
