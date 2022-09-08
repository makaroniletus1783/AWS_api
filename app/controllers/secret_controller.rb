class SecretController < ActionController::Base
  USERS = {"aws" => "candidate"}
  before_action :authenticate

  def digest
  end

  private

  def authenticate
    authenticate_or_request_with_http_digest do |username|
      USERS[username]
    end
  end

end
