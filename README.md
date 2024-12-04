# MollySocket Fly.io Service

Get Signal push notifications without Google Play Services, and without killing your phone's
battery. A secure, free, low-maintenance solution using [Fly.io](https://fly.io).

---

**IMPORTANT UPDATE 2024-12-04:** Good news! Unified push has been merged into the main Molly
app, and the old "unified push" flavor of the app is now deprecated. There also seem to be some
usability improvements around getting it set up. That said, I don't have time to look into them
now, so these instructions are now old. In the next few days I'll get around to bringing them
up-to-date.

See [this issue](https://github.com/pcrockett/mollysocket-fly/issues/15) for more details.

---

**Table of Contents:**

* [What we're building and why](doc/WHAT_WHY.md)
* [Getting Molly with UnifiedPush working](doc/HOWTO.md)
* [Troubleshooting](doc/TROUBLESHOOTING.md)

## Disclaimer

I'm going to [quote the upstream MollySocket project](https://github.com/mollyim/mollysocket/?tab=readme-ov-file#disclaimer)
because I couldn't say it any better:

> This project is NOT sponsored by or affiliated to Signal Messenger or Signal Foundation.
>
> The software is produced independently of Signal and carries no guarantee about quality, security
> or anything else. Use at your own risk.

## Side Notes

**Free tier:**

_Never assume a free tier for any service will stay around forever._ However as of May 2024:

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
