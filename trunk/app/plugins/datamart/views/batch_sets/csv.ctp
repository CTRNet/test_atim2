<?php
	
	$form_type = 'csv';
	$form_model = $results;
	$form_field = $ctrapp_form_for_ids;
	$form_link = array();
	$form_lang = $lang;
	
	$forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang );
	
	/*
	// reset VAR names based on HELPER, make copy-paste easier
	$model = $results;
	$form = $ctrapp_form_for_ids;
	
	// Sort the data with ORDER descending, FIELD ascending 
	// Add $form['FormField'] as the last parameter, to sort by the common key 
	foreach ( $form['FormField'] as $key=>$row ) {
		$sort_order_0[$key] = $row['model'];
		$sort_order_1[$key] = $row['display_column'];
		$sort_order_2[$key] = $row['display_order'];
		// $sort_field[$key]  = $row['field'];
	}
	
	// multisort, PHP array 
	array_multisort( $sort_order_0, SORT_ASC, $sort_order_1, SORT_ASC, $sort_order_2, SORT_ASC, $form['FormField'] );
	
	// list of MODELS for this form, comma delimited 
	// make into an ARRAY of model names, exploded by COMMA 
	// when building forms, any FIELD whose model name is in this array uses the "FLAG_" flag settings 
	// any field whose model name is NOT in this array uses the "FLAG_FOREIGN_" flag settings 
	$form['Form']['model'] = str_replace(' ','',$form['Form']['model']);
	$form['Form']['model'] = explode(',', $form['Form']['model']);
	
				// prepare array for list of FIELDS allowed in INDEX 
				$display_model_fields = array();
				$id_count=0; // number of ID cells, for colspan 
				
				// attach domestic models to ID fields
				foreach ( $form['Form']['model'] as $model_with_id ) {
					// only if MODEL IDs exist 
					if ( isset( $model[0][$model_with_id] ) ) {
						// $display_model_fields[] = array('model'=>$model_with_id, 'field'=>'id');
						$id_count++;
					}
				}
				
				$echo_array = array();
				
				// for each field listed in array...
				foreach ( $form['FormField'] as $field ) {
					
					// if MODEL in form MODEL, use FLAG, else use FOREIGH FLAG 
					$foreign = '';
					if ( !in_array( $field['model'], $form['Form']['model'] ) ) {
						$foreign = 'foreign_';
					}
					
							// format SETTINGS array 
							
								$temp_array = array();
								$field['setting'] = trim($field['setting']);
									
								if ( $field['setting'] ) {	
									
									// parse through FORM_FIELDS setting value, and add to helper array 
									$field['setting'] = explode( ',', $field['setting'] );
									foreach ( $field['setting'] as $setting ) {
									
										$setting = explode('=', $setting);
										$temp_array[ $setting[0] ] = $setting[1];
									
									}
									
								}
								
							// add allow field to array, to check against when displaying individual rows...
							$display_model_fields[] = array( 
								'language_tag' => $field['language_tag'],
								'model' => $field['model'],
								'field' => $field['field'],
								'type' => $field['type'],
								'setting' => $temp_array,
								'GlobalLookup' => $field['GlobalLookup']
							);
					
						// label and help/info marker, if available...
						if ( $field['language_label'] ) {
							$echo_array[] = $translations->t( $field['language_label'], $lang );
						}
					
				}
				
				echo implode(',',$echo_array)."\r";
				
				foreach ( $model as $model_row ) {
					
					$echo_array = array();
					
					// move associated MODELs up so HELPER can access them...
					foreach ( $model_row as $model_fields ) {
						$forms->pull_one_to_one_models_up( $model_row, $model_fields );
					}
					
					foreach ( $display_model_fields as $cell ) {
					
							// start BLANK display value
							$display_cell_value = '';
							
							// display TAG, sub label 
							$display_tag = '';
							if ( $cell['language_tag'] ) {
								$display_tag = $translations->t( $cell['language_tag'], $lang ).':';
							}
							
							if ( isset( $model_row[ $cell['model'] ] ) ) {
								if ( isset( $model_row[ $cell['model'] ][ $cell['field'] ] ) ) {
									$display_cell_value = $display_tag.$model_row[ $cell['model'] ][ $cell['field'] ];
								}
							}
							
							// swap out VALUE for OVERRIDE choice for SELECTS, NO TRANSLATION 
							if ( isset( $override[ $cell['model'].'/'.$cell['field'] ] ) ) {
								
								foreach ( $override[ $cell['model'].'/'.$cell['field'] ] as $key=>$value ) {
									
									if ( $key == $display_cell_value ) {
									 	$display_cell_value = $value;
									}
									
								}
								
							// swap out VALUE for LANG LOOKUP choice for SELECTS 
							} else if ( isset($cell['GlobalLookup']) ) {
								
								foreach ( $cell['GlobalLookup'] as $lookup ) {
									
									if ( $lookup['value'] == $display_cell_value && $lookup['language_choice'] ) {
									 	$display_cell_value = $translations->t( $lookup['language_choice'], $lang, 1 );
									}
									
								}
								
							}
							
							// span tag if value BLANK 
								$display_value_trim = isset($cell['setting']['trim']) ? $cell['setting']['trim'] : 40;
								$display_cell_value = strlen( $display_cell_value )>$display_value_trim ? substr( $display_cell_value, 0, $display_value_trim ).'...' : $display_cell_value;
							
							// format date values a bit...
								if ( $display_cell_value=='0000-00-00' || $display_cell_value=='0000-00-00 00:00:00' || $display_cell_value=='' ) {
									
									// set ZERO date fields to blank
									$display_cell_value = '';
									
								} else if ( $cell['type']=='date' ) {
									
									// get PHP's month name array
									$cal_info = cal_info(0);
									
									// format date STRING manually, using PHP's month name array, becuase of UnixTimeStamp's 1970 - 2038 limitation
									$calc_date_string = explode( ' ', $display_cell_value );
									$calc_date_string = explode( '-', $calc_date_string[0] );
									
										// format month INTEGER into an abbreviated month name, lowercase, to use for translation alias
										$calc_date_string_month = intval($calc_date_string[1]);
										$calc_date_string_month = $cal_info['abbrevmonths'][ $calc_date_string_month ];
										$calc_date_string_month = strtolower( $calc_date_string_month );
									
									$display_cell_value = $translations->t( $calc_date_string_month, $lang, 1 ).' '.$calc_date_string[2].' '.$calc_date_string[0]; // date array to nice string, with month translated
									
								}
							
							// display cell OR set EMPTY classes for td and span 
							$echo_array[] = '"'.$display_cell_value.'"';
						
					} // end FOREACH $display_model_fields AS $cell
					
					echo implode(',',$echo_array)."\r";
					
				} // end FOREACH $model
				
				
	
	// pr($form);
	*/
	
?>