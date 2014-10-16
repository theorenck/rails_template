class BasePresenter
  
  def initialize(object, template)
    @object = object
    @template = template
  end

  def human_attribute_name(name)
  	@object.class.human_attribute_name(name)
  end

  private

	  def self.presents(name)
	    define_method(name) do
	      @object
	    end
	  end

	  def h
	    @template
	  end
	  
	  def method_missing(*args, &block)
	    @object.send(*args, &block)
	  end

	  # Extrair HighlightHelper

		def highlighted?(text)
			text =~ /<em>(.*)<\/em>/
		end

		def unhighlight(text)
			text.gsub /<em>(.*)<\/em>/, '\1'
		end

		def highlight(text)
			"<em>#{text}</em>"
		end
end