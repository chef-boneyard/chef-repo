This directory contains directories of the various data bags you create for your infrastructure. Each subdirectory corresponds to a data bag on the Chef Server, and contains JSON files of the items that go in the bag.

First, create a directory for the data bag.

    mkdir data_bags/BAG

Then create the JSON files for items that will go into that bag.

    $EDITOR data_bags/BAG/ITEM.json

The JSON for the ITEM must contain a key named "id" with a value equal to "ITEM". For example,

    {
      "id": "foo"
    }

Next, create the data bag on the Chef Server.

    knife data bag create BAG

Then upload the items in the data bag's directory to the Chef Server.

    knife data bag from file BAG ITEM.json
