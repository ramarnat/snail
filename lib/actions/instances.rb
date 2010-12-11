# Instances

get '/:project/instances' do
  @servers = []
  @ec2_compute.servers.reverse.each do |server|
    @servers << JSON.parse(server.to_json)
  end
  erb :instances
end

get '/:project/instance/:instance_id/terminate' do
  @output = @ec2.terminate_instances(params[:instance_id])
  redirect '/instances'
end

get '/:project/instance/:instance_id/output' do
  @output = @ec2.get_console_output(params[:instance_id])
  erb :output
end

get '/:project/instance/:instance_id/reboot' do
  @ec2.reboot_instances([params[:instance_id]])
  redirect '/instances'
end
