#!/bin/bash

# List of microservices to run
declare -a services=("my-ttb-authorization-api" "outbound-email-service-api" "messaging-data-management-api")

# Loop through each microservice and run the mvnw command
for service in "${services[@]}"; do
    echo "Starting $service in the background..."
    cd "$service" || exit
    ./mvnw &
    cd - || exit
    sleep 20  # Optional: Give some time for the service to start
done

