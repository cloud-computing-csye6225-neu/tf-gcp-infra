# Google Cloud Platform Networking Setup

This project automates the setup of networking infrastructure on Google Cloud Platform (GCP) using Terraform. The configuration ensures the creation of a Virtual Private Cloud (VPC) with specific requirements and associated subnets. The infrastructure setup follows best practices and provides a flexible solution for multiple VPCs within the same GCP project.

## Prerequisites

Before proceeding, ensure you have the following prerequisites installed and configured:

1. **Google Cloud SDK (gcloud)**: Install and set up the Google Cloud SDK by following the instructions [here](https://cloud.google.com/sdk/docs/install).

2. **Terraform**: Install Terraform by following the instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

## Getting Started

Follow the steps below to set up the networking infrastructure using Terraform:

### configure GCP credentials in the environment
run the command `gcloud auth application-default login` to configure the GCP credentials

### Enable the API's
Enable Compute Engine API [here](https://console.developers.google.com/apis/library/compute.googleapis.com)

### Update Variables

Open the `variables.tf` file and update the necessary variables such as `num_vpcs`, `project`, etc., according to your GCP environment.

### Instructions to setup the networking infrastructure
1. Clone the repository
2. Run `terraform init` to initialize the terraform
3. Run `terraform apply` to apply the configuration
4. Run `terraform destry` to destory the configuration