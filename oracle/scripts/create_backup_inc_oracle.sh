#!/bin/bash

#  create_backup_inc_oracle.sh
#  
#
#  Created by Leonel Vazquez Jasso on 08/10/14.
#

JOB="$1"
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Empezando el trabajo. | create_backup_inc_oracle.sh | ORA-BI-01"

USER=`whoami`

if [ -e /media/Respaldos/oracle/properties/oracle_mode.properties ]
then

. /media/Respaldos/oracle/properties/oracle_mode.properties

if [ -e $ORACLE_LOG_DIRECTORY ]
then

if [ $# -eq 1 ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-020 | Configurando los archivos del script... | create_backup_inc_oracle.sh | ORA-BI-01"

cd $ORACLE_LOG_DIRECTORY
mkdir $JOB
cd $JOB

echo "JOB_DIRECTORY=$ORACLE_LOG_DIRECTORY$JOB/" >> $JOB.properties
echo "JOB=$JOB" >> $JOB.properties
LOG="$ORACLE_LOG_DIRECTORY$JOB/$JOB.properties"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-021 | Finalizó la configuración de los archivos del script. | create_backup_inc_oracle.sh | ORA-BI-01"
echo "EXIT_CODE=0"
sh /media/Respaldos/oracle/scripts/oracle_mode.sh $LOG
echo "******************** FIN CREATE_BACKUP_INC_ORACLE.SH *********************"

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válido. | create_backup_inc_oracle.sh | ORA-BI-01" >> $LOG_TMP
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es váliddo. | create_backup_inc_oracle.sh | ORA-BI-01"
echo "EXIT_CODE=1"
echo "******************** FIN CREATE_BACKUP_INC_ORACLE.SH E*********************"
exit 0
fi

else
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio $ORACLE_LOG_DIRECTORY no existe. | create_backup_inc_oracle.sh | ORA-BI-01" >> $LOG_TMP
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio $ORACLE_LOG_DIRECTORY no existe. | create_backup_inc_oracle.sh | ORA-BI-01"
echo "EXIT_CODE=1"
echo "******************** FIN CREATE_BACKUP_INC_ORACLE.SH E*********************"
echo 0
fi

else
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/oracle_mode.properties\"no existe. | create_backup_inc_oracle.sh|ORA-BI-01" >> $LOG_TMP
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/oracle_mode.properties\"no existe. | create_backup_inc_oracle.sh|ORA-BI-01"
echo "EXIT_CODE=1"
echo "******************** FIN CREATE_BACKUP_INC_ORACLE.SH E*********************"
exit 0
fi
