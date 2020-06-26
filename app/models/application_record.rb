class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # map表示用address定義
  def address
    [postal_code, prefecture_code, address_city, address_street].compact.join(',')
  end

end

