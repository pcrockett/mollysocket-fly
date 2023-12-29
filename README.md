## MollySocket Server

Running Signal on an [un-Googled Android fork](https://grapheneos.org/) without push notifications
is a death sentence for your battery.

Fortunately, there's [Molly](https://molly.im/), a Signal fork that adds extra features to the
Signal app. It is mostly marketed as "A hardened version of Signal", however the killer feature in
my opinion is [UnifiedPush](https://unifiedpush.org/) support. UnifiedPush is what allows an app to
receive proper push notifications _without_ Google Play Services and _without_ absolutely destroying
your battery life.

This repository shows how to get a low-maintenance, free, [MollySocket](https://github.com/mollyim/mollysocket)
instance running in "Air Gap mode" on [Fly.io](https://fly.io/). This makes it easy to set up the
[UnifiedPush flavor of Molly](https://github.com/mollyim/mollyim-android-unifiedpush).

### Getting Started

**Launch your MollySocket server:**

Set up a Fly.io account and install the CLI. You may also need to associate a credit card with that
account.

Then run:

```bash
git clone git@github.com:pcrockett/mollysocket-fly.git && cd mollysocket-fly
cp fly.template.toml fly.toml
make launch
```

**Install a UnifiedPush distributor on your Android phone:**

[ntfy](https://f-droid.org/en/packages/io.heckel.ntfy/) is an excellent choice. You don't need to
configure anything at all, except perhaps disabling battery optimization for the app (which should
in theory have trivial impact on your battery usage).

**Set up Molly-FOSS:**

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

Come back to your git repository you cloned. Run

```bash
make ssh
# or alternatively:
flyctl ssh console
```

Then on your server run `mollysocket [the-command-you-just-copied-above]`

At this point, if everything worked, you should be finished. You now have push notifications for
Signal.

### Assumptions

Fly.io really encourages you to set up your apps with redundancy by default. This configuration does
NOT do that. Push notifications are not a critical service for me and my users, so I can afford a
few seconds of downtime every now and then.
