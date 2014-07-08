#
# Cookbook Name:: yasm
# Library:: helpers
#
# Copyright 2012-2013, Escape Studios
#

module YASM
    module Helpers
        #Returns an array of package names that will install YASM on a node.
        #Package names returned are determined by the platform running this recipe.
        def yasm_packages
            value_for_platform(
                [ "ubuntu" ] => { "default" => [ "yasm" ] },
                "default" => [ "yasm" ]
            )
        end
    end
end

class Chef::Recipe
    include YASM::Helpers
end