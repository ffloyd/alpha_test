require 'rails_helper'

RSpec.describe Payment, type: :model do
  context 'when 12 payments for different monthes already present' do
    let(:loan) { create :loan }
  end
end
