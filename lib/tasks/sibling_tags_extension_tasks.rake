namespace :radiant do
  namespace :extensions do
    namespace :sibling_tags do
      
      desc "Runs the migration of the Sibling Tags extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          SiblingTagsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          SiblingTagsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Sibling Tags to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[SiblingTagsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(SiblingTagsExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
