class Command
  def self.run(path, command, hide_window = false)
    if OS.windows?
      Run.later { Thread.new {`start /D#{path.to_s.gsub('/', "\\")} #{hide_window ? "/B " : ""}#{command}` } }
    else
      Balloon.new.error("Command not currently supported on: #{OS.name}")
    end
  end
end