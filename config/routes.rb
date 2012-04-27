ActionController::Routing::Routes.draw do |map|
  map.connect 'attach_screenshot', :controller => 'attach_screenshot', :action => 'index'
end
