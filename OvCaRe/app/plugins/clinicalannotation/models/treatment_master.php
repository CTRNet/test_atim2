<?php

class TreatmentMaster extends ClinicalannotationAppModel {
	
    var $belongsTo = array(        
		'TreatmentControl' => array(            
		'className'    => 'Clinicalannotation.TreatmentControl',            
		'foreignKey'    => 'treatment_control_id'     
		)    
	); 
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			
			$return = array(
				'menu'    			=> array( NULL, __($result['TreatmentControl']['disease_site'], TRUE) . ' - ' . __($result['TreatmentControl']['tx_method'], TRUE) ),
				'title'	 			=> array( NULL, __($result['TreatmentControl']['disease_site'], TRUE)  . ' - ' . __($result['TreatmentControl']['tx_method'], TRUE)),
				'data'				=> $result,
				'structure alias'	=> 'treatmentmasters'
			);
		}
		
		return $return;
	}
	
	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $tx_master_id Id of the studied record.
	 * @param $tx_extend_tablename
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2010-04-18
	 */
	function allowDeletion($tx_master_id){
		if($tx_master_id != $this->id){
			//not the same, fetch
			$data = $this->findById($tx_master_id);
		}else{
			$data = $this->data;
		}
		if(!empty($data['TreatmentControl']['extend_tablename'])) {
			$treatment_extend_model = new TreatmentExtend( false, $data['TreatmentControl']['extend_tablename']);
			$nbr_extends = $treatment_extend_model->find('count', array('conditions'=>array('TreatmentExtend.tx_master_id'=>$tx_master_id), 'recursive' => '-1'));
			if ($nbr_extends > 0) { 
				return array('allow_deletion' => false, 'msg' => 'at least one drug is defined as treatment component'); 
			}
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	
}

?>