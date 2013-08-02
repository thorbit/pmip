class ViewDriveByTrackingReport < PMIPAction
  def run(event, context)
    report = context.filepath_from_root('target/driveby/tracking.txt')

    if !report.exist?
      result_and_balloon("could not find driveby tracking report")
    else
      Chooser.new("View driveby tracking report", [report], 1100, 800).
        preview_box{|r| r.readlines }.
        show(false)
    end
  end
end