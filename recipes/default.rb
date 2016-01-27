execute "gem uninstall puma" do
  only_if "gem list | grep puma"
end

include_recipe "nginx"

directory "/etc/nginx/shared"
directory "/etc/nginx/http"
directory "/etc/nginx/ssl"

node[:deploy].each do |application, deploy|
  puma_config application do
    directory deploy[:deploy_to]
    environment deploy[:rails_env]
    logrotate false
    thread_min 1
    thread_max 1
    workers 5
    worker_timeout 120
    restart_timeout 120
    exec_prefix "bundle exec"
  end
end

package 'runit'

runit_service 'pact_broker' do
  action [:enable, :start]
end
