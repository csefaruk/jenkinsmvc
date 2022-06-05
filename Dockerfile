#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["jenkinsmvc/jenkinsmvc.csproj", "jenkinsmvc/"]
RUN dotnet restore "jenkinsmvc/jenkinsmvc.csproj"
COPY . .
WORKDIR "/src/jenkinsmvc"
RUN dotnet build "jenkinsmvc.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "jenkinsmvc.csproj" -c Release -o /app/publish

EXPOSE  8081

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "jenkinsmvc.dll"]