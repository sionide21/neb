class PullRequest < ActiveRecord::Base
  belongs_to :repository
  before_save :clean_labels

  def clean_labels
    self.labels = labels.uniq
  end
end
