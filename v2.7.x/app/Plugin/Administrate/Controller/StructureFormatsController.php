<?php

class StructureFormatsController extends AdministrateAppController {

	public $uses = array('StructureFormat');

	public $paginate = array(
		'StructureFormat' => array(
			'limit' => PAGINATION_AMOUNT,
			'order' => 'StructureFormat.id ASC'
		)
	);

	public function listall($structure_id) {
		$this->set('atim_structure', $this->Structures->get(null, 'fields'));
		$this->set('atim_menu_variables', array('Structure.id' => $structure_id));

		$this->hook();

		$this->request->data = $this->paginate($this->StructureFormat,
			array('StructureFormat.structure_id' => $structure_id));
	}

	public function detail($structure_id, $structure_format_id) {
		$this->set('atim_structure', $this->Structures->get(null, 'fields'));
		$this->set('atim_menu_variables',
			array('Structure.id' => $structure_id, 'StructureFormat.id' => $structure_format_id));

		$this->hook();

		$this->request->data = $this->StructureFormat->find('first',
			array('conditions' => array('StructureFormat.id' => $structure_format_id)));
	}

	public function edit($structure_id, $structure_format_id) {
		$this->set('atim_structure', $this->Structures->get(null, 'fields'));
		$this->set('atim_menu_variables',
			array('Structure.id' => $structure_id, 'StructureFormat.id' => $structure_format_id));

		$this->hook();

		if (!empty($this->request->data)) {
			if ($this->StructureFormat->save($this->request->data)) {
				$this->atimFlash(__('your data has been updated'),
					'/Administrate/StructureFormats/detail/' . $structure_id . '/' . $structure_format_id);
			}
		} else {
			$this->request->data = $this->StructureFormat->find('first',
				array('conditions' => array('StructureFormat.id' => $structure_format_id)));
		}
	}
}