#!/usr/bin/env bash

for f in /home/nbrinson2/.bashrc.d/*.sh; do
    [ -r "$f" ] && . "$f"
done

update_config_repo >> /home/nbrinson2/.cronjobs/update_config_repo.log 2>&1
