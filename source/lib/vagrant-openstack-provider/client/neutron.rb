require 'log4r'
require 'restclient'
require 'json'

require 'vagrant-openstack-provider/client/http_utils'
require 'vagrant-openstack-provider/client/domain'

module VagrantPlugins
  module Openstack
    class NeutronClient
      include Singleton
      include VagrantPlugins::Openstack::HttpUtils
      include VagrantPlugins::Openstack::Domain

      def initialize
        @logger = Log4r::Logger.new('vagrant_openstack::neutron')
        @session = VagrantPlugins::Openstack.session
      end

      def get_private_networks(env)
        networks_json = get(env, "#{@session.endpoints[:network]}/networks")
        networks = []
        JSON.parse(networks_json)['networks'].each do |n|
          networks << Item.new(n['id'], n['name']) if n['tenant_id'].eql? @session.project_id
        end
        networks
      end
    end
  end
end