module Cms::FeedbacksHelper

	def feedback
	  if request.post?
		 cms.feedback = Cms::Feedback.new(params.permit(:name, :tel, :email, :content))
         cms.feedback.cms_id = @site.id
         cms.feedback.save
         if cms.feedback.errors.empty?
         	flash.now[:notice] = "您的反馈已提交，谢谢!"
         else
         	flash.now[:error] = "提交失败:"
         	#logger.debug("errors:"+cms_feedback.errors[:email].to_s)
         	#logger.debug("errors:"+cms_feedback.errors[:content].to_s)
            flash.now[:error] += "您的邮箱不合法." unless cms.feedback.errors[:email].blank?
            flash.now[:error] += "您没有填写内容." unless cms.feedback.errors[:content].blank?
         end
         
	  end
	end
end
