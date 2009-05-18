class AddAcceptProposalCommentsAfterDeadlineToggle < ActiveRecord::Migration
  def self.up
    add_column :events, :accept_proposal_comments_after_deadline, :boolean
  end

  def self.down
    remove_column :events, :accept_proposal_comments_after_deadline
  end
end
