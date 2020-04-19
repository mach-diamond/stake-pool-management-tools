#!/usr/bin/env bash
HOME=/root
LOGNAME=root
PWD=/home/pool-user/
SHELL=/bin/bash
LANG=en_US.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

maxDelta=20

# THIS SHOULD TAKE CARE OF JCLI PATH (ASSUMES $PATH ; /usr/local/bin ; or same directory)
JCLI="$(command -v jcli)"
[ -z "$JCLI" ] && JCLI="/usr/local/bin/jcli"
[ -z "$JCLI" ] && [ -f ./jcli ] && JCLI="./jcli"

# Obtain Local Node Block Height
myLastBlockHeight=$($JCLI rest v0 node stats get -h "http://127.0.0.1:3100/api" | grep -o "lastBlockHeight: \"[[:digit:]]\{1,64\}\"")
blockHeightNode=$(echo $myLastBlockHeight | cut -d '"' -f 2)

# Check if blockheight is obtainable, if not its likely booting
if [[ $(echo $blockHeightNode | grep -E "^[[:digit:]]{1,}$") ]]
then

   # Obtain True Block Height from poolTool.io api
   trueBlockHeight=$(curl -s 'https://pooltool.s3-us-west-2.amazonaws.com/stats/heights.json' | python -mjson.tool | grep -o "\"majoritymax\": [[:digit:]]\{1,64\}" )
   blockHeightTruth=$(echo $trueBlockHeight | grep -o "[[:digit:]]\{1,64\}")

   # Compare Block Heights
   myBlockLag=$(( blockHeightTruth - blockHeightNode ))

   # If Block Height is Frozen, Restart the Node
   if [ $myBlockLag -gt $maxDelta ]
   then
      restartTime=$(date +"%T")
      upTime=$($JCLI rest v0 node stats get -h "http://127.0.0.1:3100/api" | grep -o "uptime: [[:digit:]]\{1,64\}")
      runTime=$(echo $upTime | grep -o "[[:digit:]]\{1,64\}")
      echo "Block Divergence: $myBlockLag    Run Time: $runTime    Restart Time: $restartTime" >> /home/pool-user/blockDivergence.log
      /bin/systemctl restart jormungandr.service
   fi
fi
