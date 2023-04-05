import boto3
def create_ec2_instance():
    resource_ec2=boto3.client("ec2")
    resource_ec2.run_instances(
        ImageId="ami-03a933af70fa97ad2",
        MinCount=1,
        MaxCount=1,
        InstanceType="t2.micro",
    )

    def create_security_group(self):
        sg_name = "awspy_security_group"
        try:
            vpc_id, subnet_id = self.grep_vpc_subnet_id()
            response = self.ec2_client.create_security_group(
                GroupName=sg_name,
                Description="This is created using python",
                VpcId=vpc_id
            )
            sg_id = response["GroupId"]
            print(sg_id)
            sg_config = self.ec2_client.authorize_security_group_ingress(
                GroupId=sg_id,
                IpPermissions=[
                    {
                        'IpProtocol': 'tcp',
                        'FromPort': 22,
                        'ToPort': 22,
                        'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
                    }
                ]
            )
            print(sg_config)
            return sg_id, sg_name
        except Exception as e:
            if str(e).__contains__("already exists"):
                response = self.ec2_client.describe_security_groups(GroupNames=[sg_name])
                sg_id = response["SecurityGroups"][0]["GroupId"]
                print(sg_id, sg_name)
                return sg_id, sg_name

    create_ec2_instance()
    create_security_group()sni