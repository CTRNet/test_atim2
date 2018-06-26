<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class CollectionCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */
 
class CollectionCustom extends Collection
{

    var $useTable = 'collections';

    var $name = 'Collection';
    
    /**
     * Validate if the collection to participant link could be deleted.
     * Link could be deleted only if no sample exists into the collection 
     * because collection will be deleted after the link deletion by custom code.
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

    /**
     * Generate a unique 7 digits Acquisition Number
     *
     * @return string The 7 digits Acquisition Number
     */
    function getNextAcquisitionNumber()
    {
        // Check no aliquot linked to the collection
        $randAcquisitionNbr = rand(1, 9999999);
        $randAcquisitionNbr = sprintf("%06d", $randAcquisitionNbr);
        return $randAcquisitionNbr;
    }
        
    /**
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if (! $this->id && isset($this->data['Collection']['acquisition_label'])) {
            // acquisition_label should be unique
            $newLabelFound = false;
            $continueLoop = true;
            $loopCounter = 0;
            while ($continueLoop) {
                if (! $this->find('count', array(
                    'conditions' => array(
                        'Collection.acquisition_label' => $this->data['Collection']['acquisition_label']
                    )
                ))) {
                    $newLabelFound = true;
                    $continueLoop = false;
                } else {
                    $this->data['Collection']['acquisition_label'] = $this->getNextAcquisitionNumber();
                }
                $loopCounter ++;
                if ($loopCounter > 100) {
                    $continueLoop = false;
                }
            }
            if (! $newLabelFound) {
                $this->validationErrors['acquisition_label'][] = 'system generated a duplicated acquisition number - please try to save data again';
            } 
        }
        return parent::validates($options);
    }
}
