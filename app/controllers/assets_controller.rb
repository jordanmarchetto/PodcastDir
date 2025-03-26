class AssetsController < ApplicationController
  ASSETS_PATH = "/media"

  def serve
    filename = params[:filename]
    filepath = File.join(ASSETS_PATH, filename)

    if File.exist?(filepath)
      send_file(filepath, disposition: 'inline')
    else
      render plain: "File not found", status: :not_found
    end
  end
end
