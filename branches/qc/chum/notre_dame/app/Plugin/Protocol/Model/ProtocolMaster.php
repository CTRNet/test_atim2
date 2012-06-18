<?php

class ProtocolMaster extends ProtocolAppModel {

	var $name = 'ProtocolMaster';
	var $useTable = 'protocol_masters';
	
	public static $protocol_dropdown = array();
	private static $protocol_dropdown_set = false;

	var $belongsTo = array(        
	   'ProtocolControl' => array(            
	       'className'    => 'Protocol.ProtocolControl',            
	       'foreignKey'    => 'protocol_control_id'        
	   )    
	);
	
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ProtocolMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ProtocolMaster.id'=>$variables['ProtocolMaster.id'])));
			
			$return = array(
				'menu'			=>	array( NULL, __($result['ProtocolControl']['type'], TRUE) . ' - ' . $result['ProtocolMaster']['code']),
				'title'			=>	array( NULL, $result['ProtocolMaster']['code']),
				'data'			=> $result,
				'structure alias'=>'protocolmasters'
			);
		}
		
		return $return;
	}
	
	/**
	 * Get permissible values array gathering all existing protocol.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getProtocolPermissibleValuesFromId($protocol_control_id = null) {
		// Build tmp array to sort according translation
		$criteria = array();
		if(!self::$protocol_dropdown_set){
			if(!is_null($protocol_control_id)){
				$criteria['ProtocolMaster.protocol_control_id'] = $protocol_control_id; 
			} 
			foreach($this->find('all', array('conditions' => $criteria, 'order' => 'ProtocolMaster.code')) as $new_protocol) {
				self::$protocol_dropdown[$new_protocol['ProtocolMaster']['id']] = __($new_protocol['ProtocolControl']['type']) . ' : ' . $new_protocol['ProtocolMaster']['code'] . (empty($new_protocol['ProtocolMaster']['name']) ? '' : ' (' . $new_protocol['ProtocolMaster']['name'] . ')');
			}
			self::$protocol_dropdown_set = true;
		}
		
		return self::$protocol_dropdown;
	}	
	
	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $protocol_master_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2010-04-18
	 * @moved from controller to model on 2010-06-08 by Mich
	 */
	 
	function isLinkedToTreatment($protocol_master_id){
		$this->TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);	
		$nbr_trt_masters = $this->TreatmentMaster->find('count', array('conditions'=>array('TreatmentMaster.protocol_master_id'=>$protocol_master_id), 'recursive' => '-1'));
		if ($nbr_trt_masters > 0){
			return array('is_used' => true, 'msg' => 'protocol is defined as protocol of at least one participant treatment'); 
		}
		
		return array('is_used' => false, 'msg' => '');
	}
}

?>