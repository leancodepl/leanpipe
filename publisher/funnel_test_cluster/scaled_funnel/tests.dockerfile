FROM mcr.microsoft.com/dotnet/sdk:9.0

USER $APP_UID

COPY --chown=$APP_UID out/scaled_funnel_tests /home/app/bin
ENTRYPOINT ["dotnet", "test", "/home/app/bin/ScaledFunnelTests.dll"]
