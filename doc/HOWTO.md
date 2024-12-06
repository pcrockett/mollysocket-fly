## Getting Molly with UnifiedPush working

Here are the steps required to get things working. If you want to understand the big picture of what
we're setting up, check out [What we're building and why](WHAT_WHY.md).

If any of these steps give you trouble, then check out [Troubleshooting](TROUBLESHOOTING.md).

**Table of Contents:**

1. [Fork this repository](#fork-this-repository)
2. [Launch your MollySocket server](#launch-your-mollysocket-server)
3. [Install a UnifiedPush distributor on your Android phone](#install-a-unifiedpush-distributor-on-your-android-phone)
4. [Install Molly on your Android phone](#install-molly-on-your-android-phone)
5. [Setup the Molly app for push notifications](#setup-the-molly-app-for-push-notifications)
6. [Establish the connection on your MollySocket server](#establish-the-connection-on-your-mollysocket-server)
7. [Restart the server](#restart-the-server)
8. [Set up automatic updates](#set-up-automatic-updates)
9. [Subscribe to mollysocket-fly releases](#subscribe-to-mollysocket-fly-releases)

### Fork this repository

You technically don't _need_ to fork this repository, however having your own fork on GitHub will
allow you to use GitHub Actions to automatically keep your MollySocket server up-to-date (explained
below). If you choose not to fork this repository, that's fine, but you will need to set up your own
software update routine using `make deploy`.

### Launch your MollySocket server

Set up a Fly.io account and install the CLI. You may also need to associate a credit card with that
account.

Then clone your repository and create your Fly.io app:

```bash
git clone git@github.com:${GITHUB_USERNAME}/mollysocket-fly.git
cd mollysocket-fly
make launch
```

If this completes successfully, you'll have a new app in Fly.io, plus a new `fly.toml` configuration
file in your current directory. You shouldn't need to edit this file, but it's good to know that it
exists, and you should definitely keep it around.

### Install a UnifiedPush distributor on your Android phone

I recommend installing [ntfy](https://f-droid.org/en/packages/io.heckel.ntfy/) as a
[UnifiedPush distributor](https://unifiedpush.org/users/distributors/), and it requires no
configuration whatsoever. It just needs to be installed and running.

Disable battery optimization for ntfy in Android settings. Don't worry; In my experience, ntfy has
next to zero impact on battery life when on WiFi, and is significantly better than Signal when on
mobile data connections.

### Install Molly on your Android phone

[Install Molly](https://github.com/mollyim/mollyim-android?tab=readme-ov-file#download) on your
phone and [migrate your Signal account](https://github.com/mollyim/mollyim-android/wiki/Migrating-From-Signal)
(if necessary).

Also disable battery optimizations for the Molly app. And once again don't worry; Molly won't eat
your battery like the Signal app.

### Setup the Molly app for push notifications

Once Molly is all set up and running, go into notification settings in Molly and scroll down to the
bottom.

1. Select UnifiedPush as the delivery method.
2. Click on the new UnifiedPush option that appears.
3. Turn on "air gapped" mode.
4. Click on "Server parameters" to copy a command to the clipboard.

Send that command to your computer where you're working somehow (for example via Signal's "Note to
self" feature and the Signal Desktop app).

### Establish the connection on your MollySocket server

Come back to the git repository you cloned. Run

```bash
flyctl ssh console
```

This will open an interactive terminal on your server. Then run
`mollysocket <the-command-you-just-copied-above>`

You should see a new Molly notification on your phone:

> This is a test notification received from your MollySocket server.

Almost done! Run `exit` to exit the SSH session and come back to your local machine.

### Restart the server

Run `flyctl deploy`. This will restart the MollySocket server, which will cause MollySocket to begin
monitoring the Signal service for notifications.

If everything is working, there's just one thing left to do:

### Set up automatic updates

Go to your repository's GitHub Actions tab (`https://github.com/${GITHUB_USERNAME}/mollysocket-fly/actions`)
and click the big green "I understand my workflows, go ahead and enable them" button. _Feel free to
review the workflows to make sure I'm not doing anything nasty to you._

Go to your repository settings on GitHub and head over to _Secrets and Variables_ -> _Actions_
(`https://github.com/${GITHUB_USERNAME}/mollysocket-fly/settings/secrets/actions`)

Populate the `FLY_APP` repository secret with the name of the app. This should be toward the top of
your `fly.toml` file.

Back on your terminal, while you're in your cloned repository, run `flyctl tokens create deploy`.
Then populate the `FLY_DEPLOY_TOKEN` repository secret with the output of that command.

At this point GitHub Actions will update your MollySocket instance once per week. If you want to
configure this, you can edit the [deploy.yml](../.github/workflows/deploy.yml) file.

### Subscribe to mollysocket-fly releases

I periodically update this repository. If you want to keep your configuration up-to-date with the
latest changes, subscribe to releases on this repository. On [the repository's main page](https://github.com/pcrockett/mollysocket-fly)
click the _Watch_ button, then _Custom_, then the _Releases_ checkbox.

When any significant changes happen here, we'll cut a new release, and GitHub will notify you. You
can read the release notes and optionally synchronize your fork with the main repository.
