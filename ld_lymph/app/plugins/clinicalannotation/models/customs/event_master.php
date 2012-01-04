<?php

class EventMasterCustom extends EventMaster {
	
	var $useTable = 'event_masters';	
	var $name = 'EventMaster';	
	
	
	
	function beforeSave($options) {
		$scan_data = array_key_exists('pe_imag_lymph_node_waldeyers_ring', $this->data['EventDetail'])? $this->data['EventDetail'] : null;
		
		if(!empty($scan_data)) {
			
			$nodal_sites_defintion = array(
				'pe_imag_lymph_node_waldeyers_ring' => '1',
		        
				'pe_imag_lymph_node_pre_auricular_left' => '2',
				'pe_imag_lymph_node_upper_cervical_left' => '2',
				'pe_imag_lymph_node_median_lower_cervical_left' => '2',
				'pe_imag_lymph_node_posterior_cervical_left' => '2',
				'pe_imag_lymph_node_supraclavicular_left' => '2',
				'pe_imag_lymph_node_infraclavicular_left' => '2',
	            
				'pe_imag_lymph_node_pre_auricular_right' => '3',
				'pe_imag_lymph_node_upper_cervical_right' => '3',
				'pe_imag_lymph_node_median_lower_cervical_right' => '3',
				'pe_imag_lymph_node_posterior_cervical_right' => '3',
				'pe_imag_lymph_node_supraclavicular_right' => '3',
				'pe_imag_lymph_node_infraclavicular_right' => '3',
	            
				'pe_imag_lymph_node_paratracheal_left' => '4',
				'pe_imag_lymph_node_paratracheal_right' => '4',
				'pe_imag_lymph_node_mediastinal' => '4',
				'pe_imag_lymph_node_hilar_left' => '4',
				'pe_imag_lymph_node_hilar_right' => '4',
				'pe_imag_lymph_node_retrocrural' => '4',
	            
				'pe_imag_lymph_node_axillary_left' => '5',
	            
				'pe_imag_lymph_node_axillary_right' => '6',
	            
				//'pe_imag_lymph_node_spleen' => '7',
	            
				'pe_imag_lymph_node_ceuac' => '8',
				'pe_imag_lymph_node_splenic_hepatic_hilar' => '8',
				'pe_imag_lymph_node_portal' => '8',
				'pe_imag_lymph_node_mesenteric' => '8',
	            
				'pe_imag_lymph_node_para_aortic_left' => '9',
				'pe_imag_lymph_node_para_aortic_right' => '9',
				'pe_imag_lymph_node_common_illiac_left' => '9',
				'pe_imag_lymph_node_common_illiac_right' => '9',
				'pe_imag_lymph_node_external_illiac_left' => '9',
				'pe_imag_lymph_node_external_illiac_right' => '9',
	            
				'pe_imag_lymph_node_inguinal_left' => '10',
				'pe_imag_lymph_node_femoral_left' => '10',
	            
				'pe_imag_lymph_node_inguinal_right' => '11',
				'pe_imag_lymph_node_femoral_right' => '11',
	            
				'pe_imag_lymph_node_epitrochlear' => '12',
				'pe_imag_lymph_node_popliteral' => '12',
				'pe_imag_lymph_node_other' => '12'
			);			
			
			$tumoral_nodal_sites = array();
			foreach($scan_data as $node => $value) {
				if(isset($nodal_sites_defintion[$node]) && ($value == 'y')) $tumoral_nodal_sites[$nodal_sites_defintion[$node]] = $nodal_sites_defintion[$node];
			}
			$this->data['EventDetail']['nodal_sites_nbr'] = sizeof($tumoral_nodal_sites);
		}
		
		return true;
	}
		
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['EventMaster.id'])) {
				
			$result = $this->find('first', array('conditions'=>array('EventMaster.id'=>$variables['EventMaster.id'])));
				
			$return = array(
					'menu'			=>	array( NULL, __($result['EventControl']['disease_site'], TRUE).' - '.__($result['EventControl']['event_type'], TRUE) ),
					'title'			=>	array( NULL, __('annotation', TRUE) ),
					'data'				=> $result,
					'structure alias'	=> 'eventmasters'
			);
		} else if ( isset($variables['EventControl.id'])) {
				
			
			$event_control_model = AppModel::getInstance("Clinicalannotation", "EventControl", true);
			$result = $event_control_model->find('first', array('conditions'=>array('EventControl.id'=>$variables['EventControl.id'])));
				
			$return = array(
					'menu'			=>	array( NULL, __($result['EventControl']['disease_site'], TRUE).' - '.__($result['EventControl']['event_type'], TRUE) ),
					'title'			=>	null,
					'data'				=> null,
					'structure alias'	=> null
			);
		}
	
		return $return;
	}
	
}

?>