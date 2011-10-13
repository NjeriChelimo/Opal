class PluginVideosController < PluginController
  before_filter :uses_tiny_mce, :only => [:new, :edit, :create, :update]  # which actions to load tiny_mce, TinyMCE Config is done in Layout.

  def create
   @video = PluginVideo.new(params[:plugin_video])
   @video.user_id = @logged_in_user.id
   @video.record = @item
            
   if @video.save
    Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "create", :log => t("log.item_create", :item => @plugin.model_name.human, :name => @video.title))             
    flash[:success] = t("notice.item_create_success", :item => @plugin.model_name.human)
    flash[:success] += t("notice.item_needs_approval", :item => @plugin.model_name.human) if !@video.is_approved?
    redirect_to :back
   else # fail saved 
    flash[:failure] = t("notice.item_create_failure", :item => @plugin.model_name.human)
    render :action => "new"
   end  
  end
 
  def update
   @video = PluginVideo.find(params[:video_id])
   @video.attributes = params[:plugin_video]
   if @video.save
    Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "update", :log => t("log.item_save", :item => @plugin.model_name.human, :name => @video.title))                    
    flash[:success] =  t("notice.item_save_success", :item => @plugin.model_name.human)
    redirect_to :back
   else # fail saved 
     flash[:success] = t("notice.item_save_failure", :item => @plugin.model_name.human)
     render :action => "edit"
   end    
  end
  
  def delete
    @video = PluginVideo.find(params[:video_id])
    if @video.destroy
      Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "delete", :log => t("log.item_delete", :item => @plugin.model_name.human, :name => @video.title))
      flash[:success] = t("notice.item_delete_success", :item => @plugin.model_name.human)
    else # fail saved
      flash[:success] = t("notice.item_delete_failure", :item => @plugin.model_name.human)
    end

    redirect_to :back
  end  
 
  def new 
    @video = PluginVideo.new    
  end
 
  def edit
    @video = PluginVideo.find(params[:video_id])   
  end
  
  def show
  	@video = PluginVideo.find(params[:video_id])  
    respond_to do |format|
      format.html{}
      format.js{render :layout => false }
    end    	 
  end
end
