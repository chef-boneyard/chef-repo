# minitest-handler cookbook

[![Build Status](https://secure.travis-ci.org/btm/minitest-handler-cookbook.png?branch=master)](http://travis-ci.org/btm/minitest-handler-cookbook)

License: Apache 2.0 <br />
Copyright: 2012 Opscode, Inc.<br/>
Author: Bryan McLellan <btm@loftninjas.org><br/>
Author: Bryan W. Berry <bryan.berry@gmail.com><br/>


## Description

This cookbook utilizes the minitest-chef-handler project to facilitate
cookbook testing. By default, minitest-handler will collect all the
tests in your cookbook_path and run them.

minitest-chef-handler project: https://github.com/calavera/minitest-chef-handler<br/>
stable minitest-handler cookbook: http://community.opscode.com/cookbooks/minitest-handler<br/>
minitest-handler cookbook development: https://github.com/btm/minitest-handler-cookbook<br/>

**Note**: Version 0.1.8 deprecated use of
``files/default/tests/minitest/*_test.rb`` and the location of support
files. Test files should now be located in
``files/default/test/*_test.rb``

**Note**: Version 0.1.0 added a change that breaks backward compatibility. The minitest-handler now only loads<br/>
test files named "<recipe-name>_test.rb" rather than all test files in the path `files/default/test/*_test.rb`

If you have any helper libraries, they should match `files/default/test/*helper*.rb`

## Attributes
* `node[:minitest][:gem_version]` - The version of the [minitest](http://rubygems.org/gems/minitest)
  gem to install and use.
  * Default: 3.0.1
* `node[:minitest][:chef_handler_gem_version]` - The version of the [minitest-chef-handler](http://rubygems.org/gems/minitest-chef-handler)
  gem to install and use.
  * Default: 1.0.3
* `node[:minitest][:ci_reporter_gem_version]` - The version of the [ci_reporter](http://rubygems.org/gems/ci_reporter)
  gem to install and use.
  * Default: 1.9.2
* `node[:minitest][:path]` - Location to store and find test files.
  * Default: `/var/chef/minitest`
* `node[:minitest][:recipes]` - The names of all recipes included during the
  chef run, whether by insertion to the run_list, inclusion through a role, or
  added with `include_recipe`. If you only want tests for select recipes to run,
  override this value with the names of the recipes that you want tested.
  * Default: []
* `node[:minitest][:filter]` - Filter test names on a pattern (regex)
  * Default: `nil`
  * Example: `/apache2/` could be used to *only* run tests for recipes
    starting with *apache2*
* `node[:minitest][:seed]` - Set random seed
  * Default: `nil`
* `node[:minitest][:ci_reports]` - Path to write out the result of each
  test in a JUnit-compatible XML file, parseable by many CI platforms
  * Default: `nil`
* `node[:minitest][:tests]` - Test files to run.
  * Default to `**/*_test.rb`
* `node[:minitest][:verbose]` - Display verbose output
  * Default: true

## Usage
* Add ``recipe[minitest-handler]`` somewhere on your run_list, preferably last
* Place tests in ``files/default/test/`` with the name **your-recipe-name\_test.rb**
  (default recipe is named **default_test.rb**)
* Put any helper functions you have in ``files/default/test/spec_helper.rb`` but
  minitest-handler will ensure that you have access to any file that
  matches the glob ``files/test/*helper.rb``

[Minitest](https://github.com/seattlerb/minitest)

## Examples
### Traditional minitest

    class TestApache2 < MiniTest::Chef::TestCase
      def test_that_the_package_installed
        case node[:platform]
        when "ubuntu","debian"
          assert system('apt-cache policy apache2 | grep Installed | grep -v none')
        end
      end

      def test_that_the_service_is_running
        assert system('/etc/init.d/apache2 status')
      end

      def test_that_the_service_is_enabled
        assert File.exists?(Dir.glob("/etc/rc5.d/S*apache2").first)
      end
    end



### Using minitest/spec

    require 'minitest/spec'

    describe_recipe 'ark::test' do

      it "installed the unzip package" do
        package("unzip").must_be_installed
      end

      it "dumps the correct files into place with correct owner and group" do
        file("/usr/local/foo_dump/foo1.txt").must_have(:owner, "foobarbaz").and(:group, "foobarbaz")
      end

     end

For more detailed examples, see [here](https://github.com/calavera/minitest-chef-handler/blob/v0.4.0/examples/spec_examples/files/default/tests/minitest/example_test.rb)


## Testing this cookbook

This cookbook currently uses [test-kitchen](https://github.com/opscode/test-kitchen)
along with the [kitchen-vagrant](https://github.com/opscode/kitchen-vagrant).

All test are currently written using [BATS](https://github.com/sstephenson/bats),
which is essentially bash. Using BATS was done so that minitest-handler nor
minitest-chef-handler were used to test itself. For more examples of bats than
are in this cookbook, see the [chef-rvm](https://github.com/fnichol/chef-rvm),
[chef-ruby_build](https://github.com/fnichol/chef-ruby_build), and
[chef-rbenv](https://github.com/fnichol/chef-rbenv) cookbooks.

**NOTE** A known limitation of using BATS is that the cookbook is not currently
tested on Windows machines. See https://github.com/btm/minitest-handler-cookbook/issues/45
for more of the background on this.

## Releasing
This cookbook uses an 'even number' release strategy. The version number in master
will always be an odd number indicating development, and an even number will
be used when an official build is released.

Come release time here is the checklist:
* Ensure the `metadata.rb` reflects the proper *even* numbered release
* Ensure there is a *dated* change log entry in `CHANGELOG.md`
* Commit all the changes
* Use stove to release (`bundle exec stove`)
* Bump the version in metadata.rb to the next *patch level* odd number

## Contributors
* David Petzel <davidpetzel@gmail.com>
* Reijo Pitkanen <reijop@gmail.com>
* Jean Mertz <jean@mertz.fm>
