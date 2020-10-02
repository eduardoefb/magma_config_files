#!/bin/bash
while :; do
   if [[ "`pcs status | awk '/master_ha/ {print $NF}'`" == "`echo ${HOSTNAME} | awk -F '.' '{print $1}'`" ]]; then
      for node in `pcs status | grep --color -oP '(?<=Online: \[)(.*)(?=\])'`; do
         if [ "${node}" != "`echo ${HOSTNAME} | awk -F '.' '{print $1}'`" ]; then
            rsync -av -r --delete /srv/k8s_volume ${node}:/srv/
         fi
      done
   fi
   sleep 60
done
