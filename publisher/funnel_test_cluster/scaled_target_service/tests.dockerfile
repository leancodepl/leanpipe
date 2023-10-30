FROM mcr.microsoft.com/dotnet/sdk:8.0

USER $APP_UID

COPY --chown=$APP_UID out/scaled_target_service_tests /home/app/bin
ENTRYPOINT ["dotnet", "test", "/home/app/bin/ScaledTargetServiceTests.dll"]
