<?php
	
	if($is_specimen) {
		$this->set('default_reception_by','isabelle matte');
		$supplier_dept = '';
		switch($sample_control_data['SampleControl']['sample_type']) {
			case 'tissue':
				$supplier_dept = 'department of pathology';
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
