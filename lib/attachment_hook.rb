require 'redmine'

module AttachmentHook
  class Hooks < Redmine::Hook::ViewListener

    def attach_screenshots (context ={})
      issue       = context[:issue]
      journal     = context[:journal]
      params      = context[:params]

      unsaved     = []
      screenshots = params[:screenshots]
      if screenshots && screenshots.is_a?(Hash)
        screenshots.each_pair do |key, screenshot|
          key  = key.gsub("thumb", "screenshot")
          path = "#{RAILS_ROOT}/tmp/" + key
          file = File.open(path, "rb")

          def file.init(name)
            @screenshot_name = name
          end
          
          def file.content_type
            "image/png"
          end

          def file.size
            File.size(path())
          end

          def file.original_filename
           @screenshot_name
          end

          file.init(key)

          next unless file && file.size > 0
          a = Attachment.create(:container   => issue,
                                :file        => file,
                                :description => screenshot['description'].to_s.strip,
                                :author      => User.current)

          file.close()
          File.delete(path)
          key  = key.gsub("screenshot", "thumb")
          path = "#{RAILS_ROOT}/tmp/" + key
          begin
            File.delete(path)
          rescue
          end
          if a.new_record?
            unsaved << a
          else
            if journal
              journal.details << JournalDetail.new(:property => 'attachment',
                                                   :prop_key => a.id,
                                                   :value    => a.filename)
            end
          end
        end
        if unsaved.any?
          flash[:warning] = l(:warning_attachments_not_saved, unsaved.size)
        end
      end
    end

    def controller_issues_edit_before_save (context ={})
      attach_screenshots(context)
    end

    def controller_issues_new_after_save (context ={})
      attach_screenshots(context)
    end

  end
end