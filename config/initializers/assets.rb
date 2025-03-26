# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# global constant for directory containing podcast episodes
ASSETS_DIR = begin
  # when running in docker, we're not passing this env var in, so it'll default to the mounted dir, 'media'
  env_value = ENV.fetch("PODCAST_EPISODE_PATH", "/media")
end.freeze


# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
