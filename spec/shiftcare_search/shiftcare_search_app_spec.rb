# spec/shiftcare_search/shiftcare_search_app_spec.rb
require "spec_helper"
require "stringio"
require "json"
require_relative "../../lib/shiftcare_search/shiftcare_search_app"

RSpec.describe ShiftcareSearch::ShiftcareSearchApp do
  let(:test_data) do
    [
      { "id" => 1, "name" => "John Smith", "full_name" => "John Smith", "email" => "john@example.com" },
      { "id" => 2, "name" => "Jane Doe", "full_name" => "Jane Doe", "email" => "jane@example.com" },
      { "id" => 3, "name" => "Johnny Smith", "full_name" => "Johnny Smith", "email" => "john@example.com" }
    ]
  end

  let(:json_file_path) { "spec/fixtures/test_clients.json" }

  before do
    FileUtils.mkdir_p("spec/fixtures")
    File.write(json_file_path, JSON.pretty_generate(test_data))
  end

  after do
    FileUtils.rm_f(json_file_path)
  end

  subject { described_class.new(json_file_path) }

  describe "#search" do
    it "prints results matching the query" do
      expect {
        subject.search("smith")
      }.to output(/John Smith.*Johnny Smith/).to_stdout
    end

    it "prints no data found when there is no match" do
      expect {
        subject.search("notfound")
      }.to output(/No data found matching 'notfound'/).to_stdout
    end
  end

  describe "#find_dupes" do
    it "prints duplicate emails" do
      expect {
        subject.find_dupes
      }.to output(/Duplicate Emails Found:.*john@example.com/m).to_stdout
    end

    it "prints no duplicates if none found" do
      unique_data = test_data.uniq { |d| d["email"] }
      File.write(json_file_path, JSON.pretty_generate(unique_data))
      app = described_class.new(json_file_path)

      expect {
        app.find_dupes
      }.to output(/No duplicate emails found/).to_stdout
    end
  end
end
