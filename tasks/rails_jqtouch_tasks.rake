include FileUtils

# Path where the sources jqtouch templates and layouts are:
ASSETS_PATH = File.join(File.dirname(__FILE__), '../assets')
# jqtouch version used
JQT_VERSION = "1.0.0-a2"

namespace :rails_jqtouch do
  
  desc 'Displays the jqtouch version'
  task :jqtouch_version do
    puts JQT_VERSION
  end
  
  desc 'Copy the jqtouch js into public/javascripts'
  task :install_javascripts => :environment do
    Dir.chdir "#{ASSETS_PATH}/jqtouch/javascripts" do
      Dir.glob('*.js') {|js| cp(js, "#{RAILS_ROOT}/public/javascripts")}
    end
  end
  
  desc 'Copy the stylesheet and the themes into public/stylesheets'
  task :install_stylesheets_jqt => :environment do
    Dir.chdir("#{ASSETS_PATH}/jqtouch/stylesheets") do
      cp "jqtouch.css", "#{RAILS_ROOT}/public/stylesheets" 
      cp_r "themes", "#{RAILS_ROOT}/public/stylesheets"
    end
  end
  
  desc 'Copy the layout application.iphone.erb into app/views/layouts'
  task :install_layouts => :environment do
    Dir.chdir("#{ASSETS_PATH}/layouts") do
      cp "application.iphone.erb", "#{RAILS_ROOT}/app/views/layouts"
    end
  end

  desc 'Installing stylesheets, javascripts, images and layouts'
  task :install => [:install_javascripts, :install_layouts, :install_stylesheets_jqt]
  
  desc 'Remove installed javascripts'    
  task :clean_javascripts => :environment do
    Dir.chdir "#{ASSETS_PATH}/jqtouch/javascripts" do
      Dir.glob('*.js') {|js| rm("#{RAILS_ROOT}/public/javascripts/#{js}")}
    end
  end
  
  desc 'Remove installed layouts'
  task :clean_layouts => :environment do
    rm "#{RAILS_ROOT}/app/views/layouts/application.iphone.erb"
  end
  
  desc 'Delete stylesheets and associated images'
  task :clean_stylesheets => :environment do
    rm "#{RAILS_ROOT}/public/stylesheets/jqtouch.css"
    rm_r "#{RAILS_ROOT}/public/stylesheets/themes"
  end
  
  desc 'Clean install jqtouch, removing the javascripts, stylesheets, images and layouts'
  task :clean => [:clean_javascripts, :clean_layouts, :clean_stylesheets]
  
end

