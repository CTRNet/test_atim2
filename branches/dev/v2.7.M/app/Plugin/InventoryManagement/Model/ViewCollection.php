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
 * Class ViewCollection
 */
class ViewCollection extends InventoryManagementAppModel
{

    public $baseModel = "Collection";

    public $basePlugin = 'InventoryManagement';

    public $primaryKey = 'collection_id';

    public $belongsTo = array(
        'Collection' => array(
            'className' => 'InventoryManagement.Collection',
            'foreignKey' => 'collection_id',
            'type' => 'INNER'
        ),
        'Participant' => array(
            'className' => 'ClinicalAnnotation.Participant',
            'foreignKey' => 'participant_id'
        ),
        'DiagnosisMaster' => array(
            'className' => 'ClinicalAnnotation.DiagnosisMaster',
            'foreignKey' => 'diagnosis_master_id'
        ),
        'ConsentMaster' => array(
            'className' => 'ClinicalAnnotation.ConsentMaster',
            'foreignKey' => 'consent_master_id'
        )
    );

    public static $tableQuery = '
		SELECT 
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Collection.collection_protocol_id AS collection_protocol_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created 
		FROM collections AS Collection 
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1 
		WHERE Collection.deleted <> 1 %%WHERE%%';

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id'])) {
            $collectionData = $this->find('first', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $variables['Collection.id']
                ),
                'recursive' => - 1
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    $collectionData['ViewCollection']['acquisition_label']
                ),
                'title' => array(
                    null,
                    __('collection') . ' : ' . $collectionData['ViewCollection']['acquisition_label']
                ),
                'structure alias' => 'view_collection',
                'data' => $collectionData
            );
            
            $consentStatus = $this->getUnconsentedParticipantCollections(array(
                'data' => $collectionData
            ));
            if (! empty($consentStatus)) {
                if (! $collectionData['ViewCollection']['participant_id']) {
                    AppController::addWarningMsg(__('no participant is linked to the current participant collection'));
                } elseif ($consentStatus[$variables['Collection.id']] == null) {
                    $link = '';
                    if (AppController::checkLinkPermission('/ClinicalAnnotation/ClinicalCollectionLinks/detail/')) {
                        $link = sprintf(' <a href="%sClinicalAnnotation/ClinicalCollectionLinks/detail/%d/%d">%s</a>', AppController::getInstance()->request->webroot, $collectionData['ViewCollection']['participant_id'], $collectionData['ViewCollection']['collection_id'], __('click here to access it'));
                    }
                    AppController::addWarningMsg(__('no consent is linked to the current participant collection') . '.' . $link);
                } else {
                    AppController::addWarningMsg(__('the linked consent status is [%s]', __($consentStatus[$variables['Collection.id']])));
                }
            }
        }
        
        return $return;
    }

    /**
     *
     * @param array $collection with either a key 'id' referring to an array
     *        of ids, or a key 'data' referring to ViewCollections.
     * @return array The ids of participants collections with a consent status
     *         other than 'obtained' as key. Their value will null if there is no linked
     *         consent or the consent status otherwise.
     */
    public function getUnconsentedParticipantCollections(array $collection)
    {
        $data = null;
        if (array_key_exists('id', $collection)) {
            $data = $this->find('all', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $collection['id']
                ),
                'recursive' => - 1
            ));
        } else {
            $data = array_key_exists('ViewCollection', $collection['data']) ? array(
                $collection['data']
            ) : $collection['data'];
        }
        
        $results = array();
        $consentsToFetch = array();
        foreach ($data as $index => &$dataUnit) {
            if ($dataUnit['ViewCollection']['collection_property'] != 'participant collection') {
                // filter non participant collections
                unset($data[$index]);
            } elseif (empty($dataUnit['ViewCollection']['consent_master_id'])) {
                // removing missing consents
                $results[$dataUnit['ViewCollection']['collection_id']] = null;
                unset($data[$index]);
            } else {
                $consentsToFetch[] = $dataUnit['ViewCollection']['consent_master_id'];
            }
        }
        
        if (! empty($consentsToFetch)) {
            // find all required consents
            $consentModel = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
            $consentData = $consentModel->find('all', array(
                'fields' => array(
                    'ConsentMaster.id',
                    'ConsentMaster.consent_status'
                ),
                'conditions' => array(
                    'ConsentMaster.id' => $consentsToFetch,
                    'NOT' => array(
                        'ConsentMaster.consent_status' => 'obtained'
                    )
                ),
                'recursive' => - 1
            ));
            
            // put consents in array keys
            $notObtainedConsents = array();
            if (! empty($consentData)) {
                foreach ($consentData as &$consentDataUnit) {
                    $notObtainedConsents[$consentDataUnit['ConsentMaster']['id']] = $consentDataUnit['ConsentMaster']['consent_status'];
                }
                
                // see for each collection if the consent is found in the not obtained consent array
                foreach ($data as &$dataUnit) {
                    if (array_key_exists($dataUnit['ViewCollection']['consent_master_id'], $notObtainedConsents)) {
                        $results[$dataUnit['ViewCollection']['collection_id']] = $notObtainedConsents[$dataUnit['ViewCollection']['consent_master_id']];
                    }
                }
            }
        }
        
        return $results;
    }
}