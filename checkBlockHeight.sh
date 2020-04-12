#!/bin/bash

# Obtain Local Node Block Height
myLastBlockHeight="$(jcli rest v0 node stats get -h "http://127.0.0.1:3100/api" | grep -o "lastBlockHeight: \"[[:digit:]]\{1,64\}\"")"
# echo "$myLastBlockHeight"
blockHeightNode=$(echo $myLastBlockHeight | cut -d '"' -f 2)
# echo "$blockHeightNode"

if [[ $(echo $blockHeightNode | grep -E "^[[:digit:]]{1,}$") ]]
then

   # Obtain True Block Height from poolTool.io api
   trueBlockHeight=$(curl -s 'https://pooltool.s3-us-west-2.amazonaws.com/stats/heights.json' | python -mjson.tool | grep -o "\"majoritymax\": [[:digit:]]\{1,64\}" )
   # echo "$trueBlockHeight"

   blockHeightTruth=$(echo $trueBlockHeight | grep -o "[[:digit:]]\{1,64\}")
   # echo "$blockHeightTruth"

   # Compare Block Heights
   myBlockLag=$(( blockHeightTruth - blockHeightNode ))
   # echo $myBlockLag

   # If Block Height is Frozen, Restart the Node
   if [ $myBlockLag -gt 50 ]
   then
      echo "Restarting Stake Pool Node"
      echo "Block Divergence: $myBlockLag"
      systemctl restart jormungandr.service
   fi
fi
