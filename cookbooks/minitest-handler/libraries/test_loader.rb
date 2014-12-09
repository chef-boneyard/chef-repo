
module MinitestHandler
  # Helper methods to help extract code out of recipes
  module CookbookHelper
    # Load necessary tests onto the filesystem
    def load_tests
      require 'fileutils'

      seen_cookbooks = []
      seen_recipes.each do |recipe|
        # recipes is actually a list of cookbooks and recipes with :: as a
        # delimiter
        if recipe.include?('::')
          cookbook_name, recipe_name = recipe.split('::')
        else
          cookbook_name = recipe
          recipe_name = 'default'
        end
        seen_cookbooks << cookbook_name unless seen_cookbooks.include?(cookbook_name)

        unless matches_filter?(recipe_name, cookbook_name)
          ::Chef::Log.debug('Not copying test files for recipe' \
            " #{recipe_name} in cookbook #{cookbook_name} as it" \
            " does not match filter #{node[:minitest][:filter]}")
          next
        end

        # create the parent directory
        dir = Chef::Resource::Directory.new(
          "#{node[:minitest][:path]}/#{cookbook_name}", run_context)
        dir.recursive(true)
        dir.run_action(:create)

        support_files(cookbook_name).each do |support_file|
          copy_file(cookbook_name, support_file)
        end
        test_files(cookbook_name, recipe_name).each do |test_file|
          copy_file(cookbook_name, test_file)
        end
      end

      # Try to help the user out and let them know if they have
      # what appears to be a test file in a directory we don't support
      seen_cookbooks.each do |cookbook_name|
        warn_tests_in_wrong_dir(cookbook_name)
      end
    end

    def register_handler
      options = {
        path: "#{node[:minitest][:path]}/#{node[:minitest][:tests]}",
        verbose: node[:minitest][:verbose] }
      # The following options can be omited

      options[:filter] = node[:minitest][:filter] if node[:minitest].include? 'filter'
      options[:seed] = node[:minitest][:seed] if node[:minitest].include? 'seed'
      options[:ci_reports] = node[:minitest][:ci_reports] if node[:minitest].include? 'ci_reports'

      handler = MiniTest::Chef::Handler.new(options)

      Chef::Log.info('Enabling minitest-chef-handler as a report handler')
      Chef::Config.send('report_handlers').delete_if do |v|
        v.class.to_s.include? MiniTest::Chef::Handler.to_s
      end
      Chef::Config.send('report_handlers') << handler
    end

    private

    # Compare a cookbook and recipe combination against
    # node[:minitest][:filter]
    #
    # @returns [Boolean]
    def matches_filter?(recipe_name, cookbook_name)
      full_name = "#{cookbook_name}::#{recipe_name}"
      # If no filter is set, it will match all
      filter = node[:minitest][:filter] || '/./'
      if filter.class == String
        # We don't know what form the user might give
        # us the pattern in. They may including leading and
        # trailing slashes, or they might just give us a
        # string. Try to handle both variations
        if filter =~ %r{/(.*)/}
          filter = Regexp.new(Regexp.last_match[1])
        else
          filter = Regexp.new(filter)
        end
      end
      return true if full_name =~ filter
      false
    end

    # Collect a list of recipes that we care about
    #
    # @return [Array] of recipes that should be tested
    def seen_recipes
      recipe_list = []
      if node[:minitest][:recipes].empty?
        if Chef::VERSION < '11.0'
          seen_recipes = node.run_state[:seen_recipes]
          recipe_list = seen_recipes.keys.each { |i| i }
        else
          recipe_list = run_context.loaded_recipes
        end
        if recipe_list.empty? && Chef::Config[:solo]
          # If you have roles listed in your run list they are NOT expanded
          recipe_list = node.run_list.map { |item| item.name if item.type == :recipe }
        end
      else
        recipe_list = node[:minitest][:recipes].dup
      end
      recipe_list
    end

    # Given a test or support file in the form of a relative path
    # copy the files into the test directory
    #
    # @returns [Nil]
    def copy_file(cookbook_name, file_path)
      base_path = ::File.join(node[:minitest][:path], cookbook_name)
      full_path = ::File.join(base_path, file_path)

      # Historically there has not been a one-to-one parity between
      # the path in the cookbook and the path on the file system.
      # In order to preserve the legacy placemnts the following
      # gsubs will construct the path in which to place the files
      # in the minitest folder
      full_path.gsub!('/test/', '/')
      full_path.gsub!('/tests/minitest/', '/')
      dir_path = ::File.dirname(full_path)

      # Make sure the enclosing directory actually exists
      dir = ::Chef::Resource::Directory.new(dir_path, run_context)
      dir.recursive(true)
      dir.run_action(:create)

      test_file = ::Chef::Resource::CookbookFile.new(full_path, run_context)
      test_file.cookbook(cookbook_name)
      test_file.source(file_path)
      test_file.run_action(:create)

      nil
    end

    # Check for tests in wrong directorys
    def warn_tests_in_wrong_dir(cookbook_name)
      # As of version 1.2.0 a fix was implemented that would no longer copy files
      # that were in the wrong directory. Its possible this change might affect
      # users so let them know
      wrong_dir_files = []
      cookbook_file_names(cookbook_name).each do |cb_file|
        wrong_dir_files << cb_file if cb_file =~ /^[\w\d]+_test\.rb$/
      end
      wrong_dir_files.each do |wdf|
        # Cleanup for readibility only. When displaying the message
        # to the user ignore the actual disk location and just
        # show them what cookbook it is.
        Array(Chef::Config[:cookbook_path]).each do |cookbook_path|
          wdf.gsub!("#{cookbook_path}/#{cookbook_name}/", '')
        end
        ::Chef::Log.warn("A test file was detected at #{wdf} in the files directory" \
          " of the #{cookbook_name} cookbook. As of version 1.2.0 of the" \
          ' minitest-handler-cookbook storing test files in this location' \
          ' is not supported. If you would like these tests executed' \
          ' you should move them into files/default/test/')
      end
    end

    # Set of supporting files for a cookbook. This is generally
    # helper modules, however this might also include supporting
    # files of any type. IE if a user has a txt file or csv file
    # we don't want to leave it behind
    #
    # @return [Array]
    def support_files(cookbook_name)
      all_test_files(cookbook_name).reject do |test_file|
        test_file.nil? || test_file.end_with?('_test.rb')
      end
    end

    # Set of test files for a given recipe
    #
    # @return [Array] list of test files
    def test_files(cookbook_name, recipe_name)
      files = []
      all_test_files(cookbook_name).each do |test_file|
        next if test_file.nil?
        files << test_file if test_file.end_with?("#{recipe_name}_test.rb")
      end
      remove_nil_from_array(files)
    end

    # A list of all test files in a given cookbook
    #
    # @return [Array]
    def all_test_files(cookbook_name)
      files = []
      cookbook_file_names(cookbook_name).each do |file_name|
        # match test/ or tests/. Those are the two
        # supported locations
        files << file_name if file_name =~ /^tests?\//
      end
      remove_nil_from_array(files)
    end

    # Extract the list of *files* (in the files directory)
    # from a cookbook
    #
    # @return [Array] of file paths relative to the cookbook root
    def cookbook_file_paths(cookbook_name)
      ckbk = run_context.cookbook_collection[cookbook_name]
      files = []
      ckbk.manifest['files'].each do |file_info|
        files << file_info['path']
      end
      files
    end

    # Return a list of files in this cookbook
    #
    # @returns [Array] of file names relative to
    # the files directory in the cookbook
    def cookbook_file_names(cookbook_name)
      relative_file_names = []
      cb_files = cookbook_file_paths(cookbook_name)

      # Drop the cookbook directory and cookbook name
      # from the front of the path. Account for the fact
      # that we might have multiple directories in the
      # cookbook path so it might be a string, or an Array
      cb_files.each do |cb_file|
        # Without the .dup the gsub! below causes  Chef::Exceptions::FileNotFound
        # when the cookbook_file resource goes to place the file
        relative_file_name = cb_file.dup
        Array(Chef::Config[:cookbook_path]).each do |cb_path|
          # Ensure the full cookbook path is not part of relative name
          dir_prefix = Regexp.new('[A-Za-z]?:?' +
            ::File.join(cb_path, cookbook_name, '/'))
          relative_file_name.gsub!(dir_prefix, '')

          files_prefix = ::File.join('files', 'default', '/')
          relative_file_name.gsub!(files_prefix, '')
        end
        relative_file_names << relative_file_name
      end
      remove_nil_from_array(relative_file_names)
    end

    # Remove nil entries from an Array
    #
    # @return [Array]
    def remove_nil_from_array(list_to_clean)
      list_to_clean.reject { |entry| entry.nil? }
    end
  end
end
