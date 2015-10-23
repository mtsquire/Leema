Spree::Admin::GeneralSettingsController.class_eval do
  include ApplicationHelper
  before_filter :check_if_leema_admin
end