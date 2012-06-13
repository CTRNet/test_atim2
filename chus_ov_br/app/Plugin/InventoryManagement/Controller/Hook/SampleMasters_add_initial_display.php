<?php
	
	if($is_specimen) {
		$this->set('default_reception_by','isabelle matte');
		$supplier_dept = '';
		switch($sample_control_data['SampleControl']['sample_type']) {
			case 'tissue':
				$supplier_dept = 'department of pathology';
				
				$this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
				$view_coll_data = $this->ViewCollection->find('first', array('conditions'=>array('ViewCollection.collection_id'=>$collection_id)));		
				preg_match('/^(OV|BR).*$/',  $view_coll_data['ViewCollection']['frsq_number'], $matches);			
				if(isset($matches[1])) {
					switch($matches[1]) {
						case 'OV':						
							$this->set('default_tissue','ovary');
							break;
						case 'BR':					
							$this->set('default_tissue','breast');
							break;
						default:					
					}
				}
				break;
				
			case 'ascite':
				$supplier_dept = 'operating room';
				break;
				
			default:			
		}
		$this->set('supplier_dept',$supplier_dept);

	} else {
		$this->set('default_creation_by','isabelle matte');
	}

?>
