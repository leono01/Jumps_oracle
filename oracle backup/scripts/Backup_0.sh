#!/bin/sh

#  Backup_0.sh
#  
#
#  Created by Leonel Vazquez Jasso on 09/09/14.
#


if [ -e /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh ]
then


. /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh

echo "------------------$ORACLE_HOME----------------------"

JOB_CONFIG="$1"
USER=`whoami`



if [ -d /u01/app/oracle/flash_recovery_area/history ]
then


if [ -e /media/Respaldos/oracle/properties/backup_0.properties ]
then


. /media/Respaldos/oracle/properties/backup_0.properties
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-009 | Iniciando el respaldo completo... | Backup_0.sh | ORA-BI-05"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-009 | Iniciando el respaldo completo... | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log

rman target / log='/u01/app/oracle/flash_recovery_area/history/validate.log' << EOF
	list backup;
	exit;
EOF

ORA_ERROR=`cat /u01/app/oracle/flash_recovery_area/history/validate.log | grep ORA-01034 | cut -c1-9`

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/validate.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

#rm -dfr /u01/app/oracle/flash_recovery_area/history/validate.log 

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


rman target / log='/u01/app/oracle/flash_recovery_area/history/rman_backup.log' << EOF
	backup incremental level 0 database;
	list backup;
	exit;
EOF

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

SPACE=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep ORA-19502 | cut -c1-9`
echo "$SPACE"

if [ "$SPACE" = "$NO_SPACE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Espacio en disco insuficiente para generar el respaldo. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Espacio en disco insuficiente para generar el respaldo. | Backup_0.sh | ORA-BI-05"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

else

#rman target / log='/u01/app/oracle/flash_recovery_area/history/rman_backup.log' << EOF	
#	backup incremental level 0 database;
#	list backup;
#	exit;
#EOF



DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-005 | El respaldo completo se realizó exitosamente. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-005 | El respaldo completo se realizó exitosamente. | Backup_0.sh | ORA-BI-05"

LAST=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_ncsn0 | tail -1 | cut -c21-150`
LAST_MEDIA=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_nnnd0 | tail -1 | cut -c21-150`
LAST_ARC=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_annnn | tail -1 | cut -c21-150`




#IDENTIFICADOR DE LA BASE DE DATOS DE PRODUCCION DE IFREM
DBID=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep DBID | cut -c46-55`




echo "LAST_0=$LAST" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
echo "LAST_M=$LAST_MEDIA" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
#echo "LAST_A=$LAST_ARC" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
echo "DBID=$DBID" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties

echo "ULTIMO $LAST"
echo "ULTIMO MEDIA $LAST_MEDIA"
#echo "ULTIMO ARC $LAST_ARC"
echo "$DBID"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Realizando la compresión del respaldo... | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Realizando la compresión del respaldo... | Backup_0.sh | ORA-BI-05"

cd $replicator_incremental_directory

if tar -zcvf $comprimido$tar $LAST $LAST_MEDIA $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties >> $JOB_DIRECTORY$JOB.log; then
#if tar -zcvf $comprimido$tar $LAST $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties >> $JOB_DIRECTORY$JOB.log; then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-017 | Finalizó la compresión del respaldo. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-017 | Finalizó la compresión del respaldo. | Backup_0.sh | ORA-BI-05"

#rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_backup.log

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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-037 | Error al comprimir el respaldo, verifique el espacio en disco. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-037 | Error al comprimir el respaldo, verifique el espacio en disco. | Backup_0.sh | ORA-BI-05"
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio no existe \"$replicator_incremental_directory\", verifique el directorio de instalación o instale Oracle Database 0g. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio no existe \"$replicator_incremental_directory\", verifique el directorio de instalación o instale Oracle Databas 10g. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válido. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válido. | Backup_0.sh | ORA-BI-05"
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/backup_0.properties\" no existe. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/backup_0.properties\" no existe. | Backup_0.sh | ORA-BI-05"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

fi


else

cd /u01/app/oracle/flash_recovery_area
mkdir history

if [ -e /media/Respaldos/oracle/properties/backup_0.properties ]
then

. /media/Respaldos/oracle/properties/backup_0.properties
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

echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-009 | Iniciando el respaldo completo... | Backup_0.sh | ORA-BI-05"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-009 | Iniciando el respaldo completo... | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log

rman target / log='/u01/app/oracle/flash_recovery_area/history/validate.log' << EOF
        list backup;
EOF


ORA_ERROR=`cat /u01/app/oracle/flash_recovery_area/history/validate.log | grep ORA-01034 | cut -c1-9`
#rm -dfr /u01/app/oracle/flash_recovery_area/history/validate.log 

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


rman target / log='/u01/app/oracle/flash_recovery_area/history/rman_backup.log' << EOF
        backup incremental level 0 database;
	list backup;
        exit;
EOF

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

SPACE=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep ORA-19502 | cut -c1-9`
echo "$SPACE"


