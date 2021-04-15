apiVersion: launchpad.mirantis.com/mke/v1.3
kind: ${kind}
metadata:
  name: launchpad-mke
spec:
  hosts:
%{ for manager in managers ~}
  - role: manager
    # imageDir: ./ucp_images
    hooks:
      apply:
        before:
          - ls -al > test.txt
        after:
          - docker image prune --force
          - cat test.txt
    ssh:
      address : ${manager}
      user    : ${os_ssh_username}
      port    : 22
      keyPath : ${keyPath}
    privateInterface : ${privateInterface}
    # environment:
    #   http_proxy: http://example.com
    #   NO_PROXY: 10.0.0.*
    mcrConfig:
      debug: false
      log-opts:
        max-size: 10m
        max-file: "3"
%{ endfor ~}
%{ for msr in msrs ~}
  - role             : msr
    # imageDir: ./ucp_dtr_images
    hooks:
      apply:
        before:
          - ls -al > test.txt
        after:
          - docker image prune --force
          - cat test.txt
    ssh:
      address : ${msr}
      user    : ${os_ssh_username}
      port    : 22
      keyPath : ${keyPath}
    privateInterface : ${privateInterface}
    # environment:
    #   http_proxy: http://example.com
    #   NO_PROXY: 10.0.0.*
    mcrConfig:
      debug: false
      log-opts:
        max-size: 10m
        max-file: "3"
%{ endfor ~}
%{ for worker in workers ~}
  - role             : worker
    # imageDir: ./ucp_images
    hooks:
      apply:
        before:
          - ls -al > test.txt
        after:
          - docker image prune --force
          - cat test.txt
    ssh:
      address : ${worker}
      user    : ${os_ssh_username}
      port    : 22
      keyPath : ${keyPath}
    privateInterface : ${privateInterface}
    # environment:
    #   http_proxy: http://example.com
    #   NO_PROXY: 10.0.0.*
    mcrConfig:
      debug: false
      log-opts:
        max-size: 10m
        max-file: "3"
%{ endfor ~}
%{ for windows_worker in windows_workers ~}
  - role             : worker
    # imageDir: ./ucp_win_images
    winRM:
      address  : ${windows_worker}
      user     : Administrator
      password : ${windows_administrator_password}
      port     : 5986
      useHTTPS : true
      insecure : true
      useNTLM  : false
      # caCertPath: ~/.certs/cacert.pem
      # certPath: ~/.certs/cert.pem
      # keyPath: ~/.certs/key.pem
    privateInterface : Ethernet 3
%{ endfor ~}
  mke:
    version         : ${mke_version}
    adminUsername   : ${admin_username}
    adminPassword   : ${admin_password}
    installFlags    :
    # - --default-node-orchestrator=kubernetes
    - --san=${masters_lb_dns_name}
    upgradeFlags    :
    - --force-minimums
    - --force-recent-backup
    licenseFilePath : ${license_file_path}
    # configFile: ./mke-config.toml
    # configData: |-
    #   [scheduling_configuration]
    #     default_node_orchestrator = "kubernetes"
    # cloud:
    #   provider: azure
    #   configFile: ~/cloud-provider.conf
    #   configData: |-
    #     [Global]
    #     region=RegionOne
    # swarmInstallFlags
    # swarmUpdateCommands
  msr:
    version      : ${msr_version}
    installFlags :
    - --ucp-insecure-tls
    - --dtr-external-url ${msrs_lb_dns_name}
    upgradeFlags: []
    # replicaIDs: sequential | random
  mcr:
    version : ${mcr_version}
    channel: stable
    repoURL: https://repos.mirantis.com
    installURLLinux: https://get.mirantis.com/
    installURLWindows: https://get.mirantis.com/install.ps1
  cluster:
    prune: true
