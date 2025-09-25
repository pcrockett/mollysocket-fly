# MollySocket Fly.io Service

Get Signal push notifications without Google Play Services, and without
killing your phone's battery. A secure, free, low-maintenance solution using
[Fly.io](https://fly.io).

**Table of Contents:**

* [What we're building and why](doc/WHAT_WHY.md)
* [Getting Molly with UnifiedPush working](doc/HOWTO.md)
* [Troubleshooting](doc/TROUBLESHOOTING.md)

## Disclaimer

I'm going to [quote the upstream MollySocket project](https://github.com/mollyim/mollysocket/?tab=readme-ov-file#disclaimer)
because I couldn't say it any better:

> This project is NOT sponsored by or affiliated to Signal Messenger or Signal
> Foundation.
>
> The software is produced independently of Signal and carries no guarantee about
> quality, security or anything else. Use at your own risk.

## Side Notes

**Air-gapped mode:**

This project uses the MollySocket server in air-gapped mode. This is a tradeoff
decision: On the one hand, it makes initial setup a little bit more manual. On the other
hand, it avoids needing to expose a web service to the world (or to a VPN). This is a
big advantage, both in terms of security and maintenance.

While this works just fine, the upstream MollySocket project considers this to be an
exceptional use-case. If you plan to onboard lots of devices fairly frequently, this
project is probably not for you.

**Donations:**

You can certainly [buy me a muffin on Ko-fi](https://ko-fi.com/pcrockett) for the little
bit of effort I put into this project, however this project is so trivial to maintain
because it stands on the shoulders of giants. I'd encourage you to first [send donations
to Molly](https://opencollective.com/mollyim#category-CONTRIBUTE) before you think about
sending them to me.

Seriously. It's nice to know that people find this project to be helpful. A simple
"thanks!" is enough to motivate me to keep it running.

**Fly's free tier:**

_Never assume a free tier for any service will stay around forever._ However as of May
2024:

This should be within the limits of the Fly.io free tier. You may see some
expensive-looking "builder" machines in your Fly dashboard, but they are given to you
for free. If you do rack up some bills while using the service, Fly will also not charge
you for anything less than $5.

**This isn't the normal way of doing things:**

The project deviates from the usual pattern that most people set up with Fly.io:

* Fly.io really encourages you to set up your apps with redundancy by default. This
  configuration does NOT do that. Push notifications are not a critical service for me
  and my users, so I can afford a few seconds of downtime every now and then.
* Because we're using air gap mode, we have no need to provide an actual Internet-facing
  service. So the only process that's running in Fly.io is a _worker_ process, and it
  should be impossible to actually interact with the MollySocket instance besides via
  `flyctl ssh console`.

**The Makefile:**

The [Makefile](./Makefile) isn't terribly useful; I just created it to help me remember
basic Fly.io CLI commands. I'm not a frequent Fly.io user by any stretch of the
imagination.
