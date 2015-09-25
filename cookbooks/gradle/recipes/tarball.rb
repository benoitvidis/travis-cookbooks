#
# Author:: Michael S. Klishin (<michaelklishin@me.com>)
# Cookbook Name:: gradle
# Recipe:: tarball
#
# Copyright 2012, Michael S. Klishin.
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

include_recipe 'travis_java'

package %w(groovy unzip)

tmp = File.join(Chef::Config[:file_cache_path], "gradle-#{node.gradle.version}-bin.zip")
tarball_dir = File.join(Chef::Config[:file_cache_path], "gradle-#{node.gradle.version}")

remote_file tmp do
  source node.gradle.tarball.url

  not_if "which gradle"
end

bash "extract #{tmp}, move it to #{node.gradle.installation_dir}" do
  user "root"
  cwd  "/tmp"

  code <<-EOS
    unzip #{tmp}
    rm -rf #{node.gradle.installation_dir}
    mv --force #{tarball_dir} #{node.gradle.installation_dir}
  EOS

  creates "#{node.gradle.installation_dir}/bin/gradle"
end


cookbook_file "/etc/profile.d/gradle.sh" do
  owner "root"
  group "root"
  mode 0644

  source "etc/profile.d/gradle.sh"
end
