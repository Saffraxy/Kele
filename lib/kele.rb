require 'httparty'

class Kele
  include HTTParty

  def initialize(email, password)
     response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {email: email, password: password})
     raise "invalid email/pass" if response.code != 200
     @auth_token = response["auth_token"]
  end

  def get_me
    url = "https://www.bloc.io/api/v1/users/me"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

end
