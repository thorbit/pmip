class CompositeAction < PMIPAction
  def initialize(commands, name = "#{commands.collect{|c| c.name }.join(' and ')}")
    super(name)
    @commands = commands
  end

  def run(event, context)
    @commands.each{|c| c.run(event, context)}
  end
end