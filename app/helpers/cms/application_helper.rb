module Cms

  module ApplicationHelper

  	def bool_label(val)
      output = "<span class=\"label " + (val ? 'label-success' : 'label-default') +
              "\">" + (val ? '是' : '否')  +"</span>"
      output.html_safe
    end

    def str_trim(str,length,postfix='...')
		str[0,length]+(str.length > length ? postfix : "") if str
	end

    #删除文件
	def delete_file(file_name)
      if file_name
         full_name = Rails.root.join("public",file_name)
         #logger.debug("delete file:"+full_name.to_s)
         File.delete(full_name) if File.exist?(full_name)

         thumb_name = file_name[0..file_name.index('.')-1] +  "_thumb.jpg"
         full_name = Rails.root.join("public",thumb_name)
         File.delete(full_name) if File.exist?(full_name)
      end
    end

    #检查文件上传许可
    def check_ext(res_file)
      if res_file
         extname = File.extname(res_file.original_filename)

         is_allowed_ext = false
         Rails.configuration.upload_extname.split(';').each do |ext| 
           if ext == extname
              is_allowed_ext = true
              break
           end
         end
         #logger.debug("res_file "+ is_allowed_ext.to_s)
         is_allowed_ext
      else
         true   #无文件返回true
      end
    end
    
    #上传文件
    def upload (res_file)
       if res_file
           upload_path = Rails.configuration.upload_path + "/"+ Time.now.strftime("%Y%m/%d")
           unless Dir.exist?(Rails.root.join("public",upload_path))
             FileUtils.mkdir_p(Rails.root.join("public",upload_path))
           end
           file_name_main = Time.now.to_i.to_s+Digest::SHA1.hexdigest(rand(9999).to_s)[0,6]
           file_name_ext =  File.extname(res_file.original_filename)
           file_name_ext = ".jpg" if image_file?(res_file.original_filename)
           file_name = file_name_main + file_name_ext
           abs_file_name = Rails.root.join("public",upload_path,file_name)
           logger.debug("res_file:" + res_file.original_filename)
           #所有图片自动转成jpg格式，并且宽控制在720以内，压缩质量为80，以减小文件大小
           if file_name_ext == '.jpg'
               image = MiniMagick::Image.open(res_file.path)
               max_width = 720
               max_width = Rails.configuration.image_max_width.to_i unless Rails.configuration.image_max_width.blank?

               if image[:width] > max_width
                  image.resize max_width            
               end               
               image.format "jpg"
               image.quality "80"
               image.write abs_file_name
           else             
             File.open(abs_file_name, 'wb') do |file|
                file.write(res_file.read)
             end
           end

           upload_path + "/" + file_name
       end
    end

    #检查是否图片文件名
    def image_file?(file_name)
       return !file_name.blank? && file_name.downcase.match("\\.png|\\.bmp|\\.jpeg|\\.jpg|\\.gif")
    end

    #生成缩略图
    def thumb_image(file_name)
       if image_file?(file_name)
         image = MiniMagick::Image.open(file_name)
         image.format "jpg"
         thumb_size = "150x150^" 
         thumb_size = Rails.configuration.image_thumb_size unless Rails.configuration.image_thumb_size.blank?
         image.resize thumb_size
         #image.combine_options do |i|           
         #  i.resize "150x150^"
         #  i.gravity "center"
         #  i.crop "150x150+0+0"
         # end
         image.write  file_name[0..file_name.index('.')-1] + "_thumb.jpg" 
       end
    end
  end
end
