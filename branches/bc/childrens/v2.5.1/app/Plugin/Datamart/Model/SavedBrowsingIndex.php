<?php
class SavedBrowsingIndex extends DatamartAppModel{
	
	var $useTable = 'datamart_saved_browsing_indexes';
	
	var $hasMany = array(
		'SavedBrowsingStep' => array(
			'className'   => 'Datamart.SavedBrowsingStep',
			'foreignKey'  => 'datamart_saved_browsing_index_id'
		)
	);
	
	var $belongsTo = array(
		'DatamartStructure' => array(
			'className'	=> 'DatamartStructure',
			'foreignKey'=> 'starting_datamart_structure_id'		
		)
	);
	
}