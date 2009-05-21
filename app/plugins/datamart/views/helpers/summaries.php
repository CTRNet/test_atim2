<?php 
	
	class SummariesHelper extends Helper {
		
		var $name = 'Summaries';
		var $helpers = array( 'Html', 'Translations', 'othAuth', 'Forms' );
		
		function build( $ctrapp_summary=array(), $lang=array() ) {
			
			echo('
				<h2>
					'.$this->Html->link( $this->Translations->t( 'core_menu_main', $lang ), '/menus/', array( 'id'=>'h2_main_menu' ), NULL, false ).'
					'.$this->Html->link( $this->Translations->t( 'query tool', $lang ), '/datamart/adhocs/index/', array( 'id'=>'h2_datamart_adhocs_index' ), NULL, false ).'
				</h2>
			');
		
		/*
			// display if array not blank
			if ( !empty($ctrapp_summary) ) {
					
						$form_type = 'summary';
						$form_model = $ctrapp_summary['text']['data'];
						$form_field = $ctrapp_summary['text']['form'];
						$form_link = array();
						$form_lang = $lang;
						
					$display_summary_text = $this->Forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang, NULL, NULL, ' ' );
					
						$form_type = 'summary';
						$form_model = $ctrapp_summary['desc']['data'];
						$form_field = $ctrapp_summary['desc']['form'];
						$form_link = array();
						$form_lang = $lang;
						
					$display_summary_desc = $this->Forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang, NULL, NULL, ', ' );
					
					echo('
						<h2>
							'.$this->Html->link( $this->Translations->t( 'core_menu_main', $lang ), '/menus/', array( 'id'=>'h2_main_menu' ), NULL, false ).'
							'.$this->Html->link( $this->Translations->t( 'clinical annotation', $lang ), '/clinicalannotation/participants/index/', array( 'id'=>'h2_clinicalannotation_participants_index' ), NULL, false ).'
							<div id="h2_summary">
								'.$this->Html->link( $display_summary_text, '/clinicalannotation/participants/profile/'.$ctrapp_summary['text']['id'], NULL, NULL, false ).'
								'.$display_summary_desc.'
							</div>
						</h2>
					');
				
				echo( '<br class="clear" />' );
				
			} // END if count
		*/
		
		} // end TABS function
		
	}
	
?>
