class Batch < ApplicationRecord
  acts_as_tenant :account
  enum :bucket, {
    archive: 0,
    bucket_1: 1,
    bucket_2: 2,
    bucket_3: 3,
    bucket_4: 4,
    bucket_5: 5,
    bucket_6: 6
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

  def self.default_bucket_names
    @default_bucket_names ||= begin
      names = { 'archive' => 'Archive' }
      non_archive_keys = buckets.keys - ['archive']

      non_archive_keys.each_with_index do |bucket_key, index|
        names[bucket_key] = "bucket_#{index + 1}"
      end

      names
    end
  end

  def self.bucket_names_for(account)
    overrides = Preference.group_bucket_names(account)
    default_bucket_names.merge(overrides.slice(*buckets.keys))
  end

  def self.query(params, includes = nil)
    return [] if params.empty?

    BatchQuery.new(self.includes(includes), params).filter
  end
end
