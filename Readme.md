29 0 \* /bin/bash /opt/scripts/make-backup.sh

su www-data -s /bin/bash -c "php occ files:scan --path /srieger/files/Backups/Server"