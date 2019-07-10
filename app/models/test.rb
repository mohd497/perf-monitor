class Test < ApplicationRecord

	validate :check_url_validation

	def check_url_validation
    	errors.add(:url, I18n.t('url_not_proper')) unless UrlShort.is_valid? (url)
	end

end
