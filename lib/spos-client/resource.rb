class Resource
    def initialize(endpoint, client)
        @endpoint = endpoint
        @client = client
    end 
    
    def get(opts = nil)
        if(!opts.nil? && opts.has_key?("id"))
            getById(opts[:id])
        else
            getMany(opts)
        end
    end
    
    def getById(id, filled = false)
        fill = filled ? "/filled" : ""
        @client.request("#{@endpoint}/#{id}#{fill}")
    end
    
    def getMany(opts)
        @client.request(@endpoint, nil, opts)
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