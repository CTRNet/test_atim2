<?php
class TreatmentExtendsControllerCustom extends TreatmentExtendsController {


	function addComplicationTreatment($participant_id, $tx_master_id, $tx_extend_id) { 
		if (( !$participant_id ) && ( !$tx_master_id ) && ( !$tx_extend_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
				
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		// Set Extend tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		
		// Get extend data
		$tx_extend_data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id, 'TreatmentExtend.tx_master_id'=>$tx_master_id)));
		if(empty($tx_extend_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }			
		
		// Set form alias and menu data
		$this->Structures->set('qc_hb_surgery_complication_treatments');
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id, 'TreatmentExtend.id'=>$tx_extend_id));
	
		if ( !empty($this->data) ) {
			$this->data['SurgeryComplicationTreatment']['qc_hb_txe_surgery_complication_id'] = $tx_extend_id;
			
			$submitted_data_validates = true;
			// ... special validations
			
			if($submitted_data_validates) {
				App::import('Model', 'Clinicalannotation.SurgeryComplicationTreatment');
				$this->SurgeryComplicationTreatment = new SurgeryComplicationTreatment();
		
				if ( $this->SurgeryComplicationTreatment->save($this->data) ) {
					$this->flash( 'your data has been updated','/clinicalannotation/treatment_extends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id);
				}			
			}
		}
	} 
	
	function deleteComplicationTreatment($participant_id, $tx_master_id, $tx_extend_id, $complication_trt_id) { 
		if (( !$participant_id ) && ( !$tx_master_id ) && ( !$tx_extend_id ) && ( !$complication_trt_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
				
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		// Set Extend tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		
		// Get extend data
		$tx_extend_data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id, 'TreatmentExtend.tx_master_id'=>$tx_master_id)));
		if(empty($tx_extend_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }			
		
		// Check record exist
		App::import('Model', 'Clinicalannotation.SurgeryComplicationTreatment');
		$this->SurgeryComplicationTreatment = new SurgeryComplicationTreatment();
		
		$complication_trt_data = $this->SurgeryComplicationTreatment->find('first',array('conditions'=>array('SurgeryComplicationTreatment.id'=>$complication_trt_id, 'SurgeryComplicationTreatment.qc_hb_txe_surgery_complication_id'=>$tx_extend_id)));
		if(empty($complication_trt_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }			

		if( $this->SurgeryComplicationTreatment->atim_delete( $complication_trt_id ) ) {
			$this->flash( 'your data has been deleted', '/clinicalannotation/treatment_extends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id);
		} else {
			$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/treatment_extends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id);
		}	
	} 
	
}

