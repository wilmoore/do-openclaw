# Makefile – OpenClaw deployment and admin helpers

-include .env

DROPLET_NAME ?= openclaw
TAILSCALE_IP ?= $(shell cat .tailscale_ip 2>/dev/null || echo "UNKNOWN")
DEPLOY_FLAGS ?= \
	--size s-2vcpu-2gb \
	--region nyc1 \
	--ssh-key-id $(SSH_KEY_ID) \
	--user-data-file ansible/cloud-init.yml \
	--env TAILSCALE_AUTHKEY=$(TAILSCALE_AUTHKEY) \
	--wait

define print-header
	@printf "\n\033[1;34m%s\033[0m\n" "$(1)"
endef

.PHONY: help deploy ssh logs monitor grafana status backup destroy update test

help:
	$(call print-header,"OpenClaw – Available Targets")
	@printf "  \033[1;33mmake deploy\033[0m   Deploy a new Basic droplet (~\$12/mo)\n"
	@printf "  \033[1;33mmake ssh\033[0m      SSH into the droplet via Tailscale\n"
	@printf "  \033[1;33mmake logs\033[0m     Stream OpenClaw logs\n"
	@printf "  \033[1;33mmake monitor\033[0m  Print Prometheus metrics URL\n"
	@printf "  \033[1;33mmake grafana\033[0m   Print Grafana URL and credentials\n"
	@printf "  \033[1;33mmake status\033[0m   Show droplet status\n"
	@printf "  \033[1;33mmake backup\033[0m   Create a snapshot\n"
	@printf "  \033[1;33mmake destroy\033[0m  Delete the droplet\n"
	@printf "  \033[1;33mmake update\033[0m   Re-run Ansible\n"
	@printf "  \033[1;33mmake test\033[0m     Run static analysis\n"

deploy:
	$(call print-header,"Deploying OpenClaw (Basic ~\$12/mo)")
	@pro digitalocean create $(DEPLOY_FLAGS) \
	  --name $(DROPLET_NAME) \
	  > deploy.log
	@grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' deploy.log > .tailscale_ip.tmp; \
	if [ -s .tailscale_ip.tmp ]; then \
	  mv .tailscale_ip.tmp .tailscale_ip; \
	  echo "Deployment complete – IP saved to .tailscale_ip"; \
	else \
	  rm -f .tailscale_ip.tmp; \
	  echo "Error: Could not extract Tailscale IP from deployment output"; \
	  exit 1; \
	fi

ssh:
	@if [ "$(TAILSCALE_IP)" = "UNKNOWN" ]; then \
	  echo "No Tailscale IP – run 'make deploy' first"; \
	  exit 1; \
	fi
	$(call print-header,"SSH to $(TAILSCALE_IP)")
	@ssh ubuntu@$(TAILSCALE_IP)

logs:
	@if [ "$(TAILSCALE_IP)" = "UNKNOWN" ]; then \
	  echo "No Tailscale IP – run 'make deploy' first"; \
	  exit 1; \
	fi
	$(call print-header,"Streaming OpenClaw logs")
	@ssh ubuntu@$(TAILSCALE_IP) "sudo journalctl -u openclaw -f"

monitor:
	@if [ "$(TAILSCALE_IP)" = "UNKNOWN" ]; then \
	  echo "No Tailscale IP – run 'make deploy' first"; \
	  exit 1; \
	fi
	@echo "Prometheus metrics: http://$(TAILSCALE_IP):9100/metrics"

grafana:
	@if [ "$(TAILSCALE_IP)" = "UNKNOWN" ]; then \
	  echo "No Tailscale IP – run 'make deploy' first"; \
	  exit 1; \
	fi
	$(call print-header,"Grafana")
	@echo "URL: http://$(TAILSCALE_IP):3000"
	@echo "Username: admin"
	@echo "Password: admin"

status:
	$(call print-header,"Droplet status")
	@pro digitalocean status $(DROPLET_NAME)

backup:
	$(call print-header,"Creating snapshot")
	@pro digitalocean snapshot $(DROPLET_NAME) \
	  --name backup-$(shell date +%Y%m%d%H%M)

destroy:
	@read -p "Delete $(DROPLET_NAME)? [y/N] " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
	  $(call print-header,"Destroying $(DROPLET_NAME)"); \
	  pro digitalocean destroy $(DROPLET_NAME) --yes; \
	  rm -f .tailscale_ip; \
	else \
	  echo "Aborted"; \
	fi

update:
	$(call print-header,"Re-running Ansible")
	@ansible-pull -U https://github.com/wilmoore/openclaw.git \
	  -C main -i ansible/inventory.ini ansible/site.yml

test:
	$(call print-header,"Running static analysis")
	@coderabbit --prompt-only