# docker-github-backup
Docker Image to backup your repository

This docker image backups all repositories of your complete github account.

## Build

To build the image on your own, use:

```bash
docker build -t nextunit/github-backup .
```

## Required environment variables

|Variable|Description|
|--|--|
|GITHUB_USERNAME|Your github username|
|GITHUB_ACCESS_TOKEN|Your token, you created for github. Here you can find, how you can create one: [https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)|
|SLACK_NOTIFICATION_ENDPOINT *(Optional)*|This entry is just required, if you'd like to send update-debug messages to slack.|
|BACKUP_MAX_FILES *(Optional)*|The backup script will delete older backups. With this entry you define how many backups should be stored before it deletes newers. Older files in the directory will be deleted. The **Default Value is 5**. If you wan't to disable this feature, use 0.|

## Run Docker

There are two ways to set environment variables. You can find examples for both below.

### Without environment file

```bash
docker run  -e "GITHUB_USERNAME=<username>" -e "GITHUB_ACCESS_TOKEN=<access-token>" -e "SLACK_NOTIFICATION_ENDPOINT=<slack>" -e "BACKUP_MAX_FILES=<number of files, that should be available>" -v /full/path/to/backup/dir:/backup --rm nextunit/github-backup
```

### Using a environment file

Environment file content:

```text
GITHUB_USERNAME=username-1
GITHUB_ACCESS_TOKEN=token-of-username-1
SLACK_NOTIFICATION_ENDPOINT=https://hooks.slack.com/services/XXXXXX/XXXXXXXX/XXxxXXxx
BACKUP_MAX_FILES=10
```

Afterwards just execute the following command:

```bash
docker run --rm -v /full/path/to/backup/dir:/backup --env-file "./path/to/environment-file.conf" nextunit/github-backup
```