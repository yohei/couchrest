require File.dirname(__FILE__) + '/../../spec_helper'
require File.join(FIXTURE_PATH, 'more', 'card')

# add a default value
Card.property :bg_color, :default => '#ccc'

class BusinessCard < Card
  property :extension_code
  property :job_title
end

class DesignBusinessCard < BusinessCard
  property :bg_color, :default => '#eee'
end


describe "Subclassing an ExtendedDocument" do
  
  before(:each) do
    @card = BusinessCard.new
  end
  
  it "shouldn't messup the parent's properties" do
    Card.properties.should_not == BusinessCard.properties
  end
  
  it "should share the same db default" do
    @card.database.uri.should == Card.database.uri
  end
  
  it "should share the same autovalidation details" do
    @card.auto_validation.should be_true
  end
  
  it "should have kept the validation details" do
    @card.should_not be_valid
  end
  
  it "should have added the new validation details" do
    validated_fields = @card.class.validators.contexts[:default].map{|v| v.field_name}
    validated_fields.should include(:extension_code) 
    validated_fields.should include(:job_title)
  end
  
  it "should inherit default property values" do
    @card.bg_color.should == '#ccc'
  end
  
  it "should be able to overwrite a default property" do
    DesignBusinessCard.new.bg_color.should == '#eee'
  end
  
end

