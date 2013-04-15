# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Rack::Mime::MIME_TYPES.merge!({
  ".ogg"     => "application/ogg",
  ".ogx"     => "application/ogg",
  ".ogv"     => "videos/ogg",
  ".oga"     => "audio/ogg",
  ".mp4"     => "videos/mp4",
  ".m4v"     => "videos/mp4",
  ".mp3"     => "audio/mpeg",
  ".m4a"     => "audio/mpeg"
})