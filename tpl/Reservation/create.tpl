{block name="header"}
    {include file='globalheader.tpl' cssFiles='css/schedule.css' printCssFiles='css/reservation.print.css'}
{/block}

{function name="displayResource"}
    <div class="resourceName rounded-1 m-1 p-1 {if !$resource->GetColor()}text-success bg-success bg-opacity-10" {else}"
    style="background-color:{$resource->GetColor()};color:{$resource->GetTextColor()}" {/if}>
    <span class="resourceDetails" data-resourceId="{$resource->GetId()}">{$resource->Name}</span>
    {if $resource->GetRequiresApproval()}<span class="bi bi-lock-fill" data-bs-toggle="tooltip"
        data-bs-title="approval"></span>{/if}
    {if $resource->IsCheckInEnabled()}<i class="bi bi-box-arrow-in-right" data-bs-toggle="tooltip"
        data-bs-title="checkin"></i>{/if}
    {if $resource->IsAutoReleased()}<i class="bi bi-clock-history" data-bs-toggle="tooltip" data-bs-title="autorelease"
        data-autorelease="{$resource->GetAutoReleaseMinutes()}"></i>{/if}
</div>
{/function}

<div id="page-reservation">
    <div id="reservation-box" class="mx-3">
        <form id="form-reservation" method="post" enctype="multipart/form-data" role="form">

            <div class="d-flex align-items-center justify-content-between border-bottom my-3 py-2">
                <div class="reservationHeader">
                    <h3 class="mb-0">{block name=reservationHeader}{translate key="CreateReservationHeading"}{/block}
                    </h3>
                    {if !empty($ReferenceNumber)}
                        <div class="form-group">
                            <label class="fw-bold">{translate key=ReferenceNumber}</label>
                            {$ReferenceNumber}
                        </div>
                    {/if}
                </div>
                {* <div class="float-end buttonsEdit">
                    <button type="button" class="btn btn-sm btn-outline-secondary"
                        onclick="window.location='{$ReturnUrl}'">
                        <i class="bi bi-arrow-left-circle-fill"></i>
                        <span>{translate key='Cancel'}</span>
                    </button>
                    {block name="submitButtons"}
                    <button type="button" class="btn btn-sm btn-primary save create btnCreate">
                        <i class="bi bi-check-circle"></i>
                        {translate key='Create'}
                    </button>
                    {/block}
                </div> *}
            </div>

            <div class="row gx-2">
                <div class="reservationTitle col-12 border-bottom py-2">
                    <div class="form-group">
                        <label class="fw-bold mb-0" for="reservationTitle">{translate key="ReservationTitle"}
                            {if $TitleRequired}
                            <i class="bi bi-asterisk text-danger align-top text-small"></i>
                            {/if}
                        </label>
                        {textbox name="RESERVATION_TITLE" class="form-control has-feedback" value="ReservationTitle" id="reservationTitle" maxlength="300" required=$TitleRequired}
                    </div>
                </div>
                {assign var="detailsCol" value="col-12"}

                {if $ShowParticipation && $AllowParticipation && $ShowReservationDetails}
                {assign var="detailsCol" value="col-12 col-sm-6"}
                {/if}

                <div class="form-group {$detailsCol} py-2 border-bottom">

                    {if {$UserName} neq 'Guest'}  
                        <label class="fw-bold" for="userName">{translate key='Owner'}</label>

                        {if $ShowUserDetails && $ShowReservationDetails}
                            <a href="#" id="userName" data-userid="{$UserId}" class="link-primary">{$ReservationUserName}</a>
                            {* {$title|escape:'html'} *}
                        {else}
                            {translate key=Private}
                            {* {$title|escape:'html'} *}
                        {/if}
                    {/if}
                        <input id="userId" type="hidden" {formname key=USER_ID} value="{$UserId}" />
                    
                    
                    {if $CanChangeUser}
                    <a href="#" id="showChangeUsers" class="link-primary">{translate key=Change} <i
                            class="bi bi-person-fill"></i></a>  
                    <div class="modal fade" id="changeUserDialog" tabindex="-1" role="dialog"
                        aria-labelledby="usersModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-scrollable">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="usersModalLabel">{translate key=ChangeUser}
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-hidden="true"></button>
                                </div>
                                <div class="modal-body">
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-secondary"
                                        data-bs-dismiss="modal">{translate key='Cancel'}</button>
                                    <button type="button" class="btn btn-primary">{translate key='Done'}</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if}
                    <div id="availableCredits" {if !$CreditsEnabled}class="d-none" {/if}>
                        {translate key=AvailableCredits}
                        <span id="availableCreditsCount" class="fw-bold">{$CurrentUserCredits}</span> |
                        {translate key=CreditsRequired}
                        <span id="requiredCreditsCount">
                            <span class="spinner-border spinner-border-sm" role="status"></span></span>
                        <span id="creditCost" class="fw-bold"></span>
                    </div>


                    <div class="mb-4" id="changeUsers" style="display: none;">
                        <div class="form-group d-flex align-items-center gap-1">
                            <label for="changeUserAutocomplete" class="visually-hidden">{translate key=User}</label>
                            <input type="text" id="changeUserAutocomplete"
                                class="form-control form-control-sm user-search" />
                            <span class="vr m-2"></span>
                            <a href="#" id="promptForChangeUsers" class="link-primary">
                                <i class="bi bi-people-fill"></i>
                                {translate key='AllUsers'}
                            </a>
                        </div>
                    </div>
                </div>

                <div class="form-group {$detailsCol} py-2 border-bottom">
                    {if $ShowParticipation && $AllowParticipation && $ShowReservationDetails}
                    {include file="Reservation/participation.tpl"}
                    {else}
                    {include file="Reservation/private-participation.tpl"}
                    {/if}
                </div>


                <div class="reservationDates col-12 py-2 border-bottom">
                    <div class="d-flex flex-wrap">
                        <div class="form-group d-flex align-items-center me-2">
                            <label for="BeginDate" class="reservationDate fw-bold">{translate key='BeginDate'}</label>
                            <input type="text" id="BeginDate"
                                class="form-control form-control-sm d-inline-block w-auto{if $LockPeriods} no-show{/if}"
                                {formname key=BEGIN_DATE} />
                            <select id="BeginPeriod" {formname key=BEGIN_PERIOD}
                                class="form-select form-select-sm w-auto timeinput{if $LockPeriods} no-show{/if}"
                                title="Begin time">
                                {foreach from=$StartPeriods item=period}
                                {if $period->IsReservable()}
                                {assign var='selected' value=''}
                                {if $period eq $SelectedStart}
                                {assign var='selected' value=' selected="selected"'}
                                {assign var='startPeriod' value=$period}
                                {/if}
                                <option value="{$period->Begin()}" {$selected}>{$period->Label()}</option>
                                {/if}
                                {/foreach}
                            </select>
                            {if $LockPeriods}{formatdate date=$StartDate} {$startPeriod->Label()}{/if}
                        </div>

                        <div class="form-group d-flex align-items-center">
                            <label for="EndDate"
                                class="reservationDate fw-bold text-md-end pe-md-1">{translate key='EndDate'}</label>
                            <input type="text" id="EndDate"
                                class="form-control form-control-sm d-inline-block w-auto{if $LockPeriods} no-show{/if}"
                                {formname key=END_DATE} />
                            <select id="EndPeriod" {formname key=END_PERIOD}
                                class="form-select form-select-sm w-auto timeinput{if $LockPeriods} no-show{/if}"
                                title="End time">
                                {foreach from=$EndPeriods item=period name=endPeriods}
                                {if $period->IsReservable()}
                                {assign var='selected' value=''}
                                {if $period eq $SelectedEnd}
                                {assign var='selected' value=' selected="selected"'}
                                {assign var='endPeriod' value=$period}
                                {/if}
                                <option value="{$period->End()}" {$selected}>{$period->LabelEnd()}</option>
                                {/if}
                                {/foreach}
                            </select>
                            {if $LockPeriods}{formatdate date=$EndDate} {$endPeriod->LabelEnd()}{/if}
                        </div>


                        <div class="reservationLength d-flex align-items-center ms-5">
                            <div class="form-group">
                                <span class="durationText fw-bold">
                                    <span id="durationDays">0</span> {translate key=days}
                                    <span id="durationHours">0</span> {translate key=hours}
                                    <span id="durationMinutes">0</span> {translate key=minutes}
                                </span>
                            </div>
                        </div>

                        {if $ShowParticipation && $AllowParticipation && $ShowReservationDetails}
                        <div class=" d-flex align-items-center ms-5">
                            <a href="#" id="btnViewAvailability" class="link-primary"><i class="bi bi-calendar3"></i>
                                {translate key="ViewAvailability"}</a>
                        </div>
                        {/if}
                    </div>

                    {if !$HideRecurrence}
                    <div class="pt-2">{$HideRecurrence}
                        {control type="RecurrenceControl" RepeatTerminationDate=$RepeatTerminationDate}
                    </div>
                    {/if}

                </div>

                {* Court modification testing *}

                <div id="courtMapModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:99999; font-family:sans-serif;">
                    <div style="background:#f4f6f9; width:95%; max-width:700px; margin:30px auto; padding:25px; border-radius:16px; text-align:center; box-shadow:0 8px 30px rgba(0,0,0,0.3); box-sizing: border-box;">
                        
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; border-bottom:2px solid #ddd; padding-bottom:10px;">
                            <h3 style="margin:0; color:#222;" id="modalHeaderTitle">📍 Choose Location</h3>
                            <button type="button" id="closeMapBtn" style="background:none; border:none; font-size:24px; cursor:pointer; color:#666;">&times;</button>
                        </div>

                        <div id="locationStepView">
                            <p style="color:#666; font-size:15px; margin-bottom:20px;">Where are you playing today?</p>
                            <div style="display:flex; flex-direction:column; gap:12px; max-width:400px; margin:0 auto 20px;">
                                
                                <button type="button" class="location-select-btn" data-location-filename="location_1" style="padding:18px; border:2px solid #ccc; background:#fff; border-radius:8px; cursor:pointer; font-weight:bold; font-size:16px; text-align:left; display:flex; justify-content:space-between; align-items:center;">
                                    🏢 Location A (Quezon City) <span>➔</span>
                                </button>
                                
                                <button type="button" class="location-select-btn" data-location-filename="location_2" style="padding:18px; border:2px solid #ccc; background:#fff; border-radius:8px; cursor:pointer; font-weight:bold; font-size:16px; text-align:left; display:flex; justify-content:space-between; align-items:center;">
                                    🏢 Location B (Makati) <span>➔</span>
                                </button>
                                
                            </div>
                        </div>

                        <div id="courtStepView" style="display:none;">
                            
                            <div id="courtLayoutsContainer">
                                
                                <div id="layout_location_1" class="layout-file-wrapper" style="display:none;">
                                    {include file='court_layouts/location_1.tpl'}
                                </div>

                                <div id="layout_location_2" class="layout-file-wrapper" style="display:none;">
                                    {include file='court_layouts/location_2.tpl'}
                                </div>

                            </div>

                            <button type="button" id="backToLocationsBtn" style="background:#6c757d; color:white; border:none; padding:12px; width:100%; margin-top:20px; border-radius:6px; cursor:pointer; font-weight:bold;">
                                ← Back to Locations
                            </button>
                        </div>

                        <div style="margin-top:25px; border-top:1px solid #ddd; padding-top:15px; text-align:right;">
                            <button type="button" id="confirmCourtSelectionBtn" style="background:#007bff; color:white; border:none; padding:12px 25px; border-radius:6px; cursor:pointer; font-weight:bold; display:none;">Apply Selection</button>
                        </div>

                    </div>
                </div>
                
                <button type="button" id="triggerCourtMapBtn" style="background:none; border:none; color:#dc3545; margin-top:12px; cursor:pointer; font-size:14px; font-weight:bold;">
                    Court selection GUI (WIP)
                </button>

                {literal}
                <script>

                const modal = document.getElementById('courtMapModal');
                const openBtn = document.getElementById('triggerCourtMapBtn');
                const closeBtn = document.getElementById('closeMapBtn');
                const backBtn = document.getElementById('backToLocationsBtn');
                const applyBtn = document.getElementById('confirmCourtSelectionBtn');

                const headerTitle = document.getElementById('modalHeaderTitle');

                const locationView = document.getElementById('locationStepView');
                const courtView = document.getElementById('courtStepView');

                const locationButtons = document.querySelectorAll('.location-select-btn');

                openBtn.addEventListener('click', function() {
                    modal.style.display = 'block';
                });
                closeBtn.addEventListener('click', function() {
                    modal.style.display = 'none';
                });

               function showLocationStep() {
                    chosenCourtId = "";
                    locationView.style.display = 'block';
                    courtView.style.display = 'none';
                    applyBtn.style.display = 'none';
                    headerTitle.innerText = "📍 Choose Location";
                    
                    // Clear active court selections across all sub-files
                    document.querySelectorAll('.dynamic-court-btn').forEach(c => {
                        c.style.borderColor = '';
                        c.style.transform = 'scale(1)';
                    });
                }

                function showCourtMapStep(filename, locationName) {
                    locationView.style.display = 'none';
                    courtView.style.display = 'block';
                    applyBtn.style.display = 'inline-block';
                    headerTitle.innerText = `🗺️ ${locationName} Layout`;

                    // Hide all layout container views first
                    document.querySelectorAll('.layout-file-wrapper').forEach(wrapper => {
                        wrapper.style.display = 'none';
                    });

                    // Target and unhide the specific chosen include layout wrapper
                    const targetLayout = document.getElementById(`layout_${filename}`);
                    if (targetLayout) {
                        targetLayout.style.display = 'block';
                    }

                }

                backBtn.addEventListener('click', showLocationStep);

                // Location processing mapping
                locationButtons.forEach(btn => {
                    btn.addEventListener('click', function() {
                        const filename = this.getAttribute('data-location-filename');
                        const locName = this.innerText.replace('➔', '').trim();
                        showCourtMapStep(filename, locName);
                    });
                });
                
                // Global listener for dynamic courts inside the sub-files
                document.addEventListener('click', function(e) {
                    const courtBtn = e.target.closest('.dynamic-court-btn');
                    if (courtBtn) {
                        // Deselect other buttons across the entire layout container
                        document.querySelectorAll('.dynamic-court-btn').forEach(c => {
                            c.style.boxShadow = 'none';
                            c.style.transform = 'scale(1)';
                        });

                        // Set highlight border states on current node target
                        courtBtn.style.boxShadow = '0 0 0 4px #0056b3';
                        courtBtn.style.transform = 'scale(1.02)';
                        chosenCourtId = courtBtn.getAttribute('data-court-id');
                    }
                });

                // Submit selection back to database hook
                if (applyBtn) {
                    applyBtn.addEventListener('click', function() {
                        if (!chosenCourtId) {
                            alert("Please click an available court canvas option first.");
                            return;
                        }
                        
                        const nativeDropdown = document.getElementById('courtSelectDropdownId');
                        if (nativeDropdown) {
                            nativeDropdown.value = chosenCourtId;
                            nativeDropdown.dispatchEvent(new Event('change'));
                        }

                        modal.style.display = 'none';
                    });
    }

                </script>
                {/literal}

                {* court modification testing ends here *}


                <div class="reservationResources col-12 col-sm-6 py-2 border-bottom" id="reservation-resources">
                    <div class="d-flex align-items-center gap-2">
                        <label class="fw-bold mb-0">{translate key="Resources"}</label>
                        {if $ShowAdditionalResources}
                        <a id="btnAddResources" href="#" class="link-primary" data-bs-toggle="modal"
                            data-bs-target="#dialogResourceGroups">{translate key=Change} <span
                                class="bi bi-plus-square-fill"></span></a>
                        {/if}
                    </div>

                    <div class="d-inline-block">
                        <div id="primaryResourceContainer">
                            <input type="hidden" id="scheduleId" {formname key=SCHEDULE_ID} value="{$ScheduleId}" />
                            <input class="resourceId" type="hidden" id="primaryResourceId" {formname key=RESOURCE_ID}
                                value="{$ResourceId}" />
                            {displayResource resource=$Resource}
                        </div>

                        <div id="additionalResources">
                            {foreach from=$AvailableResources item=resource}
                            {if is_array($AdditionalResourceIds) && in_array($resource->Id, $AdditionalResourceIds)}
                            <input class="resourceId" type="hidden" name="{FormKeys::ADDITIONAL_RESOURCES}[]"
                                value="{$resource->Id}" />
                            {displayResource resource=$resource}
                            {/if}
                            {/foreach}
                        </div>
                    </div>
                </div>

                <div class="form-group col-12 col-sm-6 py-2 border-bottom">
                    <div class="accessoriesDiv">
                        {if $ShowReservationDetails && $AvailableAccessories|default:array()|count > 0}
                        <div class="d-flex align-items-center gap-2">
                            <label class="fw-bold mb-0" for="addAccessoriesPrompt">{translate key="Accessories"}</label>
                            <a href="#" id="addAccessoriesPrompt" class="link-primary" data-bs-toggle="modal"
                                data-bs-target="#dialogAddAccessories">{translate key='Add'} <span
                                    class="bi bi-plus-square-fill"></span></a>
                        </div>
                        <div id="accessories"></div>
                        {/if}
                    </div>
                </div>

                <div class="form-group col-12 py-2 border-bottom">
                    {if $ShowParticipation && $AllowParticipation && $ShowReservationDetails}
                    {include file="Reservation/invitees.tpl"}
                    {else}
                    {include file="Reservation/private-participation.tpl"}
                    {/if}
                </div>


                {if $RemindersEnabled}
                <div class="reservationReminders border-bottom py-2">
                    <label class="fw-bold mb-0">{translate key=SendReminder}</label>
                    <div class="d-flex gap-5">
                        <div id="reminderOptionsStart" class="d-flex align-items-center flex-wrap gap-1">
                            <div class="form-check">
                                <input type="checkbox" id="startReminderEnabled"
                                    class="reminderEnabled form-check-input" {formname key=START_REMINDER_ENABLED}
                                    aria-label="Enable Start Reminder Interval" />
                            </div>
                            <label for="startReminderTime" class="visually-hidden">Start Reminder Time</label>
                            <label for="startReminderInterval" class="visually-hidden">Start Reminder Interval</label>
                            <input type="number" min="0" max="999" size="3" maxlength="3" value="15"
                                class="reminderTime form-control form-control-sm w-auto"
                                {formname key=START_REMINDER_TIME} id="startReminderTime" />
                            <select class="reminderInterval form-select form-select-sm w-auto"
                                {formname key=START_REMINDER_INTERVAL} id="startReminderInterval">
                                <option value="{ReservationReminderInterval::Minutes}">{translate key=minutes}
                                </option>
                                <option value="{ReservationReminderInterval::Hours}">{translate key=hours}</option>
                                <option value="{ReservationReminderInterval::Days}">{translate key=days}</option>
                            </select>

                            <span class="reminderLabel">{translate key=ReminderBeforeStart}</span>
                        </div>
                        <div id="reminderOptionsEnd" class="d-flex align-items-center flex-wrap gap-1">
                            <div class="form-check">
                                <input type="checkbox" id="endReminderEnabled" class="reminderEnabled form-check-input"
                                    {formname key=END_REMINDER_ENABLED} aria-label="Enable End Reminder Interval" />
                            </div>
                            <label for="endReminderTime" class="visually-hidden">End Reminder Time</label>
                            <label for="endReminderInterval" class="visually-hidden">End Reminder Interval</label>
                            <input type="number" min="0" max="999" size="3" maxlength="3" value="15"
                                class="reminderTime form-control form-control-sm w-auto"
                                {formname key=END_REMINDER_TIME} id="endReminderTime" />
                            <select class="reminderInterval form-select form-select-sm w-auto"
                                {formname key=END_REMINDER_INTERVAL} id="endReminderInterval">
                                <option value="{ReservationReminderInterval::Minutes}">{translate key=minutes}
                                </option>
                                <option value="{ReservationReminderInterval::Hours}">{translate key=hours}</option>
                                <option value="{ReservationReminderInterval::Days}">{translate key=days}</option>
                            </select>
                            <span class="reminderLabel">{translate key=ReminderBeforeEnd}</span>

                        </div>
                    </div>
                </div>
                {/if}

                <div class="reservationDescription border-bottom py-2">
                    <div class="form-group">
                        <label class="fw-bold mb-0" for="description">
                            {translate key="ReservationDescription"}{if $DescriptionRequired}<i
                                class="bi bi-asterisk text-danger align-top text-small"></i>
                            {/if}
                        </label>
                        <textarea id="description" name="{FormKeys::DESCRIPTION}" class="form-control has-feedback"
                            {if $DescriptionRequired}required="required" {/if}>{$Description}</textarea>
                    </div>

                </div>
            </div>

            {* <div id="custom-attributes-placeholder"></div> *}

            {if $UploadsEnabled}
            <div class="border-bottom py-2">
                <div class="reservationAttachments">

                    <label class="fw-bold mb-0">{translate key=AttachFile} <span
                            class="note fst-italic">({$MaxUploadSize} MB {translate key=Maximum})</span>
                    </label>

                    <div id="reservationAttachments">
                        <div class="attachment-item">
                            <label class="fw-bold" for="reservationUploadFile">Reservation Upload File</label>
                            <input type="file" {formname key=RESERVATION_FILE multi=true} id="reservationUploadFile"
                                class="form-control form-control-sm w-auto" />
                            <a class="add-attachment link-primary" href="#">{translate key=Add}<i
                                    class="bi bi-plus-square-fill ms-1"></i></a>
                            <a class="remove-attachment link-primary" href="#"><span
                                    class="visually-hidden">{translate key=Delete}</span><i
                                    class="bi bi-dash-square-fill"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            {/if}

            {if $Terms != null}
            <div class="py-2" id="termsAndConditions">
                <div class="">
                    {if $TermsAccepted}
                    <div class="">
                        <i class="bi bi-check-square-fill me-1"></i>{translate key=IAccept}
                        <a href="{$Terms->DisplayUrl()}" class="link-primary"
                            target="_blank">{translate key=TheTermsOfService}</a>
                    </div>
                    {else}
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="termsAndConditionsAcknowledgement"
                            {formname key=TOS_ACKNOWLEDGEMENT} {if $TermsAccepted}checked="checked" {/if} />
                        <label for="termsAndConditionsAcknowledgement">{translate key=IAccept}</label>
                        <a href="{$Terms->DisplayUrl()}" class="link-primary"
                            target="_blank">{translate key=TheTermsOfService}</a>
                    </div>
                    {/if}
                </div>
            </div>
            {/if}


            <input type="hidden" {formname key=RESERVATION_ID} value="{$ReservationId}" />
            <input type="hidden" {formname key=REFERENCE_NUMBER} value="{$ReferenceNumber}" id="referenceNumber" />
            <input type="hidden" {formname key=RESERVATION_ACTION} value="{$ReservationAction}" />
            <input type="hidden" {formname key=DELETE_REASON} value="" id="hdnDeleteReason" />

            <input type="hidden" {formname key=SERIES_UPDATE_SCOPE} id="hdnSeriesUpdateScope"
                value="{SeriesUpdateScope::FullSeries}" />

            <div class="">
                <div class="reservationButtons clearfix">
                    <div class="float-sm-end">
                        <button type="button" class="btn btn-sm btn-outline-secondary"
                            onclick="window.location='{$ReturnUrl}'">
                            <i class="bi bi-arrow-left-circle-fill"></i>
                            <span class="d-none d-sm-inline-block">{translate key='Cancel'}</span>
                        </button>
                        {block name="submitButtons"}
                        <button type="button" id="preBookBtn" class="btn btn-primary">Proceed to Payment</button>
                        
                        {* <button type="button" class="btn btn-sm btn-primary save create btnCreate">
                            <i class="bi bi-check-circle"></i>
                            {translate key='Create'} </button> *}
                        {/block}
                    </div>
                </div>
            </div>

            {* Gcash payment modal *}
            <div id="paymentModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:99999; font-family: sans-serif;">
                <div style="background:white; width:90%; max-width:420px; margin:50px auto; padding:25px; border-radius:12px; text-align:center; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
                    
                    <h3 style="margin-top:0; color:#333;">Finalize Your Booking</h3>
                    
                    <input type="hidden" id="selectedPaymentMethod" name="payment_method" value="">

                    <div id="methodSelectionView" class="card-body align-items-center justify-content-center flex-column gap-3">
                        <button type="button" id="payBtnCash" class="btn pay-method-btn">
                            💵 Cash Payment <span>➔</span>
                        </button>
                        
                        <button type="button" id="payBtnGcash" class="btn pay-method-btn">
                            🔵 GCash QR <span>➔</span>
                        </button>
                        
                        <button type="button" id="payBtnQrph" class="btn pay-method-btn">
                            🔴 QRPH <span>➔</span>
                        </button>
                    </div>

                    <div id="qrDisplayView" class="card-body align-items-center justify-content-center flex-column gap-3">
                        <p id="qrInstructions" style="color:#555; font-size:14px;"></p>
                        
                        <img id="modalQRImage" src="" alt="Payment QR" style="width:100%; max-width:220px; margin:10px auto; display:block; border: 1px solid #ddd; padding: 5px; border-radius: 5px;">
                        
                        <div style="margin-top:15px; text-align:left;">
                            <label style="font-size:14px; color:#333;"><strong id="refLabel">Reference Number:</strong></label>
                            <input type="text" id="gcashRef" name="gcash_reference" placeholder="Enter reference number" style="width:100%; padding:10px; margin-top:5px; border:1px solid #ccc; border-radius:5px; box-sizing: border-box;">
                            <small class="help-block" data-bv-result="VALID" style="display: none;">A valid Reference Number is required to complete the payment.</small>
                        </div>
                        
                        {* <button type="button" onclick="goBackToMethods()" style="background:#6c757d; color:white; border:none; padding:10px; width:100%; margin-top:15px; border-radius:5px; cursor:pointer; font-weight:bold;">
                            ← Change Payment Method
                        </button> *}
                    </div>

                    <div class="card-body align-items-center justify-content-center flex-column gap-3">
                        <button type="button" id="finalConfirmBtn" class="btn btn-sm btn-primary save create btnCreate" style="background:#28a745; color:white; border:none; padding:15px; width:100%; border-radius:5px; cursor:pointer; font-weight:bold; font-size:16px;">
                            Confirm & Submit Booking
                        </button>
                        <button type="button" id="backToMethodsBtn" style="background:#6c757d; color:white; border:none; padding:10px; width:100%; margin-top:15px; border-radius:5px; cursor:pointer; font-weight:bold;">
                            ← Change Payment Method
                        </button>
                    </div>
                    

                    <button type="button" id="closePaymentModalBtn" style="background:none; border:none; color:#dc3545; margin-top:12px; cursor:pointer; font-size:14px; font-weight:bold;">
                        Cancel Payment
                    </button>
                    

                </div>
            </div>

            <script>

                let activeMethod = '';

                const qrImages = {
                    'gcash': '/img/your-gcash-qr.png',
                    'qrph': '/img/your-gcash-qr.png'
                };

                // 2. DOM Elements Cache
                const modal2 = document.getElementById('paymentModal');
                const preBookBtn = document.getElementById('preBookBtn');
                const backToMethodsBtn = document.getElementById('backToMethodsBtn');
                const finalConfirmBtn = document.getElementById('finalConfirmBtn');
                const closePaymentModalBtn = document.getElementById('closePaymentModalBtn');

                const selectionView = document.getElementById('methodSelectionView');
                const qrView = document.getElementById('qrDisplayView');
                
                const selectedMethodInput = document.getElementById('selectedPaymentMethod');
                const gcashRefInput = document.getElementById('gcashRef');
                const helpBlockElement = document.querySelector('.help-block');
                const qrImageElement = document.getElementById('modalQRImage');
                const qrInstructions = document.getElementById('qrInstructions');
                const refLabel = document.getElementById('refLabel');
                
                const methodButtons = document.querySelectorAll('.pay-method-btn');
                
                resetModalState(); // Initialize modal state on page load

                // 3. Helper Functions
                function resetModalState() {
                    activeMethod = '';
                    if (selectedMethodInput) selectedMethodInput.value = '';
                    if (gcashRefInput) gcashRefInput.value = '';
                    
                    qrView.style.display = 'none';
                    selectionView.style.display = 'block';

                    // hide confirm and back buttons until a method is selected
                    finalConfirmBtn.style.display = 'none';
                    backToMethodsBtn.style.display = 'none';
                    
                    methodButtons.forEach(btn => {
                        // btn.style.borderColor = '#ccc';
                        // btn.style.background = '#fff';
                        // btn.style.color = '#333';
                    });
                }

                function selectPaymentMode(method, targetButton) {
                    activeMethod = method;
                    if (selectedMethodInput) selectedMethodInput.value = method;
                    
                    // Reset button borders
                    // methodButtons.forEach(btn => {
                    //     btn.style.borderColor = '#ccc';
                    //     btn.style.background = '#fff';
                    //     btn.style.color = '#333';
                    // });

                    if (method === 'cash') {
                        // Apply highlight directly to the passed element node
                        // targetButton.style.borderColor = '#28a745';
                        // targetButton.style.background = '#e8f5e9';
                        // targetButton.style.color = '#1b5e20';
                        qrView.style.display = 'none';
                        
                        // show confirm button immediately for cash since no QR is needed
                        finalConfirmBtn.style.display = 'block';
                        backToMethodsBtn.style.display = 'none';    
                    }else {
                        // Update QR view elements
                        qrImageElement.src = qrImages[method] || '';
                        
                        // Switch views
                        selectionView.style.display = 'none';
                        qrView.style.display = 'block';
                        
                        // show back button in QR view
                        backToMethodsBtn.style.display = 'block';
                        finalConfirmBtn.style.display = 'none';
                        // finalConfirmBtn.style.display = 'block';
                    }
                }

                document.getElementById('payBtnCash').addEventListener('click', function() {
                    selectPaymentMode('cash', this);
                });
      
                document.getElementById('payBtnGcash').addEventListener('click', function() {
                    selectPaymentMode('gcash', this);
                });

                document.getElementById('payBtnQrph').addEventListener('click', function() {
                    selectPaymentMode('qrph', this);
                }); 

                // Show/hide help-block based on gcashRef input length
                gcashRefInput.addEventListener('input', function() {
                    if (this.value.trim().length < 10) {
                        helpBlockElement.style.display = 'block';
                        finalConfirmBtn.style.display = 'none';
                    } else {
                        helpBlockElement.style.display = 'none';
                        finalConfirmBtn.style.display = 'block';
                    }
                });
                
                backToMethodsBtn.addEventListener('click', resetModalState);
                
                preBookBtn.onclick = function() {
                    // Show the payment modal
                    modal2.style.display = 'block';
                };


                closePaymentModalBtn.addEventListener('click', function() {
                    // Cancel the payment modal
                    modal2.style.display = 'none';
                    resetModalState();
                    // Optionally, you can also trigger the cancel action for the entire booking here
                    // window.location='{$ReturnUrl}';
                });


                finalConfirmBtn.onclick = function() {
                    if (!activeMethod) {
                        alert("Please select a payment method first.");
                        return;
                    }
                    if ((activeMethod === 'gcash' || activeMethod === 'qrph') && gcashRefInput.value.trim().length < 10) {
                        alert("Please enter a valid reference number for GCash/QRPH.");
                        return;
                    }

                    const paymentData = {
                        method: activeMethod,
                        reference: gcashRefInput.value
                    };

                    console.log("Submitting booking with payment data:", paymentData);
                    
                    // Close the modal after submission
                    modal2.style.display = 'none';
                    resetModalState();
                };
            </script>

            {* heres ends gcash try *}

            
            {csrf_token}

            {if $UploadsEnabled}
            {block name='attachments'}
            {/block}
            {/if}

            <div id="retrySubmitParams" class="d-none"></div>
        </form>
    </div>
