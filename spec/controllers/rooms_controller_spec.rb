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

end
