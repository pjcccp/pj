ActiveAdmin.register Client do
  filter :name
  filter :email
  filter :address
  filter :phone
  

  
  show :title => :name do
    panel "Client Details" do
      attributes_table_for client do
        row("Name") { client.name }
        row("Email") { mail_to client.email }
        row("Address") { client.address }
        row("City") {client.city}
        row("State"){client.state}
        row("Postal Code"){client.postal_code}
        row("Country"){client.country_code}
        row("Phone") { client.phone }
      end
    end
  end
  sidebar "FedEx Account Details", :only => :show do
        attributes_table_for client do
          row("Account Number") { client.fedex_account_number }
          row("Key") {client.fedex_key }
          row("Password") { client.fedex_password }
          row("Meter Number") {client.fedex_meter_number}
        end

      end

  sidebar "Total Billed", :only => :show do
    h1 number_to_currency(Invoice.where(:client_id => client.id).all.sum(&:total)), :style => "text-align: center; margin-top: 20px;"
  end
  
  sidebar "Latest Invoices", :only => :show do
    table_for Invoice.where(:client_id => client.id).order('created_at desc').limit(5).all do |t|
      t.column("Status") { |invoice| status_tag invoice.status, invoice.status_tag }
      t.column("Code") { |invoice| link_to "##{invoice.code}", admin_invoice_path(invoice) }
      t.column("Total") { |invoice| number_to_currency invoice.total }
    end
  end
end
