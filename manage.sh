#! /bin/bash
set -e

composes=( "mysql.yaml" "traefik.yaml" "laravel.yaml" "nginx.yaml" "adminer.yaml" "vue.yaml")

stop_containers(){
    for compose in ${composes[@]}; do
        docker compose -f $compose down
    done
}

start_containers(){
    local compose_files=("${composes[@]}")  

    if [ -n "$1" ]; then
        compose_files=("$1") 
    fi

    for compose in "${compose_files[@]}"; do
        echo "Starting services from $compose..."
        docker compose -f "$compose" up -d
        services=$(docker compose -f "$compose" config --services)
        for service in $services; do
            container_id=$(docker compose -f "$compose" ps -q "$service")
            if [ -z "$container_id" ]; then
                echo "Error: No container found for service $service in $compose"
                exit 1
            fi
            echo "Waiting for $service (container $container_id) to be healthy..."
            while true; do
                health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container_id" 2>/dev/null)
                if [ "$health_status" = "healthy" ]; then
                    echo "$service is healthy!"
                    break
                elif [ "$health_status" = "unhealthy" ]; then
                    echo "Error: $service is unhealthy!"
                    exit 1
                elif [ -z "$health_status" ]; then
                    echo "Error: Healthcheck not defined for $service in $compose"
                    exit 1
                fi
                sleep 2
            done
        done
    done
    echo "All containers are up and healthy!"
}

build_containers(){
    for compose in ${composes[@]}; do
        docker compose -f $compose up -d --build
    done
}

rebuild_containers(){
    for compose in ${composes[@]}; do
        docker compose -f $compose down -v
        docker compose -f $compose up -d --build
    done
}

rebuild_container(){
    docker compose -f $1 down -v
    docker compose -f $1 up -d --build
}

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "Traefik - Script for better management of containers"
            echo " "
            echo "options:"
            echo "-h, --help                            show brief help"
            echo "-start,                               start all containers"
            echo "-stop,                                stop all containers"
            echo "-build,                               build all containers"
            echo "-rebuild,                             rebuild all containers"
            echo "-build, --compose=compose.yaml        build all containers"
            exit 0
            ;;
        -start|-s)
            start_containers
            exit 0
            ;;
        -stop|-st)
            stop_containers
            exit 0
            ;;
        -build|-ba)
            case "$2" in
            -compose=*|-c=*)
                value=${2#*=}
                echo "build specific with value: $value"
                exit 0
                ;;
            *)
               echo "build all"
               exit 0
            ;;
            esac
            ;;
        -rebuild|-rba)
            echo "rebuild all"
            exit 0
            ;;
        *)
            echo "Invalid command entered."
            exit 1
        ;;
    esac
done