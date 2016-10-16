class LoansController < ApplicationController
  before_action :set_loan, only: [:show, :edit, :update, :destroy]

  respond_to :html

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

  private

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def loan_params
    params.require(:loan).permit(:legal_entity, :amount)
  end
end
