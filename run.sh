#/bin/bash

if [ -z "$GITHUB_USERNAME" ]; then
    echo "Please set the GITHUB_USERNAME environment variable."
    exit 1
fi
if [ -z "$GITHUB_ACCESS_TOKEN" ]; then
    echo "Please set the GITHUB_ACCESS_TOKEN environment variable."
    exit 1
fi

REPOSITORIES="$(curl -s -u "$GITHUB_USERNAME:$GITHUB_ACCESS_TOKEN" "https://api.github.com/user/repos" | jq -r '.[].full_name')"
echo "$REPOSITORIES"

REPO_PATH="$(pwd)/repos"
mkdir -p $REPO_PATH

for repository in $REPOSITORIES; do
    REPOSITORY_PATH="https://${GITHUB_ACCESS_TOKEN}@github.com/${repository}"
    echo "Backing up github.com/${repository}..."
    pushd $REPO_PATH
        git clone --mirror $REPOSITORY_PATH
    popd
done

DATE=`date '+%Y-%m-%d_%H-%M-%S'`
BACKUP_FILENAME="repository-backup-${DATE}.tar.gz"
BACKUP_DIR="/backup"

tar -zcvf $BACKUP_FILENAME -C $REPO_PATH .

rm -rf $REPO_PATH

mv $BACKUP_FILENAME $BACKUP_DIR

if [ "$BACKUP_MAX_FILES" != "0" ]; then
    echo "Removing old backups. We just want to store ${BACKUP_MAX_FILES}"
    (find $BACKUP_DIR -type f|sort|tail -n $BACKUP_MAX_FILES;find $BACKUP_DIR -type f)|grep -v "^$BACKUP_DIR$"|sort|uniq -u|xargs rm -rfv
fi

if [ -n "$SLACK_NOTIFICATION_ENDPOINT" ]; then
    echo "Doing slack notification."
    curl -s -X POST -H 'Content-type: application/json' --data '{"text":"GITHUB Backup successfully done!"}' $SLACK_NOTIFICATION_ENDPOINT
fi
