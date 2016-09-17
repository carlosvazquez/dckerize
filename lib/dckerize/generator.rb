module Dckerize
  class Generator
    attr_accessor :name, :db, :extras
    def initialize(name, db, extras = [])
      if db == 'mysql'
        @db              = 'mysql:5.7'
        @db_password     = 'MYSQL_PASSWORD'
        @db_user         = 'MYSQL_USER'
        @db_name         = 'MYSQL_DATABASE'
        @data_volume_dir = '/var/lib/mysql'
        @db_service_name = 'mysql'
        @db_port = 3306
      elsif db == 'postgres'
        @db              = 'postgres:9.5.3'
        @db_password     = 'POSTGRES_PASSWORD'
        @db_user         = 'POSTGRES_USER'
        @db_name         = 'POSTGRES_DB'
        @data_volume_dir = '/var/lib/postgresql'
        @db_service_name = 'postgres'
        @db_port = 5432
      end
      @name = name

      @extras = Array.new
      extras.each do |extra|
        @extras << Dckerize::Extra.new(extra)
      end
    end

    def get_binding
      binding
    end

    def templates
      Dckerize.templates
    end

    def up

      raise Dckerize::Runner::DOCKERFILE_EXISTS if File.exists?('Dockerfile')
      raise Dckerize::Runner::DOCKERCOMPOSE_EXISTS if File.exists?('docker-compose.yml')

      create_from_template('Dockerfile.erb', 'Dockerfile.development')
      create_from_template('webapp.conf.erb', "webapp.conf")
      create_from_template('setup.sh.erb', "setup.sh")
      create_from_template('rails-env.conf.erb', "rails-env.conf")
      create_from_template('docker-compose.yml.erb', "docker-compose.yml")
    end

    private
    def create_from_template(template_name, output_file)
      template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
      result = template.result(binding)
      File.open("#{output_file}", 'w') { |file| file.write(result) }

      # add execution permissions for setup.sh
      system "chmod +x #{output_file}" if output_file == 'setup.sh'
    end

  end

end
