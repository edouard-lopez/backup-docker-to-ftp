#!/usr/bin/env bash

help() {
  echo "Usage: [--create|--get-volumes|--help] container_id" >&2
  echo "Usage: [--send]" >&2
  exit 2
}

get_volumes() {
  local container_name="$1"
  docker inspect "$container_name" --format "{{ range .Mounts }}{{ .Source }} {{ end }}"
}

create_archive() {
  local container_name="$1"
  local date
  date="$(date '+%Y-%m-%d')"
  files="$(get_volumes "$container_name")"

  sudo tar --create --gzip --file "/tmp/$container_name.data-$date.tar.gz" $files
  sudo chown "$USER":"$USER" "/tmp/$container_name.data-$date.tar.gz"
}

send_archive() {
  echo "implement ftp"
}


optspec=":hv-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
          case "${OPTARG}" in
            create)
              create_archive "${!#}";;
            send)
              send_archive "${!#}";;
            get-volumes)
              get_volumes "${!#}";;
            help)
              help;;
            *)
              echo "Error unknown argument.";;
          esac;;
        h)
            help;;
        v)
            echo "Parsing option: '-${optchar}'" >&2
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done
