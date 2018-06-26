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