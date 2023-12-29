launch:
	flyctl launch --copy-config --no-public-ips
.PHONY: launch

deploy:
	flyctl deploy
.PHONY: deploy

ssh:
	flyctl ssh console
.PHONY: ssh
