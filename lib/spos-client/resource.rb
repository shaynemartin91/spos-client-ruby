class Resource
    def initialize(endpoint, client)
        @endpoint = endpoint
        @client = client
    end 
    
    def get(id = nil)
        if(id != nil)
            path = "#{@endpoint}/#{id}"
        else
            path = @endpoint
        end
        
        @client.request(path)
    end
    
    def save(body)
        if(body.is_a?(OpenStruct))
            body = body.to_h
        end
        
        if(body.has_key?("id"))
            path = "#{@endpoint}/#{body['id']}"
        else
            path = @endpoint
        end
        
        @client.request(path, body)
    end
    
end