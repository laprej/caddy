#!/bin/bash

NOW=$(date  +"%Y-%m-%dT%H%M%S%z")

SOURCE=/mnt/.ix-apps
DEST=foobar:com-lapre-foobar

rclone sync $SOURCE ${DEST}/curr \
    --fast-list `# useful on bucket-remotes like B2` \
    --exclude "/docker/**" --exclude "/truenas_catalog/**" `# Plus any other excludes` \
    --delete-excluded \
    --links `# translate to .rclonelink - Optional` \
    --progress -v \
    --backup-dir ${DEST}/back/"${NOW}" `# IMPORTANT`
