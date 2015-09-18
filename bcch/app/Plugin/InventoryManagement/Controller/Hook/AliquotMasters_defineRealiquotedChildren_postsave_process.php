<?php
	
	// @author Stephen Fung
	// @since 2015-07-08
	// Ensure the redefined children is assigned to only one parent when using 'Define Realiquoted Children'
	// BB-29	
	
	//Get the ids of the children that have the "Define as Child" box checked
	$aliquot_ids = array();
	
	foreach($this->request->data as $parent_id => $parent_and_children){
		
		$children = $parent_and_children['children'];
		
		foreach($children as $child) {

			if(array_key_exists('__validated__', $child['Realiquoting'])) {
				
				if($child['Realiquoting']['__validated__'] == 1) {

					array_push($aliquot_ids, $child['AliquotMaster']['id']);
				}	
			}
			
		}
	}
	
	foreach($aliquot_ids as $aliquot_id) {
		
		//Using the children ids to fine the correct rows in the realiquotings table
		$realiquot = $this->Realiquoting->find('all', array(
			'conditions' => array('Realiquoting.child_aliquot_master_id' => $aliquot_id),
			'order' => array('Realiquoting.id' => 'asc')
		));
		
		//Delete the first record if there are two realiquoting records for the children
		if(count($realiquot) > 1) {
			$id_to_delete = $realiquot[0]['Realiquoting']['id'];
			$delete_query = 'DELETE FROM realiquotings WHERE id='.$id_to_delete;
			$this->AliquotMaster->tryCatchQuery($delete_query);
		}
		
	}
