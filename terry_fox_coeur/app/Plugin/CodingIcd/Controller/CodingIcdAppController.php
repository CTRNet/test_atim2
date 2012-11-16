<?php
class CodingIcdAppController extends AppController {	
	function tool($use_icd_type){
		$this->layout = 'ajax';
		$this->Structures->set('simple_search');
		$this->Structures->set('empty', "empty");
	}
	
	/**
	 * Search through an icd coding model
	 * @param boolean $is_tool Is the search made from a popup tool
	 * @param AppModel $model_to_use The model to base the search on
	 * @param $search_fields_prefix array The fields prefix to base the search on
	 */
	function globalSearch($is_tool, $model_to_use){
		if($is_tool){
			$model_name_to_use = $model_to_use->name;
			$this->layout = 'ajax';
			$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
			$this->Structures->set("CodingIcd_".$lang);
			$limit = 25;
			
			if (!$db = ConnectionManager::getDataSource($model_to_use->useDbConfig)) {
				return false;
			}

			$this->request->data = $model_to_use->globalSearch(array($this->request->data[0]['term']), isset($this->request->data['exact_search']) && $this->request->data['exact_search'], false, $limit + 1);
			
			if(count($this->request->data) > $limit){
				unset($this->request->data[$limit]);
				$this->set("overflow", true);
			}
			$this->request->data = $model_to_use->convertDataToNeutralIcd($this->request->data);
		}else{
			die("Not implemented");
		}
	}
	
	function globalAutocomplete($model_to_use){
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		
		//query the database
		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
		$data = $model_to_use->find('all', array(
			'conditions' => array(
				$model_to_use->name.'.id LIKE' => $term.'%'),
			'fields' => array($model_to_use->name.'.id'), 
			'limit' => 10,
			'recursive' => -1));
		
				//build javascript textual array
		$result = "";
		foreach($data as $data_unit){
			$result .= '"'.$data_unit[$model_to_use->name]['id'].'", ';
		}
		if(sizeof($result) > 0){
			$result = substr($result, 0, -2);
		}
		$this->set('result', "[".$result."]");
	}
}