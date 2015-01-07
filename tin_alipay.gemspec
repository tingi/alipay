$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tin_alipay/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tin_alipay"
  s.version     = TinAlipay::VERSION
  s.authors     = ["tin"]
  s.email       = ["107191613@qq.com"]
  s.homepage    = "https://github.com/tingi/tin_alipay"
  s.summary     = "The alipay directly payment web&mobile gem."
  s.description = "The alipay directly payment web&mobile gem."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"
  s.add_dependency "fakeweb"
  s.add_development_dependency "sqlite3"
end
