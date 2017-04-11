[![Build Status](https://travis-ci.org/edouard-lopez/backup-docker-to-ftp.svg?branch=master)](https://travis-ci.org/edouard-lopez/backup-docker-to-ftp)

> Easily backup your docker container to a FTP server.

### Usage

**Configure your `credentials.conf`**:

```bash
# credentials.conf
export FTP_USER="my-user"
export FTP_PASSWORD="my-password"
export FTP_HOST="backup.server.org"
```

**Append to `dockers-to-backup.txt`** the containers to backup (using their `name` or `id`):

    my_project_nginx_1
    my_project_frontend_1
    1e52f28bb583

**Launch**

    $ backup-list.bash

### Install

**Requirements:** `curl`.

    $ git clone git@github.com:edouard-lopez/backup-docker-to-ftp.git


### Test

**Requirements:** [`bats`](https://github.com/sstephenson/bats).

    $ bats ./test_backup.bats

  :warning:**Note:** `busybox` and `panubo/vsftpd` images will be **–silently– pulled if missing** (takes a few minutes).

#### Test FTP

You can test by configuring your credentials in `.netrc` and overriding `$HOME` to point to it (see [video](https://asciinema.org/a/ahai3uli13w9l52ywbjc8k0d9)):
