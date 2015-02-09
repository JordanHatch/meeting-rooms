require 'rails_helper'

RSpec.describe BulkEventImporter do

  let(:rooms) { create_list(:room, 5) }
  let(:mock_importer) { double(:importer) }

  it 'invokes an EventImporter for each room' do
    rooms.each do |room|
      expect(EventImporter).to receive(:new).with(room: room).and_return(mock_importer)
    end
    expect(mock_importer).to receive(:import).exactly(5).times

    BulkEventImporter.new.import
  end

end
