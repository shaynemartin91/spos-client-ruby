class Resource
    def initialize(endpoint, client)
        @endpoint = endpoint
        @client = client
    end 
    
    def get(id = nil)
        if(id != nil)
            getById(id)
        else
            getMany
        end
    end
    
    def getById(id, filled = false)
        fill = filled ? "/filled" : ""
        @client.request("#{@endpoint}/#{id}#{fill}")
    end
    
    def getMany()
        @client.request(@endpoint)
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