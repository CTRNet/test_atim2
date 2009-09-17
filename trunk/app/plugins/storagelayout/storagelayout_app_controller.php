<?php

class StoragelayoutAppController extends AppController {	

	var $components = array('Sop.Sops');

	var $uses = array('Sop.SopMaster');
		
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Storagelayout/';
	}
	
	/**
	 * Get list of SOPs existing to build storage entity like TMA, etc.
	 *
	 * @param $entity_type Type of the studied storage entity (tma, tma_slide)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getSopList($entity_type) {
		switch($entity_type) {
			case 'tma':
			case 'tma_slide':
				return $this->Sops->getSopList();
				break;
			default:
				$this->redirect('/pages/err_sto_system_error', NULL, TRUE); 
		}
	}
	
}

?>