<?php
/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class CollectionCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */
 
class CollectionCustom extends Collection
{

    var $useTable = 'collections';

    var $name = 'Collection';

    /**
     * Validate if the collection to participant link could be deleted.
     * Link could be deleted only if no sample exists into the collection because collection will be deleted after the link deletion by custom code.
     *
     * @param array $variables            
     * @return array|bool
     */
    function allowLinkDeletion($collectionId)
    {
        // Check no aliquot linked to the collection
        $sampleModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $collectionSamplesCount = $sampleModel->find('count', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId
            ),
            'recursive' => '-1'
        ));
        if ($collectionSamplesCount) {
            return array(
                'allow_deletion' => false,
                'msg' => 'the link cannot be deleted - collection contains at least one sample'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}
