xldeploy-puppet-sample
======================

This project shows how to integrate XL Deploy and Puppet using Vagrant images.

# Vagrant #

    vagrant plugin install vagrant-cachier
    
# Build the base-image #

These images allow to run the other images *without* internet connection.

## ubuntu-1304-puppet-java ##
Used by tomcat & jboss image

    vagrant up base-java
    vagrant package base-java
    vagrant box add ubuntu-1304-puppet-java package.box  


## ubuntu-1304-puppet-java ##
Used by the tomcat & jboss images

    vagrant up base-java
    vagrant package base-java
    vagrant box add ubuntu-1304-puppet-java package.box  

## ubuntu-1304-puppet-mysql ##
Used the mysql images 

    vagrant up base-mysql
    vagrant package base-mysql
    vagrant box add ubuntu-1304-puppet-mysql package.box  




