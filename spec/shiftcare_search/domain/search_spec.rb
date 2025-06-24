require "spec_helper"
require_relative "../../../lib/shiftcare_search/domain/search"

RSpec.describe ShiftcareSearch::Domain::Search do
  let(:data) do
    [
      { "id" => 1, "full_name" => "John Doe", "email" => "john@example.com" },
      { "id" => 2, "full_name" => "Jane Smith", "email" => "jane@example.com" },
      { "id" => 3, "full_name" => "Johnny Appleseed", "email" => "johnny@example.com" }
    ]
  end

  subject { described_class.new(data: data) }

  describe "#search" do
    it "finds exact match by name" do
      results = subject.search("John Doe")
      expect(results.map { |r| r["id"] }).to eq([1])
    end

    it "is case-insensitive" do
      results = subject.search("jOhN dOe")
      expect(results.map { |r| r["id"] }).to eq([1])
    end

    it "finds partial matches" do
      results = subject.search("john")
      expect(results.map { |r| r["id"] }).to contain_exactly(1, 3)
    end

    it "returns empty when no match found" do
      results = subject.search("Nonexistent")
      expect(results).to be_empty
    end
  end
end
