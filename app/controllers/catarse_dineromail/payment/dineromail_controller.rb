module CatarseDineromail
  module Payment
    class DineromailController < ApplicationController
      before_filter :initialize_dineromail

      def pay
        backer = current_user.backs.find params[:id]
        begin
          data = DineroMailCheckout::CheckoutData.validate {}
          redirect_to DineroMailCheckout::Client.get_url(data)
        rescue Exception => e
          raise e
        end
      end

      protected
      def initialize_dineromail
        DineroMailCheckout.configure do |config|
          config.payment_method = 'all'
          config.merchant = (::Configuration[:dineromail_merchant] || nil)
          config.logo_url = "#{request.protocol}#{request.host_with_port}/assets/logo.png"
          config.success_url = 'TODOOOO'
          config.error_url = 'TODOOOOO'
          config.currency = DineroMailCheckout::Configuration::Currency::CLP
          config.country_id = 2
        end
      end

    end
  end
end

