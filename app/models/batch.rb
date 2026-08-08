class Batch < ApplicationRecord
  acts_as_tenant :account
  enum :bucket, {
    archive: 0,
    dormant: 1,
    broad_buying_window: 2,
    buying_window: 3,
    conversations: 5,
    meetings: 6,
    contracts: 7
  }, default: :archive

  validates_presence_of :name
  validates_uniqueness_to_tenant :name, case_sensitive: false
  validates_uniqueness_to_tenant :website, case_sensitive: false, allow_blank: true
  validates :people_count, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  has_many :batches_contacts
  has_and_belongs_to_many :contacts, touch: true
  has_many :events, class_name: 'Event', foreign_key: 'trackable', dependent: :destroy

  normalizes :name, with: ->(value) { value&.strip }
  normalizes :website, with: ->(value) { value&.strip }

  def self.query(params, includes = nil)
    return [] if params.empty?

    BatchQuery.new(self.includes(includes), params).filter
  end
end
