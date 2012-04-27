<?php

class ProtocolControlCustom extends ProtocolControl {

   	var $useTable = 'protocol_controls';
   	var $name = 'ProtocolControl';

	function getNonMixedProto(){
		$data = $this->find('all', array('conditions' => array('NOT' => array('ProtocolControl.type' => 'mixed'))));
		$result = array();
		foreach($data as $data_unit){
			$result[$data_unit['ProtocolControl']['id']] = __($data_unit['ProtocolControl']['type'], true);
		}
		unset($data);
		return $result;
	}
}
