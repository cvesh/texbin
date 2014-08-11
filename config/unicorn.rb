# Preloads application before forking worker processes
preload_app true

# Amount of unicorn workers to spin up
worker_processes 2

# Restarts workers that hang for that many seconds
timeout 10
