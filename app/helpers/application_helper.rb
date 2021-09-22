module ApplicationHelper
  def is_cart_empty?
    html = ''
    if enhanced_cart.empty?
      html << "<p>... Is Empty! Please Buy Things @ 
      <a href='/'> Home Page</a></p>"
    end  
    html
  end
end

