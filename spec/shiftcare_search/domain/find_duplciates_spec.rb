require "spec_helper"
require_relative "../../../lib/shiftcare_search/domain/find_duplicates"

RSpec.describe ShiftcareSearch::Domain::FindDuplicates do
  let(:data) do
    [
      { "id" => 1, "full_name" => "Jane Smith", "email" => "jane@example.com" },
      { "id" => 2, "full_name" => "Another Jane", "email" => "jane@example.com" },
      { "id" => 3, "full_name" => "John Doe", "email" => "john@example.com" }
    ]
  end

  subject { described_class.new(data: data) }

  describe "#find_dupes" do
    it "returns a hash of duplicate emails with their associated records" do
      duplicates = subject.find_dupes

      expect(duplicates).to have_key("jane@example.com")
      expect(duplicates["jane@example.com"].size).to eq(2)
      expect(duplicates["jane@example.com"].map { |d| d["id"] }).to contain_exactly(1, 2)
    end

    it "does not include unique emails" do
      duplicates = subject.find_dupes
      expect(duplicates).not_to have_key("john@example.com")
    end

    it "returns empty hash when there are no duplicates" do
      unique_data = data.uniq { |d| d["email"] }
      service = described_class.new(data: unique_data)

      expect(service.find_dupes).to be_empty
    end
  end
end
