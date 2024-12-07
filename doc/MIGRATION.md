## Legacy Molly-UP to Molly-FOSS migration notes

Good news! This UnifiedPush "flavor" of Molly [is no longer required](https://github.com/mollyim/mollyim-android-unifiedpush/releases/tag/v7.23.1-1.up1).
UnifiedPush support has been merged into the main Molly-FOSS app.

**There will be no more updates for the legacy app.** To keep receiving updates, you'll need to
migrate to the main Molly-FOSS app.

Additionally, a new version of [MollySocket](https://github.com/mollyim/mollysocket) has been
released with a slightly different workflow for getting set up. I recommend that you:

1. [Create a new instance of MollySocket](#create-a-new-instance-of-mollysocket)
2. [Migrate your Android app from the legacy version to Molly-FOSS](#migrating-to-molly-foss)
3. [Restore MollySocket push notifications](#restore-mollysocket-push-notifications)
4. [Destroy the old instance of MollySocket](#destroy-the-old-instance-of-mollysocket)

### Create a new instance of MollySocket

Open this repository in a terminal and run:

```bash
mv fly.toml fly.toml.old
make launch
```

Congratulations, you should now have a second instance of MollySocket running in a new Fly app.

### Migrating to Molly-FOSS

1. [Install Molly-FOSS on your phone](https://molly.im/download/fdroid/). _Don't uninstall the old
   Molly-UP app yet._
2. In the old Molly app, go to Chat settings and scroll down to the bottom to _Chat backups_. Click
   that and generate a new backup. Remember the file path where you saved the backup.
3. Now go to Android's app settings page and _Disable_ the old Molly app. Don't uninstall it yet,
   just in case. You can uninstall it later when you're all finished and everything is working.
4. Open up the new Molly-FOSS app. As you go through the welcome screens, you'll see an option to
   restore from a backup. Do that.

When the new app is running correctly, you'll need to Restore push notifications.

### Restore MollySocket push notifications

Go through the steps in the instructions starting at
[step 5: Setup the Molly app for push notifications](HOWTO.md#setup-the-molly-app-for-push-notifications).
Don't forget to also update your
[GitHub Actions settings for automatic updates](HOWTO.md#set-up-automatic-updates) so that they
point to your new MollySocket instance.

_Recommended: Let it run for a while to make sure you continue receiving push notifications._

### Destroy the old instance of MollySocket

1. [Login to fly.io](https://fly.io/app/sign-in)
2. Click on the old MollySocket app
3. Go to Settings
4. Click _Delete app_.

Now is also probably a good time to fully uninstall the old Molly-UP app from your phone.
