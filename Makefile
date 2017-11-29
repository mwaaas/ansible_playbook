ansible_version=latest
image-version=latest


deploy:
	docker build --build-arg ansible_version=$(ansible_version) -t mwaaas/ansible_playbook:$(ansible_version)-$(image-version) .
	docker push mwaaas/ansible_playbook:$(ansible_version)-$(image-version)