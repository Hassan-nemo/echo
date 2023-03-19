class Error < StandardError
  attr_reader :message, :code

  def initialize(message, code)
    super(message)

    @message = message
    @code = code
  end
end

class RecordNotFound < Error
  def initialize(message, code = 'not_found')
    super
  end
end

class UnprocessableRecord < Error
  def initialize(message, code = 'invalid_transaction')
    super
  end
end
