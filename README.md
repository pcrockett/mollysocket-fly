## MollySocket Fly.io Service

Running Signal on an [un-Googled Android fork](https://grapheneos.org/) without push notifications
is a death sentence for your battery. The only way to get notifications from Signal in this case is
to disable Android's battery optimization for the app and allow it to keep an active connection
alive at all times. For some reason, Signal isn't good at doing that efficiently, so it'll often
burn through 50% of your battery in a single day.

Fortunately, there's [Molly](https://molly.im/), a Signal fork that is mostly marketed as "A
hardened version of Signal." However the killer feature in my opinion is not the extra security, but
rather [UnifiedPush](https://unifiedpush.org/) support. UnifiedPush is what allows an app to receive
proper push notifications without Google Play Services and _also_ without absolutely destroying your
battery life.

Here's an oversimplified, mostly wrong diagram that lays out how the whole system should work:

```plaintext
 ┌────────────────────┐
 │signal cloud service│
 └─────────┬──────────┘
           │ sends notification
     ┌─────▼─────┐
     │mollysocket│  <- behaves as "linked device"
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
have Google Play services, etc.). The only _really_ different piece about this setup is mollysocket.

This repository shows how to get a low-maintenance, free, [MollySocket](https://github.com/mollyim/mollysocket)
instance running in "Air Gap mode" on [Fly.io](https://fly.io/). It handles the hardest part of the
diagram above, making it much easier to get the [UnifiedPush flavor of Molly](https://github.com/mollyim/mollyim-android-unifiedpush)
working properly.

### Getting Molly with UnifiedPush working

**Launch your MollySocket server:**

Set up a Fly.io account and install the CLI. You may also need to associate a credit card with that
account.

Then run:

```bash
git clone https://github.com/pcrockett/mollysocket-fly.git && cd mollysocket-fly
cp fly.template.toml fly.toml
make launch
```

**Install a UnifiedPush distributor on your Android phone:**

[ntfy](https://f-droid.org/en/packages/io.heckel.ntfy/) is an excellent choice. You don't need to
configure anything at all, except perhaps disabling battery optimization for the app (in my
experience, the ntfy app adds almost zero extra battery drain with optimization disabled).

**Install and configure Molly on your Android phone:**

Install the [UnifiedPush flavor of Molly](https://github.com/mollyim/mollyim-android-unifiedpush)
on your phone and [migrate your Signal account](https://github.com/mollyim/mollyim-android/wiki/Migrating-From-Signal)
(if necessary).

Once Molly is all set up and running, go into notification settings in Molly and scroll down to the
bottom.

1. Select UnifiedPush as the delivery method.
2. Click on the new UnifiedPush option that appears.
3. Turn on "air gapped" mode.
4. Click on "Server parameters" to copy a command to the clipboard.

Send that command to your computer somehow (for example via Signal's "Note to self" feature and the
Signal Desktop app).

**Establish the connection on your MollySocket server:**

Come back to the git repository you cloned. Run

```bash
flyctl ssh console
```

Then on your server run `mollysocket <the-command-you-just-copied-above>`

At this point, if everything worked, you should be finished. Though before you quit your SSH
session, let's do one last thing:

**Test the connection:**

Run `mollysocket connection list` and find the UUID of the connection you just set up.

Then run `mollysocket connection ping <the-connection-uuid>`

You should see a new Molly notification on your phone. If so, you're all set up!

### Side Notes

**Free tier:**

_Never assume a free tier for any service will stay around forever._ However as of January 2024:

This should be within the limits of the Fly.io free tier. You may see some expensive-looking
"builder" machines in your Fly dashboard, but they are given to you for free. If you do rack up
some bills while using the service, Fly will also not charge you for anything less than $5.

**This isn't the normal way of doing things:**

The project deviates from the usual pattern that most people set up with Fly.io:

* Fly.io really encourages you to set up your apps with redundancy by default. This configuration
    does NOT do that. Push notifications are not a critical service for me and my users, so I can
    afford a few seconds of downtime every now and then.
* Because we're using air gap mode, we have no need to provide an actual Internet-facing service. So
    the only process that's running in Fly.io is a _worker_ process, and it should be impossible to
    actually interact with the MollySocket instance besides via `flyctl ssh console`.

**The Makefile:**

The [Makefile](Makefile) isn't terribly useful; I just created it to help me remember basic Fly.io
CLI commands. I'm not a frequent Fly.io user by any stretch of the imagination.

**Automatic updates:**

This doesn't handle updates for you. You should periodically run `make deploy` to trigger an update.
Some day I may consider adding some kind of mechanism that does this for you automatically, but I'm
not 100% sure how that should work.
