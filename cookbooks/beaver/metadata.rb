name             'beaver'
maintainer       'Chariot Forge'
maintainer_email 'dev@haydle.com'
license          "Apache 2.0"
description      "Installs/Configures Beaver"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{ ubuntu debian }.each do |os|
  supports os
end