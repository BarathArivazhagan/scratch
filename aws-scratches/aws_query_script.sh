#!/bin/bash

export REGION=$1

if [ -z "$REGION" ]
then
    # set default region if region is emppty
    export REGION=us-east-1 
fi

echo "Running the script in Region: $REGION"

get_route_tables () {
    aws ec2 describe-route-tables --region $REGION > ${REGION}_route_tables.json
}

get_security_groups () {
   aws ec2 describe-security-groups --region $REGION > ${REGION}_security_groups.json
}

get_route53_zones () {
    aws route53 list-hosted-zones | jq -r ".HostedZones | .[] | .Id" 
}

get_route53_host_mappings () {

    for hosted_zone in $(get_route53_zones);
    do
        echo "Retrieving record sets from Hosted Zone ID: $hosted_zone"
        aws route53 list-resource-record-sets --hosted-zone-id $hosted_zone > $(echo $hosted_zone | tr -d "/hostedzone/")_record_sets.json
    done
}

main () {
    get_route_tables
    get_security_groups
    get_route53_host_mappings
}

main
