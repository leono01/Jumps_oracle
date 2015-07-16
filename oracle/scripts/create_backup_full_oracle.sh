#!/bin/bash

#  create_backup_inc_oracle.sh
#  
#
#  Created by Leonel Vazquez Jasso on 08/10/14.
#

USER=`whoami`

if [ -e /media/Respaldos/oracle/properties/oracle_mode.properties ]
then

. /media/Respaldos/oracle/properties/oracle_mode.properties

if [ -e $ORACLE_LOG_DIRECTORY ]
then

if [ $# -eq 1 ]
then

JOB="$1"
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-018 | Iniciando el trabajo de respaldo... | create_backup_full_oracle.sh | ORA-BF-06"
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-018 | Iniciando el trabajo de respaldo... | create_backup_full_oracle.sh | ORA-BF-06" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.log
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-020 | Configurando los archivos del script... | create_backup_full_oracle.sh | ORA-BF-06" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-020 | Configurando los archivos del script... | create_backup_full_oracle.sh | ORA-BF-06"
			
cd $ORACLE_LOG_DIRECTORY
mkdir $JOB
cd $JOB			
echo "JOB_DIRECTORY=$ORACLE_LOG_DIRECTORY$JOB/" >> $JOB.properties
echo "JOB=$JOB" >> $JOB.properties
			
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-021 | Finalizó la configuración de los archivos del script. | create_backup_full_oracle.sh | ORA-BF-06" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.log 
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-021 | Finalizó la configuración de los archivos del script. | create_backup_full_oracle.sh | ORA-BF-06"

LOG="$ORACLE_LOG_DIRECTORY$JOB/$JOB.properties"			
/bin/sh /media/Respaldos/oracle/scripts/Backup_0.sh $LOG
                        
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`			
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-019 | Finalizó el trabajo de respaldo. | create_backup_full_oracle.sh | ORA-BF-06" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-019 | Finalizó el trabajo de respaldo. | create_backup_full_oracle.sh | ORA-BF-06"

#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-000 | Se completó exitosamente el proceso. | create_backup_full_oracle.sh | ORA-BF-06"
echo "*****************************  FIN CREATE_BACKUP_FULL_ORACLE.SH  *********************************"

else
		
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
			
echo "  | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válido. | create_backup_full_oracle.sh|ORA-BF-06"
echo "*****************************  FIN CREATE_BACKUP_FULL_ORACLE.SH E *********************************"

fi

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "  | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio $ORACLE_LOG_DIRECTORY no existe. | create_backup_full_oracle.sh | ORA-BF-06" >> $LOG_TMP
echo "  |$DAY/$MONTH/$YEAR|$HOUR:$MINUTE:$SEC|$USER|ORA-012|El directorio $ORACLE_LOG_DIRECTORY no existe.|create_backup_full_oracle.sh|ORA-BF-06"
echo "*****************************  FIN CREATE_BACKUP_FULL_ORACLE.SH E *********************************"

fi

else
  
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "  | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/oracle_mode.properties\"no existe. | create_backup_full_oracle.sh | ORA-BF-06" >> $LOG_TMP
echo "  |$DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/oracle_mode.properties\"no existe. | create_backup_full_oracle.sh | ORA-BF-06"
echo "*****************************  FIN CREATE_BACKUP_FULL_ORACLE.SH E *********************************"

fi
