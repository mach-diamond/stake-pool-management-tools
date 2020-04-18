# stake-pool-management-tools

Start a cron job to call the script(s) with the following command:

`sudo crontab -e`

And enter the following text.

```
* * * * * /home/pool-user/checkBlockHeight.sh
* * * * * /home/pool-user/sendMyTip.sh
0 * * * * sync; echo 3 > /proc/sys/vm/drop_caches
```

[sendMyTip.sh can be found here](https://github.com/papacarp/pooltool.io/blob/master/sendmytip/shell/sendmytip.sh)

Ensure the job is running with:

`crontab -l`




