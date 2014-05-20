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

nuke_dukes = ExecuteCommand.new('pmip\plugins\jawp\bash.bat ./pmip/plugins/jawp/nukeDukes.sh', PMIPContext.new.root, "Nuke Jukes")
bind 'banana J', nuke_dukes

unbind 'ctrl T', "Sorry, it's too easy to hit 'ctrl T' when you didn't mean to, please use 'banana T' to do a subversion update"
bind 'banana T', CompositeAction.new([nuke_dukes, RunIntellijAction.new('Vcs.UpdateProject', 'Subversion Update')])
#update = RunIntellijAction.new('Vcs.UpdateProject', 'GIT Update')
commit = RunIntellijAction.new('ChangesView.Commit', 'GIT Commit..')
push = RunIntellijAction.new('Git.Push', 'GIT Push..')
bind 'banana K', CompositeAction.new([commit, push], 'GIT commit and Push')

bind_and_run OptimiseDevelopmentEnvironment.new
