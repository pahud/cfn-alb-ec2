#!/bin/bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
verbose=0

show_help() {
    echo "Usage: run.sh -a <action> -f <template_file> -s <stack_name> "
    echo "<action>: create|delete|update|validate|c|d|u|v"
}

while getopts "h?a:s:f:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    s)  stack_name=$OPTARG
        ;;
    a)  action=$OPTARG
        ;;
    f)  main_stack_file=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

region=${region-ap-southeast-1}
stack_name=${stack_name-main}
main_stack_file=${main_stack_file-main.yml}
aws_profile=${aws_profile-default}

create() {
	aws --profile=$aws_profile --region=$region \
	cloudformation create-stack --stack-name $stack_name \
	--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --template-body file:///$PWD/${main_stack_file} --disable-rollback
}

update() {
	aws --profile=$aws_profile --region=$region \
	cloudformation update-stack --stack-name $stack_name --template-body file:///$PWD/${main_stack_file}
}

delete() {
	aws --profile=$aws_profile --region=$region \
	cloudformation delete-stack --stack-name $stack_name
}

validate() {
	aws --profile=$aws_profile --region=$region \
	cloudformation validate-template --template-body file:///$PWD/${main_stack_file}
}

case $action in 
	create|c) 
		create
	;;
	update|u) 
		update
	;;
	delete|d) 
		delete
	;;
	validate|v) 
		validate
	;;
	*)
		show_help
		exit 1
esac


exit 0


