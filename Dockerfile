#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
RUN apt-get update
RUN apt-get install -y npm
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
RUN apt-get update
RUN apt-get install -y npm
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

COPY ["cool-gen-kansasdcf/Cse/Cse.csproj", "cool-gen-kansasdcf/Cse/"]
COPY ["Bphx.Cool.Net/Bphx.Cool.Log/Bphx.Cool.Log.csproj", "Bphx.Cool.Net/Bphx.Cool.Log/"]
COPY ["Bphx.Cool.Net/Bphx.Cool.Core/Bphx.Cool.Core.csproj", "Bphx.Cool.Net/Bphx.Cool.Core/"]
COPY ["kansasdcf-gen-code/GOV.KS.DCF.CSS.Common.BL/GOV.KS.DCF.CSS.Common.BL.csproj", "kansasdcf-gen-code/GOV.KS.DCF.CSS.Common.BL/"]
COPY ["kansasdcf-frameworks-code/Interfaces/MDSY.Framework.Interfaces/MDSY.Framework.Interfaces.csproj", "kansasdcf-frameworks-code/Interfaces/MDSY.Framework.Interfaces/"]
COPY ["kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Interfaces/MDSY.Framework.Buffer.Interfaces.csproj", "kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Interfaces/"]
COPY ["kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Unity/MDSY.Framework.Buffer.Unity.csproj", "kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Unity/"]
COPY ["kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Common/MDSY.Framework.Buffer.Common.csproj", "kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Common/"]
COPY ["kansasdcf-frameworks-code/Control/MDSY.Framework.Control.CICS/MDSY.Framework.Control.CICS.csproj", "kansasdcf-frameworks-code/Control/MDSY.Framework.Control.CICS/"]
COPY ["kansasdcf-frameworks-code/Services/MDSY.Framework.Service.Interfaces/MDSY.Framework.Service.Interfaces.csproj", "kansasdcf-frameworks-code/Services/MDSY.Framework.Service.Interfaces/"]
COPY ["kansasdcf-frameworks-code/Core/MDSY.Framework.Core/MDSY.Framework.Core.csproj", "kansasdcf-frameworks-code/Core/MDSY.Framework.Core/"]
COPY ["kansasdcf-frameworks-code/Configuration/MDSY.Framework.Configuration.Common/MDSY.Framework.Configuration.Common.csproj", "kansasdcf-frameworks-code/Configuration/MDSY.Framework.Configuration.Common/"]
COPY ["kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Services/MDSY.Framework.Buffer.Services.csproj", "kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Services/"]
COPY ["kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.BaseClasses/MDSY.Framework.Buffer.BaseClasses.csproj", "kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.BaseClasses/"]
COPY ["kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Extensions/MDSY.Framework.Buffer.Extensions.csproj", "kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Extensions/"]
COPY ["kansasdcf-frameworks-code/Data/MDSY.Framework.Data.Vsam/MDSY.Framework.Data.Vsam.csproj", "kansasdcf-frameworks-code/Data/MDSY.Framework.Data.Vsam/"]
COPY ["kansasdcf-frameworks-code/IO/MDSY.Framework.IO.Common/MDSY.Framework.IO.Common.csproj", "kansasdcf-frameworks-code/IO/MDSY.Framework.IO.Common/"]
COPY ["kansasdcf-frameworks-code/IO/MDSY.Framework.IO.RemoteBatch/MDSY.Framework.IO.RemoteBatch.csproj", "kansasdcf-frameworks-code/IO/MDSY.Framework.IO.RemoteBatch/"]
COPY ["kansasdcf-frameworks-code/Data/MDSY.Framework.Data.SQL/MDSY.Framework.Data.SQL.csproj", "kansasdcf-frameworks-code/Data/MDSY.Framework.Data.SQL/"]
COPY ["kansasdcf-frameworks-code/UI/MDSY.Framework.UI.Angular/MDSY.Framework.UI.Angular.csproj", "kansasdcf-frameworks-code/UI/MDSY.Framework.UI.Angular/"]
COPY ["kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Implementation/MDSY.Framework.Buffer.Implementation.csproj", "kansasdcf-frameworks-code/Buffer/MDSY.Framework.Buffer.Implementation/"]
COPY ["kansasdcf-gen-code/GOV.KS.DCF.CSS.Batch.BL/GOV.KS.DCF.CSS.Batch.BL.csproj", "kansasdcf-gen-code/GOV.KS.DCF.CSS.Batch.BL/"]
COPY ["cool-gen-kansasdcf/Core/Core.csproj", "cool-gen-kansasdcf/Core/"]

RUN dotnet restore "cool-gen-kansasdcf/Cse/Cse.csproj"
COPY . .
WORKDIR "/src/Bphx.Cool.Net/Bphx.Cool.Core"
RUN dotnet build "Bphx.Cool.Core.csproj" -c Release -o /src/Bphx.Cool.Net/Bphx.Cool.Core/bin/Release

WORKDIR "/src/Bphx.Cool.Net/Bphx.Cool.Log"
RUN dotnet build "Bphx.Cool.Log.csproj" -c Release -o /src/Bphx.Cool.Net/Bphx.Cool.Log/bin/Release

WORKDIR "/src/cool-gen-kansasdcf/Cse"
RUN dotnet build "Cse.csproj" -c Release -o /app/build

WORKDIR "/app/build"
COPY ["cool-gen-kansasdcf/Cse/ClientApp", "/"]
COPY ["cool-gen-kansasdcf/Cse/wwwroot", "/"]

WORKDIR "/src/cool-gen-kansasdcf/Cse"
FROM build AS publish
RUN dotnet publish "Cse.csproj" -c Release -o /app/publish

WORKDIR "/app/publish"
COPY ["cool-gen-kansasdcf/Cse/ClientApp", "/"]
COPY ["cool-gen-kansasdcf/Cse/wwwroot", "/"]

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Cse.dll"]