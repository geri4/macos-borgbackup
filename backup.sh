#!/bin/bash

REPO_URL=ssh://borg@backupserver.com:212/storage/mymac
REPO_PASSWORD=CieKo5iePo

function backup {
	borg create --compression lz4 \
		${REPO_URL}::'{hostname}-{now:%Y-%m-%d}' \
		~ \
		/etc \
		/Applications \
		--exclude '~/Downloads' \
		--exclude '*.pyc' \
		&& touch ~/.lastbackup \
		&& osascript -e "display notification \"Backup complete\" with title \"Borgbackup\"" \
		|| ([ $1 -ge 604800 ] \
		&& osascript -e "display notification \"ERROR: Backup was failed during week\" with title \"Borgbackup\"")
}

function remove_old_backup {
	borg prune -v --list ${REPO_URL} --prefix '{hostname}-' \
		--keep-daily=7 --keep-weekly=4 --keep-monthly=6
}

function check_last_backup {
	if [ ! -f ~/.lastbackup ]; then
		touch ~/.lastbackup
		backup
	else 
		LASTBACKUP=`date -r ~/.lastbackup +%s`
		CURTIME=`date +%s`
		DIFF=$(($CURTIME - $LASTBACKUP))
		echo $DIFF
		if [[ $DIFF -ge 86400 ]]; then
			backup $DIFF
			remove_old_backup
		fi
	fi
}

export BORG_PASSPHRASE=${REPO_PASSWORD}
check_last_backup
