class AssetsController < ApplicationController

  def serve
    filename = params[:filename]
    filepath = File.join(ASSETS_DIR, filename)

    if File.exist?(filepath)
      send_file(filepath, disposition: 'inline')
    else
      render plain: "File not found", status: :not_found
    end
  end
end
