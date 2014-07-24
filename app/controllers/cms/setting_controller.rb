class Cms::SettingController < ApplicationController

  def show
    @site = Cms::Site.all.take
  end
 
 #网站设置
 def modify
    @site = Cms::Site.all.take
    if request.patch?
      #@account = Account.find(params[:account][:id])
      if @site.update(cms_site_params) && Utils::FileUtil.check_ext(params[:site][:logo_file]) 
        if params[:site][:logo_file]
           Utils::FileUtil.delete_file(@site.logo_file) if !@site.logo_file.blank?
           @site.logo_file = Utils::FileUtil.upload(params[:site][:logo_file]) 
           @site.save
        end
        flash[:notice] = "设置已成功更新."
      else
        flash[:notice] = "设置更新失败."
        if !Utils::FileUtil.check_ext(params[:site][:logo_file]) 
          @site.errors.add(:logo_file, "无效的文件类型，只允许:"+ Rails.configuration.upload_extname)
        end
        redirect_to  cms.setting_modify_path
      end
      redirect_to  cms.setting_show_path
    end
  end

  private

    def cms_site_params
      params.require(:site).permit(:name, :tel, :email, :address, :zip, :domain)
    end
end
