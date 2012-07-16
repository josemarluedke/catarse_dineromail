require 'spec_helper'

describe CatarseDineromail::Payment::DineromailController do

  describe "notifications" do
    it "should 404 status code when not passed the 'Notification' param" do
      post :notifications, {use_route: :catarse_dineromail}
      response.status.should == 404
    end

    it "should 200 status code when pass the 'Notification' param" do
      post :notifications, {Notificacion: fixture_file("dineromail_ipn_request.xml"), use_route: :catarse_dineromail}
      response.status.should == 200
    end

    it "should confirm the backer" do
      backer = Factory(:backer, payment_token: "ade4206f68ce02024ae1", confirmed: false)
      backer.confirmed.should be_false
      stub_post("/Vender/Consulta_IPN.asp", "dineromail_ipn_response.xml", {:url => {:https => false}, country: DineroMailCheckout::Configuration.country_name(::Configuration[:dineromail_country_id])})
      post :notifications, {Notificacion: fixture_file("dineromail_ipn_request.xml"), use_route: :catarse_dineromail}
      backer.reload
      backer.confirmed.should be_true
    end
  end

  describe "pay" do
    it "should redirect" do
      get :pay, {id: Factory(:backer, confirmed: false), use_route: :catarse_dineromail}
      response.should be_redirect
    end
  end

  describe "success" do
    it "should redirect" do
      get :success, {id: Factory(:backer), use_route: :catarse_dineromail}
      response.should be_redirect
    end
  end

  describe "error" do
    it "should redirect" do
      backer = Factory(:backer)
      get :success, {id: backer, use_route: :catarse_dineromail}
      response.should be_redirect
    end
  end


end
