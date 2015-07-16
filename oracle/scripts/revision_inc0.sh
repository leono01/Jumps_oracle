#!/bin/bash

#  revision_inc0.sh
#  
#
#  Created by Leonel Vazquez Jasso on 08/10/14.
#


if [ -e /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh ]
then

source /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh

echo "variables _____$ORACLE_HOME________________________"

JOB_CONFIG="$1"
USER=`whoami`


if [ -e /media/Respaldos/oracle/properties/revision_inc0.properties ]
then


. /media/Respaldos/oracle/properties/revision_inc0.properties
. $JOB_CONFIG


if [ -e $ORACLE_LOG_DIRECTORY ]
then


if [ -d /u01/app/oracle/flash_recovery_area/history ]
then


rman target / log='/u01/app/oracle/flash_recovery_area/history/rman_check.log' << EOF
	list backup;
	exit;
EOF

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-022 | Revisando si existe respaldo completo... | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo -e "\n$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-022 | Revisando si existe respaldo completo... | revision_inc0.sh | ORA-BI-03"

INC=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log | grep o1_mf_ncsn0 | cut -c21-150`
ORA_ERROR=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log | grep ORA-01034 | cut -c1-9`
echo $ORA_ERROR


#IDENTIFICADOR DE LA BASE DE DATOS DE PRODUCCION DE IFREM
DBID=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log | grep DBID | cut -c46-55`


if [ "$ORA_ERROR" = "$NO_AVAILABLE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible | revision_inc0.sh | ORA-BI-03"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

else

if [ "$INC" = "" ]
then

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log
rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_check.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-015 | No existe un respaldo completo de la base de datos | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-015 | No existe un respaldo completo de la base de datos | revision_inc0.sh | ORA-BI-03"

LOG="$ORACLE_LOG_DIRECTORY$JOB/$JOB.properties"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-023 | Finalizó la revisión del respaldo completo. | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-023 | Finalizó la revisión del respaldo completo. | revision_incsh | ORA-BI-03"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0


else

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log
rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_check.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-014 | Existe un respaldo completo de la base de datos. | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-014 | Existe un respaldo completo de la base de datos. | revision_inc0.sh | ORA-BI-03"

LOG="$ORACLE_LOG_DIRECTORY$JOB/$JOB.properties"
echo "$DBID"
echo "DBID=$DBID" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-023 | Finalizó la revisión del respaldo completo. | revision_inc0.sh | ORA-BI-03" >> $JOB_DRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-023 | Finalizó la revisión del respaldo completo. | revision_inc0.sh | ORA-BI-03"
echo "EXIT_CODE=0" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=0"


/bin/sh /media/Respaldos/oracle/scripts/Backup_1.sh $LOG

fi

fi





else

cd /u01/app/oracle/flash_recovery_area
mkdir history

rman target / log='/u01/app/oracle/flash_recovery_area/history/rman_check.log'<< EOF
	list backup;
	exit;
EOF

INC=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log | grep o1_mf_ncsn0 | cut -c21-150`






#IDENTIFICADOR DE LA BASE DE DATOS DE PRODUCCION DE IFREM
DBID=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log | grep DBID | cut -c46-55`






ORA_ERROR=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log | grep ORA-01034 | cut -c1-9`
echo "$ORA_ERROR"

echo "DBID=$DBID" >> $ORACLE_LOG_DIRECTORY$JOB/$JOB.properties
echo "$INC" >> $JOB_DIRECTORY$JOB.log


if [ "$ORA_ERROR" = "$NO_AVAILABLE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible | revision_inc0.sh | ORA-BI-03"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

else


if [ "$INC" = "" ]
then

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_check.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB| $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-015 | No existe un respaldo completo de la base de datos. | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB| $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-015 | No existe un respaldo completo de la base de datos. | revision_inc0.sh | ORA-BI-03"

LOG="$ORACLE_LOG_DIRECTORY$JOB/$JOB.properties"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-023 | Finalizó la revisión del respaldo completo. | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-023 | Finalizó la revisión del respaldo completo. | revision_inc0.sh | ORA-BI-03"
#sh /media/Respaldos/oracle/scripts/Backup_0.sh $LOG
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

else

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/rman_check.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log

rm -dfr /u01/app/oracle/flash_recovery_area/history/rman_check.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-014 | Existe un respaldo completo de la base de datos. | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-014 | Existe un respaldo completo de la base de datos. | revision_inc0.sh | ORA-BI-03"

LOG="$ORACLE_LOG_DIRECTORY$JOB/$JOB.properties"
echo "DBID=$DBID" >> $LOG

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-023 | Finalizó la revisión del respaldo completo. | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-023 | Finalizó la revisión del respaldo completo. | revision_inc0.sh | ORA-BI-03"
echo "EXIT_CODE=0" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=0"

sh /media/Respaldos/oracle/scripts/Backup_1.sh $LOG

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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio $ORACLE_LOG_DIRECTORY no existe. | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-012 | El directorio $ORACLE_LOG_DIRECTORY no existe. | revision_inc0.sh | ORA-BI-03"
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/revision_inc0.properties\" no existe. | revision_inc0.sh | ORA-BI-03" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/revision_inc0.properties\" no existe. | revision_inc0.sh | ORA-BI-03"
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo $ORACLE_HOME/bin/oracle_env.sh no existe. | oracle_mode.sh | ORA-BI-02" >> $JOBDIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo $ORACLE_HOME/bin/oracle_env.sh no existe. | oracle_mode.sh | ORA-BI-02"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
exit 0

fi
