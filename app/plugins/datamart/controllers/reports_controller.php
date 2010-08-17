<?php
class ReportsController extends DatamartAppController {
	var $uses = array(
		"Datamart.Report",
		"Datamart.DatamartStructure",
		"Structure");
	
	function index(){
		$this->data = $this->paginate($this->Report);
		$this->Structures->set("reports");
	}
	
	
	/**
	 * This function intends to allow a user to build a report by himself based on existing structures and models.
	 * We currently think that a report generator could hardly fit the users needs and that full custom reports
	 * should be used istead. 
	 * @param unknown_type $report_structure_id
	 */
	function add($report_structure_id = 0){
		$this->flash("this function is disabled", "/datamart/reports/index/");
		if(!empty($this->data)){
			$info = $this->data['Report'];
			unset($this->data['Report']);
			AppController::cleanArray($this->data);
			//put group conditions in an array
			foreach($this->data as $model => $fields){
				foreach($fields as $field_name => $options){
					foreach($options as $option_name => $option_value){
						if($option_name == "group"){
							if($option_value == "on"){
								$this->data[$model][$field_name]['group'] = array();
							}else{
								$keys = explode(";", $option_value);
								$keys = array_map("trim", $keys);
								$this->data[$model][$field_name]['group'] = array_fill_keys($keys, null);
							} 
						}
					}
				}
			}
			$report = array("Report" => array(
				"name" => $info['name'],
				"description" => $info['description'],
				"datamart_structure_id" => $info['structure_id'],
				"custom_function" => "acess",
				"serialized_representation" => serialize($this->data) 
				));
			$this->Report->save($report);
			$this->atimFlash('your data has been saved', "/datamart/reports/index");
		}
		$this->Structures->set("empty", "empty_structure");
		if($report_structure_id){
			//layout = ajax to avoid printing layout
			$this->layout = 'ajax';
			//debug = 0 to avoid printing debug queries that would break the javascript array
//			Configure::write('debug', 0);
			$rs = $this->DatamartStructure->find('first', array('conditions' => array('id' => $report_structure_id)));
			$structure = $this->Structures->getSimplifiedFormById($rs['DatamartStructure']['structure_id']);
			$this->set("structure", $structure);
		}else{
			$this->Structures->set("reports", "head_structure");
			$this->Structures->set("report_structures", "report_structures");
			$this->set("report_structures_data", $this->DatamartStructure->find('all'));
		}
	}
	
	function access($report_id){
		$report = $this->Report->findById($report_id);
		if($report['Report']['function'] != null){
			$this->redirect("/datamart/reports/".$report['Report']['function']."/");
		}else{
			$this->set("report", $report);
			$ds = $this->DatamartStructure->findById($report['Report']['datamart_structure_id']);
			$model_to_import = $ds['DatamartStructure']['plugin'].".".$ds['DatamartStructure']['model'];
			if(!App::import('Model', $model_to_import)){
				$this->redirect( '/pages/err_model_import_failed?p[]='.$model_to_import, NULL, TRUE );
			}
			$this->ModelToSearch = new $ds['DatamartStructure']['model'];
			$fields = unserialize($report['Report']['serialized_representation']);
			$structure = $this->Structures->getSimplifiedFormById($ds['DatamartStructure']['structure_id']);
			$size = $this->ModelToSearch->find('count');
			
			$straight_conditions = array();
			foreach($fields as $model => $field){
				foreach($field as $field_name => $search){
					foreach($search as $search_key => $search_param){
						if($search_key == "min" || $search_key == "max" || $search_key == "avg"){
							$straight_conditions[] = $search_key."(".$model.".".$field_name.") AS ".$search_key."_".$model."_".$field_name;
						}else if($search_key == "group"){
							if(!empty($search_param)){
								$str_cond = "IF(".$model.".".$field_name." IS NULL, 'NULL', ";
								ksort($search_param);
								foreach($search_param as $key => $foo){
									$str_cond .= "IF(".$model.".".$field_name." < '".$key."', '".$key."', ";
								}
								$str_cond .= '"'.__("higher", true).'"'.str_repeat(")", count($search_param) + 1)." AS field ";
								$tmp_data = $this->ModelToSearch->find('all', array('fields' => array("COUNT(*) AS c", $str_cond), 'group' => array("field")));
								foreach($tmp_data as $unit){
									$fields[$model][$field_name][$search_key][$unit[0]['field']] = $unit[0]['c'];
								}
							}else{
								$tmp_data = $this->ModelToSearch->find('all', array('fields' => array("COUNT(*) AS c", $field_name." AS field"), 'group' => array($field_name)));
								foreach($tmp_data as $unit){
									$fields[$model][$field_name][$search_key][$unit[$model]['field']] = $unit[0]['c'];
								}
							}
						}else if(Configure::read('debug') == 2){
							echo("Unknown condition");
						}
					}
				}
			}
			$straight_result = $this->ModelToSearch->find('all', array('fields' => $straight_conditions));
			
			foreach($fields as $model => $field){
				foreach($field as $field_name => $search){
					foreach($search as $search_key => $search_param){
						if($search_key == "min" || $search_key == "max" || $search_key == "avg"){
							$fields[$model][$field_name][$search_key] = $straight_result[0][0][$search_key."_".$model."_".$field_name];
						}
					}
				}
			}
			$this->set("data", $fields);
			$this->set("simplified_structure", $structure);
			$this->Structures->set("empty", "empty_structure");
		}
	}
	
