class ViewWebSpecificationFailures < PMIPAction
  def run(event, context)
    results = Files.new.include('target/specs2-reports/failed/*.html').find

    if results.empty?
      result_and_balloon("could not find any web specification failures")
    else
      result("found #{results.size} failures")

      Chooser.new("View web specification failure:", results, 1000).
        description{|r| "#{r.filename}" }.
        html_preview_box{|r| mangle_content(r, context) }.
        #on_selected{|r| r.navigate_to }.
        show(false)
    end
  end

  private

  def mangle_content(filepath, context)
    filepath.read.gsub('screenshot/', 'file:///' +context.root + '/target/specs2-reports/failed/screenshot/')
  end
end
