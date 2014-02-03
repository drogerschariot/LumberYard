name             'logstash'
maintainer       'Chariot Solutions LLC'
maintainer_email 'drogers@chariotsolutions.com'
license          "Apache 2.0"
description      "Installs/Configures logstash"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

%w{ ubuntu debian }.each do |os|
  supports os
end

depends "nginx"