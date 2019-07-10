class Test < ApplicationRecord

	validate :check_url_validation
	validates :max_ttfb, :max_tti, :max_speed_index, :max_ttfp, presence: true, numericality: true

	after_validation :check_and_store_values

	def check_url_validation
    	errors.add(:url, "Not a proper URL") unless UrlFetch.is_valid? (url)
	end

	def check_and_store_values
	  api_res = UrlFetch.fetch_response (url)
      actual_times = UrlFetch.extract_actual_times(api_res)
      test_params = {"max_ttfb": max_ttfb, "max_tti": max_tti, "max_speed_index": max_speed_index, "max_ttfp": max_ttfp}
      passed = UrlFetch.is_passed? actual_times, test_params
      self.is_passed = passed
      self.ttfp = actual_times[:ttfp]
      self.ttfb = actual_times[:ttfb]
      self.tti = actual_times[:tti]
      self.speed_index = actual_times[:speed_index]
	end	

end
