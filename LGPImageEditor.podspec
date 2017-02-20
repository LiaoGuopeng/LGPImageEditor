Pod::Spec.new do |s|

s.name         = "LGPImageEditor"
s.version      = "0.0.3"
s.summary      = "用于选择图片后编辑，矩形，圆形，也可以自定义路径作为剪切的依据。"

s.homepage     = "https://github.com/LiaoGuopeng/LGPImageEditor"

s.license      = "MIT"

s.author             = { "guopeng liao" => "756581014@qq.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"

s.source       = { :git => "https://github.com/LiaoGuopeng/LGPImageEditor.git", :tag => "0.0.3"}

s.source_files  = "ImageShear/LGPImageEditor/**/*.{h,m}"

# s.public_header_files = "Classes/**/*.h"


s.requires_arc = true

#s.dependency "Masonry", "~> 1.0.1"
#s.dependency "SDWebImage", "~> 3.8.1"

# s.frameworks = "Masonry", "SDWebImage"

end
