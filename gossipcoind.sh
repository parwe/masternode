#!/bin/bash
# shellcheck disable=SC2034

# Copyright (c) 2018
# All rights reserved.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.

# Run this file
# bash -i <(wget -4qO- -o- raw.githubusercontent.com/mikeytown2/masternode/master/gossipcoind.sh) ; source ~/.bashrc

# Github user and project.
GITHUB_REPO='g0ssipcoin/GossipCoinCore'
# Explorer URL
EXPLORER_URL='http://chain.gossipcoin.net/'
# Rate limit explorer
EXPLORER_SLEEP=1
# Amount of Collateral needed
COLLATERAL=25000
if [ -x "$( command -v hxnormalize )" ]
then
  echo "Getting collateral from explorer"
  COLLATERAL_ALT=$( wget -4qO- -o- "${EXPLORER_URL}"/coininfo | hxnormalize -x | hxselect -i -c '.coin-info .panel-body .row .col-md-9 .panel-body .info-row:nth-child(3) .col-md-4:nth-child(2) h4' )
  if [[ ! -z "${COLLATERAL_ALT}" ]]
  then
    COLLATERAL=${COLLATERAL_ALT}
  fi
fi

ASCII_ART () {
echo -e "\\e[0m"
clear 2> /dev/null
cat << "GOSSIPCOIN"
 _____             _     _____     _
|   __|___ ___ ___|_|___|     |___|_|___
|  |  | . |_ -|_ -| | . |   --| . | |   |
|_____|___|___|___|_|  _|_____|___|_|_|_|
                    |_|
GOSSIPCOIN
}

# Tip Address
TIPS=''
# Dropbox Addnodes
DROPBOX_ADDNODES=''
# If set to 1 then use addnodes from dropbox.
USE_DROPBOX_ADDNODES=0
# Dropbox Bootstrap
DROPBOX_BOOTSTRAP=''
# If set to 1 then use bootstrap from dropbox.
USE_DROPBOX_BOOTSTRAP=0
# Dropbox blocks and chainstake folders.
DROPBOX_BLOCKS_N_CHAINS=''
# Cycle Daemon
DAEMON_CYCLE=0
# Fallback Blockcount
BLOCKCOUNT_FALLBACK_VALUE=223000
# Slow Daemon Start.
SLOW_DAEMON_START=0
# Bad Explorer SSL.
BAD_SSL_HACK=''
# Extra configuation for the conf file.
EXTRA_CONFIG=''
# Auto Recovery.
RESTART_IN_SYNC=1
# Multiple on single IP.
MULTI_IP_MODE=1
# Number of Connections to wait for.
DAEMON_CONNECTIONS=6
# Wait for MNSYNC
#MNSYNC_WAIT_FOR='"RequestedMasternodeAssets": 999,'
MNSYNC_WAIT_FOR=''
# Run Mini Monitor.
MINI_MONITOR_RUN=1
# Mini Monitor check masternode list.
MINI_MONITOR_MN_LIST=1
# Mini Monitor Status to check for.
MINI_MONITOR_MN_STATUS='4'
# Mini Monitor Queue Payouts.
MINI_MONITOR_MN_QUEUE=1
# Mini Monitor masternode count is a json string.
MINI_MONITOR_MN_COUNT_JSON=1

# Discord User Info
# @mcarper#0918
# 401161988744544258
cd ~/ || exit
COUNTER=0
rm -f ~/___mn.sh
while [[ ! -f ~/___mn.sh ]] || [[ $( grep -Fxc "# End of masternode setup script." ~/___mn.sh ) -eq 0 ]]
do
  rm -f ~/___mn.sh
  echo "Downloading Masternode Setup Script."
  wget -4qo- goo.gl/uQw9tz -O ~/___mn.sh
  COUNTER=$((COUNTER+1))
  if [[ "${COUNTER}" -gt 3 ]]
  then
    echo
    echo "Download of masternode setup script failed."
    echo
    exit 1
  fi
done

(
  sleep 2
  rm ~/___mn.sh
) & disown

# shellcheck disable=SC1091
# shellcheck source=/root/___mn.sh
. ~/___mn.sh
DAEMON_SETUP_THREAD
# shellcheck source=/root/.bashrc
. ~/.bashrc
stty sane