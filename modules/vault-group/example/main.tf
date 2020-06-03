locals {
  # We have to define Secret Engine types, because policy templates differ between different Secret Engines
  non_prod = {
    kv       = ["kv2", var.non_prod_secret_engines.kv]
    rabbitmq = ["rabbitmq", var.non_prod_secret_engines.rabbitmq]
    mongodb  = ["db", var.non_prod_secret_engines.mongodb]
  }

  prod = {
    kv       = ["kv2", var.prod_secret_engines.kv]
    rabbitmq = ["rabbitmq", var.prod_secret_engines.rabbitmq]
    mongodb  = ["db", var.prod_secret_engines.mongodb]
  }

  # Now we define some boilerplate to be able to reuse it when setting up multiple envs running on the same secret engine
  sales = {
    non_prod = local.non_prod
    prod     = local.prod
  }

  internal = {
    non_prod = {
      kv = local.non_prod.kv
    }
    prod = {
      kv = local.prod.kv
    }
  }
}

module "sales_groups" {
  source = "../"

  name = "sales"
  groups = {
    # This group has full access to Sales dev env
    non_prod = {
      entities     = var.non_prod_access
      policies     = ["read", "write"]
      environments = ["dev"]
    }
    # This group has full access to Sales dev and prod envs
    prod = {
      entities     = var.prod_access
      policies     = ["read", "write"]
      environments = ["dev", "prod"]
    }
  }
  environments = {
    dev  = local.sales.non_prod
    prod = local.sales.prod
  }
}

module "internal_groups" {
  source = "../"

  name = "sales"
  groups = {
    # This group has full access to Internal local, dev, staging, test and demo envs
    # Note that they're all based on the same "non_prod" secret engines and we don't have to redefine anything
    dev = {
      entities     = var.non_prod_access
      policies     = ["read", "write"]
      environments = ["local", "dev", "staging", "test", "demo"]
    }
    # This group has read-only access to Internal prod env
    prod = {
      entities     = var.prod_access
      policies     = ["read"]
      environments = ["prod"]
    }
  }
  environments = {
    local   = local.internal.non_prod
    dev     = local.internal.non_prod
    staging = local.internal.non_prod
    test    = local.internal.non_prod
    demo    = local.internal.non_prod
    prod    = local.internal.prod
  }
}
