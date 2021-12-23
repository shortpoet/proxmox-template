locals {

  defaults = {
    label_order         = ["namespace", "project", "name", "region", "environment", "attributes"]
    regex_replace_chars = "/[^-a-zA-Z0-9_]/"
    delimiter           = "-"
    replacement         = ""
    id_length_limit     = 0
    id_hash_length      = 5
    label_key_case      = "title"
    label_value_case    = "lower"

    # The default value of labels_as_tags cannot be included in this
    # defaults` map because it creates a circular dependency
  }

  default_labels_as_tags = keys(local.tags_context)
  # Unlike other inputs, the first setting of `labels_as_tags` cannot be later overridden. However,
  # we still have to pass the `input` map as the context to the next module. So we need to distinguish
  # between the first setting of var.labels_as_tags == null as meaning set the default and do not change
  # it later, versus later settings of var.labels_as_tags that should be ignored. So, we make the
  # default value in context be null, meaning it can be changed, but when it is null and
  # var.labels_as_tags is null, we change it to []. Once it is set to [] we will
  # not allow it to be changed again, but of course we have to detect [] and replace it
  # with local.default_labels_as_tags when we go to use it.
  #
  # To determine whether that context.labels_as_tags is null.
  context_labels_as_tags_is_null = try(var.context.labels_as_tags == null, true)

  # The values provided by variables supersede the values inherited from the context object,
  # except for tags and attributes which are merged.
  input = {
    # It would be nice to use coalesce here, but we cannot, because it
    # is an error for all the arguments to coalesce to be empty.
    enabled     = var.enabled == null ? var.context.enabled : var.enabled
    namespace   = var.namespace == null ? var.context.namespace : var.namespace
    project     = var.project == null ? var.context.project : var.project
    name        = var.name == null ? var.context.name : var.name
    region      = var.region == null ? var.context.region : var.region
    environment = var.environment == null ? var.context.environment : var.environment
    delimiter   = var.delimiter == null ? var.context.delimiter : var.delimiter
    # modules tack on attributes (passed by var) to the end of the list (passed by context)
    attributes = compact(distinct(concat(coalesce(var.context.attributes, []), coalesce(var.attributes, []))))
    tags       = merge(var.context.tags, var.tags)

    additional_tag_map  = merge(var.context.additional_tag_map, var.additional_tag_map)
    label_order         = var.label_order == null ? var.context.label_order : var.label_order
    regex_replace_chars = var.regex_replace_chars == null ? var.context.regex_replace_chars : var.regex_replace_chars
    replacement         = var.replacement == null ? var.replacement : var.replacement
    id_hash_length      = var.id_hash_length == null ? var.id_hash_length : var.id_hash_length
    id_length_limit     = var.id_length_limit == null ? var.context.id_length_limit : var.id_length_limit
    label_key_case      = var.label_key_case == null ? lookup(var.context, "label_key_case", null) : var.label_key_case
    label_value_case    = var.label_value_case == null ? lookup(var.context, "label_value_case", null) : var.label_value_case

    labels_as_tags = local.context_labels_as_tags_is_null ? var.labels_as_tags : var.context.labels_as_tags
  }


  enabled             = local.input.enabled
  regex_replace_chars = coalesce(local.input.regex_replace_chars, local.defaults.regex_replace_chars)

  # string_label_names are names of inputs that are strings (not list of strings) used as labels
  string_label_names = ["namespace", "project", "name", "region", "environment"]
  normalized_labels = { for k in local.string_label_names : k =>
    local.input[k] == null ? "" : replace(local.input[k], local.regex_replace_chars, local.replacement)
  }
  normalized_attributes = compact(distinct([for v in local.input.attributes : replace(v, local.regex_replace_chars, local.replacement)]))

  formatted_labels = { for k in local.string_label_names : k => local.label_value_case == "none" ? local.normalized_labels[k] :
    local.label_value_case == "title" ? title(lower(local.normalized_labels[k])) :
    local.label_value_case == "upper" ? upper(local.normalized_labels[k]) : lower(local.normalized_labels[k])
  }

  attributes = compact(distinct([
    for v in local.normalized_attributes : (local.label_value_case == "none" ? v :
      local.label_value_case == "title" ? title(lower(v)) :
    local.label_value_case == "upper" ? upper(v) : lower(v))
  ]))

  namespace   = local.formatted_labels["namespace"]
  project     = local.formatted_labels["project"]
  name        = local.formatted_labels["name"]
  region      = local.formatted_labels["region"]
  environment = local.formatted_labels["environment"]

  delimiter        = local.input.delimiter == null ? local.defaults.delimiter : local.input.delimiter
  label_order      = local.input.label_order == null ? local.defaults.label_order : coalescelist(local.input.label_order, local.defaults.label_order)
  replacement      = local.input.replacement == null ? local.defaults.replacement : local.input.replacement
  id_hash_length   = local.input.id_hash_length == null ? local.defaults.id_hash_length : local.input.id_hash_length
  id_length_limit  = local.input.id_length_limit == null ? local.defaults.id_length_limit : local.input.id_length_limit
  label_key_case   = local.input.label_key_case == null ? local.defaults.label_key_case : local.input.label_key_case
  label_value_case = local.input.label_value_case == null ? local.defaults.label_value_case : local.input.label_value_case

  # labels_as_tags is an exception to the rule that input vars override context values (see above)
  labels_as_tags = local.input.labels_as_tags == null ? local.default_labels_as_tags : local.input.labels_as_tags

  additional_tag_map = merge(var.context.additional_tag_map, var.additional_tag_map)

  tags = merge(local.generated_tags, local.input.tags)

  tags_as_list_of_maps = flatten([
    for key in keys(local.tags) : merge(
      {
        key   = key
        value = local.tags[key]
    }, local.additional_tag_map)
  ])

  tags_context = {
    namespace = local.namespace
    project   = local.project
    # For AWS we need `Name` to be disambiguated since it has a special meaning
    name        = local.id
    region      = local.region
    environment = local.environment
    attributes  = local.id_context.attributes
  }

  generated_tags = {
    for l in setintersection(keys(local.tags_context), local.labels_as_tags) :
    local.label_key_case == "upper" ? upper(l) : (
      local.label_key_case == "lower" ? lower(l) : title(lower(l))
    ) => local.tags_context[l] if length(local.tags_context[l]) > 0
  }

  id_context = {
    namespace   = local.namespace
    project     = local.project
    name        = local.name
    region      = local.region
    environment = local.environment
    attributes  = join(local.delimiter, local.attributes)
  }

  labels = [for l in local.label_order : local.id_context[l] if length(local.id_context[l]) > 0]

  id_full = join(local.delimiter, local.labels)
  # Create a truncated ID if needed
  delimiter_length = length(local.delimiter)
  # Calculate length of normal part of ID, leaving room for delimiter and hash
  id_truncated_length_limit = local.id_length_limit - (local.id_hash_length + local.delimiter_length)
  # Truncate the ID and ensure a single (not double) trailing delimiter
  id_truncated = local.id_truncated_length_limit <= 0 ? "" : "${trimsuffix(substr(local.id_full, 0, local.id_truncated_length_limit), local.delimiter)}${local.delimiter}"
  # Support usages that disallow numeric characters. Would prefer tr 0-9 q-z but Terraform does not support it.
  # Take the hash of only the characters being removed,
  # so identical removed strings would produce identical hashes.
  id_hash_plus = "${md5(trimprefix(local.id_full, local.id_truncated))}qrstuvwxyz"
  id_hash_case = local.label_value_case == "title" ? title(local.id_hash_plus) : local.label_value_case == "upper" ? upper(local.id_hash_plus) : local.label_value_case == "lower" ? lower(local.id_hash_plus) : local.id_hash_plus
  id_hash      = replace(local.id_hash_case, local.regex_replace_chars, local.replacement)
  # Create the short ID by adding a hash to the end of the truncated ID
  id_short = substr("${local.id_truncated}${local.id_hash}", 0, local.id_length_limit)
  id       = local.id_length_limit != 0 && length(local.id_full) > local.id_length_limit ? local.id_short : local.id_full


  # Context of this label to pass to other label modules
  output_context = {
    enabled             = local.enabled
    namespace           = local.namespace
    name                = local.name
    region              = local.region
    environment         = local.environment
    attributes          = local.attributes
    delimiter           = local.delimiter
    tags                = local.tags
    additional_tag_map  = local.additional_tag_map
    label_order         = local.label_order
    regex_replace_chars = local.regex_replace_chars
    replacement         = local.replacement
    id_hash_length      = local.id_hash_length
    id_length_limit     = local.id_length_limit
    label_key_case      = local.label_key_case
    label_value_case    = local.label_value_case
    labels_as_tags      = local.labels_as_tags
  }

}
