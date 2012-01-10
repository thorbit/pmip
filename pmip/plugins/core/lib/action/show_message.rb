class ShowMessage < PMIPAction
  def initialize(message, name = "#{self.class.to_s}: #{message}")
    super(name)
    @message = message
  end

  def run(event, context)
    Balloon.new.error(@message)
  end
end
