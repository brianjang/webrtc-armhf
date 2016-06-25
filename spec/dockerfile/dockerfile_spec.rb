require 'spec_helper'

describe 'Dockerfile' do
  before(:all) do
    @containers = Docker::Container.all.select { |c| c.info['Image'] == 'tomasbasham/webrtc-armhf' }

    set :os, family: :debian
    set :backend, :docker
    set :docker_container, @containers.first.id
  end

  it 'installs the right version of Debian' do
    expect(os_version).to include('Debian GNU/Linux 8')
  end

  def os_version
    command('cat /etc/os-release').stdout
  end
end
