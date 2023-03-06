
require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  let(:user) { FactoryBot.create(:user) }

  describe "account_activation" do
    
  #account_activationの引数を忘れないこと!!
    let(:mail) { UserMailer.account_activation(user) }

    it "ヘッダーの描画" do
      expect(mail.subject).to eq "Account activation"
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["user@realdomain.com"])
    end

    it "ボディの描画" do
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
   # CGIモジュールのescapeメソッドを使用している。
   # @が%40に変換される
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end

   # ここからが今回のテストです。
   describe "password_reset" do
    # 下の一文を忘れないこと!!
      before { user.reset_token = User.new_token }
  
      let(:mail) { UserMailer.password_reset(user) }
  
      it "renders the headers" do
        expect(mail.subject).to eq("Password reset")
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["user@realdomain.com"])
      end
  
      it "renders the body" do
        expect(mail.body.encoded).to match user.reset_token
        expect(mail.body.encoded).to match CGI.escape(user.email)
      end
    end
end