class User < ApplicationRecord
  require "securerandom"

  has_secure_password

  normalizes :first_name, :last_name, :email, with: ->(value) { value&.strip }
  normalizes :email, with: ->(value) { value&.downcase }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates_confirmation_of :password, if: :password_confirmation_given?, on: :update

  def password_confirmation_given?
    password_confirmation ? true : false
  end

  scope :available, -> { where(archived: false) }
  scope :for_current_account, -> { where(account: Current.account) }
  enum :permission, [:true, :false]
  enum :admin, [:false, :true], prefix: :true
  belongs_to :account, optional: true
  validates :email, uniqueness: true
  validates_presence_of :first_name, :last_name, :email
  has_many :contacts, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :phone_calls, dependent: :destroy
  has_many :tasks, dependent: :destroy

  has_many :comments
  has_many :debts, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :gifts, dependent: :destroy
  has_many :reminders, dependent: :destroy

  def upcoming_tasks
    self.tasks.joins(:contact).where("contacts.archived=?", false).order(created_at: :desc).limit(10)
  end

  def upcoming_reminders
    reminders = self.reminders.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=?", false).to_a
    upcoming_reminders = []
    reminders.each do |reminder|
      upcoming_reminders += reminder.upcoming
    end
    upcoming_reminders.sort_by { |r| r.third[:reminder] }
  end

  def follow_ups(bucket: nil)
    follows = Contact.available.tracked.includes(:contacts_labels)

    if bucket.present? && Batch.buckets.key?(bucket) && bucket != 'archive'
      follows = follows.joins(:batches).where(batches: { bucket: Batch.buckets[bucket] }).distinct
    end

    follows = follows.where("contacts.touched_at <= ?", Date.today - 30.days)
    if follows.present?
      sixth = follows.over_100_days.where("contacts.touched_at <= ?", Date.today - 100.days)
      fifth = follows.ninety_days.where("contacts.touched_at <= ?", Date.today - 90.days) - sixth
      fourth = follows.sixty_days.where("contacts.touched_at <= ?", Date.today - 60.days) - fifth - sixth
      third = follows.thirty_days.where("contacts.touched_at <= ?", Date.today - 30.days) - fourth - fifth - sixth
      second = follows.fifteen_days.where("contacts.touched_at <= ?", Date.today - 15.days) - third - fourth - fifth - sixth
      first = follows.seven_days.where("contacts.touched_at <= ?", Date.today - 7.days) - second - third - fourth - fifth - sixth
    end
    return first, second, third, fourth, fifth, sixth, follows
  end
end
