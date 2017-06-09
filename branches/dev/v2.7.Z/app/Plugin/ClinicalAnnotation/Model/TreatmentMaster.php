<?php

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

    function summary($variables = array())
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
                    NULL,
                    __($result['TreatmentControl']['tx_method'], true) . (empty($result['TreatmentControl']['disease_site']) ? '' : ' - ' . __($result['TreatmentControl']['disease_site'], true))
                ),
                'title' => array(
                    NULL,
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
     * @param $txMasterId Id
     *            of the studied record.
     * @param
     *            $txExtendTablename
     *            
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2010-04-18
     */
    function allowDeletion($txMasterId)
    {
        if ($txMasterId != $this->id) {
            // not the same, fetch
            $data = $this->findById($txMasterId);
        } else {
            $data = $this->data;
        }
        
        if (! empty($data['TreatmentControl']['treatment_extend_control_id'])) {
            $TreatmentExtendMaster = AppModel::getInstance('ClinicalAnnotation', 'TreatmentExtendMaster', true);
            $nbrExtends = $TreatmentExtendMaster->find('count', array(
                'conditions' => array(
                    'TreatmentExtendMaster.treatment_master_id' => $txMasterId,
                    'TreatmentExtendMaster.treatment_extend_control_id' => $data['TreatmentControl']['treatment_extend_control_id']
                ),
                'recursive' => '-1'
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