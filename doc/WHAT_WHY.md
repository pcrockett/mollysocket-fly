## What we're building and why

_Feel free to skip to [the how-to](HOWTO.md) if you don't care about the rationale or big picture._

Running Signal on an [un-Googled Android fork](https://grapheneos.org/) without push notifications
is a death sentence for your battery. The only way to get notifications from Signal in this case is
to disable Android's battery optimization for the app and allow it to keep an active connection
alive at all times. For some reason, Signal isn't good at doing that efficiently, so it'll often
burn through 50% of your battery in a single day.

Fortunately, there's [Molly](https://molly.im/), a Signal fork that is mostly marketed as "A
hardened version of Signal." However the killer feature in my opinion is not the extra security,
but rather [UnifiedPush](https://unifiedpush.org/) support. UnifiedPush is what allows an app to
receive proper push notifications without Google Play Services and _also_ without absolutely
destroying your battery life.

Here's an oversimplified, mostly wrong diagram that lays out how the whole system should work:

```plaintext
 ┌────────────────────┐
 │signal cloud service│
 └─────────┬──────────┘
           │ sends notification
     ┌─────▼─────┐
     │mollysocket│  <- server running in fly.io -- behaves as "linked device"
     └─────┬─────┘
           │ forwards notification
       ┌───▼───┐
       │ntfy.sh│    <- UnifiedPush service
       └───┬───┘
           │ forwards notification
      ┌────▼───┐
      │ntfy app│    <- UnifiedPush client
      │on phone│
      └────┬───┘
           │ forwards notification
      ┌────▼────┐
      │molly app│
      └─────────┘
```

_Side note: Notifications themselves don't contain any sensitive information; their purpose is just
to wake up Molly, which then handles actually downloading and displaying the notification content._

If you think the above diagram looks like a lot of moving parts that could break, it's good to keep
in mind that this is generally how Google sets up a stock Android device (instead of `ntfy.sh` you
have Google Play services, etc.). The only _really_ different piece about this setup is
MollySocket.

This repository shows how to get a low-maintenance, free, [MollySocket](https://github.com/mollyim/mollysocket)
instance running in "Air Gap mode" on [Fly.io](https://fly.io/). It handles the hardest part of the
diagram above, making it much easier to get UnifiedPush for Molly working properly.

Next: [Getting Molly with UnifiedPush working](HOWTO.md)
