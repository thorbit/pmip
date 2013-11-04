class InjectTrade < PMIPAction
  def run(event, context)
    Refresh.file_system_before {
      id = rand(1000000)
      now = Time.now

      Clipboard.set(context.
        filepath_from_root('pmip/plugins/jawp/maml_event_requestConsent.xml').
        read.
            gsub('PMIP-CONVERSATION-REF', "PMIP-#{id}").
            gsub('PMIP-CLEARINGHOUSE-ID', "PMIP-#{id}").
            gsub('PMIP-CLIENT-ID', "#{id}-2").
            gsub('PMIP-SOURCE-ID', "#{id}").
            gsub('PMIP-RATE', "0.#{rand(1000000)}").
            gsub('PMIP-LONGNAME', BLAH_TEST10').
            gsub('PMIP-TRADEDATE', now.strftime("%Y-%m-%d")).
            gsub('PMIP-CREATIONDATE', now.strftime("%Y-%m-%dT%H:%M:%SZ"))
      )
      result_and_balloon("Generated trade is now in the clipboard with id: #{id}")
    }
  end
end