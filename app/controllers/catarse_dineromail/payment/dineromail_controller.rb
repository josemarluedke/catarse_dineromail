module CatarseDineromail
  module Payment
    class DineromailController < ApplicationController
      before_filter :initialize_dineromail
      SCOPE = "projects.backers.checkout"

      def pay
        begin
          backer = current_user.backs.not_confirmed.find params[:id]
          if backer
            transaction_id = (Digest::MD5.hexdigest "#{SecureRandom.hex(5)}-#{DateTime.now.to_s}")[1..20].downcase
            backer.update_attribute :payment_method, 'Dineromail'
            backer.update_attribute :payment_token, transaction_id
            data = DineroMailCheckout::CheckoutData.validate({item_name_1: t('paypal_description', scope: SCOPE),
                                                              item_quantity_1: 1,
                                                              item_currency_1: DineroMailCheckout.configuration.currency,
                                                              change_quantity: 0,
                                                              item_ammount_1: backer.moip_value,
                                                              buyer_name: backer.user.name,
                                                              buyer_phone: backer.user.phone_number,
                                                              buyer_email: backer.user.email,
                                                              ok_url: success_payment_dineromail_url(backer),
                                                              error_url: error_payment_dineromail_url(backer),
                                                              transaction_id: transaction_id})
            redirect_to DineroMailCheckout::Client.get_uri(data)
          end
        rescue Exception => e
          Airbrake.notify({ :error_class => "Dineromail Error", :error_message => "Dineromail Error: #{e.inspect}", :parameters => params}) rescue nil
          Rails.logger.info "-----> #{e.inspect}"
          flash[:failure] = t('paypal_error', scope: SCOPE)
          return redirect_to main_app.new_project_backer_path(backer.project)
        end
      end

      def success
        backer = current_user.backs.find params[:id]
        session[:thank_you_id] = backer.project.id
        session[:_payment_token] = backer.payment_token

        flash[:success] = t('success', scope: SCOPE)
        redirect_to main_app.thank_you_path
      end

      def error
        backer = current_user.backs.find params[:id]
        flash[:failure] = t('paypal_error', scope: SCOPE)
        redirect_to main_app.new_project_backer_path(backer.project)
      end

      def notifications
        notification = params[:Notificacion]
        return render(status: 404, nothing: true) if notification.nil?

        xml = Nokogiri::XML(notification)
        ids = []
        xml.xpath("//OPERACION//ID").each {|o| ids << o.children.text}

        c = DineroMailIpn::Client.new(account: ::Configuration[:dineromail_merchant], password: ::Configuration[:dineromail_ipn_password], pais: DineroMailCheckout::Configuration.country_name(::Configuration[:dineromail_country_id]))
        reports = c.consulta_transacciones(ids).reports
        if reports
          reports.each do |report|
            begin
              backer = Backer.not_confirmed.where(payment_token: report.id).first
              backer.confirm! if backer and report.transaction_completed?
            rescue Exception => e
              Rails.logger.info "-----> #{e.inspect}"
            end
          end
        end
        render nothing: true
      end

      protected
      def initialize_dineromail
        DineroMailCheckout.configure do |config|
          config.payment_method = 'all'
          config.merchant = (::Configuration[:dineromail_merchant] || nil)
          config.logo_url = "#{request.protocol}#{request.host_with_port}/assets/logo.png"
          config.currency = DineroMailCheckout::Configuration::Currency::USD
          config.country_id = ::Configuration[:dineromail_country_id]
        end
      end

    end
  end
end

