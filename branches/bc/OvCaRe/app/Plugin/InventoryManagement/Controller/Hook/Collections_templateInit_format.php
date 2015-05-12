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

if($this->request->data) {
	//Fix to be able to add default study 
	//See issue http://atim-software.ca/eventum/htdocs/view.php?id=3226
	$aliquot_control_model = AppModel::getInstance('InventoryManagement', 'AliquotControl', true);
	$tmp_all_aliquot_control = $aliquot_control_model->find('first', array('conditions' => array('flag_active' => 1), 'recursive' => 0));
	$this->request->data['AliquotMaster']['aliquot_control_id'] = $tmp_all_aliquot_control['AliquotControl']['id'];
}

?>
