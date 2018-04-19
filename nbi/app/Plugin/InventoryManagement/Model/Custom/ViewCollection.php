<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class ViewCollectionCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */
 
class ViewCollectionCustom extends ViewCollection
{

    var $name = 'ViewCollection';

    /**
     * Include bc_nbi_acquisition_nbr of the breast path report into the collection view
     */
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
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
EventMaster.bc_nbi_acquisition_nbr        
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN event_masters AS EventMaster ON Collection.event_master_id = EventMaster.id AND EventMaster.deleted <> 1
		WHERE Collection.deleted <> 1 %%WHERE%%';

    /**
     * Manage infomration displayed into the summary and the collection menu (title)
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
            
            $title = __('participant identifier') . ' ' . $collectionData['ViewCollection']['participant_identifier'];
            if (strlen($collectionData['ViewCollection']['collection_datetime'])) {
                switch ($collectionData['ViewCollection']['collection_datetime_accuracy']) {
                    case 'y':
                    case 'm':
                        $title .= ' - ' . substr($collectionData['ViewCollection']['collection_datetime'], 0, 4);
                        break;
                    case 'd':
                        $title .= ' - ' . substr($collectionData['ViewCollection']['collection_datetime'], 0, 7);
                        break;
                    default:
                        $title .= ' - ' . substr($collectionData['ViewCollection']['collection_datetime'], 0, 10);
                }
            }
            
            $return = array(
                'menu' => array(
                    null,
                    $title
                ),
                'title' => array(
                    null,
                    $title
                ),
                'structure alias' => 'view_collection',
                'data' => $collectionData
            );
        }
        
        return $return;
    }
}