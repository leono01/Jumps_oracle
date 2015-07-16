#!/bin/bash

#  oracle_mode_log.sh
#  
#
#  Created by Leonel Vazquez Jasso on 06/10/14.
#

if [ -e /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh ]
then

source /u01/app/oracle/product/11.2.0/dbhome_1/bin/oracle_env.sh

JOB_CONFIG="$1"
USER=`whoami`

if [ -d /u01/app/oracle/flash_recovery_area/history ]
then

if [ -e /media/Respaldos/oracle/properties/oracle_mode.properties ]
then
. /media/Respaldos/oracle/properties/oracle_mode.properties
. $JOB_CONFIG

echo "______________________ $ORACLE_HOME _______________________"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-031 | Iniciando la revisión del modo de la base de datos.| oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-031 | Iniciando la revisión del modo de la base de datos.| oracle_mode.sh | ORA-BI-02"

sqlplus / as sysdba << EOF
	SPOOL /u01/app/oracle/flash_recovery_area/history/changos.log;
	archive log list;
	SPOOL OFF;
	exit;
EOF

MODE=`cat /u01/app/oracle/flash_recovery_area/history/changos.log | grep Database | cut -c26-46`
ORA_ERROR=`cat /u01/app/oracle/flash_recovery_area/history/changos.log | grep ORA-01012 | cut -c1-9`
echo "$MODE"
echo "$ORA_ERROR"

if [ "$MODE" = "$ARCHIVE" ]
then

DBZ=`cat /u01/app/oracle/flash_recovery_area/history/changos.log`
echo "$DBZ" >> $JOB_DIRECTORY$JOB.log
rm -dfr /u01/app/oracle/flash_recovery_area/history/changos.log

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`

echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-002 | Modo de la Base de Datos correcto. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-002 | Modo de la Base de Datos correcto. | oracle_mode.sh | ORA-BI-02"
LOG="$ORACLE_LOG_DIRECTORY$JOB/$JOB.properties"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`

echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos.| oracle_mode.sh | ORA-BI-02"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos.| oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=0"
echo "EXIT_CODE=0" >> $JOB_DIRECTORY$JOB.log


/bin/sh /media/Respaldos/oracle/scripts/revision_inc0.sh $LOG

else

if [ "$ORA_ERROR" = "$NO_AVAILABLE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible. | oracle_mode.sh | ORA-BI-02"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`

echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos.| orac le_mode.sh | ORA-BI-"02>> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02"
echo "EXIT_CODE=1"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
exit 0
else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-001 | Modo de la Base de Datos incorrecto. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-001 | Modo de la Base de Datos incorrecto. | oracle_mode.sh | ORA-BI-02"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos| oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/oracle_mode.properties\" no existe. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/oracle_mode.properties\" no existe. | oracle_mode.sh| ORA-BI-02"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
exit 0
fi

else

cd /u01/app/oracle/flash_recovery_area
mkdir /u01/app/oracle/flash_recovery_area/history

if [ -e /media/Respaldos/oracle/properties/oracle_mode.properties ]
then

. /media/Respaldos/oracle/properties/oracle_mode.properties
. $JOB_CONFIG

echo "______________________ $ORACLE_HOME _______________________"

echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-031 | Iniciando la revisión del modo de la base de datos.| oracle_mode.sh | ORA-BI-0"  >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-031 | Iniciando la revisión del modo de la base de datos.| oracle_mode.sh | ORA-BI-02"

sqlplus / as sysdba << EOF
	SPOOL /u01/app/oracle/flash_recovery_area/history/changos.log;
	archive log list;
	SPOOL OFF;
	exit;
EOF

MODE=`cat /u01/app/oracle/flash_recovery_area/history/changos.log | grep Database | cut -c26-46`
ORA_ERROR=`cat /u01/app/oracle/flash_recovery_area/history/changos.log | grep ORA-01012 | cut -c1-9`
echo "$MODE"
echo "$ORA_ERROR"

if [ "$MODE" = "$ARCHIVE" ]
then

rm -dfr /u01/app/oracle/flash_recovery_area/history/changos.log


DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-002 | Modo de la Base de Datos correcto. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-002 | Modo de la Base de Datos correcto. | oracle_mode.sh | ORA-BI-02"
LOG="$ORACLE_LOG_DIRECTORY$JOB/$JOB.properties"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos.| oracle_mode.sh | ORA--02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos.| oracle_mode.sh | ORA-BI-02"
echo "EXIT_CODE=0"
echo "EXIT_CODE=0" >> $JOB_DIRECTORY$JOB.log
sh /media/Respaldos/oracle/scripts/revision_inc0.sh $LOG

else

if [ "$ORA_ERROR" = "$NO_AVAILABLE" ]
then

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-034 | Base de datos no disponible. | oracle_mode.sh | ORA-BI-02"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
exit 0

else

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`

echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-001 | Modo de la Base de Datos incorrecto. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-001 | Modo de la Base de Datos incorrecto. | oracle_mode.sh | ORA-BI-02"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/oracle_mode.properties\" no existe. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo \"/media/Respaldos/oracle/properties/oracle_mode.properties\" no existe. | oracle_mode.sh| ORA-BI-02"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
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
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo $ORACLE_HOME/bin/oracle_env.sh no existe. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-011 | El archivo $ORACLE_HOME/bin/oracle_env.sh no existe. | oracle_mode.sh | ORA-BI-02"

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02"
echo "$JOB | $DAY/$MONTH/$YEAR | $HOUR:$MINUTE:$SEC | $USER | ORA-032 | Finalizó la revisión del modo de la base de datos. | oracle_mode.sh | ORA-BI-02" >> $JOB_DIRECTORY$JOB.log
echo "EXIT_CODE=1"
echo "EXIT_CODE=1" >> $JOB_DIRECTORY$JOB.log
exit 0

fi
