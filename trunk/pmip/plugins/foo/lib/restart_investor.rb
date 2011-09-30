class RestartFoo < PMIPAction
  def run(event, context)
    Run.read_action {
      Action.from_id('Stop').run(event.presentation)
      RunConfiguration.new.choose('Foo Server').run('Run', event.presentation)
      result('done')
    }
  end
end