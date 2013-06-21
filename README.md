# What Is Chef?

Chef is a set of tools that lets you manage infrastructure consistently using Ruby code, instead of manually logging into boxes and running commands to do things. This helps ensure consistent server configurations.

## Minimum Viable Vocabulary

Here are some useful pieces of the Chef lexicon:

__recipes__ tell Chef how to do something. For example, you would write a "mysql" recipe to tell Chef how to install and configure mysql.

__roles__ are groups of recipes that work together to serve some purpose. For example, you might have a role called "web_server" that consists of "ruby", "nginx", and "unicorn" recipes.

__nodes__ are individual servers that you configure, each containing one or more roles.

__Chef Server__ is a queryable open source server that keeps track of how every node is configured. When you "deploy" a node, it queries Chef Server to figure out what it needs to do.

__users__ are humans, or in some cases machines, who have access to the Chef Server, usually for the purpose of managing new nodes.

# Getting Started

First, youll need a Chef Server account. [Login](https://chef.wistia.com) and generate a new key via the web site. Save your private key as `.chef/<your-username>.pem`.

Next, get `chef-validator.pem` from a team member who has it, and place it in your `.chef` directory.

Next, configure Berkshelf, which manages Chef recipes, not to verify SSL, since we haven't set up our Chef server with our SSL certificate yet:

`~/.berkshelf/config.json` should look like:

    {
      "ssl": {
        "verify": false
      }
    }

Finally, you need to configure some environment variables so that knife.rb can retrieve the settings it needs without those settings being saved in our git repository.

* `WISTIA_CHEF_USERNAME` is the username of your account on Chef Server.
* `WISTIA_RACKSPACE_USERNAME` is the name of the Distillery's rackspace account.
* `WISTIA_RACKSPACE_API_KEY` is the api key of the Distillery's rackspace account.

The easiest way to do this is to add lines to your ~/.bashrc or ~/.zshrc like `export WISTIA_CHEF_USERNAME="robby"`. __If you do this, make sure you have [OS X FileVault](http://support.apple.com/kb/ht4790) turned on. Otherwise, losing your laptop will compromise several production security credentials.__

After modifying your `~/.[ba|z]shrc` you will need to start a new shell session or reload it by running `source ~/.[ba|z]shrc`.