</div>

<div class="modal fade" id="dialogResourceGroups" tabindex="-1" role="dialog" aria-labelledby="resourcesModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="resourcesModalLabel">{translate key=AddResources}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
            </div>
            <div class="modal-body">
                <div id="resourceGroups"></div>
            </div>
            <div class="modal-footer">
                <div id="checking-availability" class="float-start">{translate key=CheckingAvailability} <div
                        class="spinner-border spinner-border-sm" role="status"></div>
                </div>
                <div id="checking-availability-error" class="float-start no-show">
                    {translate key=CheckingAvailabilityError}</div>
                <button type="button" class="btn btn-outline-secondary btnClearAddResources"
                    data-bs-dismiss="modal">{translate key='Cancel'}</button>
                <button type="button" class="btn btn-primary btnConfirmAddResources">{translate key='Done'}</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="dialogAddAccessories" tabindex="-1" role="dialog" aria-labelledby="accessoryModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="accessoryModalLabel">{translate key=AddAccessories}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
            </div>
            <div class="modal-body">
                <table class="table table-sm">
                    <thead>
                        <tr>
                            <th>{translate key=Accessory}</th>
                            <th>{translate key=QuantityRequested}</th>
                            <th>{translate key=QuantityAvailable}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$AvailableAccessories item=accessory}
                        <tr accessory-id="{$accessory->GetId()}">
                            <td>{$accessory->GetName()}</td>
                            <td>
                                <input type="hidden" class="name" value="{$accessory->GetName()}" />
                                <input type="hidden" class="id" value="{$accessory->GetId()}" />
                                <input type="hidden" class="resource-ids"
                                    value="{$accessory->ResourceIds()|join:','}" />
                                <label for="accessory{$accessory->GetId()}"
                                    class="visually-hidden">{$accessory->GetName()}</label>
                                {if $accessory->GetQuantityAvailable() == 1}
                                <input class="form-check-input" type="checkbox" name="accessory{$accessory->GetId()}"
                                    id="accessory{$accessory->GetId()}" value="1" size="3" aria-label="checkbox" />
                                {else}
                                <input type="number" min="0" max="999"
                                    class="form-control form-control-sm accessory-quantity"
                                    name="accessory{$accessory->GetId()}" id="accessory{$accessory->GetId()}" value="0"
                                    size="3" />
                                {/if}
                            </td>
                            <td accessory-quantity-id="{$accessory->GetId()}"
                                accessory-quantity-available="{$accessory->GetQuantityAvailable()}">
                                {$accessory->GetQuantityAvailable()|default:'&infin;'}</td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>

            </div>
            <div class="modal-footer">
                {cancel_button}
                <button id="btnConfirmAddAccessories" type="button"
                    class="btn btn-primary">{translate key='Done'}</button>
            </div>
        </div>
    </div>
