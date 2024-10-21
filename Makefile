launch: fly.toml
	flyctl launch --copy-config --no-public-ips --yes
.PHONY: launch

deploy:
	flyctl deploy
.PHONY: deploy

ssh:
	flyctl ssh console
.PHONY: ssh

status:
	flyctl status
.PHONY: status

logs:
	flyctl logs --no-tail
.PHONY: logs

release:
	@gh release create --generate-notes --draft
.PHONY: release

fly.toml:
	cp fly.template.toml fly.toml
