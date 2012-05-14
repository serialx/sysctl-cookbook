#
# Cookbook Name:: sysctl
# Provider:: sysctl
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 20012, Societe Publica.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


action :save do
  template new_resource.path do
    notifies :start, 'service[procps]'
    source 'sysctl.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :instructions => new_resource.instructions,
      :name => new_resource.name_attribute)
  end
  new_resource.updated_by_last_action(true)
end


action :set do
  new_resource.instructions.each do |variable, value|
    execute 'set sysctl' do
      command "sysctl #{variable}=#{value}"
    end
  end
  new_resource.updated_by_last_action(true)
end


action :remove do
  file path do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end


private
def path
  f_name = new_resource.name.gsub(' ', '_')
  return new_resource.path ? new_resource.path : "/etc/sysctl.d/40-#{f_name}.conf"
end