<?php 
	
	if(isset($default_reception_by)) {
		$final_options['override']['SpecimenDetail.reception_by'] = $default_reception_by;	
		$final_options['override']['SpecimenDetail.supplier_dept'] = $supplier_dept;
	}
	if(isset($default_creation_by)) {
		$final_options['override']['DerivativeDetail.creation_by'] = $default_creation_by;		
	}	
?>
