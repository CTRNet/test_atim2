<?php

class ClinicalCollectionLink extends ClinicalAnnotationAppModel
{
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ClinicalCollectionLinks.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ClinicalCollectionLinks.id'=>$variables['ClinicalCollectionLinks.id'])));
			
			$return = array(
				'Summary' => array(
					'participant_id' => array(NULL, $result['ClinicalCollectionLinks']['participant_id']),
					'collection_id'	=> array(NULL, $result['ClincicalCollectionLinks']['collection_id']),
					'diagnosis_id'	=> array(NULL, $result['ClinicalCollectionLinks']['diagnosis_id']),
					'consent_id'	=> array(NULL, $result['ClinicalCollectionLinks']['consent_id'])
				)
			);
		}
		
		return $return;
	}
}

?>