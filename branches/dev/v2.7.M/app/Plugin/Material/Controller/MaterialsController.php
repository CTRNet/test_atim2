<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class MaterialsController
 */
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

    public function index()
    {
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $searchId
     */
    public function search($searchId)
    {
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Material/Materials/index/'));
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->Material, 'materials', '/Material/Materials/search');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    public function add()
    {
        $this->set('atimMenu', $this->Menus->get('/Material/Materials/index/'));
        
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
                $this->atimFlash(__('your data has been updated'), '/Material/Materials/detail/' . $this->Material->id);
            }
        }
    }

    /**
     *
     * @param null $materialId
     */
    public function edit($materialId = null)
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
                    $this->atimFlash(__('your data has been updated'), '/Material/Materials/detail/' . $materialId);
                }
            }
        }
    }

    /**
     *
     * @param null $materialId
     */
    public function detail($materialId = null)
    {
        if (! $materialId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
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

    /**
     *
     * @param null $materialId
     */
    public function delete($materialId = null)
    {
        if (! $materialId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($this->Material->atimDelete($materialId)) {
            $this->atimFlash(__('your data has been deleted'), '/Material/Materials/index/');
        } else {
            $this->atimFlashError(__('error deleting data - contact administrator'), '/Material/Materials/listall/');
        }
    }
}