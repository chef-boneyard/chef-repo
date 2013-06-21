# What Is Chef?

Chef is a set of tools that lets you manage infrastructure consistently using Ruby code, instead of manually logging into boxes and running commands to do things. This helps ensure consistent server configurations.

## Minimum Viable Vocabulary

Here are some useful pieces of the Chef lexicon:

__cookbooks__ tell Chef how to install and configure something. For example a "mysql" cookbook would install and configure mysql.

Each cookbook has one or more __recipes__, which tell Chef how to do something. For example, your "mysql" cookbook might have "install" and "configure" recipes.

__roles__ are groups of recipes that work together to serve some purpose. For example, you might have a role called "web_server" that consists of "ruby", "nginx", and "unicorn" recipes.

__nodes__ are individual servers that you configure, each containing one or more roles.

__Chef Server__ is a queryable open source server that keeps track of how every node is configured. When you "deploy" a node, it queries Chef Server to figure out what it needs to do.

__users__ are humans, or in some cases machines, who have access to the Chef Server, usually for the purpose of managing new nodes.

# Getting Started

First, youll need a Chef Server account. [Login](https://chef.wistia.com) and generate a new key via the web site. Save your private key as `.chef/<your-username>.pem`.

Next, get `chef-validator.pem` from a team member who has it, and place it in your `.chef` directory.

Finally, you need to configure some environment variables so that knife.rb can retrieve the settings it needs without those settings being saved in our git repository.

* `WISTIA_CHEF_USERNAME` is the username of your account on Chef Server.
* `WISTIA_RACKSPACE_USERNAME` is the name of the Distillery's rackspace account.
* `WISTIA_RACKSPACE_API_KEY` is the api key of the Distillery's rackspace account.
* `WISTIA_AWS_ACCESS_KEY_ID` is your Wistia AWS access key.
* `WISTIA_AWS_SECRET_ACCESS_KEY` is your Wistia AWS secret access key.

The easiest way to do this is to add lines to your ~/.bashrc or ~/.zshrc like `export WISTIA_CHEF_USERNAME="robby"`. __If you do this, make sure you have [OS X FileVault](http://support.apple.com/kb/ht4790) turned on. Otherwise, losing your laptop will compromise several production security credentials.__

After modifying your `~/.[ba|z]shrc` you will need to start a new shell session or reload it by running `source ~/.[ba|z]shrc`.

# Deploying

## Options

When you bring up a new server, you have to choose an OS image and a hardware flavor to use.

To view available images, run:

    knife rackspace image list

EC2 Ubuntu images can be found [here](http://cloud-images.ubuntu.com/releases/13.04/).

To view available flavors, run:

    knife [ec2|rackspace] flavor list

It's advisable to use Ubuntu 12.04 whenever possible, as it is the most widely supported OS among Chef cookbooks.

## Creating New Boxes

### Blank Box

To deploy a blank box to Rackspace, run:

    knife rackspace server create -f <flavor> -I <image> -N <name of node> -r "role[blank_box]" -E [production|staging]

To deploy a blank box to EC2, run:

    knife ec2 server create -r "role[blank_box]" --region <region> -I <ubuntu-64 AMI> -G all-open -Z <availability zone> -N blank-box-<n> -f m1.small -x ubuntu -S <AWS keypair name> -E production -i <path to your AWS private key>

For example:

    knife ec2 server create -r "role[blank_box]" --region us-west-2 -I ami-1b6ffe2b -G all-open -Z us-west-2a -N blank-box-1 -f m1.small -x ubuntu -S robby-oregon -E production -i ~/workspace/wistia/keys/ec2-robby-oregon.pem 

## Deploying Boxes

To redeploy a box, log into it and run `sudo chef-client`, or use the `knife` tool to do it via:

    knife ssh "role:<role>" "sudo chef-client" -x ubuntu -a ec2.public_hostname -C 1 -i <path to a valid SSH key>

where `role` is the role you want to deploy and `C` is the concurrency of the deploy.

# Bootstrapping a Chef Server

[RG] In practice, Chef servers should be backed up and restored if they are lost so that node attributes are maintained and keys don't need to be regenerated; however if you ever need to rebuild your Chef server from scratch, here's what I did:

Spin up an Ubuntu 12.04 instance on whatever provider you like. I did this via the EC2 web interface using a newly generated keypair.

First, install chef-client via:

    sudo curl -L https://www.opscode.com/chef/install.sh | sudo bash

Next, download and install chef-server via:

    wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.8-1.ubuntu.12.04_amd64.deb
    sudo dpkg -i chef-server_11.0.8-1.ubuntu.12.04_amd64.deb 

Create `/etc/chef-server/chef-server.rb` and set:

    server_name = "chef.wistia.com"
    api_fqdn server_name
    
    nginx['url'] = "https://#{server_name}"
    nginx['server_name'] = server_name
    lb['fqdn'] = server_name
    bookshelf['vip'] = server_name

Configure the Chef Server with:

    sudo chef-server-ctl reconfigure

Test your setup with:

    sudo chef-server-ctl test

Finally, re-associate the 54.214.50.177 elastic IP address with the new box or update the `chef.wistia.com` DNS entry so that it points to the new box. After propagation, you should be able to get to your new chef-server at [https://chef.wistia.com](https://chef.wistia.com). If you use the elastic IP address method, your box will be available at that location immediately.

When you're done, be sure to put your public key on the box in `~.ssh/authorized_keys` so that if you lose the credentials you used to bring up the box, you can still get into it.
