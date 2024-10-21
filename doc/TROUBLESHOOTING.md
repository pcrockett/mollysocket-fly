## Troubleshooting

If the following doesn't help you, do feel free to
[file an issue](https://github.com/pcrockett/mollysocket-fly/issues). If you include the output of
`make logs` in your issue description, that would be very helpful.

If the Molly app stops receiving push notifications, there could be a number of reasons:

### You forgot to restart / redeploy the MollySocket server after adding your device

Try restarting the server with `flyctl deploy`.

### You have too many linked devices:

Signal only allows 5 linked devices per account. MollySocket counts as 1 linked device, so if you've
linked more than 4 other devices, you risk MollySocket being bumped off and it will never reconnect
again.

To see if this is the case, go into the Molly Android app settings and select _Linked devices_. You
should see your current Android device in the list, _MollySocket_, and up to 4 other devices.

If you don't see _MollySocket_ in the list, you know MollySocket has been disconnected. Try these
steps:

1. If you see 5 or more linked devices in your list, remove one of them by tapping on it.
2. Login to your server with `flyctl ssh console`
3. Run `mollysocket connection list`. It should output something like this:
   ```plaintext
   [src/cli/connection.rs:109:13] &connection = Connection {
       uuid: "....",
       device_id: ...,
       password: "...",
       endpoint: "...",
       forbidden: true,
       last_registration: OptTime(
           None,
       ),
   }
   ```
4. Run `mollysocket connection remove <the uuid displayed above>`
5. Type `exit` and then `flyctl deploy` to restart the server.
6. Re-add the connection as described in the [setup instructions](./HOWTO.md#setup-the-molly-app-for-push-notifications).
7. Restart the server again

After your server is up and running again, you should see MollySocket in your list of linked
devices.

### Your Android device is still doing battery optimization

Double-check that battery optimization for both the UnifiedPush distributor AND Molly is disabled.
If you have already disabled battery optimization, and you're not running some custom Android ROM
on your phone, check out [dontkillmyapp.com](https://dontkillmyapp.com/) to see if there are
additional hoops you need to jump through to prevent your phone from killing apps.

### You are using a wonky UnifiedPush distributor app

If you chose to use a UnifiedPush distributor other than `ntfy`, it very well
[may stop working](https://github.com/mollyim/mollysocket/issues/35#issuecomment-2105094828). Try
switching to `ntfy` (at least temporarily) to see if it resolves the problem.
