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
 * Class StorageCoordinatesController
 */
class StorageCoordinatesController extends StorageLayoutAppController
{

    public $components = array();

    public $uses = array(
        'StorageLayout.StorageControl',
        'StorageLayout.StorageCoordinate',
        'StorageLayout.StorageMaster',
        
        'InventoryManagement.AliquotMaster'
    );

    public $paginate = array(
        'StorageCoordinate' => array(
            'order' => 'StorageCoordinate.order ASC'
        )
    );

    /*
     * --------------------------------------------------------------------------
     * DISPLAY FUNCTIONS
     * --------------------------------------------------------------------------
     */
    /**
     *
     * @param $storageMasterId
     */
    public function listAll($storageMasterId)
    {
        
        // MANAGE DATA
        
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($storageMasterId);
        
        if (! $storageData['StorageControl']['is_tma_block']) {
            // Get data for the add to selected button
            $this->set('addLinks', $this->StorageControl->getAddStorageStructureLinks($storageMasterId));
        }
        
        if (! $this->StorageControl->allowCustomCoordinates($storageData['StorageControl']['id'], array(
            'StorageControl' => $storageData['StorageControl']
        ))) {
            // Check storage supports custom coordinates
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get storage coordinates
        $this->request->data = $this->paginate($this->StorageCoordinate, array(
            'StorageCoordinate.storage_master_id' => $storageMasterId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->Structures->set('storage_coordinates');
        $this->set('atimMenuVariables', array(
            'StorageMaster.id' => $storageMasterId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $storageMasterId
     */
    public function add($storageMasterId)
    {
        // MANAGE DATA
        
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($storageMasterId);
        
        if (! $this->StorageControl->allowCustomCoordinates($storageData['StorageControl']['id'], array(
            'StorageControl' => $storageData['StorageControl']
        ))) {
            // Check storage supports custom coordinates
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->Structures->set('storage_coordinates');
        $this->set('atimMenuVariables', array(
            'StorageMaster.id' => $storageMasterId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            // Set dimension
            $this->request->data['StorageCoordinate']['dimension'] = 'x';
            
            // Set storage id
            $this->request->data['StorageCoordinate']['storage_master_id'] = $storageMasterId;
            
            // Validates data
            $submittedDataValidates = true;
            
            if ($this->StorageCoordinate->isDuplicatedValue($storageMasterId, $this->request->data['StorageCoordinate']['coordinate_value'])) {
                $submittedDataValidates = false;
            }
            
            if ($this->StorageCoordinate->isDuplicatedOrder($storageMasterId, $this->request->data['StorageCoordinate']['order'])) {
                $submittedDataValidates = false;
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // Save data
                $this->StorageCoordinate->addWritableField(array(
                    'dimension',
                    'storage_master_id'
                ));
                if ($this->StorageCoordinate->save($this->request->data['StorageCoordinate'])) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/StorageLayout/StorageCoordinates/listAll/' . $storageMasterId);
                }
            }
        }
    }

    /**
     *
     * @param $storageMasterId
     * @param $storageCoordinateId
     */
    public function delete($storageMasterId, $storageCoordinateId)
    {
        
        // MANAGE DATA
        
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($storageMasterId);
        
        if (! $this->StorageControl->allowCustomCoordinates($storageData['StorageControl']['id'], array(
            'StorageControl' => $storageData['StorageControl']
        ))) {
            // Check storage supports custom coordinates
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get the coordinate data
        $storageCoordinateData = $this->StorageCoordinate->find('first', array(
            'conditions' => array(
                'StorageCoordinate.id' => $storageCoordinateId,
                'StorageCoordinate.storage_master_id' => $storageMasterId
            )
        ));
        if (empty($storageCoordinateData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->StorageCoordinate->allowDeletion($storageMasterId, $storageCoordinateData);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $flashUrl = '/StorageLayout/StorageCoordinates/listAll/' . $storageMasterId;
        
        if ($arrAllowDeletion['allow_deletion']) {
            // Delete coordinate
            if ($this->StorageCoordinate->atimDelete($storageCoordinateId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), $flashUrl);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $flashUrl);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), $flashUrl);
        }
    }
}