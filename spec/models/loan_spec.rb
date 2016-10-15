require 'rails_helper'

RSpec.describe Loan, type: :model do
  subject { create(:loan, amount: 1_000_000) }

  it 'assigns predefined duration, period and rates' do
    values = [subject.duration, subject.period, subject.annual_rate, subject.deliquency_rate]
    expected_values = [
      Loan::BASE_DURATION,
      Loan::BASE_PERIOD,
      Loan::BASE_ANNUAL_RATE,
      Loan::BASE_DELIQENCY_RATE
    ]

    expect(values).to eq expected_values
  end

  it '#monthly_debt_payment is correct' do
    expect(subject.monthly_debt_payment.round(4)).to eq 166_666.6667
  end

  it '#monthly_perc_payment is correct' do
    expect(subject.monthly_perc_payment).to eq 25_000
  end

  it '#monthly_deliquency_perc_payment is correct' do
    expect(subject.monthly_deliquency_perc_payment.round(4)).to eq 41_666.6667
  end

  it '#monthly_payment is correct' do
    expect(subject.monthly_payment.round(2)).to eq 191_666.67
  end

  it '#monthly_deliquency_payment is correct' do
    expect(subject.monthly_deliquency_payment.round(2)).to eq 208_333.33
  end
end
