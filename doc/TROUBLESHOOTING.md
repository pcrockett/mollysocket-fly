## Troubleshooting

_Work in progress._

If the following doesn't help you, do feel free to
[file an issue](https://github.com/pcrockett/mollysocket-fly/issues). If you include the output of
`make logs` in your issue description, that would be very helpful.

**The Molly app stops receiving notifications after a while.**

If you recently added a new connection to your MollySocket server, restart the server with
`flyctl deploy` if you haven't already.

Double-check that battery optimization for both the UnifiedPush distributor AND Molly is disabled.
If you have already disabled battery optimization, and you're not running some custom Android ROM
on your phone, check out [dontkillmyapp.com](https://dontkillmyapp.com/) to see if there are
additional hoops you need to jump through to prevent your phone from killing apps.

If you chose to use a UnifiedPush distributor other than `ntfy`, it very well
[may stop working](https://github.com/mollyim/mollysocket/issues/35#issuecomment-2105094828). Try
switching to `ntfy` (at least temporarily) to see if it resolves the problem.
