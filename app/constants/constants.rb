module Constants
  RESPONSE_SCHEMA = Rails.root.join('config', 'schemas', 'response.json')
  PATH_REGEX = %r{\A/([a-zA-Z0-9\-._~!$&'()*+,;=:@]|%[0-9a-fA-F]{2})*/?\z} # https://www.rfc-editor.org/rfc/rfc3986#section-3.3
  ALLOWED_VERBS = %w[GET POST PUT PATCH DELETE HEAD OPTIONS CONNECT TRACE].freeze
end
