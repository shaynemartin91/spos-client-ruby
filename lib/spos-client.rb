require 'net/http'
require 'json'
require 'ostruct'
require 'time'
require_relative './spos-client/resource'
require_relative './spos-client/EmailTemplate'
require_relative './spos-client/Order'
require_relative './spos-client/time-helpers'

class SPOSClient
    attr_reader :Adcodes, :Addresses, :Affiliates, :AttributeGroups, :Attributes, :BlogCategories, :BlogPosts, :Blogs, :CartItems, :Carts, :Categories, :CouponCodes, :CreditCards, :CustomFieldValues, :CustomFields, :CustomShippingMethods, :CustomerPaymentMethods, :CustomerTypes, :Customers, :DiscountMethods, :DiscountRules, :Drips, :EmailTemplates, :GiftCertificateTransactions, :GiftCertificates, :Inventory, :Links, :MailingLists, :Manufacturers, :OrderAddresses, :OrderItems, :OrderPayments, :OrderShipments, :OrderStatuses, :Orders, :Pages, :PaymentMethods, :ProductLists, :ProductPictures, :ProductReviews, :ProductStatuses, :ProductVariants, :Products, :Profiles, :Quotes, :Regions, :Sessions, :ShippingProviders, :ShippingRateAdjustments, :Stores, :Subscriptions, :TaxRates, :UrlRedirects, :Users, :VariantGroups, :VariantInventory, :Warehouses, :Webhooks, :Wishlists 

    def initialize(domain, token)
        @domain = domain
        @token = token
        
        @Adcodes = Resource.new "adcodes", self
        @Addresses = Resource.new "addresses", self
        @Affiliates = Resource.new "affiliates", self
        @AttributeGroups = Resource.new "attribute_groups", self
        @Attributes = Resource.new "attributes", self
        @BlogCategories = Resource.new "blog_categories", self
        @BlogPosts = Resource.new "blog_posts", self
        @Blogs = Resource.new "blogs", self
        @CartItems = Resource.new "cart_items", self
        @Carts = Resource.new "carts", self
        @Categories = Resource.new "categories", self
        @CouponCodes = Resource.new "coupon_codes", self
        @CreditCards = Resource.new "credit_cards", self
        @CustomFieldValues = Resource.new "custom_field_values", self
        @CustomFields = Resource.new "custom_fields", self
        @CustomShippingMethods = Resource.new "custom_shipping_methods", self
        @CustomerPaymentMethods = Resource.new "customer_payment_methods", self
        @CustomerTypes = Resource.new "customer_types", self
        @Customers = Resource.new "customers", self
        @DiscountMethods = Resource.new "discount_methods", self
        @DiscountRules = Resource.new "discount_rules", self
        @Drips = Resource.new "drips", self
        @EmailTemplates = EmailTemplateResource.new "email_templates", self
        @GiftCertificateTransactions = Resource.new "gift_certificate_transactions", self
        @GiftCertificates = Resource.new "gift_certificates", self
        @Inventory = Resource.new "inventory", self
        @Links = Resource.new "links", self
        @MailingLists = Resource.new "mailing_lists", self
        @Manufacturers = Resource.new "manufacturers", self
        @OrderAddresses = Resource.new "order_addresses", self
        @OrderItems = Resource.new "order_items", self
        @OrderPayments = Resource.new "order_payments", self
        @OrderShipments = Resource.new "order_shipments", self
        @OrderStatuses = Resource.new "order_statuses", self
        @Orders = OrderResource.new "orders", self
        @Pages = Resource.new "pages", self
        @PaymentMethods = Resource.new "payment_methods", self
        @ProductLists = Resource.new "product_lists", self
        @ProductPictures = Resource.new "product_pictures", self
        @ProductReviews = Resource.new "product_reviews", self
        @ProductStatuses = Resource.new "product_statuses", self
        @ProductVariants = Resource.new "product_variants", self
        @Products = Resource.new "products", self
        @Profiles = Resource.new "profiles", self
        @Quotes = Resource.new "quotes", self
        @Regions = Resource.new "regions", self
        @Sessions = Resource.new "sessions", self
        @ShippingProviders = Resource.new "shipping_providers", self
        @ShippingRateAdjustments = Resource.new "shipping_rate_adjustments", self
        @Stores = Resource.new "stores", self
        @Subscriptions = Resource.new "subscriptions", self
        @TaxRates = Resource.new "tax_rates", self
        @UrlRedirects = Resource.new "url_redirects", self
        @Users = Resource.new "users", self
        @VariantGroups = Resource.new "variant_groups", self
        @VariantInventory = Resource.new "variant_inventory", self
        @Warehouses = Resource.new "warehouses", self
        @Webhooks = Resource.new "webhooks", self
        @Wishlists = Resource.new "wishlists", self
    end
    
    def parse_query(opts)
        if(opts.nil?)
            return ""
        end

        queries = []

        opts.each do |key, value|
            unless(value.nil?)
                queries << "#{key}=#{value}"
            end
        end

        "?#{queries.join('&')}"
    end

    def request(path, body = nil, opts = nil, method = nil)
        query = self.parse_query(opts)
        uri = URI.parse("https://#{@domain}/api/v1/#{path}#{query}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        
        if(body.nil?)
            request = Net::HTTP::Get.new(uri.request_uri)
        else
            if(body.has_key?("id"))
                request = Net::HTTP::Put.new(uri.request_uri)
            else
                case method
                    when "GET"
                        request = Net::HTTP::Get.new(uri.request_uri)
                    when "PUT"
                        request = Net::HTTP::Put.new(uri.request_uri)
                    else
                        request = Net::HTTP::Post.new(uri.request_uri)
                end
            end
            
            request.add_field('Content-Type', 'application/json')
            request.body = body.to_json
        end
        
        request['X-AC-Auth-Token'] = @token 
        response = http.request(request)
        
        if(response.nil? || response.body.nil?)
            body = nil
        else
            body = JSON.parse(JSON.parse(response.body).to_json, object_class: OpenStruct)    
        end

        
    
        if !body.nil? && body.status_code === 429 
            time = Time.now.time_until(Time.parse(response['Retry-After']))
            sleeptime = (time/1000) 
            
            if(sleeptime > 0)
                sleep sleeptime
            end
            
            body = request(path)
        end
        
        body
    end
end