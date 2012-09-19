class MrObserver < Mongoid::Observer

  def after_save(doc)
     puts "Triggered"
  end
end
