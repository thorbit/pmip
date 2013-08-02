class R
  attr_accessor :to, :from, :prod_only

  def initialize(to, from, prod_only = false)
    @to = to; @from = from; @prod_only = prod_only
  end
end

class UnicodeUpMyScala < PMIPAction
  REPLACEMENTS = [R.new('=>', '⇒'), R.new('<-', '←'), R.new('=>', '⇒'), R.new('|@|', '⊛'), R.new('->', '→'),
                  R.new('===', '≟', true), R.new('=/=', '≠'), R.new('/==', '≠')]

  def run(event, context)
    Refresh.file_system_before_and_after {
      changes = find_and_unicode_up
      result_and_balloon("#{changes} Scala files were unicoded up")
    }
  end

  private

  def find_and_unicode_up
    changes = 0
    candidates = scala_files

    candidates.each {|f|
      original = f.readlines.join("\r\n")
      updated = mangle(original, is_spec(f))

      if original != updated
        changes = changes + 1
        f.writelines(updated.split("\r\n"))
      end
    }

    changes
  end

  def scala_files
    Files.new.include('**/*.scala').find
  end

  def is_spec(f)
    f.ends?('Spec.scala')
  end

  #TODO: rename to content or something
  def mangle(original, is_spec)
    REPLACEMENTS.each {|r|
      (original = original.gsub(' ' + r.to, ' ' + r.from)) unless is_spec && r.prod_only
    }
    original
  end
end