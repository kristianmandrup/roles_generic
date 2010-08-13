require 'require_all'
require 'active_support/inflector'

module RoleModels
  module Generic
  end
end

class Object
  define_method :not do
    Not.new(self)
  end

  class Not
    private *instance_methods.select { |m| m !~ /(^__|^\W|^binding$)/ }

    def initialize(subject)
      @subject = subject
    end

    def method_missing(sym, *args, &blk)
      !@subject.send(sym,*args,&blk)
    end
  end
end

class Object
  # The hidden singleton lurks behind everyone
  def metaclass; class << self; self; end; end
  def meta_eval &blk; metaclass.instance_eval &blk; end

  # Adds methods to a metaclass
  def meta_def( name, &blk )
    meta_eval { define_method name, &blk }
  end

  # Defines an instance method within a class
  def class_def( name, &blk )
    class_eval { define_method name, &blk }
  end
end


class Object
  def find_methods method, option=nil
    methods = option == :singleton ? singleton_methods : methods             
    return if !methods
    methods.sort.grep(/#{method.to_s}/) if method.kind_of?(String) || method.kind_of?(Symbol)
    methods.sort.grep(method) if method.kind_of?(Regexp)
  end
end  

module RoleModels
  module Base
    attr_accessor :orm_name

    def roles(*roles)
      strategy_class.valid_roles = Array[*roles].flatten.map { |r| r.to_sym }
    end
    
    def role_strategy strategy, options=nil
      include_strategy orm_name, strategy, options
    end  
         
    def include_strategy orm, strategy, options=nil 
      begin     
        constant = "RoleModels::#{orm_name.to_s.camelize}::#{strategy.to_s.camelize}".constantize

        strategy_class_method = %Q{
          def strategy_class
            #{constant} 
          end
        }
        
        class_eval do
          eval strategy_class_method
        end

        instance_eval do        
          eval strategy_class_method
          include constant
        end        
      rescue
        raise "No Role strategy module for ORM #{orm} found for strategy #{strategy}"
      end
      constant.apply_options(options) if constant.respond_to? :apply_options
    end    
  end
end
