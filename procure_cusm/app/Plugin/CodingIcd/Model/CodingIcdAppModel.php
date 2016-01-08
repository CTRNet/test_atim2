<?php
class CodingIcdAppModel extends AppModel {	
	
	/**
	 * @param unknown_type $id The id of the code to get the description of
	 * @return the description of an icd code
	 * @note: This is CodingIcdAppModel, thus this function must work for all coding
	 */
	function getDescription($id){
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		if(isset(AppController::getInstance()->csv_config) && isset(AppController::getInstance()->csv_config['config_language'])){
			$lang = AppController::getInstance()->csv_config['config_language'] == "eng" ? "en" : "fr";
		}
		$data = $this->find('first', array('conditions' => array('id' => $id), 'fields' => array($lang."_description")));
		$description = '';
		if(is_array($data) && !empty($data)) {
			//useless if, but php generates a bogus warning without it
			$data = array_values($data);
			$data = array_values($data[0]);
			$description = $data[0];
		}
		return $description;
	}
	
	function globalValidateId($id){
		if(is_array($id)){
			$id = array_values($id);
			$id = $id[0];
		}
		return strlen($id) > 0 ? strlen($this->getDescription($id)) > 0 : true;
	}

	function globalSearch(array $terms, $exact_search, $search_on_id, $limit){
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		$search_fields = array();
		$conditions = array();
		$search_fields = array_keys($this->schema());
		$filter_key = $lang.'_';
		$search_fields = array_filter($search_fields, function($in) use ($filter_key){return strpos($in, $filter_key) === 0;});

		if($search_on_id){
			$search_fields[] = "id";
		}
		
		if (!$db = ConnectionManager::getDataSource($this->useDbConfig)) {
			return false;
		}
			
		foreach($terms as $term){
			
			if(strlen($term) > 3) {
				if($exact_search){
					$term = "+".preg_replace("/(\s)([^ \t\r\n\v\f])/", "$1+$2", trim($term));
				}else{
					$term = preg_replace("/([^ \t\r\n\v\f])(\s)/", "$1*$2", trim($term))."*";
				}
				$term = $db->value($term);
				$conditions[] = "MATCH(".implode(", ", $search_fields).") AGAINST (".$term." IN BOOLEAN MODE)";
			} else {
				//See issue#3019: Disease Code: Search on short string like 'C61' failed 
				$small_term_conditions = '';
				foreach($search_fields as $new_field) {
					if($exact_search){
						$conditions[] = "$new_field LIKE '$term'";
					} else {
						$conditions[] = "$new_field LIKE '%$term%'";
					}
				}
			}
		}	
		
		if($limit != null){
			$data = $this->find('all', array(
				'conditions' => array(implode(" OR ", $conditions)),
				'limit' => $limit));
		}else{
			$data = $this->find('all', array(
				'conditions' => array(implode(" OR ", $conditions))));
		}
		return self::convertDataToNeutralIcd($data);
		
	}
	
	/**
	 * Convert CodingIcd* data arrays to have them use the generic CodingIcd model so that we only have 2 CodingIcd structures
	 * @param array $data_array The CodingIcd* data array to convert
	 * @return The converted array
	 */
	static function convertDataToNeutralIcd(array $data_array){
		$result = array();
		if(count($data_array) > 0){
			$key = array_keys($data_array[0]);
			$key = $key[0];
			foreach($data_array as $data_unit){
				$result[] = array("CodingIcd" => $data_unit[$key]);
			}
		}
		return $result;
	}
	
	function getCastedSearchParams(array $terms, $exact_search){
		$search_result = $this->globalSearch($terms, $exact_search, true, false);
		$data = array();
		if(count($search_result) > 0){
			foreach($search_result as $unit){
				$data[] = $unit['CodingIcd']['id'];
			}
		}else{
			$data[] = "NO ID MATCHED";
		}
		return $data;
	}
}