require "fedex"
require 'active_shipping'
include ActiveMerchant::Shipping

def generate_fedex_quote(shipment)

  user = Client.find(shipment.client_id)
  shipper = {:name => shipment.sender_name,
             :company => shipment.sender_company_name,
             :phone_number => shipment.sender_phone,
             :address => shipment.sender_address,
             :city => shipment.sender_city,
             :state => shipment.sender_state,
             :postal_code => shipment.sender_postal_code,
             :country_code => shipment.sender_country_code}
  recipient = {:name => shipment.receiver_name,
               :company => shipment.receiver_company_name,
               :phone_number => shipment.receiver_phone,
               :address => shipment.receiver_address,
               :city => shipment.receiver_city,
               :state => shipment.receiver_state,
               :postal_code => shipment.receiver_postal_code,
               :country_code => shipment.receiver_country_code,
               :residential => shipment.receiver_residential}
  packages = []

  shipping_details = {:packaging_type => "YOUR_PACKAGING", :drop_off_type => "REGULAR_PICKUP"}


  shipment.items.each do |item|
    packages << {:weight => {:units => item.weight_units, :value => item.weight_value},
                 :dimensions => {:length => item.length, :width => item.width, :height => item.height, :units => item.dimension_units}}
  end

  fedex = Fedex::Shipment.new(:key => user.fedex_key,
                              :password => user.fedex_password,
                              :account_number => user.fedex_account_number.to_s,
                              :meter => user.fedex_meter_number.to_s,
                              :mode => 'development')

  #begin
  rate = fedex.rate({:shipper => shipper, :recipient => recipient, :packages => packages,
                     :service_type => shipment.fedex_service_type, :shipping_details => shipping_details}) #rescue :error
                                                                                                           #shipment.total_net_charges = rate.total_net_charge

                                                                                                           #shipment.total_surcharges = rate.total_surcharges
                                                                                                           #shipment.total_billable_weight = rate.total_billing_weight
                                                                                                           #shipment.total_taxes = rate.total_taxes
end
def active_shipping(shipment)


  # Package up a poster and a Wii for your nephew.
  packages = []

  shipment.items.each do |item|
    packages << Package.new(  (item.weight_value * 16),                 # 7.5 lbs, times 16 oz/lb.
                              [item.length, item.width, item.height],              # 15x10x4.5 inches
                              :units => :imperial)
  end



  # You live in Beverly Hills, he lives in Ottawa
  origin = Location.new(      :country => shipment.sender_country_code,
                              :state => shipment.sender_state,
                              :city => shipment.sender_city,
                              :zip => shipment.sender_postal_code)

  destination = Location.new( :country => shipment.receiver_country_code,
                              :state => shipment.receiver_state,
                              :city => shipment.receiver_city,
                              :zip => shipment.receiver_postal_code)

  # Find out how much it'll be.
  fedex = FedEx.new(:login => '', :password => '',
                     :key => '', :account =>'',:test => true)
  response = fedex.find_rates(origin, destination, packages)
  fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
end

ActiveAdmin.register Shipment do
  menu :priority => 2

filter :id
filter :sender_name
filter :receiver_name
filter :total_net_charges



#action_item :only => :show do
#    @shipment = Shipment.find(params[:id])
#    #value = generate_fedex_quote(@shipment)
#    #@shipment.total_net_charges = value.total_net_charge
#    #@shipment.total_surcharges = value.total_surcharges
#    #@shipment.base_charge = value.total_base_charge
#    #@shipment.provider = value
#    #@shipment.save
#    #redirect_to admin_shipment_path(@shipment), :notice => "Success!"
#end
index do
    column :id
    column :sender_name
    column :sender_phone
    column :receiver_name
    column :receiver_phone
    column :total_net_charges
    column { |shipment| link_to("Details", admin_shipment_path(shipment)) + " | " + \
      link_to("Edit", edit_admin_shipment_path(shipment)) + " | " + \
      link_to("Delete", admin_shipment_path(shipment), :method => :delete, :confirm => "Are you sure?") }
end

