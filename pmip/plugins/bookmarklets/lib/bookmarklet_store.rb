load 'lib/list_bookmarklets.rb'
load 'lib/get_bookmarklet.rb'

class BookmarkletStore
  def self.start(port, context = PMIPContext.new)
    assets_dir = '/assets'
    assets_filepath = Path.new(context.plugin_root + assets_dir)

    mount '/', ListBookmarklets, {:Path => assets_filepath, :Port => port}
    mount '/assets', GetBookmarklet, {:Path => assets_filepath}

    server port
  end
end