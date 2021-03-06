require 'rails_helper'

RSpec.describe RoomsController, :type => :controller do

  describe '#create' do
    let(:room_attributes) { attributes_for(:room) }

    it 'redirects to the rooms list' do
      post :create, room: room_attributes

      expect(subject).to redirect_to(action: :index)
    end

    it 'creates a room' do
      post :create, room: room_attributes

      expect(controller.room).to be_persisted
    end

    it 'displays the form again given invalid data' do
      expect(controller.room).to receive(:valid?).and_return(false)
      post :create, room: room_attributes

      expect(subject).to render_template(:new)
    end
  end

  describe '#update' do
    let(:room) { create(:room) }
    let(:updated_room_attributes) {
      { title: 'Situation room' }
    }

    it 'redirects to the room' do
      post :update, id: room, room: updated_room_attributes

      expect(subject).to redirect_to(action: :show)
    end

    it 'updates a room' do
      post :update, id: room, room: updated_room_attributes

      controller.room.reload
      expect(controller.room.title).to eq('Situation room')
    end

    it 'displays the form again given invalid data' do
      expect(controller.room).to receive(:valid?).and_return(false)
      post :update, id: room, room: updated_room_attributes

      expect(subject).to render_template(:edit)
    end
  end

  describe '#import' do
    let(:room) { create(:room) }
    let(:mock_importer) { double('Importer', import: true) }

    it 'initiates an import of events for the room' do
      expect(EventImporter).to receive(:new).with(
        room: room
      ).and_return(mock_importer)

      post :import, id: room
    end

    it 'redirects to the room path' do
      expect(EventImporter).to receive(:new).and_return(mock_importer)

      post :import, id: room
      expect(subject).to redirect_to(action: :show, id: room)
    end

    it 'sets a success message' do
      expect(EventImporter).to receive(:new).and_return(mock_importer)

      post :import, id: room
      expect(controller.flash.notice).to match(/complete/)
    end
  end

  describe '#import_all' do
    let(:mock_importer) { double('Importer', import: true) }

    before do
      allow(BulkEventImporter).to receive(:new).and_return(mock_importer)
    end

    it 'initiates the BulkEventImporter' do
      expect(mock_importer).to receive(:import)

      post :import_all
    end

    it 'redirects to the room list' do
      post :import_all

      expect(subject).to redirect_to(action: :index)
    end

    it 'sets a success message' do
      post :import_all

      expect(controller.flash.notice).to match(/complete/)
    end
  end

end
