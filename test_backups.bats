#!/usr/bin/env bats

remove_container() {
  docker rm --force mock_seafile || true
  rm /tmp/directory-{a,b}
  docker rm --force mock_ftp_server || true
  return 0
}

create_mock_container() {
  touch /tmp/directory-{a,b}
  docker run \
    --name mock_seafile \
    --volume /tmp/directory-a:/container-volume-a \
    --volume /tmp/directory-b:/container-volume-b \
  --detach busybox
}

create_mock_ftp_server() {
  docker run \
    --name mock_ftp_server \
    --volume /etc/default/:/container-volume-a \
    --volume /etc/docker/:/container-volume-b \
  --detach  busybox
}

teardown() {
  remove_container
}

log() {
  echo "$(tput setaf 6)status: ${status}$(tput sgr 0)"
  echo "$(tput setaf 6)output: ${output}$(tput sgr 0)"
}

@test "--get-volumes: return one volume per line as source:destination" {
  create_mock_container

  run ./backups.bash --get-volumes "mock_seafile"
  volumes_unsorted=($output)
  IFS=$'\n' volumes=($(sort <<<"${volumes_unsorted[*]}"))

  [[ ${#volumes[@]} == 2 ]]
  [[ ${volumes[0]} == "/tmp/directory-a" ]]

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

@test "--create: return archive filepath" {
  create_mock_container
  container_name="mock_seafile"
  archive_filepath="/tmp/$container_name.data-$(date '+%Y-%m-%d').tar.gz"

  run ./backups.bash --create "$container_name"

  last_line="${lines[@]:(-1)}"
  [[ "$last_line" == "$archive_filepath" ]]

  rm "$archive_filepath"
  remove_container
}

@test "--create: create data-volume archive" {
  create_mock_container
  container_name="mock_seafile"
  archive_filepath="/tmp/$container_name.data-$(date '+%Y-%m-%d').tar.gz"

  run ./backups.bash --create "$container_name"

  [[ -e "$archive_filepath" ]]

  rm "$archive_filepath"
  remove_container
}

@test "--create: contains the files" {
  create_mock_container
  container_name="mock_seafile"
  archive_filepath="/tmp/$container_name.data-$(date '+%Y-%m-%d').tar.gz"

  run ./backups.bash --create "$container_name"

  files_count="$(tar --list --file "$archive_filepath" | wc -l)"
  (( $files_count == 2 ))
  rm "$archive_filepath"
  remove_container
}

@test "--create: set user on archive file" {
  create_mock_container
  container_name="mock_seafile"
  archive_filepath="/tmp/$container_name.data-$(date '+%Y-%m-%d').tar.gz"

  run ./backups.bash --create "$container_name"

  [[ $(stat -c '%U' "$archive_filepath") == "$USER" ]]
  rm "$archive_filepath"
  remove_container
}

# @test "--send: send archive to FTP" {
#   run ./backups.bash --send "container_id"
#
#   echo "$output"
#   [[ "$output" == "Usage:"* ]]
# }
