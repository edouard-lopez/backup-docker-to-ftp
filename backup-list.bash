#!/usr/bin/env bash
# USAGE
#   ./backup-list.bash

scriptDir=$(dirname "$(readlink -f "$0")")
# shellcheck source=./credentials.conf
source $scriptDir/credentials.conf

while IFS='' read -r container_id || [[ -n "$container_id" ]]; do
  archive_filepath=$($scriptDir/backup.bash --create $container_id)
  $scriptDir/backup.bash --send "$archive_filepath" $FTP_HOST
  $scriptDir/backup.bash --remove "$archive_filepath"
done < $scriptDir/dockers-to-backup.txt
