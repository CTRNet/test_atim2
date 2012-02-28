<?php

class TreatmentMaster extends ClinicalAnnotationAppModel {
	
    var $belongsTo = array(        
		'TreatmentControl' => array(            
		'className'    => 'ClinicalAnnotation.TreatmentControl',            
		'foreignKey'    => 'treatment_control_id'     
		)    
	); 
    
    var $browsing_search_dropdown_info = array(
    	'browsing_filter' => array(
	    	1	=> array('lang' => 'keep entries with the most recent start date per participant', 'group by' => 'participant_id', 'field' => 'start_date', 'attribute' => 'MAX'),
	    	2	=> array('lang' => 'keep entries with the oldest start date per participant', 'group by' => 'participant_id', 'field' => 'start_date', 'attribute' => 'MIN')
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
			$treatment_extend_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentExtend', true);
			$treatment_extend_model = AppModel::atimInstantiateExtend($treatment_extend_model, $data['TreatmentControl']['extend_tablename']);
			$nbr_extends = $treatment_extend_model->find('count', array('conditions'=>array('TreatmentExtend.treatment_master_id'=>$tx_master_id), 'recursive' => '-1'));
			if ($nbr_extends > 0) { 
				return array('allow_deletion' => false, 'msg' => 'at least one drug is defined as treatment component'); 
			}
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>