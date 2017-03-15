#!/usr/bin/env bash

for i in "$@"; do
	case "$i" in
		create)
      create_archive
			shift # past argument=value
			;;
		*)
  esac
done


create_archive() {
  local container_id="$1"
  touch /tmp/"$container_id"
}
