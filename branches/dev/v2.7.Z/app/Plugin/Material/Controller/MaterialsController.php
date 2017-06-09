<?php

class MaterialsController extends MaterialAppController
{

    public $uses = array(
        'Material.Material'
    );

    public $paginate = array(
        'Material' => array(
            'order' => 'Material.item_name'
        )
    );

    function index()
    {
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    function search($searchId)
    {
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/material/materials/index/'));
        
        $this->searchHandler($searchId, $this->Material, 'materials', '/material/materials/search');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    function add()
    {
        $this->set('atimMenu', $this->Menus->get('/material/materials/index/'));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates && $this->Material->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/material/materials/detail/' . $this->Material->id);
            }
        }
    }

    function edit($materialId = null)
    {
        $materialData = $this->Material->getOrRedirect($materialId);
        
        $this->set('atimMenuVariables', array(
            'Material.id' => $materialId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $materialData;
        } else {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->Material->id = $materialId;
                if ($this->Material->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/material/materials/detail/' . $materialId);
                }
            }
        }
    }

    function detail($materialId = null)
    {
        if (! $materialId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, NULL, true);
        }
        
        $this->set('atimMenuVariables', array(
            'Material.id' => $materialId
        ));
        
        $this->request->data = $this->Material->find('first', array(
            'conditions' => array(
                'Material.id' => $materialId
            )
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    function delete($materialId = null)
    {
        if (! $materialId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, NULL, true);
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($this->Material->atimDelete($materialId)) {
            $this->atimFlash(__('your data has been deleted'), '/material/materials/index/');
        } else {
            $this->atimFlashError(__('error deleting data - contact administrator'), '/material/materials/listall/');
        }
    }
}