FROM mcr.microsoft.com/dotnet/sdk:9.0

USER $APP_UID

COPY --chown=$APP_UID out/multiple_services_tests /home/app/bin
ENTRYPOINT ["dotnet", "test", "/home/app/bin/MultipleServicesTests.dll"]
