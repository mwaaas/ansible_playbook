ansible_version=latest
version=latest


deploy:
	docker build --build-arg ansible_version=$(ansible_version) -t mwaaas/ansible_playbook:$(ansible_version)-$(version) .
	docker push mwaaas/ansible_playbook:$(ansible_version)-$(version)