require 'net/http'
require 'json'
require 'ostruct'
require 'time'
require_relative './spos-client/resource'
require_relative './spos-client/time-helpers'

class SPOSClient
    attr_reader :Products, :Orders, :Customers, :OrderAddresses 

    def initialize(domain, token)
        @domain = domain
        @token = token
        
        @Products = Resource.new "products", self
        @Orders = Resource.new "orders", self
        @Customers = Resource.new "customers", self
        @OrderAddresses = Resource.new "order_addresses", self
    end
    
    def request(path, body = nil)
        uri = URI.parse("https://#{@domain}/api/v1/#{path}")
        
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        
        if(body.nil?)
            request = Net::HTTP::Get.new(uri.request_uri)
        else
            if(body.has_key?("id"))
                request = Net::HTTP::Put.new(uri.request_uri)
            else
                request = Net::HTTP::Post.new(uri.request_uri)
            end
            
            request.add_field('Content-Type', 'application/json')
            request.body = body.to_json
        end
        
        request['X-AC-Auth-Token'] = @token 
        response = http.request(request)
        
        body = JSON.parse(JSON.parse(response.body).to_json, object_class: OpenStruct)
    
        if body.status_code === 429
            retrytime = 
            time = Time.now.time_until(Time.parse(response['Retry-After']))
            sleep (time/1000)
            body = request(path)
        end
        
        body
    end
end