class ViewDriveByTrackingReport < PMIPAction
  def run(event, context)
    report = context.filepath_from_root('target/specs2-reports/tracking.txt')

    if !report.exist?
      result_and_balloon("could not find driveby tracking report")
    else
      Chooser.new("View driveby tracking report", [report], 1000).
        preview_box{|r| r.readlines }.
        show(false)
    end
  end
end