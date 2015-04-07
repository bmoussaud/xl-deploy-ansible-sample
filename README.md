# XLDeploy Ansible Demo #

This project shows how to integrate [XL Deploy](https://xebialabs.com/products/xl-deploy/) and [Ansible](http://www.ansible.com) using Vagrant images.


## Web Machines ##

3 instances (tomcat1, tomcat2, tomcat3) including tomcat servers can be created by Ansible and automaticaly defined in XLD and added
into an environment

Exemple:

`$vagrant up tomcat2` 

```
.....
==> tomcat2: Running provisioner: ansible...
ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false PYTHONUNBUFFERED=1 ansible-playbook --private-key=/Users/bmoussaud/.vagrant.d/insecure_private_key --user=vagrant --limit='tomcat2' --inventory-file=/Users/bmoussaud/Workspace/xebialabs/demos/4.5.0/xl-deploy-ansible-sample/.vagrant/provisioners/ansible/inventory -v provisioning/playbook.yml

PLAY [web] ********************************************************************

GATHERING FACTS ***************************************************************
ok: [tomcat2]

TASK: [xldeploy | XLD Infrastructure/ANSIBLE] *********************************
ok: [tomcat2] => {"changed": false}

TASK: [xldeploy | XLD Environments/ANSIBLE] ***********************************
ok: [tomcat2] => {"changed": false}

TASK: [xldeploy | XLD Define Host] ********************************************
changed: [tomcat2] => {"changed": true, "msg": "Create Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm overthere.SshHost {u'username': u'vagrant', u'address': u'tomcat2.xebialabs.demo', u'connectionType': u'INTERACTIVE_SUDO', u'stagingDirectoryPath': u'/tmp', u'sudoUsername': u'root', u'password': '********', u'os': u'UNIX'}"}

TASK: [xldeploy | XLD Define tomcat server] ***********************************
changed: [tomcat2] => {"changed": true, "msg": "Create Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/tomcat tomcat.Server {u'stopCommand': u'/etc/init.d/tomcat7 stop', u'home': u'/var/lib/tomcat7', u'startCommand': u'/etc/init.d/tomcat7 start', u'stopWaitTime': 0, u'startWaitTime': 10}"}

TASK: [xldeploy | XLD Define tomcat virtual host] *****************************
changed: [tomcat2] => {"changed": true, "msg": "Create Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/tomcat/tomcat.vh tomcat.VirtualHost {}"}

TASK: [xldeploy | XLD Define the smoke test runner] ***************************
changed: [tomcat2] => {"changed": true, "msg": "Create Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/test-runner-tomcat2 smoketest.Runner {}"}

TASK: [xldeploy | XLD Define the dictionary for the node] *********************
changed: [tomcat2] => {"changed": true, "msg": "Create Environments/ANSIBLE/tomcat2.dict udm.Dictionary {u'entries': {u'log.RootLevel': u'ERROR', u'TITLE': u'ANSIBLE', u'tomcat.port': u'8080', u'tomcat.DataSource.url': u'jdbc:mysql://localhost/petclinic', u'tomcat.DataSource.username': u'scott', u'tomcat.DataSource.password': u'tiger', u'log.FilePath': u'/tmp/null', u'tests2.ExecutedHttpRequestTest.url': u'http://localhost:8080/petclinic/index.jsp', u'tomcat.DataSource.driverClassName': u'com.mysql.jdbc.Driver', u'tomcat.DataSource.context': u'petclinic'}}"}

TASK: [xldeploy | XLD Define the test environment] ****************************
changed: [tomcat2] => {"changed": true, "msg": "[ADD] Update Environments/ANSIBLE/ansible-tomcat-test udm.Environment {u'dictionaries': [u'Environments/ANSIBLE/tomcat2.dict'], u'members': [u'Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/tomcat/tomcat.vh', u'Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/tomcat', u'Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm', u'Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/test-runner-tomcat2']}, previous Environments/ANSIBLE/ansible-tomcat-test udm.Environment {'triggers': [], 'requiresChangeTicketNumber': 'false', 'dictionaries': ['Environments/ANSIBLE/tomcat1.dict'], 'requiresReleaseNotes': 'false', 'requiresPerformanceTested': 'false', 'members': ['Infrastructure/ANSIBLE/tomcat1.xebialabs.demo.vm/tomcat/tomcat.vh', 'Infrastructure/ANSIBLE/tomcat1.xebialabs.demo.vm', 'Infrastructure/ANSIBLE/tomcat1.xebialabs.demo.vm/tomcat', 'Infrastructure/ANSIBLE/dbprod.xebialabs.demo.vm/mysql', 'Infrastructure/ANSIBLE/tomcat1.xebialabs.demo.vm/test-runner-tomcat1'], 'backupDirectory': '/tmp'}"}

PLAY [db] *********************************************************************
skipping: no hosts matched

PLAY RECAP ********************************************************************
tomcat2                    : ok=9    changed=6    unreachable=0    failed=0
```

## DB Machines ##

2 instances (dbprod, dbqa) including MySql servers can be created by Ansible and automaticaly defined in XLD and added
into an environment

`$vagrant up dbqa` 

```
....
TASK: [xldeploydb | XLD Infrastructure/ANSIBLE] *******************************
ok: [dbqa] => {"changed": false}

TASK: [xldeploydb | XLD Environments/ANSIBLE] *********************************
ok: [dbqa] => {"changed": false}

TASK: [xldeploydb | XLD Define Host] ******************************************
changed: [dbqa] => {"changed": true, "msg": "Create Infrastructure/ANSIBLE/dbqa.xebialabs.demo.vm overthere.SshHost {u'username': u'vagrant', u'address': u'dbqa.xebialabs.demo', u'connectionType': u'INTERACTIVE_SUDO', u'stagingDirectoryPath': u'/tmp', u'sudoUsername': u'root', u'password': '********', u'os': u'UNIX'}"}

TASK: [xldeploydb | XLD Define Mysql] *****************************************
changed: [dbqa] => {"changed": true, "msg": "Create Infrastructure/ANSIBLE/dbqa.xebialabs.demo.vm/mysql sql.MySqlClient {u'username': u'root', u'password': '********', u'databaseName': u'petdb'}"}

TASK: [xldeploydb | XLD add the db to test environment] ***********************
changed: [dbqa] => {"changed": true, "msg": "[ADD] Update Environments/ANSIBLE/ansible-tomcat-test udm.Environment {u'members': [u'Infrastructure/ANSIBLE/dbqa.xebialabs.demo.vm/mysql']}, previous Environments/ANSIBLE/ansible-tomcat-test udm.Environment {'triggers': [], 'requiresChangeTicketNumber': 'false', 'dictionaries': ['Environments/ANSIBLE/tomcat1.dict', 'Environments/ANSIBLE/tomcat2.dict'], 'requiresReleaseNotes': 'false', 'requiresPerformanceTested': 'false', 'members': ['Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/tomcat/tomcat.vh', 'Infrastructure/ANSIBLE/tomcat1.xebialabs.demo.vm/tomcat/tomcat.vh', 'Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/tomcat', 'Infrastructure/ANSIBLE/tomcat1.xebialabs.demo.vm', 'Infrastructure/ANSIBLE/tomcat1.xebialabs.demo.vm/tomcat', 'Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm', 'Infrastructure/ANSIBLE/dbprod.xebialabs.demo.vm/mysql', 'Infrastructure/ANSIBLE/tomcat1.xebialabs.demo.vm/test-runner-tomcat1', 'Infrastructure/ANSIBLE/tomcat2.xebialabs.demo.vm/test-runner-tomcat2'], 'backupDirectory': '/tmp'}"}

PLAY RECAP ********************************************************************
dbqa                       : ok=7    changed=4    unreachable=0    failed=0

``
