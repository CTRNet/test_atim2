<?php
class SampleMasterCustom extends SampleMaster {

	var $useTable = 'sample_masters';
	var $name = 'SampleMaster';
	
	//$collection_data is the structure of the collection model
	//$sample_type is just string
	//$sample_master_id is just string
	
	function generateSampleLabel($collection_data, $sample_type, $sample_master_id) {
		// Parameters check: Verify parameters have been set
		if(empty($sample_master_id) || empty($collection_data) || empty($sample_type)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);

		// Set participant identifer
		$participant_identifier = $collection_data['Participant']['participant_identifier'];

		// Set sample label based on sample type
		$sample_label = 'XX';
		switch($sample_type) {
			case 'blood':
				$sample_label = 'BL';
				break;
			case 'bone marrow':
				$sample_label = 'BM';
				break;
			case 'cell culture':
				$sample_label = 'CC';
				break;
			case 'cell lysate':
				$sample_label = 'CL';
				break;
			case 'cord blood':
				$sample_label = 'CB';
				break;
			case 'csf':
				$sample_label = 'CF';
				break;
			case 'dna':
				$sample_label = 'DN';
				break;
			case 'ccbr expanded cells':
				$sample_label = 'EC';
				break;
			case 'ccbr leukapheresis':
				$sample_label = 'LK';
				break;
			/*
			case 'pbmc':
				$sample_label = 'MC';
				break;
			*/
			case 'plasma':
				$sample_label = 'PL';
				break;
			case 'rna':
				$sample_label = 'RN';
				break;
			case 'saliva':
				$sample_label = 'SL';
				break;
			case 'ccbr stem cells':
				$sample_label = 'SC';
				break;
			case 'stool':
				$sample_label = 'ST';
				break;
			case 'ccbr swab':
				$sample_label = 'SB';
				break;
			case 'tissue':
				$sample_label = 'TI';
				break;
			case 'tissue suspension':
				$sample_label = 'TS';
				break;
			case 'urine':
				$sample_label = 'UR';
				break;
			case 'csf cells':
				$sample_label = 'CE';
				break;
			case 'csf supernatant':
				$sample_label = 'CS';
				break;
			/*
			case 'blood cell':
				$sample_label = 'BC';
				break;
				*/
			case 'ccbr mononuclear cells':
				$sample_label = 'MC';
				break;
			case 'ccbr buffy coat':
				$sample_label = 'BC';
				break;
			case 'serum':
				$sample_label = 'SE';
				break;
			case 'tissue lysate':
				$sample_label = 'TL';
				break;
			case 'protein':
				$sample_label = 'PR';
				break;
			case 'pleural fluid':
				$sample_label = 'PF';
				break;
			case 'pleural fluid cell':
				$sample_label = 'PC';
				break;
			case 'pleural fluid supernatant':
				$sample_label = 'PS';
				break;
			// BB-58
			case 'cdna':
				$sample_label = 'CD';
				break;
			case 'amplified rna':
				$sample_label = 'AR';
				break;
			case 'xenograft':
				$sample_label = 'XE';
				break;	
            case 'cell pellet': 
                $sample_label = 'CP';
                break;	
			// BB-214
			case 'urine supernatant':
				$sample_label = 'US';
				break;		
		}

		// Set participant ID for finding collections and sample counts
		$participant_id = $collection_data['Collection']['participant_id'];

		// Find all collection ID's for current participant
		$participant_collection_ids =
			$this->Collection->find('list', array('conditions' => array('Collection.participant_id' => $participant_id), 'fields' => array('Collection.id')));

		// For each collecton, find number of samples in each collection
		$total_sample_count = 0;
		$collection_sample_count = 0;
		
		foreach ($participant_collection_ids as $collection_id) {
			$collection_sample_count =
				$this->find('count', array('conditions' => array('SampleMaster.collection_id' => $participant_collection_ids[$collection_id], 'SampleMaster.deleted' => array(0,1)))); //Eventum ID: 3215

			// Add current collection sample count to total sample count
			$total_sample_count = $total_sample_count + $collection_sample_count;
			$collection_sample_count = 0;
		}

		// Pad sample count to three digits
		if ($total_sample_count < 10) {
			$total_sample_count = '00'.$total_sample_count;
		} elseif ($total_sample_count < 100) {
			$total_sample_count = '0'.$total_sample_count;
		}

		// Set sample code
		$sample_code = $participant_identifier . $sample_label . $total_sample_count;

		// Save sample code
		$query_to_update = null;
		$query_to_update = "UPDATE sample_masters SET sample_code = '$sample_code' WHERE id = $sample_master_id;";
		$this->tryCatchQuery($query_to_update);

		// Update revs table
		$this->tryCatchQuery(str_replace("sample_masters", "sample_masters_revs", $query_to_update));

		// Update ViewSample
		$query_to_update = "UPDATE view_samples SET sample_code = '$sample_code' WHERE sample_master_id = $sample_master_id;";
		$this->tryCatchQuery($query_to_update);

	}

