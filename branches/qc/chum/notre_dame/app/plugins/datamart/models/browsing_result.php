<?php
class BrowsingResult extends DatamartAppModel {
	var $useTable = 'datamart_browsing_results';
	
	var $belongsTo = array(       
		'BrowsingStructure' => array(           
			'className'    => 'Datamart.BrowsingStructure',            
			'foreignKey'    => 'browsing_structures_id')
	);
}