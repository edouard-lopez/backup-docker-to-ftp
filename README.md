## Usage

    export -x FTP_URL="ftp://backup.server.org"
    export -x FTP_USER="john-doe"
    export -x FTP_PASSWORD="long-phrase-are-best"

## Install

  todo

## Requirement

* `curl`
* `docker` (for tests)

      docker pull busybox
      docker pull stilliard/pure-ftpd

## Test

Pour tester le script de backup.

    cd backups/
    bats ./test_backups.bats
