class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show edit update destroy connect]

  # GET /customers or /customers.json
  def index
    @customers = Customer.all
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers or /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: "Customer was successfully created." }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: "Customer was successfully updated." }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy!

    respond_to do |format|
      format.html { redirect_to customers_path, status: :see_other, notice: "Customer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def connect
    # session_url = AccessSessionService.create_connect_session(@customer.customer_id, @customer.customer_name)
    session_url = Tryfinch::API::SessionConnect.create_url(@customer.customer_id, @customer.customer_name)

    respond_to do |format|
      if session_url
        format.html { redirect_to session_url, allow_other_host: true, notice: "Session successfully created." }
        format.json { render json: { session_url: session_url }, status: :ok }
      else
        format.html do
          flash[:alert] = "Failed to generate session token"
          redirect_to customers_path
        end
        format.json { render json: { error: "Failed to generate session token" }, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:customer_id, :customer_name, :email)
    end
end
