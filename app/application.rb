class Application
  @@items = %w[Apples Carrots Pears]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path =~ /items/
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path =~ /search/
      search_term = req.params['q']
      resp.write handle_search(search_term)
    elsif req.path =~ /cart/
      resp.write 'Your cart is empty' if @@cart.empty?
      @@cart.each { |i| resp.write "#{i}\n" }
    elsif req.path =~ /add/
      par = req.params['item']
      if @@items.include?(par)
        @@cart << par
        resp.write "You have added #{par} in your cart."
      else
        resp.write "We don't have that item"
      end
    else
      resp.write 'Path Not Found'
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      "#{search_term} is one of our items"
    else
      "Couldn't find #{search_term}"
    end
  end
end
