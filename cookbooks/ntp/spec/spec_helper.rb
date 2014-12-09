require 'chefspec'
require 'berkshelf'

Berkshelf.ui.mute do
  Berkshelf::Berksfile.from_file('Berksfile').install
end
