class MicroPlugins < PMIPAction
  def run(event, context)
    Chooser.new("Micro plugins", plugins.keys).
      description{|r| r }.
      on_selected{|r| result("#{r} - #{plugins[r].call}") }.
      show
  end

  private

  def plugins
    all = { 'Copy my staff id to clipboard' => lambda { Clipboard.set(staff_id(username)) },
            'Copy my username to clipboard' => lambda { Clipboard.set(username) },
            'Copy my hostname to clipboard' => lambda { Clipboard.set(hostname) }
    }
    all
  end

  def username
    System.getProperty("user.name")
  end

  def staff_id(username)
    users = YAML::load_file(plugin_root + '/users.yaml')
    users.has_key?(username) ? users[username].to_s : Balloon.new.error("Could not find a staff id for '#{username}', please edit 'users.yaml'")
  end

  def hostname
    `hostname`.strip
  end
end
