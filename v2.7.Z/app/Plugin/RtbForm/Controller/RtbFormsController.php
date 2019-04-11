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
 * Class RtbformsController
 */
class RtbformsController extends RtbformAppController
{

    public $uses = array(
        'Rtbform.Rtbform'
    );

    public $paginate = array(
        'Rtbform' => array(
            'order' => 'Rtbform.frmTitle'
        )
    );

    public function index()
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }

    /**
     *
     * @param $searchId
     */
    public function search($searchId)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->set('atimMenu', $this->Menus->get('/rtbform/rtbforms/index'));
        $this->searchHandler($searchId, $this->Rtbform, 'rtbforms', '/rtbform/rtbforms/search');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $rtbformId
     */
    public function profile($rtbformId = null)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (! $rtbformId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('atimMenuVariables', array(
            'Rtbform.id' => $rtbformId
        ));
        
        $this->hook();
        
        $this->request->data = $this->Rtbform->find('first', array(
            'conditions' => array(
                'Rtbform.id' => $rtbformId
            )
        ));
    }

    public function add()
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->hook();
        
        if (! empty($this->request->data)) {
            if ($this->Rtbform->save($this->request->data))
                $this->atimFlash(__('your data has been updated'), '/rtbform/rtbforms/profile/' . $this->Rtbform->id);
        }
    }

    /**
     *
     * @param null $rtbformId
     */
    public function edit($rtbformId = null)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (! $rtbformId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('atimMenuVariables', array(
            'Rtbform.id' => $rtbformId
        ));
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            $this->Rtbform->id = $rtbformId;
            if ($this->Rtbform->save($this->request->data)) {
                $this->atimFlash(__('your data has been updated'), '/rtbform/rtbforms/profile/' . $rtbformId);
            }
        } else {
            $this->request->data = $this->Rtbform->find('first', array(
                'conditions' => array(
                    'Rtbform.id' => $rtbformId
                )
            ));
        }
    }

    /**
     *
     * @param null $rtbformId
     */
    public function delete($rtbformId = null)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (! $rtbformId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->hook();
        
        if ($this->Rtbform->atimDelete($rtbformId)) {
            $this->atimFlash(__('your data has been deleted'), '/rtbform/rtbforms/search/');
        } else {
            $this->atimFlashError(__('error deleting data - contact administrator'), '/rtbform/rtbforms/search/');
        }
    }
}