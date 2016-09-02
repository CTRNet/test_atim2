<?php

class ProtocolMasterCustom extends ProtocolMaster {

	var $name = 'ProtocolMaster';
	var $useTable = 'protocol_masters';
	
	public static $protocol_dropdown = array();
	private static $protocol_dropdown_set = false;
	
	function getProtocolPermissibleValuesFromId($protocol_control_id = null) {
		// Build tmp array to sort according translation
		$criteria = array();
		if(!self::$protocol_dropdown_set){
			if(!is_null($protocol_control_id)){
				$criteria['ProtocolMaster.protocol_control_id'] = $protocol_control_id; 
			} 
			$drug_model = AppModel::getInstance("Drug", "Drug", true);
			$all_drugs = array();
			foreach($drug_model->find('all') as $new_drug) $all_drugs[$new_drug['Drug']['id']] = $new_drug['Drug']['generic_name'];
			$has_many_details = array(
				'hasMany' => array(
					'ProtocolExtendMaster' => array(
						'className' => 'Protocol.ProtocolExtendMaster',
						'foreignKey' => 'protocol_master_id')));
			$this->bindModel($has_many_details);
			foreach($this->find('all', array('conditions' => $criteria, 'order' => 'ProtocolMaster.code')) as $new_protocol) {
				$drug_precisions = '';
				if(isset($new_protocol['ProtocolExtendMaster'])) {
					$protocol_drugs = array();
					foreach($new_protocol['ProtocolExtendMaster'] as $new_precision) {
						if($new_precision['drug_id'] && isset($all_drugs[$new_precision['drug_id']])) $protocol_drugs[] = $all_drugs[$new_precision['drug_id']];
					}
					if($protocol_drugs) $drug_precisions = ' ('.implode(', ', $protocol_drugs).')';
				}
				self::$protocol_dropdown[$new_protocol['ProtocolMaster']['id']] = $new_protocol['ProtocolMaster']['code'] . $drug_precisions;
			}
			self::$protocol_dropdown_set = true;
		}
		
		return self::$protocol_dropdown;
	}
}

?>