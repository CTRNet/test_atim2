<?php

class ViewCollectionCustom extends ViewCollection
{

    var $useTable = 'view_collections';

    var $name = 'ViewCollection';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id'])) {
            $collectionData = $this->find('first', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $variables['Collection.id']
                )
            ));
            
            $collectionTitle = __('participant identifier') . ': ' . (empty($collectionData['ViewCollection']['participant_identifier']) ? __('unlinked') : $collectionData['ViewCollection']['participant_identifier']);
            if (! empty($collectionData['ViewCollection']['collection_datetime'])) {
                $formattedCollectionDate = substr($collectionData['ViewCollection']['collection_datetime'], 0, strpos($collectionData['ViewCollection']['collection_datetime'], ' '));
                switch ($collectionData['ViewCollection']['collection_datetime_accuracy']) {
                    case 'y':
                        $formattedCollectionDate = '+/-' . substr($formattedCollectionDate, 0, strpos($formattedCollectionDate, '-'));
                        break;
                    case 'm':
                        $formattedCollectionDate = substr($formattedCollectionDate, 0, strpos($formattedCollectionDate, '-'));
                        break;
                    case 'd':
                        $formattedCollectionDate = substr($formattedCollectionDate, 0, strrpos($formattedCollectionDate, '-'));
                        break;
                    default:
                }
                $collectionTitle .= ' [' . $formattedCollectionDate . ']';
            }
            
            $return = array(
                'menu' => array(
                    null,
                    $collectionTitle
                ),
                'title' => array(
                    null,
                    __('collection') . ' : ' . $collectionTitle
                ),
                'structure alias' => 'view_collection',
                'data' => $collectionData
            );
            
            $consentStatus = $this->getUnconsentedParticipantCollections(array(
                'data' => $collectionData
            ));
            if (! empty($consentStatus)) {
                if ($consentStatus[$variables['Collection.id']] == null) {
                    AppController::addWarningMsg(__('no consent is linked to the current participant collection'));
                } else {
                    AppController::addWarningMsg(__('the linked consent status is [%s]', $consentStatus[$variables['Collection.id']], true));
                }
            }
        }
        
        return $return;
    }
}