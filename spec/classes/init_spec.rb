require 'spec_helper'
describe 'puppet', :type => :class do

  it { is_expected.to compile }
  it { is_expected.to compile.with_all_deps }

  it { is_expected.to contain_class('puppet') }
  it { is_expected.to contain_class('puppet::agent::install').that_comes_before('Class[puppet::agent::configure]') }
  it { is_expected.to contain_class('puppet::agent::configure').that_comes_before('Class[puppet::agent::service]') }
  it { is_expected.to contain_class('puppet::agent::service') }


end
