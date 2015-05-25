<?php 

	$joins[] = 	array('table' => 'misc_identifiers', 'alias' => 'MiscIdentifier', 'type' => 'LEFT', 
			'conditions' => array('MiscIdentifier.misc_identifier_control_id = Collection.qcroc_misc_identifier_control_id', 'MiscIdentifier.participant_id = Collection.participant_id'));
	$joins[] = 	array('table' => 'view_collections', 'alias' => 'ViewCollection', 'type' => 'LEFT',
			'conditions' => array('Collection.id = ViewCollection.collection_id'));
	
?>