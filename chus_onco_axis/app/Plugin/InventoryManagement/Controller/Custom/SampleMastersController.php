<?php
class SampleMastersControllerCustom extends SampleMastersController {
	
	function autocompleteTissueSourcePrecisions(){
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
	
		//query the database
		$joins = array(array(
			'table' => 'sd_spe_tissues',
			'alias' => 'SampleDetail',
			'type' => 'INNER',
			'conditions' => array('SampleMaster.id = SampleDetail.sample_master_id')));
		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
		$data = $this->SampleMaster->find('all', array(
			'conditions' => array('SampleDetail.chus_tissue_source_precisions LIKE' => '%'.$term.'%'),
			'fields' => array('DISTINCT SampleDetail.chus_tissue_source_precisions'),
			'orders' => array('SampleDetail.chus_tissue_source_precisions ASC'),
			'joins' => $joins,
			'limit' => 20,
			'recursive' => -1));
		
		//build javascript textual array
		$result = "";
		foreach($data as $data_unit){
			$result .= '"'.$data_unit['SampleDetail']['chus_tissue_source_precisions'].'", ';
		}
		if(sizeof($result) > 0){
			$result = substr($result, 0, -2);
		}
		$this->set('result', "[".$result."]");
	}
	
}
 