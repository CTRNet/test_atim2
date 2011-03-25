<?php
class ReportsControllerCustom extends ReportsController {
	function procureConsentStat($data){
		$load_form = false;
		$this->ConsentMaster = AppModel::atimNew('Clinicalannotation', 'ConsentMaster', true);
		$error = null;
		if(!empty($data)){
			$this->set("csv", isset($data['action']) && $data['action'] == "true");
			$date_from = $data['report_date_range_start']['year']."-".$data['report_date_range_start']['month']."-".$data['report_date_range_start']['day']." 00:00:00";
			$date_to = $data['report_date_range_end']['year']."-".$data['report_date_range_end']['month']."-".$data['report_date_range_end']['day']." 23:59:59";
			$this->set("date_from", $date_from);
			$this->set("date_to", $date_to);
			if(!preg_match(VALID_DATETIME_YMD, $date_from) || !preg_match(VALID_DATETIME_YMD, $date_to)){
				$error = "error in the date definitions";
				$load_form = true;
			}else{
				//step 1 - fetch procure consents for specified interval
				$conditions = array(
					'ConsentMaster.consent_control_id' => 5, 
					"ConsentMaster.consent_signed_date BETWEEN '".$date_from."' AND '".$date_to."'");
				$fields = array(
					'YEAR(ConsentMaster.consent_signed_date) AS signed_year',
					'MONTH(ConsentMaster.consent_signed_date) AS signed_month',
					'ConsentMaster.*');
				
				//build time ranges
				$year_start = (int)$data['report_date_range_start']['year'];
				$month_start = (int)$data['report_date_range_start']['month'];
				$year_end = $tmp = (int)$data['report_date_range_end']['year'];
				$month_end = $tmp = (int)$data['report_date_range_end']['month'];
				$date_range = array();
				$data = array();
				
				$initial_data = array(0 => array(
						"denied" => 0,
						"participant" => 0,
						"blood" => 0,
						"urine" => 0,
						"questionnaire" => 0,
						"annual_followup" => 0,//TODO 
						"contact_if_info_req" => 0,
						"contact_if_discovery" => 0,
						"study_other_diseases" => 0,
						"contact_if_disco_other_diseases" => 0,
						"other_contacts_if_die" => 0//TODO
					)
				);
				AppController::addWarningMsg("Les valeurs pour le suivi annuel et les autres contacts en cas de décès ne sont pas calculées");
				while($year_start < $year_end || $month_start <= $month_end){
					$key = $year_start."-".$month_start;
					$data[$key] = $initial_data;
					$data[$key][0]['period'] = $key;
					$month_start ++;
					if($month_start > 12){
						$year_start ++;
						$month_start = 1;
					}
				}
				$tmp_data = $this->ConsentMaster->find('all', array('conditions' => $conditions, 'recursive' => 2, 'fields' => $fields, 'order' => array("ConsentMaster.consent_signed_date")));
				
				$participants_ids = $date_range;
				$data_result = array();
				foreach($tmp_data as $data_unit){
					$year = $data_unit[0]['signed_year'];
					$month = $data_unit[0]['signed_month'];
					$key = $year."-".$month;
					
					
					if($data_unit['ConsentMaster']['consent_status'] == 'denied' || $data_unit['ConsentMaster']['consent_status'] == 'withdrawn'){
						$data[$key][0]["denied"] ++;
					}
					$data[$key][0]["participant"] ++;
					if($data_unit['ConsentDetail']['use_of_blood'] == "yes"){
						$data[$key][0]["blood"] ++;
					}
					if($data_unit['ConsentDetail']['use_of_urine'] == "yes"){
						$data[$key][0]["urine"] ++;
					}
					if($data_unit['ConsentDetail']['allow_questionnaire'] == "yes"){
						$data[$key][0]["questionnaire"] ++;
					}
					
					if($data_unit['ConsentDetail']['contact_for_additional_data'] == 'yes'){
						$data[$key][0]["contact_if_info_req"] ++;
					}
					if($data_unit['ConsentDetail']['inform_significant_discovery'] == 'yes'){
						$data[$key][0]["contact_if_discovery"] ++;
					}
					if($data_unit['ConsentDetail']['research_other_disease'] == 'yes'){
						$data[$key][0]["study_other_diseases"] ++;
					}
					if($data_unit['ConsentDetail']['inform_discovery_on_other_disease'] == 'yes'){
						$data[$key][0]["contact_if_disco_other_diseases"] ++;
					}
				}
				
				$total = $initial_data[0];
				foreach($data as $key => $data_unit){
					$sub_data_unit = $data_unit[0];
					foreach($total as $sub_key => &$value){
						$value += $sub_data_unit[$sub_key];
					}
				}
				$total['period'] = __('total', true);
				$data['total'][0] = $total;
			}
		}else{
			$load_form = true;
		}
		$this->set("submit", $load_form);

		return array(
			"header"		=> "PROCURE - consent report",
			"data"			=> $data,
			"columns_names"	=> array(),
			"error_msg"		=> $error
		);
	}
}