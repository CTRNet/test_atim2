<?php

/**
 * Class StructureFormatsController
 */
class StructureFormatsController extends AdministrateAppController
{

    public $uses = array(
        'StructureFormat'
    );

    public $paginate = array(
        'StructureFormat' => array(
            'order' => 'StructureFormat.id ASC'
        )
    );

    /**
     *
     * @param $structureId
     */
    public function listall($structureId)
    {
        $this->set('atimStructure', $this->Structures->get(null, 'fields'));
        $this->set('atimMenuVariables', array(
            'Structure.id' => $structureId
        ));
        
        $this->hook();
        
        $this->request->data = $this->paginate($this->StructureFormat, array(
            'StructureFormat.structure_id' => $structureId
        ));
    }

    /**
     *
     * @param $structureId
     * @param $structureFormatId
     */
    public function detail($structureId, $structureFormatId)
    {
        $this->set('atimStructure', $this->Structures->get(null, 'fields'));
        $this->set('atimMenuVariables', array(
            'Structure.id' => $structureId,
            'StructureFormat.id' => $structureFormatId
        ));
        
        $this->hook();
        
        $this->request->data = $this->StructureFormat->find('first', array(
            'conditions' => array(
                'StructureFormat.id' => $structureFormatId
            )
        ));
    }

    /**
     *
     * @param $structureId
     * @param $structureFormatId
     */
    public function edit($structureId, $structureFormatId)
    {
        $this->set('atimStructure', $this->Structures->get(null, 'fields'));
        $this->set('atimMenuVariables', array(
            'Structure.id' => $structureId,
            'StructureFormat.id' => $structureFormatId
        ));
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            if ($this->StructureFormat->save($this->request->data))
                $this->atimFlash(__('your data has been updated'), '/Administrate/StructureFormats/detail/' . $structureId . '/' . $structureFormatId);
        } else {
            $this->request->data = $this->StructureFormat->find('first', array(
                'conditions' => array(
                    'StructureFormat.id' => $structureFormatId
                )
            ));
        }
    }
}