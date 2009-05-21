<?php 
	$sidebars->header( $lang );
	$sidebars->cols( $ctrapp_sidebar, $lang );
	$summaries->build( $ctrapp_summary, $lang ); 
	$menus->tabs( $ctrapp_menu, $lang ); 
?>

	<?php 
		
			$form_type = 'detail';
			$form_model = isset( $this->params['data'] ) ? array( $this->params['data'] ) : array( $batch_set );
			$form_field = $ctrapp_form_for_set;
			$form_link = array();
			$form_lang = $lang;
			
			$forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang ); 
			
			echo '
				<form action="'.$html->url( '/datamart/batch_sets/process/'.$batch_set_id ).'" method="post">
					
					<fieldset class="form">
				
							<table class="edit" cellspacing="0">
							<tbody>
								
								<tr>
									<th colspan="3">&nbsp;</th>
								</tr>
								
								<tr>
									<td class="label">
										'.$translations->t( 'batch set', $lang, 1 ).'
										
										<p style="font-weight: normal;">
											<a href="#" onclick="checkAll(\'batchSetIds\'); return false;">Check</a>/<a href="#" onclick="uncheckAll(\'batchSetIds\'); return false;">Uncheck</a>
										</p>
									</td>
									<td id="batchSetIds" class="content">
			';						
			
				$form_type = array( 'checklist' ); // first value is TYPE, all other values are FORM SETTINGS, if any
				$form_model = $results;
				$form_field = $ctrapp_form_for_ids;
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
										'.$translations->t( 'process batch set', $lang, 1 ).'
									</td>
									<td class="content">
			';
				
				// make SELECT OPTIONS array for select tag 
					$batch_select = array();
				
					// batch processes from datatable, based on set's model
					foreach ( $batch_set_processes as $process ) {
						if ( $process['BatchSetProcess']['url'] && $process['BatchSetProcess']['name'] ) {
							$batch_select[ $process['BatchSetProcess']['url'] ] = $process['BatchSetProcess']['name'];
						}
					}
					
					// standard processes, for ALL sets
					$batch_select[ '/datamart/batch_sets/csv/' ] = 'Export as CSV file';
					if ( $belong_to_this_user ) {
						$batch_select[ '/datamart/batch_sets/remove/' ] = 'Remove from batch';
					}
				
				echo $html->selectTag( 'BatchSet/process', $batch_select, NULL, NULL, NULL, false );
				
			echo '
									</td>
									<td class="help">
										<span class="error help">?</span>
									</td>
								</tr>
					
								<tr>
									<td class="button" colspan="3">
										<input type="submit" class="submit" value="Submit" onclick="processSelect=getElementById(\'BatchSetProcess\');processSelectValue=processSelect.options[processSelect.selectedIndex].value;if(processSelectValue.indexOf(\'csv\')!=-1){return confirm(\''.addslashes($translations->t( 'export csv confirmation message', $lang, 1 )).'\')};" />
									</td>
								</tr>
								
								<tr>
									<th colspan="3">&nbsp;</th>
								</tr>
							
							</tbody>
							</table>
						
					</fieldset>	
					
					<fieldset class="hidden">
						<input type="hidden" class="hidden" name="data[BatchSet][id]" value="'.$batch_set['BatchSet']['id'].'" />
						<input type="hidden" class="hidden" name="data[BatchSet][model]" value="'.$batch_set['BatchSet']['model'].'" />
					</fieldset>
					
				</form>
			';
			
			// manually build ACTION BAR
			
			if ( $belong_to_this_user ) {
				$action_bar_links = array(
					'edit'		=>	'/datamart/batch_sets/edit/'.$batch_set_id,
					'delete'		=>	'/datamart/batch_sets/delete/'.$batch_set_id,
					'list'		=>	'/datamart/batch_sets/index/'.$group
				);
			} else {
				$action_bar_links = array(
					'list'		=>	'/datamart/batch_sets/index/'.$group
				);
			}
			
			echo $forms->generate_links_list( array(), $action_bar_links, $lang );
			
	?>

<?php echo $sidebars->footer($lang); ?>
