launch: fly.toml
	@flyctl launch --copy-config --no-public-ips --yes
.PHONY: launch

deploy:
	@flyctl deploy
.PHONY: deploy

lint:
	pre-commit run --all
.PHONY: lint

ssh:
	@flyctl ssh console
.PHONY: ssh

qr:
	@# if your terminal background is dark:
	@flyctl ssh console --command "qr.sh"
.PHONY: qr

qr-invert:
	@# if your terminal background is light:
	@flyctl ssh console --command "mollysocket qr airgapped"
.PHONY: qr-invert

restart:
	@flyctl scale count 0 --process-group worker --yes
	@flyctl scale count 1 --process-group worker --yes
.PHONY: restart

status:
	@flyctl status
.PHONY: status

logs:
	@flyctl logs --no-tail
.PHONY: logs

release:
	@gh release create --generate-notes --draft
.PHONY: release

deploy-token:
	@flyctl tokens create deploy
.PHONY: deploy-token

healthcheck:
	@./bin/set-secret.sh MOLLY_FLY_HEALTHCHECK_URL
.PHONY: healthcheck

fly.toml:
	@cp fly.template.toml fly.toml
