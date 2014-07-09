name              "god"

version           "1.0.0"


%w{debian ubuntu}.each do |os|
  supports os
end
