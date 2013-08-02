class MicroPlugins < PMIPAction
  def run(event, context)
    Chooser.new("Micro plugins", plugins.keys).
      description{|r| r }.
      on_selected{|r| result("#{r} - #{plugins[r].call}") }.
      show
  end

  private

  def plugins
    all = {
            'Copy my staff id to clipboard' => lambda { Clipboard.set(staff_id(username)) },
            'Copy my nedap to clipboard' => lambda { Clipboard.set(nedap(username)) },
            'Copy my username to clipboard' => lambda { Clipboard.set(username) },
            'Copy my hostname to clipboard' => lambda { Clipboard.set(hostname) },
            'Copy my phone number to clipboard' => lambda { Clipboard.set(phone_number_or_default_if_missing) }
    }
    all
  end

  def username
    System.getProperty("user.name")
  end

  def staff_id(username)
    user(username).has_key?('staff_id') ? user(username)['staff_id'].to_s : Balloon.new.error("Could not find a staff id for '#{username}', please edit 'users.yaml'")
  end
  def nedap(username)
    user(username).has_key?('nedap') ? user(username)['nedap'].to_s : Balloon.new.error("Could not find a nedap for '#{username}', please edit 'users.yaml'")
  end
  def user(usersname)
    users = YAML::load_file(plugin_root + '/users.yaml')
    users.has_key?(username) ? users[username] : Balloon.new.error("Could not find a user for '#{username}', please edit 'users.yaml'")
  end

  def hostname
    `hostname`.strip
  end

  def phone_number_or_default_if_missing
    user(username).has_key?('phone') ? user(username)['phone'].to_s : 'XXX XXXXXXXX'
  end
end
