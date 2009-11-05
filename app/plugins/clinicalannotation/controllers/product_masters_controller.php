<?php
class ProductMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.ClinicalCollectionLink',
		'Clinicalannotation.Collection',
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.AliquotMaster'
	);
	
	var $paginate = array('DiagnosisMaster'=>array('limit'=>10,'order'=>'DiagnosisMaster.dx_date')); 
	
	function listall( $participant_id, $current_filter = null) {
		$atim_structure = array();
		$atim_structure['ClinicalCollectionLink']	= $this->Structures->get('form','clinicalcollectionlinks');
		$atim_structure['Collection']	= $this->Structures->get('form','collection_tree_view');
		$atim_structure['SampleMaster']	= $this->Structures->get('form','sample_masters_for_collection_tree_view');
		$atim_structure['AliquotMaster']	= $this->Structures->get('form','aliquot_masters_for_collection_tree_view');
		$this->set('atim_structure', $atim_structure);
		
		$this->set('atim_menu_variables', array('Participant.id' => $participant_id, 'CurrentFilter' => $current_filter));
		$collection_data = $this->Collection->find('all', array('conditions' => 'ClinicalCollectionLink.participant_id='.$participant_id, 'recursive' => 2));
		$this->data = array();
		$tmp_data = array();
		$filters = array();
		$collection_n = 0;
		foreach($collection_data as $key => $value){//iterate over collections
			if(isset($collection_data[$key]['SampleMaster'][0])){
				$tmp_data[$collection_n]['Collection'] = $collection_data[$key]['Collection'];
				$sample_data = $this->SampleMaster->find('threaded', array('conditions' => 'Collection.id='.$collection_data[$key]['Collection']['id']));
				$this->build_sample_recur(&$sample_data, &$filters, $current_filter);
				$tmp_data[$collection_n]['children'] = $sample_data;
				++ $collection_n;
			}
		}
		if($current_filter != null){
			foreach($tmp_data as $key => $value){//iterate over collections
				if(isset($tmp_data[$key]['children'])){
					foreach($tmp_data[$key]['children'] as $key2 => $value2){
						array_push($this->data, $value2);
					}
				}
			}
			$this->set('none_filter', true);
		}else{
			$this->data = $tmp_data;
		}
		$this->set('filters', $filters);
	}
	
	function build_sample_recur($sample_data, $filters, $current_filter){
		foreach($sample_data as $key => $value){//iterate over samples
			$aliquot_n = 0;
			$tmp_aliquot_array = array();
			if(isset($sample_data[$key]['AliquotMaster'])){
				foreach($sample_data[$key]['AliquotMaster'] as $key2 => $value2){//iterate over aliquots
						$tmp_aliquot_array[$aliquot_n ++]['AliquotMaster'] = $sample_data[$key]['AliquotMaster'][$key2];
				}
			}
			$this->clean(&$sample_data[$key], 'SampleMaster');
			$filters[$sample_data[$key]['SampleMaster']['initial_specimen_sample_type']] = "";
			if($current_filter != null && $sample_data[$key]['SampleMaster']['initial_specimen_sample_type'] != $current_filter){
				unset($sample_data[$key]);
			}
			else if(isset($sample_data[$key]['children'])){
				$this->build_sample_recur(&$sample_data[$key]['children'], &$filters, $current_filter);
				$sample_data[$key]['children'] = array_merge($sample_data[$key]['children'], $tmp_aliquot_array);
			}else{
				$sample_data[$key]['children'] = $tmp_aliquot_array;
			}
		}
	}
	
	function clean($arr, $keep){
		foreach($arr as $key => $value){
			if($key != $keep && $key != 'children'){
				unset($arr[$key]);
			}
		}
	}
}