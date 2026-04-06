class NormalizeLegacyIconKeysInLinksAndFields < ActiveRecord::Migration[8.1]
  def up
    # Normalize old Font Awesome-based social link types to icon keys.
    execute <<~SQL
      UPDATE links
      SET link_type = CASE link_type
        WHEN 'fa-brands fa-linkedin' THEN 'linkedin'
        WHEN 'fa-brands fa-youtube' THEN 'youtube'
        WHEN 'fa-brands fa-facebook' THEN 'facebook'
        WHEN 'fa-brands fa-facebook-square' THEN 'facebook'
        WHEN 'fa-brands fa-instagram' THEN 'instagram'
        WHEN 'fa-brands fa-whatsapp' THEN 'whatsapp'
        WHEN 'fa-brands fa-twitter' THEN 'twitter'
        WHEN 'fa-brands fa-twitter-square' THEN 'twitter'
        WHEN 'fa-brands fa-hubspot' THEN 'hubspot'
        WHEN 'fa-solid fa-globe' THEN 'website'
        WHEN 'fa-globle' THEN 'website'
        WHEN 'fa-brands fa-globle' THEN 'website'
        WHEN 'fa-solid fa-globle' THEN 'website'
        WHEN 'fa-brands fa-globe' THEN 'website'
        WHEN 'fa-brands fa-github' THEN 'github'
        WHEN 'fa-brands fa-telegram' THEN 'telegram'
        ELSE link_type
      END
      WHERE link_type IS NOT NULL;
    SQL

    # Normalize old Font Awesome-based field icons to icon keys.
    execute <<~SQL
      UPDATE fields
      SET icon = CASE icon
        WHEN 'far fa-envelope-open' THEN 'email'
        WHEN 'fa-brands fa-facebook-square' THEN 'facebook'
        WHEN 'fa-solid fa-phone-volume' THEN 'phone'
        WHEN 'fa-brands fa-twitter-square' THEN 'twitter'
        WHEN 'fa-brands fa-whatsapp' THEN 'whatsapp'
        WHEN 'fa-brands fa-telegram' THEN 'telegram'
        WHEN 'fa-brands fa-linkedin' THEN 'linkedin'
        ELSE icon
      END
      WHERE icon IS NOT NULL;
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
