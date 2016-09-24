require_relative './resource'

class OrderResource < Resource
  def change_status(order_id, status_id)
    self.custom("#{@endpoint}/#{order_id}/status", {:order_status_id => status_id}, nil, "PUT")
  end

  def add_shipment(order_id, shipment)
    self.custom("#{@endpoint}/#{order_id}/shipments", shipment)
  end
end