# frozen_string_literal: true

module Oxidized
  class Script
    module Command
      class ListNodes < Base
        Short       = "n"
        Name        = "list-nodes"
        Description = "list nodes in oxidized source"

        # this is not needed this this command, just shown how todo more
        # complex commands, this could use slop sub-commands etc. As long as it
        # sets cli.cmd_class when you want to run it, it gets ran after parsing
        # commandline
        def self.cmdline(slop, cli)
          slop.on "--#{Name}", Description do
            cli.cmd_class = self
          end
        end

        # 执行节点查询任务
        def self.run(opts = {})
          if opts[:opts][:terse] # find if 'terse' global option is set
            puts new(opts).nodes_terse
          else
            puts new(opts).nodes
          end
        end

        # 查询项目下所有节点 - 详细输出
        def nodes
          out = ""
          Nodes.new.each do |node|
            out += "#{node.name}:\n"
            node.instance_variables.each do |var|
              name = var.to_s[1..-1]
              next if name == "name"
              value = node.instance_variable_get var
              value = value.class if name == "model"
              out   += "  %10s => %s\n" % [name, value.to_s]
            end
          end
          out
        end

        # 查询项目下所有节点 - 详细输出
        def node(name)
          item = Nodes.new.filter { |i| i.name == name }
          return "#{name} not in DB!" if item.nil?

          out = ""
          out += "#{item.name}: \n"
          node.instance_variables.each do |var|
            name = var.to_s[1..-1]
            next if name == "name"
            value = item.instance_variable_get var
            value = value.class if name == "model"
            # 规则打印数据
            out += "%10s => %s\n" % [name, value.to_s]
          end
          out
        end

        # 简洁输出 - 列出节点名称
        def nodes_terse
          out = ""
          i   = 0
          Nodes.new.each do |node|
            out += "#{i += 1} - #{node.name}\n"
          end
          out
        end

        private
          def initialize(opts = {})
            Oxidized.mgr = Manager.new
          end
      end
    end
  end
end
