<?php
class EventMastersControllerCustom extends EventMastersController{
	
	function autocompleteMedication() {
		
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		
		//query the database
		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
		
		$joins = array(array(
		    'table' => 'chus_ed_medication_history',
		    'alias'	=> 'EventDetail',
		    'type'	=> 'INNER',
		    'conditions' => array('EventMaster.id = EventDetail.event_master_id')
		));
		
		$data = $this->EventMaster->find('all', array(
		    'fields'  => array('DISTINCT EventDetail.medication'),
		    'joins'   => $joins,
		    'order'   => 'EventDetail.medication ASC',
		    'conditions'	=> array('EventDetail.medication LIKE' => "%$term%")));

		//build javascript textual array
		$result = "";
		foreach($data as $data_unit){
			$result .= '"'.$data_unit['EventDetail']['medication'].'", ';
		}
		if(sizeof($result) > 0){
			$result = substr($result, 0, -2);
		}
		
		$this->set('result', "[".$result."]");				
	}
	
}