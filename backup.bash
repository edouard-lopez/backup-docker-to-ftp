#!/usr/bin/env bash
# USAGE
#   ./backup.bash --help

if [[ -z $FTP_USER && -z $FTP_PASSWORD ]]; then
  scriptDir=$(dirname "$(readlink -f "$0")")
  # shellcheck source=./credentials.conf
  source $scriptDir/credentials.conf
fi

help() {
  echo "Usage:" >&2
  echo "    backup.bash [--create|--get-volumes|--help] container_id" >&2
  echo "    backup.bash --send archive.tar.gz ftp_host" >&2
  echo "    backup.bash --remove archive.tar.gz" >&2
  exit 2
}

get_volumes() {
  local container_name="$1"
  docker inspect "$container_name" --format "{{ range .Mounts }}{{ .Source }} {{ end }}"
}

create_archive() {
  local container_name="$1"
  local date
  files="$(get_volumes "$container_name")"
  filepath="/tmp/$container_name.data-$(date '+%Y-%m-%d').tar.gz"

  tar --create --gzip --file "$filepath" $files
  chown "$USER":"$USER" "$filepath"

  echo "$filepath"
}

send_archive() {
  local archive_filepath="$1"
  local ftp_host="$2"
  curl \
    --upload-file "$archive_filepath" "ftp://$ftp_host" \
    --user "$FTP_USER":"$FTP_PASSWORD"
}

remove_tmp() {
  local archive_filepath="$1"
  rm --force "$archive_filepath"
}

optspec=":hv-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
          case "${OPTARG}" in
            create)
              create_archive "${!#}";;
            send)
              send_archive "${@:(-2)}";;
            get-volumes)
              get_volumes "${!#}";;
            remove)
              remove_tmp "${!#}";;
            help)
              help;;
            *)
              echo "Error unknown argument.";
              exit 127;;
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
