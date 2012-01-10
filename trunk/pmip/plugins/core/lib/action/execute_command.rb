class ExecuteCommand < PMIPAction
  def initialize(command, path='', name = "#{self.class.to_s}: #{command}")
    super(name)
    @command = command
    @path = path
  end

  def run(event, context)
    result('Running ...')
    Command.run(@path, @command)
  end
end