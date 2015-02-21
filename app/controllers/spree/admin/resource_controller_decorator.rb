# Spree::Admin::ResourceController.class_eval do

#   def create
#     @object.attributes = permitted_resource_params
#     if @object.save
#       flash[:success] = flash_message_for(@object, :successfully_created)
#       respond_with(@object) do |format|
#         format.html { redirect_to location_after_save }
#         format.js   { render :layout => false }
#       end
#     else
#       invoke_callbacks(:create, :fails)
#       respond_with(@object) do |format|
#         format.html do
#           flash.now[:error] = @object.errors.full_messages.join(", ")
#           render action: 'new'
#         end
#         format.js { render layout: false }
#       end
#     end
#   end

# end