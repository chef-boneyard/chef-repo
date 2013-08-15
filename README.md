# What Is Chef?

Chef is a set of tools that lets you manage infrastructure consistently using Ruby code, instead of manually logging into boxes and running commands to do things. This helps ensure consistent server configurations.

## Minimum Viable Vocabulary

Here are some useful pieces of the Chef lexicon:

__cookbooks__ tell Chef how to install and configure something. For example a "mysql" cookbook would install and configure mysql.

Each cookbook has one or more __recipes__, which tell Chef how to do something. For example, your "mysql" cookbook might have "install" and "configure" recipes.

__roles__ are groups of recipes that work together to serve some purpose. For example, you might have a role called "web_server" that consists of "ruby", "nginx", and "unicorn" recipes.

__nodes__ are individual servers that you configure, each containing or more roles.

__Chef Server__ is a queryable open source server that keeps track of how every node is configured. When you "deploy" a node, it queries Chef Server to figure out what it needs to do.

__users__ are humans, or in some cases machines, who have access to the Chef Server, usually for the purpose of managing new nodes.

# Getting Started

First, youll need a Chef Server account. [Login](https://chef.wistia.com) and generate a new key via the web site. Save your private key as `.chef/<your-username>.pem`.

Next, get `chef-validator.pem` and `encrypted_data_bag_secret` from a team member who has them, and place it in your `.chef` directory.

Now you need to configure some environment variables so that knife.rb can retrieve the settings it needs without those settings being saved in our git repository.

* `WISTIA_CHEF_USERNAME` is the username of your account on Chef Server.
* `WISTIA_RACKSPACE_USERNAME` is the name of the Distillery's rackspace account.
* `WISTIA_RACKSPACE_API_KEY` is the api key of the Distillery's rackspace account.
* `WISTIA_AWS_ACCESS_KEY_ID` is your Wistia AWS access key.
* `WISTIA_AWS_SECRET_ACCESS_KEY` is your Wistia AWS secret access key.

The easiest way to do this is to add lines to your `~/.bash_profile` or `~/.zsh_profile` like `export WISTIA_CHEF_USERNAME="robby"`. __If you do this, make sure you have [OS X FileVault](http://support.apple.com/kb/ht4790) turned on. Otherwise, losing your laptop will compromise several production security credentials.__

After modifying your `~/.[ba|z]sh_profile` you will need to start a new shell session or reload it by running `source ~/.[ba|z]sh_profile`.

In order to work around our chef server not having an SSL certificate, create a `~/.berkshelf/config.json` as follows:

    {
      "ssl": {
        "verify": false
      }
    }

This bypasses SSL errors caused by the fact that our Chef SSL certificate is not signed by a CA.

Finally, run `bundle install`.

## Getting Access to Old Servers & New Ones

A good first exercise in getting acquainted with Chef is to get your SSH key on all of the Wistia servers.

To do this, first create a data bag item in the `users` data bag with your name. You can do this at the command line with:

    knife data bag create users robby-grossman

The final contents would be:

    {
      "id": "robby-grossman",
      "ssh_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwwMlNoPlvA34uaHPoiCiq64zGgPNtsOX7sLW2fLzmd86e9aIPy9p5nZQ6YfcSpZ7TW01v88s24WmDzepp/Fiz7xGpUT5zuUFfSVry4OEPYmy59HFZ+bFUYGP1gP7hZH2eWL/uS+e5KoTXQMB8rSXfWc3TYeOgQOdmykH/UsUh5BaBamLnY9jRZtJYud4+TQ2muEoAPs/jRPdwDqHAIDjIeuF/hmlnTdC2S1pS1o7Amf/L8UfuqYkQWljbGReDifdMk7l5ql/nQ2mKYH7Knd7w703kStXQ/IsT6VKPrzAdhnMZ7QmMsn5Iu6c6GsBmE7m7sKT4HBS6uqew3S1OwaXFw== robby@Starks.local"
    }

When you create a data bag, it gets uploaded to and retained by the Chef server. These data bags can be queried by various Chef recipes.

Next, open `roles/wistia-base.rb`. Every Wistia server receives this role. You'll see a set of attributes for it like:

    default_attributes(
      'ssh_keys' => {
        'ubuntu' => ['max-schnur', 'robby-grossman']
      }
    )

Add your user id to the array of "ubuntu" users, commit your changes to git, and run `rake roles`.'

Now get someone on the team (whose key is already in the .authorized_users) to deploy all the boxes. Your public key will be added to them and you will be able to perform subsequent deploys.

# Deploying

## Options

When you bring up a new server, you have to choose an OS image and a hardware flavor to use.

To view available images, run:

    knife rackspace image list

EC2 Ubuntu images can be found [here](http://cloud-images.ubuntu.com/releases/13.04/).

To view available flavors, run:

    knife [ec2|rackspace] flavor list

It's advisable to use Ubuntu 12.04 whenever possible, as it is the most widely supported OS among Chef cookbooks.

## Listing Boxes

To list all EC2 boxes in a given zone, use:

    knife ec2 server list --region <region>
    
e.g. for us-west-2, run:

    knife ec2 server list --region us-west-2
    
## Deleting Boxes

List the boxes to get the ID of the box you want to delete, then run

    knife ec2 server delete <EC2 ID> --region <region>
    
After deleting the server, be sure to delete its node and client via:

    knife node delete <nodename>
    knife client delete <nodename>

## Creating New Boxes

### Blank Box

To deploy a blank box to Rackspace, run:

    knife rackspace server create -f <flavor> -I <image> -N <name of node> -r "role[blank-box], role[rackspace-cloud-base]" -E [production|staging]

To deploy a blank box to EC2, run:

    knife ec2 server create -r "role[blank-box]" --region <region> -I <ubuntu-64 AMI> -G all-open -Z <availability zone> -N blank-box-<n> -f m1.small -x ubuntu -S <AWS keypair name> -E production -i <path to your AWS private key>

For example:

    knife ec2 server create -r "role[tickr]" --region us-west-2 -I ami-1b6ffe2b -G all-open -Z us-west-2a -N blank-box-1 -f m1.small -x ubuntu -S robby-oregon -E production -i ~/workspace/wistia/keys/ec2-robby-oregon.pem

If you want a hard drive to be saved when a box is lost, you can also apply the `--ebs-no-delete-on-term` flag.

### Tickr Box

For US-West Oregon, use:

    knife ec2 server create -r "role[tickr]" --region us-west-2 -I ami-1b6ffe2b -G all-open -Z us-west-2a -N tickr-1 -f m1.small -x ubuntu -S robby-oregon -E production -i ~/workspace/wistia/keys/ec2-robby-oregon.pem --ebs-no-delete-on-term

For US-East North Virginia, use:

    knife ec2 server create -r "role[tickr]" --region us-east-1 -I ami-21d9a948 -G all-open -Z us-east-1a -N tickr-2 -f m1.small -x ubuntu -S robby-north-virginia -E production -i ~/workspace/wistia/keys/ec2-robby-north-virginia.pem --ebs-no-delete-on-term

For Rackspace, use:

    knife rackspace server create -f 2 -I 23b564c9-c3e6-49f9-bc68-86c7a9ab5018 -N tickr-3 -r "role[tickr], role[rackspace-cloud-base]" -E production

Rackspace will bomb because it changes IP addresses shortly after the box is brought up (because hey, it's Rackspace, why not).
Work around this by logging into chef server and deleting whatever node and client were created for that box. Log into
Rackspace to get the new box IP address after the box has come back up. Note the password provided by `knife rackspace create`.
Bootstrap the box via:

    knife bootstrap <IP Address> -P <password> -N tickr-3 -r "role[tickr], role[rackspace-cloud-base]" -E production -x root
    
### Collector Box

    knife ec2 server create --region us-west-2 -I ami-1b6ffe2b -G all-open -Z us-west-2a -N distillery-collector-new -f m1.small -x ubuntu -S robby-oregon -i ~/workspace/wistia/keys/ec2-robby-oregon.pem
    
    knife bootstrap <public fqdn of new box> -r "role[rackspace-cloud-base], role[distillery-collector]" -N distillery-collector-new -E production -x ubuntu --sudo -i ~/workspace/wistia/keys/ec2-robby-oregon.pem --secret-file ./.chef/encrypted_data_bag_secret

### Adding Chef to an App Server

    knife bootstrap <public fqdn> -r "role[wistia-app]" -N app-<num> -E production -x wistia --sudo --secret-file ./.chef/encrypted_data_bag_secret

### Boxes that Require SSL Keys

Due to a bug ([fixed](https://github.com/opscode/knife-ec2/pull/139) but not yet merged) in knife-ec2, it is not possible to fully bootstrap nodes that require encrypted data bags with a single command.

To deploy a box that uses the wistia-ssl role, use something like the following two commands:

    knife ec2 server create --region us-west-2 -I ami-1b6ffe2b -G all-open -Z us-west-2a -N wistia-ssl-8 m1.small -x ubuntu -S robby-oregon -E production -i ~/workspace/wistia/keys/ec2-robby-oregon.pem

    knife bootstrap <public fqdn of new box> -r "role[wistia-ssl]" -N wistia-ssl-8 -E production -x ubuntu --sudo -i ~/workspace/wistia/keys/ec2-robby-oregon.pem --secret-file ./.chef/encrypted_data_bag_secret

where `wistia-ssl-8` is the name of your box and `wistia-ssl` is the role of the box that you want to deploy. The `knife ec2` command will create the box, and the `knife bootsrap command` will bootstrap it using the data bag secret key.

## Deploying Boxes

To redeploy a box, log into it and run `sudo chef-client`, or use the `knife` tool to do it via:

    knife ssh "role:<role>" "sudo chef-client" -x ubuntu -a public_ip -C 1
    
where `role` is the role you want to deploy and `C` is the server concurrency of the deploy.

## Running Commands on All Boxes

knife-ssh also provides a way to run a single command on every box. This is useful for replicating small changes across all application servers before automating those changes with chef. Use:

    knife ssh "role:<role>" interactive -x ubuntu -a public_ip -C 1
    
where `role` is the role you want to deploy.

This provides an interactive console on which you can run shell commands.

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

# General Tips & Tricks

## Transforming Nodes

The `knife exec` tool, combined with the `transform` operation, gives us a way to dynamically change node attributes based on other node attributes. For example, let's say when we launched our threshers, we forgot to add rackconnect support for them. We could run:

    knife exec -E 'nodes.transform("role:distillery-thresher") {|n| n.run_list << "role[rackspace-cloud-base]"; n.save }'

to fix this.

Of course, we should be safe by running this command, first:

    knife exec -E 'nodes.transform("role:distillery-thresher") {|n| puts n.run_list << "role[rackspace-cloud-base]" }'

# Provider-Specific Tips & Tricks

## EC2

### Disabling DeleteOnTermination

If you forget to set DeleteOnTermination to false when creating a box, you can do it afterwords by running:

    ec2-modify-instance-attribute --block-device-mapping /dev/sda1=:false <instance ID> -O <aws key> -W <aws secret> --region region
  
## Rackspace

### Support for RackConnect

Any box in the rackspace cloud must include the rackspace-cloud-base role to ensure that rackconnect is fully functional.
