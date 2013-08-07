class ExecuteCommand < PMIPAction
  def initialize(command, path='', hide_window = false, name = "#{self.class.to_s}: #{command}")
    super(name)
    @command = command
    @path = path
    @hide_window = hide_window
  end

  def run(event, context)
    result('Running ...')
    Command.run(@path, @command, @hide_window)
  end
end