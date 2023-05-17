# Introduction to Terraform

You have used the web console to configure AWS services

You have used the CLI to configure AWS services

Now it's time to step up our coding and automation skills and use [Infrastructure as Code](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code), in the form of Terraform, to create your cloud infrastructure 👩‍💻

This exercise will guide you through getting started with terraform and then ask you to create the code to provision resources

## ⭐️ Golden rule ⭐️

Now that you are entering the world of infrastructure as code there is one golden rule to keep in your mind.

__*Once you are managing a piece of infrastructure using terraform you should ALWAYS manage that infrastructure with terraform.*__

Said another way, don't edit things bespokely in the console or via the CLI. If Terraform was used to create the infrastructure then terraform should be used to modify or remove it

## Instructions

### 1. Terraform AWS getting started guide

The first step is to get setup with Terraform and their AWS Getting Started guide is a great place to start.

Before you get started, here are a couple of guidance points:

**Remote state stage**

Ignore the final stage which is the remote state stage. We are going to cover that in more detail later.

**Authenticating terraform for your AWS account**

In the guide it tells you to set the `AWS_ACCESS_KEY_ID` and the `AWS_SECRET_ACCESS_KEY` - this approach would be used if you are using long live credentials (and is a bit insecure as we have already discussed) so instead we can continue to leverage the refresh token and AWS SSO login approach.

Instead of setting the variables as indicated in the terraform guide you should perform the `aws sso login` command approach to authenticate your AWS command line. 

Validate that your AWS CLI is authenticated using the usual `aws sts get-caller-identity` approach

Once your AWS CLI is authenticated then we just need to inform terraform of what your AWS profile is called. To do this run the following (replacing the REPLACE_ME section with whatever you called your AWS profile):

```
export AWS_PROFILE="REPLACE_ME"
```

Then you can run the `terraform` commands as indicated through the guide and they should authenticate fine.

**Directories and files**

Make sure to create any directories or files within this repository so that they will be included in your submission

**Screenshots**

Once you have a successful `terraform apply` outcome, take a screenshot showing the output from the command line and a second screenshot showing your EC2 instance running in the console. The screenshots should be placed within the **learn-terraform-aws-instance** directory.

===

Ok now that you've got a few guidance points here's the link to get started:


[Terraform AWS Getting Started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)

Once finished, make sure to commit and push your code at this point

### 2. Re-creating the production ready network

Using your new skills it's time to convert that production ready VPC into terraform

Create a new directory called **learn-terraform-cloud-engineering-exercise** and within there create your **main.tf** file. 

🗒️ Note: The **learn-terraform-cloud-engineering-exercise** must NOT be placed within the **learn-terraform-aws-instance** directory otherwise Terraform will get confused about the state

Your terraform config should:

* A VPC with the correct private IP address space CIDR range
* 6 subnets in total 
* 3 subnets, one in each availability zone, named as public
* 3 subnets, one in each availability zone, named as private

Make sure to commit and push your code at this point

### 3. Variables and looping

Let's now refactor - its often a could tactic to keep your code [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

If you haven't used variables, see if you can utilise variables for defining the CIDR ranges and how you might loop over them to create your subnets

Make sure to commit and push your code at this point

### 4. Modules

Let's take things even further - people have made it even easier to write terraform by providing re-usable [modules](https://developer.hashicorp.com/terraform/language/modules) which means less boiler plater code for you to write.

See if you can refactor your code to utilise the [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)


## Tearing things down

Make sure you have ran `terraform destroy` within the **learn-terraform-aws-instance** directory AND the **learn-terraform-cloud-engineering-exercise** directory

You can validate this by going on to the console and making sure your EC2 instance is no longer running and any VPC's created by Terraform are no longer there.


## Submission process

1. Fork this GitHub repository

2. Make regular commits and pushes back to your repository as you write your code. At a minimum commit and push when indicated in the instructions but feel free to commit more often. It help's to see the journey you worked through when completing the task.

3. Share your GitHub link

4. Tear things down as described above


## Further reading 

[Terraform variables](https://developer.hashicorp.com/terraform/language/values/variables)

[Terraform loops and tricks](https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)

[Terraform module library](https://registry.terraform.io/browse/modules)

[Cloud Development Kit (CDK) - An AWS specific infrastructure as code tool](https://aws.amazon.com/cdk/)

[Pulumi - An alternative infrastructure as code tool](https://www.pulumi.com/)

