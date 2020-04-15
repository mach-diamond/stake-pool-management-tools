# stake-pool-management-tools

Start a cron job to call the script(s) with the following command:

`sudo crontab -e`

And enter the following text.

```
* * * * * /home/pool-user/checkBlockHeight.sh
*/5 * * * * /home/pool-user/sendMyTip.sh
```

[sendMyTip.sh can be found here](https://github.com/papacarp/pooltool.io/blob/master/sendmytip/shell/sendmytip.sh)

Ensure the job is running with:

`crontab -l`




