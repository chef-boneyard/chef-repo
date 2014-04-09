#!/usr/bin/env rake

task :default => "foodcritic"

desc "Runs foodcritic linter"
task :foodcritic do
  Rake::Task[:prepare_sandbox].execute

  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sh "foodcritic -f any #{sandbox_path}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

desc "Runs knife cookbook test"
task :knife do
  Rake::Task[:prepare_sandbox].execute

  sh "knife cookbook test cookbook -c test/.chef/knife.rb -o #{sandbox_path}/../"
end

desc "Runs test-kitchen tests"
task :kitchen, :regex do |t, args|
  # Skip if on Travis an no secure vars avail.
  next if ENV['TRAVIS_SECURE_ENV_VARS'] == "false"

  cmd = "bundle exec kitchen test #{args.regex} --parallel"

  cmd = "#{cmd} --destroy=always" if ENV['CI']

  sh cmd
end

task :prepare_sandbox do
  files = %w{*.md *.rb attributes definitions libraries files providers recipes resources templates}

  rm_rf sandbox_path
  mkdir_p sandbox_path
  cp_r Dir.glob("{#{files.join(",")}}"), sandbox_path
end

private

def sandbox_path
  File.join(File.dirname(__FILE__), %w[tmp cookbooks cookbook])
end
