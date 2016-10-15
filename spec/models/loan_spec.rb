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

  context '#paid?' do
    it 'returns false when no payments' do
      expect(subject.paid?).to eq false
    end

    context 'when all payments present' do
      subject { create :loan, :paid }

      it 'returns true' do
        expect(subject.paid?).to eq true
      end
    end
  end

  context '#add_next_payment!' do
    it 'adds payment for first month if no loan payments present' do
      expect { subject.add_next_payment! }.to change { subject.reload.payments.count }.from(0).to(1)

      payment = subject.payments.last
      expect(payment.month).to        eq 1
      expect(payment.deliquency?).to  eq false
    end

    it 'has working deliquency option' do
      subject.add_next_payment!(deliquency: true)
      expect(subject.payments.last.deliquency?).to eq true
    end

    context 'when partially paid (2 monthes)' do
      before { 2.times { subject.add_next_payment! } }

      it 'adds payment for third month' do
        subject.add_next_payment!
        expect(subject.payments.last.month).to eq 3
      end
    end

    context 'when loan is fully paid' do
      subject { create :loan, :paid }

      it 'raises error' do
        expect { subject.add_next_payment! }.to raise_error StandardError
      end
    end
  end
end