</div>


<div id="wait-box" class="modal fade" aria-labelledby="update-boxLabel" data-bs-backdrop="static" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body">
                <div id="creatingNotification" class="text-center">
                    <h3 id="createUpdateMessage" class="d-none">
                        {block name="ajaxMessage"}
                        {translate key=CreatingReservation}
                        {/block}
                    </h3>
                    <h3 id="checkingInMessage" class="d-none">
                        {translate key=CheckingIn}
                    </h3>
                    <h3 id="checkingOutMessage" class="d-none">
                        {translate key=CheckingOut}
                    </h3>
                    <h3 id="joiningWaitingList" class="d-none">
                        {translate key=AddingToWaitlist}
                    </h3>
                    <div class="spinner-border text-secondary" style="width: 3rem; height: 3rem;" role="status"></div>
                </div>
                <div id="result" class="text-center"></div>
            </div>
        </div>
    </div>
</div>

<div id="user-availability-box"></div>

</div>

{block name=extras}{/block}

{include file="javascript-includes.tpl"}

{control type="DatePickerSetupControl" ControlId="BeginDate" DefaultDate=$StartDate MinDate=$AvailabilityStart MaxDate=$AvailabilityEnd FirstDay=$FirstWeekday}
{control type="DatePickerSetupControl" ControlId="EndDate" DefaultDate=$EndDate MinDate=$AvailabilityStart MaxDate=$AvailabilityEnd FirstDay=$FirstWeekday}
{control type="DatePickerSetupControl" ControlId="EndRepeat" DefaultDate=$RepeatTerminationDate MinDate=$StartDate MaxDate=$AvailabilityEnd FirstDay=$FirstWeekday}
{control type="DatePickerSetupControl" ControlId="RepeatDate" MaxDate=$AvailabilityEnd FirstDay=$FirstWeekday MinDate=Date::Now()->ToTimezone($Timezone) Multiple=false}

