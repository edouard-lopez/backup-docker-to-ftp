#!/usr/bin/env bats

remove_container() {
  docker rm --force seafile_test
  return 0
}

create_container() {
  docker run \
    --name seafile_test \
    --volume /etc/default/:/container-volume-a \
    --volume /etc/docker/:/container-volume-b \
  --detach  busybox &> /dev/null
}

teardown() {
  remove_container
}

log() {
  echo "$(tput setaf 6)status: ${status}$(tput sgr 0)"
  echo "$(tput setaf 6)output: ${output}$(tput sgr 0)"
}

@test "--get-volumes: return one volume per line as source:destination" {
  create_container

  run ./backups.bash --get-volumes "seafile_test"
  volumes_unsorted=($output)
  IFS=$'\n' volumes=($(sort <<<"${volumes_unsorted[*]}"))

  [[ ${#volumes[@]} == 2 ]]
  [[ ${volumes[0]} == "/etc/default" ]]

  remove_container
}

@test "--help: show help" {
  run ./backups.bash --help
  [[ "$output" == "Usage:"* ]]
}

@test "-h: show help" {
  run ./backups.bash -h
  [[ "$output" == "Usage:"* ]]
}

@test "--xyz: invalid argument" {
  run ./backups.bash --xyz
  [[ "$output" == "Error unknown argument." ]]
}

@test "--create: create data-volume archive" {
  create_container
  archive="/tmp/seafile_test.data-$(date '+%Y-%m-%d').tar.gz"

  run ./backups.bash --create "seafile_test"

  [[ -e "$archive" ]]
  files_count="$(tar --list --file "$archive" | wc -l)"
  (( $files_count > 2 ))
  [[ $(stat -c '%U' "$archive") == "$USER" ]]

  rm "$archive"
  remove_container
}

# @test "--send: send archive to FTP" {
#   run ./backups.bash --send "container_id"
#
#   echo "$output"
#   [[ "$output" == "Usage:"* ]]
# }
