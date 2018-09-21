<?php

/**
 * Class MenusController
 */
class MenusController extends AdministrateAppController
{

    public $uses = array(
        'Menu'
    );
    
    // temp beforefilter to allow permissions, ACL tables not updated yet
    public function beforeFilter()
    {
        parent::beforeFilter();
        $this->AtimAuth->allowedActions = array(
            'index'
        );
    }

    public function index()
    {
        $this->hook();
        $this->request->data = $this->Menu->find('threaded', array(
            'conditions' => array(
                'parent_id!="3" AND parent_id!="11" AND parent_id!="18" AND parent_id!="55" AND parent_id!="70"'
            )
        ));
    }

    /**
     *
     * @param $menuId
     */
    public function detail($menuId)
    {
        $this->set('atimMenuVariables', array(
            'Menu.id' => $menuId
        ));
        $this->hook();
        $this->request->data = $this->Menu->find('first', array(
            'conditions' => array(
                'Menu.id' => $menuId
            )
        ));
    }

    /**
     *
     * @param $bankId
     */
    public function edit($bankId)
    {
        $this->set('atimMenuVariables', array(
            'Menu.id' => $menuId
        ));
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            $this->Menu->id = $bankId;
            if ($this->Menu->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/Administrate/Menus/detail/' . $menuId);
            }
        } else {
            $this->request->data = $this->Menu->find('first', array(
                'conditions' => array(
                    'Menu.id' => $menuId
                )
            ));
        }
    }
}