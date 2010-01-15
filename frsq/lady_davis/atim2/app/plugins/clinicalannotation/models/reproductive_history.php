<?php

class ReproductiveHistory extends ClinicalAnnotationAppModel
{
     function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ReproductiveHistory.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ReproductiveHistory.id'=>$variables['ReproductiveHistory.id'])));
			
			$return = array(
				'Summary' => array(
					'participant_id' => array( NULL, $result['ReproductiveHistory']['participant_id']),
					'description'	=>	array(
						'date_captured'	=>	$result['ReproductiveHistory']['date_captured'],
						'menopause_status'	=>	$result['ReproductiveHistory']['menopause_status'],
						'hrt_use'	=>	$result['ReproductiveHistory']['hrt_use'],
						'hysterectomy'	=>	$result['ReproductiveHistory']['hysterectomy'],
						'gravida'	=>	$result['ReproductiveHistory']['gravida'],
						'para'	=>	$result['ReproductiveHistory']['para'],
						'oralcontraceptive_use'	=>	$result['ReproductiveHistory']['oralcontraceptive_use'],
						'years_on_oralcontraceptives'	=>	$result['ReproductiveHistory']['years_on_oralcontraceptives']
					)
				)
			);
		}
		
		return $return;
	}
}

?>