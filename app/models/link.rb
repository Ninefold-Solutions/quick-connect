class Link < ApplicationRecord
  belongs_to :user
  validates_presence_of :link
  belongs_to :contact

  PROFILE_OPTIONS = [
    ["LinkedIn", "fa-brands fa-linkedin"],
    ["Youtube", "fa-brands fa-youtube"],
    ["Facebook", "fa-brands fa-facebook"],
    ["Instagram", "fa-brands fa-instagram"],
    ["Whatsapp", "fa-brands fa-whatsapp"],
    ["Twitter", "fa-brands fa-twitter"],
    ["Hubspot", "fa-brands fa-hubspot"],
    ["Website", "fa-solid fa-globe"],
  ]
  validates :link_type, uniqueness: { :scope => [:contact_id], message: "already exists" }

  def normalized_link_type
    return if link_type.blank?

    case link_type
    when "fa-globle", "fa-brands fa-globle", "fa-solid fa-globle", "fa-brands fa-globe"
      "fa-solid fa-globe"
    else
      link_type
    end
  end

  def link_type_label
    normalized_link_type.to_s.split("-").last.upcase_first
  end

  private

  def normalize_link_type
    self.link_type = normalized_link_type
  end
end
