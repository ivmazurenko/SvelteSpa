FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y libpng-dev libjpeg-dev curl libxi6 build-essential libgl1-mesa-glx
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs


WORKDIR /src
COPY ["EntryPoint/EntryPoint.csproj", "EntryPoint/"]
RUN dotnet restore "EntryPoint/EntryPoint.csproj"
COPY . .
WORKDIR "/src/EntryPoint"
RUN dotnet build "EntryPoint.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EntryPoint.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EntryPoint.dll"]
