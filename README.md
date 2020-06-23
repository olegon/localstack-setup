# localstack-setup docker image

You can use this image to wait `localstack/localstack` get ready and create your resources.

## Environment Variables

### LOCALSTACK_HOST

The host of the localstack container. Example: "localstack_container_name"

### CREATE_RESOURCES_SCRIPT

Pathname of the script that create resources. Example: "/mount/point/create-resources.sh"

### SERVICES_TO_WAIT (optional)

Services separated by whitespace that will wait to get ready. Example: "s3 dynamodb"

### TIMEOUT_LIMIT (optional)

How many requests to healthcheck it should wait. Example: "30". Default: "90"

### PREVENT_EXECUTION_FINISH (optional)

If equals `1`, prevents container to finish (365 days) after `CREATE_RESOURCES_SCRIPT` execution.
