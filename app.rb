# coding: utf-8

require 'uri'
require 'find'

module Project
  class App < Sinatra::Base

    configure :development do
      Bundler.require :development
      register Sinatra::Reloader
      Slim::Engine.set_default_options :pretty => true
      set :scss, :views => 'assets/scss', :style => :expanded
    end

    configure :production do
      set :scss, :views => 'assets/scss', :style => :compressed
    end

    set :views, :markdown => 'views/md', :slim => 'views', :default => 'views'

    helpers do
      def find_template(views, name, engine, &block)
        _, folder = views.detect { |k,v| engine == Tilt[k] }
        folder ||= views[:default]
        super(folder, name, engine, &block)
      end
    end

    before do
      @jquery_version = '2.1.1'
      @site_title = 'Sinatra Markdown Wiki'
    end

    get '/css/:name.css' do
      scss params[:name].to_sym
    end

    get '/' do
      markdown_file_paths = Dir.glob('views/md/*.md')
      @markdown_files = markdown_file_paths.map { |f| URI.unescape(File.basename(f, '.md')) }

      slim :index
    end

    post '/pages' do
      @title = params[:page_title]
      @body  = params[:page_body]

      filename = URI.escape(@title)
      open(File.join('views', 'md', "#{filename}.md"), 'w') do |f|
        f.write @body
      end

      redirect "/#{filename}"
    end

    not_found do
      is_edit_mode = request.path[-5..-1] == '/edit'

      @title = request.path[1..-1].split('/').first
      begin
        @body = open(File.join('views', 'md', "#{@title}.md")) { |f| f.read }
      rescue Errno::ENOENT
        slim :new_page
      else
        @filename = @title
        @title = URI.unescape(@title).force_encoding('utf-8')

        if is_edit_mode
          slim :edit_page
        else
          slim :show_page
        end
      end
    end
  end

end
