ansible_version=latest
version=latest
terraform_version=0.12.10
terragrunt_version="v0.20.5"

build:
	docker build --build-arg ansible_version=$(ansible_version) --build-arg terraform_version=$(terraform_version) --build-arg terragrunt_version=$(terragrunt_version) -t mwaaas/ansible_playbook:$(ansible_version)-$(version) .

push:
	docker push mwaaas/ansible_playbook:$(ansible_version)-$(version)

deploy: build push