require 'digest/md5'
require 'openssl'
require 'base64'

module TinAlipay
  module Sign
    def self.excute_md5(params)
      query = params.sort.map do |key, value|
        "#{key}=#{value}"
      end.join('&')
      Digest::MD5.hexdigest("#{query}#{TinAlipay.key}")
    end

    def self.verify?(params)
       params = Payment.new_hash(params)
       params.delete('sign_type')
       sign = params.delete('sign')
       excute_md5(params) == sign
    end

    module Mobile
      SORT_PARAMS = %w( service v sec_id notify_data )
      def self.verify?(params)
        params = Payment.new_hash(params)
        query = SORT_PARAMS.map do |key|
          "#{key}=#{params[key]}"
        end.join('&')
        params['sign'] == Digest::MD5.hexdigest("#{query}#{TinAlipay.key}")
      end
    end


  end
end
