# MacOS borgbackup script # 

## Server side ##
1. Install docker on server
2. Run container:
```
docker run -d -p 212:22 -v /opt/backupstorage:/storage --name borg-server -e BORG_AUTHORIZED_KEYS='YOUR_SSH_PUB_KEY' geri4/borgbackup-server:1.0.10
```

## Client(MacOS) side ##

1. Install borgbackup:
```
brew install borgbackup
```
2. Initialyze repository, specify repo password and remember it:
```
borg init ssh://borg@backupserver.com:212/storage/mymac
```

3. Copy backup.sh from this script to your home directory and give it run permissions:
```
cp backup.sh ~/backup.sh && chmod a+x ~/backup.sh
```

4. Edit variables in ~/backup.sh. Set REPO_URL and REPO_PASSWORD.
REPO_PASSWORD should be the same as in step 2. Also specify directories that you want to backup.

5. Open crontab editor:
```
crontab -e
```

6. Add this line and save the crontab file:
```
*/15 * * * *  ~/backup.sh &>/dev/null
```
