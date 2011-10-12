require 'account_controller'
require 'ftools'

module AttachScreenshotPlugin
  module ApplicationControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :find_current_user, :screenshot
      end
    end

    module InstanceMethods
      def find_current_user_with_screenshot
        if params[:controller] == "attach_screenshot" && request.post? && params[:key].present?
          User.find_by_rss_key(params[:key])
        else
          find_current_user_without_screenshot
        end
      end
    end    
  end
end
