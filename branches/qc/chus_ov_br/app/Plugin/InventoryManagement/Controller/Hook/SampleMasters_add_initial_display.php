<?php
	
	if($is_specimen) {
		$this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
		$view_coll_data = $this->ViewCollection->find('first', array('conditions'=>array('ViewCollection.collection_id'=>$collection_id)));
		
		$supplier_dept = '';
		switch($sample_control_data['SampleControl']['sample_type']) {
			case 'tissue':
				$supplier_dept = 'department of pathology';
				switch($view_coll_data['ViewCollection']['bank_name']) {
					case 'Ovaire/Ovary':						
						$this->request->data['SampleDetail']['tissue_source'] = 'ovary';
						break;
					default:				
						$this->request->data['SampleDetail']['tissue_source'] = 'breast';
						break;			
				}
				
				break;
				
			case 'ascite':
				$supplier_dept = 'operating room';
				break;
				
			default:			
		}
		
		$this->request->data['SpecimenDetail']['reception_by'] = 'isabelle matte';
		$this->request->data['SpecimenDetail']['supplier_dept'] = $supplier_dept;
		$this->request->data['SpecimenDetail']['chus_collection_datetime'] = $view_coll_data['ViewCollection']['chus_collection_date'];
		$this->request->data['SpecimenDetail']['chus_collection_datetime_accuracy'] = $view_coll_data['ViewCollection']['chus_collection_date_accuracy'];
		$this->request->data['SpecimenDetail']['reception_datetime'] = $view_coll_data['ViewCollection']['chus_collection_date'];
		$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $view_coll_data['ViewCollection']['chus_collection_date_accuracy'];
		
	} else {
		$this->request->data['DerivativeDetail']['creation_by'] = 'isabelle matte';
		if(in_array($sample_control_data['SampleControl']['sample_type'], array('plasma','pbmc','ascite cell','ascite supernatant')) && !empty($parent_sample_data['SpecimenDetail']['reception_datetime'])) {
			$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
		}
	}

?>
