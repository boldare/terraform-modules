/**
 * # AWS WAF
 * 
 * This module is used to restrict access to a CloudFront distribution based on IP whitelist.
 * It creates a Web Application Firewall rule that can be added to an existing CF distribution.
 */

# ------------------------------------
# WEB APPLICATION FIRWEWALL
# ------------------------------------

resource "aws_waf_ipset" "ipset" {
  count = length(var.allowed_ips) > 0 ? 1 : 0
  name  = "${var.name}-ipset"
  dynamic "ip_set_descriptors" {
    iterator = ip
    for_each = var.allowed_ips
    content {
      type  = "IPV4"
      value = ip.value
    }
  }
}

resource "aws_waf_rule" "wafrule" {
  count       = length(var.allowed_ips) > 0 ? 1 : 0
  name        = "${var.name}-rule"
  metric_name = replace("${var.name}WafRule", "-", "")

  predicates {
    data_id = aws_waf_ipset.ipset[count.index].id
    negated = false
    type    = "IPMatch"
  }
  tags = var.tags
}

resource "aws_waf_web_acl" "waf_acl" {
  count       = length(var.allowed_ips) > 0 ? 1 : 0
  name        = "${var.name}-acl"
  metric_name = replace("${var.name}WafAcl", "-", "")

  default_action {
    type = "BLOCK"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = aws_waf_rule.wafrule[count.index].id
    type     = "REGULAR"
  }
  tags = var.tags
}