show :title => :id do


  @shipment = Shipment.find(params[:id])

  value = generate_fedex_quote(@shipment)
  @shipment.total_net_charges = value.total_net_charge
  @shipment.total_surcharges = value.total_surcharges
  @shipment.base_charge = value.total_base_charge
  ###debug###
  @shipment.provider = value

  #rate =  active_shipping(@shipment)
  #@shipment.rate = rate.to_a
  @shipment.save

  shipment = Shipment.find(params[:id])

    panel "Shipment Details" do
      attributes_table_for shipment do
        row("Shipment Number") { shipment.id }
        row("Status") { status_tag shipment.status, shipment.status_tag }
        row("Package Type") { shipment.fedex_package_types }
        row("Drop-Off Type") { shipment.fedex_dropoff_types }
        #row("Due Date") { invoice.due_date }
      end
    end

    panel "Items" do
      table_for shipment.items do |t|
        t.column("Item No.") { |item| item.id}
        t.column("Weight") { |item| item.weight_value.to_s + " " + item.weight_units.to_s}
        t.column("Height") { |item| item.height.to_s + " " + item.dimension_units.to_s }
        t.column("Width") { |item| item.width.to_s + " " + item.dimension_units.to_s }
        t.column("Length") { |item| item.length.to_s + " " + item.dimension_units.to_s}


        # Show the tax, discount, subtotal and total
        #tr do
        #  2.times { td "" }
        #  td "Discount:", :style => "text-align:right; font-weight: bold;"
        #  td "#{number_with_delimiter(invoice.discount)}%"
        #end
        #
        #tr do
        #  2.times { td "" }
        #  td "Sub-total:", :style => "text-align:right; font-weight: bold;"
        #  td "#{number_to_currency(invoice.subtotal)}%"
        #end
        #
        #tr do
        #  2.times { td "" }
        #  td "Taxes:", :style => "text-align:right; font-weight: bold;"
        #  td "#{number_to_currency(invoice.taxes)} (#{number_with_delimiter(invoice.tax)}%)"
        #end
        #
        #tr do
        #  2.times { td "" }
        #  td "Total:", :style => "text-align:right; font-weight: bold;"
        #  td "#{number_to_currency(invoice.total)}%", :style => "font-weight: bold;"
        #end
      end
    end
   # if(shipment.receiver_residential == 1) then :service_type => "GROUND_HOME_DELIVERY" end



    #rescue
     #redirect_to admin_shipment_path(@shipment), :notice => "Error"
    #ensure

    #end



    panel "FedEx Shipping Details" do
      attributes_table_for shipment do
        row("Service Type") { shipment.fedex_service_type }
        row("Base Charge") { number_to_currency shipment.base_charge }
        row("Total Surcharge") {number_to_currency shipment.total_surcharges }
        #row("Total Billing Weight") { shipment.total_billable_weight }
        #row("Total Taxes") { number_to_currency shipment.total_taxes }
        row("Total Net Charges") {number_to_currency shipment.total_net_charges }
        row("Fedex Response") {shipment.provider}
        #row("Total Discounts") { shipment.total_discounts }
      end
    end
    panel "FEDEX_AS Shipping Details" + shipment.rate  do



    end
        div do
          simple_format shipment.rate[15]
        end

    panel "US Postal Service Shipping Details" do

    end

