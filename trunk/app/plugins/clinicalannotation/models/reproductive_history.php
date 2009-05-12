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
						'age_at_menopause'	=>	$result['ReproductiveHistory']['age_at_menopause'],
						'menopause_age_certainty'	=>	$result['ReproductiveHistory']['menopause_age_certainty'],
						'hrt_years_on'	=>	$result['ReproductiveHistory']['hrt_years_on'],
						'hrt_use'	=>	$result['ReproductiveHistory']['hrt_use'],
						'hysterectomy_age'	=>	$result['ReproductiveHistory']['hysterectomy_age'],
						'hysterectomy_age_certainty'	=>	$result['ReproductiveHistory']['hysterectomy_age_certainty'],
						'hysterectomy'	=>	$result['ReproductiveHistory']['hysterectomy'],
						'first_ovary_out_age'	=>	$result['ReproductiveHistory']['first_ovary_out_age'],
						'first_ovary_certainty'	=>	$result['ReproductiveHistory']['first_ovary_certainty'],
						'second_ovary_out_age'	=>	$result['ReproductiveHistory']['second_ovary_out_age'],
						'second_ovary_certainty'	=>	$result['ReproductiveHistory']['second_ovary_certainty'],
						'first_ovary_out'	=>	$result['ReproductiveHistory']['first_ovary_out'],
						'second_ovary_out'	=>	$result['ReproductiveHistory']['second_ovary_out'],
						'gravida'	=>	$result['ReproductiveHistory']['gravida'],
						'para'	=>	$result['ReproductiveHistory']['para'],
						'age_at_first_parturition'	=>	$result['ReproductiveHistory']['age_at_first_parturition'],
						'first_parturition_certainty'	=>	$result['ReproductiveHistory']['first_parturition_certainty'],
						'age_at_last_parturition'	=>	$result['ReproductiveHistory']['age_at_last_parturition']
						'last_parturition_certainty'	=>	$result['ReproductiveHistory']['last_parturition_certainty'],
						'age_at_menarche'	=>	$result['ReproductiveHistory']['age_at_menarche'],
						'age_at_menarche_certainty'	=>	$result['ReproductiveHistory']['age_at_menarche_certainty'],
						'oralcontraceptive_use'	=>	$result['ReproductiveHistory']['oralcontraceptive_use'],
						'years_on_oralcontraceptives'	=>	$result['ReproductiveHistory']['years_on_oralcontraceptives']
						'lnmp_date'	=>	$result['ReproductiveHistory']['lnmp_date'],
						'lnmp_certainty'	=>	$result['ReproductiveHistory']['lnmp_certainty']
					)
				)
			);
		}
		
		return $return;
	}
}

?>