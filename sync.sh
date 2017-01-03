#!/bin/bash

base='cfn-alb-ec2'
aws s3 cp main.yml s3://pahud-cfn-templates/$base-main.yml
aws s3 cp vpc.yml s3://pahud-cfn-templates/$base-vpc.yml
aws s3 cp ec2elb.yml s3://pahud-cfn-templates/$base-ec2elb.yml
