module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  ENV['APIKEY']="cd72f2c73f934ac32034074ec13d6f6d"
end