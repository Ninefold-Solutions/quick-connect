class ApplicationService
  attr_reader :result

  def self.call(...)
    service = new(...)
    service.instance_variable_set(:@result, service.call)
    service
  end

  def call
    raise NotImplementedError
  end
end
