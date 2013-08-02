
class UsefulBookmarks < PMIPAction
  def run(event, context)
    Chooser.new("Useful Bookmarks", plugins.keys).
      description{|r| r }.
      on_selected{|r| result("#{r} - #{plugins[r].call}") }.
      show(false)
  end

  private

  def plugins
    all = {
      'Open ABC' => lambda { open('http://foo.com') },
      'Open XYZ' => lambda { open('http://bar.com') }
    }
    all
  end

  def open(url)
    Browser.new.open(url)
  end
end
