<?php
class BrowsingIndex extends DatamartAppModel {
	var $useTable = "datamart_browsing_indexes";
	
	var $belongsTo = array(
		'BrowsingResult'	=> array(
			'className'		=> 'BrowsingResult',
			'foreignKey'	=>	'root_node_id'
		)
	);
}