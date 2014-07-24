module Cms::InfosHelper
	def static
		
	end
    def home
    	@info_categories = Cms::Category.where(column_id: @site.columns ,is_enabled:true)
	    @recommend_infos = Cms::Info.where("category_id IN (?) AND is_recommend = ? AND is_enabled = ?",
	    	                          @info_categories,true,true).order("updated_at DESC").limit(5)
	    logger.debug("info size:" + @recommend_infos.size.to_s)
	end
	def info
        info_categories
        @new_infos = Cms::Info.where("column_id = ? AND is_enabled = ? ",@site_column.id,true).
                                      page(params[:page]).per_page(5).order("updated_at DESC")
        @recommend_infos = Cms::Info.where("column_id = ? AND is_recommend = ? AND is_enabled = ?",
        	                     @site_column.id,true,true).order("updated_at DESC").limit(5)
	end
	def info_list
		info_categories
		@info_category = Cms::Category.find(params[:id])
		@sticky_infos = Cms::Info.where("category_id =? AND is_sticky=? AND is_enabled =? ",
			                               params[:id],true,true).order("updated_at DESC").limit(5)
		@category_infos = Cms::Info.where("category_id =? AND is_sticky=? AND  is_enabled =? ",
			                               params[:id],false,true).page(params[:page]).per_page(9).
		                                   order("updated_at DESC")
        render json: @category_infos if request.format.json?
	end
	def info_show
		info_categories
		@info = Cms::Info.where("id =? AND is_enabled = ? ",params[:id],true).take
		view_count = @info.view_count
		view_count = 0 if @info.view_count.nil?
		view_count +=1
		@info.record_timestamps=false
		@info.update_attributes(:view_count => view_count)
		@info.record_timestamps=true
	end

	def info_categories
		if @site_column.parent_column.nil?
			column_id = @site_column.id 
		else
			column_id = @site_column.parent_column.id 
		end

	    @info_categories = Cms::Category.where(column_id: column_id,is_enabled:true)
	end
end
