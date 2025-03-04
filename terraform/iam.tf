# IAM Role for Packer
resource "aws_iam_role" "packer_role" {
  name = "mp-packer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "mp-packer-role"
  }
}

# IAM Policy for Packer
resource "aws_iam_policy" "packer_policy" {
  name        = "mp-packer-policy"
  description = "Policy for Packer to create AMIs"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CopyImage",
          "ec2:CreateImage",
          "ec2:CreateKeypair",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteKeypair",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSnapshot",
          "ec2:DeleteVolume",
          "ec2:DeregisterImage",
          "ec2:DescribeImageAttribute",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume",
          "ec2:GetPasswordData",
          "ec2:ModifyImageAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifySnapshotAttribute",
          "ec2:RegisterImage",
          "ec2:RunInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "mp-packer-policy"
  }
}

# Attach the IAM Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "packer_policy_attachment" {
  role       = aws_iam_role.packer_role.name
  policy_arn = aws_iam_policy.packer_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "packer_instance_profile" {
  name = "mp-packer-profile"
  role = aws_iam_role.packer_role.name

  tags = {
    Name = "mp-packer-profile"
  }
}

# Output the IAM Instance Profile Name
output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.packer_instance_profile.name
}