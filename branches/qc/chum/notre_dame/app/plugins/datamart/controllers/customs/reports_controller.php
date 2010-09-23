<?php
class ReportsControllerCustom extends ReportsController {
	function procure_consent_stat(){
		$load_form = false;
		if(!App::import('Model', 'Clinicalannotation.ConsentMaster')){
			$this->redirect( '/pages/err_model_import_failed?p[]=ConsentMaster', NULL, TRUE );
		}
		$this->ConsentMaster = new ConsentMaster();
		if(!empty($this->data) && $this->ConsentMaster->validates($this->data)){
			$data = $this->data[0];
			$this->set("csv", $data['action'] == "true");
			$date_from = $data['date_from_start']['year']."-".$data['date_from_start']['month']."-".$data['date_from_start']['day']." 00:00:00";
			$date_to = $data['date_from_end']['year']."-".$data['date_from_end']['month']."-".$data['date_from_end']['day']." 23:59:59";
			$this->set("date_from", $date_from);
			$this->set("date_to", $date_to);
			if(!preg_match(VALID_DATETIME_YMD, $date_from) || !preg_match(VALID_DATETIME_YMD, $date_to)){
				$this->ConsentMaster->validationErrors[] = "error in the date definitions";
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
				$year_start = (int)$data['date_from_start']['year'];
				$month_start = (int)$data['date_from_start']['month'];
				$year_end = $tmp = (int)$data['date_from_end']['year'];
				$month_end = $tmp = (int)$data['date_from_end']['month'];
				$date_range = array();
				while($year_start < $year_end || $month_start <= $month_end){
					$date_range[$year_start][$month_start] = 0;
					$month_start ++;
					if($month_start > 12){
						$year_start ++;
						$month_start = 1;
					}
				}
				
				$tmp_data = $this->ConsentMaster->find('all', array('conditions' => $conditions, 'recursive' => 2, 'fields' => $fields));
				$this->data = array(0 => array(
						"denied" => $date_range,
						"participant" => $date_range,
						"blood" => $date_range,
						"urine" => $date_range,
						"questionnaire" => $date_range,
						"annual_followup" => $date_range,//TODO 
						"contact_if_info_req" => $date_range,
						"contact_if_discovery" => $date_range,
						"study_other_diseases" => $date_range,
						"contact_if_disco_other_diseases" => $date_range,
						"other_contacts_if_die" => $date_range//TODO
					)
				);
				$participants_ids = $date_range;
				
				foreach($tmp_data as $data_unit){
					$year = $data_unit[0]['signed_year'];
					$month = $data_unit[0]['signed_month'];
					
					$participants_ids[$year][$month] .= ",".$data_unit['ConsentMaster']['participant_id'];
					if($data_unit['ConsentMaster']['consent_status'] == 'denied' || $data_unit['ConsentMaster']['consent_status'] == 'withdrawn'){
						$this->data[0]["denied"][$year][$month] ++;
					}
					$this->data[0]["participant"][$year][$month] ++;
					if($data_unit['ConsentDetail']['use_of_blood'] == "yes"){
						$this->data[0]["blood"][$year][$month] ++;
					}
					if($data_unit['ConsentDetail']['use_of_urine'] == "yes"){
						$this->data[0]["urine"][$year][$month] ++;
					}
					if($data_unit['ConsentDetail']['allow_questionnaire'] == "yes"){
						$this->data[0]["questionnaire"][$year][$month] ++;
					}
					
					if($data_unit['ConsentDetail']['contact_for_additional_data'] == 'yes'){
						$this->data[0]["contact_if_info_req"][$year][$month] ++;
					}
					if($data_unit['ConsentDetail']['inform_significant_discovery'] == 'yes'){
						$this->data[0]["contact_if_discovery"][$year][$month] ++;
					}
					if($data_unit['ConsentDetail']['research_other_disease'] == 'yes'){
						$this->data[0]["study_other_diseases"][$year][$month] ++;
					}
					if($data_unit['ConsentDetail']['inform_discovery_on_other_disease'] == 'yes'){
						$this->data[0]["contact_if_disco_other_diseases"][$year][$month] ++;
					}
				}
			}
		}else{
			$load_form = true;
		}
		
		$this->Structures->set("qc_nd_procure_consent_stats_report");
		if($load_form){
			$this->set("submit", true);
		}
	}
}