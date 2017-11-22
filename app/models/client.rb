class Client < ActiveRecord::Base
  validates_presence_of :name, :email
  validates_format_of :email, with: ->(user) { user.email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/) ? /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ : /([Nn]\/[Aa])+/ }

  belongs_to :user

  def self.store(params, tmp_password, account_id)
    ActiveRecord::Base.transaction do
      @user = User.new(params)
      @user.account_id = account_id
      @user.password = tmp_password
      if @user.save
        @client = Client.new(params)
        @client.user_id = @user.id
        @client.account_id = account_id
        if @client.save
          customer_role = Role.find_by(account_id: account_id, name: "Customer")
          RoleUser.create(account_id: account_id, role_id: customer_role.id , user_id: @user.id) if customer_role
          #UserMail.send_email_password(@client.name, @client.email, 'New User oomovers', tmp_password).deliver_later
          return @client
        else
          raise @client.errors.full_messages.to_json
        end
      else
        raise @user.errors.full_messages.to_json
      end
    end
  end

  def self.store_only_client(params, user)
    ActiveRecord::Base.transaction do
        @client = Client.new(params)
        @client.user_id = user.id
        @client.account_id = user.account_id
        if @client.save
          return @client
        else
          raise @client.errors.full_messages.to_json
        end
    end
  end

end
