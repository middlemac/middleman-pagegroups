require 'middleman-core'

Middleman::Extensions.register :MiddlemanPageGroups, :before_configuration do
  require_relative 'middleman-pagegroups/extension'
  MiddlemanPageGroups
end
