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
 * Class SopExtendsController
 */
class SopExtendsController extends SopAppController
{

    public $uses = array(
        'Sop.SopExtend',
        'Sop.SopMaster',
        'Sop.SopControl',
        'Material.Material'
    );

    public $paginate = array(
        'SopMaster' => array(
            'order' => 'SopMaster.id DESC'
        )
    );

    /**
     *
     * @param $sopMasterId
     */
    public function listall($sopMasterId)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->set('atimMenuVariables', array(
            'SopMaster.id' => $sopMasterId
        ));
        
        $sopMasterData = $this->SopMaster->find('first', array(
            'conditions' => array(
                'SopMaster.id' => $sopMasterId
            )
        ));
        
        $this->SopExtend = AppModel::atimInstantiateExtend($this->SopExtend, $sopMasterData['SopControl']['extend_tablename']);
        $useFormAlias = $sopMasterData['SopControl']['extend_form_alias'];
        $this->Structures->set($useFormAlias);
        
        $this->hook();
        
        $this->request->data = $this->paginate($this->SopExtend, array(
            'SopExtend.sop_master_id' => $sopMasterId
        ));
        
        $materialList = $this->Material->find('all', array(
            'fields' => array(
                'Material.id',
                'Material.item_name'
            ),
            'order' => array(
                'Material.item_name'
            )
        ));
        $this->set('materialList', $materialList);
    }

    /**
     *
     * @param null $sopMasterId
     * @param null $sopExtendId
     */
    public function detail($sopMasterId = null, $sopExtendId = null)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->set('atimMenuVariables', array(
            'SopMaster.id' => $sopMasterId,
            'SopExtend.id' => $sopExtendId
        ));
        
        // Get treatment master row for extended data
        $sopMasterData = $this->SopMaster->find('first', array(
            'conditions' => array(
                'SopMaster.id' => $sopMasterId
            )
        ));
        
        // Set form alias/tablename to use
        $this->SopExtend = AppModel::atimInstantiateExtend($this->SopExtend, $sopMasterData['SopControl']['extend_tablename']);
        $useFormAlias = $sopMasterData['SopControl']['extend_form_alias'];
        $this->Structures->set($useFormAlias);
        
        $this->hook();
        
        $this->request->data = $this->SopExtend->find('first', array(
            'conditions' => array(
                'SopExtend.id' => $sopExtendId
            )
        ));
        
        $materialList = $this->Material->find('all', array(
            'fields' => array(
                'Material.id',
                'Material.item_name'
            ),
            'order' => array(
                'Material.item_name'
            )
        ));
        $this->set('materialList', $materialList);
    }

    /**
     *
     * @param null $sopMasterId
     */
    public function add($sopMasterId = null)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->set('atimMenuVariables', array(
            'SopMaster.id' => $sopMasterId
        ));
        
        // Get treatment master row for extended data
        $sopMasterData = $this->SopMaster->find('first', array(
            'conditions' => array(
                'SopMaster.id' => $sopMasterId
            )
        ));
        
        // Set form alias/tablename to use
        $this->SopExtend = AppModel::atimInstantiateExtend($this->SopExtend, $sopMasterData['SopControl']['extend_tablename']);
        $useFormAlias = $sopMasterData['SopControl']['extend_form_alias'];
        $this->Structures->set($useFormAlias);
        
        $materialList = $this->Material->find('all', array(
            'fields' => array(
                'Material.id',
                'Material.item_name'
            ),
            'order' => array(
                'Material.item_name'
            )
        ));
        $this->set('materialList', $materialList);
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            $this->request->data['SopExtend']['sop_master_id'] = $sopMasterData['SopMaster']['id'];
            if ($this->SopExtend->save($this->request->data)) {
                $this->atimFlash(__('your data has been saved'), '/Sop/SopExtends/listall/' . $sopMasterId);
            }
        }
    }

    /**
     *
     * @param null $sopMasterId
     * @param null $sopExtendId
     */
    public function edit($sopMasterId = null, $sopExtendId = null)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->set('atimMenuVariables', array(
            'SopMaster.id' => $sopMasterId,
            'SopExtend.id' => $sopExtendId
        ));
        
        // Get treatment master row for extended data
        $sopMasterData = $this->SopMaster->find('first', array(
            'conditions' => array(
                'SopMaster.id' => $sopMasterId
            )
        ));
        
        // Set form alias/tablename to use
        $this->SopExtend = AppModel::atimInstantiateExtend($this->SopExtend, $sopMasterData['SopControl']['extend_tablename']);
        $useFormAlias = $sopMasterData['SopControl']['extend_form_alias'];
        $this->Structures->set($useFormAlias);
        
        $materialList = $this->Material->find('all', array(
            'fields' => array(
                'Material.id',
                'Material.item_name'
            ),
            'order' => array(
                'Material.item_name'
            )
        ));
        $this->set('materialList', $materialList);
        
        $thisData = $this->SopExtend->find('first', array(
            'conditions' => array(
                'SopExtend.id' => $sopExtendId
            )
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'SopMaster.id' => $sopMasterId,
            'SopExtend.id' => $sopExtendId
        ));
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            $this->SopExtend->id = $sopExtendId;
            if ($this->SopExtend->save($this->request->data)) {
                $this->atimFlash(__('your data has been updated'), '/Sop/SopExtends/detail/' . $sopMasterId . '/' . $sopExtendId);
            }
        } else {
            $this->request->data = $thisData;
        }
    }

    /**
     *
     * @param null $sopMasterId
     * @param null $sopExtendId
     */
    public function delete($sopMasterId = null, $sopExtendId = null)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->hook();
        
        $this->SopExtend->del($sopExtendId);
        $this->atimFlash(__('your data has been deleted'), '/Sop/SopExtends/listall/' . $sopMasterId);
    }
}