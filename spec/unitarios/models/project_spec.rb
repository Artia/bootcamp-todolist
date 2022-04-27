require 'rails_helper'

RSpec.describe Project, type: :model do

  describe 'associações' do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'validações' do
    describe 'title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(255) } 
    end
  end
end