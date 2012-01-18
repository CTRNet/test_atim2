<?php
class MiscIdentifiersController extends AdministrateAppController {
	
	var $name = 'MiscIdentifiers';
	var $uses = array(
		'ClinicalAnnotation.MiscIdentifier',
		'ClinicalAnnotation.MiscIdentifierControl'
	);
	
	function index(){
		$joins = array(array(
			'table' => 'misc_identifiers',
			'alias'	=> 'MiscIdentifier',
			'type'	=> 'LEFT',
			'conditions' => array('MiscIdentifierControl.id = MiscIdentifier.misc_identifier_control_id', 'MiscIdentifier.participant_id' => null, 'MiscIdentifier.deleted' => 1, 'MiscIdentifier.tmp_deleted' => 1)
		));
		
		$data = $this->MiscIdentifierControl->find('all', array(
			'fields'		=> array('MiscIdentifierControl.id', 'MiscIdentifierControl.misc_identifier_name', 'COUNT(MiscIdentifier.id) AS count'),
			'joins'			=> $joins,
			'conditions'	=> array('NOT' => array('MiscIdentifierControl.autoincrement_name' => '')),
			'group'			=> array('MiscIdentifierControl.id'))
		);
		
		foreach($data as $unit){
			$this->request->data[] = array(
				'MiscIdentifierControl' => $unit['MiscIdentifierControl'],
				'0' => array('count' => $unit[0]['count'])
			);
		}
		
		$this->Structures->set('misc_identifier_manage');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function manage($mi_ctrl_id){
		$this->MiscIdentifierControl->getOrRedirect($mi_ctrl_id);
		$mi_control = $this->MiscIdentifierControl->findById($mi_ctrl_id);
		if($mi_control['MiscIdentifierControl']['flag_confidential'] && !$_SESSION['Auth']['User']['flag_show_confidential']){
			AppController::getInstance()->redirect("/Pages/err_confidential");
		}
		
		$this->set('title', $mi_control['MiscIdentifierControl']['misc_identifier_name']);
		$this->Structures->set('misc_identifier_value');
		$this->set( 'atim_menu_variables', array('MiscIdentifierControl.id' => $mi_ctrl_id));
		
		$reusable_identifiers = $this->MiscIdentifier->find('all', array(
			'conditions' => array('MiscIdentifier.participant_id' => null, 'MiscIdentifier.misc_identifier_control_id' => $mi_ctrl_id, 'MiscIdentifier.deleted' => 1, 'MiscIdentifier.tmp_deleted' => 1),
			'recursive' => -1)
		);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(!empty($this->request->data)){
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}
			
			if($submitted_data_validates){
				$this->MiscIdentifier->query('LOCK TABLE misc_identifiers AS MiscIdentifier WRITE, participants AS Participant WRITE, misc_identifier_controls AS MiscIdentifierControl WRITE, misc_identifiers WRITE, misc_identifiers_revs WRITE');
				$mis = $this->MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.id' => $this->request->data['MiscIdentifier']['selected_id'], 'MiscIdentifier.misc_identifier_control_id' => $mi_ctrl_id, 'MiscIdentifier.tmp_deleted' => 1, 'MiscIdentifier.deleted' => 1), 'recursive' => -1));
				foreach($mis as $mi){
					$mi['MiscIdentifier']['tmp_deleted'] = 0;
					$this->MiscIdentifier->save($mi, array('fieldList' => array('tmp_deleted')));
				}
				$this->MiscIdentifier->query('UNLOCK TABLES');
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				$this->atimFlash( 'your data has been saved', '/Administrate/MiscIdentifiers/manage/'.$mi_ctrl_id );
			}
		}
		
		
		$this->request->data = $reusable_identifiers;

		if(empty($this->request->data)){
			AppController::addWarningMsg(__('there are no unused identifiers of the current type'));
		}
		
	}
	
}