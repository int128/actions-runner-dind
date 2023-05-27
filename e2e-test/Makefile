KUBECONFIG := kubeconfig.yaml
export KUBECONFIG

.PHONY: cluster
cluster:
	kind create cluster --name arc-cluster
	kubectl version

.PHONY: deploy
deploy:
	helmfile sync
	helm list -A
	kubectl get pods -n arc-systems
	kubectl wait pods -n arc-systems --all --for=condition=Ready

.PHONY: wait-for-job
wait-for-job:
	kubectl wait pods -n arc-systems --all --for=condition=Ready
	kubectl wait pods -n arc-runners --all --for=condition=Ready
	-kubectl logs -n arc-runners -l app.kubernetes.io/component=runner --tail=-1 -f

.PHONY: logs
logs:
	-kubectl logs -n arc-systems -l app.kubernetes.io/component=controller-manager --tail=-1
