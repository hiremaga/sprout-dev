require 'spec_helper'

describe 'sprout-osx-apps::chrome' do
  before do  
    backend.run_command '
      cd /vagrant/sprout-cookbooks
      soloist run_recipe sprout-osx-apps::chrome &> /vagrant/out
    '
  end
  
  it 'installs Google Chrome into /Applications' do
    expect(file('/Applications/Google Chrome.app')).to be_a_directory
  end
end
