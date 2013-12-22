require 'zeus/rails'

ROOT_PATH = File.expand_path(Dir.pwd)
ENV_PATH  = File.expand_path('spec/test_app/config/environment',  ROOT_PATH)
BOOT_PATH = File.expand_path('spec/test_app/config/boot',  ROOT_PATH)
APP_PATH  = File.expand_path('spec/test_app/config/application',  ROOT_PATH)
ENGINE_ROOT = File.expand_path(Dir.pwd)
ENGINE_PATH = File.expand_path('lib/newsletter/engine', ENGINE_ROOT)

class EnginePlan < Zeus::Rails
end

Zeus.plan = EnginePlan.new
