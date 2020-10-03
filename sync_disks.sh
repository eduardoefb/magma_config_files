#!/bin/bash
POSTGRES_DB="#POSTGRES_DB#"
while :; do
   if [[ "`pcs status | awk '/master_ha/ {print $NF}'`" == "`echo ${HOSTNAME} | awk -F '.' '{print $1}'`" ]]; then
      for node in `pcs status | grep --color -oP '(?<=Online: \[)(.*)(?=\])'`; do
         if [ "${node}" != "`echo ${HOSTNAME} | awk -F '.' '{print $1}'`" ]; then
            rsync -av -r --delete /srv/k8s_volume ${node}:/srv/
            su - postgres -c "pg_dump ${POSTGRES_DB}" > /tmp/db_bkp
            cat /tmp/db_bkp | psql -U postgres -h ${node} orc8r
            \rm -f /tmp/db_bkp 2>/dev/null          
         fi
      done
   fi
   sleep 60
done



