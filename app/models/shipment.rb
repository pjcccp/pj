class Shipment < ActiveRecord::Base

  STATUS_DRAFT = 'draft'
  STATUS_PROCESSED  = 'processed'
  STATUS_SHIPPED  = 'shipped'

  belongs_to :client
  belongs_to :invoice

  has_many :items, :dependent => :destroy
  accepts_nested_attributes_for :items, :allow_destroy => true
  class Fedex_Rate

  end
  class << self
    def suggest_code
      invoice = order('created_at desc').limit(1).first
      if invoice
        "INV-#{invoice.id + 1}"
      else
        "INV-1"
      end
    end


    def redirect
      redirect_to admin_shipment_path(self), :notice => "ERROR"
    end

    def status_collection
      {
        "Draft" => STATUS_DRAFT,
        "Processed" => STATUS_PROCESSED,
        "Shipped" => STATUS_SHIPPED
      }
    end

    def this_month
      where('created_at >= ?', Date.new(Time.now.year, Time.now.month, 1).to_datetime)
    end
  end

  def items_total
    items_total = 0
    self.items.each do |i|
      items_total += i.total
    end
    items_total
  end

  def total
    items_total * (1 - self.discount / 100) * (1 + self.tax / 100)
  end

  def subtotal
    items_total * (1 - self.discount / 100)
  end

  def taxes
    subtotal * (self.tax / 100)
  end

  def status_tag
    case self.status
      when STATUS_DRAFT then :error
      when STATUS_PROCESSED then :warning
      when STATUS_SHIPPED then :ok
    end
  end

  def invoice_location
    "#{Rails.root}/pdfs/invoice-#{self.code}.pdf"
  end
end

