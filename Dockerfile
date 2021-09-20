# syntax=docker/dockerfile:1
# First stage: build the app
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Make and switch to the /app directory
WORKDIR /app

# Copy the C# project file into /app
COPY *.csproj ./

# Restore dependencies
RUN dotnet restore

# Now we can copy the rest of the source into /app
COPY ./ ./

# Build the project to the "out" directory
RUN dotnet publish -c Release -o out

# Second stage: run the app
FROM mcr.microsoft.com/dotnet/aspnet:5.0

# Switch back to /app
WORKDIR /app 

# Copy the binaries from the build stage into our new stage
COPY --from=build-env /app/out .

# Set the entrypoint for when the image is started
ENTRYPOINT ["dotnet", "auto-deploy-docker.dll"]