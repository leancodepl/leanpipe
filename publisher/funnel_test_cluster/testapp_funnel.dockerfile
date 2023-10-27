FROM mcr.microsoft.com/dotnet/aspnet:8.0

USER $APP_UID

ENV ASPNETCORE_ENVIRONMENT=Development

COPY --chown=$APP_UID out/testapp_funnel /home/app/bin
ENTRYPOINT ["dotnet", "/home/app/bin/TestAppFunnel.dll"]
