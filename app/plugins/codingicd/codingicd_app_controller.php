<?php
class CodingicdAppController extends AppController {	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
	
	function tool(){
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
	function globalSearch($is_tool, $model_to_use, array $search_fields_suffix = array("_title", "_sub_title", "_description")){
		if($is_tool){
			$model_name_to_use = $model_to_use->name;
			$this->layout = 'ajax';
			$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
			$this->Structures->set("codingicd_".$lang);
			$limit = 25;
			$term = mysql_real_escape_string($this->data[0]['term']);
			
			$this->data = $model_to_use->globalSearch(array($term), isset($this->data['exact_search']) && $this->data['exact_search'], $search_fields_suffix, false, $limit + 1);
			
			if(count($this->data) > $limit){
				unset($this->data[$limit]);
				$this->set("overflow", true);
			}
			$this->data = $model_to_use::convertDataToNeutralIcd($this->data);
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