#!/bin/sh

if [ -z "$LOCALSTACK_HOST" ]; then
    echo "Environment variable LOCALSTACK_HOST not found." > /dev/stderr
    exit 1
fi

if [ ! -f "$CREATE_RESOURCES_SCRIPT" ]; then
    echo "Environment variable CREATE_RESOURCES_SCRIPT must contain a path to a .sh file." > /dev/stderr
    exit 1
fi

if [ -z "$TIMEOUT_LIMIT" ]; then
    echo "Environment variable TIMEOUT_LIMIT not found. Setting TIMEOUT_LIMIT to 90."
fi

TIMEOUT_COUNT=1
TIMEOUT_LIMIT=${TIMEOUT_LIMIT:-90}

waiting_resource() {
    resource=$1

    echo "Starting waiting loop for service $resource..."

    while true; do
        echo "Waiting resource $resource get ready (attempt $TIMEOUT_COUNT / $TIMEOUT_LIMIT)..."

        HEALTHCHECK_RESPONSE=$(curl -sl http://$LOCALSTACK_HOST:8080/health)

        echo "Healthcheck response: $HEALTHCHECK_RESPONSE"

        if [ "$(echo $HEALTHCHECK_RESPONSE | jq -r .services.$resource)" == "running" ]; then
            break
        fi

        sleep 1

        TIMEOUT_COUNT=$((TIMEOUT_COUNT + 1))

        if [ $TIMEOUT_COUNT -ge $TIMEOUT_LIMIT ]; then
            echo "Timeout limit exceeded. Aborting..." > /dev/stderr
            exit 1
        fi
    done
}


if [ -n "$SERVICES_TO_WAIT" ]; then
    echo "Waiting \"$SERVICES_TO_WAIT\" get ready before executing $CREATE_RESOURCES_SCRIPT..."

    for resource in $SERVICES_TO_WAIT; do
        waiting_resource "$resource"
    done
fi

echo "Executing $CREATE_RESOURCES_SCRIPT..."

/bin/sh "$CREATE_RESOURCES_SCRIPT"

if [ "$PREVENT_EXECUTION_FINISH" == "1" ]; then
    sleep 365d
else
    echo "Tip: you can prevent execution to finish setting PREVENT_EXECUTION_FINISH to 1."
fi
