<?php 
		
	// display adhoc DETAIL
	
		$structures->build( $atim_structure_for_detail, array('type'=>'detail', 'settings'=>array('actions'=>false), 'data'=>$data_for_detail) );
	
	// display adhoc RESULTS form
		
		$structure_links = array(
			'top'=>'/datamart/adhocs/process',
			'checklist' => array(
				$data_for_detail['Adhoc']['model'].'.id]['=>'%%'.$data_for_detail['Adhoc']['model'].'.id'.'%%'
			)
		);
		
		// append LINKS from DATATABLE, if any...
		if ( count($ctrapp_form_links) ) {
			$structure_links['index'] = $ctrapp_form_links;
		}
		
		$structures->build( $atim_structure_for_results, array('type'=>'checklist', 'data'=>$results, 'settings'=>array('form_bottom'=>false, 'form_inputs'=>false, 'actions'=>false, 'pagination'=>false), 'links'=>$structure_links) );
	
	// display adhoc-to-batchset ADD form
	
		// include SAVE button
		if ( $atim_menu_variables['Param.Type_Of_List']!='saved' && $save_this_search_data ) {
			$structure_links = array(
				'top'=>'#',
				'bottom'=>array(
					'add as saved search'=>'/datamart/adhoc_saved/add/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'],
					'search'=>'/datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']
				)
			);
		}
		
		else {
			$structure_links = array(
				'top'=>'#',
				'bottom'=>array(
					'search'=>'/datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']
				)
			);
		}
		
		$structure_override = array(
			'Adhoc.id' => $atim_menu_variables['Adhoc.id'],
			'Adhoc.sql_query_for_results' => $final_query,
			'Adhoc.process' => $batch_sets
		);
		
		$structures->build( $atim_structure_for_add, array('type'=>'add', 'settings'=>array('form_top'=>false), 'links'=>$structure_links, 'override'=>$structure_override, 'data'=>array()) );
		
	/*
		// display DETAIL FORM, of adhoc query
		
			$form_type = 'detail';
			$form_model = isset( $this->params['adhoc'] ) ? array( $this->params['adhoc'] ) : array( $adhoc );
			$form_field = $ctrapp_form_for_query;
			$form_link = array();
			$form_lang = $lang;
			
			$forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang );
			
		// display EDIT FORM, or adhoc query RESULTS
	*/
		
	/*
		echo '
			<form action="'.$html->url( '/datamart/batch_sets/add/' ).'" method="post">
				
				<fieldset class="form">
			
						<table class="edit" cellspacing="0">
						<tbody>
					
							<tr>
								<td class="label">
									'.$translations->t( 'search results', $lang, 1 ).'
									
									<p style="font-weight: normal;">
										<a href="#" onclick="checkAll(\'searchResults\'); return false;">Check</a>/<a href="#" onclick="uncheckAll(\'searchResults\'); return false;">Uncheck</a>
									</p>
									
								</td>
								<td id="searchResults" class="content">
		';						
		
			$form_type = 'checklist'; // first value is TYPE, all other values are FORM SETTINGS, if any
			$form_model = $results;
			$form_field = $ctrapp_form;
			$form_link = $ctrapp_form_links;
			$form_lang = $lang;
			// $form_pagination = $paging;
			
			$forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang );
		
		echo '						
								</td>
								<td class="help">
									<span class="error help">?</span>
								</td>
							</tr>
						
							<tr>
								<td class="label">
									'.$translations->t( 'compatible datamart batches', $lang, 1 ).'
									
								</td>
								<td class="content">
		';
			
			// make SELECT OPTIONS array for select tag 
			$batch_select = array();
			$batch_select[0] = $translations->t( 'new batch set', $lang, 1 );
			foreach ( $batch_sets as $set ) {
				$batch_select[ $set['BatchSet']['id'] ] = strlen( $set['BatchSet']['description'] )>60 ? substr( $set['BatchSet']['description'], 0, 60 ).'...' : $set['BatchSet']['description'];
			}
			
			echo $html->selectTag( 'BatchSet/id', $batch_select, NULL, NULL, NULL, false );
			
		echo '
								</td>
								<td class="help">
									<span class="error help">?</span>
								</td>
							</tr>

						
						</tbody>
						</table>
					
				</fieldset>	
				
				<fieldset class="hidden">
					<input type="hidden" class="hidden" name="data[Adhoc][id]" value="'.$adhoc['Adhoc']['id'].'" />
					<input type="hidden" class="hidden" name="data[BatchSet][model]" value="'.$adhoc['Adhoc']['model'].'" />
					<input type="hidden" class="hidden" name="data[BatchSet][form_alias_for_results]" value="'.$adhoc['Adhoc']['form_alias_for_results'].'" />
					<input type="hidden" class="hidden" name="data[BatchSet][sql_query_for_results]" value="'.$final_query.'" />
					<input type="hidden" class="hidden" name="data[BatchSet][form_links_for_results]" value="'.$adhoc['Adhoc']['form_links_for_results'].'" />
					<input type="hidden" class="hidden" name="data[BatchSet][flag_use_query_results]" value="'.$adhoc['Adhoc']['flag_use_query_results'].'" />
				</fieldset>
				
				<fieldset class="button">
					<input type="submit" class="submit" value="Submit" />
				</fieldset>
				
			</form>
			
				<div class="action_bar">
					<h5>Actions</h5>
					<ul>
						<li>
						<a href="'.$html->url( '/datamart/adhocs/index/'.$type_of_list.'/' ).'"  class="form list"><span class="icon"></span>'.$translations->t('list', $lang).'</a>
						</li>
				
		';	
		
		if ( $type_of_list!='saved' && $save_this_search_data ) {
			echo '
						<li>
						<a href="'.$html->url( '/datamart/adhoc_saved/add/'.$adhoc['Adhoc']['id'] ).'"  class="form add"><span class="icon"></span>'.$translations->t('add as saved search', $lang).'</a>
						</li>
			';
		}

		echo '
					</ul>
				</div>
				<br class="clear" />
		';
		
		// pr($results);
	*/
?>