# Instances


get '/:project/compute' do

  @nodes = Chef::Node.list

  @servers = []
  @ec2_compute.servers.reverse.each do |server|
    node = JSON.parse(server.to_json)
    node["chefified"] = true if @nodes[server.id]
    @servers << node
  end
  
  erb :instances
end

get '/:project/instance/:instance_id/terminate' do
  @output =  @ec2_compute.servers.get(params[:instance_id]).destroy
  redirect '/instances'
end

get '/:project/instance/:instance_id/output' do
  @output =  @ec2_compute.servers.get(params[:instance_id]).console_output.body
  erb :output
end

get '/:project/instance/:instance_id/reboot' do
  node =  @ec2_compute.servers.get(params[:instance_id])
  @output = @node.reboot if @node['state'] == 'running'
  redirect '/instances'
end

get '/:project/instance/:instance_id/start' do
  node =  @ec2_compute.servers.get(params[:instance_id])
  @output = @node.start if @node['state'] == 'stopped'
  redirect '/instances'
end

get '/:project/instance/:instance_id/stop' do
  node =  @ec2_compute.servers.get(params[:instance_id])
  @output = @node.stop if @node['state'] == 'running'
  redirect '/instances'
end


get '/:project/instance/:instance_id/Chef' do  
  @node = Chef::Node.load(params[:instance_id])
  @node = JSON.pretty_generate(@node)
  erb :node_raw
end
