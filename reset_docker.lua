local commands = {
    -- -- Stop Docker Compose and remove all containers
    "sudo docker-compose down",
    
    -- Remove all containers
    "sudo docker rm $(sudo docker ps -a -q)",
    
    -- Remove all Docker images
    "sudo docker rmi $(sudo docker images -q)",
    
    -- Remove all Docker volumes
    "sudo docker volume rm $(sudo docker volume ls -q)",
    
    -- Remove Docker network
    "sudo docker network rm wp-gen_wp-network",
    
    -- Prune unused Docker resources
    "sudo docker system prune -a --volumes"
}

-- Function to execute each command
for _, command in ipairs(commands) do
    print("Executing: " .. command)
    local success = os.execute(command)
    if success then
        print("Command executed successfully!")
    else
        print("Error executing command: " .. command)
    end
end