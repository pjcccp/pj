ActiveAdmin.register AdminUser, :as => "User" do
    filter :id
    #filter :name
    filter :email
    filter :last_sign_in_at
  
  index do
    column :id
    #column :name
    column :email
    column "Last Sign in", :last_sign_in_at
    column do |user|
      delete = " | " + link_to("Delete", admin_user_path(user), :method => :delete, :confirm => "Are you sure?") unless current_admin_user == user
      
      link_to("Details", admin_user_path(user)) + " | " + \
      link_to("Edit", edit_admin_user_path(user)) + delete.try(:html_safe)
    end
  end
  

  show :title => :id do
    panel "User Details" do
      attributes_table_for user do
        row("ID") { user.id }
        row("Email") { mail_to user.email }
    #    row("Address") { user.address }
    #    row("City") {user.city}
    #    row("State"){user.state}
    #    row("Postal Code"){user.postal_code}
    #    row("Country"){user.country_code}
    #    row("Phone") { user.phone_number }
      end
    end

  end
  
  form do |f|
    f.inputs do
      #f.input :name
      #f.input :address
      #f.input :city
      #f.input :state
      #f.input :postal_code
      #f.input :country_code
      #f.input :phone_number

      f.input :email
      f.input :password, :type => :password
      f.input :password_confirmation, :type => :password
    end
    
    f.buttons
  end
end
