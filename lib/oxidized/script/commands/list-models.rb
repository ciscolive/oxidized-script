# frozen_string_literal: true

module Oxidized
  class Script
    module Command
      class ListModels < Base
        Short       = "m"
        Name        = "list-models"
        Description = "list supported models"

        # 查询兼容的设备模型
        def self.run(opts = {})
          puts new(opts).models
        end

        # 列出项目下 models
        def models
          out    = ""
          models = Dir.glob File.join Config::ModelDir, "*.rb"
          models.each do |model|
            next if model.match?(/output|model/i)
            out += "%15s - %s\n" % [File.basename(model, ".rb"), model]
          end
          # 返回查询结果
          out
        end

        private
          def initialize(opts = {}) end
      end
    end
  end
end
