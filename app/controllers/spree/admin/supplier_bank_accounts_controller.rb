class Spree::Admin::SupplierBankAccountsController < Spree::Admin::ResourceController

  before_filter :load_supplier
  create.before :set_supplier

  def new
    @object = @supplier.bank_accounts.build
  end

  def destroy
    @supplier = spree_current_user.supplier
    invoke_callbacks(:destroy, :before)
    if @object.destroy
      invoke_callbacks(:destroy, :after)
      flash[:success] = flash_message_for(@object, :successfully_removed)
      respond_with(@object) do |format|
        format.html { redirect_to edit_admin_supplier_path(@supplier) }
        format.js   { render :partial => "spree/admin/shared/destroy" }
      end
    else
      invoke_callbacks(:destroy, :fails)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_destroy }
      end
    end
  end

  # def destroy
  #   @supplier = spree_current_user.supplier
  #   @bank_account = Spree::SupplierBankAccount.where("supplier_id = ?", spree_current_user.supplier.id)
  #   @bank_account.destroy
  #   prints "bank account was destroyed"
  #   respond_to do |format|
  #     prints "redirecting..."
  #     format.html { redirect_to edit_admin_supplier(@supplier) }
  #     format.json { head :no_content }
  #   end
  # end

  private

    def load_supplier
      @supplier = Spree::Supplier.friendly.find(params[:supplier_id])
    end

    def location_after_save
      spree.edit_admin_supplier_path(@supplier)
    end

    def set_supplier
      @object.supplier = @supplier
    end

end
