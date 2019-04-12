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
 * Class TreatmentMaster
 */
class TreatmentMaster extends ClinicalAnnotationAppModel
{

    public $belongsTo = array(
        'TreatmentControl' => array(
            'className' => 'ClinicalAnnotation.TreatmentControl',
            'foreignKey' => 'treatment_control_id'
        )
    );

    public $browsingSearchDropdownInfo = array(
        'browsing_filter' => array(
            1 => array(
                'lang' => 'keep entries with the most recent start date per participant',
                'group by' => 'participant_id',
                'field' => 'start_date',
                'attribute' => 'MAX'
            ),
            2 => array(
                'lang' => 'keep entries with the oldest start date per participant',
                'group by' => 'participant_id',
                'field' => 'start_date',
                'attribute' => 'MIN'
            )
        )
    );

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['TreatmentMaster.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'TreatmentMaster.id' => $variables['TreatmentMaster.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    __($result['TreatmentControl']['tx_method'], true) . (empty($result['TreatmentControl']['disease_site']) ? '' : ' - ' . __($result['TreatmentControl']['disease_site'], true))
                ),
                'title' => array(
                    null,
                    __('treatment', true)
                ),
                'data' => $result,
                'structure alias' => 'treatmentmasters'
            );
        }
        
        return $return;
    }

    /**
     * Check if a record can be deleted.
     *
     * @param $txMasterId Id of the studied record.
     * @param $txExtendTablename
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2010-04-18
     */
    public function allowDeletion($txMasterId)
    {
        if ($txMasterId != $this->id) {
            // not the same, fetch
            $data = $this->findById($txMasterId);
        } else {
            $data = $this->data;
        }
        
        if (! empty($data['TreatmentControl']['treatment_extend_control_id'])) {
            $treatmentExtendMaster = AppModel::getInstance('ClinicalAnnotation', 'TreatmentExtendMaster', true);
            $nbrExtends = $treatmentExtendMaster->find('count', array(
                'conditions' => array(
                    'TreatmentExtendMaster.treatment_master_id' => $txMasterId,
                    'TreatmentExtendMaster.treatment_extend_control_id' => $data['TreatmentControl']['treatment_extend_control_id']
                ),
                'recursive' => - 1
            ));
            if ($nbrExtends > 0) {
                return array(
                    'allow_deletion' => false,
                    'msg' => 'at least one precision is defined as treatment component'
                );
            }
        }
        
        $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection');
        if ($collectionModel->find('first', array(
            'conditions' => array(
                'Collection.treatment_master_id' => $txMasterId
            )
        ))) {
            return array(
                'allow_deletion' => false,
                'msg' => 'at least one collection is linked to that treatment'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}