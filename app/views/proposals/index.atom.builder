cache("#{@cache_key}.atom") do
  atom_feed do |feed|
    feed.title("#{SETTINGS.organization}: Presentation Proposals")
    feed.updated((@proposals.blank? ? Time.at(0) : @proposals.first.submitted_at))

    @proposals[0..ProposalsController::MAX_FEED_ITEMS].each do |proposal|
      feed.entry(proposal, :url => proposal_url(proposal)) do |entry|

        entry.title(h proposal.title)
        body = <<-HERE
<p>
<b>Presenter:</b> #{h proposal.presenter}
</p>

<p>
<b>Biography:</b> #{preserve_formatting_of proposal.bio}
</p>

<p>
<b>Description:</b> #{preserve_formatting_of proposal.description}
</p>
        HERE

        entry.content(body, :type => 'html')

        entry.author do |author|
          author.name(proposal.presenter)
        end
      end
    end
  end # atom_feed
end # cache
