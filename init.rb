require 'redmine'
require 'dispatcher'
require 'application_patch'
require 'cleanup_tmp'

require_dependency 'attachment_hook'

Redmine::Plugin.register :redmine_attach_screenshot do
  name 'Redmine Attach Screenshot plugin'
  author 'Konstantin Zaitsev, Sergei Vasiliev, Alexandr Poplavsky, Jens Alfke'
  description 'Attach screenshots from clipboard directly to a Redmine issue'
  version '0.1.0'
  Dispatcher.to_prepare do
    ApplicationController.send(:include, AttachScreenshotPlugin::ApplicationControllerPatch)
    AccountController.send(:include, AttachScreenshotPlugin::CleanupTmp)
  end
end
