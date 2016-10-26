class Idea < ApplicationRecord
  include Likable

  belongs_to :author, :class_name => "User"

  scope :most_recent_first,
    -> { order('ideas.created_at DESC') }
  scope :with_associations,
    -> { includes(:author).includes(:likes) }

  validates :content, presence: true
  validates :content, length: { maximum: 250 }

  def readable_by? user
    true
  end

  # whether the post can be deleted by a given user
  def deletable_by? user
    return false unless user
    return self.author.id == user.id
  end

end
