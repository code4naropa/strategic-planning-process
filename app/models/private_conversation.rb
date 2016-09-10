class PrivateConversation < ApplicationRecord

  # # Assocations
  # ## Participantships/Participants
  has_many :participantships,
    :class_name => "ParticipantshipInPrivateConversation",
    :foreign_key => "private_conversation_id",
    :dependent => :destroy,
    :autosave => true,
    :inverse_of => :private_conversation
  has_many :participants,
    :through => :participantships,
    :source => :participant

  # ## Private Messages
  has_many :messages,
    :class_name => "PrivateMessage",
    :foreign_key => "private_conversation_id",
    :dependent => :destroy,
    :inverse_of => :conversation
  has_one :most_recent_message, -> {
      self.select_values = ["DISTINCT ON(private_messages.private_conversation_id) private_messages.*"]
      reorder('private_messages.private_conversation_id, private_messages.id DESC')
    },
    :class_name => "PrivateMessage",
    :foreign_key => "private_conversation_id"

  # # Scopes
  scope :most_recent_activity_first,
    -> { order('"private_conversations"."updated_at" DESC') }
  scope :with_associations,
    -> { includes(:messages).includes(:participants) }

  # finds the conversations between a set of users
  # use like PrivateConversations.find_conversations_between [alice, bob]
  scope :find_conversations_between,
    ->(users) {
      joins(participantships: :participant).
      where(users: {id: users.pluck(:id)}).
      group("id").
      having("count(\"private_conversations\".\"id\") = ?", users.size)
    }

  # # Accessors
  attr_reader(:sender, :recipient)

  # # Validations
  validates :sender, presence: true, on: :create
  validates :recipient, presence: { message: "does not exist or their profile is private" }, on: :create
  validates :participantships,
    length: {
      is: 2,
      message: "needs exactly two conversation participants"}
  validate :uniqueness_for_participants, on: :create,
    if: "participantships.present?"
  validate :recipient_can_be_messaged_by_sender, on: :create,
    if: "sender.present? and recipient.present?"
  validate :recipient_and_sender_cannot_be_the_same_person, on: :create,
    if: "sender.present? and recipient.present?"

  # # Methods

  def sender=(user)
    remove_participant @sender if @sender
    add_participant user
    @sender = user
  end

  def recipient=(user)
    remove_participant @recipient if @recipient
    add_participant user
    @recipient = user
  end

  # returns a list of participants that exclude the participant (object or ID)
  # supplied by the this_participant argument
  def participants_other_than this_participant
    case this_participant
    when Fixnum
      id_of_this_participant = this_participant
    else
      id_of_this_participant = this_participant.id
    end
    return participants.select {|p| p.id != id_of_this_participant}
  end

  # returns the participantship of a given participant
  def participantship_of this_participant
    case this_participant
    when Fixnum
      id_of_this_participant = this_participant
    else
      id_of_this_participant = this_participant.id
    end
    return participantships.
      select{|p| p.participant_id == id_of_this_participant}.first
  end

  # marks the current conversation as read for the participant (only if there
  # are new messages, to avoid unnessecary database insert statements)
  def mark_read_for participant
    if participantship_of( participant ).read_at.nil? or
      participantship_of( participant ).read_at < messages.first.created_at

      participantship_of( participant ).touch(:read_at)

    end
  end

  private
    # adds a participant to the conversation
    def add_participant participant
      self.participantships.build(:participant => participant)
    end

    # removes a participant from the conversation
    def remove_participant participant
      self.participantships.each do |p|
        p.mark_for_destruction if p.participant_id == participant.id
      end
    end

    def uniqueness_for_participants
      # since :participants is not yet initiated before creation, we need to
      # generate our own hash of user ids
      participation_ids = self.participantships.map {|p| {:id => p.participant_id}}

      if PrivateConversation.find_conversations_between(participation_ids).any?
        errors[:base] << "You already have a conversation with #{recipient.name}"
      end
    end

    def recipient_can_be_messaged_by_sender
      # eager load profile if not already loaded
      if not recipient.association(:profile).loaded?
        ActiveRecord::Associations::Preloader.new.preload(recipient, :profile)
      end

      # validate that recipient can be messaged by sender
      if not recipient.profile.viewable_by? sender
        errors.add :recipient, "does not exist or their profile is private"
      end
    end

    # Conversation sender and recipient must not be the same person
    def recipient_and_sender_cannot_be_the_same_person
      if sender.id == recipient.id
        errors.add :recipient, "can't be yourself"
      end
    end

end
