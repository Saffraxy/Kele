require 'httparty'
require 'roadmap'

class Kele
  include HTTParty
  include RoadMap

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

  def get_mentor_availability(mentor_id)
    #mentor_id = "539470"
    url = "https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    h = JSON.parse(response.body)
    h.to_a
  end

  def get_messages(number = nil)
    url = "https://www.bloc.io/api/v1/message_threads/"
    body = {page: number}
    if number
      response = self.class.get(url, headers: { "authorization" => @auth_token }, body: body)
    else
      response = self.class.get(url, headers: { "authorization" => @auth_token })
    end
    JSON.parse(response.body)
  end

  def create_messages(string, text)
    url = "https://www.bloc.io/api/v1/messages"
    body = {
      user_id: get_me["id"],
      recipient_id: "539470",
      subject: string,
      "stripped-text"=> text
    }
    response = self.class.post(url, headers: { "authorization" => @auth_token }, body: body)
    JSON.parse(response.body)
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    url = "https://www.bloc.io/api/v1/checkpoint_submissions"
    body = {
      assignment_branch: assignment_branch,
      assignment_commit_link: assignment_commit_link,
      checkpoint_id: checkpoint_id,
      comment: comment,
      enrollment_id: get_me["current_enrollment_id"]
    }
    response = self.class.post(url, headers: { "authorization" => @auth_token }, body: body)
    JSON.parse(response.body)
  end

end
