# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "mongodb" do |mongodb|
    mongodb.vm.provider "docker" do |d|
      d.image   = "mongo"
      d.name    = "texbin_mongodb"
    end
  end

  config.vm.define "app" do |app|
    app.vm.provider "docker" do |d|
      d.build_dir = "."
      d.name      = "texbin"

      # Without this, we wouldn't be able to change the code and
      # refresh the browser
      d.volumes   = ["#{Dir.pwd}:/texbin/app"]

      d.link "texbin_mongodb:mongodb"
    end
  end

  config.vm.define "web" do |web|
    web.vm.provider "docker" do |d|
      d.build_dir = "config/docker/nginx"
      d.name      = "texbin_nginx"
      d.ports     = ["80:80"]

      d.create_args = ["--volumes-from", "texbin"]

      d.link "texbin:app"
    end
  end
end