	function nb_consent_by_month($csv = false){
		App::import('Model', 'Clinicalannotation.ConsentMaster');
		$this->ConsentMaster = new ConsentMaster();
		$load_form = false;
		if(!empty($this->data) && $this->ConsentMaster->validates($this->data)){
			$data = $this->data[0];
			$date_from = $data['date_from_start']['year']."-".$data['date_from_start']['month']."-01 00:00:00";
			$date_to = $data['date_from_end']['year']."-".$data['date_from_end']['month']."-".$data['date_from_end']['day']." 23:59:59";
			if(!preg_match(VALID_DATETIME_YMD, $date_from) || !preg_match(VALID_DATETIME_YMD, $date_to)){
				$this->ConsentMaster->validationErrors[] = "error in the date definitions";
				$load_form = true;
			}else{
				//show stats
				$this->data = $this->ConsentMaster->find('all', array(
					'fields' => array("YEAR(ConsentMaster.consent_signed_date) AS y", "MONTH(ConsentMaster.consent_signed_date) AS m", "COUNT(*) AS c"),
					'conditions' => array("ConsentMaster.consent_status" => "obtained", "ConsentMaster.consent_signed_date BETWEEN '".$date_from."' AND LAST_DAY('".$date_to."')"),
					'group' => array("y", "m"),
					'order' => array("y", "m"),
					'recursive' => -1));
				$this->Structures->set("empty");
				$this->set("date_from", $date_from);
				$this->set("date_to", $date_to);
				
				$this->set("csv", $csv);
				if($csv){
					Configure::write('debug', 0);
					$this->layout = false;
				}
			}
		}else{
			$load_form = true;
		}
		
		if($load_form){
			//date range form
			$this->Structures->set("date_range");
			$this->set("submit", true);
		}
	}
	
	function samples_by_type($csv = false){
		App::import('Model', 'Inventorymanagement.SampleMaster');
		$this->SampleMaster = new SampleMaster();
		$load_form = false;
		if(!empty($this->data) && $this->SampleMaster->validates($this->data)){
			$data = $this->data[0];
			$date_from = $data['date_from_start']['year']."-".$data['date_from_start']['month']."-".$data['date_from_start']['day']." 00:00:00";
			$date_to = $data['date_from_end']['year']."-".$data['date_from_end']['month']."-".$data['date_from_end']['day']." 23:59:59";
			if(!preg_match(VALID_DATETIME_YMD, $date_from) || !preg_match(VALID_DATETIME_YMD, $date_to)){
				$this->SampleMaster->validationErrors[] = "error in the date definitions";
				$load_form = true;
			}else{
				//show stats
				$this->data = array(); //clear this data to have a clena CSV if needed
				$this->set("my_data", $this->SampleMaster->find('all', array(
					'fields' => array("COUNT(*) AS c", "SampleMaster.sample_type AS sample_type"),
					'conditions' => array("SampleMaster.created BETWEEN '".$date_from."' AND '".$date_to."'"),
					'group' => array("sample_type"),
					'recursive' => -1)));
				$this->Structures->set("empty");
				$this->set("date_from", $data['date_from_start']);
				$this->set("date_to", $data['date_from_end']);
				
				$this->set("csv", $csv);
				if($csv){
					Configure::write('debug', 0);
					$this->layout = false;
				}
			}
			
		}else{
			$load_form = true;
		}
		
		if($load_form){
			$this->Structures->set("date_range");
			$this->set("submit", true);
		}
	}
}