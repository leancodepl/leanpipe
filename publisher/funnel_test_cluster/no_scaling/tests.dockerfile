FROM mcr.microsoft.com/dotnet/sdk:10.0

USER $APP_UID

COPY --chown=$APP_UID out/no_scaling_tests /home/app/bin
ENTRYPOINT ["dotnet", "test", "/home/app/bin/NoScalingTests.dll"]