{jsfile src="resourcePopup.js"}
{jsfile src="userPopup.js"}
{jsfile src="date-helper.js"}
{jsfile src="recurrence.js"}
{jsfile src="reservation.js"}
{jsfile src="autocomplete.js"}
{jsfile src="force-numeric.js"}
{jsfile src="reservation-reminder.js"}
{jsfile src="ajax-helpers.js"}
{jsfile src="reservation-pdf.js"}
{vendor_js src="jqtree/1.8.11/js/tree.jquery.js"}

{include file="Reservation/pdf_libraries.tpl"}
{include file="Reservation/pdf.tpl"}
<script type="text/javascript">
    $(function() {
        var scopeOptions = {
            instance: '{SeriesUpdateScope::ThisInstance}',
            full: '{SeriesUpdateScope::FullSeries}',
            future: '{SeriesUpdateScope::FutureInstances}'
        };

        var reservationOpts = {
            additionalResourceElementId: '{FormKeys::ADDITIONAL_RESOURCES}',
            accessoryListInputId: '{FormKeys::ACCESSORY_LIST}[]',
            returnUrl: '{$ReturnUrl}',
            scopeOpts: scopeOptions,
            createUrl: 'ajax/reservation_save.php',
            updateUrl: 'ajax/reservation_update.php',
            deleteUrl: 'ajax/reservation_delete.php',
            checkinUrl: 'ajax/reservation_checkin.php?action={ReservationAction::Checkin}',
            checkoutUrl: 'ajax/reservation_checkin.php?action={ReservationAction::Checkout}',
            waitlistUrl: 'ajax/reservation_waitlist.php',
            userAutocompleteUrl: "ajax/autocomplete.php?type={AutoCompleteType::User}",
            groupAutocompleteUrl: "ajax/autocomplete.php?type={AutoCompleteType::Group}",
            changeUserAutocompleteUrl: "ajax/autocomplete.php?type={AutoCompleteType::MyUsers}",
            maxConcurrentUploads: '{$MaxUploadCount}',
            guestLabel: '({translate key=Guest})',
            accessoriesUrl: 'ajax/available_accessories.php?{QueryStringKeys::START_DATE}=[sd]&{QueryStringKeys::END_DATE}=[ed]&{QueryStringKeys::START_TIME}=[st]&{QueryStringKeys::END_TIME}=[et]&{QueryStringKeys::REFERENCE_NUMBER}=[rn]',
            resourcesUrl: 'ajax/unavailable_resources.php?{QueryStringKeys::SCHEDULE_ID}={$ScheduleId}&{QueryStringKeys::START_DATE}=[sd]&{QueryStringKeys::END_DATE}=[ed]&{QueryStringKeys::START_TIME}=[st]&{QueryStringKeys::END_TIME}=[et]&{QueryStringKeys::REFERENCE_NUMBER}=[rn]',
            creditsUrl: 'ajax/reservation_credits.php',
            creditsEnabled: '{$CreditsEnabled}',
            emailUrl: 'ajax/reservation_email.php?{QueryStringKeys::REFERENCE_NUMBER}={$ReferenceNumber}',
            availabilityUrl: 'ajax/availability.php?{QueryStringKeys::SCHEDULE_ID}={$ScheduleId}',
            maximumResources: {$MaximumResources|default:0}
        };

        var reminderOpts = {
            reminderTimeStart: '{$ReminderTimeStart}',
            reminderTimeEnd: '{$ReminderTimeEnd}',
            reminderIntervalStart: '{$ReminderIntervalStart}',
            reminderIntervalEnd: '{$ReminderIntervalEnd}'
        };

        var reservation = new Reservation(reservationOpts);
        reservation.init('{$UserId}', '{format_date date=$StartDate key=system_datetime timezone=$Timezone}', '{format_date date=$EndDate key=system_datetime timezone=$Timezone}');

        var reminders = new Reminder(reminderOpts);
        reminders.init();

        {foreach from=$Participants item=user}
        reservation.addParticipant("{$user->FullName|escape:'javascript'}", "{$user->UserId|escape:'javascript'}");
        {/foreach}

        {foreach from=$Invitees item=user}
        reservation.addInvitee("{$user->FullName|escape:'javascript'}", '{$user->UserId}');
        {/foreach}

        {foreach from=$ParticipatingGuests item=guest}
        reservation.addParticipatingGuest('{$guest}');
        {/foreach}

        {foreach from=$InvitedGuests item=guest}
        reservation.addInvitedGuest('{$guest}');
        {/foreach}

        {foreach from=$Accessories item=accessory}
        reservation.addAccessory({$accessory->AccessoryId}, {$accessory->QuantityReserved}, "{$accessory->Name|escape:'javascript'}");
        {/foreach}

        reservation.addResourceGroups({$ResourceGroupsAsJson});

        var recurOpts = {
            repeatType: '{$RepeatType}',
            repeatInterval: '{$RepeatInterval}',
            repeatMonthlyType: '{$RepeatMonthlyType}',
            repeatWeekdays: [{foreach from=$RepeatWeekdays item=day}{$day}, {/foreach}],
            autoSetTerminationDate: $('#referenceNumber').val() != '',
            customRepeatExclusions: ['{formatdate date=$StartDate key=system}']
        };

        var recurrence = new Recurrence(recurOpts);
        recurrence.init();

        recurrence.onChange(reservation.repeatOptionsChanged);

        {foreach from=$CustomRepeatDates item=date}
        recurrence.addCustomDate('{format_date date=$date key=system timezone=$Timezone}',
        '{format_date date=$date key=schedule_daily timezone=$Timezone}');
        {/foreach}

        var ajaxOptions = {
            target: '#result', // target element(s) to be updated with server response
            beforeSubmit: reservation.preSubmit, // pre-submit callback
            success: reservation.showResponse // post-submit callback
        };

        $('#form-reservation').submit(function() {
            $(this).ajaxSubmit(ajaxOptions);
            return false;
        });

        $('#userName').bindUserDetails();

        translateTooltips();

    });
    $('.modal').on('shown.bs.modal', function() {
        $(this).find('[autofocus]').focus();
    });
</script>

<script>
    function translateTooltips() {
        var resourcesContainer = document.querySelector('#reservation-resources');
        var resources = [].slice.call(resourcesContainer.querySelectorAll('[data-bs-toggle="tooltip"]'));
        resources.forEach(function(resource) {
            var tooltipType = resource.getAttribute('data-bs-title');
            if (tooltipType === 'approval') {
                var tooltipText = "{translate key=RequiresApproval}";
            }
            if (tooltipType === 'checkin') {
                var tooltipText ="{translate key=RequiresCheckInNotification}";
            }
            if (tooltipType === 'autorelease') {
                var text = "{translate key=AutoReleaseNotification args='%s'}";
                    var tooltipText = text.replace('%s', resource.getAttribute('data-autorelease'));
                }
                resource.setAttribute('data-bs-title', tooltipText);
                new bootstrap.Tooltip(resource);
            });
        }
    </script>

    {include file='globalfooter.tpl'}
