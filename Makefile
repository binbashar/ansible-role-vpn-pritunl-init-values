.PHONY: help
SHELL := /bin/bash

ANSIBLE_GALAXY_ROLE_NAME := binbash_inc.ansible_role_vpn_pritunl_init_values
ANSIBLE_REPO_ROLE_NAME := ansible-role-vpn-pritunl-init-values

PY_PIP_VER := 19.3.1
PY_ANSIBLE_VER := 2.8.7
PY_MOLECULE_VER := 2.22

define OS_VER_LIST
"ubuntu1804" \
"ubuntu1604" \
"debian9" \
"debian8"
endef

help:
	@echo 'Available Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf " - \033[36m%-18s\033[0m %s\n", $$1, $$2}'

#==============================================================#
# MOLECULE: ANSIBLE ROLE TESTS                                 #
#==============================================================#
init: ## Install required ansible roles
	@if [[ "$$(cd ../ && ls |grep '${ANSIBLE_REPO_ROLE_NAME}')" =~ "${ANSIBLE_REPO_ROLE_NAME}" ]]; then\
		echo "# Local molecule dependencies setup";\
		pip install --upgrade pip==${PY_PIP_VER};\
		pip install --user -I ansible==${PY_ANSIBLE_VER};\
		pip install --user -I molecule[docker]==${PY_MOLECULE_VER};\
	else\
		echo "# CircleCI molecule dependencies setup";\
		pip install --upgrade pip==${PY_PIP_VER};\
		pip install -I ansible==${PY_ANSIBLE_VER};\
		pip install -I molecule[docker]==${PY_MOLECULE_VER};\
	fi;

test-ansible-lint: ## Ansible lint
	ansible-lint

test-molecule-galaxy: ## Run playbook tests w/ molecule pulling role from ansible galaxy
	mkdir -p molecule/default/roles
	ansible-galaxy install ${ANSIBLE_GALAXY_ROLE_NAME} -p molecule/default/roles -f

	OS_VER=(${OS_VER_LIST});\
    for i in "$${OS_VER[@]}"; do\
        echo -------------------------------;\
        echo TESTING MODULE ON: $$i;\
        echo -------------------------------;\
    	docker pull geerlingguy/docker-$$i-ansible;\
		if [ "$$i" != "debian8" ]; then\
			MOLECULE_DISTRO=$$i molecule test;\
		else\
	    	echo "Last testing stage";\
	    	MOLECULE_DISTRO=$$i molecule test || rm -rf molecule/default/roles;\
		fi;\
        echo -------------------------------;\
        echo "DONE";\
        echo "";\
	done;

test-molecule-local: ## Run playbook tests w/ molecule using the local code
	mkdir -p molecule/default/roles/${ANSIBLE_GALAXY_ROLE_NAME}

	@if [[ "$$(cd ../ && ls |grep '${ANSIBLE_REPO_ROLE_NAME}')" =~ "${ANSIBLE_REPO_ROLE_NAME}" ]]; then\
		echo "# Local molecule role setup";\
		cd .. && rsync -Rr --exclude '${ANSIBLE_REPO_ROLE_NAME}/molecule' ${ANSIBLE_REPO_ROLE_NAME}/ ${ANSIBLE_REPO_ROLE_NAME}/molecule/default/roles/${ANSIBLE_GALAXY_ROLE_NAME}/;\
	else\
		echo "# CircleCI molecule role setup";\
		cd .. rsync -Rr --exclude 'project/molecule' project/ ${ANSIBLE_REPO_ROLE_NAME}/molecule/default/roles/${ANSIBLE_GALAXY_ROLE_NAME}/;\
	fi;

	OS_VER=(${OS_VER_LIST});\
    for i in "$${OS_VER[@]}"; do\
        echo -------------------------------;\
        echo TESTING MODULE ON: $$i;\
        echo -------------------------------;\
    	docker pull geerlingguy/docker-$$i-ansible;\
		if [ "$$i" != "debian8" ]; then\
			echo "## Starting testing stages ##";\
			MOLECULE_DISTRO=$$i molecule test;\
		else\
			echo "## Last testing stage ##";\
	    	MOLECULE_DISTRO=$$i molecule test || rm -rf molecule/default/roles;\
		fi;\
        echo -------------------------------;\
        echo "DONE";\
        echo "";\
	done;

ansible-galaxy-import-role: ## Run playbook tests w/ molecule using the local code
	ansible-galaxy role import --branch="master" --api-key="$(ANSIBLE_GALAXY_API_KEY)" \
	--role-name="binbash_inc.ansible_role_users" \
	binbashar ${ANSIBLE_REPO_ROLE_NAME}

#==============================================================#
# CIRCLECI 													   #
#==============================================================#
circleci-validate-config: ## Validate A CircleCI Config (https://circleci.com/docs/2.0/local-cli/)
	circleci config validate .circleci/config.yml