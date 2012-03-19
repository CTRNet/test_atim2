<?php
class BrowsingResult extends DatamartAppModel {
	var $useTable = 'datamart_browsing_results';
	
	var $belongsTo = array(       
		'DatamartStructure' => array(           
			'className'    => 'Datamart.DatamartStructure',            
			'foreignKey'    => 'browsing_structures_id')
	);
	
	var $actsAs = array('Tree');
	
	public function cacheAndGet($start_id, &$browsing_cache){
		$browsing = $this->find('first', array("conditions" => array('BrowsingResult.id' => $start_id)));

		assert(!empty($browsing)) or die();
		
		$browsing_cache[$start_id] = $browsing;
		
		return $browsing;
	}
}