end

    sidebar "Send To", :only => :show do
      shipment = Shipment.find(params[:id])
      attributes_table_for shipment  do
        row("Name") {shipment.receiver_name}
        row("Company") {shipment.receiver_company_name}
        row("Address") { shipment.receiver_address }
        row("City") { shipment.receiver_city }
        row("State") { shipment.receiver_state }
        row("Postal Code") { shipment.receiver_postal_code }
     end
    end

    sidebar "Total", :only => :show do
      shipment = Shipment.find(params[:id])
      attributes_table_for shipment do
        h1 number_to_currency(shipment.total_net_charges), :style => "text-align: center; margin-top: 20px"
      end

    end


  form do |f|

    f.inputs "Sender Information" do
      f.input :client, :as => :check_boxes
      f.input :sender_name
      f.input :sender_company_name
      f.input :sender_phone
      f.input :sender_address
      f.input :sender_city
      f.input :sender_state, :as => :select, :collection => ['AL','AK' ,'AS' ,'AZ' ,'AR' ,'CA' ,'CO' ,'CT' ,'DE' ,'DC' ,'FM' ,'FL' ,'GA' ,'GU' ,'HI' ,'ID' ,'IL' ,'IN' ,'IA' ,'KS' ,'KY' ,'LA' ,'ME' ,'MH' ,'MD' ,'MA' ,'MI' ,'MN' ,'MS' ,'MO' ,'MT' ,'NE' ,'NV' ,'NH' ,'NJ' ,'NM' ,'NY' ,'NC' , 'ND', 'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI','SC' ,'SD' ,'TN' ,'TX' ,'UT' ,'VT' ,'VI' ,'VA' ,'WA','WV','WI','WY']
      f.input :sender_postal_code
      f.input :sender_country_code
    end


    f.inputs "Receiver Information" do
      f.input :receiver_name
      f.input :receiver_company_name
      f.input :receiver_phone
      f.input :receiver_address
      f.input :receiver_city
      f.input :receiver_state, :as => :select, :collection => ['AL','AK' ,'AS' ,'AZ' ,'AR' ,'CA' ,'CO' ,'CT' ,'DE' ,'DC' ,'FM' ,'FL' ,'GA' ,'GU' ,'HI' ,'ID' ,'IL' ,'IN' ,'IA' ,'KS' ,'KY' ,'LA' ,'ME' ,'MH' ,'MD' ,'MA' ,'MI' ,'MN' ,'MS' ,'MO' ,'MT' ,'NE' ,'NV' ,'NH' ,'NJ' ,'NM' ,'NY' ,'NC' , 'ND', 'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI','SC' ,'SD' ,'TN' ,'TX' ,'UT' ,'VT' ,'VI' ,'VA' ,'WA','WV','WI','WY']
      f.input :receiver_postal_code
      f.input :receiver_country_code
      f.input :receiver_residential, :as => :boolean, :label => "Residential Location", :hint => "Service type is automatically set to Ground Home Delivery"
    end
    f.inputs "Shipping Options" do
      f.input :status, :collection => Shipment.status_collection, :as => :radio
      f.input :fedex_service_type, :as => :select, :collection => ["ALL SERVICES",
                                                                   #"FEDEX_1_DAY_FREIGHT",
                                                                   "FEDEX_2_DAY",
                                                                   "FEDEX_2_DAY_AM",
                                                                  # "FEDEX_2_DAY_FREIGHT",
                                                                  # "FEDEX_3_DAY_FREIGHT",
                                                                  # "FEDEX_EXPRESS_SAVER",
                                                                   #"FEDEX_FIRST_FREIGHT",
                                                                   #"FEDEX_FREIGHT_ECONOMY",
                                                                   #"FEDEX_FREIGHT_PRIORITY",
                                                                   "FEDEX_GROUND",
                                                                   "FIRST_OVERNIGHT",
                                                                   "GROUND_HOME_DELIVERY",
                                                                   #"INTERNATIONAL_ECONOMY",
                                                                   #"INTERNATIONAL_ECONOMY_FREIGHT",
                                                                   #"INTERNATIONAL_FIRST",
                                                                   #"INTERNATIONAL_PRIORITY",
                                                                   #"INTERNATIONAL_PRIORITY_FREIGHT",
                                                                   "PRIORITY_OVERNIGHT",
                                                                  # "SMART_POST",
                                                                   "STANDARD_OVERNIGHT",
                                                                 #  "EUROPE_FIRST_INTERNATIONAL_PRIORITY"
                                                                 ]

      f.input :fedex_package_types, :as => :select, :collection => ["FEDEX_10KG_BOX", "FEDEX_25KG_BOX", "FEDEX_BOX", "FEDEX_ENVELOPE", "FEDEX_PAK", "FEDEX_TUBE", "YOUR_PACKAGING"]
      f.input :fedex_dropoff_types, :as => :select, :collection => ["BUSINESS_SERVICE_CENTER", "DROP_BOX", "REGULAR_PICKUP", "REQUEST_COURIER", "STATION"]
    end

    f.inputs "Packages" do
      f.has_many :items do |i|
        i.input :_destroy, :as => :boolean, :label => "Delete this item" unless i.object.id.nil?
        i.input :weight_value
        i.input :weight_units, :as => :select, :collection => ["LB","KG"]
        i.input :width
        i.input :length
        i.input :height
        i.input :dimension_units, :as => :select, :collection => ["IN","CM"]
        #i.input :service_type, :as => :radio, :collection => ["ALL SERVICES","FEDEX_1_DAY_FREIGHT","FEDEX_2_DAY","FEDEX_2_DAY_AM","FEDEX_2_DAY_FREIGHT", "FEDEX_3_DAY_FREIGHT","FEDEX_EXPRESS_SAVER","FEDEX_FIRST_FREIGHT","FEDEX_FREIGHT_ECONOMY","FEDEX_FREIGHT_PRIORITY","FEDEX_GROUND","FIRST_OVERNIGHT","GROUND_HOME_DELIVERY","INTERNATIONAL_ECONOMY","INTERNATIONAL_ECONOMY_FREIGHT","INTERNATIONAL_FIRST","INTERNATIONAL_PRIORITY","INTERNATIONAL_PRIORITY_FREIGHT","PRIORITY_OVERNIGHT","SMART_POST","STANDARD_OVERNIGHT","EUROPE_FIRST_INTERNATIONAL_PRIORITY"]

      end
    end

    #f.inputs "Options" do
    #  f.input :code, :hint => "The invoice's code, should be incremental. Suggested code: #{Invoice.suggest_code}"
    #  f.input :status, :collection => Invoice.status_collection, :as => :radio
    #  f.input :due_date
    #  f.input :tax, :input_html => { :style => "width: 30px"}, :hint => "This should be a percentage, from 0 to 100 (without the % sign)"
    #  f.input :discount, :input_html => { :style => "width: 30px"}, :hint => "This should be a percentage, from 0 to 100 (without the % sign)"
    #end
    #
    #f.inputs "Other Fields" do
    #  f.input :terms, :input_html => { :rows => 4 }, :label => "Terms & Conditions"
    #  f.input :notes, :input_html => { :rows => 4 }
    #end

    f.buttons


  end
end
