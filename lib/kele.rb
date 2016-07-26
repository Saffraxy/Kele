require 'httparty'

class Kele
  include HTTParty

  #def initialize(attributes = {})
   #@username = attributes[:username]
   #@password = attributes[:password]
   #@BlocAPIURL= "https://www.bloc.io/api/v1"
  #end

  def initialize(username, password)
     response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"username": username, "password": password})
     raise "invalid username/pass" if response.code != 200
     @auth_token = response["auth_token"]
  end
end
