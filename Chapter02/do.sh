#!/bin/bash

COLUMNS="`tput cols`"
LINES="`tput lines`"
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

COMPOSE_FILES="-f docker-compose.yml"

DOCKER_COMPOSE="docker compose ${COMPOSE_FILES}"

# Game-specific commands:
_requires() {
    service="$1"
    $DOCKER_COMPOSE ps -q $service &> /dev/null
    if [[ "$?" == 1 ]]; then
        echo "'$service' service is not running. Please run \`start\` first."
        exit 1
    fi
}

build() {
    $DOCKER_COMPOSE build --force-rm "${@:3}"
}

compose() {
    $DOCKER_COMPOSE "$@"
}

start() {
    $DOCKER_COMPOSE up "$@"
}

stop() {
    $DOCKER_COMPOSE down "$@"
}

shell() {
    _requires web_run
    exec -w /code/mysite web_run /bin/bash
}

migrate() {
    _requires web_run
    exec -w /code/mysite web_run ./manage.py migrate "$@"
}

makemigrations() {
    _requires web_run
    exec -w /code/mysite web_run python manage.py makemigrations "$@"
}

check() {
    _requires web_run
    exec -w /code/mysite web_run ./manage.py check
}

exec() {
    $DOCKER_COMPOSE exec -e COLUMNS -e LINES "$@"
}

_usage() {
    cat <<USAGE
Convenience wrapper around docker compose.

Usage:

    ${BOLD}build${NORMAL} [<arg>]

        Builds all the images (or the ones specified).


    ${BOLD}exec${NORMAL} [<arg>]

        Execute a command in a container

    ${BOLD}compose${NORMAL}

        Minimal wrapper around docker-compose, just ensures the correct config files are loaded.

    ${BOLD}migrate${NORMAL} [<arg>]

        Apply any unapplied django migrations

    ${BOLD}makemigrations${NORMAL} [<arg>]

        Create a new Django migration, using the given args

    ${BOLD}check${NORMAL}

        Validate django settings

    ${BOLD}shell${NORMAL}

        Opens a bash terminal in web_run

    ${BOLD}start${NORMAL} [<arg>]

        Start the django server (and dependent services)
        You can pass `-d` for running detached.

    ${BOLD}stop${NORMAL} [<arg>]

        Stop the django server (and dependent services)

USAGE
}

if [ "$1" == "" ]; then
    _usage
fi

$*
