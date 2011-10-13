class PluginTagsController < PluginController
  def create
     @tag = PluginTag.new
     @tag.name = params[:tag_name]
     @tag.user_id = @logged_in_user.id
     @tag.record = @record
     
     if @tag.save
       log(:log_type => "create", :target => @tag)
       flash[:success] = t("notice.item_create_success", :item => @plugin.model_name.human)
       flash[:notice] += "<br>" + t("notice.item_needs_approval", :item => @plugin.model_name.human) if !@tag.is_approved?     
     else # fail saved 
       flash[:failure] = t("notice.item_create_failure", :item => @plugin.model_name.human)
     end     
     redirect_to :back
  end
  
  def delete
     @tag = PluginTag.find(params[:tag_id])
     if @tag.destroy
      log(:log_type => "destroy", :target => @tag)
      flash[:success] = t("notice.item_delete_success", :item => @plugin.model_name.human)
     else # fail saved 
       flash[:failure] = t("notice.item_delete_failure", :item => @plugin.model_name.human)
     end     
     redirect_to :back
  end
end
