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
 * Class OrdersController
 */
class OrdersController extends OrderAppController
{

    public $components = array();

    public $uses = array(
        'Order.Order',
        'Order.OrderLine',
        'Order.Shipment',
        
        'Study.StudySummary'
    );

    public $paginate = array(
        'Order' => array(
            'order' => 'Order.date_order_placed DESC'
        ),
        'OrderLine' => array(
            'order' => 'OrderLine.date_required DESC'
        )
    );

    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $this->set('atimMenu', $this->Menus->get('/Order/Orders/search'));
        
        if (empty($searchId)) {
            // index
            unset($_SESSION['Order']['AliquotIdsToAddToOrder']);
        }
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->Order, 'orders', '/Order/Orders/search');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            $this->render('index');
        }
    }

    public function add()
    {
        // MANAGE DATA
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Order/Orders/search'));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // SAVE PROCESS
        
        if (! empty($this->request->data)) {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates && $this->Order->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been saved'), '/Order/Orders/detail/' . $this->Order->id);
            }
        }
    }

    /**
     *
     * @param $orderId
     * @param bool $isFromTreeView
     */
    public function detail($orderId, $isFromTreeView = false)
    {
        // MANAGE DATA
        $orderData = $this->Order->getOrRedirect($orderId);
        if (empty($orderData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Set order data
        $this->set('orderData', $orderData);
        $this->request->data = array();
        
        $shipmentsList = $this->Shipment->find('all', array(
            'conditions' => array(
                'Shipment.order_id' => $orderId
            ),
            'recursive' => - 1
        ));
        $this->set('shipmentsList', $shipmentsList);
        
        $this->set('isFromTreeView', $isFromTreeView);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $orderId
     */
    public function edit($orderId)
    {
        // MANAGE DATA
        $orderData = $this->Order->getOrRedirect($orderId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // SAVE PROCESS
        
        if (empty($this->request->data)) {
            $orderData['FunctionManagement']['autocomplete_order_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $orderData['Order']['default_study_summary_id']
                )
            ));
            $this->request->data = $orderData;
        } else {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->Order->id = $orderId;
                $this->Order->data = array();
                if ($this->Order->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Order/Orders/detail/' . $orderId);
                }
            }
        }
    }

    /**
     *
     * @param $orderId
     */
    public function delete($orderId)
    {
        if (! $orderId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        $orderData = $this->Order->find('first', array(
            'conditions' => array(
                'Order.id' => $orderId
            )
        ));
        if (empty($orderData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->Order->allowDeletion($orderId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->Order->atimDelete($orderId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Order/Orders/search/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Order/Orders/search/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Order/Orders/detail/' . $orderId);
        }
    }
}