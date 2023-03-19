class ServicesBase
  def self.execute(params)
    new(params).execute
  end

  def initialize(params)
    @params = params
  end

  def execute
    raise NotImplementedError, 'Must Implement execute method for the service'
  end

  private_class_method :new

  private

  attr_reader :params

  def attributes
    @attributes ||= params[:data][:attributes]
  end
end
