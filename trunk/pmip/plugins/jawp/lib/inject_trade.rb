class InjectTrade < PMIPAction
  def run(event, context)
    Refresh.file_system_before {
      id = rand(1000000)
      Clipboard.set(context.
        filepath_from_root('pmip/plugins/jawp/maml_event_requestConsent.xml').
        read.gsub('PMIP-CONVERSATION-REF', "PMIP-#{id}").gsub('PMIP-RATE', "0.#{rand(1000000)}")
      )
      result_and_balloon("Generated trade is now in the clipboard with id: #{id}")
    }
  end
end