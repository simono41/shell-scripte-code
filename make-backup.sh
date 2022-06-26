#!/bin/bash

BACKUPTIME=`date +%b-%d-%y` #get the current date

DESTINATION=/var/www/html/data/sebastian/files/backups/backup-documents-$BACKUPTIME.tar.gz #create a backup file using the current date in it's name

SOURCEFOLDER=/var/www/html/data/sebastian/files/Documents #the folder that contains the files that we want to backup

tar -cpzf $DESTINATION $SOURCEFOLDER #create the backup

su www-data -s /bin/bash -c "php occ files:scan --path /sebastian/"

chown -cRv www-data:www-data data/sebastian/files/backups
