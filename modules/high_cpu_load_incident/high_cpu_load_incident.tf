resource "shoreline_notebook" "high_cpu_load_incident" {
  name       = "high_cpu_load_incident"
  data       = file("${path.module}/data/high_cpu_load_incident.json")
  depends_on = [shoreline_action.invoke_get_highest_cpu_usage,shoreline_action.invoke_cpu_processes_services_thresholds,shoreline_action.invoke_cpu_threshold_check]
}

resource "shoreline_file" "get_highest_cpu_usage" {
  name             = "get_highest_cpu_usage"
  input_file       = "${path.module}/data/get_highest_cpu_usage.sh"
  md5              = filemd5("${path.module}/data/get_highest_cpu_usage.sh")
  description      = "A process or application running on the server is consuming too much CPU resources, causing the overall load to increase."
  destination_path = "/agent/scripts/get_highest_cpu_usage.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cpu_processes_services_thresholds" {
  name             = "cpu_processes_services_thresholds"
  input_file       = "${path.module}/data/cpu_processes_services_thresholds.sh"
  md5              = filemd5("${path.module}/data/cpu_processes_services_thresholds.sh")
  description      = "The server is running too many applications or services simultaneously, leading to a high overall CPU load."
  destination_path = "/agent/scripts/cpu_processes_services_thresholds.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cpu_threshold_check" {
  name             = "cpu_threshold_check"
  input_file       = "${path.module}/data/cpu_threshold_check.sh"
  md5              = filemd5("${path.module}/data/cpu_threshold_check.sh")
  description      = "If possible, terminate any unnecessary processes or applications to free up CPU resources."
  destination_path = "/agent/scripts/cpu_threshold_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_get_highest_cpu_usage" {
  name        = "invoke_get_highest_cpu_usage"
  description = "A process or application running on the server is consuming too much CPU resources, causing the overall load to increase."
  command     = "`chmod +x /agent/scripts/get_highest_cpu_usage.sh && /agent/scripts/get_highest_cpu_usage.sh`"
  params      = []
  file_deps   = ["get_highest_cpu_usage"]
  enabled     = true
  depends_on  = [shoreline_file.get_highest_cpu_usage]
}

resource "shoreline_action" "invoke_cpu_processes_services_thresholds" {
  name        = "invoke_cpu_processes_services_thresholds"
  description = "The server is running too many applications or services simultaneously, leading to a high overall CPU load."
  command     = "`chmod +x /agent/scripts/cpu_processes_services_thresholds.sh && /agent/scripts/cpu_processes_services_thresholds.sh`"
  params      = []
  file_deps   = ["cpu_processes_services_thresholds"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_processes_services_thresholds]
}

resource "shoreline_action" "invoke_cpu_threshold_check" {
  name        = "invoke_cpu_threshold_check"
  description = "If possible, terminate any unnecessary processes or applications to free up CPU resources."
  command     = "`chmod +x /agent/scripts/cpu_threshold_check.sh && /agent/scripts/cpu_threshold_check.sh`"
  params      = []
  file_deps   = ["cpu_threshold_check"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_threshold_check]
}

