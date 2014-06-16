class JavascriptsController < ApplicationController
  def dynamic_manufacturers
    @manufacturers = Manufacturer.find(:all)
  end

end
