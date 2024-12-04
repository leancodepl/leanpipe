FROM mcr.microsoft.com/dotnet/aspnet:9.0

USER $APP_UID

ENV ASPNETCORE_ENVIRONMENT=Development
ARG MassTransit__RabbitMq__Url

COPY --chown=$APP_UID out/testapp_funnel /home/app/bin
ENTRYPOINT ["dotnet", "/home/app/bin/TestAppFunnel.dll"]
