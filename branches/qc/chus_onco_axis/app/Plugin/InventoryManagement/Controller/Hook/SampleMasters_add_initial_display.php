<?php 
	
	//Get the name of the template if tempalte is used
	$system_template = '';
	if(isset($this->passedArgs['templateInitId'])) {
		$tmp_template_session_data = $this->Session->read('Template.init_data.'.$this->passedArgs['templateInitId']);
		if(isset($tmp_template_session_data['FunctionManagement']['chus_template_name'])) $system_template = $tmp_template_session_data['FunctionManagement']['chus_template_name'];
	}
	
	//Get the last sample created data
	$sample_control_ids = array($sample_control_data['SampleControl']['id']);
	if(in_array($sample_control_data['SampleControl']['sample_type'], array('serum', 'plasma', 'buffy coat'))) {
		$sample_control_ids = $this->SampleControl->find('list', array('fields' => array('SampleControl.id'), 'conditions' => array("SampleControl.sample_type" => array('serum', 'plasma', 'buffy coat')), 'recursive' => -1));
	}
	$all_collection_samples = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.sample_control_id' => $sample_control_ids, 'SampleMaster.collection_id' => $collection_id), 'orders' => array('SampleMaster.modified DESC')));
	$last_sample_modified = $all_collection_samples? $all_collection_samples[0] : array();
	
	//Manage default data
	switch($sample_control_data['SampleControl']['sample_type']) {
		case 'tissue':
			if($last_sample_modified) {
				$this->request->data = $last_sample_modified;
				if($system_template == 'Tissue Post-Chirurgie') {
					if(sizeof($all_collection_samples) == 1) {
						$last_tissue_nature = $this->request->data['SampleDetail']['tissue_nature'];
						$this->request->data['SampleDetail']['tissue_nature'] = ($last_tissue_nature == 'tumour')? 'normal' : 'tumour';
					} else {
						unset($this->request->data['SampleDetail']['tissue_nature']);
					}
				} else {
					unset($this->request->data['SampleDetail']);
					$this->request->data['SampleDetail']['pathology_reception_datetime'] = $last_sample_modified['SampleDetail']['pathology_reception_datetime'];
					$this->request->data['SampleDetail']['pathology_reception_datetime_accuracy'] = $last_sample_modified['SampleDetail']['pathology_reception_datetime_accuracy'];
				}
			} else {
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
				$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data['Collection']['collection_datetime'];
				$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = in_array($collection_data['Collection']['collection_datetime_accuracy'], array('i', 'c'))? 'h' : $collection_data['Collection']['collection_datetime_accuracy'];
				$this->request->data['SampleDetail']['pathology_reception_datetime'] = $this->request->data['SpecimenDetail']['reception_datetime'];
				$this->request->data['SampleDetail']['pathology_reception_datetime_accuracy'] = $this->request->data['SpecimenDetail']['reception_datetime_accuracy'];
				if($system_template == 'Tissue Post-Chirurgie') $this->request->data['SampleDetail']['tissue_nature'] = 'tumour';
			}
			break;
		case 'blood':
			$last_sample_modified = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id'], 'SampleMaster.collection_id' => $collection_id), 'orders' => array('SampleMaster.modified DESC')));
			if($last_sample_modified) {
				$this->request->data = $last_sample_modified;
				$last_blood_type = $this->request->data['SampleDetail']['blood_type'];
				unset($this->request->data['SampleDetail']);
				if($system_template == 'Sang Pré-Chirurgie' && sizeof($all_collection_samples) == 1) {
					$this->request->data['SampleDetail']['blood_type'] = ($last_blood_type == 'EDTA')? 'heparin' : 'EDTA';
					$this->request->data['SampleDetail']['collected_tube_nbr'] = '1';
				}
			} else {
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
				$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data['Collection']['collection_datetime'];
				$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = in_array($collection_data['Collection']['collection_datetime_accuracy'], array('i', 'c'))? 'h' : $collection_data['Collection']['collection_datetime_accuracy'];
				if($system_template == 'Sang Pré-Chirurgie') {
					$this->request->data['SampleDetail']['blood_type'] = 'EDTA';
					$this->request->data['SampleDetail']['collected_tube_nbr'] = '2';
				}
			}
			break;
		case 'serum':
		case 'plasma':
		case 'buffy coat':
			if($last_sample_modified) {
				$this->request->data = $last_sample_modified;
			} else {
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
				$this->request->data['DerivativeDetail']['creation_datetime'] = $collection_data['Collection']['collection_datetime'];
				$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = in_array($collection_data['Collection']['collection_datetime_accuracy'], array('i', 'c'))? 'h' : $collection_data['Collection']['collection_datetime_accuracy'];
			}
			break;
	}
	
	//Override data based on tempalte init
	if(isset($this->passedArgs['templateInitId'])) {
		$tmp_template_session_data = $this->Session->read('Template.init_data.'.$this->passedArgs['templateInitId']);
		foreach($tmp_template_session_data as $template_model => $template_fields) {
			foreach($template_fields as $template_field => $template_value) {
				if($template_value) {
					$this->request->data[$template_model][$template_field] = $template_value;
					unset($this->request->data[$template_model][$template_field.'_accuracy']);	//In case accuracy alrready has been set
				}
			}
		}
	}
		
?>