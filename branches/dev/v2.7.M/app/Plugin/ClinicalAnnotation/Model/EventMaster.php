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
 * Class EventMaster
 */
class EventMaster extends ClinicalAnnotationAppModel
{

    public $belongsTo = array(
        'EventControl' => array(
            'className' => 'ClinicalAnnotation.EventControl',
            'foreignKey' => 'event_control_id'
        )
    );

    public $browsingSearchDropdownInfo = array(
        'browsing_filter' => array(
            1 => array(
                'lang' => 'keep entries with the most recent date per participant',
                'group by' => 'participant_id',
                'field' => 'event_date',
                'attribute' => 'MAX'
            ),
            2 => array(
                'lang' => 'keep entries with the oldest date per participant',
                'group by' => 'participant_id',
                'field' => 'event_date',
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
        
        if (isset($variables['EventMaster.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'EventMaster.id' => $variables['EventMaster.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    __($result['EventControl']['event_type'], true) . (empty($result['EventControl']['disease_site']) ? '' : ' - ' . __($result['EventControl']['disease_site'], true))
                ),
                'title' => array(
                    null,
                    __('annotation', true)
                ),
                'data' => $result,
                'structure alias' => 'eventmasters'
            );
        } elseif (isset($variables['EventControl.id'])) {
            $return = array();
        }
        
        return $return;
    }

    /**
     * Compares dx data with a cap report and generates warning when there are
     * mismatches.
     *
     * @param array $diagnosisData
     * @param array $eventData
     */
    public static function generateDxCompatWarnings(array $diagnosisData, array $eventData)
    {
        $diagnosisData = $diagnosisData['DiagnosisMaster'];
        $eventData = $eventData['EventDetail'];
        
        $toCheck = array(
            // field => untranslated language label
            'path_tstage' => 'path tstage',
            'path_nstage' => 'path nstage',
            'path_mstage' => 'path mstage',
            'tumour_grade' => 'histologic grade'
        );
        foreach ($toCheck as $field => $languageLabel) {
            if (array_key_exists($field, $eventData) && $diagnosisData[$field] != $eventData[$field]) {
                AppController::addWarningMsg(sprintf(__('the diagnosis value for %s does not match the cap report value'), __($languageLabel)));
            }
        }
    }

    /**
     *
     * @param int $eventMasterId
     * @return array
     */
    public function allowDeletion($eventMasterId)
    {
        $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection');
        if ($collectionModel->find('first', array(
            'conditions' => array(
                'Collection.event_master_id' => $eventMasterId
            )
        ))) {
            return array(
                'allow_deletion' => false,
                'msg' => 'at least one collection is linked to that annotation'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     *
     * @param array $data
     */
    public function calculatedDetailFields(array &$data)
    {
        if (($data['EventControl']['detail_tablename'] == 'ed_all_lifestyle_smokings') && array_key_exists('started_on', $data['EventDetail']) && array_key_exists('stopped_on', $data['EventDetail'])) {
            // for smoking, smoked for and stopped since fields
            if (! empty($data['EventDetail']['started_on']) && $data['EventDetail']['started_on_accuracy'] == 'c' && ! empty($data['EventDetail']['stopped_on']) && $data['EventDetail']['stopped_on_accuracy'] == 'c') {
                $data['EventDetail']['smoked_for'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($data['EventDetail']['started_on'] . ' 00:00:00', $data['EventDetail']['stopped_on'] . ' 00:00:00'), false);
            } else {
                $data['EventDetail']['smoked_for'] = __('cannot calculate on incomplete date');
            }
            if (! empty($data['EventDetail']['stopped_on']) && $data['EventDetail']['stopped_on_accuracy'] == 'c') {
                $data['EventDetail']['stopped_since'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($data['EventDetail']['stopped_on'] . ' 00:00:00', date("Y-m-d H:i:s")), false);
            } else {
                $data['EventDetail']['stopped_since'] = __('cannot calculate on incomplete date');
            }
        }
    }
}