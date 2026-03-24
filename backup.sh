#!/bin/bash

set -euo pipefail
set -x

NOW=$(date  +"%Y-%m-%dT%H%M%S%z")

DATASET=tank/backup
SOURCE=/mnt/tank/backup
SNAPNAME="rclone-backup-${NOW}"
SNAPPATH="${SOURCE}/.zfs/snapshot/${SNAPNAME}"
DEST=smar-backup:smar-backup
# DEST=secret2:
LOGFILE="/var/log/rclone-backup.log"

# ---- CREATE SNAPSHOT ----
echo "Creating ZFS snapshot: ${DATASET}@${SNAPNAME}"
zfs snapshot "${DATASET}@${SNAPNAME}"

# ---- RUN BACKUP FROM SNAPSHOT ----
echo "Starting rclone sync from snapshot path: ${SNAPPATH}"

if rclone sync "${SNAPPATH}" "${DEST}/curr" \
    --fast-list `# useful on bucket-remotes like B2` \
    --exclude "/docker/**" --exclude "/truenas_catalog/**" `# Plus any other excludes` \
    --exclude "/data/usenet/**" \
    --delete-excluded \
    --links `# translate to .rclonelink - Optional` \
    --progress -v \
    --log-file "$LOGFILE" \
    --transfers 8 \
    --checkers 16 \
    --backup-dir ${DEST}/back/"${NOW}" `# IMPORTANT`
then
    echo "Backup completed successfully. Destroying snapshot."
    zfs destroy "${DATASET}@${SNAPNAME}"
else
    echo "Backup FAILED. Snapshot retained for inspection: ${DATASET}@${SNAPNAME}"
    exit 1
fi
