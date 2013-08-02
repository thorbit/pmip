#TODO: sort by date, most recent first
class ViewXmlSpecificationFailures < PMIPAction
  def run(event, context)
    results = Files.new.include('target/specs2-reports/failed/*_expected.xml').find

    if results.empty?
      result_and_balloon("could not find any xml conversion failures")
    else
      result("found #{results.size} failures")

      Chooser.new("View xml conversion failure:", results, 1100, 800).
        description{|r| "#{r.filename}" }.
        on_selected{|r| diff_expected_and_actual(event, context, r.to_s) }.
        show(false)
    end
  end

  private

  def diff_expected_and_actual(event, context, expected)
    actual = expected.sub('_expected', '_actual')
    path = "#{context.root}/tools/BeyondCompare3/"
    command = "BComp.com #{actual} #{expected}"
    Command.run(path, command, true)
  end
end
