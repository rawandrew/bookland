module Authentication
  extend ActiveSupport::Concern

  AUTH_SCHEME = 'Bookland-Token'

  included do
    before_action :validate_auth_scheme
  end

  private

  def validate_auth_scheme
    unless authorization_request.match(/^#{AUTH_SCHEME} /)
      unauthorized!('Client Realm')
    end
  end

  def unauthorized!(realm)
    headers['WWW-Authenticate'] = %(#{AUTH_SCHEME} realm="#{realm}")
    render status: 401
  end

  def authorization_request
    @authorization_request ||= request.authorization.to_s
  end
end