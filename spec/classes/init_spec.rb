require 'spec_helper'
describe 'puppet', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('puppet') }
      it { is_expected.to contain_class('puppet::agent::install').that_comes_before('Class[puppet::agent::configure]') }
      it { is_expected.to contain_class('puppet::agent::configure').that_comes_before('Class[puppet::agent::service]') }
      it { is_expected.to contain_class('puppet::agent::service') }

      context 'when the package will be installed must be a puppet-agent' do
        it 'contains the package by default' do
          is_expected.to contain_package('puppet-agent').with(ensure: :present)
        end
      end

      context 'override config new values' do
        let(:params)  { { puppet_config_override_defaults: { 'main' => { 'certname': 'agent.server', 'server': 'server', 'environment': 'dev', 'runinterval' => '1m' } } } }
          it { is_expected.to contain_file('puppet/puppet.conf').with_content(%r{^certname = agent.server}) }
          it { is_expected.to contain_file('puppet/puppet.conf').with_content(%r{^server = server}) }
          it { is_expected.to contain_file('puppet/puppet.conf').with_content(%r{^environment = dev}) }
          it { is_expected.to contain_file('puppet/puppet.conf').with_content(%r{^runinterval = 1m}) }
      end

      context 'override config false' do
        let(:facts) { {'fqdn' => 'agent.lab', 'domain' => 'lab'} }
          it { is_expected.to contain_file('puppet/puppet.conf').with_content(%r{^certname = agent.lab}) }
          it { is_expected.to contain_file('puppet/puppet.conf').with_content(%r{^server = puppet.lab}) }
          it { is_expected.to contain_file('puppet/puppet.conf').with_content(%r{^environment = production}) }
          it { is_expected.to contain_file('puppet/puppet.conf').with_content(%r{^runinterval = 30m}) }
      end

      context 'when not managing the service' do
        let(:params) { { manage_service: false } }
          it { is_expected.to compile.with_all_deps }
          it { is_expected.not_to contain_service('puppet') }
      end

      context 'when managing the service' do
        let(:params) { { manage_service: true } }
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_service('puppet') }
      end

    end
  end
end

