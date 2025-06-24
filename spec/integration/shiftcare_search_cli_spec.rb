require "spec_helper"
require "json"
require "open3"

RSpec.describe "shiftcare_search CLI" do
  let(:cli_path) { File.expand_path("../../../bin/shiftcare_search", __FILE__) }
  let(:data) do
    [
      { "id" => 1, "full_name" => "John Smith", "email" => "john@example.com" },
      { "id" => 2, "full_name" => "Jane Doe", "email" => "jane@example.com" },
      { "id" => 3, "full_name" => "Johnny Smith", "email" => "john@example.com" }
    ]
  end
  let(:json_file_path) { "spec/fixtures/integration_clients.json" }

  before do
    FileUtils.mkdir_p("spec/fixtures")
    File.write(json_file_path, JSON.pretty_generate(data))
    FileUtils.chmod("+x", cli_path)
  end

  after do
    FileUtils.rm_f(json_file_path)
  end

  it "runs a search from the CLI and returns matching results" do
    stdout, stderr, status = Open3.capture3("#{cli_path} --file=#{json_file_path} search Smith")

    expect(status.success?).to be true
    expect(stdout).to include("John Smith", "Johnny Smith")
    expect(stderr).to eq("")
  end

  it "runs a duplicate check and returns duplicate emails" do
    stdout, _, status = Open3.capture3("#{cli_path} --file=#{json_file_path} duplicates")

    expect(status.success?).to be true
    expect(stdout).to include("Duplicate Emails Found:", "john@example.com")
  end

  it "errors if no --file is given" do
    stdout, stderr, status = Open3.capture3("#{cli_path} search Smith")

    expect(status.success?).to be false
    expect(stdout).to include("Error: You must provide a JSON file using --file")
  end
end
