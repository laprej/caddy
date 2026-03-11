#!/bin/bash

set -euo pipefail
set -x

NOW=$(date  +"%Y-%m-%dT%H%M%S%z")

SOURCE=/mnt/tank/backup
# DEST=foobar:com-lapre-foobar
DEST=secret2:

rclone sync $SOURCE ${DEST}/curr \
    --fast-list `# useful on bucket-remotes like B2` \
    --exclude "/docker/**" --exclude "/truenas_catalog/**" `# Plus any other excludes` \
    --delete-excluded \
    --links `# translate to .rclonelink - Optional` \
    --progress -v \
    --log-file /var/log/rclone-backup.log \
    --backup-dir ${DEST}/back/"${NOW}" `# IMPORTANT`
