<?php

	// -------------------------------------------------------------------------------
	// Generate block, slide and core aliquot label
	// -------------------------------------------------------------------------------
	$linked_collection_ids = array();
	$tmp_collection_ids = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => explode(",", $parent_aliquots_ids)), 'fields'=>'DISTINCT collection_id','recursive' => -1));
	foreach($tmp_collection_ids as $aliquots_collection_id) $linked_collection_ids[] = $aliquots_collection_id['AliquotMaster']['collection_id'];
	
?>
