include FileUtils

# Path where the sources jqtouch templates and layouts are:
ASSETS_PATH = File.join(File.dirname(__FILE__), '../assets')
# jqtouch version used
JQT_VERSION = "1.0.0-a2"

namespace :rails_jqtouch do
  
  desc "Muestra la versión de jqtouch utilizada"
  task :jqtouch_version do
    puts JQT_VERSION
  end
  
  desc 'Copia los js de jqtouch en public/javascripts'
  task :install_javascripts => :environment do
    Dir.chdir "#{ASSETS_PATH}/jqtouch/javascripts" do
      Dir.glob('*.js') {|js| cp(js, "#{RAILS_ROOT}/public/javascripts")}
    end
  end
  
  desc 'Copia la hoja de estilos y las imagenes del tema jqt en public/stylesheets'
  task :install_stylesheets_jqt => :environment do
    Dir.chdir("#{ASSETS_PATH}/jqtouch/stylesheets") do
      cp "jqtouch.css", "#{RAILS_ROOT}/public/stylesheets" 
      cp_r "themes", "#{RAILS_ROOT}/public/stylesheets"
    end
  end
  
  desc 'Copia el layout application.iphone.erb a app/views/layouts'
  task :install_layouts => :environment do
    Dir.chdir("#{ASSETS_PATH}/layouts") do
      cp "application.iphone.erb", "#{RAILS_ROOT}/app/views/layouts"
    end
  end

  desc 'instala las hojas de estilos, javascripts, imágenes y layouts'
  task :install => [:install_javascripts, :install_layouts, :install_stylesheets_jqt]
  
  desc 'Elimina los javascripts instalados'    
  task :clean_javascripts => :environment do
    Dir.chdir "#{ASSETS_PATH}/jqtouch/javascripts" do
      Dir.glob('*.js') {|js| rm("#{RAILS_ROOT}/public/javascripts/#{js}")}
    end
  end
  
  desc 'Elimina los layouts instalados'
  task :clean_layouts => :environment do
    rm "#{RAILS_ROOT}/app/views/layouts/application.iphone.erb"
  end
  
  desc 'Elimina las hojas de estilos y las imagenes asociadas'
  task :clean_stylesheets => :environment do
    rm "#{RAILS_ROOT}/public/stylesheets/jqtouch.css"
    rm_r "#{RAILS_ROOT}/public/stylesheets/themes"
  end
  
  desc 'Limpia la instalación de jqtouch, removiendo los javascripts, hojas de estilos, imágenes y layouts'
  task :clean => [:clean_javascripts, :clean_layouts, :clean_stylesheets]
  
end

