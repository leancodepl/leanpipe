FROM mcr.microsoft.com/dotnet/aspnet:10.0

USER $APP_UID

ENV ASPNETCORE_ENVIRONMENT=Development
ARG MassTransit__RabbitMq__Url

COPY --chown=$APP_UID out/testapp2 /home/app/bin
ENTRYPOINT ["dotnet", "/home/app/bin/TestApp2.dll"]
