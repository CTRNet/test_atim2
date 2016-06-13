<?php
class BrowsingIndex extends DatamartAppModel {
	var $useTable = "datamart_browsing_indexes";
	
	var $belongsTo = array(
		'BrowsingResult'	=> array(
			'className'		=> 'BrowsingResult',
			'foreignKey'	=>	'root_node_id'
		)
	);
	
	var $tmp_browsing_limit = 5;
}