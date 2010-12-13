# IAM


get '/:project/IAM' do
    response = @ec2_iam.list_groups
    @iam_groups = response.body["Groups"]
    response = @ec2_iam.list_users
    @iam_users = response.body["Users"]
    response = @ec2_iam.list_access_keys 
    @iam_access_keys = response.body["AccessKeys"]

    erb :iam
end
