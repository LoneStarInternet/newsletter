require 'dynamic_form'
require 'nested_form'
require 'cancan'
class Newsletter::ApplicationController < ::ApplicationController 
  layout Newsletter.layout
  load_and_authorize_resource

  helper :'newsletter/layout'
end
