!SLIDE

# Ruby Fast & Scalable (notes)

## Speed vs Throughput
optimize & cache for speed

optimize - Search for slow and make it fast
Cacheing: Search for expensive & make it cheap
Add capacity for throughput

Speed first
Look for N+1 Queries (use Logs)
@products = Product.all

    %li= product.name
    %li= product.price
    %li= product.user.name

problem => many queries in log

Fix with Eager Loading

@products = Product.includes(:user).all

    %li= product.user.name

Look for Queries not using an index.

config/production.rb
config.active_record.auto_explain_threshold_in_seconds = 1

User a Monitoring software;

- New Relic
- Scout

Cache expensive Queries

    Benchmark.measure do
      User.some_expensive_query
    end.real
    => 20 s

Use Memcache & Rails.cache

    Benchmark.measure do
      Rails.cache.fetch("cache_key") do
        User.some_expensive_query
      end
    end.real
    => 20.5 s

slow first time;

    => 0.00001 s

Crazy fast after that

Naming things & cache invalidation
method cacheable gem

    User.cache.some_expensive_query

Scale up 
Scale out
- Don't store state on server
- store it in db

How do we scale data storage
Master DB ->
Slave DB - Slave DB - Slave DB - Slave DB - Slave DB 
Sharding
  cannot join against sharded data
Facebook shareds MySQL
Instagram  shards postresql

postresql beter than MySQL IMHO

NoSQL

CAP Theorem 

Pick two:

- Consistency
- Availability
- Partition tolerance

CDN 
Content Distribution Network
- Serves Images, CSS, Javascript

Turn on Rails Asset fingerprints
config/production.rb
    config.assets.digest = true

hash afile to take its fingerprint

Measure everything;
use YSLow

Compress assets
Serve using CDN
