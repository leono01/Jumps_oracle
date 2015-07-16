#!/bin/bash

#  restore_backup_full_oracle.sh
#
#
#  Created by Leonel Vazquez Jasso on 13/09/14.
#

if [ $# -ne 1 ]; then

echo "Falta valor del trabajo del respaldo"
echo "EXIT_CODE=1"
exit 0

else
PID=$1
echo "Se recibió correctamente el valor del trabajo del respaldo"
fi

if [ -f /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh ]
then

source /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh

echo "----------- $ORACLE_HOME -------------------"

USER=`whoami`

if [ -e /media/Respaldos/oracle/properties/restore_0.properties ]
then

. /media/Respaldos/oracle/properties/restore_0.properties


DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-024 | Iniciando la restauración del respaldo completo... | restore_backup_full_oracle.sh | ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo "$PID | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-024 | Iniciando la restauración del respaldo completo... | restore_backup_full_oracle.sh | ORA-RF-01"

cd /

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-026 | Realizando la descompresión del respaldo completo... | restore_backup_full_oracle.sh | ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo "$PID | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-026 | Realizando la descompresión del respaldo completo... | restore_backup_full_oracle.sh | ORA-RF-01"

if [ -e $replicator_incremental_directory ]
then

if tar -xzvf $replicator_incremental_directory >> /media/Respaldos/oracle/files/tmp_.log; then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-027 | Finalizó la descomprensión del respaldo. | restore_backup_full_oracle.sh | ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo "$PID | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-027 | Finalizó la descomprensión del respaldo. | restore_backup_full_oracle.sh | ORA-RF-01"


JOB_ID=`cat /media/Respaldos/oracle/files/tmp_.log | grep logs | cut -c1-100`
rm -dfr /media/Respaldos/oracle/files/tmp_.log
. /$JOB_ID
echo "$DBID"
echo "$LAST_0"


else

LAST_F=`cat /media/Respaldos/oracle/files/tmp_.log | grep o1_mf_ncsn0 | cut -c1-106`
LAST_MED=`cat /media/Respaldos/oracle/files/tmp_.log | grep o1_mf_nnnd0 | cut -c1-106`
LAST_ARC=`cat /media/Respaldos/oracle/files/tmp_.log | grep o1_mf_annnn | cut -c1-106`

rm -dfr /$LAST_F
rm -dfr /$LAST_MED
rm -dfr /$LAST_ARC

rm -dfr /media/Respaldos/oracle/files/tmp_.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$PID | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-036 | Error al descomprimir respaldo, debido a falta de espacio en disco o corrupción de archivo. | restore_backup_full_oracle.sh | ORA-RF-01"
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-036 | Error al descomprimir respaldo, debido a falta de espacio en disco o corrupción de archiv.o | restore_backup_full_oracle.sh | ORA-RF-01"
#echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

fi

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-028 | Realizando restauración del respaldo... | restore_backup_full_oracle.sh | ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-028 | Realizando restauración del respaldo... | restore_backup_full_oracle.sh | ORA-RF-01"

/u01/app/oracle/product/11.2.0/dbhome_1/bin/rman target / log='/media/Respaldos/oracle/files/validate.log' << EOF
        list backup;
        exit;
EOF

ORA_ERROR=`cat /media/Respaldos/oracle/files/validate.log | grep ORA-01034 | cut -c1-9`

DBZ=`cat /media/Respaldos/oracle/files/validate.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

rm -dfr /media/Respaldos/oracle/files/validate.log

if [ "$ORA_ERROR" = "$NO_AVAILABLE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0


else

#echo "Sleeping ........."
#sleep 600

/u01/app/oracle/product/11.2.0/dbhome_1/bin/rman target / log='/u01/app/oracle/flash_recovery_area/history/rman_restore.log' << EOF
	delete noprompt archivelog all;
	shutdown;
	set dbid $DBID;
	startup nomount;
	restore controlfile from '$LAST_0';
	startup mount;
	crosscheck backup;
	restore database validate;
	restore database;
	recover database;
	alter database open resetlogs;
	exit;
EOF

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_restore.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-025 | Finalizó exitosamente la restauración del respaldo completo. | restore_backup_full_oracle.sh | ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-025 | Finalizó exitosamente la restauración del respaldo completo. | restore_backup_full_oracle.sh | ORA-RF-01"
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-000 | Se completó exitosamente el proceso. | restore_backup_full_oracle.sh |ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-000 | Se completó exitosamente el proces. | restore_backup_full_oracle.sh | ORA-RF-01"
echo "EXIT_CODE=0" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=0"

rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_restore.log
#rm -dfr $replicator_incremental_directory


fi

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo no existe $replicator_incremental_directory. | restore_backup_full_oracle.sh | ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo "$PID | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo no existe $replicator_incremental_directory. | restore_backup_full_oracle.sh | ORA-RF-01"
echo "EXIT_CODE=1"
exit 0

fi

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/restore_0.properties\" no existe. | restore_backup_full_oracle.sh | ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo "$PID | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/restore_0.properties\" no existe. | restore_backup_full_oracle.sh | ORA-RF-01"
echo "EXIT_CODE=1"
exit 0

fi


else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
#echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo $ORACLE_HOME/bin/oracle_env.sh no existe. | restore_backup_full_oracle.sh | ORA-RF-01" >> $JOB_DIRECTORY$JOB.log
echo "$PID | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo $ORACLE_HOME/bin/oracle_env.sh no existe. | restore_backup_full_oracle.sh | ORA-RF-01"
echo "EXIT_CODE=1"
exit 0

fi
