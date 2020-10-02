<div align="center">
    <img src="./%40doc/figures/binbash-logo.png" 
    alt="binbash" width="250"/>
</div>
<div align="right">
  <img src="./%40doc/figures/binbash-leverage-ansible-logo.png"
  alt="leverage" width="130"/>
</div>

# Ansible Role: binbash_inc.ansible_role_vpn_pritunl_init_values

**Ansible Role Print in stdout the initial user and pass pritunl setup values.**

- PRITUNL_DB_KEY
- DEFAULT_USER
- DEFAULT_USER

## Requirements

None.

### Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

This vars should not be modified except it's strictly necessary for an specific use case. 

```
pritunl_openvpn_init_cmd_db_setup_key: "pritunl setup-key"

pritunl_openvpn_init_cmd_default_login_admin_user: "pritunl default-password | grep 'username: '"

pritunl_openvpn_init_cmd_default_login_admin_pass: "pritunl default-password | grep 'password: '"
```

### Example Playbook

We encourage the user to implement this role as follows, where `print_out_pritunl_setup_secrets` is
a variable that will work till you change the default admin user and pass from the UI

After the 1st round execution you'll need to visit Pritunl UI eg: `vpn-pritunl-server.domain.com` and 
set the **PRITUNL_DB_KEY**.
```
vars:
    print_out_pritunl_setup_secrets: true

- role: binbash_inc.ansible_role_vpn_pritunl_init_values
  when: print_out_pritunl_setup_secrets == true
  tags: openvpn-pritunl-post-task
```

2nd round execution the flag must be kept as `true` and you'll get the default admin user credentials 
in order to re-visit the UI `vpn-pritunl-server.domain.com` and reset these with your new custom values.
Pritunl will always request to change these credentials during your 1st log in. We don't recommend to 
choose "Config Later" under any circumstances.

```
vars:
    print_out_pritunl_setup_secrets: true

- role: binbash_inc.pritunl-openvpn-init-values
      when: print_out_pritunl_setup_secrets == true
      tags: openvpn-pritunl-post-task
```

### Expected Output

```shell
ok: [infra_ec2_pritunl_vpn]
 __________________________________________________________
/ TASK [binbash_inc.ansible_role_vpn_pritunl_init_values : \
\ Print out Pritunl database setup key variable]           /
 ----------------------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ok: [infra_ec2_pritunl_vpn] => {
    "msg": [
        "#================================================#",
        "# PRITUNL_DB_KEY ddf1f3rth9g88j389n3e4c331e396555",
        "#================================================#"
    ]
}

ok: [infra_ec2_pritunl_vpn]
 __________________________________________________________
/ TASK [binbash_inc.ansible_role_vpn_pritunl_init_values : \
\ Print out Pritunl default admin user setup key variable] /
 ----------------------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ok: [infra_ec2_pritunl_vpn] => {
    "msg": [
        "#================================================#",
        "# DEFAULT_USER   username: \"pritunl\"",
        "#================================================#"
    ]
}

ok: [infra_ec2_pritunl_vpn]
 __________________________________________________________
/ TASK [binbash_inc.ansible_role_vpn_pritunl_init_values : \
| Print out Pritunl default admin password setup key       |
\ variable]                                                /
 ----------------------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ok: [infra_ec2_pritunl_vpn] => {
    "msg": [
        "#================================================#",
        "# DEFAULT_USER   password: \"Z5hHTU6sJwGr\"",
        "#================================================#"
    ]
}
 ____________
< PLAY RECAP >
 ------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

if flag it's not set to `false` you'll not be printing this default values, consider that after you've
setup them this outputs will be an empty string.

---
## Binbash Leverage | DevOps Automation Code Library Integration

In order to get the full automated potential of the
[Binbash Leverage DevOps Automation Code Library](https://leverage.binbash.com.ar/how-it-works/code-library/code-library/)  
you should initialize all the necessary helper **Makefiles**.

#### How?
You must execute the `make init-makefiles` command  at the root context

```shell
╭─delivery at delivery-ops
╰─⠠⠵ make
Available Commands:
 - init-makefiles     initialize makefiles

