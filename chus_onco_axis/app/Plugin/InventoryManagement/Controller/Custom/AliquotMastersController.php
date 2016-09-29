<?php
class AliquotMastersControllerCustom extends AliquotMastersController {
	
	function autocompleteAliquotLabel(){
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
	
		//query the database
		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
		$data = $this->AliquotMaster->find('all', array(
				'conditions' => array(
						'AliquotMaster.aliquot_label LIKE' => $term.'%'),
				'fields' => array('AliquotMaster.aliquot_label'),
				'limit' => 10,
				'recursive' => -1));
		
		//build javascript textual array
		$result = "";
		foreach($data as $data_unit){
			$result .= '"'.$data_unit['AliquotMaster']['aliquot_label'].'", ';
		}
		if(sizeof($result) > 0){
			$result = substr($result, 0, -2);
		}
		$this->set('result', "[".$result."]");
	}
	
}
