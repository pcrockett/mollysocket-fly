launch:
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
