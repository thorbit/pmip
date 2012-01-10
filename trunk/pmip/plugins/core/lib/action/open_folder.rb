class OpenFolder < PMIPAction
  def initialize(folder, name = "#{self.class.to_s}: #{folder}")
    super(name)
    @folder = folder
  end

  def run(event, context)
    raise "currently only supported on windows" unless OS.windows?
    `rundll32 url.dll,FileProtocolHandler #{@folder}`
  end
end
