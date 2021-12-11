require 'rails_helper'

RSpec.describe 'log in/out', type: :feature do
  describe 'root path' do
    it 'shows a log in button' do
      visit root_path
      expect(page).to have_button('Log In with Spotify')
      find('[value="Log In with Spotify"]', match: :first).click
      expect(page.current_url).to match("spotify.com")
    end
  end
end