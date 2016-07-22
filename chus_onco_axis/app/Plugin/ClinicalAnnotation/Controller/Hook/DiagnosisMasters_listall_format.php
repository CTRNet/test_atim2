<?php 
	
	foreach($this->request->data as &$new_diagnosis) {
		if($new_diagnosis['DiagnosisMaster']['topography']) {
			$new_diagnosis['DiagnosisMaster']['topography'] = $this->CodingIcdo3Topo->getDescription($new_diagnosis['DiagnosisMaster']['topography']);
		}
	}
	
	
	
	