```

### Why?
You'll get all the necessary commands to automatically operate this module via a dockerized approach,
example shown below

```shell
╭─delivery at delivery-ops
╰─⠠⠵ make
Available Commands:
 - ansible-galaxy-import-role  ## Run playbook tests w/ molecule using the local code
 - init                ## Install required ansible roles
 - test-ansible-lint   ## Ansible lint
 - test-molecule-galaxy  ## Run playbook tests w/ molecule pulling role from ansible galaxy
 - test-molecule-local  ## Run playbook tests w/ molecule using the local code
 - circleci-validate-config  ## Validate A CircleCI Config (https
 - changelog-init      ## git-chglog (https
 - changelog-major     ## git-chglog generation for major release
 - changelog-minor     ## git-chglog generation for minor release
 - changelog-patch     ## git-chglog generation for path release
 - release-major       ## releasing major (eg
 - release-major-with-changelog-circleci  ## make changelog-major && git add && git commit && make release-major
 - release-major-with-changelog  ## make changelog-major && git add && git commit && make release-major
 - release-minor       ## releasing minor (eg
 - release-minor-with-changelog-circleci  ## make changelog-minor && git add && git commit && make release-minor
 - release-minor-with-changelog  ## make changelog-minor && git add && git commit && make release-minor
 - release-patch       ## releasing patch (eg
 - release-patch-with-changelog-circleci  ## make changelog-patch && git add && git commit && make release-patch
 - release-patch-with-changelog  ## make changelog-patch && git add && git commit && make release-patch
 - init-makefiles      ## initialize makefiles
```

```shell
╭─delivery at delivery-ops
╰─⠠⠵ make test-molecule-local 
...
-------------------------------
TESTING MODULE ON: ubuntu1804
-------------------------------
Using default tag: latest
latest: Pulling from geerlingguy/docker-ubuntu1804-ansible
Digest: sha256:1b47cbb66e819170fd3afee98db55176bc13cd12fabdbcf0183aff2582dc0254
Status: Image is up to date for geerlingguy/docker-ubuntu1804-ansible:latest
docker.io/geerlingguy/docker-ubuntu1804-ansible:latest
## Starting testing stages ##
--> Test matrix
    
└── default
    ├── dependency
    ├── lint
    ├── cleanup
    ├── destroy
    ├── syntax
    ├── create
    ├── prepare
    ├── converge
    ├── idempotence
    ├── side_effect
    ├── verify
    ├── cleanup
    └── destroy
    
--> Scenario: 'default'
...
    
    PLAY [Destroy] *****************************************************************
    
    TASK [Destroy molecule instance(s)] ********************************************
    changed: [localhost] => (item=instance)
    
    TASK [Wait for instance(s) deletion to complete] *******************************
    FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
    changed: [localhost] => (item=None)
    changed: [localhost]
    
    TASK [Delete docker network(s)] ************************************************
    
    PLAY RECAP *********************************************************************
    localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
    
--> Pruning extra files from scenario ephemeral directory
-------------------------------
DONE

-------------------------------
TESTING MODULE ON: ubuntu1604
-------------------------------
```

## License

MIT / BSD

# Release Management
### CircleCi PR auto-release job

<div align="left">
  <img src="./%40doc/figures/circleci-logo.png" alt="circleci" width="130"/>
</div>

- [**pipeline-job**](https://app.circleci.com/pipelines/github/binbashar/ansible-role-vpn-pritunl-init-values) (**NOTE:** Will only run after merged PR)
- [**releases**](https://github.com/binbashar/ansible-role-vpn-pritunl-init-values/releases) 
- [**changelog**](https://github.com/binbashar/ansible-role-vpn-pritunl-init-values/blob/master/CHANGELOG.md) 
