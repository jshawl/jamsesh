Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, Rails.application.credentials.spotify_client_id, Rails.application.credentials.spotify_client_secret, scope: %w(
    playlist-read-private
    user-read-private
    user-read-email
    user-read-playback-position
    user-read-recently-played
    user-top-read
    user-read-playback-state
    user-modify-playback-state
    user-read-currently-playing
  ).join(' ')
end