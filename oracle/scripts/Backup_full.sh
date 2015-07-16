#!/bin/sh

#  Backup_full.sh
#  
#
#  Created by Leonel Vazquez Jasso on 09/09/14.
#

. /media/Respaldos/oracle/backup_full.properties

su oracle << EOF
    sqlplus /nolog << EOF
        CONNECT / as sysdba;
        SHUTDOWN;
        STARTUP MOUNT;
        ALTER DATABASE noarchivelog;
        ALTER DATABASE open;
        DISCONNECT;
        exit;
    EOF
exit
EOF

#expdp $replicator_user_database/$replicator_password_database DUMPFILE=$replicator_dumpfile_name$replicator_dumpfile_extension SCHEMAS=$replicator_schema_name
exp $replicator_user_database/$replicator_password_database FULL=y FILE=$replicator_dpdump_directory$replicator_dumpfile_name$replicator_dumpfile_extension
cd $replicator_dpdump_directory
tar -zcvf $comprimido $replicator_dumpfile_name$replicator_dumpfile_extension

echo $USER
scp $replicator_dpdump_directory$comprimido $replicator_destination_user@$replicator_destination_ip:/root/backupscold
echo "Respaldo completo enviado al DRP."

su oracle << EOF
    sqlplus /nolog << EOF
        CONNECT / as sysdba;
        shutdown;
        startup mount;
        ALTER DATABASE archivelog;
        ALTER DATABASE open;
        DISCONNECT;
        exit;
    EOF
exit
EOF

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
HOUR=`date +%H`
MINUTE=`date +%M`
SEC=`date +%S`
echo $USER

mv $replicator_dpdump_directory$replicator_dumpfile_name$replicator_dumpfile_extension $replicator_dpdump_directory$replicator_dumpfile_name$DAY$MONTH$YEAR$HOUR$MINUTE$SEC$replicator_dumpfile_extension
echo "Fin del Respaldo full"
