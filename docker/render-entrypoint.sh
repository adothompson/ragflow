#!/bin/bash

# Render-compatible initialization
export PYTHONPATH=/ragflow:$PYTHONPATH

# Add health check endpoint
if [ -n "$PORT" ]; then
    nc -l -p $PORT -e echo -e "HTTP/1.1 200 OK\n\nHealthy" &
fi

exec "$@"
