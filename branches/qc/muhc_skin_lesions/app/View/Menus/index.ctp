<?php
$atimContent = array(
    'menu' => ''
);

if (count($menuData)) {
    
    $atimContent['menu'] .= '
				<ul id="big_menu_main" class="big_menu">
		';
    
    $count = 0;
    $class = null;
    foreach ($menuData as $menu) {
        
        $title = __($menu['Menu']['language_title']);
        
        if (! $menu['Menu']['language_description']) {
            $menu['Menu']['language_description'] = $menu['Menu']['language_title'];
        }
        
        if (! $menu['Menu']['allowed']) {
            $class = 'icon32 not_allowed';
        } else {
            $class = 'icon32 ' . $this->Structures->generateLinkClass('plugin ' . $menu['Menu']['use_link']);
        }
        
        $atimContent['menu'] .= '
				<!-- ' . $menu['Menu']['id'] . ' -->
				<li class="' . ($menu['Menu']['at'] ? 'at ' : '') . 'count_' . $count . '">' . $this->Html->link('<div class="row"><span class="cell"><span class="' . $class . '"></span></span><span class="menuLabel cell">' . __($menu['Menu']['language_title']) . '<span class="menuDesc">' . __($menu['Menu']['language_description']) . '</span></span></div>', $menu['Menu']['use_link'], array(
            'title' => $title,
            'escape' => false
        )) . '
				</li>
			';
        
        $count ++;
    }
    
    $atimContent['menu'] .= '
			</ul>
		';
}

$dueMsgCond = isset($dueMessagesCount) && $dueMessagesCount > 0 && AppController::checkLinkPermission('/ClinicalAnnotation/ParticipantMessages/search/');
$collCond = isset($unlinkedPartColl) && $unlinkedPartColl > 0 && AppController::checkLinkPermission('/InventoryManagement/Collections/search/');
$completeForgottenPasswordAnswers = isset($missingForgottenPasswordResetAnswers) && $missingForgottenPasswordResetAnswers && AppController::checkLinkPermission('/Customize/Profiles/index/');
$dueAnnoucementsCond = isset($dueAnnoucementsCount) && $dueAnnoucementsCount > 0 && AppController::checkLinkPermission('/Customize/UserAnnouncements/index/');

if ($dueMsgCond || $collCond || $completeForgottenPasswordAnswers || $dueAnnoucementsCond) {
    $atimContent['messages'] = '';
    if ($dueMsgCond) {
        $atimContent['messages'] = '<ul class="warning"><li><span class="icon16 warning mr5px"></span>' . __('not done participant messages having reached their due date') . ': ' . $dueMessagesCount . '.
				<a id="goToNotDue" href="javascript:goToNotDoneDueMessages()">' . __('click here to see them') . '</a>.
				</li></ul>
				<form action="' . $this->request->webroot . 'ClinicalAnnotation/ParticipantMessages/search/' . AppController::getNewSearchId() . '" method="POST" id="doneDueMessages">
					<input type="hidden" name="data[ParticipantMessage][done]" value="0">
					<input type="hidden" name="data[ParticipantMessage][due_date_end]" value="' . now() . '">
				</form>
			';
    }
    if ($collCond) {
        $forBankPart = isset($bankFilter) ? __('for your bank') : __('for all banks');
        $atimContent['messages'] .= '<ul class="warning"><li><span class="icon16 warning mr5px"></span>' . __('unlinked participant collections') . ' (' . $forBankPart . '): ' . $unlinkedPartColl . '.
				 <a id="goToUnlinkedColl" href="' . $this->request->webroot . 'InventoryManagement/Collections/search/' . AppController::getNewSearchId() . '/unlinkedParticipants:/ ">' . __('click here to see them') . '</a>.
				</li></ul>
			';
    }
    if ($completeForgottenPasswordAnswers) {
        $atimContent['messages'] .= '<ul class="warning"><li><span class="icon16 warning mr5px"></span>' . __('user questions to reset forgotten password are not completed - update your profile with the customize tool') . '
				 <a id="goToNotDue" href="' . $this->request->webroot . 'Customize/Profiles/index/">' . __('click here to update') . '</a>.
				</li></ul>
			';
    }
    if ($dueAnnoucementsCond) {
        $atimContent['messages'] .= '<ul class="warning"><li><span class="icon16 warning mr5px"></span>' . __('you have %s due annoucements', $dueAnnoucementsCount) . '
				 <a id="goToNotDue" href="' . $this->request->webroot . 'Customize/UserAnnouncements/index/">' . __('click here to see them') . '</a>.
				</li></ul>
			';
    }
}

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

if (isset($setOfMenus)) {
    echo $this->Structures->generateContentWrapper($atimContent, array(
        'links' => array(
            'bottom' => array(
                'back to main menu' => '/Menus'
            )
        )
    ));
} else {
    echo $this->Structures->generateContentWrapper($atimContent);
}
?>
<script>
function goToNotDoneDueMessages(){
	$("#doneDueMessages").submit();
}
</script>