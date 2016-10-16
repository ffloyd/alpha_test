class LoansController < ApplicationController
  before_action :set_loan, only: [:show, :edit, :update, :destroy, :remove_last_payment, :add_next_payment]

  respond_to :html, except: [:remove_last_payment, :add_next_payment]
  respond_to :js,   only:   [:remove_last_payment, :add_next_payment]

  def index
    @loans = Loan.all
    respond_with(@loans)
  end

  def show
    respond_with(@loan)
  end

  def new
    @loan = Loan.new
    respond_with(@loan)
  end

  def create
    @loan = Loan.new(loan_params)
    @loan.save
    respond_with(@loan)
  end

  def destroy
    @loan.destroy
    respond_with(@loan)
  end

  def remove_last_payment
    @loan.payments.last.destroy

    render 'refresh'
  end

  def add_next_payment
    @loan.add_next_payment!(payment_params)

    render 'refresh'
  end

  private

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def loan_params
    params.require(:loan).permit(:legal_entity, :amount)
  end

  def payment_params
    permitted = params.require(:payment).permit(:deliquency, :pay_all)

    {
      deliquency: permitted[:deliquency] == '0' ? false : true,
      pay_all:    permitted[:pay_all] == '0' ? false : true
    }
  end
end
