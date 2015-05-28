<?php
class SampleMasterCustom extends SampleMaster {

	var $useTable = 'sample_masters';
	var $name = 'SampleMaster';

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
}

?>
