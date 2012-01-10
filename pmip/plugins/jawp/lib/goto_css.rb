class GotoCss < PMIPAction
  def run(event, context)
    #TODO: make it move back between css and html
    unless context.has_editor?
      result_and_balloon("please invoke with the cursor on an element class or id etc")
      return
    end

    line = context.current_editor.line
    line =~ /.*"(.*?)".*/
    css = $1
    return if css.nil?

    results = FindInFiles.new(Files.new.include('src/main/webapp/**/*.css')).pattern(/#{css}/, css)

    if results.empty?
      result_and_balloon("could not find css for: #{css}, maybe it can be deleted")
    else
      result("found #{results.size} usages of css: #{css}#{results}")

      Chooser.new("Goto css for: #{css}", results).
        description{|r| "#{r.line} - #{r.filepath.replace(context.root, '')}" }.
        preview_line{|r| r.content }.
        on_selected{|r| r.navigate_to }.
        show
    end
  end
end
