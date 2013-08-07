class Command
  def self.run(path, command, hide_window = false)
    if OS.windows?
      Run.later { Thread.new {
      full_command = "start /D#{path.to_s.gsub('/', "\\")} #{hide_window ? "/B " : ""}#{command}"
      #puts full_command
      `#{full_command}`
      } }
    else
      Balloon.new.error("Command not currently supported on: #{OS.name}")
    end
  end

  #TODO: support no window option
end