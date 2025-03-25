#!/bin/bash 

echo "stash any local changes"
git stash

echo "pulling latest codebase"
git pull origin main

echo "rebuilding docker image / rebooting rails"
docker compose up -d --build