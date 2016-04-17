# SPOS Client - Ruby

This is a ruby gem for connecting to your SPOS account and using the API. 

## Installation

```
gem install spos-client
```

##Usage

```
require 'spos-client'

order = client.Orders.get(103673)
order.adcode = 'Change the adcode!'

order = client.Orders.save(order)

puts order
```

Resources on the `client` instance are taken from [this list](https://github.com/SparkPay/rest-api/tree/master/resources). Currently, the only methods supported on resources are `get`, `get(id)` and `save(body)`. Filters and fields are to come. The body passed to `save` can either be an OpenStruct such as returned from the api, or a hash.

The rate limit is handled for you by checking for a 429 response and waiting to retry before returning. This will be toggleable a future version if you would like to handle the 429 response yourself instead of sleeping (which may not be the best option in a web app but may be acceptable in a CLI app).