<?php 

if($event_control_data['EventControl']['event_type'] == 'medical history') {
	$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
	$default_types = $StructurePermissibleValuesCustom->find('all', array(
		'conditions' => array('StructurePermissibleValuesCustom.use_as_input' => '1', 'StructurePermissibleValuesCustomControl.name' => 'Medical History Diagnosis'), 
		'limit' => 10,
		'order' => 'StructurePermissibleValuesCustom.id ASC'
	));
	$this->request->data = array();
	$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
	foreach($default_types as $new_type) {
		$translated_type = strlen($new_type['StructurePermissibleValuesCustom'][$lang])? $new_type['StructurePermissibleValuesCustom'][$lang] : $new_type['StructurePermissibleValuesCustom']['value'];
		$this->request->data[$translated_type] = array('EventDetail' => array('type' => $new_type['StructurePermissibleValuesCustom']['value']));
	}
	ksort($this->request->data);
}
