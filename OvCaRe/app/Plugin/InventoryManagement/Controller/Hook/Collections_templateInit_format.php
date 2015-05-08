<?php

if($template) {
	switch($template['Template']['name']) {
		case 'Blood collection':
			$this->Structures->set('ovcare_blood_template_init_structure', 'template_init_structure');
			break;
		case 'Tissue collection':
		case 'Endometriosis Study':
			$this->Structures->set('ovcare_tissue_template_init_structure', 'template_init_structure');
			break;
	}
}


?>
