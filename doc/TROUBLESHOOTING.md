## Troubleshooting

If the following doesn't help you, do feel free to
[file an issue](https://github.com/pcrockett/mollysocket-fly/issues). If you include the
output of `make logs` in your issue description, that would be very helpful.

If the Molly app stops receiving push notifications, there could be a number of reasons:

### You forgot to restart / redeploy the MollySocket server after adding your device

Try restarting the server with `make deploy`.

### You have too many linked devices:

Signal only allows 5 linked devices per account. MollySocket counts as 1 linked device,
so if you've linked more than 4 other devices, you risk MollySocket being bumped off and
it will never reconnect again.

To see if this is the case, go into the Molly Android app settings and select _Linked
devices_. You should see your current Android device in the list, _MollySocket_, and up
to 4 other devices.

If you don't see _MollySocket_ in the list, you know MollySocket has been disconnected.
Try these steps:

1. If you see 5 or more linked devices in your list, remove one of them by tapping on
   it.
2. Login to your server with `make ssh`
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
5. Type `exit` and then `make restart` to restart the server.
6. Re-add the connection as described in the [setup instructions](./HOWTO.md#setup-the-molly-app-for-push-notifications).
7. Restart the server again

After your server is up and running again, you should see MollySocket in your list of
linked devices.

### Your Android device is still doing battery optimization

Double-check that battery optimization for both the UnifiedPush distributor
AND Molly is disabled. If you have already disabled battery optimization,
and you're not running some custom Android ROM on your phone, check out
[dontkillmyapp.com](https://dontkillmyapp.com/) to see if there are additional hoops you
need to jump through to prevent your phone from killing apps.

### You are using a UnifiedPush distributor app that isn't compatible with air-gapped mode

Most UnifiedPush distributor apps should work fine the way we have things set up.
However some apps might be configured to rotate UnifiedPush endpoints occasionally, and
since we're using MollySocket in air-gapped mode, there's no way to tell MollySocket to
update its configuration when that happens. So things silently stop working.

Here are some things you can try if this happens:

* see if you can configure your distributor app to avoid rotating endpoints
* switch to a known-compatible distributor app like `ntfy`
* avoid using this repository, and instead setup MollySocket as a proper
  Internet-accessible web service (that is, _not_ using air-gapped mode)

### You have more than one UnifiedPush distributor on your phone

This issue is a weird one, but is thankfully easy to solve.

If you're looking at your MollySocket server logs (via `make logs`) and see messages
about [HTTP 507 Insufficient Storage](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/507),
it's very likely because you have multiple UnifiedPush distributors on your phone, and
Molly isn't using the correct one.

These HTTP 507 server log messages happen because MollySocket is
[trying to publish notifications where no UnifiedPush client is listening yet](https://docs.ntfy.sh/config/#subscriber-based-rate-limiting).

Why does this happen? Some custom Android ROMs like [/e/OS](https://e.foundation/e-os/)
actually come with a UnifiedPush distributor app preinstalled out of the box. This may
sound great, however at least in the case of /e/OS, the built-in app _doesn't work_, and
its existence is hidden from you. So when you setup Molly with a UnifiedPush
distributor, Molly may set itself up with the broken UnifiedPush distributor app, and
not the _good_ one you installed yourself.

The fix is to either:

1. uninstall one of your UnifiedPush distributor apps and reconfigure Molly, or
2. go into Molly's notification settings and explicitly select a different UnifiedPush
   distributor in the list.

Unfortunately in the case of /e/OS, their built-in distributor app is a "system" app, so
you can't uninstall it. Option 2 is the only solution in this case.
