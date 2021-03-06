require 'test_helper'
require 'httparty'

describe EdamamApiWrapper do
  describe "find_recipes" do
    it "Can find all recipes that match a search" do
      VCR.use_cassette("list_all") do
        search = EdamamApiWrapper.find_recipes("chicken")
        search.must_be_instance_of Search
        search.hits.length.must_be :>, 0
      end
    end

    it "will return empty array for broken request" do
      VCR.use_cassette("list_all") do
        search = EdamamApiWrapper.find_recipes("there is no way mummies cats broken glass")
        search.must_be_instance_of Search
        search.hits.count.must_equal 0
      end
    end
  end

  describe "show recipe" do
    it "Can find one specific recipe using the URI" do
      VCR.use_cassette("list_one_recipe") do
        search = EdamamApiWrapper.find_recipes("lemon")
        uri = URI.escape(search.hits[0]['recipe']['uri'])
        find_one = EdamamApiWrapper.show_recipe(uri)
        find_one.must_be_instance_of HTTParty::Response
      end
    end

    it "returns nil for an invalid uri" do
      VCR.use_cassette("list_one_recipe") do
        search = EdamamApiWrapper.find_recipes("lemon")
        uri = search.hits[0]['recipe']['uri']
        find_one = EdamamApiWrapper.show_recipe(uri)
        find_one.must_equal nil
      end
    end
  end
end
