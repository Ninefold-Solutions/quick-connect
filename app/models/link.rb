class Link < ApplicationRecord
  belongs_to :user
  validates_presence_of :link
  belongs_to :contact

  ICON_LABELS = {
    "linkedin" => "LinkedIn",
    "youtube" => "Youtube",
    "facebook" => "Facebook",
    "instagram" => "Instagram",
    "whatsapp" => "Whatsapp",
    "twitter" => "Twitter",
    "hubspot" => "Hubspot",
    "website" => "Website",
    "github" => "Github",
    "telegram" => "Telegram"
  }.freeze

  PROFILE_OPTIONS = [
    ["LinkedIn", "linkedin"],
    ["Youtube", "youtube"],
    ["Facebook", "facebook"],
    ["Instagram", "instagram"],
    ["Whatsapp", "whatsapp"],
    ["Twitter", "twitter"],
    ["Hubspot", "hubspot"],
    ["Website", "website"],
    ["Github", "github"],
  ]
  validates :link_type, uniqueness: { :scope => [:contact_id], message: "already exists" }
  before_validation :normalize_link_type

  def normalized_link_type
    return if link_type.blank?

    link_type
  end

  def link_type_label
    ICON_LABELS.fetch(normalized_link_type.to_s, normalized_link_type.to_s.upcase_first)
  end

  private

  def normalize_link_type
    self.link_type = normalized_link_type
  end
end
