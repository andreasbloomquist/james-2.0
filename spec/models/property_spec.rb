require 'rails_helper'

RSpec.describe Property, :type => :model do
  
  context 'Validation' do
    let(:property) do
      #create a property in memory
      Property.new({
        address: '123 test street',
        sub_market: 'Soma',
        property_type: 'Creative',
        sq_ft: 15000,
        available: Time.now,
        min: 12,
        max: 24,
        broker_id: 1,
        lead_id: 1,
        rent_price: 65,
        image_url: nil
      })
    end
    
    it 'validates presence of address' do
      property.address = nil
      expect(property).not_to be_valid
    end

    it 'validates presence of sub_market' do
      property.sub_market = nil
      expect(property).not_to be_valid
    end

    it 'validates presence of property_type' do
      property.property_type = nil
      expect(property).not_to be_valid
    end

    it 'validates presence of sq_ft' do
      property.sq_ft = nil
      expect(property).not_to be_valid
    end

    it 'validates presence of available' do
      property.available = nil
      expect(property).not_to be_valid
    end

    it 'allows for nil image_url' do
      expect(property).to be_valid
    end
  end

  context 'Initialization' do
    let(:property) { Property.new }

    it 'allows for adding adddress' do
      expect(property).to respond_to(:address=).with(1).argument
    end

    it 'allows for getting of an address' do
      expect(property).to respond_to(:address)
    end

    it 'allows for adding sub_market' do
      expect(property).to respond_to(:sub_market=).with(1).argument
    end

    it 'allows for getting of an sub_market' do
      expect(property).to respond_to(:sub_market)
    end

    it 'allows for adding property_type' do
      expect(property).to respond_to(:property_type=).with(1).argument
    end

    it 'allows for getting of an property_type' do
      expect(property).to respond_to(:property_type)
    end
  end

  describe '::exists?' do

    it 'returns true if property has already been added for given lead' do
      params = {
        address: '123 test st.',
        lead_id: 1,
        sq_ft: 15000
      }

      expect(Property.exists?(params)).to eq(true)
    end
  end
end
