resource "shoreline_notebook" "high_cpu_load_incident" {
  name       = "high_cpu_load_incident"
  data       = file("${path.module}/data/high_cpu_load_incident.json")
  depends_on = [shoreline_action.invoke_get_highest_cpu_usage_info,shoreline_action.invoke_cpu_process_service_thresholds,shoreline_action.invoke_cpu_threshold]
}

resource "shoreline_file" "get_highest_cpu_usage_info" {
  name             = "get_highest_cpu_usage_info"
  input_file       = "${path.module}/data/get_highest_cpu_usage_info.sh"
  md5              = filemd5("${path.module}/data/get_highest_cpu_usage_info.sh")
  description      = "A process or application running on the server is consuming too much CPU resources, causing the overall load to increase."
  destination_path = "/agent/scripts/get_highest_cpu_usage_info.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cpu_process_service_thresholds" {
  name             = "cpu_process_service_thresholds"
  input_file       = "${path.module}/data/cpu_process_service_thresholds.sh"
  md5              = filemd5("${path.module}/data/cpu_process_service_thresholds.sh")
  description      = "The server is running too many applications or services simultaneously, leading to a high overall CPU load."
  destination_path = "/agent/scripts/cpu_process_service_thresholds.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cpu_threshold" {
  name             = "cpu_threshold"
  input_file       = "${path.module}/data/cpu_threshold.sh"
  md5              = filemd5("${path.module}/data/cpu_threshold.sh")
  description      = "If possible, terminate any unnecessary processes or applications to free up CPU resources."
  destination_path = "/agent/scripts/cpu_threshold.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_get_highest_cpu_usage_info" {
  name        = "invoke_get_highest_cpu_usage_info"
  description = "A process or application running on the server is consuming too much CPU resources, causing the overall load to increase."
  command     = "`chmod +x /agent/scripts/get_highest_cpu_usage_info.sh && /agent/scripts/get_highest_cpu_usage_info.sh`"
  params      = []
  file_deps   = ["get_highest_cpu_usage_info"]
  enabled     = true
  depends_on  = [shoreline_file.get_highest_cpu_usage_info]
}

resource "shoreline_action" "invoke_cpu_process_service_thresholds" {
  name        = "invoke_cpu_process_service_thresholds"
  description = "The server is running too many applications or services simultaneously, leading to a high overall CPU load."
  command     = "`chmod +x /agent/scripts/cpu_process_service_thresholds.sh && /agent/scripts/cpu_process_service_thresholds.sh`"
  params      = []
  file_deps   = ["cpu_process_service_thresholds"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_process_service_thresholds]
}

resource "shoreline_action" "invoke_cpu_threshold" {
  name        = "invoke_cpu_threshold"
  description = "If possible, terminate any unnecessary processes or applications to free up CPU resources."
  command     = "`chmod +x /agent/scripts/cpu_threshold.sh && /agent/scripts/cpu_threshold.sh`"
  params      = []
  file_deps   = ["cpu_threshold"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_threshold]
}

