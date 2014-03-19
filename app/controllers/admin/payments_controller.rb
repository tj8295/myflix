class Admin::PaymentsController < AdminsController
  before_filter :require_user

  def index
    @payments = Payment.all
  end
end
