#!/bin/bash

# Render-compatible initialization
export PYTHONPATH=/ragflow:$PYTHONPATH
exec "$@"
