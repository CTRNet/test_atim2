<?php
class TmaSlideCustom extends TmaSlide{
	var $useTable = 'tma_slides';
	var $name = 'TmaSlide';
	
	private $section_ids_check = array(); 	//used for validations
		
	function validates($options = array()){
		//Check tma slide section id (id unique per block)
		if(isset($this->data['TmaSlide']['qbcf_section_id'])) {
			$qbcf_section_id = $this->data['TmaSlide']['qbcf_section_id'];
			$tma_block_storage_master_id = null;
			if(isset($this->data['TmaSlide']['tma_block_storage_master_id'])) {
				$tma_block_storage_master_id = $this->data['TmaSlide']['tma_block_storage_master_id'];
			} else if(isset($this->data['TmaSlide']['id'])) {
				$tmp_slide = $this->find('first', array('conditions' => array('TmaSlide.id' => $this->data['TmaSlide']['id']), 'fields' => array('TmaSlide.tma_block_storage_master_id'), 'recursive' => '-1'));
				if($tmp_slide) {
					$tma_block_storage_master_id = $tmp_slide['TmaSlide']['tma_block_storage_master_id'];
				}
			}
			if(!$tma_block_storage_master_id) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			// Check duplicated id for the same block into submited record
			if(!strlen($qbcf_section_id)) {
				// Not studied
			} else if(isset($this->section_ids_check[$tma_block_storage_master_id.'-'.$qbcf_section_id])) {
				$this->validationErrors['qbcf_section_id'][] = str_replace('%s', $qbcf_section_id, __('you can not record section id [%s] twice'));
			} else {
				$this->section_ids_check[$tma_block_storage_master_id.'-'.$qbcf_section_id] = '';
			}
			
			// Check duplicated id for the same block into db
			$criteria = array('TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id, 'TmaSlide.qbcf_section_id' => $qbcf_section_id);
			$slides_having_duplicated_id = $this->find('all', array('conditions' => $criteria, 'recursive' => -1));;
			if(!empty($slides_having_duplicated_id)) {
				foreach($slides_having_duplicated_id as $duplicate) {
					if((!array_key_exists('id', $this->data['TmaSlide'])) || ($duplicate['TmaSlide']['id'] != $this->data['TmaSlide']['id'])) {
						$this->validationErrors['qbcf_section_id'][] = str_replace('%s', $qbcf_section_id, __('the section id [%s] has already been recorded'));
					}
				}
			}
		}
		
		return parent::validates($options);
	}
}