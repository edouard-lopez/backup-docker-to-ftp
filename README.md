## Usage

prepare context

    export -x FTP_URL="ftp://backup.server.org"
    export -x FTP_USER="john-doe"

  Then run the command

    FTP_PASSWORD="long-phrase-are-best" backup.bash


## Install

  todo

## Requirement

* `curl`
* `docker` (for tests)

      docker pull busybox
      docker pull stilliard/pure-ftpd

## Test

Pour tester le script de backup.

    cd backup/ && bats ./test_backup.bats