if [ "$SPACE" = "$NO_SPACE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Espacio en disco insuficiente para generar el respaldo. | Backup_0.sh | ORA-BI-05" >> $JOB_DIREC$
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Espacio en disco insuficiente para generar el respaldo. up_0.sh | ORA-BI-05"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-005 | El respaldo completo se realizó exitosamente. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-005 | El respaldo completo se realizó exitosamente. | Backup_0.sh | ORA-BI-05"

LAST=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_ncsn0 | tail -1 | cut -c21-150`
LAST_MEDIA=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_nnnd0 | tail -1 | cut -c21-150`
LAST_ARC=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep o1_mf_annnn | tail -1 | cut -c21-150`



DBID=`cat /u01/app/oracle/flash_recovery_area/history/rman_backup.log | grep DBID | cut -c46-55`



echo "LAST_0=$LAST" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
echo "LAST_M=$LAST_MEDIA" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
#echo "LAST_A=$LAST_ARC"	>> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
echo "DBID=$DBID" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties

echo "ULTIMO $LAST"
echo "ULTIMO MEDIA $LAST_MEDIA"
#echo "ULTIMO ARC $LAST_ARC"
echo "$DBID"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Realizando la compresión del respaldo... | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-016 | Realizando la compresión del respaldo... | Backup_0.sh | ORA-BI-05"

cd $replicator_incremental_directory

#if tar -zcvf $comprimido$tar $LAST $LAST_MEDIA $LAST_ARC $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties >> $JOB_DIRECTORY$JOB.log; then
if tar -zcvf $comprimido$tar $LAST $LAST_MEDIA $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties >> $JOB_DIRECTORY$JOB.log; then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-017 | Finalizó la compresión del respaldo. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-017 | Finalizó la compresión del respaldo. | Backup_0.sh | ORA-BI-05"

#rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_backup.log

#mv $replicator_incremental_directory$comprimido$tar $replicator_incremental_directory$comprimido$DAY$MONTH$YEAR$HOUR$MINUTE$SEC$tar

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-037 | Error al comprimir el respaldo, verifique el espacio en disco. | Backup_0.sh | ORA-BI-05"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-037 | Error al comprimir el respaldo, verifique el espacio en disco. | Backup_0.sh | ORA-BI-05"
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio no existe \"$replicator_incremental_directory\", verifique el directorio de instalación o instale Oracle Database 0g. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio no existe \"$replicator_incremental_directory\", verifique el directorio de instalación o instale Oracle Databas 10g. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
fi


else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válido. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-013 | Identificador de Job no es válido. | Backup_0.sh | ORA-BI-05"

fi

	
else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/backup_0.properties\" no existe. |Backup_0.sh|ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/backup_0.properties\" no existe. | Backup_0.sh | ORA-BI-05"

fi

fi

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh no existe. | Backup_0.sh | ORA-BI-05" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh no existe. | Backup_0.sh | ORA-BI-05"

fi
