#!/bin/bash

########### PARAMETERS ###########

BACKUP_DEFAULT_DATA_DIR='your backup directory'
BACKUP_DATA_DIR=${1:-$BACKUP_DEFAULT_DATA_DIR} 
BACKUP_DIR=$BACKUP_DATA_DIR/"dump_$(date +%d_%m_%Y_%H_%M_%S)"

MYSQL_USER_LOGIN='your login'
MYSQL_USER_PASSWORD='your password'
DAYS_TO_STORE=30

########### /PARAMETERS ###########


echo "[$(date +"%d.%m.%Y %H:%M:%S")]: started"

mkdir -p $BACKUP_DIR

# Cоздание и архивация дампа базы данных
mysqldump --opt -u $MYSQL_USER_LOGIN  -p$MYSQL_USER_PASSWORD --events --all-databases > $BACKUP_DIR/all_databases_dump.sql
tar -cjf $BACKUP_DIR/all_databases_dump.sql.tbz -C $BACKUP_DIR/ all_databases_dump.sql && rm $BACKUP_DIR/all_databases_dump.sql 
echo "Databases backup finished"

# Изменяем права директории BACKUP_DATA_DIR
chmod 700 $BACKUP_DATA_DIR

# Удаляем архивы, которые старее DAYS_TO_STORE дней
find $BACKUP_DATA_DIR -type d -mtime $DAYS_TO_STORE | xargs -r rm -r

echo "[$(date +"%d.%m.%Y %H:%M:%S")]: finished"