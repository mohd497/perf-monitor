module UrlFetch
	require 'net/http'

	HTTP_REGEX = /https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9]\.[^\s]{2,}/i

	def self.fetch_response (url)
			url = URI.parse("https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=#{url}&key=" + ENV['api_key'])
			req = Net::HTTP::Get.new(url.request_uri)
			http = Net::HTTP.new(url.host, url.port)
			http.use_ssl = (url.scheme == "https")
			response = http.request(req)
			res_json = JSON.parse(response.body)
	end

	def self.extract_actual_times (api_res)
		begin
			ttfb = api_res['lighthouseResult']['audits']['time-to-first-byte']['displayValue']
			ttfb = extract_number_from_display_value (ttfb)
			ttfb = ttfb[0].to_i

			tti = api_res['lighthouseResult']['audits']['interactive']['displayValue']
			tti = get_result_from_string (tti)

			ttfp = api_res['lighthouseResult']['audits']['first-meaningful-paint']['displayValue']
			ttfp = get_result_from_string (ttfp)

			speed_index = api_res['lighthouseResult']['audits']['speed-index']['displayValue']
			speed_index = get_result_from_string (speed_index)
		
			{ttfb: ttfb, tti: tti, ttfp: ttfb, speed_index: speed_index}
		rescue
			{ttfb: 0, tti: 0, ttfp: 0, speed_index: 0}
		end		
	end

	def self.get_result_from_string (display_value)
		display_value = extract_number_from_display_value (display_value)
		display_value = convert_to_milliseconds (display_value)
		display_value = display_value.to_i
	end	

	def self.extract_number_from_display_value (time)
		time.scan(/\d+.\d+/)
	end

	def self.convert_to_milliseconds (seconds)
		milliseconds = seconds[0].to_f * 1000
	end

	def self.is_passed? (actual_times, test_params)
		if (test_params[:max_ttfb] < actual_times[:ttfb] || test_params[:max_tti] < actual_times[:tti] || test_params[:max_speed_index] < actual_times[:speed_index] || test_params[:max_ttfp] < actual_times[:ttfp])
    			false
    	else
    			true
    	end		
	end	

	def self.is_valid? (url)
		url =~ HTTP_REGEX
	end
end	