	//BB-232
	/*
	function generateTrackingCode($sample_master_id, $sample_control_id) {

		// Get all aliquots that now need barcodes
		$sample_to_update = 
			$this->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_id)));			
		pr($sample_to_update);
		pr($sample_control_id);

		if($sample_to_update['SampleControl']['sample_category'] == 'specimen') {
			die();
			$next_barcode = $this->findNextBarcode();
			$query = "UPDATE sample_masters SET `tracking_code` = '" . $next_barcode . "' WHERE `id` = " . $sample_master_id . ";";
			$this->tryCatchQuery($query);

			$query = "UPDATE sample_masters_revs SET `tracking_code` = '" . $next_barcode . "' WHERE `id` = " . $sample_master_id . " ORDER BY `version_id` DESC LIMIT 1;";
			$this->tryCatchQuery($query);

		} else {
			// Derivatives barcode
			$parent_sample_id = $sample_to_update['SampleMaster']['parent_id'];
			pr($parent_sample_id);
			$query = "SELECT `sample_barcode` FROM sample_masters WHERE `id`=" . $parent_sample_id . ";";

			$next_barcode_array = $this->find('first', array(
				'conditions' => array('SampleMaster.id' => $parent_sample_id), 
				'fields' => array('SampleMaster.sample_barcode'),
				'recursive' => -1
			));

			//exit(pr($next_barcode_array));
			$next_barcode = $next_barcode_array['SampleMaster']['sample_barcode'];
			$query = "UPDATE sample_masters SET `sample_barcode` = '" . $next_barcode . "' WHERE `id` = " . $sample_master_id . ";";
			$this->tryCatchQuery($query);			

		}

		//$sample_control_data = $this->SampleControl->getOrRedirect($sample_control_id);
		//pr($sample_control_data);
		
		if($sample_to_update['SampleControl']['sample_category'] == 'specimen') {

			$next_barcode = $this->findNextBarcode();
			$query = "UPDATE sample_masters SET `sample_barcode` = '" . $next_barcode . "' WHERE `id` = " . $sample_master_id . ";";
			$this->tryCatchQuery($query);

		} else {
			// Derivatives barcode
			$parent_sample_id = $sample_to_update['SampleMaster']['parent_id'];
			pr($parent_sample_id);
			$query = "SELECT `sample_barcode` FROM sample_masters WHERE `id`=" . $parent_sample_id . ";";

			$next_barcode_array = $this->find('first', array(
				'conditions' => array('SampleMaster.id' => $parent_sample_id), 
				'fields' => array('SampleMaster.sample_barcode'),
				'recursive' => -1
			));

			//exit(pr($next_barcode_array));
			$next_barcode = $next_barcode_array['SampleMaster']['sample_barcode'];
			$query = "UPDATE sample_masters SET `sample_barcode` = '" . $next_barcode . "' WHERE `id` = " . $sample_master_id . ";";
			$this->tryCatchQuery($query);			

		}
		
	}
	*/

}

?>
