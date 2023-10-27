FROM mcr.microsoft.com/dotnet/aspnet:8.0

USER $APP_UID

ENV ASPNETCORE_ENVIRONMENT=Development

COPY --chown=$APP_UID out/testapp1 /home/app/bin
ENTRYPOINT ["dotnet", "/home/app/bin/TestApp1.dll"]
