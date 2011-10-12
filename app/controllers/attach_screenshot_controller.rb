#require 'RMagick'

class AttachScreenshotController < ApplicationController
  unloadable
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token
  accept_key_auth :index

  def index
    path = "#{RAILS_ROOT}/tmp/"
    if request.post?
      date = DateTime.now.strftime("%H%M%S")
      @fname = make_tmpname(date)                 
      file = File.new(path + make_tmpname(date), "wb");
      file.write(params[:attachments].read);
      file.close();
      if (Object.const_defined?(:Magick))
        img = Magick::Image::read(file.path()).first
        thumb = img.resize_to_fit(150, 150)
        @fname = make_tmpname(date, "thumb.png")
        thumb.write path + @fname
      end
        render :inline => "<%= @fname %>"
    else
      @fname = params[:id];
      send_file(path + @fname,
                :disposition => 'inline',
                :type => 'image/png',
                :filename => "screenshot.png");
    end
  end

  private

  def make_tmpname(date, name = "screenshot.png")
    sprintf('%d_%d%s', User.current.id, date, name)
  end
end
