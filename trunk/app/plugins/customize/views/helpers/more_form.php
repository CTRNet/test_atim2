<?php 
	
	class MoreFormHelper extends Helper
	{
	
		var $name = 'MoreForm';
		var $helpers = array( 'Translations' );
		
		/* 
			Creates radio buttons for choosing a CONSTENT FORM 
			info comes from CONSENT table rows
			Used for LINK views 
		*/
		
		function associated_collection_form( $lang=array(), $list_of_collection=array(), $form_field_name=array( 'ClinicalCollectionLink', 'collection_id' ), $form_select_value=0 ) {
			
			// setup variables for build 
			$radio = array();
			$radio_display = '';
				
			
				
			// build COLLECTION radio button set 
				
				// go through all COLLECTION, make array of COLLECTION for building radio buttons 
				foreach ( $list_of_collection as $collection ) {
				
					$radio[ $collection['Collection']['id'] ] = 
						$collection['Collection']['acquisition_label']
						.'</td><td>'.
						$collection['Collection']['collection_datetime']
					;
					
				}
				
				// start RADIO table, with hardcoded LABEL and HELP 
				$radio_display .= '
					<label>'.$this->Translations->t( 'collection', $lang ).'<a href="/ctrapp-dev/forms/displayhelp/'.$form_field_name[0].'/'.$form_field_name[1].'?width=400" class="jTip" id="jTip_'.$form_field_name[1].'" name="'.$this->Translations->t( 'collection', $lang ).'">?</a></label>
					<table class="radio" cellspacing="0">
						<tbody>
				';
				
				/*
				$radio_display .= '
						<tr>
							<td class="button">
								<input class="radio" type="radio" name="data['.$form_field_name[0].']['.$form_field_name[1].']" value="0" '.( !$form_select_value ? 'checked="checked"' : '' ).' />
							</td>
							<td colspan="4">'.$this->Translations->t( 'no collection', $lang ).'</td>
						</tr>
				';
				*/
				
				foreach ( $radio as $id=>$collection ) {
					
					$radio_display .= '
						<tr>
							<td class="button">
								<input class="radio" type="radio" name="data['.$form_field_name[0].']['.$form_field_name[1].']" value="'.$id.'" '.( $form_select_value==$id ? 'checked="checked"' : '' ).' />
							</td>
							<td>'.$collection.'</td>
						</tr>
					';
					
				}
				
				// end TABLE 
				$radio_display .= '
						</tbody>
					</table>
				';
				
			// end COLLECTION radio 
				
			return $radio_display;
			
		} // end "associated_collection_form" function
		
		/* 
			Creates radio buttons for choosing a CONSTENT FORM 
			info comes from CONSENT table rows
			Used for LINK views 
		*/
		
		function associated_consent_form( $lang=array(), $list_of_consents=array(), $form_field_name=array( 'ClinicalCollectionLink', 'consent_id' ), $form_select_value=0 ) {
			
			// setup variables for build 
			$radio = array();
			$radio_display = '';
				
			// build PRIMARY radio button set 
				
				// go through all DX, make array of DX divided by PRIMARY NUMBER for building radio buttons 
				foreach ( $list_of_consents as $dx ) {
				
					$radio[ $dx['Consent']['id'] ] = 
						$dx['Consent']['date']
						.'</td><td>'.
						$dx['Consent']['form_version']
						.'</td><td>'.
						$this->Translations->t( $dx['Consent']['obtained'], $lang )
						.'</td><td>'.
						$dx['Consent']['date_denied']
					;
					
				}
				
				// start RADIO table, with hardcoded LABEL and HELP 
				$radio_display .= '
					<label>'.$this->Translations->t( 'consent', $lang ).'<a href="/ctrapp-dev/forms/displayhelp/'.$form_field_name[0].'/'.$form_field_name[1].'?width=400" class="jTip" id="jTip_'.$form_field_name[1].'" name="'.$this->Translations->t( 'consent', $lang ).'">?</a></label>
					<table class="radio" cellspacing="0">
						<tbody>
						<tr>
							<td class="button">
								<input class="radio" type="radio" name="data['.$form_field_name[0].']['.$form_field_name[1].']" value="0" '.( !$form_select_value ? 'checked="checked"' : '' ).' />
							</td>
							<td colspan="4">'.$this->Translations->t( 'no consent', $lang ).'</td>
						</tr>
				';
				
				foreach ( $radio as $id=>$consent ) {
					
					$radio_display .= '
						<tr>
							<td class="button">
								<input class="radio" type="radio" name="data['.$form_field_name[0].']['.$form_field_name[1].']" value="'.$id.'" '.( $form_select_value==$id ? 'checked="checked"' : '' ).' />
							</td>
							<td>'.$consent.'</td>
						</tr>
					';
					
				}
				
				// end TABLE 
				$radio_display .= '
						</tbody>
					</table>
				';
				
			// end CONSENT radio 
			
			return $radio_display;
			
		} // end "associated_consent_form" function
		
		
		/* 
			Creates radio buttons for choosing a PRIMARY NUMBER 
			info comes from DX table rows, list DXs related to each PRIMARY 
			Used for DX views 
		*/
		
		function associated_primary_form( $lang=array(), $list_of_diagnosis=array(), $form_field_name=array( 'Diagnosis', 'case_number' ), $form_select_value=0, $include_new_primary=false ) {
			
			// setup variables for build 
			$radio = array();
			$radio_display = '';
				
			// build PRIMARY radio button set 
				
				// each PRIMARY, make RADIO button and list DXs 
				$last_primary_number = 0;
				
				// go through all DX, make array of DX divided by PRIMARY NUMBER for building radio buttons 
				foreach ( $list_of_diagnosis as $dx ) {
				
					if ( !isset( $radio[$dx['Diagnosis']['case_number']] ) ) {
						$radio[ $dx['Diagnosis']['case_number'] ] = array();
					}
					
					$radio[ $dx['Diagnosis']['case_number'] ][ $dx['Diagnosis']['id'] ] = 
						$dx['Diagnosis']['dx_date']
						.'</td><td>'.
						$this->Translations->t( $dx['Diagnosis']['dx_origin'], $lang )
						.'</td><td>'.
						$this->Translations->t( $dx['Diagnosis']['dx_nature'], $lang )
						.'</td><td>'.
						$dx['Diagnosis']['icd10_id']
						.'</td><td>'.
						$this->Translations->t( $dx['Diagnosis']['dx_method'], $lang )
					;
					
					// set LAST PRIMARY, used for NEW primary 
					$last_primary_number = $dx['Diagnosis']['case_number'];
					
				}
				
				// start RADIO table, with hardcoded LABEL and HELP 
				$radio_display .= '
					<label>'.$this->Translations->t( 'case_number', $lang ).'<a href="/ctrapp-dev/forms/displayhelp/'.$form_field_name[0].'/'.$form_field_name[1].'?width=400" class="jTip" id="jTip_'.$form_field_name[1].'" name="'.$this->Translations->t( 'case_number', $lang ).'">?</a></label>
					<table class="radio" cellspacing="0">
						<tbody>
				';
				
				//foreach ( $radio as $primary=>$dx_list ) {
				for ( $i=0; $i<=$last_primary_number; $i++ ) {
				
					// radio button 
					$radio_display .= '
							<tr>
								<th class="button">
									<input class="radio" type="radio" name="data['.$form_field_name[0].']['.$form_field_name[1].']" value="'.$i.'" '.( $form_select_value==$i ? 'checked="checked"' : '' ).' />
								</th>
								<th colspan="5">
									'.$i.( $i=='0' ? ', '.$this->Translations->t( 'no primary', $lang ) : '' ).'
								</th>
							</tr>
							
					';
					
					// if DXs are set for this PRIMARY 
					if ( isset($radio[$i]) ) {
						
						// list each DX 
						foreach ( $radio[$i] as $dx_id=>$dx ) {
							
							$radio_display .= '
								<tr>
									<td class="button">
										&nbsp;
									</td>
									<td>'.$dx.'</td>
								</tr>
							';
							
						}
						
					}
				
				}
					
				// if flag set, provided NEW primary radio 
				if ( $include_new_primary ) {
					$radio_display .= '
								<tr>
									<th class="button">
										<input class="radio" type="radio" name="data['.$form_field_name[0].']['.$form_field_name[1].']" value="'.intval($last_primary_number+1).'" />
									</th>
									<th colspan="5">
										'.intval($last_primary_number+1).', '.$this->Translations->t( 'new primary', $lang ).'
									</th>
								</tr>
					';
				}
				
				// end TABLE 
				$radio_display .= '
						</tbody>
					</table>
				';
				
			// end PRIMARY radio 
			
			return $radio_display;
			
		} // end "associated_primary" function
		
		/* 
			Creates radio buttons for choosing an ASSOCIATED DX  
			info comes from DX table rows, list DXs related to each PRIMARY 
			Used for EVENT MASTER views 
		*/
		
		function associated_dx_form( $lang=array(), $list_of_diagnosis=array(), $form_field_name=array( 'EventMaster', 'diagnosis_id' ), $form_select_value=0 ) {
			
			// setup variables for build 
			$radio = array();
			$radio_display = '';
				
			// build DX radio button set 
				
				// each PRIMARY, make RADIO buttons and list DXs 
				$last_primary_number = 0;
				
				// go through all DX, make array of DX divided by PRIMARY NUMBER for building radio buttons 
				foreach ( $list_of_diagnosis as $dx ) {
				
					if ( !isset( $radio[$dx['Diagnosis']['case_number']] ) ) {
						$radio[ $dx['Diagnosis']['case_number'] ] = array();
					}
					
					$radio[ $dx['Diagnosis']['case_number'] ][ $dx['Diagnosis']['id'] ] = 
						$dx['Diagnosis']['dx_date']
						.'</td><td>'.
						$this->Translations->t( $dx['Diagnosis']['dx_origin'], $lang )
						.'</td><td>'.
						$this->Translations->t( $dx['Diagnosis']['dx_nature'], $lang )
						.'</td><td>'.
						$dx['Diagnosis']['icd10_id']
						.'</td><td>'.
						$this->Translations->t( $dx['Diagnosis']['dx_method'], $lang )
					;
					
					// set LAST PRIMARY, used for NEW primary 
					$last_primary_number = $dx['Diagnosis']['case_number'];
					
					
				}
				
				// start RADIO table, with hardcoded LABEL and HELP 
				$radio_display .= '
					<label>'.$this->Translations->t( 'diagnosis', $lang ).'<a href="/ctrapp-dev/forms/displayhelp/'.$form_field_name[0].'/'.$form_field_name[1].'?width=400" class="jTip" id="jTip_'.$form_field_name[1].'" name="'.$this->Translations->t( 'diagnosis', $lang ).'">?</a></label>
					<table class="radio" cellspacing="0">
						<tbody>
				';
				
				//foreach ( $radio as $primary=>$dx_list ) {
				for ( $i=0; $i<=$last_primary_number; $i++ ) {
				
					// radio button 
					$radio_display .= '
							<tr>
								<td clas="button">
									<input class="radio" type="radio" name="data['.$form_field_name[0].']['.$form_field_name[1].']" value="0" '.( !$form_select_value ? 'checked="checked"' : '' ).' />
								</td>
								<td colspan="5">
									'.$this->Translations->t( 'no diagnosis', $lang ).'
								</td>
							</tr>
								
								<th class="button">
									&nbsp;
								</th>
								<th colspan="5">
									'.$i.( $i=='0' ? ', '.$this->Translations->t( 'no primary', $lang ) : '' ).'
								</th>
							</tr>
							
					';
					
					// if DXs are set for this PRIMARY 
					if ( isset($radio[$i]) ) {
						
						// list each DX 
						foreach ( $radio[$i] as $dx_id=>$dx ) {
							
							$radio_display .= '
								<tr>
									<td class="button">
										<input class="radio" type="radio" name="data['.$form_field_name[0].']['.$form_field_name[1].']" value="'.$dx_id.'" '.( $form_select_value==$dx_id ? 'checked="checked"' : '' ).' />
									</td>
									<td>'.$dx.'</td>
								</tr>
							';
							
						}
						
					}
				
				}
				
				// end TABLE 
				$radio_display .= '
						</tbody>
					</table>
				';
				
			// end DX radio 
			
			return $radio_display;
			
		} // end "associated_dx" function
		
	}
		
?>
