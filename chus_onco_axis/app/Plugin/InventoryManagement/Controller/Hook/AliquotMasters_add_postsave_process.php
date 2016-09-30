<?php
	
	// Regenerated barcode
	$this->AliquotMaster->regenerateAliquotBarcode();
	
	// Create block to slide creation if creation done from template
	if(isset($this->passedArgs['templateInitId']) && $aliquot_control['AliquotControl']['aliquot_type'] == 'slide') {
		$chus_sample_control_data = $this->SampleControl->getOrRedirect($sample_control_id);
		if($chus_sample_control_data['SampleControl']['sample_type'] == 'tissue') {
			$chus_block_aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.flag_active' => '1', 'AliquotControl.aliquot_type' => 'block', 'AliquotControl.sample_control_id' => $chus_sample_control_data['SampleControl']['id'])));
			
			$tmp_template_session_data = $this->Session->read('Template.init_data.'.$this->passedArgs['templateInitId']);
			$chus_realiquoted_by = isset($tmp_template_session_data['Realiquoting']['realiquoted_by'])? $tmp_template_session_data['Realiquoting']['realiquoted_by'] : '';
			$realiquoting_datetime = isset($tmp_template_session_data['Realiquoting']['realiquoting_datetime'])? $tmp_template_session_data['Realiquoting']['realiquoting_datetime'] : '';
			
			//Try to find block matching the aliquot label of the created slides		
			$query = "SELECT BlockAliquotMaster.id AS block_aliquot_master_id, BlockAliquotMaster.aliquot_label, SlideAliquotMaster.id AS slide_aliquot_master_id, SlideAliquotMaster.aliquot_label
				FROM aliquot_masters BlockAliquotMaster, aliquot_masters SlideAliquotMaster
				WHERE BlockAliquotMaster.deleted <> 1 AND BlockAliquotMaster.aliquot_control_id = ".$chus_block_aliquot_control_data['AliquotControl']['id']."
				AND SlideAliquotMaster.deleted <> 1 AND SlideAliquotMaster.aliquot_control_id = ".$aliquot_control['AliquotControl']['id']."
				AND BlockAliquotMaster.sample_master_id =  SlideAliquotMaster.sample_master_id
				AND SlideAliquotMaster.aliquot_label LIKE CONCAT(BlockAliquotMaster.aliquot_label, '-%')
				AND SlideAliquotMaster.id IN (".implode(',',$batch_ids).");";
			$chus_blocks_to_slides_link_to_create = $this->AliquotMaster->tryCatchQuery($query);
			$this->Realiquoting->addWritableField(array('parent_aliquot_master_id', 'child_aliquot_master_id', 'realiquoting_datetime', 'realiquoting_datetime_accuracy', 'realiquoted_by'));
			foreach($chus_blocks_to_slides_link_to_create as $chus_link_to_create) {
				$chus_block_aliquot_master_id = $chus_link_to_create['BlockAliquotMaster']['block_aliquot_master_id'];
				$chus_slide_aliquot_master_id = $chus_link_to_create['SlideAliquotMaster']['slide_aliquot_master_id'];
				$chus_realiquoting_data = array(
					'parent_aliquot_master_id' => $chus_block_aliquot_master_id,
					'child_aliquot_master_id' => $chus_slide_aliquot_master_id,
					'realiquoting_datetime' => $realiquoting_datetime,
					'realiquoting_datetime_accuracy' => str_replace(array('0', '4', '7', '10', '13', '16'), array('', 'm', 'd', 'h', 'i', 'c'), strlen($realiquoting_datetime)),
					'realiquoted_by' => $chus_realiquoted_by);
				$this->Realiquoting->id = NULL;
				$this->Realiquoting->data = array(); // *** To guaranty no merge will be done with previous data ***
				if(!$this->Realiquoting->save(array('Realiquoting' => $chus_realiquoting_data), false)){
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			}
			$chus_nbr_of_slides_created = sizeof($batch_ids);
			$chus_nbr_of_links_created = sizeof($chus_blocks_to_slides_link_to_create);
			AppController::addWarningMsg(__('created %s tissue block to slide realiquoting data on a set of %d slides created - please validate and create missing raliquoting information', $chus_nbr_of_links_created, $chus_nbr_of_slides_created));
		}
	}
