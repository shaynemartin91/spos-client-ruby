require_relative './resource'

class EmailTemplateResource < Resource
  def send(id, body)
    self.custom("#{@endpoint}/#{id}/send", body)
  end
end