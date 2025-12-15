FROM mcr.microsoft.com/dotnet/aspnet:10.0

USER $APP_UID

COPY --chown=$APP_UID out/multiple_services_tests /home/app/bin
ENTRYPOINT ["/home/app/bin/MultipleServicesTests", "--explicit", "only"]
