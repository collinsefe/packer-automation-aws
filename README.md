# Packer Automation for Windows

## Project Description

This repository contains the Packer configuration files and scripts for automating the creation of Windows-based AMIs (Amazon Machine Images) on AWS. The project uses Packer to configure Windows instances, install necessary software, and prepare custom AMIs for use in cloud environments.

The goal of this project is to streamline the process of creating consistent and repeatable Windows-based AMIs that can be used for production, testing, or development environments.

## Prerequisites

Before you begin, make sure you have the following tools installed on your local machine:

- [Packer](https://www.packer.io/downloads) - Tool for automating the creation of machine images.
- [Terraform](https://www.terraform.io/downloads) - Infrastructure as code tool for provisioning resources.
- [AWS CLI](https://aws.amazon.com/cli/) - AWS Command Line Interface for interacting with AWS services.
- [AWS Account](https://aws.amazon.com/) - Active AWS account with necessary IAM permissions.
- [Git](https://git-scm.com/) - To clone the repository.

## Installation Instructions

### Step 1: Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/collinsefe/packer-automation-aws.git
cd packer-automation-aws

Run:
packer build <TEMPLATE_FILE>


