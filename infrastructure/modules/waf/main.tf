# AWS WAFv2 IP Set (Allow Specific IP)
resource "aws_wafv2_ip_set" "hnc_allowed_ip_set" {
  name            = "allowed-ip-set"
  scope           = "REGIONAL"
  addresses       = [var.source_ip]
  ip_address_version = "IPV4"

  tags = {
    Name = "allowed-ip-set"
  }
}

# AWS WAFv2 Web ACL
resource "aws_wafv2_web_acl" "hnc_waf_web_acl" {
  name        = "hnc-webacl"
  scope       = "REGIONAL"
  default_action {
    allow {} # Default action is to allow if no rules match
  }

  rule {
    name     = "AllowSpecificIP"
    priority = 1
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.hnc_allowed_ip_set.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AllowedIPRule"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "HnCWebACL"
    sampled_requests_enabled   = false
  }

  tags = {
    Name = "HNC WAF Web ACL"
  }
}

# --- Associate WAF with the Application Load Balancer ---
resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = var.public_alb_arn
  web_acl_arn  = aws_wafv2_web_acl.hnc_waf_web_acl.arn
}