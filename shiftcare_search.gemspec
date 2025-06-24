Gem::Specification.new do |spec|
  spec.name          = "shiftcare_search"
  spec.version       = "0.1.0"
  spec.authors       = ["Neil Marion dela Cruz"]
  spec.email         = ["nmfdelacruz@gmail.com"]

  spec.summary       = "Client dataset search and duplicate finder"
  spec.description   = "CLI tool to search clients and find duplicate emails from a JSON dataset"
  spec.homepage      = "https://your-repo-url.com"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "bin/*", "clients.json"]
  spec.executables   = ["shiftcare_search"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json"
end
