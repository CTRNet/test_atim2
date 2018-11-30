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
 * Class InventoryManagementAppController
 */
class InventoryManagementAppController extends AppController
{

    /**
     *
     * @param array $data
     */
    public function setBatchMenu(array $data)
    {
        if (array_key_exists('SampleMaster', $data) && ! empty($data['SampleMaster'])) {
            $id = null;
            if (is_string($data['SampleMaster'])) {
                $id = explode(",", $data['SampleMaster']);
            } elseif (array_key_exists(0, $data['SampleMaster']) && is_numeric($data['SampleMaster'][0])) {
                $id = $data['SampleMaster'];
            } elseif (! array_key_exists('initial_specimen_sample_id', $data['SampleMaster'])) {
                $id = $data['SampleMaster']['id'];
            }
            if ($id != null) {
                $data = $this->SampleMaster->find('all', array(
                    'conditions' => array(
                        'SampleMaster.id' => $id
                    ),
                    'recursive' => - 1
                ));
            } elseif (array_key_exists('SampleMaster', $data)) {
                $data = array(
                    array(
                        'SampleMaster' => $data['SampleMaster']
                    )
                );
            }
            
            if (count($data) == 1) {
                $data = $data[0]['SampleMaster'];
                if ($data['initial_specimen_sample_id'] == $data['id']) {
                    $this->set('atimMenu', $this->Menus->get('/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));
                } else {
                    $this->set('atimMenu', $this->Menus->get('/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%'));
                }
                $this->set('atimMenuVariables', array(
                    'Collection.id' => $data['collection_id'],
                    'SampleMaster.id' => $data['id'],
                    'SampleMaster.initial_specimen_sample_id' => $data['initial_specimen_sample_id']
                ));
            } elseif (! empty($data)) {
                $collectionId = $data[0]['SampleMaster']['collection_id'];
                foreach ($data as $dataUnit) {
                    if ($dataUnit['SampleMaster']['collection_id'] != $collectionId) {
                        $collectionId = null;
                        break;
                    }
                }
                if ($collectionId == null) {
                    $this->set('atimMenu', $this->Menus->get('/InventoryManagement/'));
                } else {
                    $this->set('atimMenu', $this->Menus->get('/InventoryManagement/Collections/detail/%%Collection.id%%'));
                    $this->set('atimMenuVariables', array(
                        'Collection.id' => $collectionId
                    ));
                }
            }
        }
    }

    /**
     *
     * @param $data
     * @param bool $isRealiquotedList
     */
    public function setAliquotMenu($data, $isRealiquotedList = false)
    {
        if (! isset($data['SampleControl']) || ! isset($data['SampleMaster']) || ! isset($data['AliquotMaster'])) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $atimMenuLink = ($data['SampleControl']['sample_category'] == 'specimen') ? '/InventoryManagement/AliquotMasters/' . ($isRealiquotedList ? 'listAllRealiquotedParents' : 'detail') . '/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' : '/InventoryManagement/AliquotMasters/' . ($isRealiquotedList ? 'listAllRealiquotedParents' : 'detail') . '/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
        $this->set('atimMenu', $this->Menus->get($atimMenuLink));
        $this->set('atimMenuVariables', array(
            'Collection.id' => $data['AliquotMaster']['collection_id'],
            'SampleMaster.id' => $data['AliquotMaster']['sample_master_id'],
            'SampleMaster.initial_specimen_sample_id' => $data['SampleMaster']['initial_specimen_sample_id'],
            'AliquotMaster.id' => $data['AliquotMaster']['id']
        ));
    }
}