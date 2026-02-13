# Makefile
APP=monitoring
VERSION=75.1.0
# Variables (optional, but good practice)
# EXAMPLE_VARIABLE = value

.PHONY: deploy uninstall clean-up

deploy:
	@echo "Deploying application..."
	# Add your deployment commands here
	helm install $(APP) prometheus-community/kube-prometheus-stack --version $(VERSION) -n monitoring -f kube-prometheus-values.yaml

update:
	@echo "Updating application..."
	# Add your update commands here
	helm upgrade $(APP) prometheus-community/kube-prometheus-stack -n monitoring -f kube-prometheus-values.yaml

add-ingress: 
	@echo "Adding Ingress for $(APP)..."
	# Add your ingress commands here
	kubectl apply -f monitoring-ingress.yaml
# Optional: A default target
all: deploy add-ingress

uninstall:
	@echo "Uninstalling application..."
	# Add your uninstallation commands here
	helm uninstall $(APP) -n monitoring 

clean-up:
	@echo "Cleaning up resources..."
	# Add your clean-up commands here
	kubectl delete crd alertmanagers.monitoring.coreos.com
	kubectl delete crd podmonitors.monitoring.coreos.com
	kubectl delete crd probes.monitoring.coreos.com 
	kubectl delete crd prometheusagents.monitoring.coreos.com 
	kubectl delete crd prometheuses.monitoring.coreos.com 
	kubectl delete crd prometheusrules.monitoring.coreos.com 
	kubectl delete crd thanosrulers.monitoring.coreos.com

rem-ingress:
	@echo "Removing Ingress for $(APP)..."
	# Add your ingress removal commands here
	kubectl delete ingress monitoring-ingress -n monitoring

delete: uninstall clean-up
	@echo "All resources have been deleted."

# Optional: Help target
help:
	@echo "Available commands:"
	@echo "  make deploy     - Deploy the application"
	@echo "  make uninstall  - Uninstall the application"
	@echo "  make clean-up   - Clean up resources"
	@echo "  make all        - Deploy the application (default)"
	@echo "  make update     - Update the application"
	@echo "  make add-ingress - Add Ingress for monitoring"
	@echo "  make delete     - Uninstall and clean up resources"
	@echo "  make help       - Show this help message"

 