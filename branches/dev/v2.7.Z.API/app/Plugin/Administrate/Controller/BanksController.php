<?php

/**
 * Class BanksController
 */
class BanksController extends AdministrateAppController
{

    public $uses = array(
        'Administrate.Bank'
    );

    public $paginate = array(
        'Bank' => array(
            'order' => 'Bank.name ASC'
        )
    );

    public function add()
    {
        $this->set('atimMenu', $this->Menus->get('/Administrate/Banks/index'));
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            if ($this->Bank->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/Administrate/Banks/detail/' . $this->Bank->id);
            }
        }
    }

    public function index()
    {
        $this->hook();
        $this->request->data = $this->paginate($this->Bank);
    }

    /**
     * @param $bankId
     */
    public function detail($bankId)
    {
        $this->set('atimMenuVariables', array(
            'Bank.id' => $bankId
        ));
        $this->hook();
        $this->request->data = $this->Bank->find('first', array(
            'conditions' => array(
                'Bank.id' => $bankId
            )
        ));
    }

    /**
     * @param $bankId
     */
    public function edit($bankId)
    {
        $this->set('atimMenuVariables', array(
            'Bank.id' => $bankId
        ));
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            $this->Bank->id = $bankId;
            if ($this->Bank->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/Administrate/Banks/detail/' . $bankId);
            }
        } else {
            $this->request->data = $this->Bank->find('first', array(
                'conditions' => array(
                    'Bank.id' => $bankId
                )
            ));
        }
    }

    /**
     * @param $bankId
     */
    public function delete($bankId)
    {
        $arrAllowDeletion = $this->Bank->allowDeletion($bankId);
        
        // CUSTOM CODE
        $hookLink = $this->hook();
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->Bank->atimDelete($bankId)) {
                $this->atimFlash(__('your data has been deleted'), '/Administrate/Banks/index');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Administrate/Banks/index');
            }
        } else {
            $this->atimFlashWarning(__('this bank is being used and cannot be deleted') . ': ' . __($arrAllowDeletion['msg']), '/Administrate/Banks/detail/' . $bankId . "/");
        }
    }
}