<?php

class Bank extends AdministrateAppModel {
	
 	/**
	 * Get permissible values array gathering all existing banks.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'ProtocolControl.type', 'value' => (translated string describing bank))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  		
	function getBankPermissibleValues(){
		$result = array();
		foreach($this->find('all', array('order' => 'Bank.name ASC')) as $bank){
			$result[] = array("value" => $bank["Bank"]["id"], "default" => $bank["Bank"]["name"]);
		}
		return $result;
	}
}

?>
