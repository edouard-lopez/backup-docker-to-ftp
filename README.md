[![Build Status](https://travis-ci.org/edouard-lopez/backup-docker-to-ftp.svg?branch=master)](https://travis-ci.org/edouard-lopez/backup-docker-to-ftp)

> Easily backup your docker container to a FTP server.

### Usage

prepare context

    export FTP_USER="johndoe"
    export FTP_PASSWORD="test"
    export FTP_HOST="backup.server.org"

Then run the command

    # container_id="1e52f28bb583"
    archive_filepath=$(backup.bash --create $container_id)
    backup.bash --send "$archive_filepath" FTP_HOST


### Install

**Requirements:** `curl`.

    git clone git@github.com:edouard-lopez/backup-docker-to-ftp.git


### Test

**Requirements:** [`bats`](https://github.com/sstephenson/bats).

    bats ./test_backup.bats

  :warning:**Note:** `busybox` and `panubo/vsftpd` images will be **–silently– pulled if missing** (takes a few minutes).
