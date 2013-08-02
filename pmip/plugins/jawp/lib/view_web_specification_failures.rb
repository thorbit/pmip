class ViewWebSpecificationFailures < PMIPAction
  def run(event, context)
    results = Files.new.include('target/driveby/failed/*.html').find

    if results.empty?
      result_and_balloon("could not find any web specification failures")
    else
      result("found #{results.size} failures")

      Chooser.new("View web specification failure:", results, 1100, 800).
        description{|r| "#{r.filename}" }.
        html_preview_box{|r| mangle_content(r, context) }.
        on_selected{|r| navigate_to(r, context) }.
        show(false)
    end
  end

  private

  def mangle_content(filepath, context)
    filepath.read.gsub('screenshot/', 'file:///' + context.root + '/target/driveby/failed/screenshot/')
  end

  def navigate_to(filepath, context)
    spec_name = filepath.to_s.split('_')[1].sub('.html', '')
    Navigator.new(context).open(Elements.new.by_class(spec_name))
  end
end
