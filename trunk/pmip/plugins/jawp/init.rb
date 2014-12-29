load 'lib/generate_font_awesome_icons.rb'
load 'lib/goto_css.rb'
load 'lib/inject_trade.rb'
load 'lib/micro_plugins.rb'
load 'lib/optimise_development_environment.rb'
load 'lib/run_specification_in_sbt.rb'
load 'lib/unicode_up_my_scala.rb'
load 'lib/useful_bookmarks.rb'
load 'lib/view_driveby_tracking_report.rb'
load 'lib/view_web_specification_failures.rb'
load 'lib/view_xml_specification_failures.rb'

bind GenerateFontAwesomeIcons.new
bind 'alt shift S', GotoCss.new
bind 'banana M', MicroPlugins.new
bind 'pear B', UsefulBookmarks.new
bind 'banana F10', RunSpecificationInSBT.new
bind 'banana Z', ViewDriveByTrackingReport.new
bind 'banana W', ViewWebSpecificationFailures.new
bind 'banana X', ViewXmlSpecificationFailures.new
bind 'alt shift H', RunIntellijAction.new('Vcs.ShowTabbedFileHistory', 'Show History')
bind 'alt shift A', RunIntellijAction.new('Annotate', 'Finger Of Blame')
bind 'banana D', RunIntellijAction.new('Compare.SameVersion', 'Compare With Same Repo Version')
bind 'banana C', RunIntellijAction.new('CompareTwoFiles', 'Compare Two Files')
bind 'banana F', RunIntellijAction.new('OpenInBrowser', 'Open in Browser')
bind 'banana R', RunIntellijAction.new('ChangesView.Rollback', 'Rollback/Revert')
bind 'banana U', UnicodeUpMyScala.new
bind 'banana I', InjectTrade.new
bind 'banana T', RunIntellijAction.new('Vcs.UpdateProject', 'Update')

nuke_dukes = ExecuteCommand.new('pmip\plugins\jawp\bash.bat ./pmip/plugins/jawp/nukeDukes.sh', PMIPContext.new.root, "Nuke Jukes")
bind 'banana J', nuke_dukes

class RefreshAction < PMIPAction
  def run(event, context)
    puts "refreshing"
    Refresh.file_system
  end
end

#update = RunIntellijAction.new('Vcs.UpdateProject', 'GIT Update')
commit = RunIntellijAction.new('ChangesView.Commit', 'GIT Commit..')
push = RunIntellijAction.new('Git.Push', 'GIT Push..')
refresh = RefreshAction.new
commit_and_push = CompositeAction.new([refresh, commit, refresh, push, refresh], 'GIT commit and Push')

#if 'foo' == System.getProperty("user.name")
#  unbind 'ctrl K', 'Try banana K instead'
#  bind 'ctrl K', commit_and_push
#  bind 'banana K', commit
#  load 'lib/clobber_annoying_intellij_defaults.rb'
#else
#  bind 'banana K', commit_and_push
#end

#bind 'banana Q', RunIntellijAction.new('CloseProject', 'Close Project')

bind_and_run OptimiseDevelopmentEnvironment.new
