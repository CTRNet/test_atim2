<?php
class BrowsingResult extends DatamartAppModel {
	var $useTable = 'datamart_browsing_results';
	
	var $belongsTo = array(       
		'DatamartStructure' => array(           
			'className'    => 'Datamart.DatamartStructure',            
			'foreignKey'    => 'browsing_structures_id')
	);
}