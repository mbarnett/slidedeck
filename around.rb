class ApplicationController < ActionController::Base
  around_filter :profile, if: -> {Rails.env.development? && params[:trace] == "1"}

  def profile
    require 'ruby-prof'

    RubyProf.start

    yield

    results = RubyProf.stop

    File.open "#{Rails.root}/profile-stack.html", 'w' do |file|
        RubyProf::CallStackPrinter.new(results).print(file)
    end
  end
end
