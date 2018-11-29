<?php

/**
 * Class StructuresController
 */
class StructuresController extends AdministrateAppController
{

    public $uses = array(
        'Structure'
    );

    public $paginate = array(
        'Structure' => array(
            'order' => 'Structure.alias ASC'
        )
    );

    public function index()
    {
        $this->hook();
        
        $this->request->data = $this->paginate($this->Structure);
    }

    /**
     *
     * @param $structureId
     */
    public function detail($structureId)
    {
        $this->set('atimMenuVariables', array(
            'Structure.id' => $structureId
        ));
        
        $this->hook();
        
        $this->request->data = $this->Structure->find('first', array(
            'conditions' => array(
                'Structure.id' => $structureId
            )
        ));
    }

    /**
     *
     * @param $structureId
     */
    public function edit($structureId)
    {
        $this->set('atimMenuVariables', array(
            'v.id' => $structureId
        ));
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            if ($this->Structure->save($this->request->data))
                $this->atimFlash(__('your data has been updated'), '/Administrate/Structure/detail/' . $structureId);
        } else {
            $this->request->data = $this->Structure->find('first', array(
                'conditions' => array(
                    'Structure.id' => $structureId
                )
            ));
        }
    }
}