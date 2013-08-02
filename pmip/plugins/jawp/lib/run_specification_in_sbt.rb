class RunSpecificationInSBT < PMIPAction
  def run(event, context)
    unless context.has_editor? && context.editor_filepath.ends?("Spec.scala")
      result_and_balloon("please ensure a specification is open in the active editor")
      return
    end

    spec_name = fully_qualified_spec_name(context.editor_filepath, context.root)
    command = "bash ./sbt.sh \\\"test-only #{spec_name}\\\""
    result(command)
    Command.run(context.root, command)
  end

  private

  def fully_qualified_spec_name(filepath, root)
    filepath.to_s.sub('.scala', '').sub(root + '/src/test/scala/', '').gsub('/', '.')
  end
end