module TinAlipay
  module Notify
    def self.verify?(params)
      params = Payment.new_hash(params)
      Sign.verify?(params) && verify_notify_id?(params['notify_id'])
    end

    def self.verify_notify_id?(notify_id)
      open("https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{TinAlipay.pid}&notify_id=#{URI::escape(notify_id.to_s)}").read == 'true'
    end

    module Mobile
      def self.verify?(params)
        params = Payment.new_hash(params)
        notify_id = params['notify_data'].scan(/\<notify_id\>(.*)\<\/notify_id\>/).flatten.first
        Sign::Mobile.verify?(params) && Notify.verify_notify_id?(notify_id)
      end
    end
    
  end
end
