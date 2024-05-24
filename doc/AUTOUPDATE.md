## Automatic Updates

If you want your MollySocket instance to stay up-to-date automatically, there's an easy way using
GitHub Actions.

1. Fork this repository.
2. Go through the [README](../README.md) of your new repository and set up your MollySocket instance
   if you haven't already. When you're finished, come back here. I'll wait.
3. Go to your repository's Actions tab and click the big green "I understand my workflows, go ahead
   and enable them" button. _Feel free to review the workflows to make sure I'm not doing anything
   nasty to you._
4. Go to your repository settings on GitHub and head over to _Secrets and Variables_ -> _Actions_.
5. Populate the `FLY_APP` repository secret with the name of the app. This should be toward the top
   of your `fly.toml` file.
6. On your terminal, while you're in your repository directory, run `flyctl tokens create deploy`.
7. Create a new `FLY_DEPLOY_TOKEN` repository secret, and copy / paste the output of that command
   into it.

At this point GitHub Actions will update your MollySocket instance once per week. If you want to
configure this, you can edit the [depoly.yml](../.github/workflows/deploy.yml) file.

_You may still want to periodically make sure your forked repository is up-to-date with the latest
changes here._
