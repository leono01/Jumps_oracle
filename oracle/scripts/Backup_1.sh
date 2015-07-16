#!/bin/bash

#  Backup_1.sh
#
#
#  Created by Leonel Vazquez Jasso on 09/09/14.
#

if [ -e /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh ]
then

source /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh

echo "----------- $ORACLE_HOME -------------------"

JOB_CONFIG="$1"
USER=`whoami`

if [ -d /u01/app/oracle/flash_recovery_area/history ]
then

if [ -e /media/Respaldos/oracle/properties/backup_1.properties ]
then
. /media/Respaldos/oracle/properties/backup_1.properties
. $JOB_CONFIG

if [ $# -eq 1 ]
then

if [ -d $replicator_incremental_directory ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-010 | Iniciando el respaldo incremental... | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-010 | Iniciando el respaldo incremental... | Backup_1.sh | ORA-BI-04"

rman target / log='/u01/app/oracle/flash_recovery_area/history/validate.log' << EOF
	list backup;
	backup incremental level 1 database validate;
EOF


ORA_ERROR=`cat /u01/app/oracle/flash_recovery_area/history/validate.log | grep ORA-01034 | cut -c1-9`
rm -dfr /u01/app/oracle/flash_recovery_area/history/validate.log

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


rman target / log='/u01/app/oracle/flash_recovery_area/history/check_backup_full.log' << EOF
        backup incremental level 1 database;
        exit;
EOF

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/check_backup_full.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

SPACE=`cat /u01/app/oracle/flash_recovery_area/history/check_backup_full.log | grep ORA-19502 | cut -c1-9`
echo "$SPACE"

rm -dfr /u01/app/oracle/flash_recovery_area/history/check_backup_full.log


if [ "$SPACE" = "$NO_SPACE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Espacio en disco insuficiente para generar el respaldo. | Backup_1.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Espacio en disco insuficiente para generar el respaldo. | Backup_1.sh | ORA-BI-05"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

else

rman target / log='/u01/app/oracle/flash_recovery_area/history/rman_backup.log' << EOF
	backup incremental level 1 archivelog all delete input;
	list backup;
	exit;
EOF


DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-033 | Finalizó de realizar el respaldo incremental. | Backup_1.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-033 | Finalizó de realizar el respaldo incremental. | Backup_1.sh | ORA-BI-05"

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log



LAST=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_ncsn1 | tail -1 | cut -c21-150`
LAST_MEDIA=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_nnnd1 | tail -1 | cut -c21-150`
LAST_ARC=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_annnn | tail -1 | cut -c21-150`

echo "LAST_0=$LAST" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
echo "LAST_M=$LAST_MEDIA" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
#echo "LAST_A=$LAST_ARC"	>> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties

echo "ULTIMO $LAST"
echo "ULTIMO MEDIA $LAST_MEDIA"
#echo "ULTIMO ARC $LAST_ARC"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Realizando la compresión del respaldo... | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Realizando la compresión del respaldo... | Backup_1.sh | ORA-BI-04"

cd $replicator_incremental_directory

#if tar -zcvf $comprimido$tar $LAST $LAST_MEDIA $LAST_ARC $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties >> $JOB_DIRECTORY$JOB.log; then
if tar -zcvf $comprimido$tar $LAST $LAST_MEDIA $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties >> $JOB_DIRECTORY$JOB.log; then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-017 | Finalizó la compresión del respaldo. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-017 | Finalizó la compresión del respaldo. | Backup_1.sh | ORA-BI-04"

rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_backup.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-007 | Respaldo incremental se realizó exitosamente. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-007 | Respaldo incremental se realizó exitosmmente. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=0" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=0"


#mv $replicator_incremental_directory$comprimido$tar $replicator_incremental_directory$comprimido$DAY$MONTH$YEAR$HOUR$MINUTE$SEC$tar

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-037 | Error al comprimir el respaldo, verifique el espacio en disco. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-037 | Error al comprimir el respaldo, verifique el espacio en disco. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

fi

fi

fi



else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio no existe | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio no existe | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válido. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válddo. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/backup_1.properties\" no existe. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/backup_1.properties\" no existe. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

fi


else

cd /u01/app/oracle/flash_recovery_area
mkdir history

if [ -e /media/Respaldos/oracle/properties/backup_1.properties ]
then
. /media/Respaldos/oracle/properties/backup_1.properties
. $JOB_CONFIG

if [ $# -eq 1 ]
then

if [ -d $replicator_incremental_directory ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-010 | Iniciando el respaldo incremental... | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-010 | Iniciando el respaldo incremental... | Backup_1.sh | ORA-BI-04"

rman target / log='/u01/app/oracle/flash_recovery_area/history/validate.log' << EOF
        list backup;
        backup incremental level 1 database validate;
EOF

VALIDATOR=`cat /u01/app/oracle/flash_recovery_area/history/validate.log | grep algo | cut -c1-9`
ORA_ERROR=`cat /u01/app/oracle/flash_recovery_area/history/validate.log | grep ORA-01034 | cut -c1-9`
rm -dfr /u01/app/oracle/flash_recovery_area/history/validate.log 

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


rman target / log='/u01/app/oracle/flash_recovery_area/history/check_backup_full.log' << EOF
        backup incremental level 1 database;
        exit;
EOF

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/check_backup_full.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

SPACE=`cat /u01/app/oracle/flash_recovery_area/history/check_backup_full.log | grep ORA-19502 | cut -c1-9`
echo "$SPACE"

rm -dfr /u01/app/oracle/flash_recovery_area/history/check_backup_full.log


if [ "$SPACE" = "$NO_SPACE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Espacio en disco insuficiente para generar el respaldo. | Backup_1.sh | ORA-BI-05" >> $JOB_DIREC$
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Espacio en disco insuficiente para generar el respaldo. | Backup_1.sh | ORA-BI-05"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

else

rman target / log='/u01/app/oracle/flash_recovery_area/history/rman_backup.log' << EOF
	backup incremental level 1 archivelog all delete input;
	list backup;
	exit;
EOF


DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-033 | Finalizó de realizar el respaldo incremental. | Backup_1.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-033 | Finalizó de realizar el respaldo incremental. | Backup_1.sh | ORA-BI-05"

LAST=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_ncsn1 | tail -1 | cut -c21-150`
LAST_MEDIA=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_nnnd1 | tail -1 | cut -c21-150`
LAST_ARC=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_annnn | tail -1 | cut -c21-150`

echo "LAST_0=$LAST" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
echo "LAST_M=$LAST_MEDIA" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
#echo "LAST_A=$LAST_ARC"	>> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties

echo "ULTIMO $LAST"
echo "ULTIMO MEDIA $LAST_MEDIA"
#echo "ULTIMO ARC $LAST_ARC"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Realizando la compresión del respaldo... | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Realizando la compresión del respaldo... | Backup_1.sh | ORA-BI-04"

cd $replicator_incremental_directory

#if tar -zcvf $comprimido$tar $LAST $LAST_MEDIA $LAST_ARC $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties >> $JOB_DIRECTORY$JOB.log; then
if tar -zcvf $comprimido$tar $LAST $LAST_MEDIA $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties >> $JOB_DIRECTORY$JOB.log; then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-017 | Finalizó la compresión del respaldo. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-017 | Finalizó la compresión del respaldo. | Backup_1.sh | ORA-BI-04"

rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_backup.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-007 | Respaldo incremental se realizó exitosamente. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-007 | Respaldo incremental se realizó exitosmmente. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=0" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=0"

#mv $replicator_incremental_directory$comprimido$tar $replicator_incremental_directory$comprimido$DAY$MONTH$YEAR$HOUR$MINUTE$SEC$tar

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-037 | Erro al comprimir el respaldo, verifique el espacio en disco. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-037 | Erro al comprimir el respaldo, verifique el espacio en disco. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

fi

fi

fi

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio no existe | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio no existe | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válido. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es váliddo. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/backup_1.properties\" no existe. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/backup_1.properties\" no existe. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

fi

fi


else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo $ORACLE_HOME/bin/oracle_env.sh no existe. | Backup_1.sh | ORA-BI-04" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo $ORACLE_HOME/bin/oracle_env.sh no existe. | Backup_1.sh | ORA-BI-04"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

fi
