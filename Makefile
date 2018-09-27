ansible_version=2.4.1.0
version=latest


deploy:
	docker build --build-arg ansible_version=$(ansible_version) -t mwaaas/ansible_playbook:$(ansible_version)-$(image-version) .
	docker push mwaaas/ansible_playbook:$(ansible_version)-$(image-version)