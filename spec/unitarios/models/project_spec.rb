require 'rails_helper'

# DESAFIO
RSpec.describe Project, type: :model do
  describe 'associações' do
    it {is_expected.to have_many(:tasks)}
  end

  describe 'validações' do
  end
end