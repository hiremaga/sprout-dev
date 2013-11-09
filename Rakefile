require 'rake'
require 'rspec/core/rake_task'

namespace :sprout do
  desc 'Run a sprout recipe in a VM'
  task :run, :recipe_name do |t, args|
    recipe_name = args.to_hash.fetch(:recipe_name)

    sh('vagrant up --provider vmware_fusion')

    cmd = <<-BASH
    cd /vagrant/sprout-cookbooks
    soloist run_recipe #{recipe_name}
    BASH

    sh "vagrant ssh -c '#{cmd}'"
  end

  desc 'Review a sprout pull request by merging it locally and then running a recipe in a VM'
  task :review, [:pull_request_id, :recipe_name]  do |t, args|
    Rake::Task['sprout:merge'].invoke(args[:pull_request_id])
    Rake::Task['sprout:run'].invoke(args[:recipe_name])
  end

  desc 'Merge a sprout pull request locally'
  task :merge, [:pull_request_id] => [:pullify]  do |t, args|
    pull_request_id = args.to_hash.fetch(:pull_request_id)

    Dir.chdir('sprout-cookbooks') do
      sh <<-BASH
        git merge origin/pr/#{pull_request_id}
      BASH
    end
  end

  desc 'Discard a locally merged pull request'
  task :reset do
    sh 'git submodule update'
  end

  task :pullify do
    Dir.chdir('sprout-cookbooks') do
      sh <<-BASH
        git config --get-all remote.origin.fetch refs/pull || \
          git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
        git fetch
      BASH
    end
  end
end

desc 'Run all sprout recipe specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end
