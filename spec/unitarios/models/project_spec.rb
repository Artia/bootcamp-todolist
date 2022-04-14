require 'rails_helper'

# DESAFIO
RSpec.describe Project, type: :model do
  let(:project) { Project.new(title: 'Novo projeto') }

  describe 'associações' do
    it { is_expected.to have_many(:tasks)}
  end

  describe 'validações' do
    describe 'formata o percentual' do

      it 'quando o valor é padrão' do
        expect(project.format_percent).to eq("0.0%")
      end

      it 'quando o valor é 0' do
        project.stub(completed_percent: 0.to_f)
        expect(project.format_percent).to eq("0.0%")
      end

      it 'quando o valor é inteiro' do
        project.stub(completed_percent: 10.to_f)
        expect(project.format_percent).to eq("10.0%")
      end

      it 'quando o valor é decimal' do
        project.stub(completed_percent: 33.3333.to_f)
        expect(project.format_percent).to eq("33.33%")
      end

      it 'quando o valor é 100' do
        project.stub(completed_percent: 100)
        expect(project.format_percent).to eq("100.0%")
      end
    end
  end
end